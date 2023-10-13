# frozen_string_literal: true

module KylasDataMask
  class Webhook
    def initialize(api_key:, webhook_api_key:)
      @api_key = api_key
      @webhook_api_key = webhook_api_key
    end

    def create
      response = KylasDataMask::HttpRequest.request(request_parameters: request_parameters, api_key: @api_key)
      if response[:status_code] == '201'
        { success: true, data: response[:data] }
      else
        Rails.logger.error "#{self.class} | Error while creating webhook to kylas - status_code: #{response[:status_code]}, error_message: #{response[:data]}"
        { success: false, data: response[:data] }
      end
    end

    private

    def request_parameters
      {
        url: KylasDataMask::UrlBuilder.create_webhook_url,
        request_type: 'post',
        authentication_type: API_KEY,
        body: webhook_payload
      }
    end

    def webhook_payload
      {
        name: 'Webhook for data masking feature on marketplace app.',
        requestType: 'POST',
        url: "#{KylasDataMask::Context.config.marketplace_app_host}/kylas-data-mask/webhooks/handler.json",
        authenticationType: 'API_KEY',
        authenticationKey: Base64.strict_encode64(
          { 'keyName': 'Api-Key', 'value': @webhook_api_key }.to_json
        ),
        events: webhook_events_list,
        system: true,
        appId: KylasDataMask::Context.config.marketplace_app_id,
        active: true
      }
    end

    def webhook_events_list
      %w[USER_UPDATED USER_ACTIVATED USER_DEACTIVATED]
    end
  end
end
