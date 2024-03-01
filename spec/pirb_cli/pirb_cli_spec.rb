# frozen_string_literal: true

# rubocop: disable RSpec/SubjectStub
RSpec.describe PirbCli do
  subject(:pomodoro_timer) { PirbCli::PomodoroTimer.new }

  let(:prompt_mock) { instance_double(PirbCli::Components::Prompt) }
  let(:timer_bus_mock) { instance_double(PirbCli::Components::TimerBus) }
  let(:settings) { { cycles: 4, focus_time: 25, short_break: 5, long_break: 20 } }

  before do
    # Mocking all Prompts
    allow(PirbCli::Components::Prompt).to receive(:new).and_return(prompt_mock)
    allow(prompt_mock).to receive(:ask_settings).and_return(settings)
    allow(prompt_mock).to receive(:interrupted)
    allow(prompt_mock).to receive(:start_next_timer?)
    allow(prompt_mock).to receive(:congratulate)

    # Mocking TimerBus
    allow(PirbCli::Components::TimerBus).to receive(:new).and_return(timer_bus_mock)
    allow(timer_bus_mock).to receive(:run)
  end

  it 'has a version number' do
    expect(PirbCli::VERSION).not_to be_nil
  end

  describe '#start' do
    context 'when settings are provided' do
      it 'initializes TimerBus with the correct settings and starts cycles' do
        expect(PirbCli::Components::TimerBus).to receive(:new).with(focus_time: 25, short_break: 5, long_break: 20)

        pomodoro_timer.start
      end
    end

    context 'when settings are nil' do
      it 'does not start the timer' do
        allow(prompt_mock).to receive(:ask_settings).and_return(nil)
        expect { pomodoro_timer.start }.not_to raise_error
      end
    end

    context 'when interrupted' do
      it 'calls interrupted on prompt' do
        allow(prompt_mock).to receive(:ask_settings).and_raise(Interrupt)
        expect(prompt_mock).to receive(:interrupted)

        pomodoro_timer.start
      end
    end
  end

  describe '#start_cycles' do
    it 'runs focus and break timers for the specified number of cycles' do
      allow(pomodoro_timer).to receive(:start_cycles).and_call_original
      allow(prompt_mock).to receive_messages(ask_settings: settings, start_next_timer?: true) # simulate "next"

      expect(timer_bus_mock).to receive(:run).with('focus').exactly(settings[:cycles])
      expect(timer_bus_mock).to receive(:run).with('short_break').exactly(settings[:cycles])
      expect(prompt_mock).to receive(:congratulate).with(settings[:cycles])

      pomodoro_timer.start # To initialize the @timer_bus and @number_of_cycles
      pomodoro_timer.start_cycles
    end
  end
end
# rubocop: enable RSpec/SubjectStub
