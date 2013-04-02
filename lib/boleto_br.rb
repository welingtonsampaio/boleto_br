require "rails"
require 'active_support/dependencies'
require "boleto_br/version"

module BoletoBr

  mattr_accessor :app_path
  @@app_path = File.expand_path('../../app', __FILE__)

  mattr_accessor :date_format
  @@date_format = "%d/%m/%Y"

  def self.setup
    yield self
  end

end

require "boleto_br/engine"
require "boleto_br/strategies_common"
require "boleto_br/strategies/bb"
