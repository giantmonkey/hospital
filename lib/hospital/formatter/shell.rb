require_relative "base"

using StringFormatter

module Hospital
  module Formatter
    class Shell < Base
      def put_group_header text
        @buffer << text
      end

      def put_diagnosis_header text
        @buffer << text
      end

      def put_summary errors_count, warnings_count
        @buffer <<  <<~END

          #{"Summary:".h1}
          #{"Errors:   #{errors_count}".red}
          #{"Warnings: #{warnings_count}".yellow}
        END
      end

    end
  end
end
