# frozen_string_literal: true

module PirbCli
  module Components
    # Clock Timer
    class Timer
      TIME_MULTIPLIER = 60

      attr_reader :type, :name, :time, :total_time

      def initialize(total_time:, type:, name:)
        @total_time = total_time * TIME_MULTIPLIER
        @time = @total_time
        @type = type
        @name = name
      end

      def tick
        @time -= 1
        sleep 1
      end

      def reset
        @time = @total_time
      end
    end
  end
end
