require "spec_helper"

describe BoletoBr::Strategies::Commom do
  before do
    @commom = BoletoBr::Strategies::Commom.new
  end

   describe "Testando as variaveis padrao da classe" do
     it "deve conter um objeto data que deve possuir alguns parametros pre-definidos" do
       @commom.data.present?.should be_true
       @commom.data[:aceite        ].present?.should be_true
       @commom.data[:especie       ].present?.should be_true
       @commom.data[:especie_doc   ].present?.should be_true
       @commom.data[:quantidade    ].present?.should be_true
       @commom.data[:valor_unitario].present?.should be_true
     end
   end

  describe "Testando os metodos de instancia da classe" do

    it "deve poder recuperar o conteudo de dentro da variavel data" do
      @commom.get_data(:aceite).should eql @commom.data[:aceite]
    end

    it "deve poder setar o conteudo existente de dentro da variavel data" do
      old_value = @commom.get_data(:aceite)
      @commom.set_data :aceite, "new value"
      @commom.get_data(:aceite).should_not eql old_value
    end

    it "deve poder setar um novo conteudo dentro da variavel data" do
      @commom.set_data :new_value, "new value"
      @commom.get_data(:new_value).should eql "new value"
    end

    it "deve possuir um metodo 'setup' que deve poder setar novamente todas as variaveis" do
      _1 = @commom.conta
      _2 = @commom.dv
      _3 = @commom.valor_boleto
      _4 = @commom.get_data :especie
      @commom.setup do |config|
        config.conta        = "new1"
        config.dv           = "new2"
        config.valor_boleto = "new3"
        config.set_data :especie, "new4"
      end
      @commom.conta.should_not              eql _1
      @commom.dv.should_not                 eql _2
      @commom.valor_boleto.should_not       eql _3
      @commom.get_data(:especie).should_not eql _4
    end

    it "deve possuir um metodo para formatar os numeros" do
      value = "1.250,00 "
      opts  = { loop: 10, insert: :"0" }
      _return = "0000125000"
      @commom.formata_numero(value, opts).should eql _return
    end

    it "deve retornar a data do dia no formato padrao cadastrado no modulo principal, e enviado" do
      date       = Date.today
      new_format = "%Y%m%d"
      @commom.date_today.should eql date.strftime( BoletoBr::date_format )
      @commom.date_today( new_format ).should eql date.strftime( new_format )
    end

    it "deve possuir uma funcao para recuperar caracteres da esquerda para a direita" do
      @commom.esquerda("123456789",4).should eql "1234"
    end

    it "deve possuir uma funcao para recuperar caracteres da direita para a esquerda" do
      @commom.direita("123456789",4).should eql "6789"
    end

    it "deve poder gerar um Hash com os valores para impressao do codigo da barras" do
      expected_value = [{color:"p", width:1, height:50},
                        {color:"b", width:1, height:50},
                        {color:"p", width:1, height:50},
                        {color:"b", width:1, height:50},
                        {color:"p", width:3, height:50},
                        {color:"b", width:1, height:50},
                        {color:"p", width:1, height:50},
                        {color:"b", width:3, height:50},
                        {color:"p", width:1, height:50},
                        {color:"b", width:3, height:50},
                        {color:"p", width:1, height:50},
                        {color:"b", width:1, height:50},
                        {color:"p", width:3, height:50},
                        {color:"b", width:1, height:50},
                        {color:"p", width:3, height:50},
                        {color:"b", width:1, height:50},
                        {color:"p", width:1, height:50}]
      @commom.set_data :codigo_barras, "16"
      @commom.generate_hash_barcode.should       eql expected_value
      @commom.generate_hash_barcode("16").should eql expected_value
    end

    it "deve poder gerar codigo de barras atraves da data(:barcode), ou valor passado" do
      hash = [{color:"p", width:1, height:50},
              {color:"p", width:3, height:50},
              {color:"b", width:1, height:50},
              {color:"b", width:3, height:50}]
      expect_value = "<img src=\"/assets/boleto_br/p.png\" width=\"1\" height=\"50\" border=\"0\" />" <<
                     "<img src=\"/assets/boleto_br/p.png\" width=\"3\" height=\"50\" border=\"0\" />" <<
                     "<img src=\"/assets/boleto_br/b.png\" width=\"1\" height=\"50\" border=\"0\" />" <<
                     "<img src=\"/assets/boleto_br/b.png\" width=\"3\" height=\"50\" border=\"0\" />"
      expect{ @commom.barcode_html(321) }.to raise_error "Valor enviado e de formato invalido"
      @commom.barcode_html(hash).should eql expect_value
      #@commom.fbarcode.should eql "<img src=imagens/p.png width=1 height=50 border=0><img src=imagens/b.png width=1 height=50 border=0><img src=imagens/p.png width=1 height=50 border=0><img src=imagens/b.png width=1 height=50 border=0><img src=imagens/p.png width=3 height=50 border=0><img src=imagens/b.png width=1 height=50 border=0><img src=imagens/p.png width=1 height=50 border=0><img src=imagens/b.png width=3 height=50 border=0><img src=imagens/p.png width=1 height=50 border=0><img src=imagens/b.png width=3 height=50 border=0><img src=imagens/p.png width=1 height=50 border=0><img src=imagens/b.png width=1 height=50 border=0><img src=imagens/p.png width=3 height=50 border=0><img src=imagens/b.png width=1 height=50 border=0><img src=imagens/p.png width=3 height=50 border=0><img src=imagens/b.png width=1 height=50 border=0><img src=imagens/p.png width=1 height=50 border=0>"
    end

  end
end