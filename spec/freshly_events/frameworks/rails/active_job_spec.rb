# frozen_string_literal: true

require 'spec_helper'
require 'freshly_events/frameworks/rails/active_job'

RSpec.describe FreshlyEvents::Frameworks::Rails::ActiveJobExtension do
  let(:dummy_job_klass) do
    Class.new(ActiveJob::Base) do
      trackable_job!

      def perform(*args)
        # do something
      end

      def job_id
        'uuid'
      end

      class << self
        def name
          'DummyJob'
        end
      end
    end
  end

  subject(:dummy_job_instance) { dummy_job_klass.new }

  let(:test_buffer) { [] }
  let(:test_target) { FreshlyEvents::TestAdapter.new(test_buffer) }

  before { FreshlyEvents.config.targets = [test_target] }

  describe '.trackable_job!' do
    it 'prepends an emit event action before performing the job' do
      expect do
        dummy_job_instance.perform(arg: :value)
      end.to change {
        test_buffer
      }.from([]).to([{
                      type: 'active_job',
                      timestamp: Time.now.utc,
                      job_id: 'uuid',
                      queue_name: 'default',
                      class: 'DummyJob'
                    }])
    end
  end
end
