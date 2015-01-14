# coding: utf-8
#
namespace :hermes do

  desc 'Setup the app for the first time'
  task :setup do

    Setup.database_configuration
    Setup.secret_token

    puts "All done. Run the app by running 'rails server'"
  end

  module Setup
    extend self

    def database_configuration
      template      = 'config/database.yml.example'
      configuration = 'config/database.yml'

      unless File.exists?(configuration)
        print "* #{template} -> #{configuration} "
        FileUtils.cp template, configuration
        puts '✓'
      end
    end

    def secret_token
      configuration = 'config/initializers/secret_token.rb'
      unless File.exists?(configuration)
        print "* Generating #{configuration} "

        token = SecureRandom.hex(64)
        File.open('config/initializers/secret_token.rb', 'w+') do |file|
          file.puts %[Hermes::Application.config.secret_key_base = '#{token}']
        end

        puts '✓'
      end
    end
  end
end
