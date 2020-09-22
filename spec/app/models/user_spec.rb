require 'spec_helper'

RSpec.describe User do

  let(:login)       { 'my_login' }
  let(:blank_login) { '' }
  let!(:db_user)    { FactoryBot.create(:user) }

  subject { described_class }

  context "record validations" do
    let(:blank_login_error) {
      {login: [{error: :blank }]}
    }
    let(:uniq_login_error) {
      {login: [{error: :taken, value: db_user.login}]}
    }

    it 'creates new instance' do
      user = subject.new(login: login)

      expect(user.valid?).to be_truthy
      expect{ user.save! }.not_to raise_exception
      expect(user.login).to eq(login)
      expect(user.errors.details).to eq({})
    end

    it 'fails (blank value)' do
      user = subject.new(login: blank_login)

      expect(user.valid?).to be_falsey
      expect{ user.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(user.errors.details).to eq(blank_login_error)
    end

    it 'fails (not uniq value)' do
      user = subject.new(login: db_user.login)

      expect(user.valid?).to be_falsey
      expect{ user.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(user.errors.details).to eq(uniq_login_error)
    end
  end

  context "#find_by_login" do
    it 'returns user' do
      user = subject.find_by_login(db_user.login)
      expect(user).to eq(db_user)
    end

    it 'returns nil (not found login)' do
      user = subject.find_by_login(login)
      expect(user).to be_nil
    end

    it 'returns nil (nil login)' do
      user = subject.find_by_login(nil)
      expect(user).to be_nil
    end
  end
end
