set_default(:nr_license_key) { Capistrano::CLI.password_prompt "New Relic monitor license key: " }

namespace :newrelic_sysmond do
  desc "Install and configure latest release of NewRelic server monitor."
  task :install do
    run "#{sudo} wget -O /etc/apt/sources.list.d/newrelic.list http://download.newrelic.com/debian/newrelic.list"
    run "#{sudo} apt-key adv --keyserver hkp://subkeys.pgp.net --recv-keys 548C16BF"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y -q install newrelic-sysmond"
  end
  after "deploy:install", "newrelic_sysmond:install"

  desc "Configure and run monitor."
  task :setup do
    run "#{sudo} nrsysmond-config --set license_key=#{nr_license_key}"
    run "#{sudo} service newrelic-sysmond restart"
  end
  after "deploy:setup", "newrelic_sysmond:setup"
end
