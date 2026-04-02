Docker Compose Experience



This guide is structured as a multi-lesson series to help learners gradually understand Docker Compose concepts. Each lesson builds on the previous one.



Lesson 1: Single Container Basics



Goal


'''bash
Run a simple Node.js application in a container.
'''


docker-compose.yml



version: "3.8"



services:

&#x20; web:

&#x20;   image: node:18

&#x20;   command: node app.js

&#x20;   volumes:

&#x20;     - ./app:/usr/src/app

&#x20;   ports:

&#x20;     - "3000:3000"



Key Concepts



services: Defines containers.



image: Base image for the container.



volumes: Maps local code into the container.



ports: Exposes the app on localhost:3000.



Lesson 2: Adding a Database



Goal



Connect the web app to a PostgreSQL database.



docker-compose.yml



services:

&#x20; db:

&#x20;   image: postgres:15

&#x20;   environment:

&#x20;     POSTGRES\_USER: postgres

&#x20;     POSTGRES\_PASSWORD: postgres

&#x20;     POSTGRES\_DB: mydb

&#x20;   volumes:

&#x20;     - db\_data:/var/lib/postgresql/data



Key Concepts



environment: Sets database credentials.



volumes: Ensures data persists even if the container restarts.



Lesson 3: Adding an Admin Tool



Goal



Use pgAdmin to manage the PostgreSQL database.



docker-compose.yml



services:

&#x20; pgadmin:

&#x20;   image: dpage/pgadmin4

&#x20;   environment:

&#x20;     PGADMIN\_DEFAULT\_EMAIL: admin@admin.com

&#x20;     PGADMIN\_DEFAULT\_PASSWORD: admin

&#x20;   ports:

&#x20;     - "5050:80"

&#x20;   depends\_on:

&#x20;     - db



Key Concepts



pgAdmin provides a web UI for managing PostgreSQL.



Accessible at http://localhost:5050.



Lesson 4: Adding a Reverse Proxy



Goal



Use Nginx to route traffic to the web app.



docker-compose.yml



services:

&#x20; nginx:

&#x20;   image: nginx:latest

&#x20;   ports:

&#x20;     - "80:80"

&#x20;   volumes:

&#x20;     - ./nginx/default.conf:/etc/nginx/conf.d/default.conf

&#x20;   depends\_on:

&#x20;     - web



Nginx Config (nginx/default.conf)



server {

&#x20;   listen 80;



&#x20;   location / {

&#x20;       proxy\_pass http://web:3000;

&#x20;   }

}



Key Concepts



Nginx listens on port 80.



Routes traffic to the web service.



Lesson 5: Introducing Networks



Goal



Separate frontend and backend traffic using networks.



docker-compose.yml



networks:

&#x20; frontend:

&#x20;   driver: bridge

&#x20; backend:

&#x20;   driver: bridge



services:

&#x20; web:

&#x20;   build: ./app

&#x20;   networks:

&#x20;     - backend



&#x20; db:

&#x20;   image: postgres:15

&#x20;   networks:

&#x20;     - backend



&#x20; pgadmin:

&#x20;   image: dpage/pgadmin4

&#x20;   networks:

&#x20;     - backend



&#x20; nginx:

&#x20;   image: nginx:latest

&#x20;   networks:

&#x20;     - frontend

&#x20;     - backend



Key Concepts



frontend network: Exposes Nginx to the outside world.



backend network: Internal communication between web, db, and pgAdmin.



Nginx connects to both networks to route external requests to the backend.



Lesson 6: Scaling Services



Goal



Run multiple instances of the web app.



Command



docker-compose up --scale web=3



Key Concepts



Scaling creates multiple containers for the same service.



Useful for load balancing and high availability.



Lesson 7: Environment Variables and .env Files



Goal



Move sensitive data into a .env file.



.env



POSTGRES\_USER=postgres

POSTGRES\_PASSWORD=postgres

POSTGRES\_DB=mydb



docker-compose.yml



db:

&#x20; image: postgres:15

&#x20; environment:

&#x20;   POSTGRES\_USER: ${POSTGRES\_USER}

&#x20;   POSTGRES\_PASSWORD: ${POSTGRES\_PASSWORD}

&#x20;   POSTGRES\_DB: ${POSTGRES\_DB}



Key Concepts



.env files keep credentials separate from code.



Makes configuration more secure and flexible.



Lesson 8: Adding a Cache Layer (Optional)



Goal



Introduce Redis for caching.



docker-compose.yml



services:

&#x20; redis:

&#x20;   image: redis:latest

&#x20;   ports:

&#x20;     - "6379:6379"

&#x20;   networks:

&#x20;     - backend



Key Concepts



Redis provides fast in-memory caching.



Connected to the backend network for communication with the web app.



🎯 Final Learning Outcomes



By completing these lessons, you will understand:



How to define services in Docker Compose.



How to use volumes for persistence.



How to configure services with environment variables.



How to organize communication with networks.



How to scale services.



How to extend stacks with caching and proxies.



📊 Visual Diagram (Mermaid)



graph TD

&#x20;   A\[User Browser] --> B\[Nginx (frontend network)]

&#x20;   B --> C\[Web App (backend network)]

&#x20;   C --> D\[PostgreSQL DB]

&#x20;   D --> E\[pgAdmin]

&#x20;   C --> F\[Redis Cache]





