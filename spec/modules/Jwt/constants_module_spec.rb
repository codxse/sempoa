require 'rails_helper'

RSpec.describe Jwt::ConstantsModule do
  describe '#ALGO' do
    it 'should equal to HS512' do
      expect(Jwt::ConstantsModule::ALGO).to eq 'HS512'
    end
  end

  describe '#SECRET' do
    it 'should not null' do
      expect(Jwt::ConstantsModule::SECRET).not_to be nil
    end

    it 'should be a String' do
      expect(Jwt::ConstantsModule::SECRET).to be_a String
    end

    it 'should be equal to env' do
      expect(Jwt::ConstantsModule::SECRET).to eq ENV.fetch('JWT_SECRET')
    end
  end
end
