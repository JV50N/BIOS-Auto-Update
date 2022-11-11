
<#
# Name:     BIOS_UPDATE.ps1
# Purpose:  Provide BIOS Update firmware for HP and Dell Workstations @ PRAPA
# Author:   Jason Goncalves
# Initial:  November 10, 2022 
# Revision: 
# Notes:     
#>
 
<#
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host "You didn't run this script as an Administrator. This script will self elevate to run as an Administrator and continue."
    Start-Sleep 1
    Write-Host "                                               3"
    Start-Sleep 1
    Write-Host "                                               2"
    Start-Sleep 1
    Write-Host "                                               1"
    Start-Sleep 1
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}
#>

# If Using PowerShell 3 or greater
if($PSVersionTable.PSVersion.Major -gt 3) {
    $ScriptPath = $PSScriptRoot
# If using PowerShell 2 or lower
} else {
    $ScriptPath = split-path -parent $MyInvocation.MyCommand.Path
}
    
#Supported systems in this script
#Dell
	$Optiplex5090 = "*Optiplex 5090*"
	$Precision3460 = "*Precision3460*"
	$Optiplex5000 = "*Optiplex 5000*" 
#HP

    $HPG3 = "*EliteDesk 800 G3*"
    $HPG4 = "*EliteDesk 800 G4*"
    $HPG5 = "*EliteDesk 800 G5*"
    $HPZ2G5 = "HP Z2 SFF G5 Workstation"
 
#PC BIOS versions include in this script
#Dell
	$Optiplex5090Ver = "1.10.0"
	$Precision3460Ver = "1.6.0"
	$Optiplex5000Ver = "1.6.0"
	$Optiplex5090BINFILE = "$ScriptPath\DELL\Optiplex5090\OptiPlex_5090_1.10.0.exe"
	$Precision3460BINFILE = "$ScriptPath\DELL\Precision3460\Precision_3260_3460_1.6.0.exe"
	$Optiplex5000BINFILE = "$ScriptPath\DELL\Optiplex5000\OptiPlex_5000_1.6.0.exe"
#HP

    $HPG3BIOSVer = "P01 Ver. 02.40"
    $HPG4BIOSVer = "Q01 Ver. 02.20.01"
    $HPG5BIOSVer = "R01 Ver. 02.13.00"
    $HPZ2G5BIOSVer = "S50 Ver. 01.04.04"
    $HPG3BINFILE = "$ScriptPath\HP\HPG3\P01_0240.bin"
    $HPG5BINFILE = "$ScriptPath\HP\HPG5"
    $HPG4BINFILE = "$ScriptPath\HP\HPG4"
    $HPZ2G5BINFILE = "$ScriptPath\HP\HPZ2G5"

#
    $Logpath = "$Env:SystemDrive"



If (Test-Path "$logpath\Temp"){
    Write-Host Temp folder exist.
} else {
    New-Item -Path "$logpath\Temp" -ItemType Directory
}

Start-Transcript -OutputDirectory "$logpath\Temp"

#System Information

    $Manufacturer = $((Get-WmiObject -Class Win32_ComputerSystem).Manufacturer).Trim()
    $Model = $((Get-WmiObject -Class Win32_ComputerSystem).Model).Trim()
    $SerialNumber = $((Get-WmiObject -Class Win32_BIOS).SerialNumber).Trim()
    $PCBIOSVersion = $((Get-WmiObject -Class Win32_BIOS).SMBIOSBIOSVersion).Trim()
    $RunningOS = $((Get-WmiObject -Class Win32_OperatingSystem).Caption).Trim()
   
    Write-Host
    Write-Host "====================="
    Write-Host "PC System Information"
    Write-Host "====================="
    Write-Host "Manufacturer: " $Manufacturer -ForegroundColor Cyan
    Write-Host "Model: " $Model -ForegroundColor Cyan
    Write-Host "Serial Number: " $SerialNumber -ForegroundColor Cyan
    Write-Host "BIOS Version: " $PCBIOSVersion -ForegroundColor Cyan
    Write-Host "OS: " $RunningOS -ForegroundColor Cyan
    Write-Host 


#Check if this is a Dell or HP supported system
if ($Manufacturer -notlike "*Dell*" -and $Manufacturer -notlike "*HP*")

 {
    Write-Host "This script will only execute on Dell or HP supported systems . . ." -ForegroundColor Green
    Write-Host "Target system manufacturer is: " $Manufacturer -ForegroundColor Green
     
    Stop-Transcript
    Exit 0
}


Write-Host "The manufacturer of the PC is:" $Manufacturer -ForegroundColor Green
Write-Host "Identifying the model# of the PC ..." -ForegroundColor Green

