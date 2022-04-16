
function powershell-designer($a) {
	function path($a) {
		return Split-Path -Path $a
	}
	function chr($a) {
		$a = $a | Out-String
    return [char][byte]$a
	}

	if ((get-host).version.major -eq 7) {
		if ((Get-Module -ListAvailable powershell-designer).count -gt 1){
			start-process -filepath pwsh.exe -argumentlist '-ep bypass',"-file $(chr 34)$(path $(Get-Module PowerShell-Designer)[0].path)\Designer.ps1$(chr 34)"
		}
		else {
			start-process -filepath pwsh.exe -argumentlist '-ep bypass',"-file $(chr 34)$(path $(Get-Module PowerShell-Designer).path)\Designer.ps1$(chr 34)"
		}
	}
	else {
		if ((Get-Module -ListAvailable powershell-designer).count -gt 1){
			start-process -filepath powershell.exe -argumentlist '-ep bypass',"-file $(chr 34)$(path $(Get-Module PowerShell-Designer)[0].path)\Designer.ps1$(chr 34)"
		}
		else {
			start-process -filepath powershell.exe -argumentlist '-ep bypass',"-file $(chr 34)$(path $(Get-Module PowerShell-Designer).path)\Designer.ps1$(chr 34)"
		}
	}
}