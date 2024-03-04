# frozen_string_literal: true

require 'gir_ffi'

module PirbCli
  module Components
    # Desktop Notification
    class Notifier
      PLAY_COMMANDS = {
        macos: 'afplay',
        linux: 'aplay'
      }.freeze

      TYPES_DATA = {
        'focus' => {
          title: 'Focus Time',
          message: 'Time to Rest!',
          sound_name: 'rest_notification.wav'
        },

        'short_break' => {
          title: 'Break Time',
          message: 'Time to Focus!',
          sound_name: 'focus_notification.wav'
        }
      }.freeze

      def initialize
        set_os
        GirFFI.setup :Notify
        Notify.init('Pomodoro Timer')
      end

      def notify(type: 'focus')
        play_sound(type: type)
        show(type: type)
      end

      def show(type: 'focus')
        title = TYPES_DATA.dig(type, :title)
        message = TYPES_DATA.dig(type, :message)

        notification = Notify::Notification.new(title, message, 'dialog-information')
        notification.show
      end

      def play_sound(type: 'focus')
        selected_notification = TYPES_DATA.dig(type, :sound_name)
        notification_path = File.join('media', selected_notification)
        notification_path = File.join('media', 'notification.wav') unless File.exist?(notification_path)
        stdout_suppressor = '> /dev/null  2>&1' # if you want to show the stdout and stderr remove this line/variable

        `#{PLAY_COMMANDS[@os]} #{notification_path} #{stdout_suppressor}`
      end

      def set_os
        @os = case RbConfig::CONFIG['host_os']
              when /darwin/ # macOS
                :macos
              when /linux/ # Linux
                :linux
              else
                raise 'Unsupported operating system' # :unsupported
              end
      end
    end
  end
end
