# Containerized Hello World

A simple containerized application meant to illustrate the different ways you can interact with Docker and containers while developing applications.

Before running this code, you need to install Docker. If you run OSX or Windows, I highly recommend [Boot2Docker](http://boot2docker.io/). If you're running Linux, you can download Docker via [their official packages](https://docs.docker.com/installation/#installation).


## Usage

There are two different ways of developing with Docker. First is what I refer to as the *static container* way: running code inside a container that does not need to be modified during the course of development. Most likely, you'll use this style for dependencies, and also during QA and testing. In this type of container, the code is packaged up and you can't modify it after the image is built and the container is running.

The *dynamic container* way is what you'll use when working on an application under active development. Instead of running an image with the code packaged up, you'll link the folders from your dev environment to the container by mounting them as a volume. You can work on the file on your local system and see the changes propogate all the way through the container.


### The Static Way

The Dockerfile in this project builds a Docker image in the static way.

There are a few instructions in the Dockerfile that copy code from your current directory and package it up into the image.

RUN mkdir -p /usr/src/app -- make a new directory
ADD . /usr/src/app -- copy all of your current files into this directory

WORKDIR /usr/src/app -- set this new directory as the working directory
RUN bundle install -- execute your bundle install within the app directory


Build the Docker image by running ```docker build -t hello-world .```. You will see each layer of the image being downloaded.

You can check to see that your image was downloaded successfully by running ```docker images```.

Next, run this image inside a container.

```docker run -p 4567:4567 hello-world```

The -p flag sets up a port binding rule of ```-p host_port:container_port``` . If you're working with a VM (like Boot2Docker) remember to also set up a port forwarding rule on your VM in order to access the application from your local host. The -p flag only creates a rule from the container to the container's host system, which, if you're not running Linux on your local machine, is most likely a small VM.

After the port rules are set, you can access your application in your browser at localhost:4567.


### The Dynamic Way

Instead of packaging the code up inside the container, the dynamic way of creating a container will allow you to access and modify your code, and see those updates propogated to your browser.

If you've already built the previous hello-world image, great news! You have a ruby-base image, which is all you need to run a container in this way. If you haven't built a Docker image yet, modify the Dockerfile so that it only has one line.

FROM centurylink/ruby-base:2.1.2

Alternatively, you could just pull down centurylink/ruby-base:2.1.2 by saying ```docker pull centurylink/ruby-base:2.1.2```

That's it! The only thing this image does is creates an Ruby environment for your application to run in, using version 2.1.2.

To get the code into the container, there are a few config options that need to be set on the ```docker run``` string.

```docker run -it -p 4567:4567 -v /PATH/TO/CODE/:/var/app/hello-world centurylink/ruby-base:2.1.2 /bin/bash```

The ```-it``` flag allocates a tty for interactive sessions, which we'll need in order to bundle install and fire up the application. Unlike the previous static way, which had the container start command (CMD) specified in the Dockerfile, we have specified ```/bin/bash``` as the container entrypoint command. When the container is up, you'll be dropped into a bash session automatically. Think of this dynamic container as just a normal dev environment inside a container -- you still need to execute all of the commands needed to get your application running.

An important note about the volume mount: just like with the ports, there could be an extra hop in here if you're working on a VM. Make sure that /PATH/TO/CODE is the correct directory on the VM, not your local machine. In some cases, like Boot2Docker, the filepath will be identical. You'll see pretty quickly if you made a mistake as your container directory will be empty.

Once inside the container (you'll see `root@container_id` as the prompt), cd into the code directory, in this case /var/app/hello-world. From here, bundle install. Then start the application with `ruby hello_world.rb`

Remember to set up your port forwarding rules if you're using a VM, avoiding any port conflicts from previous containers or projects (you may want to use a different port just to make it easier on yourself). Check out the application in your browser and you should see "Hello World!". On your local system, go modify public/index.html. You'll see the changes after a page refresh. That right there is you modifying code that's running in a container!

This dynamic container concept can be applied to much larger projects as well, and even multiple projects running inside containers. For example, you could run both a UI and API project in a container -- using container linking, port forwarding, and environment variables to get them to communicate -- and actively develop against both projects.

## Additonal Resources

[Installing Docker](https://docs.docker.com/installation/#installation)

[Understanding Docker](https://docs.docker.com/introduction/understanding-docker/)
