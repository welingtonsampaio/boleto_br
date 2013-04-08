# -*- encoding: utf-8 -*-
# @author Welington Sampaio
module BoletoBr
  module Strategies
    class Standard

      # Metodos de validacao do Rails
      include ActiveModel::Validations

      # <b>REQUERIDO</b>: Número do convênio/contrato do cliente junto ao banco emissor
      attr_accessor :convenio

      # <b>REQUERIDO</b>: Tipo de moeda utilizada (Real(R$) e igual a 9)
      attr_accessor :moeda

      # <b>REQUERIDO</b>: Carteira utilizada
      attr_accessor :carteira

      # <b>OPCIONAL</b>: Variacao da carteira(opcional para a maioria dos bancos)
      attr_accessor :variacao

      # <b>OPCIONAL</b>: Data de processamento do boleto, geralmente igual a data_documento
      attr_accessor :data_processamento

      # Número de dias a vencer ou objeto Date
      # REQUERIDO
      # type [Integer, Date]
      attr_accessor :vencimento

      # <b>REQUERIDO</b>: Quantidade de boleto(padrão = 1)
      attr_accessor :quantidade

      # <b>REQUERIDO</b>: Valor do boleto
      attr_accessor :valor

      # <b>REQUERIDO</b>: Número da agencia sem <b>Digito Verificador</b>
      attr_accessor :agencia

      # <b>REQUERIDO</b>: Número da conta corrente sem <b>Digito Verificador</b>
      attr_accessor :conta_corrente

      # <b>REQUERIDO</b>: Nome do proprietario da conta corrente
      attr_accessor :cedente

      # <b>REQUERIDO</b>: Documento do proprietario da conta corrente (CPF ou CNPJ)
      attr_accessor :documento_cedente

      # <b>OPCIONAL</b>: Número sequencial utilizado para identificar o boleto
      attr_accessor :numero_documento

      # Símbolo da moeda utilizada (R$ no brasil)
      # <REQUERIDO>
      # @type [String]
      attr_accessor :especie

      # <b>REQUERIDO</b>: Tipo do documento (Geralmente DM que quer dizer Duplicata Mercantil)
      attr_accessor :especie_documento

      # <b>REQUERIDO</b>: Data em que foi emitido o boleto
      attr_accessor :data_documento

      # <b>OPCIONAL</b>: Código utilizado para identificar o tipo de serviço cobrado
      attr_accessor :codigo_servico

      # <b>OPCIONAL</b>: Utilizado para mostrar alguma informação ao sacado
      attr_accessor :instrucao1

      # <b>OPCIONAL</b>: Utilizado para mostrar alguma informação ao sacado
      attr_accessor :instrucao2

      # <b>OPCIONAL</b>: Utilizado para mostrar alguma informação ao sacado
      attr_accessor :instrucao3

      # <b>OPCIONAL</b>: Utilizado para mostrar alguma informação ao sacado
      attr_accessor :instrucao4

      # <b>OPCIONAL</b>: Utilizado para mostrar alguma informação ao sacado
      attr_accessor :instrucao5

      # <b>OPCIONAL</b>: Utilizado para mostrar alguma informação ao sacado
      attr_accessor :instrucao6

      # <b>OPCIONAL</b>: Utilizado para mostrar alguma informação ao sacado
      attr_accessor :instrucao7

      # <b>REQUERIDO</b>: Informação sobre onde o sacado podera efetuar o pagamento
      attr_accessor :local_pagamento

      # <b>REQUERIDO</b>: Informa se o banco deve aceitar o boleto após o vencimento ou não( S ou N, quase sempre S)
      attr_accessor :aceite

      # <b>REQUERIDO</b>: Nome da pessoa que receberá o boleto
      attr_accessor :sacado

      # <b>OPCIONAL</b>: Endereco da pessoa que receberá o boleto
      attr_accessor :sacado_endereco

      # <b>REQUERIDO</b>: Documento da pessoa que receberá o boleto
      attr_accessor :sacado_documento

      # Validações
      validates_presence_of :agencia, :conta_corrente, :moeda, :especie_documento, :especie, :venciimento,
                            :aceite, :numero_documento, :message => "não pode estar em branco."
      validates_numericality_of :convenio, :agencia, :conta_corrente, :numero_documento,
                                :message => "não é um número.", :allow_nil => true


      def initialize(opts={})
        {
          :moeda => "9", :data_documento => Date.today, :vencimento => 1, :quantidade => 1,
          :especie_documento => "DM", :especie => "R$", :aceite => "S", :valor => 0.0,
          :local_pagamento => "QUALQUER BANCO ATÉ O VENCIMENTO"
        }.merge(opts).each do |campo, valor|
          send "#{campo}=", valor
        end
        especie
        yield self if block_given?
      end

      def generate_hash_barcode valor = nil, opts={}
        valor ||= get_data(:codigo_barras)
        opts = {fino:1,largo:3,altura:50}.merge opts

        barcodes = ["00110","10001","01001","11000","00101","10100","01100","00011","10010","01010"]
        range = (0..9).to_a.reverse
        range.each do |f1|
          range.each do |f2|
            f     = f1 * 10 + f2
            texto = ""
            (1..5).each do |i|
              texto = "#{texto}#{barcodes[f1].slice((i-1),1)}#{barcodes[f2].slice((i-1),1)}"
            end
            barcodes[f] = texto
          end
        end
        barcodes

        _r = []                                                         ## Desenho da barra
        _r << { color: "p", width: opts[:fino], height: opts[:altura] } ## Guarda inicial
        _r << { color: "b", width: opts[:fino], height: opts[:altura] }
        _r << { color: "p", width: opts[:fino], height: opts[:altura] }
        _r << { color: "b", width: opts[:fino], height: opts[:altura] }

        texto = valor
        texto = "0#{texto}" if texto.length.odd?

        #// Draw dos dados
        while texto.length > 0
          i = esquerda(texto,2).to_i.round
          texto = direita(texto,texto.length-2)
          f = barcodes[i]
          (1..10).each do |i|
            next if i.even?
            f1 = if f.slice((i-1),1) == "0" then opts[:fino] else opts[:largo] end
            _r << { color: "p", width: f1, height: opts[:altura] }

            f2 = if f.slice(i,1) == "0" then opts[:fino] else opts[:largo] end
            _r << { color: "b", width: f2, height: opts[:altura] }
          end
        end
        _r << { color: "p", width: opts[:largo], height: opts[:altura] }
        _r << { color: "b", width: opts[:fino],  height: opts[:altura] }
        _r << { color: "p", width: opts[:fino],  height: opts[:altura] }
        _r
      end

      # Gera o Codigo de Barras
      def barcode_html valor = nil
        valor = generate_hash_barcode valor if valor.instance_of? String
        valor ||= generate_hash_barcode get_data(:codigo_barras)
        raise "Valor enviado e de formato invalido" unless valor.instance_of? Array
        _return = ""
        valor.each do |hash|
          _return << %`<img src="/assets/boleto_br/#{hash[:color]}.png" width="#{hash[:width]}" height="#{hash[:height]}" border="0" />`
        end
        _return.html_safe
      end

      def esquerda entra, comp
        entra.slice 0, comp
      end

      def direita entra, comp
        entra.slice entra.length-comp, comp
      end

      def vencimento
        return data_documento + @vencimento if @vencimento.is_numeric?
        @vencimento
      end

    end
  end
end