# agents

There is two step to what the cookbook as a whole will do.
First off it will configure a windows server machine. This is done in the [default recipe](recipes/default.rb)
After this the system will reboot to install all the required files for the system.
Then it will run a new recipe [AutoConfigureNodesToMaster](recipes/AutoConfigureNodesToMaster.rb), where it will setup require programs and run scripts to connect a created node (this is also done in the recipe) and connect this node to the Jenkins Master.

---
### How to run:
There is an example in [Jenkinsfile](../../Jenkinsfile)
But to go more into details we use a tool called Chef Knife for Windows.
This tool can be found at [url](https://docs.chef.io/plugin_knife_windows.html). We use RubyGems to install the plugin. This plugin is a required part of the workstation that bootstrap all the nodes (more on what this is this later).

Powershell is a required shell to run the cookbook in.
Before you can run a cookbook (the recipes) up against a node we need to have configured both a Chef Workstation and a Chef Server.

#### Chef Workstation
A Chef Workstation is a machine that will bootstrap nodes. This mean that the workstation will send commands towards the chef server using a knife tool. These commands will the chef server forward to the specified node. Therefor to run chef recipes a workstation is need, and it will demand some of the system. My workstation takes arround 30% CPU to run a single instance of chef SDK.
Programs to run chef workstation:
[Chef SDK](https://downloads.chef.io/chefdk)
[Git](https://git-scm.com/downloads)
[Ruby](https://rubyinstaller.org/)
Knife-Windows install through RubyGem
`/opt/chef/embedded/bin/gem install knife-windows`
Knife-Windows install through Chef
`chef gem install knife-windows`
This Repository cloned


#### Chef Server
A detailed description on how to configure a chef server can be found [here](http://jira.kamstrup.dk/browse/CODE-224)
A chef server is the middleman in the configuration of the agents. The chef server job is to monitor all nodes in the system, what cookbooks and files to use and how often different recipes should be run on the different nodes.
On the image below you can see how Chef Server, Workstation and chef nodes play together in a setup.

<img src="https://www.chef.io/wp-content/uploads/2017/02/chefos-diagram-a489184d.svg" height="500" >

---
#### Commands
All commands are run from a powershell with workingdirectory at the root of this this repo.
From here we got some options.

To upload a new cookbook version of Agents:
Bump version in [metadata.rb](metadata.rb)
run `knife cookbook upload agents`

To Start a new node (configure the machine)
`knife bootstrap windows winrm ${nodeName} --winrm-user username --winrm-password 'password' --node-name ${nodeName} --run-list 'recipe[agents::default]'`

To link the configured node with the Jenkins master
`knife node run_list set ${nodeName} 'recipe[agents::AutoConfigureNodesToMaster]'`
`knife winrm 'name:${nodeName}' chef-client --winrm-user username --winrm-password 'password' --attribute ipaddress`

The above is with the assumption that a job already has ran on the node (default recipe).
All of this should never be run by another system than Jenkins or by Team Kaizen.


---
## Recipes

---
### Default
The [default recipe](recipes/default.rb) is a recipe that can configure a windows server manchine to run as a Jenkins Agent.
This includes installation of various application needed to build and test .NET application and installers.
A list is here listed in the order for execution in the recipe:
1. Chef-client is installed
2. Chef-client deletes a validation.pom if it exists (a new will and should be created every run)
3. Java_se is installed - newest is installed
4. Git is installed - Here we override som attributes to specify the version. These needs to be changed if we want to change the version of git
5. ms_dotnet_framework version 4.5, 4.5.1, 4.5.2 is installed if no newer version is installed
6. MSBuildFolder from MSBuild/Microsoft is copied to the machine
7. VisualStudio from MSBuild is copied to the machine
8. Portable from MSBuild is copied to the machine
9. Mongo ports is opened
10. Standalone Installshield is installed
11. vsBuildTools v17 is installed
12. MSBuildTools v15 is installed
13. MSBuild env path is set
14. .NET 3.0 is installed as a windows feature
15. Windows SDK 8.0 and 8.1 is installed
16. vc_redist.x64 and x86 is installed.
17. .NETPortable from Reference Assemblies is copied to the machine
18. NETFX 4.6 Tools from Microsoft SDK is copied to the machine
19. FxCop from vs v14 is copied to the machine
20. NUGET_HOME env variable is set
21. Reboot

---
### AutoConfigureNodesToMaster
The [AutoConfigureNodesToMaster recipe](recipes/AutoConfigureNodesToMaster.rb) is a recipe that can link a windows machine with java installed to a Jenkins Master.

It utilizes a Jenkins plugin called Swarm.
Swarm jenkins plugin is required on the Jenkins Master
https://wiki.jenkins.io/display/JENKINS/Swarm+Plugin 

How the recipe uses the plugin and what it overall does. The list is ordered for execution in the recipe.
1. Chef-client deletes a validation.pom
2. Swarm-client.jar version 3.4 is copied to the machine
3. a batch file to execute: `java -jar C:/swarm-client.jar -master https://jenkins-omnisoft.devtools.kamstrup.dk -sslFingerprints " " -username %username% -password %password% -labels general_purpose_agent -name %name% -executors 4 -fsroot C:/Jenkins -mode exclusive -disableClientsUniqueId` is run - This runs swarm-client that creates a node on the specified Jenkins master. Here we can edit all the information that otherwise is manual connected.
4. The batch is set as a service through a 3rd party app nssm.exe
5. The Service is active running and set to automatic start.



