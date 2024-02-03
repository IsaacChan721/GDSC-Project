from googleapiclient.discovery import build
from pprint import pprint
from settings import API_KEY

youtube = build('youtube', 'v3', developerKey=API_KEY)

request = youtube.search().list(
    part="snippet",
    channelType="any",
    maxResults=25,
    order="relevance",
    q="chemistry|stoichiometry",
    relevanceLanguage="en",
    safeSearch="moderate",
    type="video"
)
response = request.execute()

pprint(response)
