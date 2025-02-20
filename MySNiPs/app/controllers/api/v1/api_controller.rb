module Api
  module V1
    class ApiController < ApplicationController
      include Response
      include ExceptionHandler
      skip_before_action :verify_authenticity_token
      before_action :authenticate_request
      helper_method :current_api_user


      def authority_valid?
        return false if current_api_user.nil?

        role = Role.find(current_api_user.role_id)
        return false if role.nil?

        case role.role_name
        when "admin" then true
        when "laboratorio" then true
        else false
        end
      end

      def current_api_user
        AuthorizeApiRequest.call(request.headers).result
      end

      private

      def authenticate_request
        render json: {error: "Not Authorized"}, status: :unauthorized unless current_api_user
      end
    end
  end
end
