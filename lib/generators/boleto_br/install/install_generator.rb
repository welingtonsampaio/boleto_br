require 'rails'

module BoletoBr
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      source_root File.expand_path("../templates", __FILE__)

      desc "Adiciona o arquivo de controller e o initializer do sistema de boletos."

      def initialize_file
        copy_file "boletobr.rb", "config/initializers/boletobr.rb"
      end

      def create_controller
        copy_file "boletobr_controller.rb", "app/controllers/boletobr_controller.rb"
      end

    end
  end
end
