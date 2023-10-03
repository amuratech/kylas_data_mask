# frozen_string_literal: true

require_relative 'kylas/http_request'

module KylasDataMask
  class FetchMaskedFields
    def initialize(access_token:, entity_type:)
      @access_token = access_token
      @entity_type = entity_type.downcase.singularize
    end

    def fetch
      response = KylasDataMask::Kylas::HttpRequest.request(request_parameters, access_token: @access_token)
      if response[:status_code] == '200'
        { success: true, data: response[:data] }
      else
        puts "#{self.class} | Error while fetching masked fields from kylas for entity #{@entity_type} - status_code: #{response[:status_code]}, error_message: #{response[:data]}"
        { success: false, data: response[:data] }
      end
    end

    private

    def request_parameters
      {
        url: "#{KylasDataMask.config.api_url}/#{API_VERSION}/entities/#{@entity_type}/masked-fields",
        request_type: 'get',
        authentication_type: BEARER_TOKEN
      }
    end
  end
end
