from youtube_transcript_api import YouTubeTranscriptApi as yta
import re
from pprint import pprint
import numpy

def print_time(search_word,time):
    print(f"'{search_word}' was mentioned at:")
    # calculate the accurate time according to the video's duration
    for t in time:
        hours = int(t // 3600)
        min = int((t // 60) % 60)
        sec = int(t % 60)
        print(f"{hours:02d}:{min:02d}:{sec:02d}")


video_id = "86Gy035z_KA"
transcript = yta.get_transcript(video_id, languages=('en', 'English')) 
data = [t['text'] for t in transcript]
data = [re.sub(r"[^a-zA-Z0–9-ışğöüçiIŞĞÖÜÇİ ]", "", line) for line in data]
search_word = "Facebook"
time = []
#pprint(transcript)
text = numpy.array([dictionary["text"] for dictionary in transcript])
pprint(list(text))
print(type(transcript))

