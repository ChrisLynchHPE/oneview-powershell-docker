## Setup Params for HPE Powershell Version
param(
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$false)]
        [string]$HPEOVVersion,

        [Parameter(Mandatory=$true,
        ValueFromPipeline=$false)]
        [string]$ImageTagName,

        [Parameter(Mandatory=$false,
        ValueFromPipeline=$false)]
        [bool]$KeepPreviousImageTagName
    )

# Uncomment to Override $ImageTageName specified.
# $ImageTagName='oneview-powershell-ubuntu' # Example

# Ensure proper entry for HPE Powershell Version and run only if using a proper version:
If (($HPEOVVersion -eq '5.50') -Or ($HPEOVVersion -eq '6.00') -Or ($HPEOVVersion -eq '6.10')) {
    # If there is an existing image by that name and user does not want to keep previous image, delete any existing image by this $ImageTagName
    $ImageExists = docker image list | grep $ImageTagName
    If (($KeepPreviousImageTagName -eq $false) -And ($ImageExists)) {
      docker rmi --force $ImageTagName
    }
    # Setup Parameters for use with docker command.
    $Env:OVMajorVersion=$HPEOVVersion.split(".") | Select-Object -Index 0
    $Env:OVMinorVersion=$HPEOVVersion.split(".") | Select-Object -Index 1

    # Build the image
    docker build -t $ImageTagName . --build-arg HPE_ONEVIEW_MAJOR_VERSION=$Env:OVMajorVersion --build-arg HPE_ONEVIEW_MINOR_VERSION=$Env:OVMinorVersion

    # Execute the image
    docker run -ti $ImageTagName

}
Else {
    Write-Host -ForegroundColor Red  "You must enter an HPEOVVersion that is 5.50, 6.00, or 6.10 at this time or the docker build will fail. If there is a newer version please contact bryan.sullins@gmail.com or alter the PS code in the build.ps1 file."
    Exit
}
