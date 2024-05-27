
function powershell-designer($a) {
	function path($a) {
		return Split-Path -Path $a
	}
	function chr($a) {
		$a = $a | Out-String
    return [char][byte]$a
	}
	
	$folderExists = Test-Path -path ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions")
	if ($folderExists -eq $false){
		New-Item -ItemType directory -Path ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions")
	}

	$functionsExists = Test-Path -path ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\functions.psm1")
	if ($functionsExists -eq $false){
		Copy-Item -Path "$PSScriptRoot\functions\functions.psm1" -destination ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\functions.psm1")
	}

	$dependenciesExists = Test-Path -path ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\Dependencies.ps1")
	if ($dependenciesExists -eq $false){
		Copy-Item -Path "$PSScriptRoot\functions\Dependencies.ps1" -destination ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\Dependencies.ps1")
	}
	
	$designerExists = Test-Path -path ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\designer\designer.ps1")
	if ($designerExists -eq $false){
		New-Item -ItemType directory -Path ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\Designer")
		Copy-Item -Path "$PSScriptRoot\Designer.fbs" -destination ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer")
		Copy-Item -Path "$PSScriptRoot\Designer\Designer.ps1" -destination ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\Designer")
		Copy-Item -Path "$PSScriptRoot\Designer\Events.ps1" -destination ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\Designer")
		Copy-Item -Path "$PSScriptRoot\Designer\finds.txt" -destination ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\Designer")
	}
	
	$ExamplesExists = Test-Path -path ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\Examples")
	if ($ExamplesExists -eq $false){
		Copy-Item -Path "$PSScriptRoot\Examples" -destination ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\Examples") -recurse
	}
	
	if ($a) {
		if ((get-host).version.major -eq 7) {
			if ((Get-Module -ListAvailable powershell-designer).count -gt 1){
				start-process -filepath pwsh.exe -argumentlist '-ep bypass',"-file $(chr 34)$(path $(Get-Module -ListAvailable PowerShell-Designer)[0].path)\Designer\Designer.ps1$(chr 34)","$($a)"
			}
			else {
				start-process -filepath pwsh.exe -argumentlist '-ep bypass',"-file $(chr 34)$(path $(Get-Module -ListAvailable PowerShell-Designer).path)\Designer\Designer.ps1$(chr 34)","$($a)"
			}
		}
		else {
			if ((Get-Module -ListAvailable powershell-designer).count -gt 1){
				start-process -filepath powershell.exe -argumentlist '-ep bypass',"-file $(chr 34)$(path $(Get-Module -ListAvailable PowerShell-Designer)[0].path)\Designer\Designer.ps1$(chr 34)","$($a)"
			}
			else {
				start-process -filepath powershell.exe -argumentlist '-ep bypass',"-file $(chr 34)$(path $(Get-Module -ListAvailable PowerShell-Designer).path)\Designer\Designer.ps1$(chr 34)","$($a)"
			}
		}
	}
	else{	
		if ((get-host).version.major -eq 7) {
			if ((Get-Module -ListAvailable powershell-designer).count -gt 1){
				start-process -filepath pwsh.exe -argumentlist '-ep bypass',"-file $(chr 34)$(path $(Get-Module -ListAvailable PowerShell-Designer)[0].path)\Designer\Designer.ps1$(chr 34)"
			}
			else {
				start-process -filepath pwsh.exe -argumentlist '-ep bypass',"-file $(chr 34)$(path $(Get-Module -ListAvailable PowerShell-Designer).path)\Designer\Designer.ps1$(chr 34)"
			}
		}
		else {
			if ((Get-Module -ListAvailable powershell-designer).count -gt 1){
				start-process -filepath powershell.exe -argumentlist '-ep bypass',"-file $(chr 34)$(path $(Get-Module -ListAvailable PowerShell-Designer)[0].path)\Designer\Designer.ps1$(chr 34)"
			}
			else {
				start-process -filepath powershell.exe -argumentlist '-ep bypass',"-file $(chr 34)$(path $(Get-Module -ListAvailable PowerShell-Designer).path)\Designer\Designer.ps1$(chr 34)"
			}
		}
	}
}