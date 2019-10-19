
# Debug an ASP.Net Core application from VSCode inside a Docker Container

  

This example assumes that you are using a Windows computer and want to run a Docker Container for use with .Net Core Development.  

#### Setup Docker on your Windows PC
1. Install Docker Desktop: https://www.docker.com/products/docker-desktop
2. Set Docker Desktop to use Linux Containers
3. Open Docker Desktop Settings and share the drive where you store your code

![Docker shared drives](/readmeimages/shared-drives.png)

#### Install Git Bash
1. Download and install from https://gitforwindows.org/
2. Run Git Bash from the Window Start button
  
![Git Bash](/readmeimages/git-bash.png)

Bash is a Linux shell that will allow you to interact with Docker. If you try to send commands to a Linux container from a Windows command prompt or powershell, a carriage return (\r) character will be appended to each command and Linux won't know what to do with it.
#### Build and run the Container
1. From Git Bash: navigate to this project on you hard drive, for example if it is stored in `D:\Projects\HelloWebApiCoreDocker` then enter: `cd /d/projects/hellowebapicoredocker`
 
 ![Git Bash](/readmeimages/bash-cd-to-project.png)
 
2. List all of the files in this directory: `ls -g`

![Git Bash](/readmeimages/bash-ls.png)

The Dockerfile contains the commands to build the Docker Image.

3. To build the image with the name "myapp": `docker build -t myapp .`
Note that the space and dot: ` .`  at the end of the command is required. It means that the Dockerfile to be used is in the current directory which is signified by `.` in Linux.

![Git Bash](/readmeimages/bash-docker-build.png)

My screenshot shows Docker using cached data as I have run this before. The first time you run this it will download the necessary files from the internet and may take a while.

4. Once the build is complete, then we can create a container instance (or multiple instances) of the Docker Image (like instantiating an object from a class in C#) using: 
`docker run -i -p 7000:5000 -v //d//Projects//HelloWebApiCoreDocker//webapi:/app/webapi --name test myapp`

Each instance needs to map ports from the host machine ie your Windows PC to ports inside the Docker Container for that ASP.Net Core application to uses. The application uses port 5000 which is mapped to port 7000 on your host machine using:`-p 7000:5000`. We also want to give the container access to our source files so that when we update them, it can re-build and deploy them to the Kestrel server for us. This command creates a volume for us: 
`-v //d//Projects//HelloWebApiCoreDocker//webapi:/app/webapi`
The double forward slashes are required to escape the forward slash for the directory path on a Windows host machine. If we were running this on a Linux host machine we would not need this. After the `:` is the path inside the Docker Container to map the files to. Then we give this Docker Container instance the name of "test": `--name test`. Finally we want to use the Docker Image that we built before, that we tagged as `myapp`

![Git Bash](/readmeimages/bash-docker-run.png)

Because we used the `-i` (interactive) option in the command, it will output the ASP.Net Core's output to Git Bash.

5. To exit press `Ctrl+C`
This won't stop the ASP.Net Core application or the Docker Container, it will only exit from the interactive session.
6. To see the Docker Containers currently on our system: `docker ps -a`

![Git Bash](/readmeimages/bash-docker-ps.png)

This shows us that the Docker Container named "test" that we created from image: "myapp" has a status of being "Up" (running) for 6 minutes and has port 7000 being forwarded to port 5000. 

7. The ASP.Net Core application has an endpoint at: http://localhost:7000/api/hello, when you click on this link you should see a response in the browser.

![hello](/readmeimages/browser-whats-up.png)

8. If you shutdown the Docker Container using: `docker kill test`, then refresh the browser, then the endpoint is no longer available.
9. To start the Docker Container again: `docker start test`

![Git Bash](/readmeimages/bash-docker-kill-start.png)

10. If you want to destroy the Docker Container, kill it and then prune: `docker kill test` then `docker container prune`

![Git Bash](/readmeimages/bash-docker-container-prune.png)

 
