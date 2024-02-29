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
        timer_settings[:focus_time] = @prompt.ask('Focus Time? (Minutes)', convert: :int, default: 25)
        timer_settings[:short_break] = @prompt.ask('Short Resting Time? (Minutes)', convert: :int, default: 5)
        timer_settings[:long_break] = @prompt.ask('Long Resting Time? (Minutes)', convert: :int, default: 20)

        timer_settings
      end

      def draw_help
        puts draw_exit_command
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

      def draw_box_frame_with_title(top_left_msg, box_message)
        TTY::Box.frame(width: 30, title: { top_left: top_left_msg }, padding: [1, 0]) do
          box_message
        end
      end

      def draw_box_frame_without_title(box_message)
        TTY::Box.frame(width: 30, padding: [1, 0], align: :center) do
          box_message
        end
      end

      def draw_cycle
        top_left_msg = '1 Cycle'
        box_message = '1 Focus Time + 1 Short Rest'
        draw_box_frame_with_title(top_left_msg, box_message)
      end

      def draw_full_cycle
        box_message = '4 Cycles + Long Rest'
        top_left_msg = 'Full Cycle'
        draw_box_frame_with_title(box_message, top_left_msg)
      end

      def draw_default_settings
        top_left_msg = 'Default Settings'
        box_message = "Cycles: 4\nFocus Time: 25 min\nShort Rest: 05 min\nLong  Rest: 20 min"
        draw_box_frame_with_title(top_left_msg, box_message)
      end

      def draw_bye_bye
        TTY::Box.frame(width: 30, padding: 1, align: :center) do
          'Bye Bye!'
        end
      end

      def draw_congratulate(cycles)
        box_message = "Congratulations!\n\nYou did #{cycles} cycles!\n\nSee you!"
        draw_box_frame_without_title(box_message)
      end

      def draw_interrupt
        box_message = "It seems you want to leave...\n\nBye Bye!"
        draw_box_frame_without_title(box_message)
      end

      def draw_exit_command
        top_left_msg = 'To quit anytime'
        box_message = 'CTRL + C'
        draw_box_frame_with_title(top_left_msg, box_message)
      end
    end
  end
end
