require 'spec_helper'

RSpec.describe :api, type: :controller do

  let!(:user) { FactoryBot.create(:user) }
  let!(:ip) { FactoryBot.create(:ip) }
  let!(:my_post) { FactoryBot.create(:post, user_id: user.id, ip_id: ip.id) }

  describe "POST :create_post" do
    let(:params) {
      { title: title,
        body: body,
        user_login: user_login,
        ip_address: ip_address }
    }

    context 'creates new post & ip & user' do
      let(:title) { 'my_title' }
      let(:body)  { 'my_body' }
      let(:user_login) { 'my_user_login' }
      let(:ip_address) { '37.222.66.111' }

      let(:expected_response) {
        { post: { id: 2,
                  title: title,
                  body: body,
                  ip_id: 2,
                  user_id: 2 }
        }
      }

      it 'returns post attrs' do
        post 'api/create_post', params

        expect_response_with_status(200)
      end
    end

    context 'creates new post with existing user & ip' do
      let(:title) { 'myy_title' }
      let(:body) { 'myy_body' }
      let(:user_login) { user.login }
      let(:ip_address) { ip.address }

      let(:expected_response) {
        { post: { id: 4,
                  title: title,
                  body: body,
                  ip_id: ip.id,
                  user_id: user.id }
        }
      }

      it 'returns post attrs' do
        post 'api/create_post', params
        
        expect_response_with_status(200)
      end
    end

    context 'validation errors' do
      let(:title) { '' }
      let(:body) { '' }
      let(:user_login) { '' }
      let(:ip_address) { '' }

      let(:expected_response) {
        { user: { login: ["can't be blank"] },
          ip: { address: ["can't be blank"] },
          post: { title: ["can't be blank"], body: ["can't be blank"] }
        }
      }

      it 'fails with 422 status' do
        post 'api/create_post', params
        expect_response_with_status(422)
      end
    end
  end


  describe "POST :mark_post" do
    let(:params) {
      { post_id: post_id,
        mark:    mark }
    }

    context 'mark creation' do
      let(:post_id) { my_post.id }
      let(:mark) { 4 }

      let(:expected_response) {
        { :avg_mark => 4.0 }
      }

      it 'returns avg mark' do
        post 'api/mark_post', params

        expect_response_with_status(200)
      end
    end

    context 'validation errors' do
      let(:post_id) { 'post_id' }
      let(:mark) { 0 }

      let(:expected_response) {
        { mark: { mark: ["must be greater than or equal to 1"] },
          post: ["no post with such id"] }
      }

      it 'fails with 422 status' do
        post 'api/mark_post', params

        expect_response_with_status(422)
      end
    end
  end


  describe "POST :top_posts" do
    let(:params) {
      { limit: limit }
    }
    let(:marks) { [1, 2, 3, 4, 5] }

    before(:each) { create_posts_with_marks }

    context 'return result' do
      let(:limit) { 5 }
      let(:expected_response) {
        [{"title"=>"title8", "body"=>"very interesting body", "avg_mark"=>3.5},
         {"title"=>"title10", "body"=>"very interesting body", "avg_mark"=>3.5},
         {"title"=>"title7", "body"=>"very interesting body", "avg_mark"=>3.0},
         {"title"=>"title9", "body"=>"very interesting body", "avg_mark"=>3.0},
         {"title"=>"title11", "body"=>"very interesting body", "avg_mark"=>3.0}]
      }

      it 'returns list with ips and user logins' do
        post 'api/top_posts', params

        expect_response_with_status(200)
      end
    end

    context 'validation errors' do
      let(:limit) { 'limit' }
      let(:expected_response) {
        { limit: 'invalid value' }
      }

      it 'fails with 400 status' do
        post 'api/top_posts', params

        expect_response_with_status(400)
      end
    end
  end


  describe "GET :ips_list" do
    let(:expected_response) {
      [{"ip"=>"127.127.127.9", "users"=>["login9", "login8"]},
       {"ip"=>"127.127.127.11", "users"=>["login11", "login10"]},
       {"ip"=>"127.127.127.13", "users"=>["login13", "login12"]},
       {"ip"=>"127.127.127.15", "users"=>["login15", "login14"]},
       {"ip"=>"127.127.127.17", "users"=>["login17", "login16"]}]
    }

    before(:each) { create_ips_users }

    it 'returns list with ips and user logins' do
      get 'api/ips_list'
      
      expect_response_with_status(200)
    end
  end

  def expect_response_with_status(status)
    expect(last_response.status).to eq(status)
    expect(parsed_response).to eq(expected_response)
  end

  def parsed_response
    body = JSON.parse(last_response.body)
    body.is_a?(Hash) ? body.deep_symbolize_keys : body
  end

  def create_posts_with_marks
    5.times do
      post = FactoryBot.create(:post, user_id: user.id, ip_id: ip.id)

      Mark.create(post_id: post.id, mark: 2)

      case post.id % 2
      when 0
        Mark.create(post_id: post.id, mark: 5)
      when 1
        Mark.create(post_id: post.id, mark: 4)
      end
    end
  end

  def create_ips_users
    10.times do
      user = FactoryBot.create(:user)
      ip = FactoryBot.create(:ip)

      IpsUsers.create(ip_id: ip.id, user_id: user.id)
      IpsUsers.create(ip_id: ip.id, user_id: user.id - 1) if user.id % 2 == 0
    end
  end
end
