require "rails"
require "date"
require 'active_support'
require "boleto_br/version"

module BoletoBr

  mattr_accessor :app_path
  @@app_path = File.expand_path('../../app', __FILE__)

  mattr_accessor :date_format
  @@date_format = "%d/%m/%Y"

  mattr_accessor :title
  @@title = "Boleto Br"

  mattr_accessor :identificacao
  @@identificacao = "Boleto Br"

  mattr_accessor :cpf_cnpj
  @@cpf_cnpj = true

  mattr_accessor :endereco
  @@endereco = "Endereco da empresa"

  mattr_accessor :cidade_uf
  @@cidade_uf = "Cidade / Estado"

  mattr_accessor :cedente
  @@cedente = "Razao social da empresa"

  def self.setup
    yield self
  end

end

require "boleto_br/engine"
require "boleto_br/strategies_common"
require "boleto_br/strategies/bb"
require "boleto_br/strategies/hsbc"
