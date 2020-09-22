Blog::App.controllers :api do

  post :create_post do
    result = PostsManager.create_post(params[:title], params[:body],
                                      params[:user_login], params[:ip_address])

    if (errors = result[:errors]).present?
      error_response(422, errors)
    else
      @post = result[:post]
      render :create_post
    end
  end

  post :mark_post do
    result = PostsManager.create_mark(params[:post_id], params[:mark])

    if (errors = result[:errors]).present?
      error_response(422, errors)
    else
      @post = result[:mark].post
      render :mark_post
    end
  end

  post :top_posts do
    if params[:limit].blank? || params[:limit].to_i <= 0
     errors = { limit: 'invalid value' }
     error_response(400, errors)
    else
      @posts = Post.top_by_avg_mark(params[:limit])
      render :top_posts
    end
  end

  get :ips_list do
    ip_ids = IpsUsers.with_several_users.pluck(:ip_id)
    @ips_with_users = Ip.with_users(ip_ids)

    render :ips_list
  end

  define_method :error_response do |code, errors|
    status code
    body errors.to_json
  end
end
