collection @ips_with_users, object_root: false

node(:ip) {|ip| ip.address}
node(:users) {|ip| ip.users.pluck(:login)}
