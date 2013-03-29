require 'rails'

module BoletoBr
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      source_root File.expand_path("../templates", __FILE__)

      desc "Generates a model with the given NAME (if one does not exist) with devise " <<
               "configuration plus a migration file and devise routes."

      def create_controller
        copy_file "boletobr_controller.rb", "app/controllers/boletobr_controller.rb"
      end

    end
  end
end
