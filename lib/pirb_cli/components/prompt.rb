# frozen_string_literal: true

require 'tty-prompt'
require 'tty-box'

module PirbCli
  module Components
    # Commands prompt
    class Prompt
      def initialize
        @prompt = TTY::Prompt.new(help_color: :cyan)
      end

      def ask_settings
        choices = %w[yes no help quit]
        settings_opt = @prompt.enum_select('Use default settings?', choices, default: 1)

        case settings_opt
        when 'yes'
          { cycles: 4, focus_time: 25, short_break: 5, long_break: 20 }
        when 'help'
          draw_help
          ask_settings
        when 'no'
          set_timer
        else
          puts draw_bye_bye
          false
        end
      end

      def set_timer
        timer_settings = {}

        timer_settings[:cycles] = @prompt.ask('Number of Cycles?', convert: :int, default: 4)
        timer_settings[:focus_time] = @prompt.ask('Focus Time?', convert: :int, default: 25)
        timer_settings[:short_break] = @prompt.ask('Short Resting Time?', convert: :int, default: 5)
        timer_settings[:long_break] = @prompt.ask('Long Resting Time?', convert: :int, default: 20)

        timer_settings
      end

      def draw_help
        puts draw_cycle
        puts draw_full_cycle
        puts draw_default_settings
      end

      def start_next_timer?
        @prompt.keypress('Press [space] or [enter] to start the next timer', keys: %i[space return])
      end

      def congratulate(cycles)
        puts draw_congratulate(cycles)
      end

      def interrupted
        puts "\n"
        puts draw_interrupt
      end

      private

      def draw_cycle
        TTY::Box.frame(width: 30, title: { top_left: '1 Cycle' }, padding: [1, 0]) do
          '1 Focus Time + 1 Short Rest'
        end
      end

      def draw_full_cycle
        TTY::Box.frame(width: 30, title: { top_left: 'Full Cycle' }, padding: [1, 0]) do
          '4 Cycles + Long Rest'
        end
      end

      def draw_default_settings
        TTY::Box.frame(width: 30, title: { top_left: 'Default Settings' }, padding: [1, 0]) do
          "Cycles: 4\nFocus Time: 25 min\nShort Rest: 05 min\nLong  Rest: 20 min"
        end
      end

      def draw_bye_bye
        TTY::Box.frame(width: 30, padding: 1, align: :center) do
          'Bye Bye!'
        end
      end

      def draw_congratulate(cycles)
        TTY::Box.frame(width: 30, padding: [1, 0], align: :center) do
          "Congratulations!\n\nYou did #{cycles} cycles!\n\nSee you!"
        end
      end

      def draw_interrupt
        TTY::Box.frame(width: 30, padding: [1, 0], align: :center) do
          "It seems you want to leave...\n\nBye Bye!"
        end
      end
    end
  end
end
