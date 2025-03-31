require_relative "base"

using StringFormatter

module Hospital
  module Formatter
    class Shell < Base
      def put_group_header text
        @buffer << "\n### #{text}".h1
      end

      def put_diagnosis_header text
        @buffer << "\nChecking #{text.h2.indented}"
      end

      def put_diagnosis_skipped text
        @buffer << "\nSkipped #{text.h2.indented}"
      end

      def put_summary errors_count, warnings_count
        @buffer <<  <<~END

          #{"Summary:".h1}
          #{"Errors:   #{errors_count}".red}
          #{"Warnings: #{warnings_count}".yellow}
        END
      end

      def put_diagnosis_result text
        @buffer << "\n#{text.indented}"
      end

    end
  end
end
