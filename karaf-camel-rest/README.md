
Minimal Camel Servlet Installation
==================================

Requirements

- Apache Karaf 4.4.7
- Apache Camel 4.10.3
- jakarta
- Java 21

Java Runtime

export JAVA_HOME=/usr/lib/jvm/temurin-21-jre-amd64

Unpack Karaf into KARAF_HOME

Test run

bin/karaf

OK

Camel
-----

# version LTS is 4.10.3

feature:repo-add camel 4.10.3

feature:install camel-core
feature:install camel-blueprint
feature:install camel-servlet
feature:install camel-jetty
feature:install jetty

Copy test-camel-servlet-ok.xml into $KARAF_HOME/deploy

Check log for errors.

Test



