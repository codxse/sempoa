require 'rails_helper'

RSpec.describe Jwt::EncoderModule do
  describe "#encode" do
    it 'should return correct encoded token based on given user_info' do
      mock_user = {
        id: 1,
        name: 'Some User'
      }

      access_token, jti, exp = Jwt::EncoderModule.encode mock_user
      decoded_token = Jwt::DecoderModule.decode access_token

      expect(decoded_token[:sub]).to eq mock_user[:id]
      expect(decoded_token[:name]).to eq mock_user[:name]
      expect(decoded_token[:jti]).not_to eq nil
      expect(decoded_token[:jti]).to eq jti
      expect(decoded_token[:iat]).to eq Time.now.to_i
      expect(decoded_token[:exp]).to eq 90.minutes.from_now.to_i
      expect(decoded_token[:exp]).to eq exp
    end

    it 'should return nil if id is missing' do
      invalid_user = {
        name: 'Invalid User'
      }

      expect(Jwt::EncoderModule.encode invalid_user).to eq nil
    end
  end
end
