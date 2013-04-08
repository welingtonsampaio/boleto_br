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
        :cedente           => "Kivanio Barbosa",
        :documento_cedente => "12345678912",
        :sacado            => "Claudio Pozzebom",
        :sacado_documento  => "12345678900",
        :agencia           => "4042",
        :conta_corrente    => "61900",
        :convenio          => 12387989,
        :numero_documento  => "777700168"
    }
  end

end