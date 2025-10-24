# frozen_string_literal: true

require_relative "../camera"
require_relative "stream"

module Camcast
	module Service
		module Environment
			def cameras
				Camcast::Camera.all
			end
			
			def service_class
				Stream
			end
			
			def public_path
				File.join(self.root, "public")
			end
		end
	end
end
