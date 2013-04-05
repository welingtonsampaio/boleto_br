module BoletoBr
  module Strategies
    class HSBC < BoletoBr::Strategies::Commom

      def initialize
        super
        @codigo_banco = "399"
        @num_moeda    = "9"
      end

      def setup
        super
        @codigo_banco_com_dv  = geraCodigoBanco codigo_banco
        @fator_vencimento     = (Date.new(1997, 10, 7).jd - data_vencimento.jd).abs
        @valor                = formata_numero String.new(valor_boleto), 10, 0, "valor"
        @carteira             = @data[:carteira]
        @codigo_cedente       = formata_numero String.new(@data[:codigo_cedente]), 7, 0
        @documento            = String.new @data[:numero_documento].to_s

        #// número do documento (sem dvs) é 13 digitos
        @nnum = formata_numero @data[:numero_documento],13,0
        #// nosso número (com dvs) é 16 digitos
        @nosso_numero = HSBC::gera_nosso_numero @nnum, @codigocedente, @data_venc.strftime(BoletoBr::date_format)

        @app = "2"

        #// 43 numeros para o calculo do digito verificador do codigo de barras
        @barra = "#{@codigo_banco}#{@num_moeda}#{@fator_vencimento}#{@valor}#{@codigo_cedente}#{@nnum}#{@data_venc.jd}#{@app}";
        @dv = digito_verificador_barra @barra
        #// Numero para o codigo de barras com 44 digitos
        linha= "#{@barra.slice(0,4)}#{@dv}#{@barra.slice(4,@barra.length)}"

        @agencia_codigo = @codigo_cedente;

        @data[:codigo_barras]       = linha;
        @data[:linha_digitavel]     = monta_linha_digitavel linha;
        @data[:agencia_codigo]      = agencia_codigo;
        @data[:nosso_numero]        = @nosso_numero;
        @data[:codigo_banco_com_dv] = @codigo_banco_com_dv;

        @agencia              = formata_numero @data[:agencia],       4, 0
        @conta                = formata_numero @data[:conta],         8, 0
        @agencia_codigo       = "#{@agencia}-#{modulo_11 @agencia} / #{@conta}-#{modulo_11 @conta}"
      end

      def gera_nosso_numero ndoc, cedente, venc, tipoid='4'
        ndoc = "#{ndoc}#{modulo_11_invertido(ndoc)}#{tipoid}"
        venc = "#{venc.slice(0,2)}#{venc.slice(3,2)}#{venc.slice(8,2)}"
        res  = "#{ndoc}#{cedente}#{venc}"
        "#{ndoc}#{modulo_11_invertido res}"
      end

      def digito_verificador_nosso_numero numero
        resto2 = modulo_11 numero, 9, 1
        digito = 11 - $resto2;
        dv = if digito == 10 || digito == 11 then 0 else digito end
        dv
      end

      def digito_verificador_barra numero
        resto2 = modulo_11 numero, 9, 1
        dv = if resto2 == 0 || resto2 == 1 || resto2 == 10 then 1 else 11 - resto2 end
        dv
      end

      def self.gera_nosso_numero ndoc, cedente, venc
        HSBC.new.gera_nosso_numero ndoc, cedente, venc
      end

    #private

      def modulo_11 num, base=9, r=0
        soma  = 0
        fator = 2
        num = num.to_s
        numeros = parcial = []

        (1..num.length).to_a.reverse.each do |i|  # Separacao dos numeros
          numeros[i] = num.slice i-1,1            # pega cada numero isoladamente
          parcial[i] = numeros[i].to_i * fator    # Efetua multiplicacao do numero pelo falor
          soma      += parcial[i]                 # Soma dos digitos
          fator = 1 if fator == base
          fator += 1
        end

        if r == 0                     # Calculo do modulo 11
          soma *= 10
          digito = soma % 11
          digito = 0 if digito == 10
          return digito
        else
          return soma % 11 if r == 1
        end
        false
      end

      # Calculo de Modulo 11 "Invertido" (com pesos de 9 a 2  e não de 2 a 9)
      def modulo_11_invertido num
        ftini = 2
        fator = ftfim = 9
        soma  = 0
        num = num.to_s

        (1..num.length).to_a.reverse.each do |i|
          soma += num.slice(i-1,1).to_i * fator
          fator = ftfim if (fator-=1) < ftini
        end

        digito = soma % 11
        digito = 0 if digito > 9
        digito
      end

      def modulo_10 num
        temp = temp0 = numtotal10 = 0
        fator      = 2
        num        = num.to_s
        numeros = parcial10 = []

        (1..num.length).to_a.reverse.each do |i|                            # Separacao dos numeros
          numeros[i] = num.slice i-1, 1                                     # pega cada numero isoladamente
          temp  = numeros[i].to_i * fator                                   # Efetua multiplicacao do numero pelo (falor 10)
          temp0 = 0                                                         # 2002-07-07 01:33:34 Macete para adequar ao Mod10 do Itaú
          (0..(temp.to_s.length-1)).each { |i| temp0 += temp.to_s[i].to_i } # temp=12 | ['1','2'] | temp0 = 1 + 2
          parcial10[i] = temp0                                              # numeros[i] * fator
          numtotal10 += parcial10[i]                                        # monta sequencia para soma dos digitos no (modulo 10)
          fator = if fator == 2 then 1 else 2 end
        end

        resto  = numtotal10 % 10  # várias linhas removidas, vide função original
        digito = 10 - resto       # Calculo do modulo 10
        digito = 0 if resto == 0
        digito
      end

      # Posição 	Conteúdo
      # 1 a 3    Número do banco
      # 4        Código da Moeda - 9 para Real
      # 5        Digito verificador do Código de Barras
      # 6 a 9    Fator de Vencimento
      # 10 a 19  Valor (8 inteiros e 2 decimais)
      #          Campo Livre definido por cada banco (25 caracteres)
      # 20 a 26  Código do Cedente
      # 27 a 39  Código do Documento
      # 40 a 43  Data de Vencimento em Juliano (mmmy)
      # 44       Código do aplicativo CNR = 2
      def monta_linha_digitavel codigo

        campo1 = "#{codigo.slice(0,4)}#{codigo.slice(19,5)}"       # 1. Campo - composto pelo código do banco, código da moéda, as cinco primeiras posições
        campo1 = "#{campo1}#{modulo_10 campo1}";                     # do campo livre e DV (modulo10) deste campo
        campo1 = "#{campo1.slice(0,5)}.#{campo1.slice(5,5)}"

        campo2 = "#{codigo.slice(24,2)}#{codigo.slice(26,8)}"      # 2. Campo - composto pelas posiçoes 6 a 15 do campo livre
        campo2 = "#{campo2}#{modulo_10 campo2}"                    # e livre e DV (modulo10) deste campo
        campo2 = "#{campo2.slice(0,5)}.#{campo2.slice(5,6)}"

        campo3 = "#{codigo.slice(34,5)}#{codigo.slice(39,4)}#{codigo.slice(43,1)}" # 3. Campo composto pelas posicoes 16 a 25 do campo livre
        campo3 = "#{campo3}#{modulo_10 campo3}"                                    # e livre e DV (modulo10) deste campo
        campo3 = "#{campo3.slice(0,5)}.#{campo3.slice(5,6)}"


        campo4 = codigo.slice 4, 1 # 4. Campo - digito verificador do codigo de barras

        # 5. Campo composto pelo fator vencimento e valor nominal do documento, sem
        # indicacao de zeros a esquerda e sem edicao (sem ponto e virgula). Quando se
        # tratar de valor zerado, a representacao deve ser 000 (tres zeros).
        campo5 = "#{codigo.slice(5, 4)}#{codigo.slice(9, 10)}"

        "#{campo1} #{campo2} #{campo3} #{campo4} #{campo5}";
      end

      def geraCodigoBanco numero
        parte1 = numero.to_s.slice 0, 3
        parte2 = modulo_11(parte1)
        "#{parte1}-#{parte2}"
      end

    end

  end
end