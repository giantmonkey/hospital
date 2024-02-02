module Hospital
  module Formatter
    class Base
      attr_reader :buffer

      def initialize
        @buffer = ""
      end
    end
  end
end
