module BoletoBr
  module Strategies
    class Commom
      attr_accessor :agencia,
                    :agencia_codigo,
                    :codigo_banco,
                    :codigo_banco_com_dv,
                    :conta,
                    :data,
                    :data_vencimento,
                    :dv,
                    :fator_vencimento,
                    :linha,
                    :livre_zeros,
                    :nosso_numero,
                    :num_moeda,
                    :valor_boleto,
                    :valor_real

      def initialize
        @data = {}
        set_data :aceite             , "N"
        set_data :contrato           , nil
        set_data :convenio           , nil
        set_data :data_documento     , nil
        set_data :data_processamento , nil
        set_data :demonstrativo1     , nil
        set_data :demonstrativo2     , nil
        set_data :demonstrativo3     , nil
        set_data :endereco1          , nil
        set_data :endereco2          , nil
        set_data :especie            , "R"
        set_data :especie_doc        , "DM"
        set_data :identificacao      , nil
        set_data :instrucoes1        , nil
        set_data :instrucoes2        , nil
        set_data :instrucoes3        , nil
        set_data :instrucoes4        , nil
        set_data :numero_documento   , nil
        set_data :quantidade         , "10"
        set_data :sacado             , nil
        set_data :valor_unitario     , "10"
      end

      def get_data symbol
        return @data[ symbol.to_sym ] if @data[ symbol.to_sym ].present?
        false
      end

      def set_data symbol, value
        @data[ symbol.to_sym ] = value
      end

      def setup
        yield self
      end

      # Funcao para formatar numeros para
      # geracao dos boletos
      # @param [String] numero
      # @param [Integer] loop
      # @param [String] insert
      # @param [String] tipo
      # @return [String]
      def formata_numero number, opts={}
        number = number.to_s
        opts   = { loop: 10, insert: :"0" }.merge opts
        # remove as virgulas e pontos caso seja um valor de dinheiro
        number.gsub! /[,\.\ ]/ , ''
        (opts[:loop] - number.length).times { number = "#{opts[:insert]}#{number}" }
        number
      end

      # Retorna a data do dia no formato brasileiro
      # @param [String] format
      # @return [String]
      def date_today format=nil
        format ||= BoletoBr::date_format
        Date.today.strftime format
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

    end
  end
end