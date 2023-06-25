# Prota's Docker Factorio Server

## Description
Prota's take on a container-based server for the game Factorio. The goal is a lightweight but 
functional server with as few external dependencies required on the host machine as possible.

## Getting Started
The defaults included in this project are reasonably sane for a single server setup. If you find 
yourself wanting more than one server instance or need/want to customize different aspects of the 
setup, a more complex guide is also included. These guides assume you have already cloned the 
repository to the hosting location.

### Hosting Requirements
- Docker
- Docker Compose V1 (V2 may work fine but is currently untested)
- Git (optional but may be easier)
- An internet connection of at least a 5+ Mbps download and upload speed per server instance
(recommended but not necessarily required)
- Any OS that can run Docker/Compose
- Shell access

### Minimal Change Setup
1. Run the setup script located at `./bin/local`
    - There is a Bash script for Linux and a Powershell script for Windows
2. Add any mods you would like to use into the newly created `./mods` directory
    - If you don't want to use mods, leaving it empty is fine
3. Build the Docker project: `docker-compose build main-server`
4. Add a new save game using: `docker-compose run main-server ./bin/new-save`
5. Start the server using: `docker-compose run -d main-server ./bin/start`

#### What if I want to use an existing save game?
1. Proceed with steps 1 and 2 of the above [Minimal Change Setup](#minimal-change-setup).
2. Add in the existing save game .zip archive into the `./saves` directory.
3. Change the Dockerfile ENV `SAVE_NAME` to the name of your save file.
4. Build the Docker project: `docker-compose build main-server`
5. Start the server using: `docker-compose run -d main-server ./bin/start`

### Customized or Multi-Instance Setup
Here are some recommendations when it comes to hosting multiple instances of this project on one machine.
These are only recommendations.
- Keep a separate instance of this project for each "server" you would like to set up
- Modify the `image:` line in `compose.yaml` to avoid build collisions in `docker-compose build`
  - Provide a descriptive name there for each instance set up to keep track of them via Docker
- Host each instance on a different port number by modifying the Dockerfile ENV "SERVER_PORT"
- After considering the above, change to the directory of your choosing and continue with the
  [Minimal Change Setup](#minimal-change-setup).

### External Access / Routing
If you want others on the public internet to connect to your server, you will need to take the
appropriate steps yourself according to your setup to allow this to take place. These are loosely made 
steps and will vary depending on your specific setup. If you need help beyond these general steps
it is recommended to refer to your router's user guide or cloud hosting documentation. Otherwise
various community sites may be able to assist with specific issues.

#### Self Hosting
- Open up firewall access on the container host using the same port number your container expects
- Set up Port Forwarding on your internet facing router to direct traffic to the container host
  on the same port number

#### Cloud Hosting
- Ensure the container or host can be accessed using a public address (may require attaching a public 
  ip address to the instance)
- Adjust the access control of the instance to allow traffic on the port your container expects

#### Static IPs
Whether you are self hosting or hosting on the cloud, a Static IP (or Dynamic DNS) is always recommended 
in order for external users to be able to consistently connect to your instance. Consumer ISPs and Cloud
Hosting services often have the right to change your non-static publicly facing IP without warning.

### Updating
I'm still working out a better solution to pulling down new versions of this project as a whole. But when
it comes to updating or changing the Factorio version the server is running or updating any mods, it is trivial 
to do this maintenance yourself.

#### Change Factorio Version
1. Stop the server using `docker-compose down` in the directory of your instance
2. Modify the Dockerfile ARG `FACTORIO_VERSION` to the version of your choosing
3. Build the Docker project: `docker-compose build main-server`
4. Start the server again using: `docker-compose run -d main-server ./bin/start`

#### Update Mod Versions Automatically
If you do not possess a `$FACTORIO_USER_ID` and/or `$FACTORIO_KEY` please visit https://www.factorio.com and
login. Replace `$FACTORIO_USER_ID` with your Username and `$FACTORIO_KEY` with your Token.

1. Stop any running server using `docker-compose down` in the directory of your instance
2. If you've never built the server, do so: `docker-compose build main-server`
3. Update the mods using: `docker-compose run main-server ./bin/update-mods.sh $FACTORIO_USER_ID $FACTORIO_KEY`
4. Re-build the server: `docker-compose build main-server`
5. Start the server again using: `docker-compose run -d main-server ./bin/start`

### Server Logs
Logs for a live server instance are exported using an bind mount to `./log/server-logs.log`. These can be
streamed elsewhere if desired.

## Remarks and Comments
I (Prota/ccarro30) am in no way affiliated with the development of the game Factorio or its 
studio Wube Software. This software is provided as-is, and there is no expectation or guarantee of
support by myself or any other contributors to this project. This is a hobby project for the benefit 
of the Factorio and Docker community, and there is currently no way to donate or support this 
project financially.
