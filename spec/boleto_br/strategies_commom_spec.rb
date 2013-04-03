require "spec_helper"

describe BoletoBr::Strategies::Commom do
  before do
    @commom = BoletoBr::Strategies::Commom.new
  end

   describe "Testando a existencia das variaveis padroes dos boeltos" do
     it "deve conseguir setar pelo metodo setup a variavel data_venc" do
       data_venc = Date.today
       @commom.setup { |c| c.data_venc = data_venc }
       @commom.data_venc.should eql data_venc
     end

     it "deve conseguir setar pelo metodo setup a variavel valor_boleto" do
       valor = "123,00"
       @commom.setup { |c| c.valor_boleto = valor }
       @commom.valor_boleto.should eql valor
     end

     it "deve conseguir setar pelo metodo setup a variavel codigo_banco" do
       value = "001"
       @commom.setup { |c| c.codigo_banco = value }
       @commom.codigo_banco.should eql value
     end

     it "deve conseguir setar pelo metodo setup a variavel agencia" do
       value = "123"
       @commom.setup { |c| c.agencia = value }
       @commom.agencia.should eql value
     end

     it "deve conseguir setar pelo metodo setup a variavel agencia" do
       value = "123"
       @commom.setup { |c| c.agencia = value }
       @commom.agencia.should eql value
     end
   end
end