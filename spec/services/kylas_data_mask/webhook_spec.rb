# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KylasDataMask::Webhook, type: :service do
  describe '#create' do
    let(:product_api_key) { '83960f84-9982-4d5d-8e2e-484da09a2ec0' }
    let(:webhook_api_key) { '83960f84-9982-4d5d-8e2e-484da09a2ec2' }

    let(:create_payload) do
      {
        url: "#{KylasDataMask::Context.config.api_url}/v1/webhooks",
        request_type: 'post',
        authentication_type: 'api_key',
        body: {
          name: 'Webhook for data masking feature on marketplace app.',
          requestType: 'POST',
          url: "#{KylasDataMask::Context.config.marketplace_app_host}/kylas-data-mask/webhooks/handler.json",
          authenticationType: 'API_KEY',
          authenticationKey: Base64.strict_encode64(
            { 'keyName': 'Api-Key', 'value': webhook_api_key }.to_json
          ),
          events: %w[USER_CREATED USER_UPDATED USER_ACTIVATED USER_DEACTIVATED],
          system: true,
          appId: KylasDataMask::Context.config.marketplace_app_id,
          active: true
        }
      }
    end

    let(:webhook_response) do
      JSON.parse(file_fixture('webhook/create_webhook_response.json').read)
    end

    def stub_create_webhook_request(api_key: product_api_key, status_code: 200, request_body: {}, response_body: {})
      stub_request(:post, "#{KylasDataMask::Context.config.api_url}/#{KylasDataMask::Context.config.api_version}/webhooks")
        .with(
          headers: {
            'Content-Type' => 'application/json', 'api-key' => api_key
          },
          body: request_body.to_json
        )
        .to_return(status: status_code, body: response_body.to_json)
    end

    context 'when parameters are invalid for webhook creation' do
      it 'should returns success false and error response' do
        invalid_create_payload = create_payload
        invalid_create_payload[:body].except!(:url)

        expect_any_instance_of(described_class).to receive(:request_parameters)
          .and_return(invalid_create_payload)

        stub_create_webhook_request(
          api_key: product_api_key,
          status_code: 422,
          request_body: invalid_create_payload[:body],
          response_body: webhook_response['error']
        )

        expect(Rails.logger).to receive(:error)
          .with(/Error while creating webhook to kylas - status_code: 422/)
        result = described_class.new(api_key: product_api_key, webhook_api_key: webhook_api_key).create
        expect(result[:success]).to eq(false)
        expect(result[:data]).to eq(
          {
            'errorCode' => '027003',
            'message' => "Url can't be blank,Url is invalid"
          }
        )
      end
    end

    context 'when parameters are valid for webhook creation' do
      it 'should returns success true and success response' do
        stub_create_webhook_request(
          api_key: product_api_key,
          status_code: 201,
          request_body: create_payload[:body],
          response_body: webhook_response['success']
        )

        result = described_class.new(api_key: product_api_key, webhook_api_key: webhook_api_key).create
        expect(result[:success]).to eq(true)
        expect(result[:data]).to eq({ 'id' => 442 })
      end
    end
  end
end
