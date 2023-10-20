# frozen_string_literal: true

require 'rails_helper'

class TestClass
  include KylasDataMask::MaskingConfiguration
end

RSpec.describe 'KylasDataMask::MaskingConfiguration' do
  let(:test_class) { TestClass.new }

  describe '#format_value_based_on_masking' do
    context 'when field is masked' do
      before(:each) { expect_any_instance_of(TestClass).to receive(:field_is_masked?).and_return(true) }

      context 'when country code is not present in value' do
        it 'should returns masked value' do
          response = test_class.format_value_based_on_masking(
            'call_log', double('user'), ['phoneNumber'], '9090909876', KylasDataMask::PHONE_MASKING
          )
          expect(response).to eq('****876')
        end
      end

      context 'when country code is present in value' do
        it 'should returns masked value with country code' do
          response = test_class.format_value_based_on_masking(
            'call_log', double('user'), ['phoneNumber'], '+355694460027', KylasDataMask::PHONE_MASKING
          )
          expect(response).to eq('+355****027')
        end
      end
    end

    context 'when field is not masked' do
      before(:each) { expect_any_instance_of(TestClass).to receive(:field_is_masked?).and_return(false) }

      it 'should returns unmasked value' do
        response = test_class.format_value_based_on_masking(
          'call_log', double('user'), ['phoneNumber'], '9090909876', KylasDataMask::PHONE_MASKING
        )
        expect(response).to eq('9090909876')
      end
    end
  end

  describe '#field_is_masked?' do
    let(:tenant) { double('tenant', kylas_api_key: SecureRandom.uuid) }
    let(:user) { double('user', id: 222, kylas_profile_id: 22, tenant: tenant) }

    context 'when masking is not enabled on the given field' do
      before(:each) do
        expect_any_instance_of(TestClass).to receive(:cache_masking_configuration).and_return([])
      end

      it 'should returns false' do
        response = test_class.field_is_masked?('call_log', user, ['phoneNumber'])
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
        expect_any_instance_of(TestClass).to receive(:cache_masking_configuration).and_return(masked_field_list_without_ivr_number)
      end

      it 'should returns false' do
        response = test_class.field_is_masked?('call_log', user, ['ivrNumber'])
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
        expect_any_instance_of(TestClass).to receive(:cache_masking_configuration).and_return(masked_fields_list)
      end

      context 'when profile ids array in mask configuration is empty' do
        it 'should returns true' do
          response = test_class.field_is_masked?('call_log', user, ['phoneNumber'])
          expect(response).to eq(true)
        end
      end

      context 'when profile ids array in mask configuration is not empty' do
        context 'when current user profile id is not included in profile ids array' do
          it 'should returns false' do
            masked_fields_list.each { |field| field['maskConfiguration']['profileIds'] = [3, 4] }

            response = test_class.field_is_masked?('call_log', user, %w[phoneNumber ivrNumber])
            expect(response).to eq(false)
          end
        end

        context 'when current user profile id is included in profile ids array' do
          it 'should returns true' do
            masked_fields_list.first['maskConfiguration']['profileIds'] = [22, 3, 4]
            response = test_class.field_is_masked?(masked_fields_list, user, ['phoneNumber'])
            expect(response).to eq(true)
          end
        end
      end
    end
  end

  describe '#masking_based_on_type' do
    context 'when masking type is phone number masking' do
      context 'when country code is not present in value' do
        it 'should returns masked value' do
          response = test_class.masking_based_on_type(
            '9090909876',
            KylasDataMask::PHONE_MASKING
          )
          expect(response).to eq('****876')
        end
      end

      context 'when country code is present in value' do
        it 'should returns masked value with country code' do
          response = test_class.masking_based_on_type(
            '+355694460027',
            KylasDataMask::PHONE_MASKING
          )
          expect(response).to eq('+355****027')
        end
      end
    end

    context 'when masking type is last name masking' do
      context 'when country code is not present in value' do
        it 'should returns masked value' do
          response = test_class.masking_based_on_type(
            '9090909876',
            KylasDataMask::LAST_NAME_MASKING
          )
          expect(response).to eq('MaskedValue876')
        end
      end

      context 'when country code is present in value' do
        it 'should returns masked value with country code' do
          response = test_class.masking_based_on_type(
            '+355694460027',
            KylasDataMask::LAST_NAME_MASKING
          )
          expect(response).to eq('+355MaskedValue027')
        end
      end
    end
  end
end
