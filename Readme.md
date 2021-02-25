# Docker local setup

This is the readme for the local setup of Awesome apps.

## Prerequisites

1. [Docker](https://www.docker.com/)
2. [Node.js](https://nodejs.org/en/)
3. [Composer](https://getcomposer.org/)

## Apps

All three apps are located in the ./apps folder, each app in its subfolder.

Awesome app1 returns its own name.
Awesome app2 has the ability to create a database table and insert some data.
Awesome app3 can read from the database and display the output.

## Setup

Copy `.env.example` to `.env`.

To build and start the app containers up run

```bash
docker-compose up -d --build
```

This should create and start app containers - `docker-app` and `app-db` (database).


