# install and configure a chef-client
include_recipe 'chef-client::default'
log 'message' do
  message 'chef-client::default done.'
  level :info
end

# # Delete the valdiation.pem
include_recipe 'chef-client::delete_validation'
log 'message' do
  message 'chef-client::delete_validation done.'
  level :info
end
# Install and configure java
include_recipe 'java_se'
log 'message' do
  message 'java:install done.'
  level :info
end

# Override git version and download url. Remember to update the checksum
node.override['git']['version'] = '2.11.0'
node.override['git']['url'] = 'https://github.com/git-for-windows/git/releases/download/v2.11.0.windows.3/Git-2.11.0.3-64-bit.exe'
node.override['git']['checksum'] = 'c3897e078cd7f7f496b0e4ab736ce144c64696d3dbee1e5db417ae047ca3e27f'
node.override['git']['display_name'] = "Git version #{node['git']['version']}"
# Install git
include_recipe 'git::default'
log 'message' do
  message 'git_client::defualt:install done.'
  level :info
end

# Install ms_dotnetframework4.5
ms_dotnet_framework '4.5' do
  action            :install
end

ms_dotnet_framework '4.5.1' do
  action            :install
end

ms_dotnet_framework '4.5.2' do
  action            :install
end

log 'message' do
  message 'ms_dotnetframework::default:install done.'
  level :info
end

# Make directories for installation files
%w[ /installfiles /installfiles/installShield /installfiles/vsBuildTools /installfiles/MSBuild /installfiles/SDK ].each do |path|
  directory path do
    owner 'Administrator'
    group 'Administrators'
    mode '0755'
  end
end

# Make directory for MSBuild
directory "MSBuildFolder"  do
   path "C:\\Program Files (x86)\\MSBuild\\Microsoft"
     recursive true
     owner 'Administrator'
     group 'Administrator'
     action    :create
end

# Copy a lot of files
cookbook_file 'C:\installfiles\VisualStudio.zip' do
  source 'VisualStudio.zip'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end

cookbook_file 'C:\installfiles\Portable.zip' do
  source 'Portable.zip'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end


cookbook_file 'C:\installfiles\OpenPort27021.bat' do
  source 'OpenPort27021.bat'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end
# Run script for opening port 27021 that mongo is using
batch 'run-script' do
  code 'OpenPort27021.bat'
  cwd 'C:/installfiles'
  action :run
end

# unzip MSBuild protable files
zipfile 'C:\installfiles\Portable.zip' do
  into 'C:\\Program Files (x86)\\MSBuild\\Microsoft'
end

#unzip visualStudio MSBuild files
zipfile 'C:\installfiles\VisualStudio.zip' do
  into 'C:\\Program Files (x86)\\MSBuild\\Microsoft'
end

# Copy mroe files
cookbook_file 'C:\installfiles\installShield\setupInstallShield.exe' do
  source 'InstallShield/setupInstallShield.exe'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end
log 'message' do
  message 'Installshield setup.exe File copied to node'
  level :info
end

cookbook_file 'C:\installfiles\installShield\setupInstallShield.bat' do
  source 'InstallShield/setupInstallShield.bat'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end
log 'message' do
  message 'Installshield setup.bat File copied to node'
  level :info
end


## Need to download vs build tools from artifactory
## some gradle script to download possibly
cookbook_file 'C:\installfiles\vsBuildTools\setupVSBT.exe' do
  source 'vsBuildTools/setupVSBT.exe'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end
log 'message' do
  message 'vsBuildTools setupVSBT.exe File copied to node'
  level :info
end

cookbook_file 'C:\installfiles\vsBuildTools\setupVSBTrun.bat' do
  source 'vsBuildTools/setupVSBTrun.bat'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end
log 'message' do
  message 'Installshield setup.bat File copied to node'
  level :info
end

cookbook_file 'C:\installfiles\MSBuild\BuildTools_Full.exe' do
  source 'MSBuild/BuildTools_Full.exe'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end
log 'message' do
  message 'MSBuild BuildTools_Full.exe File copied to node'
  level :info
end

cookbook_file 'C:\installfiles\MSBuild\setupMSBuild.bat' do
  source 'MSBuild/setupMSBuild.bat'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end

log 'message' do
  message 'MSBuild setupMSBuild.bat File copied to node'
  level :info
end

# Setup MSBuild path variable
cookbook_file 'C:\installfiles\SetMSBuildPath.ps1' do
  source 'SetMSBuildPath.ps1'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
  action :create
