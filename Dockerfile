# Create an image called 'myapp' from this file (run from bash with this file in the current directory, 
# which is the dot at the end of the command)
# $ docker build -t myapp .

# Run the image 'myapp' with the container name 'test'
# -i: interactive (use this if there is an ENTRYPOINT in the Dockerfile)
# -p: map ports 7000 and 7001 on the host machine to ports 5000 and 5001 inside the container
# -v: mounts a volume, which allows file sharing with the host (need double backslashes for Windows path)

# $ docker run -i -p 7000:5000 -p 7001:5001 -v //d//Projects//HelloWebApiCoreDocker//webapi:/app/webapi --name test myapp

# Using this command would be preferable but usually results in an error because it cannot find the project file in time
# $ docker run -i -p 7000:5000 -p 7001:5001 -v ${pwd}//webapi:/app/webapi --name test myapp

# To reconnect to the container 'test'
# $ docker attach test

# To access bash (command line) inside the container 'test'
# $ docker exec -i test bash
# or from windows command line: docker exec -it test bash

# From inside bash, can run normal Linux commands like: ls, pwd etc.
# To start Kestrel server (from the folder with the .csproj)
# dotnet run

# When attached to a container, if ctrl+c does not shutdown all processes correctly, then run
# dotnet build-server shutdown

# To list all containers
# $ docker ps -a

# To stop container 'test'
# $ docker kill test

# To remove all stopped containers
# $ docker container prune

##########################################
FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build

# Copy solution and project files so that build doesn't fail
WORKDIR /app
COPY *.sln .
WORKDIR /app/webapi
COPY ./webapi/*.csproj ./
RUN dotnet restore

# Debugging support
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y curl unzip procps
RUN curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l /publish/vsdbg;

# ports (must match UseUrls in CreateWebHostBuilder)
EXPOSE 5000 5001

# Run
ENV DOTNET_USE_POLLING_FILE_WATCHER 1
ENTRYPOINT dotnet watch run
