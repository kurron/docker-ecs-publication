#Overview
This project is a simple Docker image that transforms Amazon ECS templates and publishes them to an
artifact repository.  The idea is to make this a step in a CI pipeline. 

#Prerequisites
* a working [Docker](http://docker.io) engine
* a working [Docker Compose](http://docker.io) installation

#Building
Type `docker-compose build` to build the image.

#Installation
Docker will automatically install the newly built image into the cache.

#Tips and Tricks

##Testing The Image

`docker-compose up` will launch the image allowing you to test your configuration and templates. The `docker-compose.yml` file controls
how the container is started and needs to be modified to match your environment.  The container requires access to the folder 
containing your ECS template files.  Make sure to change the volume entry to point to that location.  You'll also have
to edit the coordinates to your artifact repository.  The default values will not work for you.   

The template files are [ECS](http://docs.aws.amazon.com/cli/latest/reference/ecs/index.html) compatible files.  The following
are samples and yours will almost certainly be different.  The container expects three files to be in the templates folder: 

**task-definition.template**
```javascript
{
    "family": "${family}",
    "containerDefinitions": [
        {
            "name": "${containerName}",
            "image": "${registry}/${imageName}:${imageTag}",
            "portMappings": [
                {
                    "containerPort": 8080,
                    "hostPort": 1234,
                    "protocol": "tcp"
                }
            ],
            "essential": true,
            "hostname": "${containerName}",
            "dockerLabels": {
                "release": "${imageTag}"
            }
        }
    ]
}
```

**service-definition.template**
```javascript
{
    "cluster": "${clusterName}",
    "serviceName": "${serviceName}",
    "taskDefinition": "${family}",
    "loadBalancers": [
        {
            "loadBalancerName": "${loadBalancerName}",
            "containerName": "${containerName}",
            "containerPort": 8080
        }
     ],
    "desiredCount": ${desiredCount},
    "clientToken": "${clientToken}",
    "role": "${ecsInstanceRole}"
}
```

**service-update.template**
```javascript
{
    "cluster": "${clusterName}",
    "service": "${serviceName}",
    "desiredCount": ${desiredCount},
    "taskDefinition": "${family}"
}
```

The templates can contain the following keywords, which will be replaced with values supplied when the container runs, typically 
at build time as part of a CI chain.

* **artifactGroup** - the group portion of the Maven coordinates to use when publishing the descriptors, eg. org.kurron
* **artifactID** - the name of the Maven coordinates, eg. mySuperDuperService
* **major** - the major version number, see [Semantic Versioning](http://semver.org/)
* **minor** - the minor version number, see [Semantic Versioning](http://semver.org/)
* **patch** - the patch version number, see [Semantic Versioning](http://semver.org/)
* **branch** - the name of the VCS branch being built.  Valid values are `master` and `development`.
* **releaseURL** - the URL where `master` branch publications should go, eg. `http://artifactory.example.com/artifactory/release`
* **milestoneURL** - the URL where `development` branch publications should go, eg. `http://artifactory.example.com/artifactory/milestone`
* **publishUsername** - the username to use when authenticating with the artifact repository
* **publishPassword** - the password to use when authenticating with the artifact repository
* **family** - the ECS family that the descriptor belongs to, eg. production-system
* **containerName** - the name Docker will use when the container is deployed into the ECS family, eg. Bravo Container
* **registry** - the Docker registry to pull the container from, eg. registry.example.com
* **imageName** - the Docker image to pull from the registry, eg. image-bravo
* **imageTag** - the tag of the Docker image to pull, eg. 1.2.3.RELEASE
* **clusterName** - the ECS cluster to publish to, eg. my-ecs-cluster
* **serviceName** - the name of the service being deployed into the ECS family, eg. bravo-service
* **loadBalancerName** - the AWS name of the load balancer to bind the container to, if an ELB is defined, eg. ecs-load-balancer
* **ecsInstanceRole** - the name of the AWS role that should be used to bind the container to the load balancer, if one is being used, eg. ecs-elb-role
* **desiredCount** - the number of container instances you want deployed into your ECS cluster, eg. 3
 

#Troubleshooting

TODO

#License and Credits
This project is licensed under the [Apache License Version 2.0, January 2004](http://www.apache.org/licenses/).

#List of Changes

