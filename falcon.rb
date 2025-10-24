#!/usr/bin/env -S falcon host
# frozen_string_literal: true

# Copyright, 2025, by Samuel Williams.

require "falcon/environment/rack"
require "falcon/environment/tls"
require "falcon/environment/lets_encrypt_tls"
require "falcon/environment/supervisor"

service "supervisor" do
	include Falcon::Environment::Supervisor
end

hostname = File.basename(__dir__)

service hostname do
	include Falcon::Environment::Rack
	include Falcon::Environment::TLS
	include Falcon::Environment::LetsEncryptTLS
end

# service hostname do
# 	include Falcon::Environment::Rack
	
# 	scheme "http"
# 	protocol {Async::HTTP::Protocol::HTTP}
	
# 	endpoint do
# 		Async::HTTP::Endpoint.for(scheme, "localhost", port: 9292, protocol: protocol)
# 	end
# end

require_relative "lib/camcast/service/environment"

service "stream" do
	include Camcast::Service::Environment
end
