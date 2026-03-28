# Multi-Stage Docker & Cloud Infrastructure Lab

This repository contains a specialized Docker configuration for a DevOps environment, including tools like **Terraform**, **Packer**, and a dual-service setup for **Nginx** and **Node.js**.

## Commands Used

### 1. Build the Image
Use the following command to build the custom image. Note the use of build arguments to specify tool versions.

```bash
docker build --build-arg T_VERSION=1.6.6 --build-arg P_VERSION=1.8.0 --progress=plain --no-cache -t all-in-one-image -f dockerfile.dev .
```

**Flag Breakdown:**
* `--build-arg`: Passes versions (Terraform/Packer) into the build process.
* `-t`: Tags the image with a name.
* `-f`: Specifies the custom Dockerfile name (`dockerFile.dev`).
* `--no-cache`: Forces a fresh build from scratch.
* `--progress=plain`: Shows all output logs during execution.

### 2. Run the Container
The following command starts a container named `server1` with volume mounting and port mapping.

```bash
docker run --rm -d \
  --name server1 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v server:/data/testVolume \
  -p 8080:80 \
  -p 3000:3000 \
  all-in-one-image:latest
```

**Configuration Details:**
* `-v /var/run/docker.sock...`: Mounts the host Docker socket (Docker-in-Docker capability).
* `-v server:/data/testVolume`: Maps a named volume (`server`) for persistent data.
* `-p 8080:80`: Routes Nginx (Host: 8080 -> Container: 80).
* `-p 3000:3000`: Routes Node.js Backend (Host: 3000 -> Container: 3000).

---

## Docker Operations Cheat Sheet

| Command | Description |
| :--- | :--- |
| `docker ps` | List all running containers. |
| `docker images` | List all locally stored images. |
| `docker inspect [name]` | Retrieve detailed low-level metadata of an object. |
| `docker stop [name]` | Gracefully stop a running container. |
| `docker rm [name]` | Remove a stopped container. |
| `docker rmi [image]` | Delete a local image. |

### Accessing the Container
To open an interactive shell inside a running container:
```bash
docker exec -it server1 bash
# Use 'sh' if bash is not available:
docker exec -it server1 sh
```

---

## 📂 Project Setup

1. **Clone the Website Assets:**
   ```bash
   git clone [https://github.com/bhange-saheb/Static-website-test.git](https://github.com/bhange-saheb/Static-website-test.git)
   cd Static-website-test
   ```

2. **Prepare Configuration:**
   * Create your Dockerfile: `nano dockerfile.dev`
   * Prepare application files: `nano app.js`
   * *Refer to `Line-by-Line_Explanation_of_Dockerfile.docx` for a detailed code walkthrough.*

---

## Notes
* **Naming Convention:** Always ensure image tags are in **lowercase**.
* **File Sensitivity:** If your file is named `dockerfile` (lowercase 'd'), you must use the `-f` flag. Standard `Dockerfile` is recognized automatically.
```