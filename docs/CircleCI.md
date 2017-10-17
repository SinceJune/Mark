### CircleCI config 2.0 example

```yaml
version: 2
jobs:
  build:
    working_directory: ~/workdir
    machine:
      enabled: true
      java:
        version: openjdk8
      python:
        version: 2.7.13

    steps:
      - checkout
      - run:
          name: Install AWS CLI
          command: pip install awscli  --upgrade --user
      - restore_cache:
          keys:
            - maven-cache-{{ .Branch }}-{{ checksum "workdir/pom.xml" }}
            - m2- # used if checksum fails
      - run:
          working_directory: ~/workdir
          name: mvn clean package
          command: mvn clean package
      - save_cache:
          key: maven-cache-{{ .Branch }}-{{ checksum "workdi/pom.xml" }}
          paths:
            - ~/.m2
      - deploy:
          working_directory: ~/workdir
          command: |
            if [ "${CIRCLE_BRANCH}" == "master" ]; then
              ./build_docker.sh
              eval $(aws ecr get-login --region $REGION)
              docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/repo:latest
            fi
```
