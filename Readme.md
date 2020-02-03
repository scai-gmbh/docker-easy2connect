# Docker-based setup of easy2connect-scripts
## Basic usage
* Install docker and docker-compose
* Generate easyconnnect-Id (e2cid), installcode and VPN-password
```
curl -q https://members.feste-ip.net/e2cbuilder/?TASK=NEW -c /tmp/cookie -o /tmp/e2cbuild.tgz
curl -q https://members.feste-ip.net/e2cbuilder/?TASK=NEW -b /tmp/cookie
```
This outputs the data on the console.
* Add the new FIP-Box in the web interface
https://www.feste-ip.net/mein-account/acc/easy2connect/register/
* Edit build.sh 
    * Set e2cid (see https://www.feste-ip.net/account/easy2connect/
    * Set installcode (needs to be obtained before)
* Run build.sh
```
sudo ./build.sh
```
* Add the new docker instance as a new service to be started on boot of your machine
## File reference
### build.sh
The basic deployment script
### docker-compose.yml
Passing the e2cid and installcode environment variables into the docker instance. The volume on tmp is just for debugging purposes.
### Dockerfile
Copies scripts into docker instance, installs basic packages and runs scripts. 
#### Beware: Hacks! 
There is an evil hack with /etc/issue.net since the scripts seem to try to determine the Linux environment based on /etc/issue.net but fail to do so correctly in the docker instance. The provided /etc/issue.net hacks around this.
### sysprep.sh
Installs openvpn and knockd. 
### install.sh
Gets data based on e2cid and installcode from feste-ip.net.
### easy2connect
This file is run on each start of the docker instance. It gets the current configuration for the e2cid from feste-ip.net and opens the VPN tunnel based on the settings. 
#### Beware: Hacks!
* There is also a mean hack for /etc/resolv.conf to always use the Google nameserver, since the docker nameserver seemed to fail in my environment.
* Another hack is adding a log-append option to /tmp/easy2connect/openvpn/ec.conf for better debugging.
* The last hack is that since the script to run (run.sh) is downloaded from feste-ip.net. But we want two things to happen in it: 
   * We want a trap on signal 15 and a sleep infinity in the end, so that we can stop the script. This stopping is usually performed by knockd, which listens on commands from feste-ip.net. feste-ip.net issues a knock-sequence across the established VPN, if the configuration is changed in the web interface. We need to process this command in a way, that we stop all runnings scripts, refetch the current configuration and restart our scripts.
   * The sleep is necessary, since we want our script to block until run.sh got terminated - most likely through knockd.
### easy2connectrefresh
This file is run by knockd, when feste-ip.net wants the FIP-Box to restart.
#### Beware: Hacks!
Currently it issues a "pkill -9", but with the trap set on signal 15 it should also be possible to just use "pkill". Maybe we do not understand correctly how "trap", "sleep" and "kill" work together? Needs some debugging and/or RTFM on these...



  
