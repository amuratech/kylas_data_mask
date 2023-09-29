# frozen_string_literal: true

require 'spec_helper'
require 'kylas_data_mask/fetch_masked_fields'

RSpec.describe KylasDataMask::FetchMaskedFields do
  describe '#fetch' do
    before(:each) do
      KylasDataMask.configure do |c|
        c.api_url = 'https://www.examples.io'
      end
    end

    context 'when access_token and entity is valid' do
      context 'when get failed response from API' do
        it 'should returns success false and error data' do
          stub_request(:get, 'https://www.examples.io/v1/entities/lead/masked-fields')
            .with(
              headers: {
                'Authorization' => 'Bearer 41c55214-6f77-4d35-a3c0-8f0bc2313696:1999:3779',
                'User-Agent' => 'User Access Token: 41c55214-6f77-4d35-a3c0-8f0bc2313696:1999:3779'
              }
            )
            .to_return(status: 404, body: { 'status_code' => '404', 'message' => 'NOT_FOUND' }.to_json, headers: {})

          response = described_class.new(
            access_token: '41c55214-6f77-4d35-a3c0-8f0bc2313696:1999:3779',
            entity_type: 'lead'
          ).fetch

          expect(response[:success]).to be(false)
          expect(response[:data]).to eq({ 'status_code' => '404', 'message' => 'NOT_FOUND' })
        end
      end

      context 'when get success response from API' do
        let(:expected_masked_fields_response) do
          [
            {
              "createdAt": '2022-01-04T05:08:50.713+0000',
              "updatedAt": '2022-01-04T05:08:52.236+0000',
              "createdBy": 3779,
              "updatedBy": 3779,
              "id": 126_414,
              "deleted": false,
              "version": 1,
              "recordActions": nil,
              "metaData": nil,
              "tenantId": 1999,
              "displayName": 'Phone Numbers',
              "description": nil,
              "type": 'PHONE',
              "internalType": nil,
              "name": 'phoneNumbers',
              "entityType": nil,
              "standard": true,
              "sortable": false,
              "filterable": true,
              "required": false,
              "important": true,
              "active": true,
              "multiValue": true,
              "length": nil,
              "isUnique": nil,
              "greaterThan": nil,
              "lessThan": nil,
              "lookupForEntity": nil,
              "internal": false,
              "lookupUrl": nil,
              "skipIdNameResolution": false,
              "picklist": nil,
              "regex": nil,
              "colorConfiguration": nil,
              "maskConfiguration": nil
            }.with_indifferent_access
          ]
        end

        it 'should returns success true and masked fields data' do
          stub_request(:get, 'https://www.examples.io/v1/entities/lead/masked-fields')
            .with(
              headers: {
                'Authorization' => 'Bearer 41c55214-6f77-4d35-a3c0-8f0bc2313696:1999:3779',
                'User-Agent' => 'User Access Token: 41c55214-6f77-4d35-a3c0-8f0bc2313696:1999:3779'
              }
            )
            .to_return(status: 200, body: expected_masked_fields_response.to_json, headers: {})

          response = described_class.new(
            access_token: '41c55214-6f77-4d35-a3c0-8f0bc2313696:1999:3779',
            entity_type: 'lead'
          ).fetch

          expect(response[:success]).to be(true)
          expect(response[:data]).to eq(expected_masked_fields_response)
        end
      end
    end
  end
end
