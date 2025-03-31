require_relative "base"

using StringFormatter

module Hospital
  module Formatter
    class Raw < Base

      def initialize
        @data = {}
        @current_group      = nil
        @current_diagnosis  = nil
      end

      def put_group_header text
        @current_group = text
      end

      def put_diagnosis_header text
        @current_diagnosis = text
      end

      def put_diagnosis_skipped text
      end

      def put_summary errors_count, warnings_count
        @data['summary'] = {
          'errors'    => errors_count,
          'warnings'  => warnings_count
        }
      end

      def put_diagnosis_result text
        @data[@current_group] ||= {}
        @data[@current_group][@current_diagnosis] ||= []
        @data[@current_group][@current_diagnosis] << text
      end

      def result
        @data
      end
    end
  end
end
