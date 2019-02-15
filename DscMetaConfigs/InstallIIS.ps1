Configuration InstallIIS {
    # Import the module that contains the resources we're using.
    Import-DscResource -ModuleName PsDesiredStateConfiguration

    # The Node statement specifies which targets this configuration will be applied to.
    Node 'localhost' {

        # Install IIS
        WindowsFeature InstallWebServer 
        { 
            Ensure = "Present"
            Name = "Web-Server" 
        }
    }
}
Configuration InstallNetCore{

    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    choco install dotnetcore-sdk
    choco install dotnetcore-runtime
}