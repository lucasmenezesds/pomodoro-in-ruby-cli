# frozen_string_literal: true

require 'rspec'

describe PirbCli::Components::Timer do
  let(:progress_bar_mock) { instance_double(PirbCli::Components::ProgressBar) }
  let(:timer) { described_class.new(total_time: 5, type: 'focus', name: 'focus timer') }

  context 'successful behaviors' do
    describe '#initialize' do
      it 'has the expected attr_readers' do
        expect(timer.type).to eq('focus')
        expect(timer.name).to eq('focus timer')
        expect(timer.time).to eq(300)
        expect(timer.total_time).to eq(300)
      end
    end

    describe '#tick' do
      it 'reduces current_time by 1' do
        stub_const('PirbCli::Components::Timer::TIME_MULTIPLIER', 1)

        expect(timer).to receive(:sleep).exactly(1)

        timer.tick

        expect(timer.time).to eq(4)
      end
    end

    describe '#reset' do
      it 'sets time equal to total_time' do
        stub_const('PirbCli::Components::Timer::TIME_MULTIPLIER', 1)

        expect(timer).to receive(:sleep).exactly(2)

        timer.tick
        timer.tick
        expect(timer.time).to eq(3)

        timer.reset

        expect(timer.time).to eq(5)
      end
    end
  end
end