end

powershell_script 'ExecutePathVariable' do
  code '. C:\installfiles\SetMSBuildPath.ps1'
end

powershell_script 'Install .NET3.0' do
  code 'Install-WindowsFeature Net-Framework-Core -source \\network\share\sxs'
end

# cookbook_file 'C:\installfiles\SDK\win7sdksetup.exe' do
#   source 'SDK/win7sdksetup.exe'
#   owner 'Administrator'
#   group 'Administrators'
#   mode '0755'
# end

# remote_directory 'C:\installfiles\SDK\win7SDK' do
#   source 'win7SDK'
#   owner 'Administrator'
#   group 'Administrators'
#   mode '0755'
#   action :create
# end

# batch 'run-script' do
#   code 'win7SDKsetup.bat'
#   cwd 'C:/installfiles/SDK/win7SDK'
#   action :run
# end

cookbook_file 'C:\installfiles\SDK\win8sdksetup.exe' do
  source 'SDK/win8sdksetup.exe'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end
cookbook_file 'C:\installfiles\SDK\win81sdksetup.exe' do
  source 'SDK/win81sdksetup.exe'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end
cookbook_file 'C:\installfiles\SDK\SDKsetup.bat' do
  source 'SDK/SDKsetup.bat'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end

batch 'run-script' do
  code 'SDKsetup.bat'
  cwd 'C:/installfiles/SDK'
  action :run
end

# Install VS 2015 redistributable 
cookbook_file 'C:\installfiles\vc_redist.x64.exe' do
  source 'vc_redist.x64.exe'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end
cookbook_file 'C:\installfiles\vc_redist.x86.exe' do
  source 'vc_redist.x86.exe'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end
cookbook_file 'C:\installfiles\InstallRedi.bat' do
  source 'InstallRedi.bat'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end

batch 'run-script' do
  code 'InstallRedi.bat'
  cwd 'C:/installfiles'
  action :run
end

# Make directory for .NETPortable
directory ".NETPortable"  do
   path "C:\\Program Files (x86)\\Reference Assemblies\\Microsoft\Framework\\.NETPortable"
     recursive true
     owner 'Administrator'
     group 'Administrator'
     action    :create
end

cookbook_file 'C:\installfiles\.NETPortable.zip' do
  source '.NETPortable.zip'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end


# unzip .NETFrameworks
zipfile 'C:\installfiles\.NETPortable.zip' do
  into 'C:\\Program Files (x86)\\Reference Assemblies\\Microsoft\\Framework\\.NETPortable'
end


directory "NETFX 4.6 Tools"  do
   path "C:\\Program Files (x86)\\Microsoft SDKs\\Windows\\v10.0A\\bin\\NETFX 4.6 Tools"
     recursive true
     owner 'Administrator'
     group 'Administrator'
     action    :create
end

cookbook_file 'C:\installfiles\NETFX_4.6_Tools.zip' do
  source 'NETFX_4.6_Tools.zip'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
end

zipfile 'C:\installfiles\NETFX_4.6_Tools.zip' do
  into 'C:\\Program Files (x86)\\Microsoft SDKs\\Windows\\v10.0A\\bin\\NETFX 4.6 Tools'
end


# Install FxCop by copying
directory "FxCop" do
  path "C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\Team Tools\\Static Analysis Tools"
  recursive true
    owner 'Administrator'
     group 'Administrator'
     action    :create
end

cookbook_file 'C:\installfiles\FxCop.zip' do
  source 'FxCop.zip'
  owner 'Administrator'
  group 'Administrators'
  mode '0755'
  action :create
end

zipfile 'C:\Installfiles\FxCop.zip' do
  into 'C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\Team Tools\\Static Analysis Tools'
end


# install installshield and vsbuild tools
batch 'run-script' do
  code 'setupVSBTrun.bat'
  cwd 'C:/installfiles/vsBuildTools'
  action :run
end

batch 'run-script' do
  code 'setupInstallShield.bat'
  cwd 'C:/installfiles/installShield'
  action :run
end

# Install MSBuild
batch 'run-script' do
  code 'setupMSBuild.bat'
  cwd 'C:/installfiles/MSBuild'
  action :run
end

# Reboot after all is installed. 
reboot 'app_requires_reboot' do
  action :request_reboot
  reason 'Need to cancel reboot when the run completes successfully.'
  ignore_failure true
end
log 'message' do
  message 'Reboot complete.'
  level :info
end
return 
