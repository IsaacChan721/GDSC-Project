import webbrowser
from googleapiclient.discovery import build
from settings import API_KEY
from pprint import pprint

# Build the YouTube API client
youtube = build('youtube', 'v3', developerKey=API_KEY)

# Example API call
response = youtube.search().list(
    part="snippet",
    channelType="any",
    maxResults=10,
    order="relevance",
    q="chemistry|stoichiometry",
    relevanceLanguage="en",
    safeSearch="moderate",
    type="video"
).execute()

# Extract video IDs and construct video URLs
video_urls = []
for item in response['items']:
    video_id = item['id']['videoId']
    vid = youtube.videos().list(
        part = "statistics",
        id = video_id
    ).execute()
    if int(vid["items"][0]["statistics"]["viewCount"]) > 1000000:        
        pprint(vid)
        video_url = f"https://www.youtube.com/watch?v={video_id}"
        video_urls.append(video_url)

# Open each video URL in a web browser
for url in video_urls:
    print(url)
    #webbrowser.open(url)
