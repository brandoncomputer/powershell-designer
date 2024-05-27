#region VDS
$RunSpace = [RunspaceFactory]::CreateRunspacePool(); $RunSpace.ApartmentState = "STA"; $RunSpace.Open(); $PowerShell = [powershell]::Create();$PowerShell.RunspacePool = $RunSpace; [void]$PowerShell.AddScript({

function Add-Tab() {
<#
    .SYNOPSIS
		Sends the tab key 

		ALIASES
			Tab
     
    .DESCRIPTION
		This function sends the tab key
		
	.EXAMPLE
		Send-Window (Get-Window notepad) Add-Tab
	
	.OUTPUTS
		String
		
	.NOTES
		Only useful with 'Send-Window'.
#>	
	[Alias("Tab")]
	param()
    return "`t" 
}

function ConvertFrom-WinFormsXML {
<#
    .SYNOPSIS
		Opens a form from XAML in the format specified by 'powershell-designer'
		or its predecessor, PowerShell WinForms Creator
			 
	.DESCRIPTION
		This function opens a form from XAML in the format specified by 'powershell-designer'
		or its predecessor, PowerShell WinForms Creator
	 
	.PARAMETER XML
		The XML object or XML string specifying the parameters for the form object
	
	.PARAMETER Reference
		This function recursively calls itself. Internal parameter for child 
		objects, not typically called programatically. Also this function is
		maintained for legacy compatibility PowerShell WinForm Creator, which 
		does require the call in some instances due to not creating automatic
		variables.
	
	.PARAMETER Supress
		This function recursively calls itself. Internal parameter for child 
		objects, not typically called programatically.
	
	.EXAMPLE
		ConvertFrom-WinFormsXML -Xml  @"
		<Form Name="MainForm" Size="800,600" Tag="VisualStyle,DPIAware" Text="MainForm">
			<Button Name="Button1" Location="176,94" Text="Button1" />
		</Form>
"@

	.EXAMPLE
		ConvertFrom-WinFormsXML @"
		<Form Name="MainForm" Size="800,600" Tag="VisualStyle,DPIAware" Text="MainForm">
			<Button Name="Button1" Location="176,94" Text="Button1" />
		</Form>
"@

	.EXAMPLE
	$content = [xml](get-content $Path)
	ConvertFrom-WinformsXML -xml $content.Data.Form.OuterXml
	
	.EXAMPLE
	$content = [xml](get-content $Path)
	ConvertFrom-WinformsXML $content.Data.Form.OuterXml

	.INPUTS
		Xml as String || Xml as xml
	
	.OUTPUTS
		Object
	
	.NOTES
		Each object created has a variable created to access the object 
		according to its Name attribute e.g. $Button1
#>
	param(
		[Parameter(Mandatory)]
		$Xml,
		[string]$Reference,
		$ParentControl,
		[switch]$Suppress
	)
	try {
		if ( $Xml.GetType().Name -eq 'String' ) {
			$Xml = ([xml]$Xml).ChildNodes
		}
		$Xml.Attributes | ForEach-Object {
			$attrib = $_
			$attribName = $_.ToString()
			$attrib = $_
			$attribName = $_.ToString()
			if ($attribName -eq 'Tag'){
				if (($attrib.Value | Out-String).Contains("VisualStyle")) {
					Set-EnableVisualStyle
				}
				if (($attrib.Value | Out-String).Contains("DPIAware")) {
					Set-DPIAware
				}					
			}
		}
		$Cskip = $false
		if ($attribName -eq 'ControlType') {
			$newControl = New-Object ($attrib.Value | Out-String)
			$Cskip = $true
		}
		switch ($Xml.ToString()){
		'SplitterPanel'{}
		'Form'{$newControl = [vdsForm] @{
             ClientSize = New-Object System.Drawing.Point 0,0}
			 $Cskip = $true
			 }
		'String'{$newControl = New-Object System.String
		$Cskip = $true}
		'WebView2'{$newControl = New-Object Microsoft.Web.WebView2.WinForms.WebView2
		$Cskip = $true}
		'FastColoredTextBox'{$newControl = New-Object FastColoredTextBoxNS.FastColoredTextBox
		$Cskip = $true}
		default{
			if ($Cskip -eq $false){
				$newControl = New-Object System.Windows.Forms.$($Xml.ToString())}}
		}
		if ( $ParentControl ) {
			if ( $Xml.ToString() -eq 'ToolStrip' ) {
				$newControl = New-Object System.Windows.Forms.MenuStrip
				$ParentControl.Controls.Add($newControl)
			}
			else {
				if ( $Xml.ToString() -match "^ToolStrip" ) {
					if ( $ParentControl.GetType().Name -match "^ToolStrip" ) {
						[void]$ParentControl.DropDownItems.Add($newControl)
					} 
					else {
						[void]$ParentControl.Items.Add($newControl)
					}
				} 
				elseif ( $Xml.ToString() -eq 'ContextMenuStrip' ) {
					$ParentControl.ContextMenuStrip = $newControl
				}
				elseif ( $Xml.ToString() -eq 'SplitterPanel' ) {
					$newControl = $ParentControl.$($Xml.Name.Split('_')[-1])
					}
				else {
					$ParentControl.Controls.Add($newControl)
				}
			}
		}

		$Xml.Attributes | ForEach-Object {
			$attrib = $_
			$attribName = $_.ToString()
			$attrib = $_
			$attribName = $_.ToString()
			if ($attribName -eq 'Opacity'){
				$n = $attrib.Value.split('%')
				$attrib.value = $n[0]/100
			}
			if ($attribName -eq 'ColumnWidth'){
				$attrib.Value = [math]::round(($attrib.Value / 1)  * $ctscale)
			}
			if ($attribName -eq 'Size'){				
				$n = $attrib.Value.split(',')
				$n[0] = [math]::round(($n[0]/1) * $ctscale)
				$n[1] = [math]::round(($n[1]/1) * $ctscale)
				if ("$($n[0]),$($n[1])" -ne ",") {
					$attrib.Value = "$($n[0]),$($n[1])"
				}
			}
			if ($attribName -eq 'Location'){
				$n = $attrib.Value.split(',')
				$n[0] = [math]::round(($n[0]/1) * $ctscale)
				$n[1] = [math]::round(($n[1]/1) * $ctscale)
				if ("$($n[0]),$($n[1])" -ne ",") {
					$attrib.Value = "$($n[0]),$($n[1])"
				}
			}
			if ($attribName -eq 'MaximumSize'){
				$n = $attrib.Value.split(',')
				$n[0] = [math]::round(($n[0]/1) * $ctscale)
				$n[1] = [math]::round(($n[1]/1) * $ctscale)
				if ("$($n[0]),$($n[1])" -ne ",") {
					$attrib.Value = "$($n[0]),$($n[1])"
				}
			}
			if ($attribName -eq 'MinimumSize'){
				$n = $attrib.Value.split(',')
				$n[0] = [math]::round(($n[0]/1) * $ctscale)
				$n[1] = [math]::round(($n[1]/1) * $ctscale)
				if ("$($n[0]),$($n[1])" -ne ",") {
					$attrib.Value = "$($n[0]),$($n[1])"
				}
			}
			if ($attribName -eq 'ImageScalingSize'){
				$n = $attrib.Value.split(',')
				$n[0] = [math]::round(($n[0]/1) * $ctscale)
				$n[1] = [math]::round(($n[1]/1) * $ctscale)
				if ("$($n[0]),$($n[1])" -ne ",") {
					$attrib.Value = "$($n[0]),$($n[1])"
				}
			}
			
			if ($attribName -eq 'TileSize'){
				$n = $attrib.Value.split(',')
				$n[0] = [math]::round(($n[0]/1) * $ctscale)
				$n[1] = [math]::round(($n[1]/1) * $ctscale)
				if ("$($n[0]),$($n[1])" -ne ",") {
					$attrib.Value = "$($n[0]),$($n[1])"
				}
			}

			if ( $Script:specialProps.Array -contains $attribName ) {
				if ( $attribName -eq 'Items' ) {
					$($_.Value -replace "\|\*BreakPT\*\|","`n").Split("`n") | ForEach-Object {
						[void]$newControl.Items.Add($_)
					}
				}
				else {
						# Other than Items only BoldedDate properties on MonthCalendar control
					$methodName = "Add$($attribName)" -replace "s$"
					$($_.Value -replace "\|\*BreakPT\*\|","`n").Split("`n") | ForEach-Object { 
						$newControl.$attribName.$methodName($_)
					}
				}
			} 
			else {
				switch ($attribName) {
					ControlType{}
					FlatAppearance {
						$attrib.Value.Split('|') | ForEach-Object {
							$newControl.FlatAppearance.$($_.Split('=')[0]) = $_.Split('=')[1]
						}
					}
					default {
						if ( $null -ne $newControl.$attribName ) {
							if ( $newControl.$attribName.GetType().Name -eq 'Boolean' ) {
								if ( $attrib.Value -eq 'True' ) {
									$value = $true
								} 
								else {
									$value = $false
								}
							} 
							else {
								$value = $attrib.Value
							}
						} 
						else {
							$value = $attrib.Value
						}
						switch ($xml.ToString()) {
							"FolderBrowserDialog" {
								if ($xml.Description) {
									$newControl.Description = $xml.Description
								}
								if ($xml.Tag) {
									$newControl.Tag = $xml.Tag
								}
								if ($xml.RootFolder) {
									$newControl.RootFolder = $xml.RootFolder
								}
								if ($xml.SelectedPath) {
									$newControl.SelectedPath = $xml.SelectedPath
								}
								if ($xml.ShowNewFolderButton) {
									$newControl.ShowNewFolderButton = $xml.ShowNewFolderButton
								}
							}
							"OpenFileDialog" {
								if ($xml.AddExtension) {
										$newControl.AddExtension = $xml.AddExtension
								}
								if ($xml.AutoUpgradeEnabled) {
									$newControl.AutoUpgradeEnabled = $xml.AutoUpgradeEnabled
								}
								if ($xml.CheckFileExists) {
									$newControl.CheckFileExists = $xml.CheckFileExists
								}
								if ($xml.CheckPathExists) {
									$newControl.CheckPathExists = $xml.CheckPathExists
								}
								if ($xml.DefaultExt) {
									$newControl.DefaultExt = $xml.DefaultExt
								}
								if ($xml.DereferenceLinks) {
									$newControl.DereferenceLinks = $xml.DereferenceLinks
								}
								if ($xml.FileName) {
									$newControl.FileName = $xml.FileName
								}
								if ($xml.Filter) {
									$newControl.Filter = $xml.Filter
								}
								if ($xml.FilterIndex) {
									$newControl.FilterIndex = $xml.FilterIndex
								}
								if ($xml.InitialDirectory) {
									$newControl.InitialDirectory = $xml.InitialDirectory
								}
								if ($xml.Multiselect) {
									$newControl.Multiselect = $xml.Multiselect
								}
								if ($xml.ReadOnlyChecked) {
									$newControl.ReadOnlyChecked = $xml.ReadOnlyChecked
								}
								if ($xml.RestoreDirectory) {
									$newControl.RestoreDirectory = $xml.RestoreDirectory
								}
								if ($xml.ShowHelp) {
									$newControl.ShowHelp = $xml.ShowHelp
								}
								if ($xml.ShowReadOnly) {
									$newControl.ShowReadOnly = $xml.ShowReadOnly
								}
								if ($xml.SupportMultiDottedExtensions) {
									$newControl.SupportMultiDottedExtensions = $xml.SupportMultiDottedExtensions
								}
								if ($xml.Tag) {
									$newControl.Tag = $xml.Tag
								}
								if ($xml.Title) {
									$newControl.Title = $xml.Title
								}
								if ($xml.ValidateNames) {
									$newControl.ValidateNames = $xml.ValidateNames
								}
							}
							"ColorDialog" {
								if ($xml.AllowFullOpen) {
									$newControl.AllowFullOpen = $xml.AllowFullOpen
								}
								if ($xml.AnyColor) {
									$newControl.AnyColor = $xml.AnyColor
								}
								if ($xml.Color) {
									$newControl.Color = $xml.Color
								}
								if ($xml.FullOpen) {
									$newControl.FullOpen = $xml.FullOpen
								}
								if ($xml.ShowHelp) {
									$newControl.ShowHelp = $xml.ShowHelp
								}
								if ($xml.SolidColorOnly) {
									$newControl.SolidColorOnly = $xml.SolidColorOnly
								}
								if ($xml.Tag) {
									$newControl.Tag = $xml.Tag
								}								
							}
							"FontDialog" {
								if ($xml.AllowScriptChange) {
									$newControl.AllowScriptChange = $xml.AllowScriptChange
								}
								if ($xml.AllowSimulations) {
									$newControl.AllowSimulations = $xml.AllowSimulations
								}
								if ($xml.AllowVectorFonts) {
									$newControl.AllowVectorFonts = $xml.AllowVectorFonts
								}
								if ($xml.Color) {
									$newControl.Color = $xml.Color
								}
								if ($xml.FixedPitchOnly) {
									$newControl.FixedPitchOnly = $xml.FixedPitchOnly
								}
								if ($xml.Font) {
									$newControl.Font = $xml.Font
								}
								if ($xml.FontMustExists) {
									$newControl.FontMustExists = $xml.FontMustExists
								}		
								if ($xml.MaxSize) {
									$newControl.MaxSize = $xml.MaxSize
								}
								if ($xml.MinSize) {
									$newControl.MinSize = $xml.MinSize
								}
								if ($xml.ScriptsOnly) {
									$newControl.ScriptsOnly = $xml.ScriptsOnly
								}
								if ($xml.ShowApply) {
									$newControl.ShowApply = $xml.ShowApply
								}
								if ($xml.ShowColor) {
									$newControl.ShowColor = $xml.ShowColor
								}
								if ($xml.ShowEffects) {
									$newControl.ShowEffects = $xml.ShowEffects
								}
								if ($xml.ShowHelp) {
									$newControl.ShowHelp = $xml.ShowHelp
								}
								if ($xml.Tag) {
									$newControl.Tag = $xml.Tag
								}											
							}
							"PageSetupDialog" {
								if ($xml.AllowMargins) {
									$newControl.AllowMargins = $xml.AllowMargins
								}
								if ($xml.AllowOrientation) {
									$newControl.AllowOrientation = $xml.AllowOrientation
								}
								if ($xml.AllowPaper) {
									$newControl.AllowPaper = $xml.AllowPaper
								}
								if ($xml.Document) {
									$newControl.Document = $xml.Document
								}
								if ($xml.EnableMetric) {
									$newControl.EnableMetric = $xml.EnableMetric
								}
								if ($xml.MinMargins) {
									$newControl.MinMargins = $xml.MinMargins
								}
								if ($xml.ShowHelp) {
									$newControl.ShowHelp = $xml.ShowHelp
								}		
								if ($xml.ShowNetwork) {
									$newControl.ShowNetwork = $xml.ShowNetwork
								}
								if ($xml.Tag) {
									$newControl.Tag = $xml.Tag
								}								
							}
							"PrintDialog" {
								if ($xml.AllowCurrentPage) {
									$newControl.AllowCurrentPage = $xml.AllowCurrentPage
								}
								if ($xml.AllowPrintToFile) {
									$newControl.AllowPrintToFile = $xml.AllowPrintToFile
								}
								if ($xml.AllowSelection) {
									$newControl.AllowSelection = $xml.AllowSelection
								}
								if ($xml.AllowSomePages) {
									$newControl.AllowSomePages = $xml.AllowSomePages
								}
								if ($xml.Document) {
									$newControl.Document = $xml.Document
								}
								if ($xml.PrintToFile) {
									$newControl.PrintToFile = $xml.PrintToFile
								}
								if ($xml.ShowHelp) {
									$newControl.ShowHelp = $xml.ShowHelp
								}		
								if ($xml.ShowNetwork) {
									$newControl.ShowNetwork = $xml.ShowNetwork
								}
								if ($xml.Tag) {
									$newControl.Tag = $xml.Tag
								}
								if ($xml.UseEXDialog) {
									$newControl.UseEXDialog = $xml.UseEXDialog
								}
							}
							"PrintPreviewDialog" {
								if ($xml.AutoSizeMode) {
									$newControl.AutoSizeMode = $xml.AutoSizeMode
								}
								if ($xml.Document) {
									$newControl.Document = $xml.Document
								}
								if ($xml.MainMenuStrip) {
									$newControl.MainMenuStrip = $xml.MainMenuStrip
								}
								if ($xml.ShowIcon) {
									$newControl.ShowIcon = $xml.ShowIcon
								}
								if ($xml.UseAntiAlias) {
									$newControl.UseAntiAlias = $xml.UseAntiAlias
								}
							}
							"SaveFileDialog" {
								if ($xml.AddExtension) {
									$newControl.AddExtension = $xml.AddExtension
								}
								if ($xml.AutoUpgradeEnabled) {
									$newControl.AutoUpgradeEnabled = $xml.AutoUpgradeEnabled
								}
								if ($xml.CheckFileExists) {
									$newControl.CheckFileExists = $xml.CheckFileExists
								}
								if ($xml.CheckPathExists) {
									$newControl.CheckPathExists = $xml.CheckPathExists
								}
								if ($xml.CreatePrompt) {
									$newControl.CreatePrompt = $xml.CreatePrompt
								}
								if ($xml.DefaultExt) {
									$newControl.DefaultExt = $xml.DefaultExt
								}
								if ($xml.DereferenceLinks) {
									$newControl.DereferenceLinks = $xml.DereferenceLinks
								}
								if ($xml.FileName) {
									$newControl.FileName = $xml.FileName
								}
								if ($xml.Filter) {
									$newControl.Filter = $xml.Filter
								}
								if ($xml.FilterIndex) {
									$newControl.FilterIndex = $xml.FilterIndex
								}
								if ($xml.InitialDirectory) {
									$newControl.InitialDirectory = $xml.InitialDirectory
								}
								if ($xml.Multiselect) {
									$newControl.OverwritePrompt = $xml.OverwritePrompt
								}
								if ($xml.RestoreDirectory) {
									$newControl.RestoreDirectory = $xml.RestoreDirectory
								}
								if ($xml.ShowHelp) {
									$newControl.ShowHelp = $xml.ShowHelp
								}
								if ($xml.SupportMultiDottedExtensions) {
									$newControl.SupportMultiDottedExtensions = $xml.SupportMultiDottedExtensions
								}
								if ($xml.Tag) {
									$newControl.Tag = $xml.Tag
								}
								if ($xml.Title) {
									$newControl.Title = $xml.Title
								}
								if ($xml.ValidateNames) {
									$newControl.ValidateNames = $xml.ValidateNames
								}
							}
							"Timer" {
								if ($xml.Enabled) {
									$newControl.Enabled = $xml.Enabled
								}
								if ($xml.Interval) {
									$newControl.Interval = $xml.Interval
								}
								if ($xml.Tag) {
									$newControl.Tag = $xml.Tag
								}
							}
							default {
								$newControl.$attribName = $value
							}
						}
					}
				}
			}
			if ($xml.Name){ 			
				if ((Test-Path variable:global:"$($xml.Name)") -eq $False) {
					New-Variable -Name $xml.Name -Scope global -Value $newControl | Out-Null
				}
			}
			if (( $attrib.ToString() -eq 'Name' ) -and ( $Reference -ne '' )) {
				try {
					$refHashTable = Get-Variable -Name $Reference -Scope global -ErrorAction Stop
				}
				catch {
					New-Variable -Name $Reference -Scope global -Value @{} | Out-Null
					$refHashTable = Get-Variable -Name $Reference -Scope global -ErrorAction SilentlyContinue
				}
				$refHashTable.Value.Add($attrib.Value,$newControl)
			}
		}
		if ( $Xml.ChildNodes ) {
			$Xml.ChildNodes | ForEach-Object {ConvertFrom-WinformsXML -Xml $_ -ParentControl $newControl -Reference $Reference -Suppress}
		}
		if ( $Suppress -eq $false ) {
			return $newControl
		}
	} 
	catch {
		Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered adding $($Xml.ToString()) to $($ParentControl.Name)"
	}
}

function Get-ActiveWindow {
<#
    .SYNOPSIS
		Returns the handle of the active window

		ALIASES
			Winactive
			 
	.DESCRIPTION
		This function returns the handle of the active window

	.EXAMPLE
		$winactive = Get-ActiveWindow
	
	.OUTPUTS
		Handle
#>
	[Alias("Winactive")]
	param()
	return [vds]::GetForegroundWindow()
}

function Get-Answer {
<#
	.SYNOPSIS
		Opens a dialog window to ask the user a yes or no question.

		ALIASES
			Ask
     
    .DESCRIPTION
		This function will call upon Windows Forms to display a Information
		dialog asking the user a Yes or No quesiton.
	
	.PARAMETER QuestionText
		The question to ask the end user.
		
	.PARAMETER TitleText
	
	.EXAMPLE
		Get-Answer "Are the birds singing?"
	
	.EXAMPLE
		Get-Answer "Are the birds singing?" "About the birds" 
	
	.EXAMPLE
		Get-Answer -TitleText "About the birds" -QuestionText "Are the birds singing?"
	
	.EXAMPLE
		"Are the birds singing?" | Get-Answer
	
	.INPUTS
		QuestionText as String, TitleText as String
	
	.OUTPUTS
		Yes or No as String
#>
	[Alias("Ask")]
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$QuestionText,
		[string]$TitleText
	)
    $GetAnswer = [System.Windows.Forms.MessageBox]::Show($QuestionText,$TitleText,'YesNo','Info')
    return $GetAnswer
}

function Get-CurrentDirectory {
<#
	.SYNOPSIS
		Returns the current directory as string

		ALIASES
			Curdir
		     
    .DESCRIPTION
		This function returns the current directory of the application as string.
		
	.EXAMPLE
		Write-Host Get-CurrentDirectory
	
	.OUTPUTS
		String
#>
	[Alias("Curdir")]
	param()
    return (Get-Location | Select-Object -expandproperty Path | Out-String).Trim()
}

function Get-MousePosition {
<#
    .SYNOPSIS
		Returns the X and Y of the mouse position.

		ALIASES
			Mousepos
			 
	.DESCRIPTION
		This function returns the X and Y of the mouse position.

	.EXAMPLE
		$mouseX = (Get-MousePosition).X
	
	.EXAMPLE
		$mouseY = (Get-MousePosition).Y
	
	.OUTPUTS
		PSCustomObject
#>
	[Alias("Mousepos")]
	param()
	$return = [PSCustomObject] | Select-Object -Property X, Y
	$return.X = [System.Windows.Forms.Cursor]::Position.X
	$return.Y = [System.Windows.Forms.Cursor]::Position.Y
	return $return
}

function Get-WindowClass {
<#
    .SYNOPSIS
		Gets the class of a window by handle

		ALIASES
			Winclass
			 
	.DESCRIPTION
		This function gets the class of a window by handle

	.PARAMETER Handle
		The handle of the window

	.EXAMPLE
		$class = Get-WindowClass (Get-WindowExists "Untitled - Notepad")

	.EXAMPLE
		$class = Get-WindowClass -handle (Get-WindowExists "Untitled - Notepad")
		
	.EXAMPLE
		$class = (Get-WindowExists "Untitled - Notepad") | Get-WindowClass
		
	.INPUTS
		Handle as Handle
	
	.OUTPUTS
		String
#>
	[Alias("winclass")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
    $stringbuilt = New-Object System.Text.StringBuilder 256
    $that = [vds]::GetClassName($Handle, $stringbuilt, 256)
    return $($stringbuilt.ToString())
}

function Get-WindowFromPoint {
<#
    .SYNOPSIS
		Returns the window panel from an x y point

		ALIASES
			Winatpoint
			 
	.DESCRIPTION
		This function returns the window panel from an x y point

	.PARAMETER x
		The x point
	 
	.PARAMETER y
		The y point

	.EXAMPLE
		$xyWindow = Get-WindowFromPoint 980 540

	.EXAMPLE
		$xyWindow = Get-WindowFromPoint -x 980 -y 540
		
	.INPUTS
		x as Integer, y as Integer
		
	.OUTPUTS
		Handle
#>
	[Alias("Winatpoint")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]$x,
        [Parameter(Mandatory)]
		[int]$y
	)
    $p = new-object system.drawing.point($x,$y)
    $return = [vds]::WindowFromPoint($p)
    return $return
}

function Get-WindowParent {
<#
    .SYNOPSIS
		Returns the handle of a windows parent
		
		ALIASES
			Winparent
			 
	.DESCRIPTION
		This function returns the handle of a windows parent

	.PARAMETER Handle
		The handle of the child window

	.EXAMPLE
		$winexists = Get-WindowParent (Get-ChildWindow "Libraries")

	.EXAMPLE
		$winexists = Get-WindowParent -handle (Get-ChildWindow "Libraries")
		
	.EXAMPLE
		$winexists = (Get-ChildWindow "Libraries") | Get-WindowParent
		
	.INPUTS
		Handle as Integer
	
	.OUTPUTS
		Integer
#>
	[Alias("Winparent")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
	return [vds]::GetParent($Handle)
}

function Get-WindowPosition {
<#
    .SYNOPSIS
		Returns an object with Left, Top, Width and Height properties of a windows position

		ALIASES
			Winpos
			 
	.DESCRIPTION
		This function returns an object with Left, Top, Width and Height properties of a windows position according to a handle specified

	.PARAMETER Handle
		The handle of the window to return the postion of

	.EXAMPLE
		$winpos = Get-WindowPosition (Get-WindowExists "Untitled - Notepad")

	.EXAMPLE
		$winpos = Get-WindowPosition -handle (Get-WindowExists "Untitled - Notepad")
		
	.EXAMPLE
		$winexists = (Get-ChildWindow "Libraries") | Get-WindowParent
		
	.INPUTS
		Handle as Integer
	
	.OUTPUTS
		Integer
#>
	[Alias("Winpos")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
	$return = [PSCustomObject] | Select-Object -Property Top, Left, Width, Height
    $Rect = New-Object RECT
    [vds]::GetWindowRect($Handle,[ref]$Rect) | Out-Null
	$return.Top = $Rect.Top
	$return.Left = $Rect.Left
	$return.Width = $Rect.Right - $Rect.Left
	$return.Height = $Rect.Bottom - $Rect.Top
	return $return
}

function Get-WindowText {
<#
    .SYNOPSIS
		Returns the text of a window
		
		ALIASES
			Wintext
			 
	.DESCRIPTION
		This function returns the text of a window
		
	.PARAMETER Handle
		The handle of the window to return the sibling of

	.EXAMPLE
		$wintext = Get-WindowText (Get-WindowExists "notepad")

	.EXAMPLE
		$wintext = Get-WindowText -handle (Get-WindowExists "notepad")
		
	.EXAMPLE
		$wintext = (Get-WindowExists "notepad") | Get-WindowText
		
	.INPUTS
		Handle as Integer
	
	.OUTPUTS
		Integer
#>
	[Alias("Wintext")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
    $strbld = [vds]::GetWindowTextLength($Handle)
    $stringbuilt = New-Object System.Text.StringBuilder $strbld+1
    $that = [vds]::GetWindowText($Handle, $stringbuilt, $strbld+1)
    return $($stringbuilt.ToString())
}

function Set-DPIAware {
<#
    .SYNOPSIS
		Causes the dialog window to be DPI Aware.
	.DESCRIPTION
		This function will call upon the windows application programming
		interface to cause the window to be DPI Aware.
	.EXAMPLE
		Set-DPIAware
#>
	$vscreen = [System.Windows.Forms.SystemInformation]::VirtualScreen.height
	[vds]::SetProcessDPIAware() | out-null
	$screen = [System.Windows.Forms.SystemInformation]::VirtualScreen.height
	$global:ctscale = ($screen/$vscreen)
}

function Set-EnableVisualStyle {
<#
    .SYNOPSIS
		Enables modern visual styles in the dialog window.
	.DESCRIPTION
		This function will call upon the windows application programming
		interface to apply modern visual style to the window.
	.EXAMPLE
		Set-EnableVisualStyle
#>
	[vds]::SetCompat() | out-null
}

function Set-Types {
	
<#
    .SYNOPSIS
		Various C# calls and references
#>
Add-Type -AssemblyName System.Windows.Forms,presentationframework, presentationcore, Microsoft.VisualBasic

Add-Type @"
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.ComponentModel;
using System.Collections.Generic;

public class vds {
	
		public static void SetCompat() 
		{
			//	SetProcessDPIAware();
	            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
		}
			
	    [System.Runtime.InteropServices.DllImport("user32.dll")]
        public static extern bool SetProcessDPIAware();
	
[DllImport("user32.dll")]
public static extern bool InvertRect(IntPtr hDC, [In] ref RECT lprc);

[DllImport("user32.dll")]
public static extern IntPtr GetDC(IntPtr hWnd);

[DllImport("user32.dll")]
public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);

[DllImport("user32.dll")]
public static extern IntPtr WindowFromPoint(System.Drawing.Point p);
// Now working in pwsh 7 thanks to advice from seeminglyscience#2404 on Discord
[DllImport("user32.dll")]
public static extern IntPtr GetParent(IntPtr hWnd);
[DllImport("user32.dll")]
public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);
[DllImport("user32.dll")]
public static extern bool ShowWindow(int hWnd, WindowState nCmdShow);
public enum WindowState
    {
        SW_HIDE               = 0,
        SW_SHOW_NORMAL        = 1,
        SW_SHOW_MINIMIZED     = 2,
        SW_MAXIMIZE           = 3,
        SW_SHOW_MAXIMIZED     = 3,
        SW_SHOW_NO_ACTIVE     = 4,
        SW_SHOW               = 5,
        SW_MINIMIZE           = 6,
        SW_SHOW_MIN_NO_ACTIVE = 7,
        SW_SHOW_NA            = 8,
        SW_RESTORE            = 9,
        SW_SHOW_DEFAULT       = 10,
        SW_FORCE_MINIMIZE     = 11
    }
	
[DllImport("user32.dll")]
private static extern bool SetCursorPos(int x, int y);
    
[DllImport("User32.dll")]
public static extern bool MoveWindow(int hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
[DllImport("User32.dll")]
public static extern bool GetWindowRect(int hWnd, out RECT lpRect);

      
[DllImport("user32.dll", EntryPoint="FindWindow")]
internal static extern int FWBC(string lpClassName, int ZeroOnly);
public static int FindWindowByClass(string lpClassName) {
return FWBC(lpClassName, 0);}

[DllImport("user32.dll", EntryPoint="FindWindow")]
internal static extern int FWBT(int ZeroOnly, string lpTitle);
public static int FindWindowByTitle(string lpTitle) {
return FWBT(0, lpTitle);}

[DllImport("user32.dll")]
public static extern IntPtr GetForegroundWindow();

[DllImport("user32.dll")]
public static extern IntPtr GetWindow(int hWnd, uint uCmd);

[DllImport("user32.dll")]    
     public static extern int GetWindowTextLength(int hWnd);
     
[DllImport("user32.dll")]
public static extern IntPtr GetWindowText(IntPtr hWnd, System.Text.StringBuilder text, int count);

[DllImport("user32.dll")]
public static extern IntPtr GetClassName(IntPtr hWnd, System.Text.StringBuilder text, int count);
     
[DllImport("user32.dll")]
    public static extern bool SetWindowPos(int hWnd, int hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
    
[DllImport ("user32.dll")]
public static extern bool SetParent(int ChWnd, int hWnd);

[DllImport("user32.dll")]
public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);
    
[DllImport("User32.dll")]
public static extern bool SetWindowText(IntPtr hWnd, string lpString);


//CC-BY-SA
//Adapted from script by StephenP
//https://stackoverflow.com/users/3594883/stephenp
[DllImport("User32.dll")]
extern static uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

public struct INPUT
    { 
        public int        type; // 0 = INPUT_MOUSE,
                                // 1 = INPUT_KEYBOARD
                                // 2 = INPUT_HARDWARE
        public MOUSEINPUT mi;
    }

public struct MOUSEINPUT
    {
        public int    dx ;
        public int    dy ;
        public int    mouseData ;
        public int    dwFlags;
        public int    time;
        public IntPtr dwExtraInfo;
    }
    
const int MOUSEEVENTF_MOVED      = 0x0001 ;
const int MOUSEEVENTF_LEFTDOWN   = 0x0002 ;
const int MOUSEEVENTF_LEFTUP     = 0x0004 ;
const int MOUSEEVENTF_RIGHTDOWN  = 0x0008 ;
const int MOUSEEVENTF_RIGHTUP    = 0x0010 ;
const int MOUSEEVENTF_MIDDLEDOWN = 0x0020 ;
const int MOUSEEVENTF_MIDDLEUP   = 0x0040 ;
const int MOUSEEVENTF_WHEEL      = 0x0080 ;
const int MOUSEEVENTF_XDOWN      = 0x0100 ;
const int MOUSEEVENTF_XUP        = 0x0200 ;
const int MOUSEEVENTF_ABSOLUTE   = 0x8000 ;

const int screen_length = 0x10000 ;

public static void LeftClickAtPoint(int x, int y, int width, int height)
{
    //Move the mouse
    INPUT[] input = new INPUT[3];
    input[0].mi.dx = x*(65535/width);
    input[0].mi.dy = y*(65535/height);
    input[0].mi.dwFlags = MOUSEEVENTF_MOVED | MOUSEEVENTF_ABSOLUTE;
    //Left mouse button down
    input[1].mi.dwFlags = MOUSEEVENTF_LEFTDOWN;
    //Left mouse button up
    input[2].mi.dwFlags = MOUSEEVENTF_LEFTUP;
    SendInput(3, input, Marshal.SizeOf(input[0]));
}

public static void RightClickAtPoint(int x, int y, int width, int height)
{
    //Move the mouse
    INPUT[] input = new INPUT[3];
    input[0].mi.dx = x*(65535/width);
    input[0].mi.dy = y*(65535/height);
    input[0].mi.dwFlags = MOUSEEVENTF_MOVED | MOUSEEVENTF_ABSOLUTE;
    //Left mouse button down
    input[1].mi.dwFlags = MOUSEEVENTF_RIGHTDOWN;
    //Left mouse button up
    input[2].mi.dwFlags = MOUSEEVENTF_RIGHTUP;
    SendInput(3, input, Marshal.SizeOf(input[0]));
}
//End CC-SA
[DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hwnd);


}

 public struct RECT

    {
    public int Left;
    public int Top; 
    public int Right;
    public int Bottom;
    }
"@ -ReferencedAssemblies System.Windows.Forms, System.Drawing, System.Drawing.Primitives

if ((get-host).version.major -eq 7) {
	if ((get-host).version.minor -eq 0) {
Add-Type @"
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.ComponentModel;
public class vdsForm:Form {
[DllImport("user32.dll")]
public static extern bool RegisterHotKey(IntPtr hWnd, int id, int fsModifiers, int vk);
[DllImport("user32.dll")]
public static extern bool UnregisterHotKey(IntPtr hWnd, int id);
    protected override void WndProc(ref Message m) {
        base.WndProc(ref m);
        if (m.Msg == 0x0312) {
            int id = m.WParam.ToInt32();    
            foreach (Control item in this.Controls) {
                if (item.Name == "hotkey") {
                    item.Text = id.ToString();
                }
            }
        }
    }   
}
"@ -ReferencedAssemblies System.Windows.Forms,System.Drawing,System.Drawing.Primitives,System.Net.Primitives,System.ComponentModel.Primitives,Microsoft.Win32.Primitives
	}
	else{
Add-Type @"
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.ComponentModel;
public class vdsForm:Form {
[DllImport("user32.dll")]
public static extern bool RegisterHotKey(IntPtr hWnd, int id, int fsModifiers, int vk);
[DllImport("user32.dll")]
public static extern bool UnregisterHotKey(IntPtr hWnd, int id);
    protected override void WndProc(ref Message m) {
        base.WndProc(ref m);
        if (m.Msg == 0x0312) {
            int id = m.WParam.ToInt32();    
            foreach (Control item in this.Controls) {
                if (item.Name == "hotkey") {
                    item.Text = id.ToString();
                }
            }
        }
    }   
}
"@ -ReferencedAssemblies System.Windows.Forms,System.Drawing,System.Drawing.Primitives,System.Net.Primitives,System.ComponentModel.Primitives,Microsoft.Win32.Primitives,System.Windows.Forms.Primitives	
	}
}
else {
Add-Type @"
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.ComponentModel;
public class vdsForm:Form {
[DllImport("user32.dll")]
public static extern bool RegisterHotKey(IntPtr hWnd, int id, int fsModifiers, int vk);
[DllImport("user32.dll")]
public static extern bool UnregisterHotKey(IntPtr hWnd, int id);
    protected override void WndProc(ref Message m) {
        base.WndProc(ref m);
        if (m.Msg == 0x0312) {
            int id = m.WParam.ToInt32();    
            foreach (Control item in this.Controls) {
                if (item.Name == "hotkey") {
                    item.Text = id.ToString();
                }
            }
        }
    }   
}
"@ -ReferencedAssemblies System.Windows.Forms,System.Drawing
}

<#      
        Function: FlashWindow
        Author: Boe Prox
        https://social.technet.microsoft.com/profile/boe%20prox/
        Adapted to VDS: 20190212
        License: Microsoft Limited Public License
#>

Add-Type -TypeDefinition @"
//"
using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;

public class Window
{
    [StructLayout(LayoutKind.Sequential)]
    public struct FLASHWINFO
    {
        public UInt32 cbSize;
        public IntPtr hwnd;
        public UInt32 dwFlags;
        public UInt32 uCount;
        public UInt32 dwTimeout;
    }

    //Stop flashing. The system restores the window to its original state. 
    const UInt32 FLASHW_STOP = 0;
    //Flash the window caption. 
    const UInt32 FLASHW_CAPTION = 1;
    //Flash the taskbar button. 
    const UInt32 FLASHW_TRAY = 2;
    //Flash both the window caption and taskbar button.
    //This is equivalent to setting the FLASHW_CAPTION | FLASHW_TRAY flags. 
    const UInt32 FLASHW_ALL = 3;
    //Flash continuously, until the FLASHW_STOP flag is set. 
    const UInt32 FLASHW_TIMER = 4;
    //Flash continuously until the window comes to the foreground. 
    const UInt32 FLASHW_TIMERNOFG = 12; 


    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    static extern bool FlashWindowEx(ref FLASHWINFO pwfi);

    public static bool FlashWindow(IntPtr handle, UInt32 timeout, UInt32 count)
    {
        IntPtr hWnd = handle;
        FLASHWINFO fInfo = new FLASHWINFO();

        fInfo.cbSize = Convert.ToUInt32(Marshal.SizeOf(fInfo));
        fInfo.hwnd = hWnd;
        fInfo.dwFlags = FLASHW_ALL | FLASHW_TIMERNOFG;
        fInfo.uCount = count;
        fInfo.dwTimeout = timeout;

        return FlashWindowEx(ref fInfo);
    }
}
"@
$global:ctscale = 1
}
Set-Types

function Set-WindowOnTop {
<#
    .SYNOPSIS
		Causes a window to be on top of other windows
		
		ALIAS
			Window-Ontop
			 
	.DESCRIPTION
		This function causes a window to be on top of other windows

	.PARAMETER Handle
		The handle of the window

	.EXAMPLE
		Set-WindowOnTop (Get-WindowExists "Untitled - Notepad")

	.EXAMPLE
		Set-WindowOnTop -handle (Get-WindowExists "Untitled - Notepad")
		
	.EXAMPLE
		(Get-WindowExists "Untitled - Notepad") | Set-WindowOnTop
		
	.INPUTS
		Handle as Handle
#>
	[Alias("Window-OnTop")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
	[vds]::SetWindowPos($Handle, -1, (Get-WindowPosition $Handle).Left, (Get-WindowPosition $Handle).Top, (Get-WindowPosition $Handle).Width, (Get-WindowPosition $Handle).Height, 0x0040) | out-null
}

function Show-InformationDialog {
<#
    .SYNOPSIS
		Displays a information dialog with a message and title specified.
		
		ALIAS
			Info
			 
	.DESCRIPTION
		This function displays a information dialog with a message and title specified.
	 
	.PARAMETER Message
		The message to display

	.PARAMETER Title
		The title to display
		
	.EXAMPLE
		Show-InformationDialog "Message"

	.EXAMPLE
		Show-InformationDialog -message "Message" -title "Title"
		
	.EXAMPLE
		"Message" | Show-InformationDialog -title "Title"
	
	.INPUTS
		Message as String, Title as String
	
	.OUTPUTS
		MessageBox
#>
	[Alias("Info")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Message,
		[string]$Title
	)
	[System.Windows.Forms.MessageBox]::Show($Message,$Title,'OK',64) | Out-Null
}

function Update-ErrorLog {
<#
    .SYNOPSIS
		Logs errors to the text file 'exceptions.txt' for use in the catch 
		statement of a try catch.
			 
	.DESCRIPTION
		This function logs errors to the text file 'exceptions.txt' residing in
		the current directory in use by powershell, for use in the catch 
		statement of a try catch.
	 
	.PARAMETER ErrorRecord
		The object from the pipeline represented by $_ or $PSItem
	
	.PARAMETER Message
		The message to display to the end user.
		
	.PARAMETER Promote
		Switch that defines to also call a throw of the ValueFromPipeline
		
	.EXAMPLE
		Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered adding $($Xml.ToString()) to $($ParentControl.Name)"
		
	.EXAMPLE
		Update-ErrorLog -Promote -ErrorRecord $_ -Message "Exception encountered adding $($Xml.ToString()) to $($ParentControl.Name)"

	.INPUTS
		ErrorRecord as ValueFromPipeline, Message as String, Promote as Switch
	
	.Outputs
		String || String, Throw method of ValueFromPipeline
#>
	param(
		[System.Management.Automation.ErrorRecord]$ErrorRecord,
		[string]$Message,
		[switch]$Promote
	)

	if ( $Message -ne '' ) {
		[void][System.Windows.Forms.MessageBox]::Show("$($Message)`r`n`r`nCheck '$(get-currentdirectory)\exceptions.txt' for details.",'Exception Occurred')
	}
	$date = Get-Date -Format 'yyyyMMdd HH:mm:ss'
	$ErrorRecord | Out-File "$(get-currentdirectory)\tmpError.txt"
	Add-Content -Path "$(get-currentdirectory)\exceptions.txt" -Value "$($date): $($(Get-Content "$(get-currentdirectory)\tmpError.txt") -replace "\s+"," ")"
	Remove-Item -Path "$(get-currentdirectory)\tmpError.txt"
	if ( $Promote ) {
		throw $ErrorRecord
	}
}


ConvertFrom-WinFormsXML -Reference refs -Suppress -Xml @"
<Form Name="MainForm" Size="600,480" Tag="VisualStyle,DPIAware" Text="Window Spy"><Button Name="Button" Location="15,400" Size="275,30" Text="Capture" /><TextBox Name="Label1" Font="Segoe UI, 8.25pt, style=Bold" Location="15,15" Multiline="True" Size="550,380" /><Button Name="Button2" Location="290,400" Size="275,30" Text="Countdown Capture" /></Form>
"@
#endregion VDS
#region Images
$MainForm.Icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap][System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wAUXZUDEFqSGv///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wAiZp4GG2KarSJnnf8RW5OH////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wAycqoGK22lrVWNvP+Jtd3/GF+X/////wD///8A////AP///wD///8A////AP///wD///8A////AP///wBEf7cGPHmxrWSXxf+dweT/ZpnH/x9lnev///8A////AP///wD///8A3bKPAtmuipfWqYXj06V//dCge/3NnHbkopOK3nWizP+ry+j/dqTO/zBwqOsoa6Mn////AP///wD///8A5L2bAuG4lsDoya7/9eHN//fl0//35dH/893I/9+6nP/HqJH/hq7V/0F9tes5d68n////AP///wD///8A////AOjDopft0Lf/+OjZ//XeyP/z2L3/89a7//Tbwv/35NL/37ud/52UkvdLhLwn////AP///wD///8A////AP///wDsyKjj9+fX//bhzP/028L/9NrA//PYvf/z17v/9NvC//Peyf/Nn3vn////AP///wD///8A////AP///wD///8A8M6u/fns3//138j/9d3G//Tcw//02sH/89m+//PXvf/45tP/06V//f///wD///8A////AP///wD///8A////APTTtP357eH/9uHM//Xfyf/13sf/9NzE//Tbwv/02sD/+OfW/9eqhv3///8A////AP///wD///8A////AP///wD317nj+eve//fn1v/24cz/9eDK//XeyP/13cX/9uHL//Xi0P/bsIzj////AP///wD///8A////AP///wD///8A+tu9l/jizP/67uP/9+fW//bizv/24cv/9uPQ//nq3f/sz7X/37aTl////wD///8A////AP///wD///8A////APzewAL6277A+eLN//rs3v/57uL/+e3i//jp2v/w1b3/58CfwOO8mgL///8A////AP///wD///8A////AP///wD///8A/N7BAvrcv5f52bvj9ta4/fTTtP3xz6/j7surl+vGpgL///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A//8AAP//AAD/4wAA/8MAAP+DAADgBwAAwA8AAIAfAACAHwAAgB8AAIAfAACAHwAAgB8AAMA/AADgfwAA//8AAA=="))).GetHicon())
 
#endregion

$Button.add_Click({param($sender, $e);
    $Button.Text = "Click on Another Window"
    $winactive = (winactive)
    while ($winactive -eq $MainForm.Handle)
    {
        start-sleep 1
        $winactive = (winactive)
    }
    $Button.text = "Capture"
    $win = $(winatpoint $(mousepos).X $(mousepos).Y)
    if ($win -ne 0){
        $buildstring = "
Window: $win
Window Class: $(winclass $win)
Window Text: $(wintext $win)
"
        $Label1.Text = $buildstring
        $ask = $(ask "Attempt to Capture parents? I may crash!")
        if ($ask -eq "Yes"){
            $tabstr = ""
            $parent = $(winparent $win)
            if ($parent -ne $null) {
                while ($parent -ne 0) {
                    $tabstr+=$(tab)
                    $buildstring+= "
$tabstr Parent: $parent
$tabstr Parent Class: $(winclass $parent)
$tabstr Parent Text: $(wintext $parent)
"
                $Label1.Text = $buildstring
                $parent = $(winparent $parent)
                }
            $Label1.Text = $buildstring
            $buildstring = ""
            }
        }
    }
})

$Button2.add_Click({param($sender, $e);
    $Button2.Text = "Hover over another window."
    start-sleep 1
    $Button2.Text = "5"
    while ($i -lt 5) 
    {
        start-sleep 1
        $i = $i+1
        $button2.text = ((5-$i) | out-string).trim()
    }
    $Button2.text = "Countdown Capture"
    $win = $(winatpoint $(mousepos).X $(mousepos).Y)
    if ($win -ne 0){
        $buildstring = "
Window: $win
Window Class: $(winclass $win)
Window Text: $(wintext $win)
"
        $Label1.Text = $buildstring
        $ask = $(ask "Attempt to Capture parents? I may crash!")
        if ($ask -eq "Yes"){
            $tabstr = ""
            $parent = $(winparent $win)
            if ($parent -ne $null) {
                while ($parent -ne 0) {
                    $tabstr+=$(tab)
                    $buildstring+= "
$tabstr Parent: $parent
$tabstr Parent Class: $(winclass $parent)
$tabstr Parent Text: $(wintext $parent)
"
                $Label1.Text = $buildstring
                $parent = $(winparent $parent)
                }
            $Label1.Text = $buildstring
            $buildstring = ""
            }
        }
    }

})
[System.Windows.Forms.Application]::Run($MainForm) | Out-Null}); $PowerShell.AddParameter('File',$args[0]) | Out-Null; $PowerShell.Invoke() | Out-Null; $PowerShell.Dispose() | Out-Null
