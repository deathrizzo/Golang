FROM ubuntu:18.04

# Prevents the git installation from asking for a timezone
ENV DEBIAN_FRONTEND=noninteractive

# Major tool versions
ARG TERRAFORM_VERSION=0.12.18
ARG AWSCLI_VERSION=1.16.238

##
## The following comments are not done inline because those are parsed as an
## "empty continuation" and is being deprecated by Docker. In the future, trying
## to do inline comments like that will be an invalid Dockerfile.
##

## git, openssh-client
# Used for installing the istream_eks terraform module from our private
# GitHub

## unzip
# Used for installing other tools

## python3-setuptools, python3-pip, python3-dev
# Used for installing the latest awscli which we use to get an IAM token
# for authenticating with EKS as opposed to using aws-iam-authenticator
RUN apt-get update && apt-get install -y \
      curl=7.58.0-2ubuntu3.8 \
      git=1:2.17.1-1ubuntu0.4 \
      openssh-client=1:7.6p1-4ubuntu0.3 \
      unzip=6.0-21ubuntu1 \
      python3-setuptools=39.0.1-2 \
      python3-pip=9.0.1-2.3~ubuntu1.18.04.1 \
      python3-wheel=0.30.0-0.2 \
      --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install jq
RUN curl -Lo /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64

# Install terraform
RUN curl -Lo /tmp/terraform.zip https://releases.hashicorp.com/terraform/"$TERRAFORM_VERSION"/terraform_"$TERRAFORM_VERSION"_linux_amd64.zip && \
      unzip /tmp/terraform.zip -d /usr/local/bin/ && \
      rm /tmp/terraform.zip

# Install awscli
RUN pip3 install awscli=="$AWSCLI_VERSION"

# Make our tools executable
RUN chmod +x /usr/local/bin/*

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
