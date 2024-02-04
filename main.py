PROJECT_ID = "vital-domain-412522"
REGION = "us-central1"

import vertexai
from vertexai.preview.generative_models import GenerativeModel, Part
import webbrowser
from googleapiclient.discovery import build
from settings import API_KEY
from pprint import pprint
from youtube_transcript_api import YouTubeTranscriptApi as yta
import re
import numpy

MAX_DURATION = 1200
MIN_VIEW_COUNT = 100000


def generate_text(project_id: str, location: str, user_input, simplify = False) -> str:
    # Initialize Vertex AI
    vertexai.init(project=project_id, location=location)
    # Load the model
    multimodal_model = GenerativeModel("gemini-pro")
    # Query the model
    response = multimodal_model.generate_content(
        [
            user_input if not simplify
            else "Create a list in python format of words containing the 5 most prominent key words using the following string: " + user_input
        ]
    )
    return response.text

def string_to_list(context:str):
    list = []
    first_pointer = -1
    for i in range(len(context)):
        if context[i] == "'" or context[i] == '"':
            pointer = i
            if first_pointer == -1:
                first_pointer = pointer
            else: 
                list.append(context[first_pointer+1:pointer])
                first_pointer = -1
    return list

def get_video(video_id, api_key):
    youtube = build('youtube', 'v3', developerKey=api_key)
    response = youtube.videos().list(
        part='contentDetails,statistics,snippet',
        id=video_id
    ).execute()
    return response

def get_video_duration(video):
    duration = video['items'][0]['contentDetails']['duration']
    duration = duration.replace('PT', '').replace('S', '').replace('M', ':').replace('H', ':')
    duration_parts = duration.split(':')
    duration_seconds = 0
    for i in range(len(duration_parts)):
        duration_seconds += int(duration_parts[i]) * (60 ** (len(duration_parts) - i - 1))
    return duration_seconds

def get_video_view_count(video):
    return int(video["items"][0]["statistics"]["viewCount"])

def get_video_transcript(video_id):
    transcript = yta.get_transcript(video_id, languages=('en', 'English')) 
    text = numpy.array([dictionary["text"] for dictionary in transcript])
    time = numpy.array([dictionary["start"] for dictionary in transcript])

    merged_text = []
    temp_text = ""
    merged_time = [0]

    for i in range (0, len(text)):
        if i % 5 == 0 and i != 0:
            merged_text.append(temp_text)
            merged_time.append(round(time[i], 3))
            temp_text = text[i]
        else:
            temp_text += (" " + text[i])
    merged_text.append(temp_text)
    return merged_text, merged_time

#def main():
user_input = input("Give me something to work with?: ")
results = generate_text(PROJECT_ID, REGION, user_input)
context = generate_text(PROJECT_ID, REGION, results)

context = string_to_list(context)
print(context)

youtube = build('youtube', 'v3', developerKey=API_KEY)

response = youtube.search().list(
    q= context,
    part='id,snippet',
    maxResults=5
).execute()

video_ids = [item['id']['videoId'] for item in response['items'] if item['id']['kind'] == 'youtube#video']

video_urls = []
for video_id in video_ids:
    print(video_id)
    video  = get_video(video_id, API_KEY)
    duration_seconds = get_video_duration(video)
    view_count = get_video_view_count(video)

    if duration_seconds <= MAX_DURATION and view_count >= MIN_VIEW_COUNT:
        print("good vid")
        text, timestamp = get_video_transcript(video_id)
        print(text)
        video_url = f"https://www.youtube.com/watch?v={video_id}"
        video_urls.append(video_url)
print("video count:", len(video_urls))

#return video_urls