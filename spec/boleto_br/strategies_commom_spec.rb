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

    it "deve possuir um metodo 'setup' que deve poder setar novamente todas as variaveis"

    it "deve possuir um metodo para formatar os numeros" do
      value = "1.250,00 "
      opts  = { loop: 10, insert: :"0" }
      _return = "0000125000"
      @commom.formata_numero(value, opts).should eql _return
    end

  end
end