# frozen_string_literal: true

module Camcast
	class Stream
		def initialize(url, output_path, audio: true, codec: nil, **options)
			@url = url
			@output_path = output_path
			@audio = audio
			@codec = codec # Can be: 'copy', 'nvenc', 'vaapi', or nil for libx264
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
				"-i", @url
			]
			
			# Video codec selection for best performance:
			case @codec
			when 'copy'
				# No transcoding - just copy the stream (fastest, zero CPU)
				arguments.concat(["-c:v", "copy"])
			when 'nvenc'
				# Nvidia GPU acceleration
				arguments.concat([
					"-c:v", "h264_nvenc",
					"-preset", "fast",
					"-b:v", "3M" # 3Mbps bitrate, adjust as needed
				])
			when 'vaapi'
				# Intel/AMD GPU acceleration (Linux)
				arguments.concat([
					"-vaapi_device", "/dev/dri/renderD128",
					"-c:v", "h264_vaapi",
					"-b:v", "3M"
				])
			else
				# Fallback to software encoding with faster preset
				arguments.concat([
					"-c:v", "libx264",
					"-preset", "ultrafast", # Changed from veryfast
					"-crf", "23"
				])
			end
			
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
				# The hls_segment_filename option in FFmpeg supports strftime conversion specifiers for naming HLS segment files with the current date and time. To enable this feature, you must also use the -strftime 1 option in your FFmpeg command:
				"-strftime", "1", "-hls_segment_filename", File.join(@output_path, "stream_%Y%m%d_%H%M%S.ts"),
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
