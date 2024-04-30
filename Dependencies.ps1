function FunctionTimer{}
$functionTimer = (New-Timer -Interval 100)

$functionTimer.Add_Tick({
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Set-WindowNotOnTop")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-WindowPosition"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Set-WindowOnTop")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-WindowPosition"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Close-Window")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("New-SendMessage"), $true)
	}

	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Send-ClickToWindow")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-WindowPosition"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-ActiveWindow"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Send-RightClickToWindow")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-WindowPosition"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-ActiveWindow"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Get-BootTime")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-SubString"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Get-Key")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Ascii"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Character"), $true)
	}

	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Get-Escape")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Character"), $true)
	}

	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Get-CarriageReturn")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Character"), $true)
	}

	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Get-LineFeed")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Character"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Send-Window")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-ActiveWindow"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Open-DataSourceName")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-ODBC"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Close-DataSourceName")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-ODBC"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Get-DataTables")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-ODBC"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Add-ContextMenuStripItem")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-ImageFromStream"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-ImageFromFile"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-SubString"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Add-MenuRow")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-ImageFromStream"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-ImageFromFile"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-SubString"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Add-ToolStripItem")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-ImageFromStream"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-ImageFromFile"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-SubString"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Show-Excel")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-Excel"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Hide-Excel")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-Excel"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Add-ExcelWorkbook")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-Excel"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Add-ExcelWorksheet")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-Excel"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Open-ExcelWorkbook")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-Excel"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Save-ExcelWorkbook")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-Excel"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Select-ExcelSheet")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-Excel"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Set-ExcelCell")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-Excel"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Get-ExcelCell")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-Excel"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Remove-ExcelColumn")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-Excel"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Remove-ExcelRow")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-Excel"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("New-ExcelColumn")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-Excel"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("New-ExcelRow")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-Excel"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Get-ExcelColumnCount")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-Excel"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Get-ExcelRowCount")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-Excel"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Remove-Font")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-SubString"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Open-SeleniumURL")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Initialize-Selenium"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Get-SeleniumElementByAttribute")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Open-SeleniumURL"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Get-SeleniumElementByXPath")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Open-SeleniumURL"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Send-SeleniumElementByAttribute")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Open-SeleniumURL"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Send-SeleniumElementByXPath")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Open-SeleniumURL"), $true)
	}

	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Send-ClickToSeleniumElementByAttribute")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Open-SeleniumURL"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Send-ClickToSeleniumElementByXPath")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Open-SeleniumURL"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Stop-Selenium")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Open-SeleniumURL"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Start-WebServer")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Stop-WebServer"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-WebServerContext"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-WebServerLocalPath"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-WebServerResponse"), $true)
	}
		
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Get-StringRemove")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-SubString"), $true)
	}
	
		#region These functions are needed for all projects
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-Types"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-EnableVisualStyle"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-DPIAware"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Show-Form"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Update-ErrorLog"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-CurrentDirectory"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("ConvertFrom-WinFormsXML"), $true)
	#endregion

	#region Microsoft.PowerShell.Utility
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Add-Member"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Add-Type"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Clear-Variable"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Compare-Object"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("ConvertFrom-Csv"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("ConvertFrom-Json"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("ConvertFrom-String"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("ConvertFrom-StringData"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Convert-String"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("ConvertTo-Csv"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("ConvertTo-Html"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("ConvertTo-Json"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("ConvertTo-Xml"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Debug-Runspace"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Disable-PSBreakpoint"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Disable-RunspaceDebug"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Enable-PSBreakpoint"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Enable-RunspaceDebug"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Export-Alias"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Export-Clixml"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Export-Csv"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Export-FormatData"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Export-PSSession"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Format-Custom"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Format-List"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Format-Table"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Format-Wide"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Alias"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Culture"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Date"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Event"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-EventSubscriber"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-FormatData"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Host"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Member"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-PSBreakpoint"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-PSCallStack"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Random"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Runspace"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-RunspaceDebug"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-TraceSource"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-TypeData"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-UICulture"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Unique"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Variable"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Group-Object"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Import-Alias"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Import-Clixml"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Import-Csv"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Import-LocalizedData"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Import-PSSession"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Invoke-Expression"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Invoke-RestMethod"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Invoke-WebRequest"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Measure-Command"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Measure-Object"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("New-Alias"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("New-Event"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("New-Object"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("New-TimeSpan"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("New-Variable"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Out-File"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Out-GridView"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Out-Printer"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Out-String"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Read-Host"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Register-EngineEvent"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Register-ObjectEvent"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Remove-Event"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Remove-PSBreakpoint"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Remove-TypeData"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Remove-Variable"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Select-Object"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Select-String"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Select-Xml"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Send-MailMessage"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-Alias"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-Date"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-PSBreakpoint"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-TraceSource"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-Variable"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Show-Command"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Sort-Object"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Start-Sleep"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Tee-Object"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Trace-Command"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Unblock-File"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Unregister-Event"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Update-FormatData"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Update-List"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Update-TypeData"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Wait-Debugger"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Wait-Event"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Write-Debug"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Write-Error"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Write-Host"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Write-Information"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Write-Output"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Write-Progress"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Write-Verbose"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Write-Warning"), $true)
	#end region
	#region Microsoft.PowerShell.Management 
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Add-Computer"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Add-Content"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Checkpoint-Computer"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Clear-Content"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Clear-EventLog"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Clear-Item"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Clear-ItemProperty"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Clear-RecycleBin"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Complete-Transaction"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Convert-Path"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Copy-Item"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Copy-ItemProperty"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Debug-Process"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Disable-ComputerRestore"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Enable-ComputerRestore"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-ChildItem"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Clipboard"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-ComputerInfo"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-ComputerRestorePoint"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Content"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-ControlPanelItem"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-EventLog"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-HotFix"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Item"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-ItemProperty"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-ItemPropertyValue"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Location"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Process"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-PSDrive"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-PSProvider"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Service"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-TimeZone"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-Transaction"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-WmiObject"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Invoke-Item"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Invoke-WmiMethod"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Join-Path"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Limit-EventLog"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Move-Item"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Move-ItemProperty"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("New-EventLog"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("New-Item"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("New-ItemProperty"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("New-PSDrive"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("New-Service"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("New-WebServiceProxy"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Pop-Location"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Push-Location"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Register-WmiEvent"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Remove-Computer"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Remove-EventLog"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Remove-Item"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Remove-ItemProperty"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Remove-PSDrive"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Remove-WmiObject"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Rename-Computer"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Rename-Item"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Rename-ItemProperty"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Reset-ComputerMachinePassword"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Resolve-Path"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Restart-Computer"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Restart-Service"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Restore-Computer"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Resume-Service"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-Clipboard"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-Content"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-Item"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-ItemProperty"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-Location"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-Service"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-TimeZone"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-WmiInstance"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Show-ControlPanelItem"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Show-EventLog"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Split-Path"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Start-Process"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Start-Service"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Start-Transaction"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Stop-Computer"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Stop-Process"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Stop-Service"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Suspend-Service"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Test-ComputerSecureChannel"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Test-Connection"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Test-Path"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Undo-Transaction"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Use-Transaction"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Wait-Process"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Write-EventLog"), $true)
	#end region
})