# frozen_string_literal: true

module KylasDataMask
  module Kylas
    class Webhook
      def initialize(api_key:, webhook_api_key:, webhook_id: nil)
        @api_key = api_key
        @webhook_api_key = webhook_api_key
        @webhook_id = webhook_id
      end

      def create
        response = Kylas::HttpRequest.request(request_parameters: request_parameters, api_key: @api_key)
        if response[:status_code] == '201'
          { success: true, data: response[:data] }
        else
          puts "#{self.class} | Error while creating webhook to kylas - status_code: #{response[:status_code]}, error_message: #{response[:data]}"
          { success: false, data: response[:data] }
        end
      end

      def update
        response = Kylas::HttpRequest.request(request_parameters: request_parameters, api_key: @api_key)
        if response[:status_code] == '200'
          { success: true, data: response[:data] }
        else
          puts "#{self.class} | Error while updating webhook to kylas: #{@webhook_id} - status_code: #{response[:status_code]}, error_message: #{response[:data]}"
          { success: false, data: response[:data] }
        end
      end

      private

      def request_parameters
        {
          url: "#{KylasDataMask.config.api_url}/#{KylasDataMask.config.api_version}/webhooks",
          request_type: 'post',
          authentication_type: API_KEY,
          body: webhook_payload
        }
      end

      def webhook_payload
        {
          name: 'Webhook for data masking feature on marketplace app.',
          requestType: 'POST',
          url: "#{KylasDataMask.config.marketplace_app_host}/kylas_data_mask/webhooks/handler.json",
          authenticationType: 'API_KEY',
          authenticationKey: Base64.strict_encode64(
            { 'keyName': 'Api-Key', 'value': @webhook_api_key }.to_json
          ),
          events: webhook_events_list,
          system: true,
          appId: KylasDataMask.config.marketplace_app_id,
          active: true
        }
      end

      def webhook_events_list
        %w[USER_CREATED USER_UPDATED USER_ACTIVATED USER_DEACTIVATED]
      end
    end
  end
end
