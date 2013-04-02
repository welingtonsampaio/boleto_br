module BoletoBr
  module Strategies
    class BB < BoletoBr::Strategies::Commom

      def initialize
        super
        @codigo_banco = "001"
        @num_moeda    = "9"
        @livre_zeros  = "000000"
      end

      def setup
        super
        @codigo_banco_com_dv  = geraCodigoBanco @codigo_banco
        @fator_vencimento     = (Date.new(1997, 10, 7).jd - @data_venc.jd).abs
        @valor                = formata_numero @valor_boleto, 10, 0, "valor"
        @agencia              = formata_numero @data[:agencia],       4, 0
        @conta                = formata_numero @data[:conta],         8, 0
        @carteira             = @data[:carteira]
        @agencia_codigo       = "#{@agencia}-#{modulo_11 @agencia} / #{@conta}-#{modulo_11 @conta}"

        formatacao_8 if @data[:formatacao_convenio] == "8"
        formatacao_7 if @data[:formatacao_convenio] == "7"
        formatacao_6 if @data[:formatacao_convenio] == "6"

        @data[:codigo_barras]       = @linha
        @data[:linha_digitavel]     = monta_linha_digitavel @linha
        @data[:agencia_codigo]      = @agencia_codigo
        @data[:nosso_numero]        = @nosso_numero
        @data[:codigo_banco_com_dv] = @codigo_banco_com_dv
        @data[:data_vencimento]     = @data_venc.strftime BoletoBr::date_format
        @data[:data_documento]      = date_today
        @data[:data_processamento]  = date_today
        #@data[:valor_boleto]        = @valor_boleto

      end

    private

      def formatacao_8
        @convenio = formata_numero @data[:convenio], 8, 0, "convenio"
        #// Nosso número de até 9 dígitos
        @nosso_numero = formata_numero @data[:nosso_numero], 9, 0
        @dv           = modulo_11 "#{@codigo_banco}"     <<
                                  "#{@num_moeda}"        <<
                                  "#{@fator_vencimento}" <<
                                  "#{@valor}"            <<
                                  "#{@livre_zeros}"      <<
                                  "#{@convenio}"         <<
                                  "#{@nosso_numero}"     <<
                                  "#{@carteira}"

        @linha = "#{@codigo_banco}"     <<
            "#{@num_moeda}"        <<
            "#{@dv}"               <<
            "#{@fator_vencimento}" <<
            "#{@valor}"            <<
            "#{@livre_zeros}"      <<
            "#{@convenio}"         <<
            "#{@nosso_numero}"     <<
            "#{@carteira}"
        #//montando o nosso numero que aparecerá no boleto
        @nosso_numero = "#{@convenio}#{@nosso_numero}-#{modulo_11 "#{@convenio}#{@nosso_numero}"}"
      end

      def formatacao_7
        @convenio = formata_numero @data[:convenio], 7, 0, "convenio"
        #// Nosso número de até 9 dígitos
        @nosso_numero = formata_numero @data[:nosso_numero], 10, 0
        @dv           = modulo_11 "#{@codigo_banco}"     <<
                                  "#{@num_moeda}"        <<
                                  "#{@fator_vencimento}" <<
                                  "#{@valor}"            <<
                                  "#{@livre_zeros}"      <<
                                  "#{@convenio}"         <<
                                  "#{@nosso_numero}"     <<
                                  "#{@carteira}"

        @linha = "#{@codigo_banco}"     <<
                 "#{@num_moeda}"        <<
                 "#{@dv}"               <<
                 "#{@fator_vencimento}" <<
                 "#{@valor}"            <<
                 "#{@livre_zeros}"      <<
                 "#{@convenio}"         <<
                 "#{@nosso_numero}"     <<
                 "#{@carteira}"
        @linha;
        #//montando o nosso numero que aparecerá no boleto
        @nosso_numero = "#{@convenio}#{@nosso_numero}"
      end

      def formatacao_6
        @convenio = formata_numero @data[:convenio], 6, 0, "convenio"
        #// Nosso número de até 9 dígitos
        if @data[:formatacao_nosso_numero] == "1"
          @nosso_numero = formata_numero @data[:nosso_numero], 5, 0
          @dv           = modulo_11 "#{@codigo_banco}"     <<
                                    "#{@num_moeda}"        <<
                                    "#{@fator_vencimento}" <<
                                    "#{@valor}"            <<
                                    "#{@convenio}"         <<
                                    "#{@nosso_numero}"     <<
                                    "#{@agencia}"          <<
                                    "#{@conta}"            <<
                                    "#{@carteira}"

          @linha = "#{@codigo_banco}"     <<
                   "#{@num_moeda}"        <<
                   "#{@dv}"               <<
                   "#{@fator_vencimento}" <<
                   "#{@valor}"            <<
                   "#{@convenio}"         <<
                   "#{@nosso_numero}"     <<
                   "#{@agencia}"          <<
                   "#{@conta}"            <<
                   "#{@carteira}"
          #//montando o nosso numero que aparecerá no boleto
          @nosso_numero = "#{@convenio}#{@nosso_numero}-#{modulo_11 "#{@convenio}#{@nosso_numero}"}"
        end
        if @data[:formatacao_nosso_numero] == "2"
          nservico = "21"
          @nosso_numero = formata_numero @data[:nosso_numero], 17, 0
          @dv           = modulo_11 "#{@codigo_banco}"     <<
                                    "#{@num_moeda}"        <<
                                    "#{@fator_vencimento}" <<
                                    "#{@valor}"            <<
                                    "#{@convenio}"         <<
                                    "#{@nosso_numero}"     <<
                                    "#{nservico}"

          @linha = "#{@codigo_banco}"     <<
                   "#{@num_moeda}"        <<
                   "#{@dv}"               <<
                   "#{@fator_vencimento}" <<
                   "#{@valor}"            <<
                   "#{@convenio}"         <<
                   "#{@nosso_numero}"     <<
                   "#{nservico}"
          #//montando o nosso numero que aparecerá no boleto
          @nosso_numero = "#{@convenio}#{@nosso_numero}-#{modulo_11 "#{@convenio}#{@nosso_numero}"}"
        end
      end

      def modulo_11 num, base=9, r=0
        soma  = 0
        fator = 2
        numeros = []
        parcial = []
        num = num.to_s
        (1..num.length).to_a.reverse.each do |i|
          numeros[i] = num.slice i-1,1
          parcial[i] = numeros[i].to_i * fator
          soma += parcial[i]
          if fator == base
            fator = 1
          end
          fator += 1
        end
        if r == 0
          soma *= 10
          digito = soma % 11

          if digito == 10
            digito = "X"
          end

          if num.length == "43"
            ##//então estamos checando a linha digitável
            if digito == "0" or digito == "X" or digito > 9
              digito = 1
            end
          end
          return digito
        else
          if r == 1
            resto = soma % 11
            return resto
          end
        end
      end

      def modulo_10 num
        numtotal10 = 0
        fator = 2
        numeros = []
        parcial10 = []
        num = num.to_s

        (1..num.length).to_a.reverse.each do |i|
          numeros[i]   = num.slice i-1,1
          parcial10[i] = numeros[i].to_i * fator
          numtotal10   = "#{numtotal10}#{parcial10[i]}"
          if fator == 2
            fator = 1
          else
            fator = 2
          end
        end

        soma = 0
        numtotal10 = numtotal10.to_s
        (1..numtotal10.length).to_a.reverse.each do |i|
          numeros[i] = numtotal10.slice i-1,1
          soma += numeros[i].to_i
        end

        resto = soma % 10
        digito = 10 - resto
        digito = 0 if resto == 0
        digito
      end

      def monta_linha_digitavel linha
        #// Posição 	Conteúdo
        #// 1 a 3    Número do banco
        #// 4        Código da Moeda - 9 para Real
        #// 5        Digito verificador do Código de Barras
        #// 6 a 19   Valor (12 inteiros e 2 decimais)
        #// 20 a 44  Campo Livre definido por cada banco

        #// 1. Campo - composto pelo código do banco, código da moéda, as cinco primeiras posições
        #// do campo livre e DV (modulo10) deste campo
        p1 = linha.slice 0, 4
        p2 = linha.slice 19, 5
        p3 = modulo_10 "#{p1}#{p2}"
        p4 = "#{p1}#{p2}#{p3}"
        p5 = p4.slice 0, 5
        p6 = p4.slice 5, p4.length
        campo1 = "#{p5}.#{p6}"

        #// 2. Campo - composto pelas posiçoes 6 a 15 do campo livre
        #// e livre e DV (modulo10) deste campo
        p1 = linha.slice 24, 10
        p2 = modulo_10 p1
        p3 = "#{p1}#{p2}"
        p4 = p3.slice 0, 5
        p5 = p3.slice 5, p3.length
        campo2 = "#{p4}.#{p5}"

        #// 3. Campo composto pelas posicoes 16 a 25 do campo livre
        #// e livre e DV (modulo10) deste campo
        p1 = linha.slice 34, 10
        p2 = modulo_10 p1
        p3 = "#{p1}#{p2}"
        p4 = p3.slice 0, 5
        p5 = p3.slice 5, p3.length
        campo3 = "#{p4}.#{p5}"

        #// 4. Campo - digito verificador do codigo de barras
        campo4 = linha.slice 4, 1

        #// 5. Campo composto pelo valor nominal pelo valor nominal do documento, sem
        #// indicacao de zeros a esquerda e sem edicao (sem ponto e virgula). Quando se
        #// tratar de valor zerado, a representacao deve ser 000 (tres zeros).
        campo5 = linha.slice 5, 14

        "#{campo1} #{campo2} #{campo3} #{campo4} #{campo5}"
      end

      def geraCodigoBanco numero
        parte1 = numero.to_s.slice 0, 3
        parte2 = modulo_11(parte1)
        "#{parte1}-#{parte2}"
      end



      

    end

  end
end