module BoletoBr
  class Engine < ::Rails::Engine
    paths["app"] << BoletoBr::app_path
  end
end