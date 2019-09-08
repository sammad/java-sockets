
java-socket
========================================

Summary
-------
The project is ... TODO 

Project links
-------------
* Git repo [https://portal.tpt.com/stash/scm/REPLACE-THIS/java-socket.git](https://portal.tpt.com/stash/scm/REPLACE-THIS/java-socket.git)
* Jira [link](https://portal.tpt.com/processpoint/browse/REPLACE-THAT)
* CI jobs
  * [build job](https://portal.tpt.com/bamboo/TODO-B)
  * [sonar job](https://portal.tpt.com/bamboo/TODO-S)
  * [sanitizer job](https://portal.tpt.com/bamboo/TODO-SA)
  * [pullrequest-sonar-check job](https://portal.tpt.com/bamboo/TODO-PRSC)
  * [release job](https://portal.tpt.com/bamboo/TODO-R)
* [Sonar report](http://sonar.tpt.com/TODO)


Project characteristics
--------------------
* TODO (Spring?)
* TODO JPA? (Hibernate?/Spring Data JPA?)
* JUnit/JMockit

Prerequisites
-------------
- JDK 8 (use latest)
- Maven 3 (use latest)
- Git (use latest)

Contributing
------------

* Configure Git ([link](https://portal.tpt.com/infopoint/display/CAT/Git+Basics#GitBasics-Gitconfiguration))
* Get sources and build project
```bash
  git clone https://portal.tpt.com/stash/scm/REPLACE-THIS/java-socket.git
  cd java-socket
  mvn clean install
```

How to test java-socket locally
--------------------

* step1, 
* step2, 
* TODO

How to use java-socket
--------------------

* Add dependency to your project:

```
<dependency>
  <groupId>com.tpt.change-me</groupId>
  <artifactId>java-socket</artifactId>
  <version>0.9.00-SNAPSHOT</version>
</dependency>
```

How to configure java-socket

* Change `java-socket.properties`:

```
dataSource.driverClassName=org.postgresql.Driver
dataSource.url=jdbc:xxx:yyy
dataSource.username=some_user
dataSource.password=sume_password

```

Local build
--------------------

* Safe
  ```bash
  mvn clean install
  ```

* Unsafe (but faster)  
  ```bash
  mvn test
  ```

CI jobs configuration
--------------------


* Safe
  ```bash
  mvn clean package
  ```

* Unsafe (but faster)  
  ```bash
  mvn test
  ```


* Always release through Bamboo/Jenkins release job, never locally!
  ```bash
  mvn release:prepare release:perform 
  ```


* Configured on Bamboo/Jenkins
  ```bash
  mvn clean org.jacoco:jacoco-maven-plugin:prepare-agent install -Dmaven.test.failure.ignore=true
  mvn sonar:sonar
  ```