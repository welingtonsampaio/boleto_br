
  def bb
    boleto = BoletoBr::Strategies::BB.new
    boleto.setup do |config|
      config.data_venc = Date.today + 5.days
      config.valor_boleto = number_to_currency "1250,00", unit: "", separator: ",", delimiter: ""
      data = {}
      data[:nosso_numero]     = 87654
      data[:numero_documento] = "123456789"
      data[:sacado] = "Nome do seu Cliente"
      data[:endereco1] = "Endereço do seu Cliente"
      data[:endereco2] = "Cidade - Estado -  CEP: 00000-000"

      #// INFORMACOES PARA O CLIENTE
      data[:demonstrativo1] = "Conteudo 1"
      data[:demonstrativo2] = "Conteudo 2"
      data[:demonstrativo3] = "Boleto BR - baseado no BoletoPHP"

      #// INSTRUÇÕES PARA O CAIXA
      data[:instrucoes1] = "instrucao 1"
      data[:instrucoes2] = "instrucao 2"
      data[:instrucoes3] = "instrucao 3"
      data[:instrucoes4] = "instrucao 4"

      #// DADOS OPCIONAIS DE ACORDO COM O BANCO OU CLIENTE
      data[:quantidade]     = "10"
      data[:valor_unitario] = "10"
      data[:aceite]         = "N"
      data[:especie]        = "R$"
      data[:especie_doc]    = "DM"

      #// DADOS DA SUA CONTA - BANCO DO BRASIL
      data[:agencia] = "9999" #// Num da agencia, sem digito
      data[:conta] = "99999" 	#// Num da conta, sem digito

      #// DADOS PERSONALIZADOS - BANCO DO BRASIL
      data[:convenio] = "7777777"  #// Num do convênio - REGRA: 6 ou 7 ou 8 dígitos
      data[:contrato] = "999999"   #// Num do seu contrato
      data[:carteira] = "18"
      data[:variacao_carteira] = "-019"  #// Variação da Carteira, com traço (opcional)

      #// TIPO DO BOLETO
      #// REGRA: 8 p/ Convênio c/ 8 dígitos, 7 p/ Convênio c/ 7 dígitos, ou 6 se Convênio c/ 6 dígitos
      data[:formatacao_convenio] = "7"
      #// REGRA: Usado apenas p/ Convênio c/ 6 dígitos: informe 1 se for NossoNúmero de até 5 dígitos ou 2 para opção de até 17 dígitos
      data[:formatacao_nosso_numero] = "2"

      #// SEUS DADOS
      data[:identificacao] = "BoletoPhp - Código Aberto de Sistema de Boletos"
      data[:cpf_cnpj]      = ""
      data[:endereco]      = "Coloque o endereço da sua empresa aqui"
      data[:cidade_uf]     = "Cidade / Estado"
      data[:cedente]       = "Coloque a Razão Social da sua empresa aqui"

      @data.merge! data
    end

  end