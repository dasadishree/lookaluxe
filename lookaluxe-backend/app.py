from flask import Flask, request, jsonify
from PIL import Image
import io
import tensorflow as tf
import numpy as np

import requests
import os
from tensorflow.keras.applications.mobilenet_v2 import MobileNetV2, preprocess_input, decode_predictions

model = MobileNetV2(weights='imagenet')
app = Flask(__name__)

@app.route("/upload", methods=["POST"])
def upload_image():
    if 'image' not in request.files:
        return jsonify({'error': 'No image uploaded'}), 400
    
    file = request.files['image']
    image = Image.open(file.stream)

    image = image.resize((224, 224))
    image_array = np.array(image)
    image_batch = np.expand_dims(image_array, axis=0)
    image_preprocessed = preprocess_input(image_batch)
    predictions = model.predict(image_preprocessed)
    decoded = decode_predictions(predictions, top=3)[0]
    item_detected = decoded[0][1]
    confidence = float(decoded[0][2])

    search_query = f"cheap {item_detected}"
    SERP_API_KEY = "7f5c5673e10927c9bb7f36a0290b12c9370af70dda4af400740717471a42d8f2"

    params = {
        "engine": "google_shopping",
        "q": search_query,
        "api_key": SERP_API_KEY
    }

    response = requests.get("https://serpapi.com/search", params=params)
    data = response.json()

    results = []
    for item in data.get("shopping_results", [])[:3]:
        results.append({
            "name": item.get("title"),
            "price": item.get("price"),
            "link": item.get("link") or item.get("product_link")
        })

    return jsonify({
        'item_detected': item_detected,
        'confidence': confidence,
        'results': results
    })

if __name__ == "__main__":
    app.run(debug=True)