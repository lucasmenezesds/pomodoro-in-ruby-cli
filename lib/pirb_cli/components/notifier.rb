# frozen_string_literal: true

require 'gir_ffi'

module PirbCli
  module Components
    # Desktop Notification
    class Notifier
      TYPES_DATA = {
        'focus' => {
          title: 'Focus Time',
          message: 'Time to Rest!'
        },

        'short_break' => {
          title: 'Break Time',
          message: 'Time to Focus!'
        }
      }.freeze

      def initialize
        GirFFI.setup :Notify
        Notify.init('Pomodoro Timer')
      end

      def show(type: 'focus')
        type_info = TYPES_DATA.fetch(type, {})
        title = type_info&.fetch(:title)
        message = type_info&.fetch(:message)

        notification = Notify::Notification.new(title, message, 'dialog-information')
        notification.show
      end
    end
  end
end
