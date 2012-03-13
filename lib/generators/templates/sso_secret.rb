# This file is required to define the shared secret used for generating and decoding
# SSO cookies. This secret *must* be the same across all of your applications.

<%= Rails.application.class.parent_name %>::Application.config.sso_secret = "You-really-need-to-change-this-to-a-nice-long-random-string"