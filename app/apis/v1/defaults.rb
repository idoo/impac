module APIS
  module V1
    module Defaults
      # if you're using Grape outside of Rails, you'll have to use Module#included hook
      extend ActiveSupport::Concern

      included do
        # common Grape settings
        version 'v1'
        format :json

        helpers do
          def make_request(params)
            url = 'http://api-impac-uat.maestrano.io/api/v1/get_widget'
            default_params = {'metadata[organization_ids][]' => 'org-fbte'}
            data = params.merge(default_params)
            auth = {username: Rails.application.secrets.api_login, password: Rails.application.secrets.api_password}
            resp = HTTParty.get(url, body: data, basic_auth: auth)
            return resp
          end
        end

        # global handler for simple not found case
        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        # global exception handler, used for error notifications
        rescue_from :all do |e|
          if Rails.env.development?
            raise e
          else
            error_response(message: e.message, status: 500)
          end
        end

      end
    end
  end
end
