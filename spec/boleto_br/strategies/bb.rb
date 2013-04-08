require "spec_helper"

describe BoletoBr::Strategies::BB do

  before do
    @commom = BoletoBr::Strategies::BB.new
    @commom.data_vencimento         = Date.today + ( 5 )
    @commom.valor_boleto            = "2950,00"
    @commom.agencia                 = "9999"  # Num da agencia, sem digito
    @commom.conta                   = "99999" # Num da conta, sem digito
    @commom.nosso_numero            = "87654"
    @commom.data[:numero_documento] = "27.030195.10"
    @commom.data[:sacado]           = "Nome do seu Cliente"
    @commom.data[:endereco1]        = "Endereco do seu Cliente"
    @commom.data[:endereco2]        = "Cidade - Estado -  CEP: 00000-000"

    #// INFORMACOES PARA O CLIENTE
    @commom.data[:demonstrativo1] = "Conteudo 1"
    @commom.data[:demonstrativo2] = "Conteudo 2"
    @commom.data[:demonstrativo3] = "Boleto BR - baseado no BoletoPHP"

    #// INSTRUÇÕES PARA O CAIXA
    @commom.data[:instrucoes1] = "instrucao 1"
    @commom.data[:instrucoes2] = "instrucao 2"
    @commom.data[:instrucoes3] = "instrucao 3"
    @commom.data[:instrucoes4] = "instrucao 4"

    #// DADOS OPCIONAIS DE ACORDO COM O BANCO OU CLIENTE
    @commom.data[:quantidade]     = "10"
    @commom.data[:valor_unitario] = "10"
    @commom.data[:aceite]         = "N"
    @commom.data[:especie]        = "R$"
    @commom.data[:especie_doc]    = "DM"

    #// DADOS DA SUA CONTA - BANCO DO BRASIL


    @commom.data[:convenio]                = 7777777 # Num do convênio - REGRA: 6 ou 7 ou 8 dígitos
    @commom.data[:contrato]                = 999999  # Num do seu contrato
    @commom.data[:carteira]                = 18
    @commom.data[:variacao_carteira]       = "-019"  # Variação da Carteira, com traço (opcional)
    @commom.data[:formatacao_convenio]     = "7"
    @commom.data[:formatacao_nosso_numero] = "2"
    @commom.setup do end
  end

  describe "Testando existencias dos metodos necessarios" do
    it "deve possuir o metodo setup" do
      @commom.respond_to?(:setup).should be_true
    end

    it "deve possuir o metodo get_data" do
      @commom.respond_to?(:get_data).should be_true
    end

    it "deve possuir o metodo set_data" do
      @commom.respond_to?(:set_data).should be_true
    end

    it "deve possuir o metodo formata_numero" do
      @commom.respond_to?(:formata_numero).should be_true
    end

    it "deve possuir o metodo date_today" do
      @commom.respond_to?(:date_today).should be_true
    end

    it "deve possuir o metodo generate_hash_barcode" do
      @commom.respond_to?(:generate_hash_barcode).should be_true
    end

    it "deve possuir o metodo barcode_html" do
      @commom.respond_to?(:barcode_html).should be_true
    end

    it "deve possuir o metodo esquerda" do
      @commom.respond_to?(:esquerda).should be_true
    end

    it "deve possuir o metodo direita" do
      @commom.respond_to?(:direita).should be_true
    end

    it "deve possuir o metodo formatacao_8" do
      @commom.respond_to?(:formatacao_8).should be_true
    end

    it "deve possuir o metodo formatacao_7" do
      @commom.respond_to?(:formatacao_7).should be_true
    end

    it "deve possuir o metodo formatacao_6" do
      @commom.respond_to?(:formatacao_6).should be_true
    end

    it "deve possuir o metodo modulo_10" do
      @commom.respond_to?(:modulo_10).should be_true
    end

    it "deve possuir o metodo modulo_11" do
      @commom.respond_to?(:modulo_11).should be_true
    end

    it "deve possuir o metodo monta_linha_digitavel" do
      @commom.respond_to?(:monta_linha_digitavel).should be_true
    end

    it "deve possuir o metodo gera_codigo_banco" do
      @commom.respond_to?(:gera_codigo_banco).should be_true
    end
  end

  describe "Testando os valores padrao" do

    it "deve ter pre-configurado o numero do banco" do
      expect(@commom.codigo_banco).to eql "001"
    end

    it "deve ter pre-configurado o numero da moeda" do
      expect(@commom.num_moeda).to eql "9"
    end

    it "deve ter pre-configurado o valor do livre_zeros" do
      expect(@commom.livre_zeros).to eql "000000"
    end

  end

  describe "Testando os valores gerados pelo 'setup'" do

    it "deve gerar o conteudo do codigo do banco com o dv" do
      expect(@commom.codigo_banco_com_dv).to eql "001-9"
    end

    it "deve modificar o valor do boleto para o padrao do boleto" do
      expect(@commom.valor_boleto).to eql "0000295000"
    end

    it "deve modificar a agencia para o formato do boleto" do
      expect(@commom.agencia).to eql "9999"
    end

    it "deve modificar a conta para o formato do boleto" do
      expect(@commom.conta).to eql "00099999"
    end

    it "deve gerar o conteudo da 'agencia_codigo'" do
      expect(@commom.agencia_codigo).to eql "9999-6 / 00099999-7"
    end

    it "deve modificar o conteudo do nosso numero" do
      expect(@commom.nosso_numero).to eql "77777770000087654"
    end

    it "deve gerar o conteudo do fator do vencimento" do
      expect(@commom.fator_vencimento).to eql "5664"
    end

    it "deve gerar o conteudo da linha" do
      expect(@commom.linha).to eql "00192566400002950000000007777777000008765418"
    end

    it "deve gerar o conteudo do 'dv'" do
      expect(@commom.dv).to eql 2
    end

    it "deve gerar a linha digitavel" do
      expect(@commom.get_data :linha_digitavel).to eql "00190.00009 07777.777009 00087.654182 2 56640000295000"
    end

    it "deve gerar o hash do codigo de barras, atraves das informacoes cadastradas" do
      expect_value = [{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 1, height: 50},
                      { color: "p", width: 3, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 3, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50},{ color: "b", width: 3, height: 50},
                      { color: "p", width: 3, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 3, height: 50},{ color: "b", width: 1, height: 50},{ color: "p", width: 1, height: 50}]
      expect(@commom.generate_hash_barcode).to eql expect_value
    end



  end

end