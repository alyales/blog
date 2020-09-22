require 'spec_helper'

RSpec.describe Mark do
  
  let!(:db_user) { FactoryBot.create(:user) }
  let!(:db_ip)   { FactoryBot.create(:ip) }
  let!(:db_post) { FactoryBot.create(:post, user: db_user, ip: db_ip) }

  subject { described_class }

  context "record validations" do
    let(:mark)        { 4 }
    let(:blank_mark)  { nil }
    let(:string_mark) { 'string' }
    let(:small_mark)  { 0 }
    let(:big_mark)    { 6 }

    let(:blank_error) {
      {mark: [{error: :blank},
              {error: :not_a_number, value: nil}]}
    }
    let(:not_a_number_error) {
      {mark: [{error: :not_a_number, value: string_mark}]}
    }
    let(:greater_threshold_error) {
      {mark: [{error: :greater_than_or_equal_to, value: small_mark, count: 1 }]}
    }
    let(:less_threshold_error) {
      {mark: [{error: :less_than_or_equal_to, value: big_mark, count: 5 }]}
    }

    it 'creates new instance' do
      m = subject.new(mark: mark, post: db_post)

      expect(m.valid?).to be_truthy
      expect{ m.save! }.not_to raise_exception
      expect(m.mark).to eq(mark)
      expect(m.errors.details).to eq({})
    end

    it 'fails (blank value)' do
      m = subject.new(mark: blank_mark, post: db_post)

      expect(m.valid?).to be_falsey
      expect{ m.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(m.errors.details).to eq(blank_error)
    end

    it 'fails (not a number)' do
      m = subject.new(mark: string_mark, post: db_post)

      expect(m.valid?).to be_falsey
      expect{ m.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(m.errors.details).to eq(not_a_number_error)
    end

    it 'fails (less than 1)' do
      m = subject.new(mark: small_mark,  post: db_post)

      expect(m.valid?).to be_falsey
      expect{ m.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(m.errors.details).to eq(greater_threshold_error)
    end

    it 'fails (greater than 5)' do
      m = subject.new(mark: big_mark,  post: db_post)

      expect(m.valid?).to be_falsey
      expect{ m.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(m.errors.details).to eq(less_threshold_error)
    end
  end
end
