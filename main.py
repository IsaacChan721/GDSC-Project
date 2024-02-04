PROJECT_ID = "vital-domain-412522"
REGION = "us-central1"

import vertexai
from vertexai.preview.generative_models import GenerativeModel, Part
import webbrowser
from googleapiclient.discovery import build
from settings import API_KEY
from pprint import pprint
from youtube_transcript_api import YouTubeTranscriptApi as yta
from youtube_transcript_api._transcripts import TranscriptListFetcher
from youtube_transcript_api._errors import TranscriptsDisabled, NoTranscriptAvailable, NoTranscriptFound
import re
import numpy as np
import requests

MAX_DURATION = 1200
MIN_VIEW_COUNT = 100000

def generate_text(project_id: str, location: str, user_input, teach="") -> str:
    # Initialize Vertex AI
    vertexai.init(project=project_id, location=location)
    # Load the model
    multimodal_model = GenerativeModel("gemini-pro")
    # Query the model
    response = multimodal_model.generate_content(
        [teach + user_input]
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
        if duration_parts[i] == '':
            duration_parts[i] = 0
        duration_seconds += int(duration_parts[i]) * (60 ** (len(duration_parts) - i - 1))
    return duration_seconds

def get_video_view_count(video):
    return int(video["items"][0]["statistics"]["viewCount"])

def has_transcript(video_id):
    t = TranscriptListFetcher(requests.Session())
    try:
        t._extract_captions_json(t._fetch_video_html(video_id), video_id)
    except (TranscriptsDisabled, NoTranscriptAvailable, NoTranscriptFound):
        #print("No transcripts")
        return False
    return True

def get_video_transcript(video_id):
    transcript = yta.get_transcript(video_id, languages=['en', 'en-US']) 
    text = np.array([dictionary["text"] for dictionary in transcript])
    time = np.array([dictionary["start"] for dictionary in transcript])

    merged_text = []
    temp_text = ""
    merged_time = [0]

    for i in range(0, len(text)):
        if i % 5 == 0 and i != 0:
            merged_text.append(temp_text)
            merged_time.append(round(time[i], 3))
            temp_text = text[i]
        else:
            temp_text += (" " + text[i])
    merged_text.append(temp_text)
    return merged_text, merged_time
   
user_input = input("Give me something to work with?: ")
teach = "Create a list in python format of words containing the 5 most prominent key words using the following string: "

print("Contextualizing Data...")
results = generate_text(PROJECT_ID, REGION, user_input)
context = generate_text(PROJECT_ID, REGION, results, teach)

context = string_to_list(context)

print("Searching for Videos...")

youtube = build('youtube', 'v3', developerKey=API_KEY)

response = youtube.search().list(
    q=context,
    part='id,snippet',
    maxResults=5
).execute()

video_ids = [item['id']['videoId'] for item in response['items'] if item['id']['kind'] == 'youtube#video']

video_urls = []

print("Fetching Video Data...")
texts, timestamps = [],[]
for video_id in video_ids:
    print(video_id)
    video = get_video(video_id, API_KEY)
    duration_seconds = get_video_duration(video)
    view_count = get_video_view_count(video)
    if duration_seconds <= MAX_DURATION and view_count >= MIN_VIEW_COUNT and has_transcript(video_id):
        print("good vid")
        text, timestamp = get_video_transcript(video_id)
        video_url = f"https://www.youtube.com/watch?v={video_id}"
        video_urls.append(video_url)
        texts.append(text)
        timestamps.append(timestamp)
    else:
        print("bad vid")


teach = "Take the following data, time and text respectively, and identify the important most relevant time intervals in the video: "
time_intervals = []
for i in range(len(video_urls)):
    time_intervals.append(generate_text(PROJECT_ID, REGION, str(np.array((timestamps[i], texts[i]))), teach))

pprint(time_intervals)

teach = "Find the video/s and time interval/s mentioned in the response given in the following format: Video num: Time interval start-end, For example: 'Video 2: Time interval 5-10'"

while True:
    try:
        #video_time_string = (generate_text(PROJECT_ID, REGION, input("Which video/s and time interval/s would you like to watch?: "), teach))
        # video_time_list = video_time_string.split(', ')
        video_time_string = input("Which video/s and time interval/s would you like to watch? (format: Video num: Time interval start-end): ")
        result_list = []
        print(video_time_string)
        video_info = video_time_string.split(': ')
        print(video_info)
        video_number_str = video_info[0].replace('Video ', '')
        time_interval_str = video_info[1].replace('Time interval ', '')
        print("aaa")
 
        try:
            # Try to convert the video number to an integer
            vid_num = int(video_number_str)
            print("bbb")
        except ValueError:
            print(f"Error: Invalid video number format - {video_number_str}")
            continue

        # Split the time interval string and convert to integers
        time_interval = time_interval_str.split('-')
        try:
            start_time = int(time_interval[0])
            end_time = int(time_interval[1])
            print("ccc")
        except (ValueError, IndexError):
            print(f"Error: Invalid time interval format - {time_interval_str}")
            continue

        # Add to the result list
        result_list = [vid_num-1, [start_time, end_time]]

    except Exception as e:
        print(e)
        print("Sorry, I'm not sure I understand. Maybe be more specific (Preferably in the format of 'Video 1: Time interval 1-10').")
    else:
        break

print(result_list)
final_list = []
url = video_urls[result_list[0]] + "&t=" + str(result_list[1][0])
end = result_list[1][1]
final_list.append([url, end])
print(final_list)
