module BoletoBr
  module Strategies
    class Commom
      attr_accessor :agencia,
                    :agencia_codigo,
                    :carteira,
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
                    :valor_boleto

      def initialize
        @data = {}
        @data[:aceite]                  = "N"
        @data[:contrato]                = nil
        @data[:convenio]                = nil
        @data[:data_documento]          = nil
        @data[:data_processamento]      = nil
        @data[:demonstrativo1]          = nil
        @data[:demonstrativo2]          = nil
        @data[:demonstrativo3]          = nil
        @data[:endereco1]               = nil
        @data[:endereco2]               = nil
        @data[:especie]                 = "R"
        @data[:especie_doc]             = "DM"
        @data[:identificacao]           = nil
        @data[:instrucoes1]             = nil
        @data[:instrucoes2]             = nil
        @data[:instrucoes3]             = nil
        @data[:instrucoes4]             = nil
        @data[:numero_documento]        = nil
        @data[:quantidade]              = "10"
        @data[:sacado]                  = nil
        @data[:valor_unitario]          = "10"
        @data[:variacao_carteira]       = nil
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

      #protected
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

      # Gera o Codigo de Barras
      def fbarcode valor = nil
        valor ||= @data[:codigo_barras]
        fino   = 1
        largo  = 3
        altura = 50

        barcodes = []
        barcodes[0] = "00110"
        barcodes[1] = "10001"
        barcodes[2] = "01001"
        barcodes[3] = "11000"
        barcodes[4] = "00101"
        barcodes[5] = "10100"
        barcodes[6] = "01100"
        barcodes[7] = "00011"
        barcodes[8] = "10010"
        barcodes[9] = "01010"
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

        ## Desenho da barra
        ## Guarda inicial
        _return =  %`<img src="/assets/boleto_br/p.png" width="#{fino}" height="#{altura}" border="0" />`
        _return << %`<img src="/assets/boleto_br/b.png" width="#{fino}" height="#{altura}" border="0" />`
        _return << %`<img src="/assets/boleto_br/p.png" width="#{fino}" height="#{altura}" border="0" />`
        _return << %`<img src="/assets/boleto_br/b.png" width="#{fino}" height="#{altura}" border="0" />`

        texto = valor
        texto = "0#{texto}" if texto.length.odd?

        #// Draw dos dados
        while texto.length > 0
          i = esquerda(texto,2).to_d.round
          texto = direita(texto,texto.length-2)
          f = barcodes[i]
          (1..10).each do |i|
            next if i.even?
            f1 = if f.slice((i-1),1) == "0" then fino else largo end
            _return << %`<img src="/assets/boleto_br/p.png" width="#{f1}" height="#{altura}" border="0" />`

            f2 = if f.slice(i,1) == "0" then fino else largo end
            _return << %`<img src="/assets/boleto_br/b.png" width="#{f2}" height="#{altura}" border="0" />`

          end
        end
        _return << %`<img src="/assets/boleto_br/p.png" width="#{largo}" height="#{altura}" border="0" />`
        _return << %`<img src="/assets/boleto_br/b.png" width="#{fino}" height="#{altura}" border="0" />`
        _return << %`<img src="/assets/boleto_br/p.png" width="#{fino}" height="#{altura}" border="0" />`
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