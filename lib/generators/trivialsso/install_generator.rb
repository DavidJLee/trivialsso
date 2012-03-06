module Trivalsso
	module Generators
		class InstallGenerator < Rails::Generators::Base
			
			source_root File.expand_path("../../templates",__FILE__)
			
			def copy_intializer
				#template?
				
				copy_file "sso_secret.rb", "config/initalizers/sso_secret.rb"
			end
			
			
			def show_readme
				readme "foobar"
			end
			
		end
	end
end