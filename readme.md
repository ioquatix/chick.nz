# Chick.nz

- Website: https://chick.nz

This was a weekend project to revive my old web cameras and make them accessible from the internet. `ffmpeg` streams RSTP from the cameras to HLS which is served using Falcon. A separate `Async::Service` is used to manage the cameras and the streams. Not a lot of thought went into this code, I basically wanted to crank out of proof-of-concept as quickly as possible, which I was able to do in an evening.
