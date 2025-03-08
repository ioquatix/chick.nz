# Chick.nz

This was a weekend project to revive my old web cameras and make them accessible from the internet. `ffmpeg` streams RSTP from the cameras to HLS which is served using Falcon. A separate `Async::Service` is used to manage the cameras and the streams.
