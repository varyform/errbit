namespace :logrotate do
  desc "Setup logs rotation"
  task :setup, roles: :app do
    template "logrotate.erb", "/tmp/#{application}.conf"
    run "#{sudo} mv /tmp/#{application}.conf /etc/logrotate.d/#{application}"
  end
  after "deploy:setup", "logrotate:setup"
end
