## Trivialsso

A very simple gem to help with creating and reading cookies across multiple sites in a Ruby on Rails application.

This allows for a simple single sign on solution among sites within the same domain.

This does *not* work across domains.


## Getting Started

Add the gem to your Gemfile
	gem 'trivialsso'

Install the gem
	bundle install

After you've installed the gem, you need to generate a configuration file.
	rails g trivialsso:install

This will create an initializer file with a shared secret. You need to modify this to a big long
string of characters. Keep this safe from others as they could forge cookies for your sites if they
get ahold of this string. All sites that use the single sign on must have this same shared secret
for the cookies to properly interoperate.

## Creating a cookie

A cookie is created using a hash of data supplied to it. This has at a minimum must contain a "username" key.

When you create the cookie data an expire time is built into the payload. Setting the :expires on the cookie is
just a convenience to make sure it gets cleared by the browser. The actual expiration date that matters is what is encoded in the cookie.


	# Create a hash of data we want to store in the cookie.
	userdata = {"username" => current_user.login, "display" => current_user.display_name, "groups" => current_user.memberof}
	
	#Generate the cookie data
	cookie = Trivialsso::Login.cookie(userdata)
	
	# Set the cookie
	cookies[:sso_login] = {
		:value => cookie,
		:expires => Trivialsso::Login.expire_date,
		:domain => 'mydomain.com',
		:httponly => true,
	}

The above code creates a hash of data we will be putting in the cookie, generates the cookie, and then sets the cookie in the browser.

## Decoding a cookie

Retrieve the contents of the cookie by calling decode_cookie
	@userdata = Trivialsso::Login.decode_cookie(cookies[:sso_login])

This will throw an exception if the cookie has been tampered with, or if the expiration date has passed.

## Sample code for application_controller

Here are some methods you can add into your application controller to authenticate against the cookie.

	# If there is a problem with the cookie, redirect back to our central login server.
	rescue_from Trivialsso::CookieError do |exception|
		redirect_to 'https://login.mydomain.com/'
	end

	# authorize our users based on the cookie.
	before_filter :auth_user!

	# authenticate a user and set @current_user
	def auth_user!
		cu = current_user

		# Check for authorization based on "groups" data that was put in the cookie
		# by the central login application.
		# you could also skip this check and just return true if the cookie is valid.
		if cu['groups'].include? "ALLOWED_GROUP"    #all lower case
			@current_user = cu
			return true
		else
			render :file => "#{Rails.root}/public/403", :formats => [:html], :status => 403, :layout => false
		end

		return false
	end

	# our current_user decodes the cookie.
	def current_user
		Trivialsso::Login.decode_cookie(cookies[:ophth_login])
	end

	# Define the name we want to record in paper_trail (if using)
	def user_for_paper_trail
		if @current_user.blank?
			return "anonymous"
		else
			return @current_user['username']
		end
	end

