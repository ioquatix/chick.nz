# frozen_string_literal: true

require "async/service/generic"
require "fileutils"

module Camcast
	module Service
		class Stream < Async::Service::Generic
			def setup(container)
				cameras = @evaluator.cameras
				
				cameras.each do |camera|
					container.spawn(restart: true, name: "Camera Stream: #{camera.id}") do |instance|
						instance.ready!
						
						root = File.join(@evaluator.public_path, camera.id.to_s)
						FileUtils.mkdir_p(root)
						
						camera.stream(root).run
					end
				end
			end
		end
	end
end
