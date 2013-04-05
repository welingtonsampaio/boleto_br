module BoletobrHelper
  # @param [Date] date
  # @return [String]
  def boleto_date date
    date.strftime BoletoBr::date_format
  end
end
