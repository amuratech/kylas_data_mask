# frozen_string_literal: true

module KylasDataMask
  class HttpRequest
    def self.request(request_parameters:, access_token: nil, api_key: nil)
      url = URI(request_parameters[:url])
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = "Net::HTTP::#{request_parameters[:request_type].to_s.titleize}".constantize.new(url)
      request.body = request_parameters[:body].to_json if request_parameters[:body].present?
      request['Content-Type'] = 'application/json'

      case request_parameters[:authentication_type]
      when KylasDataMask::BEARER_TOKEN
        request['Authorization'] = "Bearer #{access_token}"
      when KylasDataMask::API_KEY
        request['api-key'] = api_key
      end

      response = https.request(request)
      response_body = begin
        JSON.parse(response.body)
      rescue JSON::ParserError, TypeError
        response.body
      end
      { status_code: response.code, data: response_body }.with_indifferent_access
    rescue StandardError => e
      Rails.logger.error "Error in kylas http request - #{e.message}"
      { status_code: nil, data: 'Something went wrong' }
    end
  end
end
