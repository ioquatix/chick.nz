module Camcast
	class Stream
		def initialize(url, output_path)
			@url = url
			@output_path = output_path
		end
		
		def stream_path
			File.join(@output_path, "stream.m3u8")
		end
		
		FFMPEG = ENV.fetch("FFMPEG", "ffmpeg")
		
		def start
			Process.spawn(
				FFMPEG,
				"-loglevel", "error",
				"-hide_banner",
				"-i", @url,
				
				# Transcode to H.264:
				"-c:v", "libx264",
				"-preset", "veryfast",
				"-crf", "23",
				
				# Disable audio:
				"-an",
				
				# Segment the stream:
				"-f", "hls",
				"-hls_time", "10",
				"-hls_list_size", "6",
				"-hls_flags", "delete_segments",
				stream_path
			)
		end
		
		def run
			pid = self.start
			
			Process.wait(pid)
			
			pid = nil # Process has exited... don't try to kill it.
		ensure
			if pid
				Process.kill("TERM", pid)
				Process.wait(pid)
			end
		end
	end
end
