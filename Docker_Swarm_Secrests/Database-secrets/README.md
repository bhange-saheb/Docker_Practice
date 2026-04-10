

```markdown
# Secure Docker Swarm MySQL + Adminer Stack

This stack deploys:
- **MySQL 8.0** database with secrets for root and DBA user passwords
- **Adminer** web UI for database management
- **Utils container** with troubleshooting tools

All services run as **non‑root users** and use **Docker secrets** for credentials.

---

## Step‑by‑Step Setup

### 1. Initialize Docker Swarm
If Swarm is not already active:
```bash
docker swarm init
```

### 2. Create an overlay network
This network allows containers across nodes to communicate:
```bash
docker network create --driver overlay appnet
```

### 3. Create secrets
Generate secure random passwords and store them as Docker secrets:
```bash
openssl rand -base64 12 | docker secret create db_root_password -
openssl rand -base64 12 | docker secret create db_dba_password -
```

> ⚠️ Secrets must exist before deploying the stack.

### 4. Deploy the stack
Run:
```bash
docker stack deploy -c docker-compose.yml securedb
```

Check status:
```bash
docker stack ps securedb
```

### 5. Verify services
List running containers:
```bash
docker ps
```

Inspect logs if needed:
```bash
docker service logs securedb_db
```

---

## Services

### MySQL (`db`)
- Runs as non‑root user (`UID 999` inside MySQL image).
- Secrets mounted at `/run/secrets/db_root_password` and `/run/secrets/db_dba_password`.
- Exposes port `3306`.
- Data stored in `datavol`.

Environment variables:
- `MYSQL_USER=dba`
- `MYSQL_DATABASE=mydb`
- `MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db_root_password`
- `MYSQL_PASSWORD_FILE=/run/secrets/db_dba_password`

### Adminer (`adminer`)
- Web UI for DB management.
- Runs as non‑root (`UID 1000`).
- Accessible at `http://<node_ip>:8888`.

### Utils (`utils`)
- Troubleshooting tools container.
- Runs as non‑root (`UID 1000`).
- Scheduled on worker nodes.

---

## Usage

### Connect with MySQL client
Install MySQL client inside the utils container or on your host:
```bash
apt-get install mysql-client
```

Then connect:
```bash
mysql -h db -u root -p
```
Password is read from the secret `db_root_password`.

### View Adminer UI
Open in browser:
```
http://<node_ip>:8888
```

---

## Security Notes

- **Non‑root users**: All services run as non‑root (`user:` directive).  
- **Secrets ownership**: Secrets mounted with correct UID/GID matching the container user.  
- **Restricted volumes**: Only MySQL data volume is persisted.  
- **Secrets as files**: Passwords are injected via `/run/secrets/` files, not environment variables.  
- **Least privilege**: Adminer and utils containers run with UID 1000.  

---

## Cleanup

To remove the stack:
```bash
docker stack rm securedb
```

To remove secrets:
```bash
docker secret rm db_root_password db_dba_password
```

To remove network:
```bash
docker network rm appnet
```
```
