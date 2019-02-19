Configuration VMConfig {
    Import-DscResource -ModuleName cChoco
    Import-DSCResource -ModuleName xStorage
    Import-DscResource -ModuleName PsDesiredStateConfiguration

    Node 'localhost' {
        xWaitforDisk Disk2 {
            DiskId           = 2
            RetryIntervalSec = 60
            RetryCount       = 10
        }
        xDisk FVolume {
            DiskId      = 2
            DriveLetter = 'F'
            FSLabel     = 'Data'
        }
        WindowsFeature InstallWebServer { 
            Ensure = "Present"
            Name   = "Web-Server" 
        }
        cChocoInstaller installChoco {
            InstallDir = 'C:\choco'
        }
        
        cChocoPackageInstaller NetCore_sdk {
            Name      = 'dotnetcore-sdk'
            DependsOn = '[cChocoInstaller]installChoco'
        }
        cChocoPackageInstaller NetCore_runtime {
            Name      = 'dotnetcore-windowshosting'
            DependsOn = '[cChocoInstaller]installChoco'
        }
    } 
}