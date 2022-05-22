require 'rails_helper'

RSpec.describe User, type: :model do
  context 'association' do
    it { should have_many(:jwt_refresh_tokens) }
    it { should have_many(:jwt_whitelisted_tokens) }
    it { should have_many(:jwt_blacklisted_tokens) }
  end

  context 'enum' do
    it 'should have role that match' do
      should define_enum_for(:role).
        with_values([:admin, :regular]).
        backed_by_column_of_type(:integer)
    end
  end

  context 'validation' do
    let(:subject) { FactoryBot.create :user }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end

  context 'default value' do
    let(:subject) { FactoryBot.create :user }

    it 'should have default value false for :email_verified' do
      expect(subject.email_verified).to eq false
    end
  end
end
