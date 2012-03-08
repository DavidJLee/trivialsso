require 'active_support/core_ext'
require 'rails/all'

require 'test/unit'
require 'mocha'         # Need the mocha gem to properly stub out rails configuration.
require 'trivialsso'


##
# Test suite for Trivialsso. Which requires rails (for config values) and active_support for time calculations.
#
class TrivialssoTest < Test::Unit::TestCase

	def setup
		# Stub out our Rails config so we can test things properly.
		Rails.stubs(:configuration).returns(Rails::Application::Configuration.allocate)
		Rails.configuration.sso_secret = "57f236fdb162bd951f2ed15683a9d9d327f26ecdccb1897107161b76223b07a46d34907c3357e66b4eb0ef6e06888a700c0dc"			
	end


	def test_can_create_cookie		
		mycookie = Trivialsso::Login.cookie({'username' => 'testor'})
		assert !mycookie.nil?		
	end

	def test_create_cookie_with_userdata
		mycookie = Trivialsso::Login.cookie({'username' => 'testor', 'data' => 'additional cookie data'})
		assert !mycookie.nil?
	end
	
	def test_create_cookie_and_decode_it
		mycookie = Trivialsso::Login.cookie({'username' => 'testor', 'data' => 'additional cookie data'})
		data = Trivialsso::Login.decode_cookie(mycookie)
		
		if data['data'] == 'additional cookie data'
			assert true
		else
			assert false
		end
	end
	
	def test_throw_exception_on_missing_username
		begin
			mycookie = Trivialsso::Login.cookie("")
		rescue Trivialsso::NoUsernameCookie
			assert true, "Exception thrown due to blank username"
		else
			assert false, "No exception was raised for a blank username"
		end
	end
	
	
	def test_expire_date_exists
		# in a full rails environment, this will return an ActiveSupport::TimeWithZone
		mydate = Trivialsso::Login.expire_date
		assert mydate.is_a?(Time), "proper Time object not returned"
	end
	
	def test_expire_date_is_in_future
		assert (DateTime.now < Trivialsso::Login.expire_date), "Expire date is in the past - cookie will expire immediatly."
	end
	
	def test_exception_on_blank_cookie
		begin
			Trivialsso::Login.decode_cookie("")
		rescue Trivialsso::MissingCookie
			assert true			
		else
			assert false, "no exception was raised for a blank cookie"
		end
	end
	
	def test_exception_on_bad_cookie
		begin
			Trivialsso::Login.decode_cookie("BAhbB0kiC2RqbGVlMgY6BkVUbCsHo17iTg")
		rescue Trivialsso::BadCookie
			assert true			
		else
			assert false, "no exception was raised for a malformed cookie"
		end		
	end
	
	def test_exception_on_expired_cookie
		#create a cookie that is expired.
		temp_cookie = Trivialsso::Login.cookie({'username' => 'testor'}, 2.seconds.ago)
		
		begin
			Trivialsso::Login.decode_cookie(temp_cookie)
		rescue Trivialsso::LoginExpired
			assert true
		else
			assert false, "no exception was raised for an expired cookie"
		end
	end
	
end
