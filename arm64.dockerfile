FROM ubuntu

RUN mkdir -p /runner
WORKDIR /runner

#dependency
RUN apt update
RUN apt install curl gnupg lsb-release curl tar unzip zip apt-transport-https -y
RUN apt install ca-certificates sudo gpg-agent software-properties-common build-essential -y
RUN apt install zlib1g-dev zstd gettext libcurl4-openssl-dev inetutils-ping jq wget dirmngr -y
RUN apt install openssh-client locales python3-pip python3-setuptools python3 dumb-init nodejs -y
RUN apt install rsync libpq-dev gosu libvirt-daemon -y


#docker
RUN sudo install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN sudo apt update
RUN apt install docker-ce docker-ce-cli docker-buildx-plugin containerd.io docker-compose-plugin -y


#github runner
RUN curl -O -L https://github.com/actions/runner/releases/download/v2.308.0/actions-runner-linux-arm64-2.308.0.tar.gz
RUN tar xzf ./actions-runner-linux-x64-2.308.0.tar.gz
RUN rm -f actions-runner-linux-x64-2.308.0.tar.gz
COPY docker.sh .

#user and permissions
RUN chmod -R 777 /runner
RUN groupadd -g 121 runner
RUN useradd -mr -d /home/runner -u 1001 -g 121 runner
RUN usermod -aG docker runner
RUN usermod -aG sudo runner
RUN echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
USER runner


ENTRYPOINT ["./docker.sh"]