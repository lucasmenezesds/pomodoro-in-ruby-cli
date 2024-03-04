# frozen_string_literal: true

require 'ruby-progressbar'

module PirbCli
  module Components
    # Visual Progress Bar
    class PomodoroProgressBar
      def initialize(title: 'Focus Time', total: 0)
        @progress_bar = ProgressBar.create(format: "%a %b\u{15E7}%i %t",
                                           title: title,
                                           progress_mark: ' ',
                                           remainder_mark: "\e[0;34m\u{FF65}\e[0m",
                                           starting_at: 0,
                                           length: 55,
                                           total: total)
      end

      def increment
        @progress_bar.increment
      end
    end
  end
end
