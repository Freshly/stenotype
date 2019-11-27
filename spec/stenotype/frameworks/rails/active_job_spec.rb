# frozen_string_literal: true

require 'spec_helper'
require 'stenotype/frameworks/rails/active_job'

RSpec.describe Stenotype::Frameworks::Rails::ActiveJobExtension do
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
  let(:test_target) { Stenotype::TestAdapter.new(test_buffer) }

  before do
    Stenotype::Configuration.configure do |c|
      c.targets = [test_target]
    end
  end

  describe '.trackable_job!' do
    it 'prepends an emit event action before performing the job' do
      expect do
        dummy_job_instance.perform(arg: :value)
      end.to change {
        test_buffer
      }.from([]).to([{
                      type: 'active_job',
                      timestamp: Time.now.utc,
                      enqueued_at: Time.now.utc,
                      job_id: 'uuid',
                      queue_name: 'default',
                      uuid: 'abcd',
                      class: 'DummyJob'
                    }])
    end
  end
end
