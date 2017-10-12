echo off
set username=%1
set password=%2
set name=%3
java -jar C:/swarm-client.jar -master https://jenkins-omnisoft.devtools.kamstrup.dk -sslFingerprints " " -username %username% -password %password% -labels emil -name %name% -executors 10 -fsroot C:/Jenkins2 -mode exclusive -disableClientsUniqueId