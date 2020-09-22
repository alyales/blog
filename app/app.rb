module Blog
  class App < Padrino::Application
    register Padrino::Helpers

    before do
      content_type :json
    end

    after do
      ActiveRecord::Base.clear_active_connections!
    end
  end
end
