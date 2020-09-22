class PostsManager
  class << self

    def create_post(title, body, user_login, ip_address)
      errors = {}

      user = get_user(user_login, errors)
      ip = get_ip(ip_address, errors)
      new_post = get_post_instance(title, body, errors)

      if errors.blank?
        user.save! if user.new_record?
        ip.save!   if ip.new_record?

        new_post.user = user
        new_post.ip = ip
        new_post.save!
        new_post
      end
      
      {errors: errors, post: new_post}
    end

    def create_mark(post_id, mark)
      errors = {}

      mark = get_mark_instance(post_id, mark, errors)
      mark.save! if errors.blank?

      {errors: errors, mark: mark}
    end

    private

    def get_user(login, errors)
      user = User.find_by_login(login)

      if user.nil?
        user = User.new(login: login)
        model_error(user, :user, errors)
      end

      user
    end

    def get_ip(address, errors)
      ip = Ip.find_by_address(address)

      if ip.nil?
        ip = Ip.new(address: address)
        model_error(ip, :ip, errors)
      end

      ip
    end

    def get_post_instance(title, body, errors)
      post = Post.new(title: title, body: body)
      model_error(post, :post, errors)

      post
    end

    def get_mark_instance(post_id, mark, errors)
      mark = Mark.new(post_id: post_id, mark: mark)
      post = mark.post

      model_error(mark, :mark, errors)
      errors[:post] = ['no post with such id'] unless post.present?

      mark
    end

    def model_error(instance, key, errors)
      errors[key] = instance.errors.messages unless instance.valid?
    end

  end
end
