# Fase 1: pegar o docker cli
FROM docker:27-cli AS dockercli

# Fase 2: Jenkins + Docker + Python
FROM jenkins/jenkins:2.462.1-lts

USER root

# Copia o docker cli para dentro do Jenkins
COPY --from=dockercli /usr/local/bin/docker /usr/local/bin/docker
RUN chmod +x /usr/local/bin/docker

# Instala Python + pip
RUN apt-get update && apt-get install -y \
      python3 \
      python3-pip \
      python3-venv \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

# Volta para o usuário jenkins
USER jenkins

# Instala plugins necessários
RUN jenkins-plugin-cli --jenkins-version 2.462.1 --plugins \
    docker-workflow workflow-aggregator git git-client