require_relative "stream"

module Camcast
	class Camera
		def self.all
			YAML.load_file("config/cameras.yaml", symbolize_names: true).map do |id, camera|
				self.new(id, **camera)
			end
		end
		
		def initialize(id, name:, url:, **options)
			@id = id
			@name = name
			@url = url
			@options = options
		end
		
		attr :id
		
		attr :name
		attr :url
		
		attr :options
		
		def stream(...)
			Stream.new(@url, ...)
		end
		
		def stream_url
			[@id, "stream.m3u8"].join("/")
		end
	end
end
