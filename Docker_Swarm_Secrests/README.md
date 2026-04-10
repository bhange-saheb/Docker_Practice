# Dokcer Swarm Secrets --procedure

In this project I am using ubuntu image 

## Step 1

Create file with with you credentials on manager/master node

example

[default]
aws_access_key_id=YOURKEY
aws_secret_access_key=YOURSECRET" > test_credentials


```bash
nano test_credentials
```
Paste your data in above created file

Create a secret named test_credentials in Swarm, using the contents of the local file test_credentials

```bash
docker secret create test_credentials test_credentials
```
docker secret create → This is the Docker Swarm command to create a new secret that can later be mounted into services.

test_credentials (first one) → This is the name of the secret inside Swarm. You’ll use this name in your YAML file under the secrets: section.

test_credentials (second one) → This is the file on your local machine that contains the secret data. Docker will read the contents of this file and store it securely in Swarm.

So, the command means:
“Create a secret named test_credentials in Swarm, using the contents of the local file test_credentials.”

Verify it exists:

```bash 
docker secret ls
```

## Step 2
Create compose file named aws-cli.yml and paste

```bash
nano aws-cli.yml 
```

Deploy the stack:

```bash 
docker stack deploy -c aws-cli.yml testingCli
```

## Step 3
Enter inside the container 

```bash 
docker exec -it testingCli bash
or 
docker exec -it 'containerID' bash
```
## Step 4

Install AWS CLI:

```bash
apt-get update && apt-get install -y awscli
```
Run AWS CLI without specifying credentials:

```bash
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query "Reservations[*].Instances[*].{ID:InstanceId,Type:InstanceType,State:State.Name,AZ:Placement.AvailabilityZone}" \
  --output table
```
In realtime I followed same approach for database passwords::
but by creating user::----

FROM ubuntu:22.04

 Create a non-root user
RUN useradd -m appuser

Switch to that user
USER appuser

WORKDIR /home/appuser

    uid: '1001'   # UID of appuser
    gid: '1001'   # GID of appuser
    mode: 0440
## check for production ready compose file -->
Refer Database-secrets folder