require "spec_helper"

describe BoletoBr::Rails::Engine do
  it "deve conter no path a pasta app" do
    BoletoBr::Rails::Engine.paths["app"].should include BoletoBr::app_path
  end
end

