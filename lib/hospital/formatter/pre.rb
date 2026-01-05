require_relative "base"

using StringFormatter

module Hospital
  module Formatter
    class Pre < Base
      def put_group_header text
        @buffer << "\n\n### #{text}"
      end

      def put_diagnosis_header text
        @buffer << "\n\n## Checking #{text}"
      end

      def put_diagnosis_skipped text
        @buffer << "\n\n## Skipped #{text}"
      end

      def put_summary errors_count, warnings_count, infos_count
        @buffer <<  <<~END
          \n\n
          #### Summary:
          Errors:   #{errors_count}
          Warnings: #{warnings_count}
          Infos:    #{infos_count}
        END
      end

      def put_diagnosis_result result
        @buffer << "\n#{result.output}"
      end

    end
  end
end
