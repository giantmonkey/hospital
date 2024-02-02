require_relative "base"

module Hospital
  module Formatter
    class Shell < Base
      def put_group_header text
        @buffer << text
      end

      def put_summary errors_count, warnings_count
        puts <<~END

          #{"Summary:".h1}
          #{"Errors:   #{errors_count}".red}
          #{"Warnings: #{warnings_count}".yellow}
        END
      end
    end
  end
end
