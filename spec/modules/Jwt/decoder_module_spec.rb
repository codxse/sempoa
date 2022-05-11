require 'rails_helper'

RSpec.describe Jwt::DecoderModule do
  describe "#decode" do
    let(:payload) { { id: 1, name: 'Some User' } }
    let(:secret) { Jwt::ConstantsModule::SECRET }
    let(:alg) { Jwt::ConstantsModule::ALGO }

    it 'should return decoded value' do
      access_token, jti, exp = Jwt::EncoderModule.encode payload

      decoded_token = Jwt::DecoderModule.decode access_token
      
      expect(decoded_token[:sub]).to eq payload[:id]
      expect(decoded_token[:name]).to eq payload[:name]
      expect(decoded_token[:jti]).not_to eq nil
      expect(decoded_token[:jti]).to eq jti
      expect(decoded_token[:iat]).to eq Time.now.to_i
      expect(decoded_token[:exp]).to eq 90.minutes.from_now.to_i
      expect(decoded_token[:exp]).to eq exp
    end

    it 'should return nil if param not JWT' do
      encoded_data = 'lalala'

      result = Jwt::DecoderModule.decode encoded_data

      expect(result).to eq nil
    end

    it 'should verify token signature by default' do
      access_token = Jwt::EncoderModule.encode(payload).first
      header, _, signature = access_token.split('.')
      tempered_token = "#{header}.#{JWT::Base64.url_encode(JSON.generate(payload))}.#{signature}"

      result = Jwt::DecoderModule::decode tempered_token

      expect(result).to eq nil
    end

    it 'should verify JWT correctness by default' do
      encoded_data = 'eyJhbGciOiJIUzUxMiJ9.eyJhIjoiYiJ9.signature-abal-abal'

      result = Jwt::DecoderModule::decode encoded_data

      expect(result).to eq nil
    end

    it 'should not verify JWT correctness when verify option is false' do
      expected = { 'a' => 'b' }
      encoded_data = 'eyJhbGciOiJIUzUxMiJ9.eyJhIjoiYiJ9.signature-abal-abal'

      result = Jwt::DecoderModule::decode(encoded_data, verify: false)
      expect(result).to eq expected.symbolize_keys
    end

    it 'should bypass expiry checking when verify_expiration has been override' do
      expected = { 'a' => 'b', 'exp' => 90.minutes.ago.to_i }
      expire_token = JWT.encode(expected, secret, alg)

      result = Jwt::DecoderModule::decode(expire_token, verify: true, options: { verify_expiration: false })

      expect(result).to eq expected.symbolize_keys
    end

    it 'should do expiry checking by default' do
      payload[:exp] = 90.minutes.ago.to_i
      expired_token = JWT.encode(payload, secret, alg)

      result = Jwt::DecoderModule::decode expired_token

      expect(result).to eq nil
    end

    it 'should ignore the options when verify is false' do
      payload[:exp] = 90.minutes.ago.to_i
      expire_token = JWT.encode(payload, secret, alg)

      result = Jwt::DecoderModule::decode(expire_token, verify: false, options: { verify_expiration: true })

      expect(result).to eq payload
    end
  end
end
