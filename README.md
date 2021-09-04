# HPE OneView PowerShell Library and Docker

These Dockerfiles enable building/running the HPE OneView PowerShell library in a container for each supported distribution.  Each provided Docker image can be used for testing, demonstration or even production use. Consult your corporate security standards for implementation in production.

- This repo's code requires Docker 17.05 or newer, and Powershell (or Powershell Core 6.2).
- This was tested on Mac/Linux with Powershell Core 7.1.4 and docker verion 20.10.8.
- It also expects you to be able to run Docker without `sudo`.
- Please follow [Docker's official instructions][install] to install `docker` correctly.

[install]: https://docs.docker.com/engine/installation/

## Release

The container images derive from Ubuntu's official distribution images, such as `ubuntu:20.04`, install dependencies for PowerShell Core, then the HPE OneView 5.50 or newer library from the PowerShell Gallery.

> __NOTE:__ OneView Powershell 5.40 and older is not supported in this release.

These containers live at <https://hub.docker.com/u/chrislynchhpe> but this can be used to build your own internal images.

> __NOTE:__ More Docker images will be created and posted in the near future.  We are currently planning CentOS and Windows images.

At about 350-399 megabytes total, these are decently minimal image sizes.

Current location for available Ubuntu 18.04 LTS release: [docker-ubuntu-release](https://hub.docker.com/r/chrislynchhpe/oneview-powershell-ubuntu)

## Building the images

### For Building Images for Ubuntu 18.04:

To build an image:

 ```powershell
PS /> Set-Location ./release/ubuntu18.04
PS /> ./build.ps1
```

### For Building Images for Ubuntu 20.04:

Extra parameters are available with release 20.04. The `./build.ps1` script has help available with:

```powershell
Get-Help ./build.ps1 -Full
```

While running `./build.ps1` you can specify the following options:

- `-HPEOVPSVersion` (Accepts 5.50, 6.00, or 6.10 with this release.)
- `-ImageTagName` (Name the docker image here. Recommended: Create one per HPE Version.)
- `-KeepPreviousImage` (If an image exists with the specified ImageTagName, this script will delete it and build it again [basic image cleanup]. Default = $true)

> __NOTE:__ If you know what you are doing in the `dockerfile`, these parameters can be overridden, including the Ubuntu Version and Powershell version, but alterations beyond what are given in `build.ps1` are currently "user-supported".

### Example: Build the Image with Ubuntu 20.04 LTS

For example to build Ubuntu `20.04/focal`, run `./build.ps1` (with parameters) which is in `./release/ubuntu20.04`:

```powershell
PS /> Set-Location ./release/ubuntu20.04/
PS /> ./build.ps1 -HPEOVPSVersion 6.10 -ImageTagName oneview-powershell-6.10-ubuntu-20.04 -KeepPreviousImageTagName:$false
Building 138.9s (15/15) FINISHED
 => [internal] load build definition from Dockerfile 
=> => transferring dockerfile: 5.93kB
 => [internal] load .dockerignore
 => => transferring context: 34B
 => [internal] load metadata for docker.io/library/ubuntu:20.04
 => [internal] load build context 
 => => transferring context: 84B
 => CACHED [1/9] FROM docker.io/library/ubuntu:20.04@sha256:9d6a8699fb5c9c39cf08a0871bd6219f0400981c570894cd8cbea30d3424a31f
 => CACHED https://github.com/PowerShell/PowerShell/releases/download/v7.1.4/powershell_7.1.4-1.ubuntu.20.04_amd64.deb
 => [2/9] RUN echo https://github.com/PowerShell/PowerShell/releases/download/v7.1.4/powershell_7.1.4-1.ubuntu.20.04_amd64.deb
 => [3/9] ADD https://github.com/PowerShell/PowerShell/releases/download/v7.1.4/powershell_7.1.4-1.ubuntu.20.04_amd64.deb /tmp/powershell.deb
 => [4/9] RUN apt-get update     && apt-get install -y /tmp/powershell.deb     && apt-get install -y     less     locales     ca-certificates     gss-ntlmssp     && apt-get dist-upgrade -y     && apt-get clean     &&  40.3s
 => [5/9] WORKDIR /root
 => [6/9] RUN pwsh     -NoLogo     -NoProfile     -Command "     $ErrorActionPreference = 'Stop' ;     $ProgressPreference = 'SilentlyContinue' ;     Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted" && 
 => [7/9] RUN mkdir -p /root/enterprise-certs
 => [8/9] COPY enterprise-certs/ /root/enterprise-certs/
 => [9/9] RUN pwsh     -NoLogo     -NoProfile     -Command "     $ErrorActionPreference = 'Stop' ;     $ProgressPreference = 'SilentlyContinue' ;     ForEach ($file in (Get-ChildItem $HOME/enterprise-certs -exclude *. 
 => exporting to image
 => => exporting layers
 => => writing image sha256:cfb8bac1158f7818424283a022ad526b50be670884a4598506b01fd4b519b3cc
 => => naming to docker.io/library/oneview-powershell-6.10-ubuntu-20.04
```

### Example: Run the Docker Image You Built (After First-run of `./build.ps1`)

```sh
sh> docker run -it oneview-powershell-6.10-ubuntu-20.04
PowerShell 7.1.4
Copyright (c) Microsoft Corporation.

https://aka.ms/powershell
Type 'help' to get help.

PS /root> Get-Module -ListAvailable -Name HPEOneview.550

    Directory: /usr/local/share/powershell/Modules

ModuleType Version    PreRelease Name                                PSEdition ExportedCommands
---------- -------    ---------- ----                                --------- ----------------
Script     5.50.2794…            HPEOneView.550                      Desk      {Disable-OVApplianceComplexPasswords, Enable-OVLogicalInterconnectPortMonitoring, Get-OVStorageSystem, Get-OVAutomaticBackupConfig…}
```

### Example: Run the Available Image from Docker Hub `chrislynchhpe/oneview-powershell-ubuntu`

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

## Legal and Licensing

The HPE OneView PowerShell library is licensed under the [MIT license][].

[MIT license]: https://github.com/HewlettPackard/POSH-HPOneView/blob/master/LICENSE