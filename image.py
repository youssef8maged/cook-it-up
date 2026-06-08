from flask import Flask, request, jsonify
from torchvision import transforms 
from PIL import Image
import torch
import os

# Define your recipe label mapping based on provided labels
label_map = {
    0: "Apple pie",
    1: "Baby back ribs",
    2: "Baklava",
    3: "Beef carpaccio",
    4: "Beef tartare",
    5: "Beet salad",
    6: "Beignets",
    7: "Bibimbap",
    8: "Bread pudding",
    9: "Breakfast burrito",
    10: "Bruschetta",
    11: "Caesar salad",
    12: "Cannoli",
    13: "Caprese salad",
    14: "Carrot cake",
    15: "Ceviche",
    16: "Cheesecake",
    17: "Cheese plate",
    18: "Chicken curry",
    19: "Chicken quesadilla",
    20: "Chicken wings",
    21: "Chocolate cake",
    22: "Chocolate mousse",
    23: "Churros",
    24: "Clam chowder",
    25: "Club sandwich",
    26: "Crab cakes",
    27: "Creme brulee",
    28: "Croque madame",
    29: "Cup cakes",
    30: "Deviled eggs",
    31: "Donuts",
    32: "Dumplings",
    33: "Edamame",
    34: "Eggs benedict",
    35: "Escargots",
    36: "Falafel",
    37: "Filet mignon",
    38: "Fish and chips",
    39: "Foie gras",
    40: "French fries",
    41: "French onion soup",
    42: "French toast",
    43: "Fried calamari",
    44: "Fried rice",
    45: "Frozen yogurt",
    46: "Garlic bread",
    47: "Gnocchi",
    48: "Greek salad",
    49: "Grilled cheese sandwich",
    50: "Grilled salmon",
    51: "Guacamole",
    52: "Gyoza",
    53: "Hamburger",
    54: "Hot and sour soup",
    55: "Hot dog",
    56: "Huevos rancheros",
    57: "Hummus",
    58: "Ice cream",
    59: "Lasagna",
    60: "Lobster bisque",
    61: "Lobster roll sandwich",
    62: "Macaroni and cheese",
    63: "Macarons",
    64: "Miso soup",
    65: "Mussels",
    66: "Nachos",
    67: "Omelette",
    68: "Onion rings",
    69: "Oysters",
    70: "Pad thai",
    71: "Paella",
    72: "Pancakes",
    73: "Panna cotta",
    74: "Peking duck",
    75: "Pho",
    76: "Pizza",
    77: "Pork chop",
    78: "Poutine",
    79: "Prime rib",
    80: "Pulled pork sandwich",
    81: "Ramen",
    82: "Ravioli",
    83: "Red velvet cake",
    84: "Risotto",
    85: "Samosa",
    86: "Sashimi",
    87: "Scallops",
    88: "Seaweed salad",
    89: "Shrimp and grits",
    90: "Spaghetti bolognese",
    91: "Spaghetti carbonara",
    92: "Spring rolls",
    93: "Steak",
    94: "Strawberry shortcake",
    95: "Sushi",
    96: "Tacos",
    97: "Takoyaki",
    98: "Tiramisu",
    99: "Tuna tartare",
    100: "Waffles",
}

# Load your model
try:
    model = torch.jit.load('models/traced_model.pt', map_location=torch.device('cpu'))
    model.eval()  # Ensure the model is in evaluation mode
    print("Model loaded successfully")
except Exception as e:
    print(f"Error loading model: {e}")

app = Flask(__name__)

def preprocess(image):
    transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
    ])
    image_tensor = transform(image).unsqueeze(0)
    return image_tensor

CONFIDENCE_THRESHOLD = 0.3 # Example threshold value

def process_output(output):
    probabilities = torch.softmax(output, dim=1)
    max_prob, predicted = torch.max(probabilities, 1)
    
    if max_prob >= CONFIDENCE_THRESHOLD:
        return int(predicted.item())
    else:
        return -1  # Return a sentinel value for unknown or non-food items

def process_image(image_path):
    # Open the image file
    image = Image.open(image_path)
    # Perform necessary preprocessing steps here (resize, normalization, etc.)
    image_tensor = preprocess(image)
    # Get model prediction
    with torch.no_grad():
        output = model(image_tensor)
    # Process the output and convert it to a string
    predicted_label = process_output(output)
    
    if predicted_label != -1:
        result = label_map.get(predicted_label, "Unknown")  # Get the corresponding recipe name
    else:
        result = "Unknown"  # Handle unknown or non-food items
    
    return result

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    
    # Ensure the directory exists before saving the file
    upload_dir = '/mnt/data'
    os.makedirs(upload_dir, exist_ok=True)

    file_path = os.path.join(upload_dir, file.filename)
    file.save(file_path)
    result = process_image(file_path)
    return jsonify({'result': result})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
