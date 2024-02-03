import webbrowser
from googleapiclient.discovery import build
from settings import API_KEY

# Function to get video duration in seconds
def get_video_duration(video_id, api_key):
    youtube = build('youtube', 'v3', developerKey=api_key)
    response = youtube.videos().list(
        part='contentDetails',
        id=video_id
    ).execute()
    duration = response['items'][0]['contentDetails']['duration']
    duration = duration.replace('PT', '').replace('S', '').replace('M', ':').replace('H', ':')
    duration_parts = duration.split(':')
    duration_seconds = 0
    for i in range(len(duration_parts)):
        duration_seconds += int(duration_parts[i]) * (60 ** (len(duration_parts) - i - 1))
    return duration_seconds

# Build the YouTube API client
youtube = build('youtube', 'v3', developerKey=API_KEY)

# Example API call without specifying video duration
response = youtube.search().list(
    q='stoichiometry examples',
    part='id,snippet',
    maxResults=10
).execute()

# Extract video IDs
video_ids = [item['id']['videoId'] for item in response['items'] if item['id']['kind'] == 'youtube#video']

# Extract video URLs and durations
video_urls = []
for video_id in video_ids:
    duration_seconds = get_video_duration(video_id, API_KEY)
    # If video duration is less than or equal to 5 minutes (300 seconds), consider it
    if duration_seconds <= 300:
        video_url = f"https://www.youtube.com/watch?v={video_id}"
        video_urls.append(video_url)

# Open each video URL in a web browser
for url in video_urls:
    webbrowser.open(url)
