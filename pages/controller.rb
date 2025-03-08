prepend Actions

on "*" do |request, path|
	@cameras = Camcast::Camera.all
	@camera = @cameras.first
	
	@cameras.each do |camera|
		if path.last == camera.id.to_s
			@camera = camera
		end
	end
	
	path.components = ["index"]
end
