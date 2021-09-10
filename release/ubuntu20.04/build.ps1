<#
    .SYNOPSIS
    This script will build a docker image with Ubuntu 20.00 LTS, Powershell Core 7.1.4, your choice of HPEOneview Powershell 5.50, 6.00, or 6.10 and then run it in docker locally.

    .DESCRIPTION
    You can easily create docker images to test different versions of HPEOneview Powershell on Powershell Core, or use it in Prod as a standard pwsh environment that runs in a container/pod. This image can also be used with Kubernetes (Jenkins, for example), but consult your company's security standards for compliance.

    .INPUTS
    -HPEOVPSVersion (Accepts 5.50, 6.00, or 6.10 with this release.)
    -ImageTagName (Name the docker image here. Recommended: Create one per HPE Version.)
    -KeepPreviousImage (If an image exists with the specified ImageTagName, this script will delete it and build it again [basic image cleanup]. Default = $true)

    .OUTPUTS
     docker image list
     REPOSITORY                             TAG       IMAGE ID       CREATED        SIZE
     oneview-powershell-ubuntu              latest    66243bf6674d   27 hours ago   399MB

    .LINK
    https://github.com/HewlettPackard/POSH-HPEOneView

    .EXAMPLE
    PS> ./build.ps1 -HPEOVPSVersion 5.50 -ImageTagName 'oneview-powershell-ubuntu-550'

    .EXAMPLE
    PS> ./build.ps1 -HPEOVPSVersion 6.10 -ImageTagName 'oneview-powershell-ubuntu-610'

    .EXAMPLE
    PS> ./build.ps1 -HPEOVPSVersion 6.10 -ImageTagName 'oneview-powershell-ubuntu-610' -KeepPreviousImage:$false

#>

## Setup Params for HPE Powershell Version
param(
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$false)]
        [string]$HPEOVPSVersion,

        [Parameter(Mandatory=$true,
        ValueFromPipeline=$false)]
        [string]$ImageTagName,

        [Parameter(Mandatory=$false,
        ValueFromPipeline=$false)]
        [bool]$KeepPreviousImage = $true
    )

## Ensure proper entry for HPE Powershell Version and run only if using a proper version:
If (($HPEOVPSVersion -eq '5.50') -Or ($HPEOVPSVersion -eq '6.00') -Or ($HPEOVPSVersion -eq '6.10')) {
    # If there is an existing image by that name and user does not want to keep previous image, delete any existing image by this $ImageTagName
    $ImageExists = docker image list | grep $ImageTagName
    If (($KeepPreviousImage -eq $false) -And ($ImageExists)) {
      docker rmi --force $ImageTagName
    }

    # Setup Parameters for use with docker command.
    $Env:HPEOVPSMajorVersion=$HPEOVPSVersion.split(".") | Select-Object -Index 0
    $Env:HPEOVPSMinorVersion=$HPEOVPSVersion.split(".") | Select-Object -Index 1

    # Build the image
    docker build -t $ImageTagName . --build-arg HPE_ONEVIEW_MAJOR_VERSION=$Env:HPEOVPSMajorVersion --build-arg HPE_ONEVIEW_MINOR_VERSION=$Env:HPEOVPSMinorVersion

    # Execute the image
    docker run -ti $ImageTagName

}
Else {
    Write-Host -ForegroundColor Red  "You must enter an HPEOVVersion that is 5.50, 6.00, or 6.10 at this time or the docker build will fail. If there is a newer version please contact bryan.sullins@gmail.com or alter the PS code in the build.ps1 file."
    Exit
}
