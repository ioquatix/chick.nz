module Camcast
	class Camera
		def initialize(url)
			@url = url
		end
		
		def stream
			Camcast::Service::Stream.new(@url)
		end
	end
end
