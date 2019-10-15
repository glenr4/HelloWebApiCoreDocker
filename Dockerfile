# Create an image called 'myapp' from this file (run from bash with this file in the current directory, 
# which is the dot at the end of the command)
# $ docker build -t myapp .

# Run the image 'myapp' with the container name 'test'
# -dit: detached, interactive, TTY (this will stop of the container from automatically exiting)
# -p: map ports 6000 and 6001 on the host machine to ports 5000 and 5001 inside the container
# $ docker run -dit -p 6000:5000 -p 6001:5001 --name test myapp

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

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY ./webapi/*.csproj ./webapi/
RUN dotnet restore

COPY webapi/. ./webapi/

# Debugging support
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y curl unzip procps
RUN curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l /publish/vsdbg;

# ports (must match UseUrls in CreateWebHostBuilder)
EXPOSE 5000 5001

