# frozen_string_literal: true

module KylasDataMask
  module UrlBuilder
    class << self
      def search_url(entity_type, page)
        case entity_type
        when KylasDataMask::PROFILE
          "#{KylasDataMask::Context.config.api_url}/#{KylasDataMask::Context.config.api_version}/profiles/search?page=#{page}&size=1000"
        end
      end

      def fields_url(entity_type)
        case entity_type
        when KylasDataMask::LEAD
          "#{KylasDataMask::Context.config.api_url}/#{KylasDataMask::Context.config.api_version}/entities/lead/fields"
        when KylasDataMask::CALL_LOG
          "#{KylasDataMask::Context.config.api_url}/#{KylasDataMask::Context.config.api_version}/call-logs/fields"
        when KylasDataMask::CONTACT
          "#{KylasDataMask::Context.config.api_url}/#{KylasDataMask::Context.config.api_version}/entities/contact/fields"
        end
      end

      def entity_details_url(entity_type, entity_id)
        "#{KylasDataMask::Context.config.api_url}/#{KylasDataMask::Context.config.api_version}/#{entity_type.downcase.pluralize}/#{entity_id}"
      end

      def create_webhook_url
        "#{KylasDataMask::Context.config.api_url}/#{KylasDataMask::Context.config.api_version}/webhooks"
      end
    end
  end
end
