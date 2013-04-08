module BoletoBr
  module Support
    module String
      def to_number
        123123
      end
    end
  end
end

[ String ].each do |_class|
  _class.class_eval { include BoletoBr::Support::String }
end