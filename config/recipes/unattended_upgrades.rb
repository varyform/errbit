namespace :unattended_upgrades do
  desc "Install unattended-upgrades package"
  task :install, roles: :web do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install unattended-upgrades"
  end
  after "deploy:install", "unattended_upgrades:install"

  desc "Setup unattended-upgrades configuration"
  task :setup, roles: :web do
    config = <<-CONFIG.gsub(/^\s+/, '')
      APT::Periodic::Update-Package-Lists "1";
      APT::Periodic::Unattended-Upgrade "1";
    CONFIG

    put config, "/tmp/20auto-upgrades"
    run "#{sudo} mv /tmp/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades"
    restart
  end
  after "deploy:setup", "unattended_upgrades:setup"

  %w[start stop restart].each do |command|
    desc "#{command} unattended-upgrades"
    task command, roles: :web do
      run "#{sudo} service unattended-upgrades #{command}"
    end
  end
end
