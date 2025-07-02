FROM ubuntu:18.04
ENV METEOR_NPM_REBUILD_FLAGS=--update-binary
MAINTAINER xym xym@xiaolin.cc 
RUN mkdir -p /var/mindx/meteor && chmod 777 /var/mindx/meteor 
RUN apt-get update && apt-get install -y git 
ENV HOME /var/mindx/meteor
ENV LC_ALL "C"
RUN useradd mindx
USER mindx
RUN echo $PATH && meteor --version
RUN curl --progress-bar https://install.meteor.com | sh
ENV PATH $PATH:/home/mindx/.meteor
WORKDIR /var/mindx/meteor
RUN meteor reset && meteor update --release 1.6.1
RUN git clone https://github.com/zzxym/install-kityminder-meteor.git
ENV PATH $PATH:$HOME/.meteor
RUN meteor create --bare /var/mindx/meteor/kityminder-meteor
WORKDIR /var/mindx/meteor/kityminder-meteor/
RUN meteor remove blaze-html-templates && \
    meteor add angular-templates@1.3.2 && \
    meteor npm install --save angular@1.6.9 angular-meteor@1.3.12 && \
    meteor add iron:router@1.1.2 && \
    meteor add meteorhacks:picker@1.0.3 && \
    meteor add session@1.1.7 && \
    meteor add autopublish@1.0.7 && \
    meteor list --tree && \
    rm -rf $HOME/.npm $HOME/.meteor/local 
WORKDIR /var/mindx/meteor/kityminder-meteor 
RUN cp -r -f README.md client collection packages.json server public /var/mindx/meteor/kityminder-meteor/ 
WORKDIR /var/mindx/meteor/kityminder-meteor/ 

RUN meteor add meteorhacks:npm && meteor update meteorhacks:npm && meteor 

RUN echo "#! /bin/bash" > /var/mindx/meteor/meteor.sh && echo "cd /var/mindx/meteor/kityminder-meteor" >> /var/mindx/meteor/meteor.sh  && echo "meteor run -p 8899" >> /var/mindx/meteor/meteor.sh 
RUN chmod +x /var/mindx/meteor/meteor.sh
RUN echo `cat /var/mindx/meteor/meteor.sh`
EXPOSE 8899 
CMD "/var/mindx/meteor/meteor.sh"
