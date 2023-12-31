# frozen_string_literal: true

module KylasDataMask
  class UnmaskedData
    def initialize(access_token:, entity_id:, entity_type:, field:)
      @access_token = access_token
      @entity_id = entity_id
      @entity_type = entity_type
      @field = field
    end

    def fetch
      response = KylasDataMask::HttpRequest.request(request_parameters: request_parameters, access_token: @access_token)
      if response[:status_code] == '200'
        { success: true, data: response.dig('data', @field) }
      else
        Rails.logger.error "#{self.class} | Error while fetching unmasked data of #{@field} from kylas for entity #{@entity_type} - status_code: #{response[:status_code]}, error_message: #{response[:data]}"
        { success: false, data: response[:data] }
      end
    end

    def request_parameters
      {
        url: KylasDataMask::UrlBuilder.entity_details_url(@entity_type, @entity_id),
        request_type: :get,
        authentication_type: KylasDataMask::BEARER_TOKEN,
        content_type: 'application/json'
      }
    end
  end
end
