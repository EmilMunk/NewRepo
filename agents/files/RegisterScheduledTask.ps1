# --------------------------------------------------------------------------------------------------------
# Script: RegisterScheduledTask.ps1
# Author: Emil Munksø Jørgensen, Kamstrup A/S
# Date 06-10-2017
# Comments: Powershell script to register a scheduled task for auto configuration of a jenkins node
# --------------------------------------------------------------------------------------------------------

$action = New-ScheduledTaskAction -execute 'runJenkinsAgentSetup.bat' -WorkingDirectory 'C:\'
$trigger = New-ScheduledTaskTrigger -AtStartup
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable -DontStopOnIdleEnd
$Principal = New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType S4U -RunLevel Highest
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "AutoConfigureJenkinsAgents" -Description "This is a fine description" -Force -Settings $settings -Principal $Principal