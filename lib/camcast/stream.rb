# frozen_string_literal: true

module Camcast
	class Stream
		def initialize(url, output_path, audio: true, **options)
			@url = url
			@output_path = output_path
			@audio = audio
			@options = options
		end
		
		def stream_path
			File.join(@output_path, "stream.m3u8")
		end
		
		FFMPEG = ENV.fetch("FFMPEG", "ffmpeg")
		
		def start
			arguments = [
				FFMPEG,
				# "-loglevel", "error",
				"-hide_banner",
				"-i", @url,
				
				# Transcode to H.264:
				"-c:v", "libx264",
				"-preset", "veryfast",
				"-crf", "23"
			]
			
			# Conditionally add audio codec or disable audio:
			if @audio
				arguments.concat(["-c:a", "aac", "-b:a", "128k"])
			else
				arguments.concat(["-an"])
			end
			
			# Segment the stream:
			arguments.concat([
				"-f", "hls",
				"-hls_time", "10",
				"-hls_list_size", "6",
				"-hls_flags", "delete_segments",
				stream_path
			])
			
			Process.spawn(*arguments)
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
