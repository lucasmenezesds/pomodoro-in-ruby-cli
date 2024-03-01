# frozen_string_literal: true

require 'rspec'

describe PirbCli::Components::TimerBus do
  let(:focus_timer) { instance_double(PirbCli::Components::Timer, type: 'focus') }
  let(:short_timer) do
    instance_double(PirbCli::Components::Timer, type: 'short_break', reset: true, name: 'shorty', total_time: 10)
  end
  let(:long_timer) { instance_double(PirbCli::Components::Timer, type: 'long_break') }
  let(:progress_bar) { instance_double(PirbCli::Components::PomodoroProgressBar) }
  let(:timer_bus) do
    allow(PirbCli::Components::Notifier).to receive(:new).and_return(double)
    described_class.new(focus_time: 5, short_break: 2, long_break: 3)
  end

  context 'with correct params' do
    describe '#define_current_timer' do
      it 'returns the expected timer according to the type' do
        allow(PirbCli::Components::Timer).to receive(:new).and_return(focus_timer, short_timer, long_timer)

        result_focus = timer_bus.define_current_timer('focus')
        result_short = timer_bus.define_current_timer('short_break')
        result_long = timer_bus.define_current_timer('long_break')

        expect(result_focus.type).to eq('focus')
        expect(result_short.type).to eq('short_break')
        expect(result_long.type).to eq('long_break')
      end
    end

    describe '#setup_current_timer' do
      it 'defines and reset the expected timer' do
        expect(timer_bus).to receive(:define_current_timer).with('short_break').and_return(short_timer).exactly(1)
        expect(short_timer).to receive(:reset).exactly(1)
        expect(PirbCli::Components::PomodoroProgressBar).to receive(:new).with(title: 'shorty', total: 10).exactly(1)

        timer_bus.setup_current_timer('short_break')
      end
    end
  end
end
