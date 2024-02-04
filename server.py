from flask import Flask, jsonify, request
from flask_cors import CORS
from ast import literal_eval
from main import get_video_ids



app = Flask(__name__)
CORS(app)

last_video_ids = []

@app.route('/data', methods=['GET'])
def get():
    global last_video_ids
    # data = [
    #     {'word': 'cat', 'type': 'animal'},
    #     {'word': 'football', 'type': 'sports'},
    #     {'word': 'rice', 'type': 'food'},
    # ]
    print('rah')
    print(last_video_ids)
    return jsonify(last_video_ids)

@app.route('/send', methods=['POST'])
def post():
    global last_video_ids
    if request.method == "POST":
        if request.data:
            data = request.data
            data = literal_eval(data.decode('utf8'))
            prompt = data['prompt']
            last_video_ids = get_video_ids(prompt)
            request.get_json()


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080)