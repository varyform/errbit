namespace :mongoid do
  desc "Install the latest stable release of mongoid."
  task :install, roles: :db, only: {primary: true} do
    run "#{sudo} apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10"
    run "echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install mongodb-10gen"
  end
  after "deploy:install", "mongoid:install"
end
