module Hospital
  module Formatter
    class Base
      def initialize
        @buffer = ""
      end

      def result
        @buffer
      end
    end
  end
end
