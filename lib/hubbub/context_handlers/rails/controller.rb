# frozen_string_literal: true

module Hubbub
  module ContextHandlers
    module Rails
      #
      # ActionController handler to support fetching data out of a rails controller instance
      #
      class Controller < Hubbub::ContextHandlers::Base
        self.handler_name = :controller

        #
        # @return {Hash} a JSON representation of controller's data
        #
        def as_json(*_args)
          {
            class: request.controller_class.name,
            method: request.method,
            url: request.url,
            referer: request.referer,
            params: request.params.except('controller', 'action'),
            ip: request.remote_ip
          }
        end

        private

        def request
          context.request
        end
      end
    end
  end
end