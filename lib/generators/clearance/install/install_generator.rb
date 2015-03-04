require 'rails/generators/base'
require 'rails/generators/active_record'

module Clearance
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def create_clearance_initializer
        copy_file 'clearance.rb', 'config/initializers/clearance.rb'
      end

      def inject_clearance_into_application_controller
        inject_into_class(
          "app/controllers/application_controller.rb",
          ApplicationController,
          "  include Clearance::Controller\n"
        )
      end

      def create_or_inject_clearance_into_user_model
        if File.exist? "app/models/user.rb"
          inject_into_file(
            "app/models/user.rb",
             "include Mongoid::Document\n
             include Mongoid::Timestamps\n
             include Clearance::User\n\n
             validates_presence_of :email, :encrypted_password, :remember_token\n
             validates_length_of :encrypted_password, :confirmation_token, :remember_token, maximum: 128\n\n
             field :email, type: String\n
             field :encrypted_password, type: String\n
             field :confirmation_token, type: String\n
             field :remember_token, type: String\n
             index\(\{ email: 1 \}, \{ unique: true, name: \"email_index\" \}\)\n
             index\(\{ remember_token: 1 \}, \{ unique: true, name: \"remember_token_index\" \}\)\n",
            after: "class User\n"
          )
        else
          copy_file 'user.rb', 'app/models/user.rb'
        end
      end

      def display_readme_in_terminal
        readme 'README'
      end
    end
  end
end
