#!/usr/bin/env rackup
# frozen_string_literal: true

require_relative "config/environment"

self.freeze_app

if UTOPIA.production?
	# Handle exceptions in production with a error page and send an email notification:
	use Utopia::Exceptions::Handler
	use Utopia::Exceptions::Mailer
else
	# We want to propate exceptions up when running tests:
	use Rack::ShowExceptions unless UTOPIA.testing?
end

# Serve static files from "public" directory:
cache_control = proc do |file|
	if file.path.last.end_with?(".m3u8")
		"public, max-age=0"
	else
		Utopia::Static::DEFAULT_CACHE_CONTROL
	end
end

use Utopia::Static, root: "public", cache_control: cache_control

use Utopia::Redirection::Rewrite, {
	"/" => "/index"
}

use Utopia::Redirection::DirectoryIndex

use Utopia::Redirection::Errors, {
	404 => "/errors/file-not-found"
}

# require "utopia/localization"
# use Utopia::Localization,
# 	default_locale: "en",
# 	locales: ["en", "de", "ja", "zh"]

# require "utopia/session"
# use Utopia::Session,
# 	expires_after: 3600 * 24,
# 	secret: UTOPIA.secret_for(:session),
# 	secure: true

use Utopia::Controller

# # Serve static files from "pages" directory:
# use Utopia::Static

# Serve dynamic content:
use Utopia::Content

run lambda { |env| [404, {}, []] }
