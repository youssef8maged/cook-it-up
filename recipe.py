from flask import Flask, jsonify, request
import pandas as pd
from ast import literal_eval
from flask_cors import CORS
import logging

app = Flask(__name__)
CORS(app)

# Configure logging
logging.basicConfig(level=logging.DEBUG)

# Load data
recipes_df = pd.read_csv("RAW_recipes.csv")
reviews_df = pd.read_csv("RAW_interactions.csv")

# Renaming ID -> Recipe_ID
recipes_df = recipes_df.rename(columns={'id': 'recipe_id'})

# Nutrition values are evaluated as expression
recipes_df['nutrition'] = recipes_df['nutrition'].apply(eval)

# Distributing Values of Nutrition List to 7 New Detailed Columns
nutrition_columns = ['calories', 'total fat (PDV)', 'sugar (PDV)', 'sodium (PDV)', 'protein (PDV)', 'saturated fat (PDV)', 'carbohydrates (PDV)']
recipes_df[nutrition_columns] = pd.DataFrame(recipes_df['nutrition'].tolist(), index=recipes_df.index)

# Removing Nutrition Column
recipes_df = recipes_df.drop(['nutrition'], axis=1)

# Dropping Duplicates
recipes_df = recipes_df.drop_duplicates()

recipes_df_filtered = recipes_df.copy()

# Removing any rows where calories, minutes, n_ingredients, and n_steps are 0
recipes_df_filtered = recipes_df_filtered[(recipes_df_filtered['calories'] != 0) &
                                          (recipes_df_filtered['minutes'] != 0) &
                                          (recipes_df_filtered['n_steps'] != 0)]

# Removing the rows where all nutritional values are 0 simultaneously
recipes_df_filtered = recipes_df_filtered[(recipes_df_filtered[nutrition_columns] != 0).any(axis=1)]

# Finding the numerical columns
numerical_columns = recipes_df.select_dtypes(include=['number']).drop(['recipe_id', 'contributor_id'], axis=1).columns.tolist()

# Calculating the 25th and 75th percentiles of all numerical columns to compute the IQR
Q1 = recipes_df_filtered[numerical_columns].quantile(0.25)
Q3 = recipes_df_filtered[numerical_columns].quantile(0.75)

# Calculating IQR for each column
IQR = Q3 - Q1

# Defining the upper limit as 1.5 times the IQR above Q3
upper_limit = Q3 + 1.5 * IQR

# Filtering out recipes with values above the upper limit for outlier handling
for col in numerical_columns:
    recipes_df_filtered = recipes_df_filtered[~(recipes_df_filtered[col] > upper_limit[col])]

# Removing rows where rating is 0 (no rating)
reviews_df_filtered = reviews_df[reviews_df['rating'] != 0]

# Process Data for Knowledge-Based Filtering
# Joining Pre-Processed Data with corresponding Review Data
merged_df = pd.merge(recipes_df_filtered, reviews_df_filtered, on='recipe_id', how='inner')

# Aggregating Ratings for each Recipe
agg_ratings_byrecipe = merged_df.groupby('recipe_id').agg(mean_rating=('rating', 'mean'),
                                                          number_of_ratings=('rating', 'count')).reset_index()

# Adding the average rating and number of rating to the filtered recipe data
KB_df = pd.merge(recipes_df_filtered, agg_ratings_byrecipe, on='recipe_id', how='inner')

# Converting all NaN to empty lists
KB_df['ingredients'] = KB_df['ingredients'].fillna('[]')

# Convert empty list string to object
KB_df['ingredients'] = KB_df['ingredients'].apply(literal_eval)

# Converting list to lowercase
KB_df['ingredients'] = KB_df['ingredients'].apply(lambda x: [ingredient.lower() for ingredient in x] if isinstance(x, list) else [])

# Creating new feature
s = KB_df.apply(lambda x: pd.Series(x['ingredients']), axis=1).stack().reset_index(level=1, drop=True)

# Renaming 'name' to 'ingredient'
s.name = 'ingredient'

# Joining s into KB_df
KB_df = KB_df.join(s)

#Counting the number of ratings for each recipe
recipes_numberofratings = reviews_df_filtered['recipe_id'].value_counts()

#Filtering Recipes with 20+ ratings
popular_recipes = recipes_numberofratings[recipes_numberofratings >= 20].index.tolist()
#Counting the number of recipes rated by each user
users_numberofratings = reviews_df_filtered['user_id'].value_counts()

#Filtering Recipes with 20+ ratings
active_users = users_numberofratings[users_numberofratings >= 20].index.tolist()

#Only keeping observations where the recipe has 20+ rating and the user has rated 20+ recipes
reviews_df_filteredforCF = reviews_df_filtered[reviews_df_filtered['recipe_id'].isin(popular_recipes) &
                                reviews_df_filtered['user_id'].isin(active_users)]

#Joining recipes_df_filtered and reviews_df_filteredforCF
CF_df = pd.merge(recipes_df_filtered, reviews_df_filteredforCF, on = 'recipe_id', how = 'inner')

#Joining agg_ratings_byrecipe so the dataset includes mean rating and number of rating per recipe
CF_df = pd.merge(CF_df, agg_ratings_byrecipe, on = 'recipe_id', how = 'inner')


#Using the same recipes from the collaborative filtering dataset, but removing the reviews/ratings related data
CB_df = CF_df.drop(['user_id','date','rating','review'], axis = 1).drop_duplicates()

