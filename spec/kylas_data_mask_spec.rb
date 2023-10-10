# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KylasDataMask do
  context 'with correct version' do
    it 'has a version number' do
      expect(KylasDataMask::VERSION).to eq('1.0.0')
    end
  end

  describe '.configure' do
    context 'when api_url is blank' do
      it 'should raise exception' do
        expect do
          described_class.configure do |c|
            c.api_url = nil
          end
        end.to raise_error(
          KylasDataMask::ConfigurationError,
          'API URL is missing in the configuration'
        )
      end
    end

    context 'when api_url is present' do
      it 'should not raise exception' do
        expect do
          described_class.configure do |c|
            c.api_url = 'https://www.examples.io'
          end
        end.not_to raise_error(
          KylasDataMask::ConfigurationError,
          'API URL is missing in the configuration'
        )
      end
    end
  end

  describe '.field_is_masked_or_not?' do
    context 'when masking is not enabled on the given field' do
      it 'should return false' do
        response = KylasDataMask.field_is_masked_or_not?(masked_fields_list: [], user_profile_id: 2, field: 'phoneNumbers')
        expect(response).to eq(false)
      end
    end

    context 'when we not find masking configuration for given field' do
      let(:masked_field_list_without_company_phone) do
        [
          {
            "createdAt"=>"2023-04-28T08:22:21.873+0000",
            "updatedAt"=>"2023-10-03T06:21:35.378+0000",
            "createdBy"=>8112,
            "updatedBy"=>8112,
            "id"=>618220,
            "deleted"=>false,
            "version"=>1,
            "recordActions"=>nil,
            "metaData"=>nil,
            "tenantId"=>3691,
            "displayName"=>"Phone Numbers Masked",
            "description"=>nil,
            "type"=>"PHONE",
            "internalType"=>nil,
            "name"=>"phoneNumbers",
            "entityType"=>nil,
            "standard"=>true,
            "sortable"=>false,
            "filterable"=>true,
            "required"=>false,
            "important"=>true,
            "active"=>true,
            "multiValue"=>true,
            "length"=>nil,
            "isUnique"=>nil,
            "greaterThan"=>nil,
            "lessThan"=>nil,
            "lookupForEntity"=>nil,
            "internal"=>false,
            "lookupUrl"=>nil,
            "skipIdNameResolution"=>false,
            "picklist"=>nil,
            "regex"=>nil,
            "colorConfiguration"=>nil,
            "maskConfiguration"=>{"id"=>1, "enabled"=>true, "profileIds"=>[]}
          }
        ]
      end

      it 'should return false' do
        response = KylasDataMask.field_is_masked_or_not?(masked_fields_list: masked_field_list_without_company_phone, user_profile_id: 2, field: 'companyPhones')
        expect(response).to eq(false)
      end
    end

    context 'when masking is enabled on the  given field' do
      let(:masked_fields_list) do
        [
          {
            "createdAt"=>"2023-04-28T08:22:21.873+0000",
            "updatedAt"=>"2023-10-03T06:21:35.378+0000",
            "createdBy"=>8112,
            "updatedBy"=>8112,
            "id"=>618220,
            "deleted"=>false,
            "version"=>1,
            "recordActions"=>nil,
            "metaData"=>nil,
            "tenantId"=>3691,
            "displayName"=>"Phone Numbers Masked",
            "description"=>nil,
            "type"=>"PHONE",
            "internalType"=>nil,
            "name"=>"phoneNumbers",
            "entityType"=>nil,
            "standard"=>true,
            "sortable"=>false,
            "filterable"=>true,
            "required"=>false,
            "important"=>true,
            "active"=>true,
            "multiValue"=>true,
            "length"=>nil,
            "isUnique"=>nil,
            "greaterThan"=>nil,
            "lessThan"=>nil,
            "lookupForEntity"=>nil,
            "internal"=>false,
            "lookupUrl"=>nil,
            "skipIdNameResolution"=>false,
            "picklist"=>nil,
            "regex"=>nil,
            "colorConfiguration"=>nil,
            "maskConfiguration"=>{"id"=>1, "enabled"=>true, "profileIds"=>[]}
          },
          {
            "createdAt"=>"2023-04-28T08:22:21.964+0000",
            "updatedAt"=>"2023-04-28T08:22:21.964+0000",
            "createdBy"=>8112,
            "updatedBy"=>8112,
            "id"=>618246,
            "deleted"=>false,
            "version"=>0,
            "recordActions"=>nil,
            "metaData"=>nil,
            "tenantId"=>3691,
            "displayName"=>"Company Phones",
            "description"=>nil,
            "type"=>"PHONE",
            "internalType"=>nil,
            "name"=>"companyPhones",
            "entityType"=>nil,
            "standard"=>true,
            "sortable"=>false,
            "filterable"=>true,
            "required"=>false,
            "important"=>false,
            "active"=>true,
            "multiValue"=>true,
            "length"=>nil,
            "isUnique"=>nil,
            "greaterThan"=>nil,
            "lessThan"=>nil,
            "lookupForEntity"=>nil,
            "internal"=>false,
            "lookupUrl"=>nil,
            "skipIdNameResolution"=>false,
            "picklist"=>nil,
            "regex"=>nil,
            "colorConfiguration"=>nil,
            "maskConfiguration"=>{"id"=>2, "enabled"=>true, "profileIds"=>[455, 452]}
          }
        ]
      end

      context 'when profile ids array in mask configuration is empty' do
        it 'should return true' do
          response = KylasDataMask.field_is_masked_or_not?(masked_fields_list: masked_fields_list, user_profile_id: 3, field: 'phoneNumbers')
          expect(response).to eq(true)
        end
      end

      context 'when profile ids array in mask configuration is not empty' do
        context 'when current user profile id is not included in profile ids array' do
          it 'should return false' do
            masked_fields_list.first['maskConfiguration']['profileIds'] = [3, 4]
            response = KylasDataMask.field_is_masked_or_not?(masked_fields_list: [], user_profile_id: 2, field: 'phoneNumbers')
            expect(response).to eq(false)
          end
        end

        context 'when current user profile id is included in profile ids array' do
          it 'should return true' do
            masked_fields_list.first['maskConfiguration']['profileIds'] = [2, 3, 4]
            response = KylasDataMask.field_is_masked_or_not?(masked_fields_list: masked_fields_list, user_profile_id: 3, field: 'phoneNumbers')
            expect(response).to eq(true)
          end
        end
      end
    end
  end

  describe '.format_field_value' do
    context 'when is_field_masked flag is true' do
      it 'should return masked field value' do
        response = KylasDataMask.format_field_value(value: '8308429939', masked: true)
        expect(response).to eq('****939')
      end
    end

    context 'when is_field_masked flag is false' do
      it 'should return unmasked field value' do
        response = KylasDataMask.format_field_value(value: '8308429939', masked: false)
        expect(response).to eq('8308429939')
      end
    end
  end
end
