require 'json'

def create_posts(ip_addresses, user_logins, i, marks)
  http_path = 'http://localhost:3000/api/create_post'
  resp = `curl -X POST -d "title=title#{i}&body=body#{i}&user_login=#{user_logins.sample}&ip_address=#{ip_addresses.sample}" #{http_path}`

  id = JSON.parse(resp).dig('post', 'id')

  if id % 13 == 0
    `curl -d "post_id=#{id}&mark=#{marks.sample}" -X POST http://localhost:3000/api/mark_post`
  end

  if id % 37 == 0
    `curl -d "post_id=#{id}&mark=#{marks.sample}" -X POST http://localhost:3000/api/mark_post`
  end
end

def in_parallel
  marks = [1, 2, 3, 4, 5]
  user_logins  = 1.upto(100).map{|n| "user#{n}"}
  ip_addresses = 1.upto(50).map{|n| "37.222.66.#{n}"}

  threads = []
  threads << Thread.new do
    1.upto(50000) do |i|
      create_posts(user_logins, ip_addresses, i, marks)
    end
  end

  threads << Thread.new do
    50001.upto(100000) do |i|
      create_posts(user_logins, ip_addresses, i, marks)
    end
  end

  threads << Thread.new do
    100001.upto(150000) do |i|
      create_posts(ips, users, i, marks)
    end
  end

  threads << Thread.new do
    150001.upto(200000) do |i|
      create_posts(ips, users, i, marks)
    end
  end
  threads.map(&:join)
end

in_parallel
