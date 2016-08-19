# The MIT License
#
#  Copyright (c) 2015, CloudBees, Inc.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

FROM cupenya/docker-jenkins-slave-mongo-es-ivy2-cache
MAINTAINER Elmar Weber <elmar(.)weber(@)cupenya(.)com>

# add npm, gulp and bower
USER root
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
   apt-get update && \
   apt-get install -y nodejs && \
   npm --global install gulp && \
   npm --global install bower && \
   # fix permissions done during install
   chown jenkins:jenkins -R /home/jenkins/.npm

# add ES plugin
COPY elasticsearch-business-hours-2-3-3-SNAPSHOT.zip /tmp
RUN /usr/share/elasticsearch/bin/plugin install -t 30s file:///tmp/elasticsearch-business-hours-2-3-3-SNAPSHOT.zip && \
  rm /tmp/elasticsearch-business-hours-2-3-3-SNAPSHOT.zip


# add docker and setup script for docker
USER root

RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-1.12.1.tgz && tar --strip-components=1 -xvzf docker-1.12.1.tgz -C /usr/local/bin

COPY setup-docker-and-start-jenkins.sh /setup-docker-and-start-jenkins.sh
RUN chmod 755 /setup-docker-and-start-jenkins.sh

# overwrite default entry point to wrap docker user and group creation
ENTRYPOINT ["/setup-docker-and-start-jenkins.sh"]
