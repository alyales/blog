collection @posts, object_root: false

node(:title) {|post| post.title}
node(:body) {|post| post.body}
node(:avg_mark) {|post| post.avg_mark}
