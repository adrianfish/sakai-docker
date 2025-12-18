# Sakai Docker

A docker compose based Sakai deployment

## Prerequisites

You need to have a docker engine installed on your machine. Take a look at the
[Docker](https://www.docker.com/) site - you'll find instructions for Mac, Windows and Linux there.

## Steps

### Build the sakai image

From the root of this repo, run this.

    docker build -t sakai .

### Use docker compose to setup the db with demo data

    EXTRA_OPTS="-Dsakai.demo=true" docker compose up -d

That command, when complete, will have brought up a small Sakai cluster consisting of a Tomcat
container and a MariaDB container. Tomcat should come up on port 8080 and that should be availble on
your localhost. However, Tomcat can take while to come up, especially when passing the demo data
property. So, you can watch the Tomcat logs with this command:

    docker logs -f sakai-docker-app-1

When you see the startup messages, go ahead and try localhost:8080. Login as admin and make sure the
demo data is there, all the SIMPL* sites.

### Restart the cluster without the demo data flag.

We don't need to pass the demo data option all the time. First shutdown the cluster:

    docker compose down

Now bring it back up and watch the logs again:

    docker compose up -d
    docker logs -f sakai-docker-app-1

The compose file is using a named volume for the db data, so it will only be deleted if you
explicitly drop volumes.

    docker compose down -v
