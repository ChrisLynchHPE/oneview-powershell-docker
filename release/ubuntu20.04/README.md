# HPE OneView PowerShell Library and Docker

These Dockerfiles enable running the HPE OneView PowerShell library in a container for each supported distribution.  Each provided Docker image can be used for testing, demonstration or even production use.

This requires Docker 17.05 or newer.
It also expects you to be able to run Docker without `sudo`.
Please follow [Docker's official instructions][install] to install `docker` correctly.

[install]: https://docs.docker.com/engine/installation/

## Release

The container images derive from Microsoft's official distribution images, such as `ubuntu:20.04`, install dependancies for PowerShell Core, then the HPE OneView 5.50 or newer library from the PowerShell Gallery.

These containers live at https://hub.docker.com/u/chrislynchhpe

* [Ubuntu 20.04/focal][docker-ubuntu-release]

> __NOTE:__ More Docker images will be created and posted in the near future.  We are currently planning a CentOS and Windows images.

At about 560 megabytes, they are decently minimal.

[docker-ubuntu-release]: https://hub.docker.com/r/chrislynchhpe/oneview-powershell-ubuntu

## Examples

To run PowerShell from using a container:

```sh
$ docker run -it chrislynchhpe/oneview-powershell-ubuntu
Unable to find image 'microsoft/powershell:latest' locally
latest: Pulling from microsoft/powershell
cad964aed91d: Already exists
3a80a22fea63: Already exists
50de990d7957: Already exists
61e032b8f2cb: Already exists
9f03ce1741bf: Already exists
adf6ad28fa0e: Pull complete
10db13a8ca02: Pull complete
75bdb54ff5ae: Pull complete
Digest: sha256:92c79c5fcdaf3027626643aef556344b8b4cbdaccf8443f543303319949c7f3a
Status: Downloaded newer image for microsoft/powershell:latest
PowerShell
Copyright (c) Microsoft Corporation. All rights reserved.

PS /> Import-Module HPOneView.500
PS /> $PSLibraryVersion
```

## Building the images

To build an image run `./build.ps1`.

### Example

For example to build Ubuntu 20.04/focal, which is in `./release/ubuntu20.04`:

```sh
PS /> ./release/ubuntu20.04/build.ps1
Sending build context to Docker daemon  9.575MB
Step 1/20 : ARG fromTag=18.04
Step 2/20 : ARG imageRepo=ubuntu
Step 3/20 : FROM ${imageRepo}:${fromTag} AS installer-env
 ---> a2a15febcdf3
Step 4/20 : ARG PS_VERSION=6.2.0
 ---> Using cache
 ---> bf52889815e6
Step 5/20 : ARG PS_PACKAGE=powershell_${PS_VERSION}-1.ubuntu.18.04_amd64.deb
 ---> Using cache
 ---> 3fce70dd5d9d
Step 6/20 : ARG PS_PACKAGE_URL=https://github.com/PowerShell/PowerShell/releases/download/v${PS_VERSION}/${PS_PACKAGE}
 ---> Using cache
 ---> 9291845770a1
Step 7/20 : RUN echo ${PS_PACKAGE_URL}
 ---> Using cache
 ---> d25f2d643a7b
Step 8/20 : ADD ${PS_PACKAGE_URL} /tmp/powershell.deb
Downloading [==================================================>]  57.86MB/57.86MB
 ---> Using cache
 ---> f3c08e2efecd
Step 9/20 : ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false     LC_ALL=en_US.UTF-8     LANG=en_US.UTF-8     PSModuleAnalysisCachePath=/var/cache/microsoft/powershell/PSModuleAnalysisCache/ModuleAnalysisCache
 ---> Using cache
 ---> f207b2803d1c
Step 10/20 : RUN apt-get update     && apt-get install -y /tmp/powershell.deb     && apt-get install -y     less     locales     ca-certificates     gss-ntlmssp     && apt-get dist-upgrade -y     && apt-get clean     && rm -rf /var/lib/apt/lists/*     && locale-gen $LANG && update-locale     && rm /tmp/powershell.deb     && pwsh     -NoLogo     -NoProfile     -Command "     \$ErrorActionPreference = 'Stop' ;     \$ProgressPreference = 'SilentlyContinue' ;     while(!(Test-Path -Path \$env:PSModuleAnalysisCachePath)) {      Write-Host "'Waiting for $env:PSModuleAnalysisCachePath'" ;     Start-Sleep -Seconds 6 ;     }"
 ---> Using cache
 ---> 9314cc446e0c
Step 11/20 : ARG VCS_REF="none"
 ---> Using cache
 ---> 5dfa39d99e2a
Step 12/20 : ARG IMAGE_NAME=chrislynchhpe/oneview-powershell:ubuntu18.04
 ---> Using cache
 ---> 493751dbd27d
Step 13/20 : LABEL maintainer="Chris Lynch <chris.lynch@hpe.com"     readme.md="https://github.com/ChrisLynchHPE/oneview-powershell-docker/blob/master/docker/README.md"     description="This Dockerfile will install the latest release of PowerShell and HPE OneView PowerShell 5.00 library for Ubuntu 18.04."     org.label-schema.usage="https://github.com/ChrisLynchHPE/oneview-powershell-docker/blob/master/docker/README.md"     org.label-schema.url="https://github.com/ChrisLynchHPE/oneview-powershell-docker/blob/master/docker/README.md"     org.label-schema.vcs-url="https://github.com/ChrisLynchHPE/oneview-powershell-docker"     org.label-schema.name="oneview-powershell-ubuntu"     org.label-schema.vendor="HewlettPackardEnterprise"     org.label-schema.version=${PS_VERSION}     org.label-schema.schema-version="1.0"     org.label-schema.vcs-ref=${VCS_REF}     org.label-schema.docker.cmd="docker run ${IMAGE_NAME} pwsh -c 'Import-Module HPOneView.500; $PSLibraryVersion'"     org.label-schema.docker.cmd.test="docker run ${IMAGE_NAME} pwsh -c Invoke-Pester"     org.label-schema.docker.cmd.help="docker run ${IMAGE_NAME} pwsh -c 'Get-Help about_HPOneView.500''"
 ---> Using cache
 ---> ed6d1bf0fc10
Step 14/20 : WORKDIR /root
 ---> Using cache
 ---> cd8e3b2b2a02
Step 15/20 : RUN mkdir -p .local/share/powershell/Modules/HPOneView.500
 ---> Using cache
 ---> 4cdc012e46a1
Step 16/20 : COPY HPOneView.500/ .local/share/powershell/Modules/HPOneView.500/
 ---> Using cache
 ---> 62a92b348b7b
Step 17/20 : RUN mkdir -p /root/enterprise-certs
 ---> Running in 465194d434bf
Removing intermediate container 465194d434bf
 ---> d530e722d348
Step 18/20 : COPY enterprise-certs/ /root/enterprise-certs/
 ---> ef8897c1a797
Step 19/20 : RUN pwsh     -NoLogo     -NoProfile     -Command "     \$ErrorActionPreference = 'Stop' ;     \$ProgressPreference = 'SilentlyContinue' ;     ForEach (\$file in (Get-ChildItem \$HOME/enterprise-certs)) {      Write-Host \"Moving \$(\$file.FileName) to /usr/local/share/ca-certificates\" ;     Copy-Item \$file -Destination \"/usr/local/share/ca-certificates/\$(\$file.BaseName).crt\" -force -confirm:\$false;     };     update-ca-certificates"
 ---> Running in c775ba24f936
Moving  to /usr/local/share/ca-certificates
Updating certificates in /etc/ssl/certs...
1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
Removing intermediate container c775ba24f936
 ---> 4c424dfe565b
Step 20/20 : CMD [ "pwsh" ]
 ---> Running in 326ab9437a46
Removing intermediate container 326ab9437a46
 ---> cba1c5159764
Successfully built cba1c5159764
Successfully tagged oneview-powershell-ubuntu:latest
SECURITY WARNING: You are building a Docker image from Windows against a non-Windows Docker host. All files and directories added to build context will have '-rwxr-xr-x' permissions. It is recommended to double check and reset permissions for sensitive files and directories.
```

### Run the Docker image you built

```sh
PS /> docker run -it oneview-powershell-ubuntu pwsh -c '$PSLibraryVersion'

LibraryVersion Path
-------------- ----
5.0.2152.1665  /root/.local/share/powershell/Modules/HPOneView.500/5.0.2152.16…
```

## Legal and Licensing

The HPE OneView PowerShell library is licensed under the [MIT license][].

[MIT license]: https://github.com/HewlettPackard/POSH-HPOneView/blob/master/LICENSE