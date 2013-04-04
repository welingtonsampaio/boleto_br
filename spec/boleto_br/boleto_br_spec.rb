require "spec_helper"

describe BoletoBr do

  after do
    BoletoBr::app_path      = File.expand_path('../../../app', __FILE__)
    BoletoBr::date_format   = "%d/%m/%Y"
    BoletoBr::title         = "Boleto Br"
    BoletoBr::identificacao = "Boleto Br"
    BoletoBr::cpf_cnpj      = true
    BoletoBr::endereco      = "Endereco da empresa"
    BoletoBr::cidade_uf     = "Cidade / Estado"
    BoletoBr::cedente       = "Razao social da empresa"
  end

  describe "Testando existencia das variaveis padroes da gem" do
    it "deve ter uma variavel chamada 'app_path'" do
      BoletoBr::app_path.present?.should be_true
    end
    it "deve ter uma variavel chamada 'date_format'" do
      BoletoBr::date_format.present?.should be_true
    end
    it "deve ter uma variavel chamada 'title'" do
      BoletoBr::title.present?.should be_true
    end
    it "deve ter uma variavel chamada 'identificacao'" do
      BoletoBr::identificacao.present?.should be_true
    end
    it "deve ter uma variavel chamada 'cpf_cnpj'" do
      BoletoBr::cpf_cnpj.present?.should be_true
    end
    it "deve ter uma variavel chamada 'endereco'" do
      BoletoBr::endereco.present?.should be_true
    end
    it "deve ter uma variavel chamada 'cidade_uf'" do
      BoletoBr::cidade_uf.present?.should be_true
    end
    it "deve ter uma variavel chamada 'cedente'" do
      BoletoBr::cedente.present?.should be_true
    end
  end
  describe "Testando os valores padrao das variaveis" do
    it "app_path deve conter o caminho para a pasta 'app' na raiz da gem" do
      value = File.expand_path('../../../app', __FILE__)
      BoletoBr::app_path.should eql value
    end
    it "date_format o formato padrao das datas" do
      value = "%d/%m/%Y"
      BoletoBr::date_format.should eql value
    end
    it "title deve conter o title impresso no head do layout HTML" do
      value = "Boleto Br"
      BoletoBr::title.should eql value
    end
    it "identificacao deve conter o nome ou identificador da empresa que esta emitindo o boleto" do
      value = "Boleto Br"
      BoletoBr::identificacao.should eql value
    end
    it "cpf_cnpj deve conter o documento de identificacao da pessoa ou empresa emitendo do boleto" do
      value = true
      BoletoBr::cpf_cnpj.should eql value
    end
    it "endereco deve conter o endereco da pessoa/empresa emitendo do boleto" do
      value = "Endereco da empresa"
      BoletoBr::endereco.should eql value
    end
    it "cidade_uf deve conter o nome da cidade e sigla do estado" do
      value = "Cidade / Estado"
      BoletoBr::cidade_uf.should eql value
    end
    it "cedente deve conter a razao social ou nome completo da pessoa emitente do boleto" do
      value = "Razao social da empresa"
      BoletoBr::cedente.should eql value
    end
  end
  describe "Testando os metodos estaticos do modulo" do
    it "deve possuir um metodo chamado 'setup'" do
      BoletoBr::respond_to?(:setup).should be_true
    end
    it "setup deve coseguir modificar todas as configuracoes padrao do modulo" do
      _1 = BoletoBr::app_path
      _2 = BoletoBr::date_format
      _3 = BoletoBr::title
      _4 = BoletoBr::identificacao
      _5 = BoletoBr::cpf_cnpj
      _6 = BoletoBr::endereco
      _7 = BoletoBr::cidade_uf
      _8 = BoletoBr::cedente
      BoletoBr::setup do |config|
        config.app_path      = "new1"
        config.date_format   = "new2"
        config.title         = "new3"
        config.identificacao = "new4"
        config.cpf_cnpj      = "new5"
        config.endereco      = "new6"
        config.cidade_uf     = "new7"
        config.cedente       = "new8"
      end
      BoletoBr::app_path.should_not eql _1
      BoletoBr::date_format.should_not eql _2
      BoletoBr::title.should_not eql _3
      BoletoBr::identificacao.should_not eql _4
      BoletoBr::cpf_cnpj.should_not eql _5
      BoletoBr::endereco.should_not eql _6
      BoletoBr::cidade_uf.should_not eql _7
      BoletoBr::cedente.should_not eql _8
    end
  end
  it "deve conter uma versao" do
    BoletoBr::VERSION.present?.should be_true
  end
end