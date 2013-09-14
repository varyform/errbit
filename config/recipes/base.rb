def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

namespace :deploy do
  desc "Install everything onto the server"
  task :install do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install python-software-properties ntp"
  end

  # this is required since we're not using sudo
  task :create_deploy_to_dir_and_set_owner, :except => { :no_release => true } do
    run "#{sudo} mkdir -p #{deploy_to}"
    run "#{sudo} chown #{user}:#{user} #{deploy_to}"
  end
  before "deploy:setup", "deploy:create_deploy_to_dir_and_set_owner"
end
