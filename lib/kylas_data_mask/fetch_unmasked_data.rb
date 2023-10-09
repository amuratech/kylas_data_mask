# frozen_string_literal: true

require_relative 'kylas/http_request'

module KylasDataMask
  class FetchUnmaskedData
    def initialize(api_key:, entity_id:, entity_type:, field:)
      @api_key = api_key
      @entity_id = entity_id
      @entity_type = entity_type
      @field = field
    end

    def fetch
      response = KylasDataMask::Kylas::HttpRequest.request(request_parameters: request_parameters, api_key: @api_key)
      if response[:status_code] == '200'
        { success: true, data: response.dig('data', @field) }
      else
        puts "#{self.class} | Error while fetching unmasked data of #{@field} from kylas for entity #{@entity_type} - status_code: #{response[:status_code]}, error_message: #{response[:data]}"
        { success: false, data: response[:data] }
      end
    end

    def request_parameters
      {
        url: "#{KylasDataMask.config.api_url}/#{KylasDataMask.config.api_version}/#{@entity_type.downcase.pluralize}/#{@entity_id}",
        request_type: 'get',
        authentication_type: API_KEY,
        content_type: 'application/json'
      }
    end
  end
end
