$ImageTagName = 'oneview-powershell-ubuntu'

# Download and save the HPE OneView PowerShell module from PowerShell Gallery
Save-Module HPOneView.500 -Path .

# Build the image
docker build -t $ImageTagName .

# Execute the image, and display the modules PSLibraryVersion global variable
docker run $ImageTagName pwsh -c 'Import-Module HPOneView.500; $PSLibraryVersion'