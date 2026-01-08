require_relative "base"

using StringFormatter

module Hospital
  module Formatter
    class Raw < Base

      def initialize
        @data               = {}
        @current_group      = nil
        @current_diagnosis  = nil
      end

      def put_group_header text
        @current_group = text
        @data[@current_group] ||= {}
      end

      def put_diagnosis_header text
        @current_diagnosis = text
        @data[@current_group][@current_diagnosis] ||= []
      end

      def put_diagnosis_skipped text, verbose: false
        # don't overwrite existing entry (in case of name collision)
        @data[@current_group][text] ||= { 'skipped' => true }
      end

      def put_summary errors_count, warnings_count, infos_count
        @data['summary'] = {
          'errors'   => errors_count,
          'warnings' => warnings_count,
          'infos'    => infos_count
        }
      end

      def put_diagnosis_result result
        @data[@current_group][@current_diagnosis] << {
          'type'    => result.type,
          'message' => result.message
        }
      end

      def result
        @data
      end
    end
  end
end
