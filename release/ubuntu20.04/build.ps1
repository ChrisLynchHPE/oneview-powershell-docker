# Desired Local Tag Name
$ImageTagName='oneview-powershell-ubuntu'

# Remove previously-built images by this process and build a new one:
$ImageExists = docker image list | grep $ImageTagName
Write-Host $ImageExists
If ($ImageExists) {
    docker rmi --force $ImageTagName
}

# Build the image
docker build -t $ImageTagName .

# Execute the image, and display the modules PSLibraryVersion global variable
docker run -ti $ImageTagName