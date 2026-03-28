# Multi-Stage Docker Image

## Docker Command Explanation
docker ps --> used shows running Docker containers
docker images --> used to list all locally stored Docker images
docker inspect -->used to retrieve detailed, low-level information about various Docker objects, including containers, images, volumes, networks, and services


docker build --build-arg T_VERSION=1.6.6 --build-arg P_VERSION=1.8.0 -t all-in-one-image -f dockerFile.dev .
  
docker build → Creates a new Docker image from your Dockerfile.

--build-arg → Passes build‑time arguments (Terraform and Packer versions).

-t all-in-one-image → Tags the image with a name (all-in-one-image).

-f dockerFile.dev → Specifies which Dockerfile to use.

. → Context directory (current folder).

--no-cache -> used to re build from start without caching data.

--progress=plain -> used to show all process on screen while executing.


docker run --rm -d --name server1 -v /var/run/docker.sock:/var/run/docker.sock -v server:/data/testVolume -p 8080:80 -p 3000:3000 all-in-one-image:latest

docker run → Starts a new container from the specified image.

--rm → Automatically removes the container when it stops.
Useful for temporary containers so they don’t clutter your system.

-d → Detached mode. Runs the container in the background.
You get the container ID back instead of attaching to logs.

--name server1 → Assigns a custom name (server1) to the container.
Makes it easier to reference later (e.g., docker logs server1).

-v /var/run/docker.sock:/var/run/docker.sock → Mounts the Docker socket inside the container.
This allows the container to talk to the Docker daemon on the host (common in CI/CD or when running Docker‑in‑Docker).

-v server:/data/testVolume → Mounts a named volume (server) to /data/testVolume inside the container.
This persists data even if the container is removed.

-p 8080:80 → Maps host port 8080 → container port 80.
So you can access Nginx at IPADDRESS:8080. (100.20.2.0:8080)

-p 3000:3000 → Maps host port 3000 → container port 3000.
So you can access the Node.js backend at IPADDRESS:3000.

all-in-one-image:latest → The image to run, tagged latest.
This is the image you built earlier with your Dockerfile.


docker exec -it server1 bash or docker exec -it server1 sh ---> 

docker exec → Runs a command inside a running container.

-it → Interactive + TTY (so you can type commands).

server1 → Target container name.

bash → Opens a Bash shell inside the container.

If Bash isn’t installed, use sh.




docker stop server1 --> Stop Container named server1
docker rm server1 --> Deletes the stopped container named server1.
docker rmi all-in-one-image --> removes the image named all-in-one-image




## Create Docker Files

'Please refer "Line-by-Line_Explanation_of_Dockerfile.docx" For line by line code explaination.

nano dockerFile or DockerFile ---> Paste Code
nano files mentioned in code (app.js).

## Cloning My Git repo where I have HTML Files

git clone https://github.com/bhange-saheb/Static-website-test.git
cd Static-website-test


## Build Images: This creates a custom image named (Note tag name should be in lowercase) .
docker build -t all_in_one_image .  ---> This will work if We have created DockerFile instead of dockerFile.dev
docker build --build-arg T_VERSION=1.14.8 --progress=plain --no-cache -t all-in-one-image -f dockerFile.dev .
-f dockerFile --> this used when dockerFile is not start with captial D DockerFile.

## Cloning My Git repo where I have HTML Files

git clone https://github.com/bhange-saheb/Static-website-test.git
cd Static-website-test

## Run Container: This maps our server's port 8080 to the container's port 3000. We can pass environment while running container.

docker run -d -p 8080:80 -p 3000:3000 all-in-one-image --> here any random will be taken as we have not given any container name

docker run --rm -d --name server1 -v /var/run/docker.sock:/var/run/docker.sock -v server:/data/testVolume -p 8080:80 -p 3000:3000 all-in-one-image:latest



