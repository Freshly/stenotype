# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stenotype::ContextHandlers::Rails::ActiveJob do
  let(:dummy_job_klass) do
    Class.new(ActiveJob::Base) do
      class << self
        def name
          :DummyJob
        end
      end

      def job_id
        'job id'
      end
    end
  end

  let(:dummy_job) { dummy_job_klass.new }

  subject(:context_handler) { described_class.new(dummy_job) }

  describe '#as_json', type: :with_frozen_time do
    it 'casts active job data to JSON' do
      expect(context_handler.as_json).to eq(
        class: :DummyJob,
        job_id: 'job id',
        enqueued_at: Time.now,
        queue_name: 'default'
      )
    end
  end

  describe '.handler_name' do
    it 'has name :active_job' do
      expect(described_class.handler_name).to eq(:active_job)
    end
  end
end
