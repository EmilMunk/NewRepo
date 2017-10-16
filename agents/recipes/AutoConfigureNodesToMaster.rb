# Delete the valdiation.pem
include_recipe 'chef-client::delete_validation'
log 'message' do
  message 'chef-client::delete_validation done.'
  level :info
end

cookbook_file 'C:\swarm-client.jar' do
  source 'swarm-client.jar'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end
my_short_name = node.name
log 'message' do
  message my_short_name
  level :info
end

cookbook_file 'C:\runJenkinsAgent.bat' do
  source 'RunJenkinsAgent.bat'
  mode '0755'
  owner 'Administrator'
  group 'Administrators'
  action :create
end

file 'C:\runJenkinsAgentSetup.bat' do
  content "RunJenkinsAgent emj Louise123402 #{my_short_name}"
  mode '0755'
  owner 'Administrator'
  group 'Administrators'
end

cookbook_file 'C:\nssm.exe' do
  source 'nssm.exe'
  mode '0755'
  owner 'Administrator'
  group 'Administrators'
  action :create
end

powershell_script 'ExecuteServiceInstall' do
  code 'C:\nssm install JenkinsAgent C:\runJenkinsAgentSetup.bat'
end

powershell_script 'ExecuteServiceInstall' do
  code 'C:\nssm start JenkinsAgent'
end




