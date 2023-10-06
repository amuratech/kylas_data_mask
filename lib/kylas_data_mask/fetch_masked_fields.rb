# frozen_string_literal: true

require_relative 'kylas/http_request'

module KylasDataMask
  class FetchMaskedFields
    def initialize(api_key:, entity_type:)
      @api_key = api_key
      @entity_type = entity_type.downcase.singularize
    end

    def fetch
      response = KylasDataMask::Kylas::HttpRequest.request(request_parameters, api_key: @api_key)
      if response[:status_code] == '200'
        masked_fields_array = []
        masked_fields_array = response[:data].select { |f| f.dig('maskConfiguration', 'enabled').present? }
        
        { success: true, data: masked_fields_array }
      else
        puts "#{self.class} | Error while fetching masked fields from kylas for entity #{@entity_type} - status_code: #{response[:status_code]}, error_message: #{response[:data]}"
        { success: false, data: response[:data] }
      end
    end

    private

    def request_parameters
      {
        url: "#{KylasDataMask.config.api_url}/#{API_VERSION}/entities/#{@entity_type}/fields?entityType=#{@entity_type}",
        request_type: 'get',
        authentication_type: API_KEY
      }
    end
  end
end
