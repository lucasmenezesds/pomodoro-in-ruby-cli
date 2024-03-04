# frozen_string_literal: true

require_relative 'notifier'
require_relative 'progress_bar'
require_relative 'timer'

module PirbCli
  module Components
    # Timer Bus
    class TimerBus
      def initialize(focus_time:, short_break:, long_break:)
        @focus_timer = Timer.new(total_time: focus_time, type: 'focus', name: 'Focus')
        @short_break_timer = Timer.new(total_time: short_break, type: 'short_break', name: 'Short Break')
        @long_break_timer = Timer.new(total_time: long_break, type: 'long_break', name: 'Long Break')
        @notifier = PirbCli::Components::Notifier.new
      end

      def run(type)
        setup_current_timer(type)
        start_timer
        @notifier.notify(type: type)
        true
      end

      def start_timer
        until @current_timer.time.zero?
          @current_timer.tick
          @progress_bar.increment
        end
      end

      def define_current_timer(type)
        case type
        when 'short_break'
          @short_break_timer
        when 'long_break'
          @long_break_timer
        else
          @focus_timer
        end
      end

      def setup_current_timer(type)
        @current_timer = define_current_timer(type)
        @current_timer.reset
        @progress_bar = PomodoroProgressBar.new(title: @current_timer.name, total: @current_timer.total_time)
      end
    end
  end
end
