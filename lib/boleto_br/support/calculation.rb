module BoletoBr
  module Support
    module Calculation
      # Verifica se o conteudo é um numero, retornando
      # true se for numerico e false caso contrario
      # * *Returns* :
      #   - Boolean
      def is_numeric?
        self.to_s.empty? ? false : (self.to_s =~ (/\D/)).nil?
      end
      def is_number?
        is_numeric?
      end
    end
  end
end

[String,Numeric].each do |_class|
  _class.class_eval { include BoletoBr::Support::Calculation }
end