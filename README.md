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
5. Start the server using: `docker-compose run main-server ./bin/start`

#### What if I want to use an existing save game?
1. Proceed with steps 1 and 2 of the above [Minimal Change Setup](#minimal-change-setup).
2. Add in the existing save game .zip archive into the `./saves` directory.
3. Change the Dockerfile ENV `SAVE_NAME` to the name of your save file.
4. Build the Docker project: `docker-compose build main-server`
5. Start the server using: `docker-compose run main-server ./bin/start`

### Customized or Multi-Instance Setup


## Remarks and Comments
I (Prota) am in no way affiliated with the development of the game Factorio or its studio 
Wube Software. This software is provided as-is, and there is no expectation or guarantee of
support. This is a hobby project for the benefit of the Factorio and Docker community, 
and there is currently no way to donate or support this project financially.