def knowledge_based(KB_df, preferred_ingredients=None, include_all_ingredients=False, max_time=None, max_calories=None, preference=None, percentile=0.8):
    if preferred_ingredients:
        matching_recipes = filter_recipes_by_ingredients(KB_df, preferred_ingredients, include_all_ingredients)
    else:
        matching_recipes = KB_df.copy()

    recipes = apply_filters(matching_recipes, max_time, max_calories)

    if preference == '7':
        # For nutritional preferences, the specific nutritional preferences would be required
        recommendations = calculate_and_sort_scores(recipes, KB_df['number_of_ratings'].quantile(percentile), percentile, preference)
    else:
        recommendations = calculate_and_sort_scores(recipes, KB_df['number_of_ratings'].quantile(percentile), percentile, preference)

    if not recommendations.empty:
        recommendations = recommendations.drop_duplicates(subset=['recipe_id']).copy()
        return recommendations.to_dict('records')
    else:
        return []

def filter_recipes_by_ingredients(KB_df, preferred_ingredients, include_all_ingredients):
    if include_all_ingredients:
        matching_recipes = KB_df[KB_df['ingredients'].apply(
            lambda x: set(preferred_ingredients).issubset(set(map(str.strip, x)))
        )]
    else:
        matching_recipes = KB_df[KB_df['ingredients'].apply(
            lambda x: any(ingredient in set(map(str.strip, x)) for ingredient in preferred_ingredients)
        )]
    return matching_recipes

def apply_filters(KB_df, max_time=None, max_calories=None):
    if max_time:
        KB_df = KB_df[KB_df['minutes'] <= int(max_time)]
    if max_calories:
        KB_df = KB_df[KB_df['calories'] <= int(max_calories)]
    return KB_df

def calculate_and_sort_scores(KB_df, m, percentile, preference, nutritional_preferences=None):
    C = KB_df['mean_rating'].mean()
    q_recipes = KB_df.loc[KB_df['number_of_ratings'] >= m]
    if not q_recipes.empty:
        q_recipes = q_recipes.copy()
        q_recipes['score'] = q_recipes.apply(lambda x: calculate_score(x, C, m, preference, nutritional_preferences), axis=1)
        q_recipes = q_recipes.sort_values('score', ascending=False)
        return q_recipes
    else:
        return pd.DataFrame()

def calculate_score(recipe, C, m, preference, nutritional_preferences=None):
    if preference == '1':
        return -recipe['n_steps'] + (recipe['number_of_ratings'] / (recipe['number_of_ratings'] + m) * recipe['mean_rating']) + (m / (m + recipe['number_of_ratings']) * C)
    elif preference == '2':
        return -recipe['n_ingredients'] + (recipe['number_of_ratings'] / (recipe['number_of_ratings'] + m) * recipe['mean_rating']) + (m / (m + recipe['number_of_ratings']) * C)
    elif preference == '3':
        return -recipe['minutes'] + (recipe['number_of_ratings'] / (recipe['number_of_ratings'] + m) * recipe['mean_rating']) + (m / (m + recipe['number_of_ratings']) * C)
    elif preference == '4':
        return (recipe['number_of_ratings'] / (recipe['number_of_ratings'] + m) * recipe['mean_rating']) + (m / (m + recipe['number_of_ratings']) * C)
    elif preference == '5':
        return -recipe['calories'] + (recipe['number_of_ratings'] / (recipe['number_of_ratings'] + m) * recipe['mean_rating']) + (m / (m + recipe['number_of_ratings']) * C)
    elif preference == '6':
        return recipe['calories'] + (recipe['number_of_ratings'] / (recipe['number_of_ratings'] + m) * recipe['mean_rating']) + (m / (m + recipe['number_of_ratings']) * C)
    elif preference == '7':
        return calculate_nutritional_score(recipe, C, m, nutritional_preferences)
    else:
        return 0

def calculate_nutritional_score(recipe, C, m, nutritional_preferences):
    score = 0
    for pref in nutritional_preferences:
        nutrient, condition = [part.strip() for part in pref.split('(')]
        condition = condition[:-1]
        column_name = f"{nutrient} (PDV)"
        if column_name in recipe.index:
            if condition == 'low':
                score += -recipe[column_name] + (recipe['number_of_ratings'] / (recipe['number_of_ratings'] + m) * recipe['mean_rating']) + (m / (m + recipe['number_of_ratings']) * C)
            elif condition == 'high':
                score += recipe[column_name] + (recipe['number_of_ratings'] / (recipe['number_of_ratings'] + m) * recipe['mean_rating']) + (m / (m + recipe['number_of_ratings']) * C)
    return score

@app.route('/recommendations', methods=['GET', 'POST'])
def get_recommendations():
  if request.method == 'GET':
    # Handle GET request (limited functionality)
    logging.debug("Received GET request for recommendations")
    # You can optionally return some basic recommendations here
    # For example, most popular recipes
    return jsonify({"message": "Use POST request to provide preferences for personalized recommendations"})
  elif request.method == 'POST':
    # Handle POST request with user preferences
    user_preferences = request.json
    logging.debug(f"Received user preferences: {user_preferences}")
    preferred_ingredients = user_preferences.get('preferred_ingredients', [])
    max_time = user_preferences.get('max_time')
    max_calories = user_preferences.get('max_calories')
    preference = user_preferences.get('preference')
    number_of_recommendations = user_preferences.get('number_of_recommendations', 2)  # Default to 2

    recommendations = knowledge_based(KB_df, preferred_ingredients, False, max_time, max_calories, preference)

    # Limit recommendations based on user input
    recommendations = recommendations[:number_of_recommendations]

    logging.debug(f"Generated recommendations: {recommendations}")
    return jsonify(recommendations)
  else:
    # Handle unsupported methods
    return jsonify({"error": "Unsupported request method"}), 405

if __name__ == '__main__':
  logging.basicConfig(level=logging.DEBUG)
  app.run(debug=True,host= '0.0.0.0',port= 5001)
