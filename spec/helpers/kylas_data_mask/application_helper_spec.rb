# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KylasDataMask::ApplicationHelper, type: :helper do
  describe '#format_value_based_on_masking' do
    context 'when field is masked' do
      before(:each) { expect(helper).to receive(:field_is_masked?).and_return(true) }

      it 'should return masked value' do
        response = helper.format_value_based_on_masking('call_log', 22, ['phoneNumber'], '9090909876')
        expect(response).to eq('*******876')
      end
    end

    context 'when field is not masked' do
      before(:each) { expect(helper).to receive(:field_is_masked?).and_return(false) }

      it 'should return unmasked value' do
        response = helper.format_value_based_on_masking('call_log', 22, ['phoneNumber'], '8090909876')
        expect(response).to eq('8090909876')
      end
    end
  end

  describe '#field_is_masked?' do
    context 'when masking is not enabled on the given field' do
      before(:each) do
        expect(helper).to receive(:cache_masking_configuration).and_return([])
      end

      it 'should return false' do
        response = helper.field_is_masked?('call_log', 22, ['phoneNumber'])
        expect(response).to eq(false)
      end
    end

    context 'when we not found masking configuration for given field' do
      let(:masked_field_list_without_ivr_number) do
        [
          {
            "id": 18_598,
            "name": 'phoneNumber',
            "displayName": 'Phone Number',
            "type": 'PHONE',
            "description": nil,
            "standard": true,
            "sortable": false,
            "filterable": false,
            "internal": false,
            "required": true,
            "active": true,
            "tenantId": 1999,
            "picklist": nil,
            "createdAt": '2022-09-28T04:10:01.284Z',
            "updatedAt": '2022-09-28T04:10:01.284Z',
            "maskConfiguration": nil
          }
        ].map(&:with_indifferent_access)
      end

      before(:each) do
        expect(helper).to receive(:cache_masking_configuration).and_return(masked_field_list_without_ivr_number)
      end

      it 'should return false' do
        response = helper.field_is_masked?(
          'call_log', 22, ['ivrNumber']
        )
        expect(response).to eq(false)
      end
    end

    context 'when masking is enabled on the given field' do
      let(:masked_fields_list) do
        [
          {
            "id": 18_598,
            "name": 'phoneNumber',
            "displayName": 'Phone Number',
            "type": 'PHONE',
            "description": nil,
            "standard": true,
            "sortable": false,
            "filterable": false,
            "internal": false,
            "required": true,
            "active": true,
            "tenantId": 1999,
            "picklist": nil,
            "createdAt": '2022-09-28T04:10:01.284Z',
            "updatedAt": '2022-09-28T04:10:01.284Z',
            "maskConfiguration": {
              "id": 18,
              "enabled": true,
              "profileIds": []
            }
          },
          {
            "id": 39_047,
            "name": 'ivrNumber',
            "displayName": 'IVR Number',
            "type": 'TEXT_FIELD',
            "description": nil,
            "standard": true,
            "sortable": false,
            "filterable": true,
            "internal": false,
            "required": false,
            "active": true,
            "tenantId": 1999,
            "picklist": nil,
            "createdAt": '2023-04-24T09:03:41.948Z',
            "updatedAt": '2023-04-24T09:03:41.948Z',
            "maskConfiguration": {
              "id": 19,
              "enabled": true,
              "profileIds": []
            }
          }
        ].map(&:with_indifferent_access)
      end

      before(:each) do
        expect(helper).to receive(:cache_masking_configuration).and_return(masked_fields_list)
      end

      context 'when profile ids array in mask configuration is empty' do
        it 'should return true' do
          response = helper.field_is_masked?('call_log', 22, ['phoneNumber'])
          expect(response).to eq(true)
        end
      end

      context 'when profile ids array in mask configuration is not empty' do
        context 'when current user profile id is not included in profile ids array' do
          it 'should return false' do
            masked_fields_list.each { |field| field['maskConfiguration']['profileIds'] = [3, 4] }

            response = helper.field_is_masked?('call_log', 22, %w[phoneNumber ivrNumber])
            expect(response).to eq(false)
          end
        end

        context 'when current user profile id is included in profile ids array' do
          it 'should return true' do
            masked_fields_list.first['maskConfiguration']['profileIds'] = [22, 3, 4]
            response = helper.field_is_masked?(masked_fields_list, 22, ['phoneNumber'])
            expect(response).to eq(true)
          end
        end
      end
    end
  end
end
