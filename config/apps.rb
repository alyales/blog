# Mounts the core application for this project
Padrino.mount('Blog::App', :app_file => Padrino.root('app/app.rb')).to('/')
