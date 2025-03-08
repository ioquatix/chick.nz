#!/usr/bin/env -S falcon host
# frozen_string_literal: true

# Copyright, 2025, by Samuel Williams.

require "falcon/environment/self_signed_tls"
require "falcon/environment/rack"
require "falcon/environment/supervisor"

service "chick.nz" do
	# include Falcon::Environment::SelfSignedTLS
	include Falcon::Environment::Rack
	
	scheme "http"
	protocol {Async::HTTP::Protocol::HTTP}
	
	endpoint do
		Async::HTTP::Endpoint.for(scheme, "localhost", port: 9292, protocol: protocol)
	end
end

require_relative "lib/camcast/service/environment"

service "stream" do
	include Camcast::Service::Environment
end
