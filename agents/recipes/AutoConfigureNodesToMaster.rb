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

cookbook_file 'C:\RegisterScheduledTask.ps1' do
  source 'RegisterScheduledTask.ps1'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end

powershell_script 'ExecuteTaskScheduler' do
  code '. C:\RegisterScheduledTask.ps1'
end


