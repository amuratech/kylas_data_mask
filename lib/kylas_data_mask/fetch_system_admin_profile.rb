# frozen_string_literal: true

require_relative 'kylas/http_request'

module KylasDataMask
  class FetchSystemAdminProfile
    def initialize(api_key:)
      @api_key = api_key
      @page = -1
    end

    def fetch
      response = KylasDataMask::Kylas::HttpRequest.request(request_parameters, api_key: @api_key)
      if response[:status_code] == '200'
        profiles_list = parse_profile_list_response(response[:data])
        number_of_pages = response.dig('data', 'totalPages')&.to_i
        if number_of_pages > 1
          (number_of_pages - 1).times do
            response = KylasDataMask::Kylas::HttpRequest.request(request_parameters, api_key: @api_key)
            if response[:status_code] == '200'
              profiles_list += parse_profile_list_response(response[:data])
            end
          end
        end

        system_admin_profile_id = profiles_list.find { |profile| profile['name'] == 'Admin' && profile['systemDefault'] }.try(:[], 'id')

        { success: true, data: system_admin_profile_id }
      else
        puts "#{self.class} | Error while fetching system admin profile id from kylas - status_code: #{response[:status_code]}, error_message: #{response[:data]}"
        { success: false, data: response[:data] }
      end
    end

    private

    def request_parameters
      {
        url: "#{KylasDataMask.config.api_url}/#{API_VERSION}/profiles/search?page=#{page}&size=1000",
        request_type: 'post',
        authentication_type: API_KEY,
        body: {
          "fields": [],
          "jsonRule": nil
        }
      }
    end

    def page
      @page += 1
    end

    def parse_profile_list_response(parsed_body)
      parsed_body.try(:[], 'content')
    end
  end
end
