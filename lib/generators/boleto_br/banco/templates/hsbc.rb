
def hsbc
  @boleto = BoletoBr::Strategies::HSBC.new
  @boleto.setup do |config|
    config.data_venc = Date.today + 5.days
    config.valor_boleto = number_to_currency "1250,00", unit: "", separator: ",", delimiter: ""
    config.data[:nosso_numero]     = 87654
    config.data[:numero_documento] = 123456789
    config.data[:sacado] = "Nome do seu Cliente"
    config.data[:endereco1] = "Endereco do seu Cliente"
    config.data[:endereco2] = "Cidade - Estado -  CEP: 00000-000"

    #// INFORMACOES PARA O CLIENTE
    config.data[:demonstrativo1] = "Conteudo 1"
    config.data[:demonstrativo2] = "Conteudo 2"
    config.data[:demonstrativo3] = "Boleto BR - baseado no BoletoPHP"

    #// INSTRUCOES PARA O CAIXA
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

    #// DADOS DA SUA CONTA
    config.data[:agencia] = "9999"  #// Num da agencia, sem digito
    config.data[:conta] = "99999" 	#// Num da conta, sem digito

    #// DADOS PERSONALIZADOS - HSBC
    config.data[:codigo_cedente] = "1122334" # Codigo do Cedente (Somente 7 digitos)
    config.data[:carteira]       = "CNR"     # Codigo da Carteira
  end
end