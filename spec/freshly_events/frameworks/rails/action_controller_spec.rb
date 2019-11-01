# frozen_string_literal: true

require 'spec_helper'
require 'freshly_events/frameworks/rails/action_controller'

RSpec.describe FreshlyEvents::Frameworks::Rails::ActionControllerExtension do
  let(:dummy_controller) do
    Class.new(ActionController::Base) do
      def index
        # do something
        head :ok
      end

      class << self
        def name
          'DummyController'
        end
      end
    end
  end

  let(:dummy_request) { ActionDispatch::TestRequest.create }
  let(:dummy_response) { ActionDispatch::TestResponse.new }

  before do
    allow_any_instance_of(dummy_controller).to receive(:request).and_return(dummy_request)
    allow(dummy_request).to receive(:controller_class).and_return(dummy_controller)
  end

  describe '.track_view' do
    it 'defines a before_action' do
      expect do
        dummy_controller.track_view(actions: :index)
      end.to change {
        dummy_controller._process_action_callbacks.count
      }.from(0).to(1)
    end
  end

  describe '#record_freshly_event' do
    let(:dummy_controller_instance) { dummy_controller.new }
    let(:test_buffer) { [] }
    let(:test_target) { FreshlyEvents::TestAdapter.new(test_buffer) }

    before do
      # FreshlyEvents::ContextHandlers.reset_defaults!
      FreshlyEvents.config.targets = [test_target]

      dummy_controller.class_eval { track_view :index }
      dummy_controller_instance.action_name = 'index'
      dummy_controller_instance.set_response!(dummy_response)
    end

    it 'emits an event' do
      expect do
        dummy_controller_instance.run_callbacks(:process_action)
      end.to change {
        test_buffer
      }.from([]).to([{
                      class: 'DummyController',
                      ip: '0.0.0.0',
                      method: 'GET',
                      params: {},
                      referer: nil,
                      timestamp: Time.now.utc,
                      type: 'view',
                      url: 'http://test.host/'
                    }])
    end
  end
end
