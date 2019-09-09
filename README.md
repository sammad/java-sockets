
java-socket
========================================

Summary
-------
The project is ... TODO 

Project links
-------------
* Git repo [https://github.com/sammad/java-sockets.git](https://github.com/sammad/java-sockets.git)
* Jira [link]()
* CI jobs
  * [build job]()
  * [sonar job]()
  * [sanitizer job]()
  * [pullrequest-sonar-check job]()
  * [release job]()
* [Sonar report]()


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

* Configure Git ([link]))
* Get sources and build project
```bash
  git clone https://github.com/sammad/java-sockets.git
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
  <groupId>com.ms</groupId>
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