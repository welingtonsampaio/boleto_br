# -*- encoding: utf-8 -*-
require "spec_helper"

describe BoletoBr::Strategies::Standard do

  before(:each) do
    @atributos_validos = {
        :especie_documento => "DM",
        :moeda             => "9",
        :data_documento    => Date.today,
        :vencimento        => 1,
        :aceite            => "S",
        :quantidade        => 1,
        :valor             => 0.0,
        :local_pagamento   => "QUALQUER BANCO ATÉ O VENCIMENTO",
        :cedente           => "Zaez Solucoes em Tecnologia",
        :documento_cedente => "12345678901234",
        :sacado            => "Welington Sampaio",
        :sacado_documento  => "12345678901",
        :agencia           => "0123",
        :conta_corrente    => "12345",
        :convenio          => 1234567,
        :numero_documento  => "123"
    }
  end

  describe "Testando funcionalidades comum" do

    it "deve poder poder cunfigurar o vencimento de duas formas, com inteiros e objeto Date" do
      standard = BoletoBr::Strategies::Standard.new @atributos_validos

    end

  end

end