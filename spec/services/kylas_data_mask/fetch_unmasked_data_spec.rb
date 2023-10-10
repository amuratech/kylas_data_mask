# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KylasDataMask::FetchUnmaskedData do
  let(:error_response) do
    {
      'status_code' => '400',
      'data' => {
        'code' => '001079',
        'message' => 'Invalid API key'
      }
    }
  end

  let(:lead_details_response) do
    {
      "createdAt": '2023-09-27T08:02:01.935Z',
      "updatedAt": '2023-09-27T09:16:08.771Z',
      "createdBy": 6157,
      "updatedBy": 6157,
      "recordActions": {
        "read": true,
        "update": true,
        "delete": true,
        "email": true,
        "call": true,
        "sms": true,
        "task": true,
        "note": true,
        "meeting": true,
        "document": true,
        "deleteAll": true,
        "quotation": false
      },
      "metaData": {
        "idNameStore": {
          "country": {},
          "convertedBy": {},
          "cfEn": {},
          "updatedBy": {
            "6157": 'Tushar Vicky'
          },
          "timezone": {},
          "multiValuePicklist": {},
          "requirementCurrency": {},
          "source": {},
          "ownerId": {
            "6571": 'V P'
          },
          "companyEmployees": {},
          "companyBusinessType": {},
          "importedBy": {},
          "pipeline": {
            "8659": 'Kylas Pipeline'
          },
          "createdBy": {
            "6157": 'Tushar Vicky'
          },
          "campaign": {},
          "companyCountry": {},
          "salutation": {},
          "pipelineStage": {
            "59904": 'rest'
          },
          "cfSystemRole": {},
          "cfNewField22": {},
          "cfMulti": {},
          "cfSubSource": {},
          "companyIndustry": {}
        }
      },
      "id": 9_998_747,
      "ownerId": 6571,
      "firstName": 'test',
      "lastName": 'lead',
      "phoneNumbers": [
        {
          "id": 6_014_001,
          "type": 'MOBILE',
          "code": 'IN',
          "value": '8956663400',
          "dialCode": '+91',
          "primary": true
        }
      ],
      "pipeline": {
        "id": 8659,
        "name": 'Kylas Pipeline',
        "stage": {
          "id": 59_904,
          "name": 'rest'
        }
      },
      "forecastingType": 'OPEN',
      "latestActivityCreatedAt": '2023-09-29T13:15:04.850Z',
      "createdViaId": '6157',
      "createdViaName": 'User',
      "createdViaType": 'Web',
      "updatedViaId": '6157',
      "updatedViaName": 'User',
      "updatedViaType": 'Web'
    }
  end

  describe '#fetch' do
    before(:each) do
      KylasDataMask::Context.setup do |c|
        c.api_url = 'https://www.examples.io'
      end
    end

    context 'when api key is valid' do
      it 'should returns success true and unmasked field data' do
        stub_request(:get, 'https://www.examples.io/v1/leads/468994')
          .with(
            headers: {
              'Api-key' => '72e641f7-3ed3-4ae0-98c4-dad27fd0964c:3440'
            }
          )
          .to_return(status: 200, body: lead_details_response.to_json, headers: {})
        response = described_class.new(
          api_key: '72e641f7-3ed3-4ae0-98c4-dad27fd0964c:3440',
          entity_type: 'lead',
          entity_id: 468_994,
          field: 'phoneNumbers'
        ).fetch
        expect(response[:success]).to be(true)
        expect(response[:data]).to eq([{ 'id' => 6_014_001, 'type' => 'MOBILE', 'code' => 'IN', 'value' => '8956663400',
                                         'dialCode' => '+91', 'primary' => true }])
      end
    end

    context 'when api key is not valid' do
      it 'should returns success false and error data' do
        stub_request(:get, 'https://www.examples.io/v1/leads/468994')
          .with(
            headers: {
              'Api-key' => '72e641f7-3ed3-4ae0-98c4-dad27fd0964c:344'
            }
          )
          .to_return(status: 400, body: error_response.to_json, headers: {})
        response = described_class.new(
          api_key: '72e641f7-3ed3-4ae0-98c4-dad27fd0964c:344',
          entity_type: 'lead',
          entity_id: 468_994,
          field: 'phoneNumbers'
        ).fetch
        expect(response[:success]).to be(false)
        expect(response[:data]).to eq(
          {
            'status_code' => '400',
            'data' => {
              'code' => '001079',
              'message' => 'Invalid API key'
            }
          }
        )
      end
    end
  end
end
