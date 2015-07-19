$rubyInstallerVersion='2.1.6'
$rubyInstallDir="C:\Ruby21"
$rubyInstallerBin="rubyinstaller-${rubyInstallerVersion}.exe"
$rubyInstallerURL="http://installer-bin.streambox.com/$rubyInstallerBin"
$devkitInstallerVersion='4.7.2'
$devkitInstallerBin="DevKit-mingw64-32-${devkitInstallerVersion}-20130224-1151-sfx.exe"
$devkitInstallerURL="http://installer-bin.streambox.com/$devkitInstallerBin"
$devkitInstallDir="$rubyInstallDir\devkit"


$cdir=Convert-Path .



if(!(test-path "$rubyInstallerBin"))
{
	Try
	{
		Write-Debug "Download latest $rubyInstallerBin module from $rubyInstallerURL"
		#Start-BitsTransfer -Source $OnlinePSWUSource -Destination $TEMPDentination
		$WebClient = New-Object System.Net.WebClient
		$WebClient.DownloadFile($rubyInstallerURL,$rubyInstallerBin)
	}
	catch
	{
		Write-Error "Can't download the latest $rubyInstallerBin from website: $rubyInstallerURL" -ErrorAction Stop
	}
}

if(!(test-path "$devkitInstallerBin"))
{
	Try
	{
		Write-Debug "Download latest $devkitInstallerBin module from $devkitInstallerURL"
		#Start-BitsTransfer -Source $OnlinePSWUSource -Destination $TEMPDentination
		$WebClient = New-Object System.Net.WebClient
		$WebClient.DownloadFile($devkitInstallerURL,$devkitInstallerBin)
	}
	catch
	{
		Write-Error "Can't download the latest $devkitInstallerBin from website: $devkitInstallerURL" -ErrorAction Stop
	}
}




& $cdir\$rubyInstallerBin /verysilent /lang=en /dir="$rubyInstallDir" /tasks="assocfiles,modpath,addtk" | write-output
# Use this PSCX to debug these aweful params
# & "C:\Program Files\PowerShell Community Extensions\Pscx3\Pscx\Apps\EchoArgs.exe" $cdir\$devkitInstallerBin -y `-o$rubyInstallDir\devkit
# also here: http://goo.gl/Y0dFbd
& $cdir\$devkitInstallerBin `-o"$rubyInstallDir\devkit" -y | write-output



$ruby="$rubyInstallDir\bin\ruby.exe"
$gem="$rubyInstallDir\bin\gem.bat"

set-location $devkitInstallDir

@"
set PATH=$rubyInstallDir\bin;%PATH%

ruby dk.rb init
ruby dk.rb install
"@	| Out-File -encoding 'ASCII' devkitinit.cmd
& cmd /c devkitinit.cmd | write-output


set-location $cdir


@"
set PATH=$rubyInstallDir\bin;%PATH%
cmd /c gem install bundler
"@	| Out-File -encoding 'ASCII' bundler.cmd
& cmd /c bundler.cmd | write-output




@"
source 'https://rubygems.org'

gem "bunlder"
gem "ocra"
gem "iniparse"
"@	| Out-File -encoding 'ASCII' Gemfile

@"
set PATH=$rubyInstallDir\bin;%PATH%
bundle install
"@	| Out-File -encoding 'ASCII' bundler.cmd
& cmd /c bundler.cmd | write-output
