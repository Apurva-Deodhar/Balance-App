from flask import Flask, request, jsonify
from flask_cors import CORS
from transformers import AutoModelForCausalLM, AutoTokenizer
import torch

app = Flask(__name__)
CORS(app)

# Load your fine-tuned model and tokenizer once when app starts
model_path = "./my_finetuned_model"  # adjust path if needed
print("Loading model and tokenizer...")
tokenizer = AutoTokenizer.from_pretrained(model_path)
model = AutoModelForCausalLM.from_pretrained(model_path)
model.eval()  # set model to evaluation mode
print("Model loaded!")

@app.route('/')
def home():
    return "<h1>Chatbot is running!</h1><p>Use POST /chat to send messages.</p><p>Use GET /health to check status.</p>"

@app.route('/health')
def health():
    return jsonify({"status": "healthy", "message": "Server is running"})

@app.route('/chat', methods=['POST'])
def chat():
    data = request.get_json()
    if not data or 'message' not in data:
        return jsonify({"response": "Error: No message provided."}), 400

    user_message = data['message']

    try:
        # Encode the user input with EOS token
        new_user_input_ids = tokenizer.encode(user_message + tokenizer.eos_token, return_tensors='pt')

        # Generate a response from the model
        output_ids = model.generate(
            new_user_input_ids,
            max_length=1000,
            pad_token_id=tokenizer.eos_token_id,
            do_sample=True,
            top_k=50,
            top_p=0.92,
            temperature=0.85,
            num_return_sequences=1
        )

        # Decode the output, skipping the user input tokens
        bot_response = tokenizer.decode(output_ids[:, new_user_input_ids.shape[-1]:][0], skip_special_tokens=True)

    except Exception as e:
        print(f"Error during model inference: {e}")
        return jsonify({"response": "Sorry, something went wrong while generating a response."}), 500

    return jsonify({"response": bot_response})

if __name__ == '__main__':
    print("Starting Flask app...")
    app.run(debug=True, host='0.0.0.0', port=5000)