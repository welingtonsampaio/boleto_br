# -*- encoding: utf-8 -*-

=begin

=end
begin
  require 'date'
rescue LoadError
  require "rubygems" unless ENV['NO_RUBYGEMS']
  gem "date"
  require 'date'
end

=begin

=end
begin
  require 'rails'
  require 'active_support'
  require 'active_support/dependencies'
rescue LoadError
  require "rubygems" unless ENV['NO_RUBYGEMS']
  gem "rails"
  gem "active_support"
  require 'rails'
  require 'active_support'
  require 'active_support/dependencies'
end

=begin

=end
require "boleto_br/support/string"
require "boleto_br/support/numeric"
require "boleto_br/support/calculation"

module BoletoBr

  # Caminho absoluto da pasta da aplicacao Rails
  # @return [String]
  # @param [String]
  mattr_accessor :app_path
  @@app_path = File.expand_path('../../app', __FILE__)

  # Padarao de data impressos nos boletos
  # @return [String] (deafult: %d/%m/%Y)
  # @param [String]
  mattr_accessor :date_format
  @@date_format = "%d/%m/%Y"

  # Texto inserido no topo no topo dos boletos
  # @return [String] (deafult: Boleto Br)
  # @param [String]
  mattr_accessor :identificacao
  @@identificacao = "Boleto Br"

  # Nome do proprietario da conta corrente
  # @return [String] (deafult: Razao social da empresa)
  # @param [String]
  mattr_accessor :cedente
  @@cedente = "Razao social da empresa"

  # Documento do proprietario da conta corrente (PF ou CNPJ)
  # @return [String] (deafult: true)
  # @param [String]
  mattr_accessor :cedente_documento
  @@cedente_documento = true

  # Endereco da empresa do cendente
  # @return [String] (deafult: Endereco da empresa)
  # @param [String]
  mattr_accessor :cedente_endereco
  @@cedente_endereco = "Endereco da empresa"

  # Cidade e Estado localizados a empresa do cendente
  # @return [String] (deafult: Cidade / Estado)
  # @param [String]
  mattr_accessor :cedente_cidade_uf
  @@cedente_cidade_uf = "Cidade / Estado"

  def self.setup
    yield self
  end

  module Strategies
    autoload :Standard,    "boleto_br/strategies/standard"
    autoload :BancoBrasil, "boleto_br/strategies/banco_brasil"
    autoload :HSBC,        "boleto_br/strategies/hsbc"
  end

  module Rails
    autoload :Engine, "boleto_br/rails/engine"
  end

end
