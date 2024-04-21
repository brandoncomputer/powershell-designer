function FunctionTimer{}
$functionTimer = (New-Timer -Interval 100)

$functionTimer.Add_Tick({
	#region These functions are needed for all projects
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-Types"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-EnableVisualStyle"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-DPIAware"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Show-Form"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Update-ErrorLog"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-CurrentDirectory"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("ConvertFrom-WinFormsXML"), $true)
	#endregion

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
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Intialize-ODBC"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Close-DataSourceName")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Intialize-ODBC"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Get-DataTables")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Intialize-ODBC"), $true)
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
})