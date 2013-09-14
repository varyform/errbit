set_default(:mandrill_username) { Capistrano::CLI.ui.ask 'Mandrill SMTP username: ' }
set_default(:mandrill_password) { Capistrano::CLI.password_prompt 'Mandrill SMTP password: ' }
set_default(:mandrill_host)     { Capistrano::CLI.ui.ask 'Mandrill host: ' }

namespace :mandrill do
  desc 'Setup Mandrill configuration'
  task :setup, roles: :app do
    config = <<-CONFIG.gsub(/^\s+/, '')
      username: #{mandrill_username}
      password: #{mandrill_password}
      host: #{mandrill_host}
    CONFIG

    run "mkdir -p #{shared_path}/config"
    put config, "#{shared_path}/config/mandrill.yml"
  end
  after 'deploy:setup', 'mandrill:setup'

  desc 'Symlink the mandrill.yml file into the latest release'
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/mandrill.yml #{release_path}/config/mandrill.yml"
  end
  after 'deploy:finalize_update', 'mandrill:symlink'
end
