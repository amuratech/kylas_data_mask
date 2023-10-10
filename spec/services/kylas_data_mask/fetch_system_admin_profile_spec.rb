# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KylasDataMask::FetchSystemAdminProfile do
  describe '#fetch' do
    before(:each) do
      KylasDataMask::Context.setup do |c|
        c.api_url = 'https://www.examples.io'
      end
    end

    context 'when api key is invalid' do
      let(:error_response) do
        {
          'status_code' => '400',
          'data' => {
            "code" => "001079",
            "message" => "Invalid API key"
          }
        }
      end

      it 'should return success false and error response' do
        stub_request(:post, "https://www.examples.io/v1/profiles/search?page=0&size=1000").
         with(
          body: "{\"fields\":[],\"jsonRule\":null}",
          headers: {
       	    'Api-Key'=>'72e641f7-3ed3-4ae0-98c4-dad27fd0964c:344'
           }).
         to_return(status: 400, body: error_response.to_json, headers: {})


        response = described_class.new(
          api_key: '72e641f7-3ed3-4ae0-98c4-dad27fd0964c:344',
        ).fetch

        expect(response[:success]).to be(false)
        expect(response[:data]).to eq({
          'status_code' => '400',
          'data' => {
            "code" => "001079",
            "message" => "Invalid API key"
          }
        })
      end
    end

    context 'when api key is valid' do
      let(:profiles_list_response) do
        {
          "last": true,
          "first": true,
          "totalPages": 1,
          "size": 1000,
          "number": 0,
          "numberOfElements": 3,
          "totalElements": 3,
          "sort": [{
            "direction": "ASC",
            "property": "updated_at",
            "ignoreCase": false,
            "nilHandling": "NATIVE",
            "descending": false,
            "ascending": true
          }],
          "content": [{
              "createdAt": "2020-09-25T06:07:11.619+0000",
              "updatedAt": "2020-09-25T06:07:11.619+0000",
              "createdBy": nil,
              "updatedBy": nil,
              "id": 2,
              "deleted": false,
              "version": 1,
              "recordActions": {
                "read": true,
                "write": false,
                "update": true,
                "delete": false,
                "email": false,
                "call": false,
                "sms": false,
                "task": false,
                "note": false,
                "meeting": false,
                "document": false,
                "readAll": false,
                "updateAll": false,
                "deleteAll": false,
                "quotation": false,
                "reshare": false
              },
              "metaData": nil,
              "tenantId": 0,
              "name": "Admin",
              "description": "Admin",
              "active": true,
              "systemDefault": true
            },
            {
              "createdAt": "2020-09-25T06:07:11.619+0000",
              "updatedAt": "2020-09-25T06:07:11.619+0000",
              "createdBy": nil,
              "updatedBy": nil,
              "id": 3,
              "deleted": false,
              "version": 1,
              "recordActions": {
                "read": true,
                "write": false,
                "update": true,
                "delete": false,
                "email": false,
                "call": false,
                "sms": false,
                "task": false,
                "note": false,
                "meeting": false,
                "document": false,
                "readAll": false,
                "updateAll": false,
                "deleteAll": false,
                "quotation": false,
                "reshare": false
              },
              "metaData": nil,
              "tenantId": 0,
              "name": "Restricted User",
              "description": "Restricted User",
              "active": true,
              "systemDefault": true
            }
          ],
          "metaData": {
            "idNameStore": {
              "updatedBy": {
                "7638": "Pansare Aditya "
              },
              "createdBy": {
                "7638": "Pansare Aditya "
              }
            }
          }
        }
      end

      it 'should return success true and return system admin user profile id' do
        stub_request(:post, "https://www.examples.io/v1/profiles/search?page=0&size=1000").
         with(
          body: "{\"fields\":[],\"jsonRule\":null}",
          headers: {
       	    'Api-Key'=>'72e641f7-3ed3-4ae0-98c4-dad27fd0964c:3440'
           }).
         to_return(status: 200, body: profiles_list_response.to_json, headers: {})

        response = described_class.new(
          api_key: '72e641f7-3ed3-4ae0-98c4-dad27fd0964c:3440',
        ).fetch

        expect(response[:success]).to be(true)
        expect(response[:data]).to eq(2)
      end
    end
  end
end
