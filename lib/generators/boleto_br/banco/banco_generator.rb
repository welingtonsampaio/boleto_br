require 'rails'

module BoletoBr
  module Generators
    class BancoGenerator < ::Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      source_root File.expand_path("../templates", __FILE__)

      desc "Generates a model with the given NAME (if one does not exist) with devise " <<
               "configuration plus a migration file and devise routes."


      def inject_action_in_controller
        inject_into_file "app/controllers/boletobr_controller.rb",
                         :after => "include ActionView::Helpers::NumberHelper"  do
          File.read("#{File.expand_path("../templates", __FILE__)}/#{file_name}.rb")
        end
      end

      class_option :routes, :desc => "Generate routes", :type => :boolean, :default => true

      def add_boletobr_routes
        boletobr_route  = %`get "/boleto/#{file_name}/:id"`
        boletobr_route << %` => "boletobr##{file_name}"`
        boletobr_route << %`, as: :boletobr_bb`
        route boletobr_route
      end

    end
  end
end
