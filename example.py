import webbrowser
from googleapiclient.discovery import build
from settings import API_KEY

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
    video_url = f"https://www.youtube.com/watch?v={video_id}"
    video_urls.append(video_url)

# Open each video URL in a web browser
for url in video_urls:
    webbrowser.open(url)
