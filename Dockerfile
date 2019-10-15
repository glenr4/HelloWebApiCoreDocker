# Create an image called 'myapp' from this file (run from bash with this file in the current directory, 
# which is the dot at the end of the command)
# $ docker build -t myapp .

# Run the image 'myapp' with the container name 'test'
# -dit: detached, interactive, TTY (this will stop of the container from automatically exiting)
# -i: interactive (use this if there is an ENTRYPOINT in the Dockerfile)
# -p: map ports 7000 and 7001 on the host machine to ports 5000 and 5001 inside the container
# -v: mounts a volume, which allows file sharing with the host (need double backslashes for Windows path)
# $ docker run -i -p 7000:5000 -p 7001:5001 -v //d//Projects//HelloWebApiCoreDocker//webapi:/app/webapi --name test myapp
# Using this command would be preferable but usually results in an error because it cannot find the project file
# $ docker run -i -p 7000:5000 -p 7001:5001 -v ${pwd}//webapi:/app/webapi --name test myapp

# To access bash inside the container 'test'
# $ docker exec -i test bash

# From inside bash, can run normal Linux commands like: ls, pwd etc.
# To start Kestrel server (from the folder with the .csproj)
# dotnet run
# If ctrl-c does not shutdown all processes correctly, then run
# dotnet build-server shutdown

# To list all containers
# $ docker ps -a

# To stop container 'test'
# $ docker kill test

# To remove all stopped containers
# $ docker container prune

##########################################
FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build

# Copy project file so that build doesn't fail
WORKDIR /app/webapi
COPY ./webapi/*.csproj ./

# Debugging support
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y curl unzip procps
RUN curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l /publish/vsdbg;

# ports (must match UseUrls in CreateWebHostBuilder)
EXPOSE 5000 5001

# Run
ENTRYPOINT dotnet watch run --no-restore
