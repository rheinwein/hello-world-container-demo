FROM centurylink/ruby-base:2.1.2

MAINTAINER CenturyLink Labs <clt-labs-futuretech@centurylink.com>

EXPOSE 4567

RUN mkdir /usr/src/app
COPY . /usr/src/app
 
WORKDIR /usr/src/app
RUN bundle install

CMD ruby hello_world.rb
