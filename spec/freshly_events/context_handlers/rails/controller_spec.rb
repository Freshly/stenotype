# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FreshlyEvents::ContextHandlers::Rails::Controller do
  let(:dummy_controller) do
    Class.new(ActionController::Base) do
      class << self
        def name
          'DummyController'
        end
      end
    end
  end

  let(:dummy_request) { ActionDispatch::TestRequest.create }
  let(:dummy_response) { ActionDispatch::TestResponse.new }
  let(:dummy_controller_instance) { dummy_controller.new }

  subject(:context_handler) { described_class.new(dummy_controller_instance) }

  describe '#as_json' do
    before do
      allow_any_instance_of(dummy_controller).to receive(:request).and_return(dummy_request)
      allow(dummy_request).to receive(:controller_class).and_return(dummy_controller)

      dummy_controller_instance.action_name = 'index'
      dummy_controller_instance.set_response!(dummy_response)
    end

    it 'casts controller data to JSON' do
      expect(context_handler.as_json).to eq(
        class: 'DummyController',
        ip: '0.0.0.0',
        method: 'GET',
        params: {},
        referer: nil,
        url: 'http://test.host/'
      )
    end
  end
end
