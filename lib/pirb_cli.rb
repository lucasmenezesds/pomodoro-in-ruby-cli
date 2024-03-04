# frozen_string_literal: true

require_relative 'pirb_cli/version'
require_relative 'pirb_cli/components'

# PomodoroInRuby-CLI
module PirbCli
  include Components

  # Pomodoro Timer
  class PomodoroTimer
    include Components

    def initialize
      @prompt = Prompt.new
      @number_of_cycles = 0
      @current_cycle = 0
    end

    def start
      settings = @prompt.ask_settings
      return unless settings

      @number_of_cycles = settings.fetch(:cycles)
      settings.delete(:cycles)
      @timer_bus = TimerBus.new(**settings)
      start_cycles
    rescue Interrupt
      @prompt.interrupted
    end

    def start_cycles
      until !@current_cycle.zero? && (@current_cycle % @number_of_cycles).zero?
        @timer_bus.run('focus')
        @prompt.start_next_timer?
        @timer_bus.run('short_break')
        @current_cycle += 1

        if (@current_cycle % @number_of_cycles).zero?
          @prompt.congratulate(@current_cycle)
        else
          @prompt.start_next_timer?
        end

      end
    end
  end
end
