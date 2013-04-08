

  def bb
    @boleto = BoletoBr::Strategies::BB.new
    @boleto.setup do |config|
      config.data_vencimento     = Date.today + ( 5 )
      config.valor_boleto        = "2950,00"
      config.agencia             = "9999"  # Num da agencia, sem digito
      config.conta               = "99999" # Num da conta, sem digito
      config.nosso_numero        = "87654"
      config.set_data :numero_documento , "27.030195.10"
      config.set_data :sacado           , "Nome do seu Cliente"
      config.set_data :endereco1        , "Endereco do seu Cliente"
      config.set_data :endereco2        , "Cidade - Estado -  CEP: 00000-000"

      #// INFORMACOES PARA O CLIENTE
      config.set_data :demonstrativo1, "Conteudo 1"
      config.set_data :demonstrativo2, "Conteudo 2"
      config.set_data :demonstrativo3, "Boleto BR - baseado no BoletoPHP"

      #// INSTRUÇÕES PARA O CAIXA
      config.set_data :instrucoes1, "instrucao 1"
      config.set_data :instrucoes2, "instrucao 2"
      config.set_data :instrucoes3, "instrucao 3"
      config.set_data :instrucoes4, "instrucao 4"

      #// DADOS OPCIONAIS DE ACORDO COM O BANCO OU CLIENTE
      config.set_data :quantidade     , "10"
      config.set_data :valor_unitario , "10"
      config.set_data :aceite         , "N"
      config.set_data :especie        , "R$"
      config.set_data :especie_doc    , "DM"

      #// DADOS DA SUA CONTA - BANCO DO BRASIL

      config.set_data :convenio                , 7777777 # Num do convênio - REGRA: 6 ou 7 ou 8 dígitos
      config.set_data :contrato                , 999999  # Num do seu contrato
      config.set_data :carteira                , 18
      config.set_data :variacao_carteira       , "-019"  # Variação da Carteira, com traço (opcional)
      config.set_data :formatacao_convenio     , "7"
      config.set_data :formatacao_nosso_numero , "2"
    end
  end
