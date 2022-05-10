require 'rails_helper'

RSpec.describe JwtService do
  context "#self.encode" do
    it 'should return correct encoded token based on given user_info' do
      payload = { sub: 1, name: 'Nadiar AS' }
      token = JwtService.encode payload

      decoded_token = JwtService.decode token

      expect(decoded_token['sub']).to eq(payload[:sub])
      expect(decoded_token['name']).to eq(payload[:name])
      expect(decoded_token['iat']).to eq(Time.now.to_i)
      expect(decoded_token['exp']).to eq 90.minutes.from_now.to_i
    end
  end

  context "#self.decode" do
    let(:payload) { { sub: 1, name: 'Nadiar AS' } }
    let(:secret) { JwtService::SECRET }
    let(:alg) { JwtService::ALG }

    it "should return decoded value" do
      token = JwtService.encode payload

      decoded = JwtService.decode token

      expect(decoded.to_json).to eq payload.to_json
    end

    it "should return empty json if param not JWT" do
      data = {}
      encoded_data = 'lalala'

      result = JwtService.decode encoded_data

      expect(result).to eq data
    end

    it 'should verify token signature by default' do
      expected = {}
      token = JwtService.encode(sub: 'before-tempered-id')
      payload = token.split(".")
      payload[1] = JWT::Base64.url_encode(JSON.generate(sub: 'tampered-id'))
      tempered_token = payload.join(".")

      result = JwtService.decode(tempered_token)

      expect(result).to eq expected
    end

    it 'should verify JWT correctness by default' do
      expected = {}
      encoded_data = 'eyJhbGciOiJIUzUxMiJ9.eyJhIjoiYiJ9.signature-abal-abal'

      result = JwtService.decode encoded_data

      expect(result).to eq expected
    end

    it 'should not verify JWT correctness when verify option is false' do
      expected = { "a" => "b" }
      encoded_data = 'eyJhbGciOiJIUzUxMiJ9.eyJhIjoiYiJ9.signature-abal-abal'

      result = JwtService.decode(encoded_data, verify: false)
      expect(result).to eq expected
    end

    it 'should bypass expiry checking when verify_expiration has been override' do
      expected = { "a" => "b", "exp" => 90.minutes.ago.to_i }
      expire_token = JWT.encode(expected, secret, alg)

      result = JwtService.decode(expire_token, verify: true, options: { verify_expiration: false })

      expect(result).to eq expected
    end

    it 'should do expiry checking by default' do
      expected = {}
      payload[:exp] = 90.minutes.ago.to_i
      expired_token = JWT.encode(payload, secret, alg)

      result = JwtService.decode(expired_token, verify: true)

      expect(result).to eq expected
    end

    it 'should ignore the options when verify is false' do
      payload = { "exp" => 90.minutes.ago.to_i }
      expire_token = JWT.encode(payload, secret, alg)

      result = JwtService.decode(expire_token, verify: false, options: { verify_expiration: true })

      expect(result).to eq payload
    end
  end
end
