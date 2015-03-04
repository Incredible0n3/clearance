require "spec_helper"
require "generators/clearance/install/install_generator"

describe Clearance::Generators::InstallGenerator, :generator do
  describe "initializer" do
    it "is copied to the application" do
      provide_existing_application_controller

      run_generator
      initializer = file("config/initializers/clearance.rb")

      expect(initializer).to exist
      expect(initializer).to have_correct_syntax
      expect(initializer).to contain("Clearance.configure do |config|")
    end
  end

  describe "application controller" do
    it "includes Clearance::Controller" do
      provide_existing_application_controller

      run_generator
      application_controller = file("app/controllers/application_controller.rb")

      expect(application_controller).to have_correct_syntax
      expect(application_controller).to contain("include Clearance::Controller")
    end
  end

  describe "user_model" do
    context "no existing user class" do
      it "creates a user class including Clearance::User" do
        provide_existing_application_controller

        run_generator
        user_class = file("app/models/user.rb")

        expect(user_class).to exist
        expect(user_class).to have_correct_syntax
        expect(user_class).to contain("include Clearance::User")
        expect(user_class).to contain("include Mongoid::Document")
        expect(user_class).to contain("include Mongoid::Timestamps")
        expect(user_class).to contain("validates_presence_of :email, :encrypted_password, :remember_token")
        expect(user_class).to contain("validates_length_of :encrypted_password, :confirmation_token, :remember_token, maximum: 128")
        expect(user_class).to contain("field :email, type: String")
        expect(user_class).to contain("field :encrypted_password, type: String")
        expect(user_class).to contain("field :confirmation_token, type: String")
        expect(user_class).to contain("field :remember_token, type: String")
        expect(user_class).to contain("index({ email: 1 }, { unique: true, name: "email_index" })")
        expect(user_class).to contain("index({ remember_token: 1 }, { unique: true, name: "remember_token_index" })")
      end
    end

    context "user class already exists" do
      it "includes Clearance::User" do
        provide_existing_application_controller
        provide_existing_user_class

        run_generator
        user_class = file("app/models/user.rb")

        expect(user_class).to exist
        expect(user_class).to have_correct_syntax
        expect(user_class).to contain("include Clearance::User")
        expect(user_class).to contain("include Mongoid::Document")
        expect(user_class).to contain("include Mongoid::Timestamps")
        expect(user_class).to contain("validates_presence_of :email, :encrypted_password, :remember_token")
        expect(user_class).to contain("validates_length_of :encrypted_password, :confirmation_token, :remember_token, maximum: 128")
        expect(user_class).to contain("field :email, type: String")
        expect(user_class).to contain("field :encrypted_password, type: String")
        expect(user_class).to contain("field :confirmation_token, type: String")
        expect(user_class).to contain("field :remember_token, type: String")
        expect(user_class).to contain("index({ email: 1 }, { unique: true, name: "email_index" })")
        expect(user_class).to contain("index({ remember_token: 1 }, { unique: true, name: "remember_token_index" })")
        expect(user_class).to have_method("previously_existed?")
      end
    end
  end
end
