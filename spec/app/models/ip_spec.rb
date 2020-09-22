require 'spec_helper'

RSpec.describe Ip do

  let(:address)       { '127.127.127.127' }
  let(:blank_address) { '' }
  let!(:db_ip)        { FactoryBot.create(:ip) }

  subject { described_class }

  context "record validations" do
    let(:blank_error) {
      {address: [{error: :blank}]}
    }
    let(:uniq_error) {
      {address: [{error: :taken, value: db_ip.address}]}
    }

    it 'creates new instance' do
      ip = subject.new(address: address)

      expect(ip.valid?).to be_truthy
      expect{ ip.save! }.not_to raise_exception
      expect(ip.address).to eq(address)
      expect(ip.errors.details).to eq({})
    end

    it 'fails (blank value)' do
      ip = subject.new(address: blank_address)

      expect(ip.valid?).to be_falsey
      expect{ ip.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(ip.errors.details).to eq(blank_error)
    end

    it 'fails (not uniq value)' do
      ip = subject.new(address: db_ip.address)

      expect(ip.valid?).to be_falsey
      expect{ ip.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(ip.errors.details).to eq(uniq_error)
    end
  end

  context "#find_by_address" do
    it 'returns ip' do
      ip = subject.find_by_address(db_ip.address)
      expect(ip).to eq(db_ip)
    end

    it 'returns nil (not found address)' do
      ip = subject.find_by_address(address)
      expect(ip).to be_nil
    end

    it 'returns nil (nil address)' do
      ip = subject.find_by_address(nil)
      expect(ip).to be_nil
    end
  end
end
