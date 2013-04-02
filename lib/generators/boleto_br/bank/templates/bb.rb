
  def bb
    valor = "1250,00"
    @boleto = BoletoBr::Strategies::BB.new
    @boleto.setup do |config|
      config.data_venc = Date.today + 5.days
      config.valor_boleto = number_to_currency valor, unit: "", separator: ",", delimiter: ""
      config.data[:nosso_numero]     = 87654
      config.data[:numero_documento] = "123456789"
      config.data[:sacado] = "Nome do seu Cliente"
      config.data[:endereco1] = "Endereco do seu Cliente"
      config.data[:endereco2] = "Cidade - Estado -  CEP: 00000-000"

      #// INFORMACOES PARA O CLIENTE
      config.data[:demonstrativo1] = "Conteudo 1"
      config.data[:demonstrativo2] = "Conteudo 2"
      config.data[:demonstrativo3] = "Boleto BR - baseado no BoletoPHP"

      #// INSTRUcÕES PARA O CAIXA
      config.data[:instrucoes1] = "instrucao 1"
      config.data[:instrucoes2] = "instrucao 2"
      config.data[:instrucoes3] = "instrucao 3"
      config.data[:instrucoes4] = "instrucao 4"

      #// DADOS OPCIONAIS DE ACORDO COM O BANCO OU CLIENTE
      config.data[:quantidade]     = "10"
      config.data[:valor_unitario] = "10"
      config.data[:aceite]         = "N"
      config.data[:especie]        = "R$"
      config.data[:especie_doc]    = "DM"

      #// DADOS DA SUA CONTA - BANCO DO BRASIL
      config.data[:agencia] = "9999" #// Num da agencia, sem digito
      config.data[:conta] = "99999" 	#// Num da conta, sem digito

      #// DADOS PERSONALIZADOS - BANCO DO BRASIL
      config.data[:convenio] = "7777777"  #// Num do convênio - REGRA: 6 ou 7 ou 8 dígitos
      config.data[:contrato] = "999999"   #// Num do seu contrato
      config.data[:carteira] = "18"
      config.data[:variacao_carteira] = "-019"  #// Variacao da Carteira, com traco (opcional)

      #// TIPO DO BOLETO
      #// REGRA: 8 p/ Convênio c/ 8 dígitos, 7 p/ Convênio c/ 7 dígitos, ou 6 se Convênio c/ 6 dígitos
      config.data[:formatacao_convenio] = "7"
      #// REGRA: Usado apenas p/ Convênio c/ 6 dígitos: informe 1 se for NossoNúmero de até 5 dígitos ou 2 para opcao de até 17 dígitos
      config.data[:formatacao_nosso_numero] = "2"

      #// SEUS DADOS
      config.data[:identificacao] = "BoletoPhp - Codigo Aberto de Sistema de Boletos"
      config.data[:cpf_cnpj]      = ""
      config.data[:endereco]      = "Coloque o endereco da sua empresa aqui"
      config.data[:cidade_uf]     = "Cidade / Estado"
      config.data[:cedente]       = "Coloque a Razao Social da sua empresa aqui"
      config.data[:valor_boleto]  = valor
    end
  end