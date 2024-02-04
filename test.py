from youtube_transcript_api import YouTubeTranscriptApi as yta
import re
import numpy

video_id = "86Gy035z_KA"
transcript = yta.get_transcript(video_id, languages=('en', 'English')) 
text = numpy.array([dictionary["text"] for dictionary in transcript])
time = numpy.array([dictionary["start"] for dictionary in transcript])
duration = numpy.array([dictionary["duration"] for dictionary in transcript])

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
print(merged_text)
print(merged_time)