if ($Model -notlike $Optiplex5000 -and $Model -notlike $Optiplex5090 -and $Model -notlike $HPG3 -and $Model -notlike $HPG5 -and $Model -notlike $Precision3460 -and $Model -notlike $HPZ2G5 -and $Model -notlike $HPG4)

 {
   Write-host "The script only supports Dell Optiplex 5090, Dell Optiplex 5000, Precision 3460, HP G3, G4, G5 & Z2 systems" -ForegroundColor Green
   Write-host "The model of this PC is: " $Manufacturer $Model -ForegroundColor Green
   Write-Host "The script will now exit." -ForegroundColor Green
   Stop-Transcript
   Exit 0
 }


If ($Manufacturer -like "*Dell*" -and $Model -like $Optiplex5000)

{

   Write-Host "Continue with Dell Optiplex 5000 system" -ForegroundColor Green

   if ([version]$PCBIOSVersion -ge [version]$Optiplex5000Ver)
   
    {
       Write-Host "BIOS version on PC is: " $PCBIOSVersion
       Write-Host "No update is required."
       Write-Host "script will now exit."
       Stop-Transcript
       Exit 0
    } 

   Else

    {
    Write-Host "BIOS version found on target is" $PCBIOSVersion -ForegroundColor Green
    Write-Host "Proceeding to flash PC BIOS to version " $Optiplex5000Ver -ForegroundColor Green
    Start-Process $Optiplex5000BINFILE -Argumentlist "/s /r" -Wait
    Sleep -Seconds 5
    Stop-Transcript
    Exit 0
    }
}

If ($Manufacturer -like "*Dell*" -and $Model -like $Optiplex5090)

{

   Write-Host "Continue with Dell Optiplex 5090 system" -ForegroundColor Green

   if ([version]$PCBIOSVersion -ge [version]$Optiplex5090Ver)
   
    {
       Write-Host "BIOS version on PC is: " $PCBIOSVersion
       Write-Host "No update is required."
       Write-Host "script will now exit."
       Stop-Transcript
       Exit 0
    } 

   Else

    {
    Write-Host "BIOS version found on target is" $PCBIOSVersion -ForegroundColor Green
    Write-Host "Proceeding to flash PC BIOS to version " $Optiplex5090Ver -ForegroundColor Green
    Start-Process $Optiplex5090BINFILE -Argumentlist "/s /r" -Wait
    Sleep -Seconds 5
    Stop-Transcript
    Exit 0
    }
}

If ($Manufacturer -like "*Dell*" -and $Model -like $Precision3460)

{

   Write-Host "Continue with Dell Precision 3460 system" -ForegroundColor Green

   if ([version]$PCBIOSVersion -ge [version]$Precision3460Ver)
   
    {
       Write-Host "BIOS version on PC is: " $PCBIOSVersion
       Write-Host "No update is required."
       Write-Host "script will now exit."
       Stop-Transcript
       Exit 0
    } 

   Else

    {
    Write-Host "BIOS version found on target is" $PCBIOSVersion -ForegroundColor Green
    Write-Host "Proceeding to flash PC BIOS to version " $Precision3460Ver -ForegroundColor Green
    Start-Process $Precision3460BINFILE -Argumentlist "/s /r" -Wait
    Sleep -Seconds 5
    Stop-Transcript
    Exit 0
    }
}

If ($Manufacturer -like "*HP*" -and $Model -like $HPG3)
      
{
   Write-Host "Continue with HP EliteDesk G3 System" -ForegroundColor Green

   if ($PCBIOSVersion -ge $HPG3BIOSVer)
  
    {
       Write-Host "BIOS version on PC is: " $PCBIOSVersion -ForegroundColor Green
       Write-Host "No update is required." -ForegroundColor Green
       Write-Host "script will now exit." -ForegroundColor Green
       Stop-Transcript
       Exit 0
    } 

   Else
    {
       Write-Host "BIOS version found on target is" $PCBIOSVersion -ForegroundColor Green
       Write-Host "Proceeding to flash PC BIOS to version " $HPG3BIOSVer -ForegroundColor Green
       Start-Process "$ScriptPath\HPG3\HPBIOSUPDREC64.exe" -Argumentlist "-s -f$HPG3BINFILE" -Wait
    
    Sleep -Seconds 5
    Stop-Transcript
    Exit 0
    }
}

If ($Manufacturer -like "*HP*" -and $Model -like $HPG5)
      
