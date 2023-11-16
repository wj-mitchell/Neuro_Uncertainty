#!/bin/python

# Specifying our libraries
import ffmpeg
import os
import sys
import whisper

# Whisper model imported
model = whisper.load_model("base")
print("Whisper model imported ...")

# Audio Transcription
audio = str(sys.argv[1])
print("Processing audio from path:" + audio)
print("Audio being transcribed ...")
result = model.transcribe(audio)

# Creating a new filepath to export
output = os.path.splitext(audio)[0] + ".txt"
print("Output being written to:" + output)

# Saving the file as a text document
with open(output, "w") as file:
    file.write(result["text"])
print("Transcription complete!")