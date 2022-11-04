#file-name: dockerfile
FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
# Run the Update
RUN apt-get update && apt-get upgrade -y

# Install pre-reqs
RUN apt-get install -y python curl openssh-server

# Setup sshd
RUN mkdir -p /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# download and install pip
RUN curl -sO https://bootstrap.pypa.io/pip/2.7/get-pip.py
RUN python get-pip.py

# install AWS CLI
RUN pip install awscli

# Setup AWS CLI Command Completion
RUN echo complete -C '/usr/local/bin/aws_completer' aws >> ~/.bashrc
CMD /usr/sbin/sshd -D

EXPOSE 22

#=========POSTGRES========#
RUN apt-get install -y gnupg2
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic"-pgdg main | tee  /etc/apt/sources.list.d/pgdg.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7FCC7D46ACCC4CF8
RUN apt update
RUN apt -y install postgresql-11
RUN service postgresql start

EXPOSE 5432
CMD ["postgres"]

#Make sure that your shell script file is in the same folder as your dockerfile while running the docker build command as the below command will copy the file to the /home/root/ folder for execution. 
COPY . /home/this/ 
#Copying script file
USER root 
#switching the user to give elevated access to the commands being executed from the k8s cron job
