module Camcast
	class Stream
		def initialize(url, output_path)
			@url = url
		end
		
		FFMPEG = "ffmpeg"
		
		def stream_path
			File.join(output_path, "stream.m3u8")
		end
		
		def start
			Process.spawn([
				FFMPEG,
				"-i", @url,
				"-c:v", "libx264",
				"-preset", "veryfast",
				"-crf", "23",
				"-c:a", "aac",
				"-b:a", "128k",
				"-f", "hls",
				"-hls_time", "4",
				"-hls_list_size", "10",
				"-hls_flags", "delete_segments",
				stream_path
			])
		end
		
		def run
			pid = self.start
			
			Process.wait(pid)
		ensure
			if pid
				Process.kill("TERM", pid)
				Process.wait(pid)
			end
		end
	end
end
