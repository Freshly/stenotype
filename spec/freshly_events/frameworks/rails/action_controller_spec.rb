# frozen_string_literal: true

require 'spec_helper'
require 'hubbub/frameworks/rails/action_controller'

RSpec.describe Hubbub::Frameworks::Rails::ActionControllerExtension do
  let(:dummy_controller) do
    Class.new(ActionController::Base) do
      def index
        head :ok
      end

      def create
        head :ok
      end

      private

      def helper
        'do something'
      end

      class << self
        def name
          'DummyController'
        end
      end
    end
  end

  describe '.track_view' do
    it 'defines a before_action' do
      expect do
        dummy_controller.track_view(:index)
      end.to change {
        dummy_controller._process_action_callbacks.count
      }.from(0).to(1)
    end

    it 'adds a callback once' do
      expect do
        dummy_controller.track_view(:index)
        dummy_controller.track_view(:index)
      end.to change {
        dummy_controller._process_action_callbacks.count
      }.from(0).to(1)
    end
  end

  describe '.track_all_views' do
    it 'defines a before_action for all controller actions' do
      expect do
        dummy_controller.track_all_views
      end.to change {
        dummy_controller._process_action_callbacks.count
      }.from(0).to(1)
      # Note that there are actually two callbacks yet AC lists only one
    end

    it 'adds callbacks once' do
      expect do
        dummy_controller.track_all_views
        dummy_controller.track_all_views
      end.to change {
        dummy_controller._process_action_callbacks.count
      }.from(0).to(1)
    end
  end

  describe '#record_freshly_event' do
    let(:dummy_request) { ActionDispatch::TestRequest.create }
    let(:dummy_response) { ActionDispatch::TestResponse.new }

    before do
      allow_any_instance_of(dummy_controller).to receive(:request).and_return(dummy_request)
      allow(dummy_request).to receive(:controller_class).and_return(dummy_controller)
    end

    let(:dummy_controller_instance) { dummy_controller.new }
    let(:test_buffer) { [] }
    let(:test_target) { Hubbub::TestAdapter.new(test_buffer) }

    before do
      Hubbub.config.targets = [test_target]

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
                      url: 'http://test.host/',
                      uuid: 'abcd'
                    }])
    end
  end
end
