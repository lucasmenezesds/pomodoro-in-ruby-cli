# frozen_string_literal: true

require 'rspec'

# rubocop: disable RSpec/SubjectStub
describe PirbCli::Components::Prompt do
  subject(:prompt) { described_class.new }

  let(:tty_prompt) { instance_double(TTY::Prompt) }

  before do
    allow(TTY::Prompt).to receive(:new).and_return(tty_prompt)
  end

  describe '#initialize' do
    it 'creates an instance with cyan help color' do
      expect(TTY::Prompt).to receive(:new).with(help_color: :cyan)

      prompt
    end
  end

  describe '#ask_settings' do
    before do
      allow(tty_prompt).to receive(:enum_select).and_return(*user_choice)
    end

    context 'when the user chooses yes' do
      let(:user_choice) { 'yes' }

      it 'returns default settings' do
        expect(prompt.ask_settings).to eq({ cycles: 4, focus_time: 25, short_break: 5, long_break: 20 })
      end
    end

    context 'when the user chooses no' do
      let(:user_choice) { 'no' }

      it 'calls set_timer' do
        allow(prompt).to receive(:set_timer)
        expect(prompt).to receive(:set_timer)

        prompt.ask_settings
      end
    end

    context 'when the user chooses help' do
      let(:user_choice) { %w[help yes] }

      it 'calls draw_help and ask_settings' do
        allow(prompt).to receive(:puts)

        expect(TTY::Box).to receive(:frame).exactly(4)
        expect(prompt).to receive(:draw_help).exactly(1).and_call_original
        expect(prompt).to receive(:ask_settings).exactly(2).and_call_original # 1 for help other for yes

        prompt.ask_settings
      end
    end

    context 'when the user chooses quit' do
      let(:user_choice) { 'quit' }

      it 'calls draw_bye_bye' do
        allow(prompt).to receive(:puts)

        expect(TTY::Box).to receive(:frame).exactly(1)
        expect(prompt).to receive(:draw_bye_bye).exactly(1).and_call_original

        result = prompt.ask_settings

        expect(result).to be_falsey
      end
    end
  end

  describe '#set_timer' do
    let(:timer_values) { [4, 25, 5, 20] }

    before do
      allow(tty_prompt).to receive(:ask).and_return(*timer_values)
    end

    it 'asks for timer settings and returns a hash with its values' do
      expect(prompt.set_timer).to eq({ cycles: 4, focus_time: 25, short_break: 5, long_break: 20 })
    end
  end

  describe '#congratulate' do
    it 'calls draw_box_frame_without_title when called' do
      allow(prompt).to receive(:puts)

      expect(TTY::Box).to receive(:frame).with(width: 30, padding: [1, 0], align: :center).exactly(1)

      prompt.congratulate(2)
    end
  end

  describe '#interrupted' do
    it 'calls draw_box_frame_without_title when called' do
      allow(prompt).to receive(:puts)

      expect(TTY::Box).to receive(:frame).with(width: 30, padding: [1, 0], align: :center).exactly(1)

      prompt.interrupted
    end
  end
end
# rubocop: enable RSpec/SubjectStub
