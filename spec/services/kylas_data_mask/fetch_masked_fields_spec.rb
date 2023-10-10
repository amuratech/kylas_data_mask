# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KylasDataMask::FetchMaskedFields do
  describe '#fetch' do
    before(:each) do
      KylasDataMask::Context.setup do |c|
        c.api_url = 'https://www.examples.io'
      end
    end

    context 'when Api key is invalid' do
      let(:error_response) do
        {
          'status_code' => '400',
          'data' => {
            'code' => '001079',
            'message' => 'Invalid API key'
          }
        }
      end

      it 'should returns success false and error data' do
        stub_request(:get, 'https://www.examples.io/v1/entities/lead/fields')
          .with(
            headers: {
              'Api-key' => '72e641f7-3ed3-4ae0-98c4-dad27fd0964c:344'
            }
          )
          .to_return(status: 404, body: error_response.to_json, headers: {})

        response = described_class.new(
          api_key: '72e641f7-3ed3-4ae0-98c4-dad27fd0964c:344',
          entity_type: 'lead'
        ).fetch

        expect(response[:success]).to be(false)
        expect(response[:data]).to eq({
                                        'status_code' => '400',
                                        'data' => {
                                          'code' => '001079',
                                          'message' => 'Invalid API key'
                                        }
                                      })
      end
    end

    context 'when Api key is valid' do
      let(:form_fields_response) do
        [
          {
            "createdAt": '2023-04-28T08:22:21.869+0000',
            "updatedAt": '2023-04-28T08:22:21.869+0000',
            "createdBy": 8112,
            "updatedBy": 8112,
            "id": 618_218,
            "deleted": false,
            "version": 0,
            "recordActions": nil,
            "metaData": nil,
            "tenantId": 3691,
            "displayName": 'First Name',
            "description": nil,
            "type": 'TEXT_FIELD',
            "internalType": nil,
            "name": 'firstName',
            "entityType": nil,
            "standard": true,
            "sortable": true,
            "filterable": true,
            "required": false,
            "important": true,
            "active": true,
            "multiValue": false,
            "length": 255,
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
          },
          {
            "createdAt": '2023-04-28T08:22:21.873+0000',
            "updatedAt": '2023-10-03T06:21:35.378+0000',
            "createdBy": 8112,
            "updatedBy": 8112,
            "id": 618_220,
            "deleted": false,
            "version": 1,
            "recordActions": nil,
            "metaData": nil,
            "tenantId": 3691,
            "displayName": 'Phone Numbers Masked',
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
            "maskConfiguration": {
              "id": 1, "enabled": true, "profileIds": []
            }
          },
          {
            "createdAt": '2023-04-28T08:22:21.964+0000',
            "updatedAt": '2023-04-28T08:22:21.964+0000',
            "createdBy": 8112,
            "updatedBy": 8112,
            "id": 618_246,
            "deleted": false,
            "version": 0,
            "recordActions": nil,
            "metaData": nil,
            "tenantId": 3691,
            "displayName": 'Company Phones',
            "description": nil,
            "type": 'PHONE',
            "internalType": nil,
            "name": 'companyPhones',
            "entityType": nil,
            "standard": true,
            "sortable": false,
            "filterable": true,
            "required": false,
            "important": false,
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
            "maskConfiguration": {
              "id": 2, "enabled": true, "profileIds": [455, 452]
            }
          }
        ]
      end

      it 'should returns success true and masked fields data' do
        stub_request(:get, 'https://www.examples.io/v1/entities/lead/fields')
          .with(
            headers: {
              'Api-key' => '72e641f7-3ed3-4ae0-98c4-dad27fd0964c:3440'
            }
          )
          .to_return(status: 200, body: form_fields_response.to_json, headers: {})

        response = described_class.new(
          api_key: '72e641f7-3ed3-4ae0-98c4-dad27fd0964c:3440',
          entity_type: 'lead'
        ).fetch

        expect(response[:success]).to be(true)
        expect(response[:data]).to eq([
                                        {
                                          'createdAt' => '2023-04-28T08:22:21.873+0000',
                                          'updatedAt' => '2023-10-03T06:21:35.378+0000',
                                          'createdBy' => 8112,
                                          'updatedBy' => 8112,
                                          'id' => 618_220,
                                          'deleted' => false,
                                          'version' => 1,
                                          'recordActions' => nil,
                                          'metaData' => nil,
                                          'tenantId' => 3691,
                                          'displayName' => 'Phone Numbers Masked',
                                          'description' => nil,
                                          'type' => 'PHONE',
                                          'internalType' => nil,
                                          'name' => 'phoneNumbers',
                                          'entityType' => nil,
                                          'standard' => true,
                                          'sortable' => false,
                                          'filterable' => true,
                                          'required' => false,
                                          'important' => true,
                                          'active' => true,
                                          'multiValue' => true,
                                          'length' => nil,
                                          'isUnique' => nil,
                                          'greaterThan' => nil,
                                          'lessThan' => nil,
                                          'lookupForEntity' => nil,
                                          'internal' => false,
                                          'lookupUrl' => nil,
                                          'skipIdNameResolution' => false,
                                          'picklist' => nil,
                                          'regex' => nil,
                                          'colorConfiguration' => nil,
                                          'maskConfiguration' => { 'id' => 1, 'enabled' => true, 'profileIds' => [] }
                                        },
                                        {
                                          'createdAt' => '2023-04-28T08:22:21.964+0000',
                                          'updatedAt' => '2023-04-28T08:22:21.964+0000',
                                          'createdBy' => 8112,
                                          'updatedBy' => 8112,
                                          'id' => 618_246,
                                          'deleted' => false,
                                          'version' => 0,
                                          'recordActions' => nil,
                                          'metaData' => nil,
                                          'tenantId' => 3691,
                                          'displayName' => 'Company Phones',
                                          'description' => nil,
                                          'type' => 'PHONE',
                                          'internalType' => nil,
                                          'name' => 'companyPhones',
                                          'entityType' => nil,
                                          'standard' => true,
                                          'sortable' => false,
                                          'filterable' => true,
                                          'required' => false,
                                          'important' => false,
                                          'active' => true,
                                          'multiValue' => true,
                                          'length' => nil,
                                          'isUnique' => nil,
                                          'greaterThan' => nil,
                                          'lessThan' => nil,
                                          'lookupForEntity' => nil,
                                          'internal' => false,
                                          'lookupUrl' => nil,
                                          'skipIdNameResolution' => false,
                                          'picklist' => nil,
                                          'regex' => nil,
                                          'colorConfiguration' => nil,
                                          'maskConfiguration' => { 'id' => 2, 'enabled' => true,
                                                                   'profileIds' => [455, 452] }
                                        }
                                      ])
      end
    end
  end
end
