require 'spec_helper'

RSpec.describe Post do

  let!(:user) { FactoryBot.create(:user) }
  let!(:ip)   { FactoryBot.create(:ip) }

  subject { described_class }

  context "record validations" do
    let(:title)       { 'title' }
    let(:body)        { 'body' }
    let(:blank_title) { '' }
    let(:blank_body)  { '' }

    let(:blank_error) {
      {title: [{error: :blank}],
       body:  [{error: :blank}]}
    }

    it 'creates new instance' do
      expect(IpsUsers.find_by(user_id: user.id, ip_id: ip.id)).to be_nil

      post = subject.new(title: title, body: body, user: user, ip: ip)

      expect(post.valid?).to be_truthy
      expect{ post.save! }.not_to raise_exception
      expect(post.title).to eq(title)
      expect(post.body).to eq(body)
      expect(post.errors.details).to eq({})

      expect(IpsUsers.find_by(user_id: user.id, ip_id: ip.id)).not_to be_nil
    end

    it 'fails (blank value)' do
      post = subject.new(title: blank_title, body: blank_body, user: user, ip: ip)

      expect(post.valid?).to be_falsey
      expect{ post.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(post.errors.details).to eq(blank_error)
    end
  end

  context "#update_avg_mark" do
    let(:post)  { FactoryBot.create(:post, user: user, ip: ip) }
    let(:mark1) { FactoryBot.create(:mark, mark: 1, post: post) }
    let(:mark2) { FactoryBot.create(:mark, mark: 2, post: post) }
    let(:mark3) { FactoryBot.create(:mark, mark: 3, post: post) }
    let(:avg_mark)    { 2.0 }
    let(:marks_count) { 3 }

    it 'updates avg mark' do
      expect(post.avg_mark).to be_nil
      [mark1, mark2, mark3]
      
      expect(post.avg_mark).to eq(avg_mark)
      expect(post.marks_count).to eq(marks_count)
    end
  end
end
