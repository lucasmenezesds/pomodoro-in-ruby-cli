# frozen_string_literal: true

require 'rspec'
require_relative '../../../lib/pirb_cli/components/notifier'

# rubocop: disable RSpec/SubjectStub
describe PirbCli::Components::Notifier do
  subject(:notifier) { described_class.new }

  let(:notify_mock) { GirFFI::Builder.build_module 'Notify', nil }

  before do
    allow(GirFFI).to receive(:setup).and_return(notify_mock)
    allow(notify_mock).to receive(:init)
  end

  describe '#initialize' do
    it 'sets up GirFFI and initializes Notify' do
      expect(GirFFI).to receive(:setup).with(:Notify)
      expect(Notify).to receive(:init).with('Pomodoro Timer')

      notifier
    end
  end

  describe '#notify' do
    before do
      allow(notifier).to receive(:play_sound)
      allow(notifier).to receive(:show)
    end

    it 'plays sound and shows notification' do
      expect(notifier).to receive(:play_sound).with(type: 'focus')
      expect(notifier).to receive(:show).with(type: 'focus')

      notifier.notify(type: 'focus')
    end
  end

  describe '#show' do
    let(:notification_double) { instance_double(Notify::Notification, show: nil) }

    before do
      allow(Notify::Notification).to receive(:new).and_return(notification_double)
    end

    it 'creates and shows a notification' do
      expect(Notify::Notification).to receive(:new).with('Focus Time', 'Time to Rest!', 'dialog-information')
      expect(notification_double).to receive(:show)

      notifier.show(type: 'focus')
    end
  end

  describe '#play_sound' do
    before do
      allow(notifier).to receive(:`).with(any_args) # To prevent actual system calls
    end

    context 'when there is focus_notification.wav' do
      before do
        allow(File).to receive(:exist?).and_return(true)
      end

      it 'plays the correct sound file for the focus type' do
        current_os = notifier.instance_variable_get(:@os)
        play_cmd = described_class::PLAY_COMMANDS[current_os]
        expected_command = "#{play_cmd} media/rest_notification.wav > /dev/null  2>&1"

        expect(notifier).to receive(:`).with(expected_command)

        notifier.play_sound(type: 'focus')
      end
    end

    context 'when there is only notification.wav' do
      before do
        allow(File).to receive(:exist?).and_return(false)
      end

      it 'plays the correct sound file for the short_break type' do
        current_os = notifier.instance_variable_get(:@os)
        play_cmd = described_class::PLAY_COMMANDS[current_os]
        expected_command = "#{play_cmd} media/notification.wav > /dev/null  2>&1"

        expect(notifier).to receive(:`).with(expected_command)

        notifier.play_sound(type: 'short_break')
      end
    end
  end
end
# rubocop: enable RSpec/SubjectStub
