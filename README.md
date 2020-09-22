blog
========
git clone https://github.com/alyales/blog.git

to create_db: rake ar:create && ar:migrate

padrino c

padrino s

examples of requests:

create post
========
curl -d "title=my_title&body=my_body&user_login=user1&ip_address=37.222.66.1" -X POST http://localhost:3000/api/create_post

mark post
========
curl -d "post_id=1&mark=4" -X POST http://localhost:3000/api/mark_post

get top posts
========
curl -d "limit=10" -X POST http://localhost:3000/api/top_posts

get ips lists
========
curl http://localhost:3000/api/ips_list