{
   Write-Host "Continue with HP EliteDesk G5 System" -ForegroundColor Green

   if ($PCBIOSVersion -ge $HPG5BIOSVer)
  
    {
       Write-Host "BIOS versio on PC is: " $PCBIOSVersion -ForegroundColor Green
       Write-Host "No update is required." -ForegroundColor Green
       Write-Host "script will now exit." -ForegroundColor Green
       Stop-Transcript
       Exit 0
    } 

   Else
    {
       Write-Host "BIOS version found on target is" $PCBIOSVersion -ForegroundColor Green
       Write-Host "Proceeding to flash PC BIOS to version " $HPG5BIOSVer -ForegroundColor Green
       Write-Host "Copying G5 Bin file to c:\downloads\G5bin"
       If (Test-Path "c:\downloads\G5bin")
           {
           Write-Host "c:\downloads\G5bin exist."
           Remove-Item -Path c:\downloads\G5bin\*.* -Force -Exclude *.log
           }
       else 
           {
           New-Item -Path "c:\downloads\G5bin" -ItemType Directory
           }
       Copy-Item -Path "$HPG5BINFILE\*" -Destination c:\downloads\G5bin -Exclude LDCacheInfo
       Push-Location -Path "c:\downloads\G5bin"
       Start-Process "HPFirmwareUpdRec64.exe" -Argumentlist "-s" -Wait
    
    Sleep -Seconds 5
    Stop-Transcript
    Exit 0
    }
}

If ($Manufacturer -like "*HP*" -and $Model -like $HPZ2G5)
      
{
   Write-Host "Continue with HP Z2 SFF G5 Workstation" -ForegroundColor Green

   if ($PCBIOSVersion -ge $HPZ2G5BIOSVer)
  
    {
       Write-Host "BIOS versio on PC is: " $PCBIOSVersion -ForegroundColor Green
       Write-Host "No update is required." -ForegroundColor Green
       Write-Host "script will now exit." -ForegroundColor Green
       Stop-Transcript
       Exit 0
    } 

   Else
    {
       Write-Host "BIOS version found on target is" $PCBIOSVersion -ForegroundColor Green
       Write-Host "Proceeding to flash PC BIOS to version " $HPZ2G5BIOSVer -ForegroundColor Green
       Write-Host "Copying HP Z2 G5 Bin file to c:\downloads\HPZ2G5bin"
       If (Test-Path "c:\downloads\HPZ2G5bin")
           {
           Write-Host "c:\downloads\HPZ2G5bin exist."
           Remove-Item -Path c:\downloads\HPZ2G5bin\*.* -Force -Exclude *.log
           }
       else 
           {
           New-Item -Path "c:\downloads\HPZ2G5bin" -ItemType Directory
           }
       Copy-Item -Path "$HPZ2G5BINFILE\*" -Destination c:\downloads\HPZ2G5bin -Exclude LDCacheInfo
       Push-Location -Path "c:\downloads\HPZ2G5bin"
       Start-Process "HPFirmwareUpdRec64.exe" -Argumentlist "-s" -Wait
    
    Sleep -Seconds 5
    Stop-Transcript
    Exit 0
    }
}
 
If ($Manufacturer -like "*HP*" -and $Model -like $HPG4)
      
{
   Write-Host "Continue with HP EliteDesk G4 System" -ForegroundColor Green

   if ($PCBIOSVersion -ge $HPG4BIOSVer)
  
    {
       Write-Host "BIOS versio on PC is: " $PCBIOSVersion -ForegroundColor Green
       Write-Host "No update is required." -ForegroundColor Green
       Write-Host "script will now exit." -ForegroundColor Green
       Stop-Transcript
       Exit 0
    } 

   Else
    {
       Write-Host "BIOS version found on target is" $PCBIOSVersion -ForegroundColor Green
       Write-Host "Proceeding to flash PC BIOS to version " $HPG4BIOSVer -ForegroundColor Green
       Write-Host "Copying G5 Bin file to c:\downloads\G4bin"
       If (Test-Path "c:\downloads\G4bin")
           {
           Write-Host "c:\downloads\G4bin exist."
           Remove-Item -Path c:\downloads\G4bin\*.* -Force -Exclude *.log
           }
       else 
           {
           New-Item -Path "c:\downloads\G4bin" -ItemType Directory
           }
       Copy-Item -Path "$HPG4BINFILE\*" -Destination c:\downloads\G4bin -Exclude LDCacheInfo
       Push-Location -Path "c:\downloads\G4bin"
       Start-Process "HPFirmwareUpdRec64.exe" -Argumentlist "-s" -Wait
    
    Sleep -Seconds 5
    Stop-Transcript
    Exit 0
    }
}


