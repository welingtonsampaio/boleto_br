module BoletoBr
  module Strategies
    class Commom
      attr_accessor :data_venc,
                    :valor_boleto,
                    :codigo_banco,
                    :agencia,
                    :conta,
                    :carteira,
                    :agencia_codigo,
                    :num_moeda,
                    :livre_zeros,
                    :codigo_banco_com_dv,
                    :fator_vencimento,
                    :valor,
                    :nosso_numero,
                    :dv,
                    :linha,
                    :data

      def initialize
        @data = {}
        @data[:nosso_numero]            = nil
        @data[:numero_documento]        = nil
        @data[:data_vencimento]         = nil
        @data[:data_documento]          = nil
        @data[:data_processamento]      = nil
        @data[:valor_boleto]            = nil
        @data[:sacado]                  = nil
        @data[:endereco1]               = nil
        @data[:endereco2]               = nil
        @data[:demonstrativo1]          = nil
        @data[:demonstrativo2]          = nil
        @data[:demonstrativo3]          = nil
        @data[:instrucoes1]             = nil
        @data[:instrucoes2]             = nil
        @data[:instrucoes3]             = nil
        @data[:instrucoes4]             = nil
        @data[:quantidade]              = "10"
        @data[:valor_unitario]          = "10"
        @data[:aceite]                  = "N"
        @data[:especie]                 = "R"
        @data[:especie_doc]             = "DM"
        @data[:agencia]                 = nil
        @data[:conta]                   = nil
        @data[:convenio]                = nil
        @data[:contrato]                = nil
        @data[:carteira]                = nil
        @data[:variacao_carteira]       = nil
        @data[:formatacao_convenio]     = nil
        @data[:formatacao_nosso_numero] = "2"
        @data[:identificacao]           = nil
        @data[:cpf_cnpj]                = nil
        @data[:endereco]                = nil
        @data[:cidade_uf]               = nil
        @data[:cedente]                 = nil
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
      def formata_numero number, loop, insert, type=nil
        type ||= "geral"
        number = number.to_s
        if type == "geral"
          number.sub! ",",""
          while number.length < loop
            number = "#{insert}#{number}"
          end
        end
        if type == "valor"
          number.sub! ",",""
          while number.length < loop
            number = "#{insert}#{number}"
          end
        end
        if type == "convenio"
          while number.length < loop
            number = "#{number}#{insert}"
          end
        end
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
      def fbarcode valor

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

        ##//Desenho da barra
        ##//Guarda inicial

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
        _return << %`<img src="/assets/boleto_br/p.png" width="1" height="#{altura}" border="0" />`
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