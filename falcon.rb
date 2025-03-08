#!/usr/bin/env -S falcon host
# frozen_string_literal: true

# Copyright, 2025, by Samuel Williams.

require 'falcon/environment/rack'
require 'falcon/environment/tls'
require 'falcon/environment/lets_encrypt_tls'
require 'falcon/environment/supervisor'

service 'supervisor' do
	include Falcon::Environment::Supervisor
end

hostname = File.basename(__dir__)

service hostname do
	include Falcon::Environment::Rack
	include Falcon::Environment::TLS
	include Falcon::Environment::LetsEncryptTLS
end

require_relative "lib/camcast/service/environment"

service "stream" do
	include Camcast::Service::Environment
end
