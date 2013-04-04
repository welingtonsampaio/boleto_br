require "spec_helper"

describe BoletoBr::Engine do
  it "deve conter no path a pasta app" do
    BoletoBr::Engine.paths["app"].should_not eql BoletoBr::Engine.paths["app"].delete(BoletoBr::app_path)
  end
end

