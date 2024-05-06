#region VDS
$RunSpace = [RunspaceFactory]::CreateRunspacePool(); $RunSpace.ApartmentState = "STA"; $RunSpace.Open(); $PowerShell = [powershell]::Create();$PowerShell.RunspacePool = $RunSpace; [void]$PowerShell.AddScript({

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
		if ( $Xml.ToString() -eq 'Form' ) {
			$newControl = [vdsForm]
		}
		if ( $Xml.ToString() -ne 'SplitterPanel' ) {
			$newControl = New-Object System.Windows.Forms.$($Xml.ToString())
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
			if ($newControl.Name){ 			
				if ((Test-Path variable:global:"$($newControl.Name)") -eq $False) {
					New-Variable -Name $newControl.Name -Scope global -Value $newControl | Out-Null
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

function Show-Form {
<#
	.SYNOPSIS
		Ensures forms are ran in the correct application space, particularly 
		when multiple forms are involved.
		
		ALIAS
			Dialog-Show
		
    .DESCRIPTION
		This function runs the first form in an application space, and shows
		successive forms.
	
	.PARAMETER Form
		The form to show.
		
	.PARAMETER Modal
		Switch that specifies the window is to be shown as a modal dialog.
	
	.EXAMPLE
		Show-Form $Form1
	
	.EXAMPLE
		Show-Form -Form $Form1 -modal

	.EXAMPLE
		$Form1 | Show-Form

	.INPUTS
		Form as Object
#>
	[Alias("Dialog-Show")]
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Form,
		[switch]$Modal
	)
	if ($Modal) {
		$Form.ShowDialog() | Out-Null
	}
	else {
		if ($global:apprunning -eq $true) {
			$Form.Show() | Out-Null
		}
		else {
			$global:apprunning = $true
			[System.Windows.Forms.Application]::Run($Form) | Out-Null
		}
	}
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
Set-Types
ConvertFrom-WinFormsXML -Reference refs -Suppress -Xml @"
<Form Name="MainForm" Size="800,600" Tag="IsMDIContainer, DPIAware, VisualStyle" Text="PowerShell Designer" IsMDIContainer="True"><TabControl Name="tcl_Top" Dock="Top" Size="332,20"><TabPage Name="tpg_Form1" Size="324,0" Text="NewProject.fbs" /></TabControl><Label Name="lbl_Left" Dock="Left" BackColor="35, 35, 35" Cursor="VSplit" Size="3,489" /><Label Name="lbl_Right" Dock="Right" BackColor="35, 35, 35" Cursor="VSplit" Size="3,489" /><Panel Name="pnl_Left" Dock="Left" BorderStyle="Fixed3D" Size="200,489"><SplitContainer Name="spt_Left" Dock="Fill" BackColor="ControlDark" Orientation="Horizontal" SplitterDistance="284"><SplitterPanel Name="spt_Left_Panel1"><TreeView Name="trv_Controls" Dock="Fill" BackColor="Azure" /></SplitterPanel><SplitterPanel Name="spt_Left_Panel2" BackColor="ControlLight"><TreeView Name="TreeView" Dock="Fill" BackColor="Azure" DrawMode="OwnerDrawText" HideSelection="False" /></SplitterPanel></SplitContainer></Panel><Panel Name="pnl_Right" Dock="Right" BorderStyle="Fixed3D" Size="200,489"><SplitContainer Name="spt_Right" Dock="Fill" BackColor="ControlDark" Orientation="Horizontal" SplitterDistance="282"><SplitterPanel Name="spt_Right_Panel1"><PropertyGrid Name="PropertyGrid" Dock="Fill" Cursor="HSplit" ViewBackColor="Azure" /></SplitterPanel><SplitterPanel Name="spt_Right_Panel2" BackColor="Control"><TabControl Name="TabControl2" Dock="Fill"><TabPage Name="Tab 1" Size="188,173" Text="Events"><SplitContainer Name="SplitContainer3" Dock="Fill" Orientation="Horizontal" SplitterDistance="119"><SplitterPanel Name="SplitContainer3_Panel1" AutoScroll="True"><ListBox Name="lst_AvailableEvents" Dock="Fill" BackColor="Azure" /></SplitterPanel><SplitterPanel Name="SplitContainer3_Panel2" AutoScroll="True"><ListBox Name="lst_AssignedEvents" Dock="Fill" BackColor="Azure" /></SplitterPanel></SplitContainer></TabPage><TabPage Name="TabPage3" Size="188,314" Text="Functions"><SplitContainer Name="SplitContainer4" Dock="Fill" Orientation="Horizontal" SplitterDistance="229"><SplitterPanel Name="SplitContainer4_Panel1" AutoScroll="True"><CheckedListBox Name="lst_Functions" Dock="Fill" BackColor="Azure" /></SplitterPanel><SplitterPanel Name="SplitContainer4_Panel2" AutoScroll="True"><TextBox Name="lst_Params" Dock="Fill" BackColor="Azure" Multiline="True" ScrollBars="Both" Size="188,81" /></SplitterPanel></SplitContainer></TabPage><TabPage Name="TabPage4" Size="188,428" Text="Finds"><SplitContainer Name="SplitContainer5" Dock="Fill" Orientation="Horizontal" SplitterDistance="25"><SplitterPanel Name="SplitContainer5_Panel1"><TextBox Name="txt_Find" BackColor="Azure" /><Button Name="btn_Find" Location="105,0" Size="23,23" Text="+" /><Button Name="btn_RemoveFind" Location="130,0" Size="23,23" Text="-" /></SplitterPanel><SplitterPanel Name="SplitContainer5_Panel2"><ListBox Name="lst_Find" Dock="Fill" BackColor="Azure" /></SplitterPanel></SplitContainer></TabPage></TabControl></SplitterPanel></SplitContainer></Panel><MenuStrip Name="ms_Left" Dock="Left" AutoSize="False" BackColor="ControlDarkDark" Font="Verdana, 9pt" LayoutStyle="VerticalStackWithOverflow" Size="23,489" TextDirection="Vertical90"><ToolStripMenuItem Name="ms_Toolbox" AutoSize="False" BackColor="RoyalBlue" ForeColor="AliceBlue" Size="23,100" Text="Toolbox" /><ToolStripMenuItem Name="ms_FormTree" AutoSize="False" BackColor="RoyalBlue" ForeColor="AliceBlue" Size="23,100" TextAlign="MiddleLeft" TextDirection="Vertical90" Text="Form Tree" /></MenuStrip><MenuStrip Name="ms_Right" Dock="Right" AutoSize="False" BackColor="ControlDarkDark" Font="Verdana, 9pt" LayoutStyle="VerticalStackWithOverflow" Size="23,489" TextDirection="Vertical90"><ToolStripMenuItem Name="ms_Properties" AutoSize="False" BackColor="RoyalBlue" ForeColor="AliceBlue" Size="23,100" TextAlign="MiddleLeft" TextDirection="Vertical270" Text="Properties" /><ToolStripMenuItem Name="ms_Events" AutoSize="False" BackColor="RoyalBlue" ForeColor="AliceBlue" ImageTransparentColor="White" Size="23,100" TextDirection="Vertical270" Text="Events" /></MenuStrip><MenuStrip Name="ToolStrip" Text="ToolStrip1"><ToolStripButton Name="tsNewBtn" BackColor="Control" DisplayStyle="Image" ImageTransparentColor="Control" Text="New" /><ToolStripButton Name="tsOpenbtn" DisplayStyle="Image" Text="ToolStripButton2" /><ToolStripButton Name="tsSavebtn" DisplayStyle="Image" Text="ToolStripButton4" /><ToolStripButton Name="tsSaveAsbtn" DisplayStyle="Image" Text="ToolStripButton5" /><ToolStripSeparator Name="ToolStripSeparator7" Margin="10, 0, 10, 0" /><ToolStripButton Name="tsUndoBtn" DisplayStyle="Image" Text="ToolStripButton6" /><ToolStripButton Name="tsRedoBtn" DisplayStyle="Image" Text="ToolStripButton7" /><ToolStripButton Name="tsCutBtn" DisplayStyle="Image" Text="ToolStripButton8" /><ToolStripButton Name="tsCopyBtn" DisplayStyle="Image" Text="ToolStripButton9" /><ToolStripButton Name="tsPasteBtn" DisplayStyle="Image" Text="ToolStripButton10" /><ToolStripButton Name="tsSelectAllBtn" DisplayStyle="Image" Text="ToolStripButton12" /><ToolStripButton Name="tsFindBtn" DisplayStyle="Image" Text="ToolStripButton13" /><ToolStripButton Name="tsReplaceBtn" DisplayStyle="Image" Text="ToolStripButton14" /><ToolStripButton Name="tsGoToLineBtn" DisplayStyle="Image" Text="ToolStripButton15" /><ToolStripButton Name="tsCollapseAllBtn" DisplayStyle="Image" Text="ToolStripButton16" /><ToolStripButton Name="tsExpandAllBtn" DisplayStyle="Image" Text="ToolStripButton17" /><ToolStripSeparator Name="ToolStripSeparator9" Margin="10, 0, 10, 0" /><ToolStripButton Name="tsRenameBtn" DisplayStyle="Image" Text="ToolStripButton16" /><ToolStripButton Name="tsDeleteBtn" DisplayStyle="Image" Text="ToolStripButton17" /><ToolStripButton Name="tsControlCopyBtn" DisplayStyle="Image" Text="ToolStripButton18" /><ToolStripButton Name="tsControlPasteBtn" DisplayStyle="Image" Text="ToolStripButton20" /><ToolStripButton Name="tsMoveUpBtn" DisplayStyle="Image" Text="ToolStripButton21" /><ToolStripButton Name="tsMoveDownBtn" DisplayStyle="Image" Text="ToolStripButton22" /><ToolStripSeparator Name="ToolStripSeparator10" Margin="10, 0, 10, 0" /><ToolStripButton Name="tsToolBoxBtn" Checked="True" CheckState="Checked" DisplayStyle="Image" Text="Toolbox" /><ToolStripButton Name="tsFormTreeBtn" Checked="True" CheckState="Checked" DisplayStyle="Image" Text="Form Tree" /><ToolStripButton Name="tsPropertiesBtn" Checked="True" CheckState="Checked" DisplayStyle="Image" Text="Properties" /><ToolStripButton Name="tsEventsBtn" Checked="True" CheckState="Checked" DisplayStyle="Image" Text="Events" /><ToolStripSeparator Name="ToolStripSeparator11" Margin="10, 0, 10, 0" /><ToolStripButton Name="tsTermBtn" DisplayStyle="Image" ImageTransparentColor="White" Text="ToolStripButton28" /><ToolStripButton Name="tsGenerateBtn" DisplayStyle="Image" Text="ToolStripButton29" /><ToolStripButton Name="tsRunBtn" DisplayStyle="Image" Text="ToolStripButton30" /></MenuStrip><MenuStrip Name="MenuStrip" RenderMode="System"><ToolStripMenuItem Name="ts_File" DisplayStyle="Text" Text="File"><ToolStripMenuItem Name="New" BackgroundImageLayout="None" DisplayStyle="Text" ImageTransparentColor="White" ShortcutKeyDisplayString="Ctrl+N" ShortcutKeys="Ctrl+N" Text="New" /><ToolStripMenuItem Name="Open" BackgroundImageLayout="None" DisplayStyle="Text" ShortcutKeyDisplayString="Ctrl+O" ShortcutKeys="Ctrl+O" Text="Open" /><ToolStripMenuItem Name="Save" BackgroundImageLayout="None" DisplayStyle="Text" ShortcutKeyDisplayString="Ctrl+S" ShortcutKeys="Ctrl+S" Text="Save" /><ToolStripMenuItem Name="Save As" DisplayStyle="Text" ShortcutKeyDisplayString="Ctrl+Alt+S" ShortcutKeys="Ctrl+Alt+S" Text="Save As" /><ToolStripSeparator Name="FileSep" /><ToolStripMenuItem Name="Exit" DisplayStyle="Text" ShortcutKeyDisplayString="Ctrl+Alt+X" ShortcutKeys="Ctrl+Alt+X" Text="Exit" /></ToolStripMenuItem><ToolStripMenuItem Name="ts_Edit" Text="Edit"><ToolStripMenuItem Name="Undo" BackgroundImageLayout="None" ShortcutKeyDisplayString="" Text="Undo" /><ToolStripMenuItem Name="Redo" ShortcutKeyDisplayString="Ctrl+Y" ShortcutKeys="Ctrl+Y" Text="Redo" /><ToolStripSeparator Name="EditSep4" /><ToolStripMenuItem Name="Cut" BackgroundImageLayout="None" ShortcutKeyDisplayString="" Text="Cut" /><ToolStripMenuItem Name="Copy" BackgroundImageLayout="None" ShortcutKeyDisplayString="" Text="Copy" /><ToolStripMenuItem Name="Paste" BackgroundImageLayout="None" ShortcutKeyDisplayString="" Text="Paste" /><ToolStripMenuItem Name="Select All" ShortcutKeyDisplayString="" Text="Select All" /><ToolStripSeparator Name="EditSep5" /><ToolStripMenuItem Name="Find" BackgroundImageLayout="None" ShortcutKeyDisplayString="Ctrl+F" ShortcutKeys="Ctrl+F" Text="Find" /><ToolStripMenuItem Name="Replace" ShortcutKeyDisplayString="Ctrl+H" ShortcutKeys="Ctrl+H" Text="Replace" /><ToolStripMenuItem Name="Goto" ShortcutKeyDisplayString="Ctrl+G" ShortcutKeys="Ctrl+G" Text="Go To Line..." /><ToolStripSeparator Name="EditSep6" /><ToolStripMenuItem Name="Collapse All" ShortcutKeyDisplayString="F10" ShortcutKeys="F10" Text="Collapse All" /><ToolStripMenuItem Name="Expand All" ShortcutKeyDisplayString="F11" ShortcutKeys="F11" Text="Expand All" /></ToolStripMenuItem><ToolStripMenuItem Name="ts_Controls" Text="Controls"><ToolStripMenuItem Name="Rename" ShortcutKeyDisplayString="Ctrl+R" ShortcutKeys="Ctrl+R" Text="Rename" /><ToolStripMenuItem Name="Delete" ShortcutKeyDisplayString="Ctrl+D" ShortcutKeys="Ctrl+D" Text="Delete" /><ToolStripSeparator Name="EditSep1" /><ToolStripMenuItem Name="CopyNode" ShortcutKeyDisplayString="Ctrl+Alt+C" ShortcutKeys="Ctrl+Alt+C" Text="Copy Control" /><ToolStripMenuItem Name="PasteNode" ShortcutKeyDisplayString="Ctrl+Alt+V" ShortcutKeys="Ctrl+Alt+V" Text="Paste Control" /><ToolStripSeparator Name="EditSep2" /><ToolStripMenuItem Name="Move Up" ShortcutKeyDisplayString="F5" ShortcutKeys="F5" Text="Move Up" /><ToolStripMenuItem Name="Move Down" ShortcutKeyDisplayString="F6" ShortcutKeys="F6" Text="Move Down" /></ToolStripMenuItem><ToolStripMenuItem Name="ts_View" Text="View"><ToolStripMenuItem Name="Toolbox" Checked="True" CheckState="Checked" ShortcutKeyDisplayString="F1" ShortcutKeys="F1" Text="Toolbox" /><ToolStripMenuItem Name="FormTree" Checked="True" CheckState="Checked" DisplayStyle="Text" ShortcutKeyDisplayString="F2" ShortcutKeys="F2" Text="Form Tree" /><ToolStripMenuItem Name="Properties" Checked="True" CheckState="Checked" DisplayStyle="Text" ShortcutKeyDisplayString="F3" ShortcutKeys="F3" Text="Properties" /><ToolStripMenuItem Name="Events" Checked="True" CheckState="Checked" ShortcutKeyDisplayString="F4" ShortcutKeys="F4" Text="Events" /></ToolStripMenuItem><ToolStripMenuItem Name="ts_Tools" DisplayStyle="Text" Text="Tools"><ToolStripMenuItem Name="functionsModule" BackgroundImageLayout="None" DisplayStyle="Text" ShortcutKeys="F7" Text="Load Functions Module in PowerShell" /><ToolStripMenuItem Name="Generate" BackgroundImageLayout="None" DisplayStyle="Text" ShortcutKeys="F8" Text="Generate Script File" /><ToolStripMenuItem Name="RunLast" BackgroundImageLayout="None" DisplayStyle="Text" ShortcutKeys="F9" Text="Run Script File" /></ToolStripMenuItem></MenuStrip><StatusStrip Name="sta_Status"><ToolStripStatusLabel Name="tsl_StatusLabel" /></StatusStrip></Form>
"@
#endregion VDS
#region Images
$tsRunBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APVbTRr+4sLef+27oCSJXxuckZAPXfz9aia0ntbmNhrlxM8NzbiWHzG6NIowRvOMg9xzVmb+1T4bgsYNMvY7pI4ULpNEv3Su7BEmeQCPxriLhdTudeGl2STJriyK7GR93lAbXDyNlgUHycHPIAAzxRXxk6c1G10/T+rnLK0bafmf/9k="))
$tsGenerateBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APVbTRr+4sLef+27oCSJXxuckZAPXfz9abLpt7ZSQTtq93Iq3MAKFnAYNKqkffPr6Vga54oudKNrorrJaXcOmrKsTyKPOk+4o3K4+XKt/EDx0PAPPXXiue9tZ4rm+uI4I4TiYSBHWVcFANspzzk7sE5C89x0OtK9unyMVTVr/wCZ/9k="))
$tsTermBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAAQABADASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwBuszaVYXl8IvBuhvbW1x5BcWsOQe2RtJGcHnocGq2kaho2p61ZWTeEtDjSaZUYiyiPB6/wVV17ydQ1e+eDxDoxs5blpkRtWhAyeN23d1xUegwWmn69Y3c+uaGIYZlZyNUgJAz/AL1fXRpZb9Wbk489tNXvb13uYpLlv1+Z/9k="))
$tsFormTreeBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APSoLW8ltImGtXQciEFDI2cSbRn7+TjcOSBmrMum3tlJBO2r3circwAoWcBg0qqR98+vpUsUWoR2lqp0q7MkcVujqHhxmNlYkHzPY9vy5q3eSXl6kMKaReRf6TA7SSPDtVVlViTiQnop6Cup1Jd1+BgoL+rn/9k="))
$tsEventsBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APTksLz7BazNrV5++iVwoLkjIHcyDPXrSR212jRXI1W+dI7mBWV2YB8yqpH+sPr6U93u4LextZbG7W6aFI0jPlsrFAN2Crkj1yR9akitdSMEML2F8p8+Bjukh8qNVlVj0ck8A9vwrKOJxEsVKDtyL0/rz7h7GmqSl1+Z/9k="))
$tsPropertiesBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APSba2u5oIsavqG9o0bGyXHzYwA5YKT8w7+tLLDfWMyyvqF/L5DpLJH5hwyKwLD/AFhzxnjH1qGe+udIhtbe+Nxbu1v8sLyRAN5ewMIyuTnnue5/CZI7zWltZl0u4+ytNE8bOY1Xyw4LFgW3YK5wMc5zzmpr4qq63saVvN6WX4BSoQUPaT/U/9k="))
$tsToolBoxBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APSYba8kt4Ma1c72WElTKSQHKD/npu439wM496tS6be2UkE7avdyKtzAChZwGDSqpH3z6+lLbwapFbwK+nXbbEgBjEiYBQoTjM23+E9FHX65v3kl5epDCmkXkX+kwO0kjw7VVZVYk4kJ6KegrrlUd7XVvkc8YL+rn//Z"))
$tsMoveDownBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APdru/trEKbiTZvzt+UnOOvQe9FjqFrqUTy2kvmIj7GO0jDYBxyPcVDquk22sWohnMiFTuSWIgOh9iQevvTtL0u10ewS0tEIReWZjlnbuzHuT/8AW6CgD//Z"))
$tsMoveUpBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APeLq7gsoDNcyiOMHGT3P07062uYbu3S4t5FkicZVlPBqjq+iQ6x5PnTzxGLdtMJXnOOu4H0o0TQ7fQbSW3t5ppVlmMzNMVJyQBxtAGPlFAH/9k="))
$tsControlPasteBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/AOnsUjl+zSSW0F5d3ggDSXoMpLEADJYkgcjp2ArTnufEfgW1l1E2kOp6JbwL9qgjvJDNbop5kiDjaQE3ZTIzhcEY5xoTJpQ0271KOaxtbeW2E011C8UceHQfM7AKBnuTW94z8YeFbrwR4ght/EmjTTy6bcpHHHfRMzsYmAAAbJJJ6V5mBpauctztxU7Witj/2Q=="))
$tsControlCopyBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/AO58MeDvDFx8P9AuJ/DWjzzXGm23mO9nHvdnjUFi+3OcnOetVbSfxh8O9JnFxZadqnhfTfMMaW9zKb6C28wsCTINjiOPI2jbwo54qpdXfjrwFY6Faai3h2fw1b3lppz3cUc6zRW4YKJZdzbI+FGTkgMwHNbfjPxh4VuvBHiCG38SaNNPLptykccd9EzOxiYAABskknpQB//Z"))
$tsDeleteBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APWJpZr2O2mmPzO+5Ipipg2kEjdgZJxxz0PNQ/bzpguHjf8Aeh9zQQlfIKgAnHy5BxxnjJ55q1LbahYQJDJEbu2QBVlgX51AwBlO/wCGelcFqV6saT27PeLqxkZIrYIwzk4Qbdw6qQfuk89awxGIjQipSOjD4eVeTjFn/9k="))
$tsRenameBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APYJ/FdlbSmKd445AoYr+8OMgEchCOhFW7DUbu8tHne0gj2SyRlRcFuUYqf4B3U49sfSoJ/C2m3MplngEkhUKWLuM4AA4DAdAKtadp1xZWckEtzFKXlkl3JCU++xYjG492OPbH1Ny5LLl+ZK5ru5/9k="))
$tsExpandAllBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APV9D0nUtN1X95BAIPL2vKpB3DHG3+IHPXPBx9Kr674d1LV9bmdTCIDBtilkIwuB93A5yWJOewP4UzQvE+o6x4ghhAi+z+SWmjQDCYH3snnJYgY7A/jVfxb4l1jQdcUQz2otzFvjgcA7xgg7v4gc9MEA4Ho1clqfs+trnH+79n1tc//Z"))
$tsCollapseAllBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APVtO0rULLxD5irP9kMjb5GlX94NrYLANknJ649+Kr67peuahrBSESiz85Gjl81cRfKoLgbgcgg/rjqcpomr63qOuKZFmFkJ3SVPKXEXysQhO0HIIH6Z6jNbW/Eeq6V4tWBjdGxaVPLhjhX9+Nq7lQlSWO49AfbI6jk9zk62v/XyOP8Ad+z62v8A18j/2Q=="))
$tsGoToLineBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APbb+7lhmKo7ABVOFHqW9j6VQ0e6Da1cRC5LvMrTTRNtyrARqDwoIyPX0rC12/1C4u7+IaVqUieYiRmK2c/Kjc4YAdQWOc9+tcuJLy41aG00qC7t9ZjlDLvjZXgztG+TO47MMuc5GDXPUxHLZKLMJVnF7aH/2Q=="))
$tsReplaceBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/AOig167a/vNX0aeMTz3Mha2aGPPkrhgWIORncAQvUqx3ZFegR+MdAlZVW/xuIGWidQMnGSSuAPc8VS8fzJF4dQNM0Mj3MaxSALhW5OSSOBgN057dCa8th1C2kWO3u7xxaecPNJ2how7ASMuM7vkRe3HQDufWpUHjG5yVorRW3/4J5cqksNLkTvf+u5//2Q=="))
$tsFindBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/ANK58eQzX1xezaZYSLPKshM0YZlQIQUyx64jXGQPvE47V2F1bWMukrqumqltcRQtdWtzbRquRs3DOOoI/PODxXKXvh6awvbqzk8TWiTQOkQ8yNU+UQjDBWlHXzCM56r71rx6jFZeF209tT0+ZbfTngDCePe5WEqMASHkkDjHevRpQqWT6HDUnBO1tT//2Q=="))
$tsSelectAllBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APSNf8appXi2DTXuoobHasNzJlQ8UkgJV/nOMKApJwVAY5ycCsfSvE2vatqy+Em1C4ttdtb6R9QuEt4iFs0UYZA6AfOzoF4Y9WPGBXQyeCLe5s9R0252vpl1ci5MRmmJd8DJchwx5APLEEjOBUtn4YutL17+0dPnt1N35a6i8gld50iTZGPndssB/ECpzyd/Sr5F3RPM+x//2Q=="))
$tsPasteBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/AOusreGc2sj28F1dXccBklvQZizFRySxJA57dgK3LCS/8NW00pjN7aRxxholuXJhRd25lVxj7pHAIHyj8MGwW4s5NNlvLe5toYTCsjz28kapjaOWKhRz71v6pqelSaZeBNRs3c28gVVuEJJKEAAZrDK8NGUXUnHW/n5GmOqyjLli9LeR/9k="))
$tsCopyBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APSrPTLBtHsC2n2j+bBCrboVBJZVGS2M9TnNW4L+58PaMsSWf2u1tSSxW4JkSLJPAZQDtXgDI6DpRc2V5oml2zT6haPa2z28bE2zIdodFyWMhA9elVdU1PSpNMvAmo2bubeQKq3CEklCAAM16GlTzV/M49YeTP/Z"))
$tsCutBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APavEckS+HtQikkRWmtpo41ZgC7eWxwPU4BOPQGub8LwatHeW1kqiHTbC4uGdUfAcM0hXdxyfnBCdABuJyUFYfjPTr5fE+o6n/Z9zcQ28SXAd9vkiBEG4bm4GG3NtBDcMdp3ZF74eane3fiLV4o1jOnOPtMxyu5Z2IVSMMeGCv8AhGpwpJB6+Tlo3TucfPzVrNWP/9k="))
$tsRedoBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APVL/wAUXUd9LFbRwpGknkr5iM7yODg4Ckd+AOtU7TXNWl8U2sbRyO8iBJLXyZIVWLdzNhj1B4z3+6OTWfqUOsaZ4gkmis7pnjuHuLeaC2aeNlctlWCjrgkEcHuD0NXdH1rW7zxPZ/a9IRVlDRS3J0uaF0QKzAeY5xjcF49644uTl7ze5xqUnK0m9z//2Q=="))
$tsUndoBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APX9SOvi+m+xrObfI8vy/JxjaM/f565rCt/Euq2uuQW9zK8qG4S1nt5o1Roy5ADAqOeoPcEH8Q3U5dbHjG4jtRKb/wAgmEW/lY+zbuP9Zxnd175zjiqdj4a8Q3niK3uL23ktoVuUu7i5uJkkeUoQQgVGOM4A7AAfQHjbk5e7ff5HG3Jy92+/yP/Z"))
$tsSaveAsbtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APQv7SuH1m4tTLcOxupI4wssnJ8xwBxIoAAX/PbR06+v9Mnja5SefT72VRHI7BnV3KhcZlb93jJx1yaqav4ens9ahvIGnktZrjc7RqWliZjIzEBE+78wwSSc1DNBeSXOnnGqyst9bsUlWV0Vd/zMcoAMeue5rulKDsls/J/0jkXMnqf/2Q=="))
$tsSavebtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/AOz0j+wotOsEvLSxD7Y3lL2QcshhHcKed5z1zS69c+HzYStpVpbRXEas6SRWxidCqkhg2AQQwFV9Mm0ptGtWlmsGnCIrCW6VSoEaAceYvfdVbX5tKTQ52glsBcElFEN0HJUo+ePMbvt9K9Tnj7bltK/4Hn3fL0P/2Q=="))
$tsOpenbtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APWPEkSeItChsfsivDPd2csiXGwq8S3ETsCuTnKqRjHOawfGvgrw5a+DtYvbLRLCxvLK0lu7a6sYEglhliQujK6AHqo71rC/01tOtg0lo0ohjB8xw2CFHYnGeKz9QtI/EOmXGjWd1YWs98j25mW3VyqPFIHO1WUnjpzgHB56Hy6eYfvFTlq316fkdUsO7OXY/9k="))
$tsNewBtn.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("/9j/4AAQSkZJRgABAQEAYABgAAD/4QBsRXhpZgAATU0AKgAAAAgABQExAAIAAAARAAAASgMBAAUAAAABAAAAXFEQAAEAAAABAQAAAFERAAQAAAABAAAAAFESAAQAAAABAAAAAAAAAABBZG9iZSBJbWFnZVJlYWR5AAAAAYagAACvyP/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APUodOs5lnleytpJGurjczwqxP75+5FQvYQWl9Z31kgtLmOaKKQwxqqyxvKqlSB7N6ds9QDVRtcjtZbiFb2xjKXVwGWWVAwPnydQXBHGO3esS81yG6sLp01KT+2Y7kC1gt3Dq7BiY9qBiGyQh6Hn17deIquhFSlqmcClFu3Y/9k="))
$MainForm.Icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap][System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String("AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAACPWjAUj1owhI9aMKOPWjC2j1owyY9aMNqPWjDrj1ow+pRgOP+ZaED/Bnwi/wN6Hf96Xizej1owNAAAAAAAAAAAk14yaLePbP/WuaL/38Wy/+fUwv/u39P/9eri//v07//9+vb///79/wuGMf9CoF7/E34o/2dmKoUAAAAAAAAAAJhjNYnHo4T//////////////////////yGWUf8bkEn/FY5D/xCKO/85nl3/f8CV/0WiYf8Iex/0AHgYKgAAAACdaDhXnWg49rOEWP/ZpHr/2J1u/9eaaf8omlr/j8qo/4zIpP+JxaD/h8Sd/2m1hP+BwZb/R6Rl/wB8IOoAeBowo247FKNuO6vVrYv//fDl//fHof/3z6z/MJ5i/5PNrP9uuY3/areI/2W1hP9gsn//ZrSB/4LBl/87n1v/AH4k/AAAAACpdD8otoVV//7+/f/63sH/+ty+/zaiav+Vzq//k82s/5DLqf+Py6f/c7uP/4nHoP9FpGf/B4Y0/QGCLA8AAAAAsHpCHriFUf/+/Pn/+dy+//jbvv88pG7/OKJt/zSgZ/8wnWH/VK57/5DLqf9OqnP/F45E/xGKPAwAAAAAAAAAALaBRgm4hEr//vv3//ncwP/43L7/+Ny+//jbv//53b//+d2//zigZv9ZsoD/J5dW/7GCRvu2gUYBAAAAAAAAAAAAAAAAvIdK+fz28P/538f/+dy8//rcvv/628D/+t3C//rdwf8+pG3/MJ5k//j59f/AjFL/vIdKDwAAAAAAAAAAAAAAAMONTdr159j/+uXS//nau//527v/+tu+//rdwP/63cD/+d3D//vhyP///fv/yJNW/8ONTRIAAAAAAAAAAAAAAADKk1G78NnA//vt4f/52r//+dzB//nexP/64Mf/+uLK//rizf/65dD///79/8uOWf/Kk1HxypNRRQAAAAAAAAAA0JlUpO3Qsf//9vD/+uHK//vjzP/749D/++bT//vp1f/86dj//Orb/////f/SnHD/7tnA/9CZVOUAAAAAAAAAANWeV5LryqT///37//3p1f/969j//erb//3t3//98OL//fHk//zw5P//////4J9v///7+f/ft4b/AAAAAAAAAADao1qE68WZ///////87+L//fDn//3x6//99e7//fjx//369////Pr///////779//02r//2qNa6gAAAAAAAAAA3qdcbeq/i////////////////////////fn0//vz6v/469n/+ObT//Xfxf/py6X/3qdc7d6nXF0AAAAAAAAAAOKrXjbiq17G6ruA/+i2dv/msWz/5K9n/+KrXvDiq17j4qtez+KrXsziq1674qteqOKrXkviq14FAAMAAAADAAAAAQAAAAAAAAAAAACAAAAAgAEAAIABAADAAQAAwAEAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAA=="))).GetHicon())

#endregion

<#

MIT License

Copyright (c) 2020 Benjamin Turmo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


    .NOTES
    ===========================================================================
        FileName:     Designer.ps1
        Modified:     Brandon Cunningham
        Created On:   1/15/2020
        Last Updated: 5/5/2024
        Version:      2.3.3
    ===========================================================================

    .DESCRIPTION
        Use this script in the creation of other WinForms PowerShell scripts.  Has the ability to
        Save/Open a project, modify most properties of any control, and generate a script
        file.  The resulting script file initializes the Form in a STA runspace.

    .DEPENDENCIES
        PowerShell 4.0
        .Net

    .UPDATES
    1.0.0.1 - 06/13/2020
        Added MIT License
    1.0.1.0 - 06/20/2020
        Added DataGridView
        Corrected issue where able to add controls directly to TabControl instead of TabPage
    1.0.2.0 - 7/10/2020
        Added TabPage for TabControl
        Added SplitterPanel for SplitContainer
        Fixed Size property being saved when Dock set to Fill or AutoSize to true
        Updated UI: Moved Toolbox/Events to SplitterPanel in a TabControl on Mainform. All controls now
            in SplitContainers to allow for finer UI customization and to allow for maximization of
            the Mainform. There are some changes to the UI that were made in preparation for updating
            to a MDI child form and to allow for other future development.
    2.0.0.0 - 12/14/2020
        Complete UI Overhaul to make more traditional and allow for future feature additions/enhancement
        Property values being saved in the form XML is now dependent on the property reflector of the
            PropertyGrid GridItem. Does still keep track of every change because of issues with
            reflectors (see Known Issues).

        Unsupported:
            Multi-threading
            Drag/Drop addition of controls
            Adding Mouse Events to WebBrowser control
            Previous pre-2.0.0.0 version save files will not open properly in 2.0.0.0+
                If the Items Element is removed from Data it should load properly
        
        Known Issues:
            DataGridView - All CellStyle Properties will save, but get exception when setting on Open
            ListView - ListViewItem and ListViewGroup Properties will not save
            TreeView - Nodes property will not save
            TextBox - AutoCompleteCustomSource Property will not save
            Form - Unable to change IsMDIContainer to True and issue Maximizing Window State
            Certain property reflectors will show that a value has been changed when it has not. This
                issue affects the following properties on all controls: UseCompatibleTextRendering,
                TabIndex, and TabStop. In order for these properties to be saved to form XML they need
                to be manually changed in the PropertyGrid. After this point, the property value will
                always be generated in the form XML for that specific control.
            Images/Icons do not save
    2.0.1.0 - 12/26/2020
        Corrected issue after resizing of Form in design after resize to refresh parent Form
        Fixed issue with Size property on Forms and Textboxes to save correctly
    2.0.2.0 - 4/13/2022
        Removed FileDialog because it was unstable.
        Removed Global Context Menus because they were unstable.
        Fixed control attached Context Menus.
        Fixed generation of and behavior of common dialogs, which did not work previously.
        Fixed Save and Save As functions to not be locked to preset directory
        Assigned controls to variables rather than a script reference array and removed abstract reference table.
        If the VDS Module is installed, it is integrated into the script file output.
        Added DataGrid, HScrollBar, StatusStrip, TrackBar, VScrollBar,ToolStripButton,ToolStripSplitButton
    2.0.2.1 - 4/14/2022
        Changed location of vds module export, added to functions
        Added ToolStrip, just for layout purposes. Cannot add items within GUI
    2.0.2.2 - 4/15/2022
        Added FastColoredTextBox for editing events - attached to \Events.ps1
        Added 'RunLast' function
        'Copy' and 'Paste' shortcuts (CTRL+C, CTRL+V) broken by addition of FastColoredTextBox. Removed shortcuts.
        Created menu items and context menu for FastColoredTextBox
        Removed (unlisted in version 2.0.2.0) backup system now that Event outputs are much harder to overwrite.
    2.0.4 - 4/16/2022
        Changed some appearance elements. 
        Renamed this effort to PowerShell Designer with the intent to replace previous. 
        Renamed from WinFormsCreator to Designer.ps1. 
        Changed documents path
        Fixed SaveFildDialog path reference
        Fixed F9 for folders with spaces.
        Switched to Semantic Versioning, this product supercedes Powershell Designer 1.0.3
        Slicked to topnode if control add error.
    2.0.5 - 4/16/2022
        Fixed path issue when installing new version. 
    2.0.6 -  4/16/2022
        Fixed bug in path issue fix.
    2.0.7 -  4/16/2022
        Github repository created
    2.0.8 - 4/17/2022
        Fixed adding ToolStrip items
        Eliminated DialogShell info function calls
    2.0.9 - 4/18/2022
        In previous update removed vds module integration, not sure which.
        Added sender [sender] and events [e] parameters to control events   
        Scaling fix added for High Resolution Displays. Set Form 'Tag' Property to 'DPIAware' to attempt. See 'DPI Scaling.txt'
        Modern Visual Control Styles Added. Add the tag 'VisualStyle'
        Fixed bugs with File>New
        Adjustments to Size Buttons for window maximized. Added DesignerDPI.ps1 for clear text editing, adjusted math in that script for size buttons, but the controls will be squished at runtime (intentional, wontfix).
    2.0.10 4/19/2022
        Resolved issue with cancel on file open.
        Dot sourced events.ps1 to calc.ps1 and added VisualStyle tag.
    2.1.0 4/21/2022
        Changed ctscale variable to cctscale for dialogshell compatibility. Call to variable in resize events must be updated to cctscale
        Here there be math involving scaling.
        DPIScale is now default mode for editing.
        DPIScale and VisualStyle are now defaults for new projects.
        Added status bar advising of $cctscale stuff.
    2.1.1 4/22/2022
        Reverted cctscale back to ctscale due to cross compatibility issues.
        Refactored versioning. This (ctscale) is no longer considered a breaking change, since it impacts no known published scripts.
        Added AutoNaming and AutoTexting controls by control type.
    2.1.2 4/24/2022
        Added FormName to FormText on New Project.
        Added a try-catch for loading FastColoredTextBox that should cause the script to be portable.
    2.1.3 4/25/2022
        Added warning concerning item collections in the property grid.
        Seperated edit and control menu.
        Fixed bug with timers causing them to not be initialized.
        Changed behavior of Paste Control to 'slick' to top node upon paste failure.
        Added image and icon embedding.
        Removed toolstrip due to buggy behavior. Toolstrip is now an alias for MenuStrip.
    2.1.4 4/26/2022
        Fixed double file dialog for icons, images
        Fixed WebBrowser control
        Fixed bug with direct control selection (accidental code delete in 2.1.3, restored)
        More control resize math for when client is maximized.
        Removed some problem attributes from export (image attributes) that are handled programmatically
        Added image import on solution open.
    2.1.5 4/27/2022
        Fixed bug with Powershell 7 not loading saved images.
        Added 'region Images' for collecting applied images and icons.
    2.1.6 4/28/2022
        Removed HScrollBar and VScrollBar due to support issues with DPI Scaling (these can still be added programmatically within 'events', if so multiply Width by $ctscale for HScrollBar but exclude width, and the opposite is true for VScrollBar).
        Fixed minor bug involving ToolStripProgressBar sizing (Set AutoSize to False to save the size of this element)
        Fixed minor bug involving ToolStripSeparator
        Fixed bug loading projects with ImageScalingSize and MinimumSize attributes.
    2.1.7 4/29/2022
        Changed several message box dialogs to status bar label updates with timer instances.
    
    3.0.0 4/19/2024 - 4/20/2024
        In a bit of a mad dash, I've refactored script output and I've added abstract syntax tree parsing and a function reference.
        Outputted scripts have the same functionality as before but are using a different system.
        The console window is no longer hidden when running your script.
        You can easily add your functions into the region 'Custom Functions' and they will show up in the GUI, you can then select them and save them with your projects.
        This will partially break previous projects. 
        To fix, open your old project, navigate to the Functions tab and click the first Seven functions listed. 
        Save your project. Done.
        
    2.2.0 4/20/2024 - 4/21/2024
        Fixed 'partually breaks previous projects'. Demoted Semantic Version. Added a metric s-ton of custom functions, a refactor of Visual DialogShell
        Fixed Timers. Fixed AST injection issues. Established custom function dependency check system.
        Forms created are now custom objects [vdsForm] that support hot keys. See previous version of this program if that upsets you. References to this custom Object are simply 'Object' so it is cross compatible with Systems.Windows.Forms.Form
        NOTE: Considering renaming to "Visual Designer Shell", that's what this is in my mind already. This is to honor the codebase from which the custom functions are derived, which in turn honors Julian Moss, the creator of Visual DialogScript.
        NOTE: A serious refactor is needed to eliminate abstract references to objects in Designer.ps1 and to conform to my current style guide standards. This may or may not be performed.
        
    2.2.1 4/21/2024
        Moved custom function (execution) into user customizable file. Moved dependency function (execution) into user customizable file. Theses files are in Documents\PowerShell Designer\functions.
        Changed AST code a bit to parse the external function file instead of the modules own script base.
        Added parameter label for displaying options for each custom function instead of injecting them into FastText
    
    2.2.2 4/22/2024
        Changed functions.ps1 to functions.psm1 so it can be imported as a module and commands such as get-help may be used to learn more about functions.
        Changed $lst_Functions.add_Click to $lst_Functions.add_SelectedIndexChanged
        Chanced parameter label to TextBox. Did some string tricks to format it properly for display. Enabled on purpose for copy/paste/scroll.
        Changed Function hotkeys around a little. Added a menu item to load functions.psm1 into PowerShell for testing (F7). Added F8 for generating script file.
        Function CheckListBox DoubleClick now injects function into FastText window and checks the item
        Events.ps1 is no longer dot sourced. Changed text to just "Run Script File" and canceled the save to Events.ps1
        Fixed custom function Get-Arctangent
        
    2.2.3 4/23/2024
        Further GUI improvements, images in menus, main window icon
        Turned off hide console for Designer.ps1
        In my FastText github repository brandoncomputer, lots of updates to FastColoredTextBox.dll
        Not sure what else I might have done... don't be surprised if these comments don't line up with the diffs.
        
    2.2.4 4/25/2024
        Abstacted initial funcitons calls to module import, which allows us to call get-command instead of invoking AST parsing for function information after functions are loaded into lst_functions
        Added all commands from Microsoft.PowerShell.Utility into the funciton checked list box
        Fixed typos in Dependencies.ps1 - typos cause the program to crash. Add custom functions and dependencies carefully.
        Note: Remember, if a Function isn't checked, it will not export to your script.
        Began adding a toolstrip.
        
    2.2.5a(lpha) 4/26/2024
        Partial incomplete refactor to format code (bookmarkFormatRefactor), eliminate orphaned code eliminate abstract references and perform toolstrip codeout
        Runspace refactor to match standard outputs
        (Re)Added STA (Single Thread Aparment) to this refactor and user script outputs
        Fixed bug with SMOVE buttions where on some configuratons they would appear above the top of the form this will cause some displays/configs to show them lower than they should be. This only occurs on-click.
        Began new toolstrip GUI element, incomplete.        
        
    2.2.6a 4/28/2024
        Completed GUI coding.
        Begain alphabetically sorting functions, they have to be resorted in the module, which is a grind.
        Various message box to statusbar changes, added exit question so people are less likely to lose work
        Finished function alpha sorting
        Other minor changes.
        Users again should remove Documents\PowerShell Designer\funcitons folder before upgrading.
        
    2.2.7 4/29/2024
        Fixed encoding issues causing non-latin based languages to not display (#7)
        Added feature to open FBS file with argument passed to script (#8)
        Decided Designer.ps1 will require a 'loose refactor' for legibility.
        Completed style (loose) refactor.
    
    2.2.8 4/30/2024
        VDS style alias's added to functions.
        Very minor changes. Changed Set-Hotkey to Add-Hotkey.
        Added Microsoft.PowerShell.Management to function list and dependencies.
        Considering unchecking imported functions, part of me says 'check, because they can be used without export',
            the other part of me says 'uncheck, because they take up space in the xml data'.
        This is a release candidate.
        
    2.2.9rc 5/1/2024
        Found bug (Issue #9) related to module differences between 5.1 and 7x PowerShell and function dependencies script.
        Due to this bug, we are switching to 'unchecked' for standard modules, although I also error trapped the problem quite a bit as well.
        Moved powershell module load into function checklistbox to the Dependencies.ps1 script, so that more modules can easily be added by the end user.
        Logged issue #10, fixed issue #10 (Shortcuts)
        
    2.3.0rc 5/2/2024
        Fixed IsMDIContainer trouble by adding IsMDIContainer as an option in the tag and interception of the xml upon output generation. Ends up it was #1 'willfix'.
        This software can now edit itself. Slight restructure of code due to being generated from PowerShell Designer itself. 
        Designer.fbs and events.ps1 now editable from within the software
        Fixed issue #11 regarding $PSScriptRoot by having the core powershell-designer.psm1 handle that standup.
        Designer.fbs and dependencies copied to Documents\PowerShell Designer
        
    2.3.1 5/3/2024
        Added Microsoft.PowerShell.Core to function list and dependencies.
        Updated FastColoredText.dll. Please see that repository for diffs and details, but I added statements and the Core module as class words and got rid of maroon coloring for variable objects.
        Changed location of Designer.ps1 and Events.ps1 and update core module to reflect.
        If you are a regex expert and want to help me with something, kindly reply to the issue called "Regex expert needed"
        In either this or the last revision added file switch to process a file argument to all scripts are are compiled with the software.
        Fixed Assert-List LoadFile
        Added 'Finds' Tab for navigating files.
        Moved functions to functions subdirectory in module root.
        
    2.3.2 5/4/2024
        'Find and Replace' and 'Find' window are now child windows (through API calls). Positioned windows.
        Change to Find behavior, no longer notifies when last result is reached wontfix.
        Find List DoubleClick searches for result twice, so the list should only be used for unique strings. Wontfix
        
    2.3.3 5/5/2024
        Added vertical folding line marks. Minor code cleanup.
        Changed FastText backcolor.
        Got rid of common edit shortcuts, they are still there, but unlabled. If I label them, then they override those shortcuts for the find and replace windows and elsewhere.
        Fixed regex for multiline comments    
        
BASIC MODIFICATIONS License
Original available at https://www.pswinformscreator.com/ for deeper comparison.
        
MIT License

Copyright (c) 2022 Brandon Cunningham

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
        
#>

import-module ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\functions.psm1")

    $global:control_track = @{} 
    
    function Convert-XmlToTreeView {
        param(
            [System.Xml.XmlLinkedNode]$Xml,
            $TreeObject,
            [switch]$IncrementName
        )

        try {
            $controlType = $Xml.ToString()
            $controlName = "$($Xml.Name)"
            
            if (($controlType -eq "Functions") -or ($controlType -eq "Function")){
                return
            }
            
            if ( $IncrementName ) {
                $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode
                $returnObj = [pscustomobject]@{OldName=$controlName;NewName=""}
                $loop = 1

                while ($objRef.Objects.Keys -contains $controlName) {
                    if ($controlName.Contains('_')) {
                        $afterLastUnderscoreText = $controlName -replace "$($controlName.Substring(0,($controlName.LastIndexOf('_') + 1)))"
                        if ($($afterLastUnderscoreText -replace "\D").Length -eq $afterLastUnderscoreText.Length) {
                            $controlName = $controlName -replace "_$($afterLastUnderscoreText)$","_$([int]$afterLastUnderscoreText + 1)"
                        }
                        else {
                            $controlName = $controlName + '_1'
                        }
                    } 
                    else {
                        $controlName = $controlName + '_1' 
                    }
                        # Make sure does not cause infinite loop
                    if ($loop -eq 1000) {
                        throw "Unable to determine incremented control name."
                    }
                    $loop++
                }
                $returnObj.NewName = $controlName
                $returnObj
            }

            if ($controlType -ne 'SplitterPanel'){
                Add-TreeNode -TreeObject $TreeObject -ControlType $controlType -ControlName $controlName
            }
            $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode
            $newControl = $objRef.Objects[$controlName]
            $Xml.Attributes.GetEnumerator().ForEach({
                if ( $_.ToString() -ne 'Name' ) {
                    if ($null -eq $objRef.Changes[$controlName]) {
                        $objRef.Changes[$controlName] = @{}
                    }
                    if ($null -ne $($newControl.$($_.ToString()))){
                        if ($_.ToString() -eq 'Size'){
                            $n = $_.Value.split(',')
                            $n[0] = [math]::Round(($n[0]/1) * $ctscale)
                            $n[1] = [math]::Round(($n[1]/1) * $ctscale)
                            if ("$($n[0]),$($n[1])" -ne ",") {
                                $_.Value = "$($n[0]),$($n[1])"
                            }
                        }
                        if ($_.ToString() -eq 'Location'){
                            $n = $_.Value.split(',')
                            $n[0] = [math]::Round(($n[0]/1) * $ctscale)
                            $n[1] = [math]::Round(($n[1]/1) * $ctscale)
                            if ("$($n[0]),$($n[1])" -ne ",") {
                                $_.Value = "$($n[0]),$($n[1])"
                            }
                        }
                        if ($_.ToString() -eq 'MaximumSize'){
                            $n = $_.Value.split(',')
                            $n[0] = [math]::Round(($n[0]/1) * $ctscale)
                            $n[1] = [math]::Round(($n[1]/1) * $ctscale)
                            if ("$($n[0]),$($n[1])" -ne ",") {
                                $_.Value = "$($n[0]),$($n[1])"
                            }
                        }
                        if ($_.ToString() -eq 'MinimumSize'){
                            $n = $_.Value.split(',')
                            $n[0] = [math]::Round(($n[0]/1) * $ctscale)
                            $n[1] = [math]::Round(($n[1]/1) * $ctscale)
                            if ("$($n[0]),$($n[1])" -ne ",") {
                                $_.Value = "$($n[0]),$($n[1])"
                            }
                        }
                        if ($_.ToString() -eq 'ImageScalingSize'){
                            $n = $_.Value.split(',')
                            $n[0] = [math]::Round(($n[0]/1) * $ctscale)
                            $n[1] = [math]::Round(($n[1]/1) * $ctscale)
                            if ("$($n[0]),$($n[1])" -ne ",") {
                                $_.Value = "$($n[0]),$($n[1])"
                            }
                        }
                        if ( $($newControl.$($_.ToString())).GetType().Name -eq 'Boolean' ) {
                            if ( $_.Value -eq 'True' ) {
                                $value = $true
                            }
                            else {
                                $value = $false
                            }
                        } 
                        else {
                            $value = $_.Value
                        }
                    }
                    else {
                        $value = $_.Value
                    }
                    try {
                        if ($controlType -ne "ContextMenuStrip"){
                            $newControl.$($_.ToString()) = $value
                        }
                    }
                    catch{
                        if ($_.Exception.Message -notmatch 'MDI container forms must be top-level'){
                            throw $_
                        }
                    }
                    $objRef.Changes[$controlName][$_.ToString()] = $_.Value
                }
            })
            if ($Xml.ChildNodes.Count -gt 0){
                if ($IncrementName){
                    $Xml.ChildNodes.ForEach({Convert-XmlToTreeView -Xml $_ -TreeObject $objRef.TreeNodes[$controlName] -IncrementName})
                }
                else{
                    $Xml.ChildNodes.ForEach({Convert-XmlToTreeView -Xml $_ -TreeObject $objRef.TreeNodes[$controlName]})
                }
            }
        } 
        catch {
            Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered adding '$($Xml.ToString()) - $($Xml.Name)' to Treeview."
        }
    }

    function Get-CustomControl {
        param(
            [Parameter(Mandatory=$true)][hashtable]$ControlInfo,
            [string]$Reference,
            [switch]$Suppress
        )
        try {
            $refGuid = [guid]::NewGuid()
            $control = ConvertFrom-WinFormsXML -Xml "$($ControlInfo.XMLText)" -Reference $refGuid
            $refControl = Get-Variable -Name $refGuid -ValueOnly
            if ($ControlInfo.Events){
                $ControlInfo.Events.ForEach({$refControl[$_.Name]."add_$($_.EventType)"($_.ScriptBlock)})
            }
            if ($Reference -ne '') {
                New-Variable -Name $Reference -Scope Script -Value $refControl
            }
            Remove-Variable -Name refGuid -Scope Script
            if ($Suppress -eq $false) {
                return $control
            }
        } 
        catch {
            Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered getting custom control."
        }
    }

    function Get-UserInputFromForm {
        param([string]$SetText)
        try {
            $inputForm = Get-CustomControl -ControlInfo $Script:childFormInfo['NameInput']
            if ($inputForm) {
                $inputForm.AcceptButton = $inputForm.Controls['StopDingOnEnter']
                $inputForm.Controls['UserInput'].Text = $SetText
                [void]$inputForm.ShowDialog()
                $returnVal = [pscustomobject]@{
                    Result = $inputForm.DialogResult
                    NewName = $inputForm.Controls['UserInput'].Text
                }
                return $returnVal
            }
        }
        catch {
            Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered setting new control name."
        } 
        finally {
            try {
                $inputForm.Dispose()
            }
            catch {
                if ( $_.Exception.Message -ne "You cannot call a method on a null-valued expression." ) {
                    throw $_
                }
            }
        }
    }

    function Add-TreeNode {
        param(
            $TreeObject,
            [string]$ControlType,
            [string]$ControlName,
            [string]$ControlText
        )
        if ($ControlText){
            #Do nothing.
        }
        else {
            if ($control_track.$controlType -eq $null){
                $control_track[$controlType] = 1
            }
            else {
                $control_track.$controlType = $control_track.$controlType + 1
            }
        }
        if ($ControlType -eq 'ToolStrip') {
            $ControlType = 'MenuStrip'
        }
        if ($ControlName -eq ''){
            $userInput = Get-UserInputFromForm -SetText "$($Script:supportedControls.Where({$_.Name -eq $ControlType}).Prefix)_"
            if ($userInput.Result -eq 'OK') {
                $ControlName = $userInput.NewName
            }
        }
        try {
            if ($TreeObject.GetType().Name -eq 'TreeView' ){
                if ($ControlType -eq 'Form') {
                    $Script:refs['lst_AssignedEvents'].Items.Clear()
                    $Script:refs['lst_AssignedEvents'].Items.Add('No Events')
                    $Script:refs['lst_AssignedEvents'].Enabled = $false
                    $newTreeNode = $TreeObject.Nodes.Add($ControlName,"Form - $($ControlName)")
                    $form = New-Object System.Windows.Forms.Form
                    $form.Name = $ControlName
                    $form.text = $ControlName
                    $form.Height = 600
                    $form.Width = 800
                    $form.Location = New-Object System.Drawing.Point(0,0)
                    $form.Add_FormClosing({
                        param($Sender,$e)
                        $e.Cancel = $true
                    })
                    
                    $form.Add_MouseEnter({$Script:refs['tsl_StatusLabel'].text ="Current DPIScale: $ctscale"})
                    $form.Add_Click({
                        if (($Script:refs['PropertyGrid'].SelectedObject -ne $this ) -and ( $args[1].Button -eq 'Left')) {
                            $Script:refs['TreeView'].SelectedNode = $Script:refsFID.Form.TreeNodes[$this.Name]
                        }
                    })
                    $form.Add_ReSize({
                        if ($Script:refs['PropertyGrid'].SelectedObject -ne $this) {
                            $Script:refs['TreeView'].SelectedNode = $Script:refsFID.Form.TreeNodes[$this.Name]
                        }
                        $Script:refs['PropertyGrid'].Refresh()
                        $this.ParentForm.Refresh()
                    })
                    $form.Add_LocationChanged({
                        $this.ParentForm.Refresh()
                    })
                    $form.Add_ReSizeEnd({
                        if ($Script:refs['PropertyGrid'].SelectedObject -ne $this) {
                            $Script:refs['TreeView'].SelectedNode = $Script:refsFID.Form.TreeNodes[$this.Name]
                        }
                        $Script:refs['PropertyGrid'].Refresh()
                        $this.ParentForm.Refresh()
                    })
                    $Script:sButtons = $null
                    Remove-Variable -Name sButtons -Scope Script -ErrorAction SilentlyContinue
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_SizeAll" Cursor="SizeAll" BackColor="White" Size="8,8" Visible="False" />'
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_TLeft" Cursor="SizeNWSE" BackColor="White" Size="8,8" Visible="False" />'
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_TRight" Cursor="SizeNESW" BackColor="White" Size="8,8" Visible="False" />'
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_BLeft" Cursor="SizeNESW" BackColor="White" Size="8,8" Visible="False" />'
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_BRight" Cursor="SizeNWSE" BackColor="White" Size="8,8" Visible="False" />'
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_MLeft" Cursor="SizeWE" BackColor="White" Size="8,8" Visible="False" />'
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_MRight" Cursor="SizeWE" BackColor="White" Size="8,8" Visible="False" />'
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_MTop" Cursor="SizeNS" BackColor="White" Size="8,8" Visible="False" />'
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_MBottom" Cursor="SizeNS" BackColor="White" Size="8,8" Visible="False" />'
                    $sButtons.GetEnumerator().ForEach({
                        $_.Value.Add_MouseMove({
                            param($Sender, $e)
                            try {
                                $currentMousePOS = [System.Windows.Forms.Cursor]::Position
                                if (($e.Button -eq 'Left') -and (($currentMousePOS.X -ne $Script:oldMousePOS.X) -or ($currentMousePOS.Y -ne $Script:oldMousePOS.Y))) {
                                    if (@('SplitterPanel','TabPage') -notcontains $Script:refs['PropertyGrid'].SelectedObject.GetType().Name) {
                                        $sObj = $Script:sRect
                                        $msObj = @{}
                                        switch ($Sender.Name) {
                                                btn_SizeAll {
                                                    if ((@('FlowLayoutPanel','TableLayoutPanel') -contains $Script:refs['PropertyGrid'].SelectedObject.Parent.GetType().Name) -or ($Script:refs['PropertyGrid'].SelectedObject.Dock -ne 'None')) {
                                                        $msObj.LocOffset = New-Object System.Drawing.Point(0,0)
                                                    } else {
                                                        $msObj.LocOffset = New-Object System.Drawing.Point(($currentMousePOS.X - $Script:oldMousePOS.X),($currentMousePOS.Y - $Script:oldMousePOS.Y))
                                                    }
                                                    $newSize = $Script:sRect.Size
                                                }
                                                btn_TLeft {
                                                    $msObj.LocOffset = New-Object System.Drawing.Point(($currentMousePOS.X - $Script:oldMousePOS.X),($currentMousePOS.Y - $Script:oldMousePOS.Y))
                                                    $newSize = New-Object System.Drawing.Size(($sObj.Size.Width + $Script:oldMousePOS.X - $currentMousePOS.X),($sObj.Size.Height + $Script:oldMousePOS.Y - $currentMousePOS.Y))
                                                }
                                                btn_TRight {
                                                    $msObj.LocOffset = New-Object System.Drawing.Point(0,($currentMousePOS.Y - $Script:oldMousePOS.Y))
                                                    $newSize = New-Object System.Drawing.Size(($sObj.Size.Width + $currentMousePOS.X - $Script:oldMousePOS.X),($sObj.Size.Height + $Script:oldMousePOS.Y - $currentMousePOS.Y))
                                                }
                                                btn_BLeft {
                                                    $msObj.LocOffset = New-Object System.Drawing.Point(($currentMousePOS.X - $Script:oldMousePOS.X),0)
                                                    $newSize = New-Object System.Drawing.Size(($sObj.Size.Width + $Script:oldMousePOS.X - $currentMousePOS.X),($sObj.Size.Height + $currentMousePOS.Y - $Script:oldMousePOS.Y))
                                                }
                                                btn_BRight {
                                                    $msObj.LocOffset = New-Object System.Drawing.Point(0,0)
                                                    $newSize = New-Object System.Drawing.Size(($sObj.Size.Width + $currentMousePOS.X - $Script:oldMousePOS.X),($sObj.Size.Height + $currentMousePOS.Y - $Script:oldMousePOS.Y))
                                                }
                                                btn_MLeft {
                                                    $msObj.LocOffset = New-Object System.Drawing.Point(($currentMousePOS.X - $Script:oldMousePOS.X),0)
                                                    $newSize = New-Object System.Drawing.Size(($sObj.Size.Width + $Script:oldMousePOS.X - $currentMousePOS.X),$sObj.Size.Height)
                                                }
                                                btn_MRight {
                                                    $msObj.LocOffset = New-Object System.Drawing.Point(0,0)
                                                    $newSize = New-Object System.Drawing.Size(($sObj.Size.Width + $currentMousePOS.X - $Script:oldMousePOS.X),$sObj.Size.Height)
                                                }
                                                btn_MTop {
                                                    $msObj.LocOffset = New-Object System.Drawing.Point(0,($currentMousePOS.Y - $Script:oldMousePOS.Y))
                                                    $newSize = New-Object System.Drawing.Size($sObj.Size.Width,($sObj.Size.Height + $Script:oldMousePOS.Y - $currentMousePOS.Y))
                                                }
                                                btn_MBottom {
                                                    $msObj.LocOffset = New-Object System.Drawing.Point(0,0)
                                                    $newSize = New-Object System.Drawing.Size($sObj.Size.Width,($sObj.Size.Height + $currentMousePOS.Y - $Script:oldMousePOS.Y))
                                                }
                                        }
                                        $msObj.Size = $newSize
                                        $Script:MouseMoving = $true
                                        Move-SButtons -Object $msObj
                                        $Script:MouseMoving = $false
                                        $refFID = $Script:refsFID.Form.Objects.Values.Where({$_.GetType().Name -eq 'Form'})
                                        $clientParent = $Script:refs['PropertyGrid'].SelectedObject.Parent.PointToClient([System.Drawing.Point]::Empty)
                                        $clientForm = $refFID.PointToClient([System.Drawing.Point]::Empty)
                                        $newLocation = New-Object System.Drawing.Point(($Script:sRect.Location.X - (($clientParent.X - $clientForm.X) * -1)),($Script:sRect.Location.Y - (($clientParent.Y - $clientForm.Y) * -1)))
                                        $Script:refs['PropertyGrid'].SelectedObject.Size = $Script:sRect.Size
                                        $Script:refs['PropertyGrid'].SelectedObject.Location = $newLocation
                                    }
                                    $Script:oldMousePos = $currentMousePOS
                                    $Script:refs['PropertyGrid'].Refresh()
                                } 
                                else {
                                    $Script:oldMousePos = [System.Windows.Forms.Cursor]::Position
                                }
                            }
                            catch {
                                Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered while moving mouse over selected control."
                            }
                        })
                        $_.Value.Add_MouseUp({
                           #do not uncomment # Move-SButtons -Object $Script:refs['PropertyGrid'].SelectedObject
                        })
                    })
                    $form.MDIParent = $refs['MainForm']
                    $form.Show()
                    $Script:refsFID = @{
                        Form = @{
                            TreeNodes=@{"$($ControlName)" = $newTreeNode}
                            Objects=@{"$($ControlName)" = $form}
                            Changes=@{}
                            Events=@{}
                        }
                    }
                } 
                elseif ((@('ContextMenuStrip','Timer') -contains $ControlType) -or ($ControlType -match "Dialog$")) {
                    $newTreeNode = $Script:refs['TreeView'].Nodes.Add($ControlName,"$($ControlType) - $($ControlName)")
                    if ($null -eq $Script:refsFID[$ControlType]){
                        $Script:refsFID[$ControlType]=@{}
                    }
                    $Script:refsFID[$ControlType][$ControlName] = @{
                        TreeNodes = @{"$($ControlName)" = $newTreeNode}
                        Objects = @{"$($ControlName)" = New-Object System.Windows.Forms.$ControlType}
                        Changes = @{}
                        Events = @{}
                    }
                }
            } 
            else {
                if (($ControlName -ne '') -and ($ControlType -ne 'SplitterPanel')){
                    $objRef = Get-RootNodeObjRef -TreeNode $TreeObject
                    if ($objRef.Success -ne $false) {
                        $newControl = New-Object System.Windows.Forms.$ControlType
                        $newControl.Name = $ControlName
                        switch ($ControlType){
                            'DateTimePicker'{}
                            'WebBrowser'{}
                            default{$newControl.Text = $controlText}
                        }
                        if ($newControl.height){
                            $newControl.height = $newControl.height * $ctscale
                        }
                        if ($newControl.width){
                            $newControl.width = $newControl.width * $ctscale
                        }
                        if ($newControl.ImageScalingSize) {
                            $newControl.imagescalingsize = new-object System.Drawing.Size([int]($ctscale * $newControl.imagescalingsize.width),[int]($ctscale * $newControl.imagescalingsize.Height))
                        } 
                    if ( $ControlType -eq "ToolStrip" ) {
                        $objRef.Objects[$TreeObject.Name].Controls.Add($newControl)
                    }
                    else{
                        if ($ControlType -match "^ToolStrip") {
                            if ($objRef.Objects[$TreeObject.Name].GetType().Name -match "^ToolStrip") {
                                if ($objRef.Objects[$TreeObject.Name].GetType().ToString() -eq "System.Windows.Forms.ToolStrip"){
                                    [void]$objRef.Objects[$TreeObject.Name].Items.Add($newControl)
                                }
                                else {
                                    [void]$objRef.Objects[$TreeObject.Name].DropDownItems.Add($newControl)
                                }
                            }
                            else {
                                [void]$objRef.Objects[$TreeObject.Name].Items.Add($newControl)
                            }
                        } 
                        elseif ($ControlType -eq 'ContextMenuStrip') {
                            $objRef.Objects[$TreeObject.Name].ContextMenuStrip = $newControl
                        } 
                        else {
                            $objRef.Objects[$TreeObject.Name].Controls.Add($newControl)
                        }
                    }
                        if ($ControlType -ne 'WebBrowser'){                     
                            try {
                                $newControl.Add_MouseUp({
                                    if (( $Script:refs['PropertyGrid'].SelectedObject -ne $this ) -and ( $args[1].Button -eq 'Left' )) {
                                        $Script:refs['TreeView'].SelectedNode = $Script:refsFID.Form.TreeNodes[$this.Name]
                                    }
                                })
                            } 
                            catch {
                                if ($_.Exception.Message -notmatch 'not valid on this control') {
                                    throw $_
                                }
                            }
                        }
                        $newTreeNode = $TreeObject.Nodes.Add($ControlName,"$($ControlType) - $($ControlName)")
                        $objRef.TreeNodes[$ControlName] = $newTreeNode
                        $objRef.Objects[$ControlName] = $newControl
                        if ($ControlType -eq 'SplitContainer') {
                            for ( $i=1;$i -le 2;$i++ ) {
                                $objRef.TreeNodes["$($ControlName)_Panel$($i)"] = $newTreeNode.Nodes.Add("$($ControlName)_Panel$($i)","SplitterPanel - $($ControlName)_Panel$($i)")
                                $objRef.Objects["$($ControlName)_Panel$($i)"] = $newControl."Panel$($i)"
                                $objRef.Objects["$($ControlName)_Panel$($i)"].Name = "$($ControlName)_Panel$($i)"
                                $objRef.Objects["$($ControlName)_Panel$($i)"].Add_MouseDown({
                                    if (( $Script:refs['PropertyGrid'].SelectedObject -ne $this ) -and ( $args[1].Button -eq 'Left' )) {
                                        $Script:refs['TreeView'].SelectedNode = $Script:refsFID.Form.TreeNodes[$this.Name]
                                    }
                                })
                            }
                            $newTreeNode.Expand()
                        }
                    }
                }
            }
            if ($newTreeNode) {
                $newTreeNode.ContextMenuStrip = $Script:reuseContext['TreeNode']
                $Script:refs['TreeView'].SelectedNode = $newTreeNode
                if (( $ControlType -eq 'TabControl' ) -and ( $Script:openingProject -eq $false )) {
                    Add-TreeNode -TreeObject $newTreeNode -ControlType TabPage -ControlName 'Tab 1'
                }
            }
        } 
        catch {
            Update-ErrorLog -ErrorRecord $_ -Message "Unable to add $($ControlName) to $($objRef.Objects[$TreeObject.Name])."
        }
    }

    function Get-ChildNodeList {
        param(
            $TreeNode,
            [switch]$Level
        )
        $returnVal = @()
        if ($TreeNode.Nodes.Count -gt 0) {
            try {
                $TreeNode.Nodes.ForEach({
                    $returnVal += $(if ($Level) { "$($_.Level):$($_.Name)" } else {$_.Name})
                    $returnVal += $(if ( $Level ) { Get-ChildNodeList -TreeNode $_ -Level } else { Get-ChildNodeList -TreeNode $_ })
                })
            } 
            catch {
                Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered building Treenode list."
            }
        }
        return $returnVal
    }

    function Get-RootNodeObjRef {
        param(
            [System.Windows.Forms.TreeNode]$TreeNode
        )
        try {
            if ($TreeNode.Level -gt 0) {
                while ($TreeNode.Parent) {
                    $TreeNode = $TreeNode.Parent
                }
            }
            $type = $TreeNode.Text -replace " - .*$"
            $name = $TreeNode.Name
            $returnVal = [pscustomobject]@{
                Success = $true
                RootType = $type
                RootName = $name
                TreeNodes = ''
                Objects = ''
                Changes = ''
                Events = ''
            }

            if ($type -eq 'Form') {
                $returnVal.TreeNodes = $Script:refsFID[$type].TreeNodes
                $returnVal.Objects = $Script:refsFID[$type].Objects
                $returnVal.Changes = $Script:refsFID[$type].Changes
                $returnVal.Events = $Script:refsFID[$type].Events
            } 
            elseif ((@('ContextMenuStrip','Timer') -contains $type) -or ($type -match "Dialog$")) {
                $returnVal.TreeNodes = $Script:refsFID[$type][$name].TreeNodes
                $returnVal.Objects = $Script:refsFID[$type][$name].Objects
                $returnVal.Changes = $Script:refsFID[$type][$name].Changes
                $returnVal.Events = $Script:refsFID[$type][$name].Events
            } 
            else {
                $returnVal.Success = $false
            }
            return $returnVal
        } 
        catch {
            Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered determining root node object reference."
        }
    }

    function Move-SButtons {
        param($Object)
            if ($Object.GetType().Name -eq 'ToolStripProgressBar') {
                return
            }
        if (($Script:supportedControls.Where({
            $_.Type -eq 'Parentless'
        }).Name + @('Form','ToolStripMenuItem','ToolStripComboBox','ToolStripTextBox','ToolStripSeparator','ContextMenuStrip')) -notcontains $Object.GetType().Name ) {     
          $newSize = $Object.Size
            if ($Object.GetType().Name -ne 'HashTable') {
                $refFID = $Script:refsFID.Form.Objects.Values.Where({$_.GetType().Name -eq 'Form'})
                $Script:sButtons.GetEnumerator().ForEach({$_.Value.Visible = $true})
                $newLoc = $Object.PointToClient([System.Drawing.Point]::Empty)
                if ( $Script:MouseMoving -eq $true ) {
                    $clientParent = $Object.Parent.PointToClient([System.Drawing.Point]::Empty)
                    $clientForm = $refFID.PointToClient([System.Drawing.Point]::Empty)
                    $clientOffset = New-Object System.Drawing.Point((($clientParent.X - $clientForm.X) * -1),(($clientParent.Y - $clientForm.Y) * -1))
                } 
                else {
                    $clientOffset = New-Object System.Drawing.Point((($clientParent.X - $clientForm.X) * -1),(($clientParent.Y - $clientForm.Y) * -1))
                }
                if ($Object.Parent.WindowState -eq "Maximized"){
                    $newLoc.X = ($newLoc.X * -1) - $refFID.Location.X - $refs['MainForm'].Location.X - $clientOffset.X - $Script:refs['ms_Left'].Size.Width - [math]::Round((15 * $ctscale))
                    $newLoc.Y = ($newLoc.Y * -1) - $refFID.Location.Y - $refs['MainForm'].Location.Y - (20 * $ctscale) - ($clientOffset.Y * $ctscale) - [math]::Round(((148 * $ctscale) - (($ctscale * 16)*$ctscale)) + (2 - ($ctscale)))
                }
                else{
                    $newLoc.X = ($newLoc.X * -1) - $refFID.Location.X - $refs['MainForm'].Location.X - $clientOffset.X - $Script:refs['ms_Left'].Size.Width - [math]::Round((15 * $ctscale))
                    $newLoc.Y = ($newLoc.Y * -1) - $refFID.Location.Y - $refs['MainForm'].Location.Y - ($clientOffset.Y * $ctscale) - [math]::Round((148 * $ctscale) - (($ctscale * 16)*$ctscale) + (2 - ($ctscale)))
                }
                if ($Script:refs['pnl_Left'].Visible -eq $true) {
                    $newLoc.X = $newLoc.X - $Script:refs['pnl_Left'].Size.Width - $Script:refs['lbl_Left'].Size.Width
                }
            } 
            else {
                $newLoc = New-Object System.Drawing.Point(($Script:sButtons['btn_TLeft'].Location.X + $Object.LocOffset.X),($Script:sButtons['btn_TLeft'].Location.Y + $Object.LocOffset.Y))
            }
            $Script:sRect = New-Object System.Drawing.Rectangle($newLoc,$newSize)
            $Script:sButtons.GetEnumerator().ForEach({
                $btn = $_.Value
                switch ($btn.Name) {
                    btn_SizeAll {$btn.Location = New-Object System.Drawing.Point(($newLoc.X + 13),$newLoc.Y)}
                    btn_TLeft {$btn.Location = New-Object System.Drawing.Point($newLoc.X,$newLoc.Y)}
                    btn_TRight {$btn.Location = New-Object System.Drawing.Point(($newLoc.X + $newSize.Width - 8),$newLoc.Y)}
                    btn_BLeft {$btn.Location = New-Object System.Drawing.Point($newLoc.X,($newLoc.Y + $newSize.Height - 8))}
                    btn_BRight {$btn.Location = New-Object System.Drawing.Point(($newLoc.X + $newSize.Width - 8),($newLoc.Y + $newSize.Height - 8))}
                    btn_MLeft {
                        if ( $Object.Size.Height -gt 28 ) {
                            $btn.Location = New-Object System.Drawing.Point($newLoc.X,($newLoc.Y + ($newSize.Height / 2) - 4))
                            $btn.Visible = $true
                        } 
                        else {
                            $btn.Visible = $false
                        }
                    }
                    btn_MRight {
                        if ( $Object.Size.Height -gt 28 ) {
                            $btn.Location = New-Object System.Drawing.Point(($newLoc.X + $newSize.Width - 8),($newLoc.Y + ($newSize.Height / 2) - 4))
                            $btn.Visible = $true
                        } 
                        else {
                            $btn.Visible = $false
                        }
                    }
                    btn_MTop {
                        if ( $Object.Size.Width -gt 40 ) {
                            $btn.Location = New-Object System.Drawing.Point(($newLoc.X + ($newSize.Width / 2) - 4),$newLoc.Y)
                            $btn.Visible = $true
                        } 
                        else {
                            $btn.Visible = $false
                        }
                    }
                    btn_MBottom {
                        if ( $Object.Size.Width -gt 40 ) {
                            $btn.Location = New-Object System.Drawing.Point(($newLoc.X + ($newSize.Width / 2) - 4),($newLoc.Y + $newSize.Height - 8))
                            $btn.Visible = $true
                        } 
                        else {
                            $btn.Visible = $false
                        }
                    }
                }
                $btn.BringToFront()
                $btn.Refresh()
            })

            $Script:refs['PropertyGrid'].SelectedObject.Refresh()
            $Script:refs['PropertyGrid'].SelectedObject.Parent.Refresh()
        }
        else {
            $Script:sButtons.GetEnumerator().ForEach({
                $_.Value.Visible = $false
            })
        }
    }

    function Save-Project {
        param(
            [switch]$SaveAs,
            [switch]$Suppress,
            [switch]$ReturnXML
        )
        $projectName = $refs['tpg_Form1'].Text
        if ($ReturnXML -eq $false) {
            if (($SaveAs) -or ($projectName -eq 'NewProject.fbs')) {
                $saveDialog = ConvertFrom-WinFormsXML -Xml @"
<SaveFileDialog InitialDirectory="$($Script:projectsDir)" AddExtension="True" DefaultExt="fbs" Filter="fbs files (*.fbs)|*.fbs" FileName="$($projectName)" OverwritePrompt="True" ValidateNames="True" RestoreDirectory="True" />
"@
                $saveDialog.Add_FileOK({
                    param($Sender,$e)
                    if ($($this.FileName | Split-Path -Leaf) -eq 'NewProject.fbs') {
                        [void][System.Windows.Forms.MessageBox]::Show("You cannot save a project with the file name 'NewProject.fbs'",'Validation Error')
                        $e.Cancel = $true
                    }
                })
                try {
                    [void]$saveDialog.ShowDialog()
                    if (( $saveDialog.FileName -ne '') -and ($saveDialog.FileName -ne 'NewProject.fbs')) {
                        $projectName = $saveDialog.FileName | Split-Path -Leaf
                    } else {
                        $projectName = ''
                    }
                } 
                catch {
                    Update-ErrorLog -ErrorRecord $_ -Message 'Exception encountered while selecting Save file name.'
                    $projectName = ''
                } 
                finally {
                    $saveDialog.Dispose()
#brandoncomputer_SaveDialogFix
                    $global:projectDirName = $saveDialog.FileName
                    Remove-Variable -Name saveDialog
                }
            }
        }

        if ($projectName -ne '') {
            try {
                $xml = New-Object -TypeName XML
                $xml.LoadXml('<Data><Events Desc="Events associated with controls"></Events><Functions Desc="Functions associated with project"></Functions></Data>')
                $tempPGrid = New-Object System.Windows.Forms.PropertyGrid
                $tempPGrid.PropertySort = 'Alphabetical'
                $Script:refs['TreeView'].Nodes.ForEach({
                    $currentNode = $xml.Data
                    $rootControlType = $_.Text -replace " - .*$"
                    $rootControlName = $_.Name
                    $objRef = Get-RootNodeObjRef -TreeNode $($Script:refs['TreeView'].Nodes | Where-Object { $_.Name -eq $rootControlName -and $_.Text -match "^$($rootControlType)" })
                    $nodeIndex = @("0:$($rootControlName)")
                    $nodeIndex += Get-ChildNodeList -TreeNode $objRef.TreeNodes[$rootControlName] -Level
                    @(0..($nodeIndex.Count-1)).ForEach({
                        $nodeName = $nodeIndex[$_] -replace "^\d+:"
                        $newElementType = $objRef.Objects[$nodeName].GetType().Name
                        [int]$nodeDepth = $nodeIndex[$_] -replace ":.*$"
                        $newElement = $xml.CreateElement($newElementType)
                        $newElement.SetAttribute("Name",$nodeName)
                        $tempPGrid.SelectedObject = $objRef.Objects[$nodeName]
                        $Script:specialProps.Before.ForEach({
                            $prop = $_
                            $tempGI = $tempPGrid.SelectedGridItem.Parent.GridItems.Where({$_.PropertyLabel -eq $prop})

                            if ($tempGI.Count -gt 0) {
                                if ($tempGI.PropertyDescriptor.ShouldSerializeValue($tempGI.Component)) {
                                    $newElement.SetAttribute($tempGI.PropertyLabel,$tempGI.GetPropertyTextValue())
                                }
                            }
                        })
                        $tempPGrid.SelectedGridItem.Parent.GridItems.ForEach({
                            $checkReflector = $true
                            $tempGI = $_
                            if ($Script:specialProps.All -contains $tempGI.PropertyLabel) {
                                switch ($tempGI.PropertyLabel) {
                                    Location {
                                        if (($tempPGrid.SelectedObject.Dock -ne 'None') -or
                                           ($tempPGrid.SelectedObject.Parent.GetType().Name -eq 'FlowLayoutPanel') -or
                                           (($newElementType -eq 'Form') -and ($tempPGrid.SelectedObject.StartPosition -ne 'Manual')) -or
                                           ($tempGI.GetPropertyTextValue() -eq '0, 0')) {
                                            $checkReflector = $false
                                        }
                                    }
                                    Size {
                                        if (($tempPGrid.SelectedObject.AutoSize -eq $true) -or ( $tempPGrid.SelectedObject.Dock -eq 'Fill')) {
                                            if (( $tempPGrid.SelectedObject.AutoSize -eq $true ) -and ( $tempPGrid.SelectedObject.Enabled -eq $false )) {
                                                $tempPGrid.SelectedObject.Enabled = $true
                                                if ($tempGI.PropertyDescriptor.ShouldSerializeValue($tempGI.Component)) {
                                                    $newElement.SetAttribute($tempGI.PropertyLabel,$tempGI.GetPropertyTextValue())
                                                }
                                                $tempPGrid.SelectedObject.Enabled = $false
                                            }
                                            $checkReflector = $false
                                            if (($newElementType -eq 'Textbox') -and ($tempPGrid.SelectedObject.Size.Width -ne 100)) {
                                                $checkReflector = $true
                                            }
                                        }
                                        if (($newElementType -eq 'Form') -and ($tempPGrid.SelectedObject.Size -eq (New-Object System.Drawing.Size(300,300)))) {
                                            $checkReflector = $false
                                        }
                                    }
                                    FlatAppearance {
                                        if ($tempPGrid.SelectedObject.FlatStyle -eq 'Flat') {
                                            $value = ''
                                            $tempGI.GridItems.ForEach({
                                                if ( $_.PropertyDescriptor.ShouldSerializeValue($_.Component.FlatAppearance) ) {$value += "$($_.PropertyLabel)=$($_.GetPropertyTextValue())|"}
                                            })
                                            if ($value -ne '') {
                                                $newElement.SetAttribute('FlatAppearance',$($value -replace "\|$"))
                                            }
                                        }
                                        $checkReflector = $false
                                    }
                                    default {
                                        if (($Script:specialProps.BadReflector -contains $_) -and ( $null -ne $objRef.Changes[$_] )) {
                                            $newElement.SetAttribute($_,$objRef.Changes[$_])
                                        }
                                        $checkReflector = $false
                                    }
                                }
                            }

                            if ($checkReflector) {
                                if ( $tempGI.PropertyDescriptor.ShouldSerializeValue($tempGI.Component) ) {
                                    $newElement.SetAttribute($tempGI.PropertyLabel,$tempGI.GetPropertyTextValue())
                                }
                                elseif (( $newElementType -eq 'Form' ) -and ( $tempGI.PropertyLabel -eq 'Size') -and ( $tempPGrid.SelectedObject.AutoSize -eq $false )) {
                                    $newElement.SetAttribute($tempGI.PropertyLabel,$tempGI.GetPropertyTextValue())
                                }
                            }
                            [void]$currentNode.AppendChild($newElement)
                        })

                            # Set certain properties last
                        $Script:specialProps.After.ForEach({
                            $prop = $_
                            $tempGI = $tempPGrid.SelectedGridItem.Parent.GridItems.Where({$_.PropertyLabel -eq $prop})

                            if ( $tempGI.Count -gt 0 ) {
                                if ( $Script:specialProps.Array -contains $prop ) {
                                    if ( $prop -eq 'Items' ) {
                                        if ( $objRef.Objects[$nodeName].Items.Count -gt 0 ) {
                                            if ( @('CheckedListBox','ListBox','ComboBox','ToolStripComboBox') -contains $newElementType ) {
                                                $value = ''
                                                $objRef.Objects[$nodeName].Items.ForEach({$value += "$($_)|*BreakPT*|"})
                                                $newElement.SetAttribute('Items',$($value -replace "\|\*BreakPT\*\|$"))
                                            } 
                                            else {
                                                switch ($newElementType) {
                                                    'MenuStrip' {}
                                                    'ContextMenuStrip' {}
                                                    'StatusStrip'{}
                                                    'ToolStrip'{}
                                                    #'ListView' {}
                                                    default {if ( $ReturnXML -eq $false ) {[void][System.Windows.Forms.MessageBox]::Show("$($newElementType) items will not save",'Notification')}}
                                                }
                                            }
                                        }
                                    } 
                                    else {
                                        if ( $objRef.Objects[$nodeName].$prop.Count -gt 0 ) {
                                            $value = ''
                                            $objRef.Objects[$nodeName].$prop.ForEach({$value += "$($_)|*BreakPT*|"})
                                            $newElement.SetAttribute($prop,$($value -replace "\|\*BreakPT\*\|$"))
                                        }
                                    }
                                } 
                                else {
                                    if ( $tempGI.PropertyDescriptor.ShouldSerializeValue($tempGI.Component) ) {$newElement.SetAttribute($tempGI.PropertyLabel,$tempGI.GetPropertyTextValue())}
                                }
                            }
                        })

                            # Set assigned Events
                        if ( $objRef.Events[$nodeName] ) {
                            $newEventElement = $xml.CreateElement($newElementType)
                            $newEventElement.SetAttribute('Name',$nodeName)
                            $newEventElement.SetAttribute('Root',"$($objRef.RootType)|$rootControlName")
                            $eventString = ''
                            $objRef.Events[$nodeName].ForEach({$eventString += "$($_) "})
                            $newEventElement.SetAttribute('Events',$($eventString -replace " $"))
                            [void]$xml.Data.Events.AppendChild($newEventElement)
                        }
                        
                           # Set $currentNode for the next iteration
                        if ( $_ -lt ($nodeIndex.Count-1) ) {
                            [int]$nextNodeDepth = "$($nodeIndex[($_+1)] -replace ":.*$")"
                            if ( $nextNodeDepth -gt $nodeDepth ) {$currentNode = $newElement}
                            elseif ( $nextNodeDepth -lt $nodeDepth ) {@(($nodeDepth-1)..$nextNodeDepth).ForEach({$currentNode = $currentNode.ParentNode})}
                        }
                    })
                })
                foreach ($item in $lst_Functions.items){
                    $checkItem = $lst_Functions.GetItemCheckState($lst_Functions.Items.IndexOf($item)).ToString()
                    $i = $lst_Functions.Items.IndexOf($item)
                    if ($checkItem -eq 'Checked') {
                        $newFunctionElement = $xml.CreateElement('Function')
                        $newFunctionElement.SetAttribute('Name',$item.ToString())
                        [void]$xml.Data.Functions.AppendChild($newFunctionElement)
                    }
                }       
                $nodes = $xml.SelectNodes('//*')
                foreach ($node in $nodes) {
                    if ($node.Size){
                        $n = ($node.Size).split(',')
                        $n[0] = [math]::round(($n[0]/1) / $ctscale)
                        $n[1] = [math]::round(($n[1]/1) / $ctscale)
                        if ("$($n[0]),$($n[1])" -ne ",") {
                            $node.Size = "$($n[0]),$($n[1])"
                        }
                    }
                    if ($node.Location){
                        $n = ($node.Location).split(',')
                        $n[0] = [math]::round(($n[0]/1) / $ctscale)
                        $n[1] = [math]::round(($n[1]/1) / $ctscale)
                        if ("$($n[0]),$($n[1])" -ne ",") {
                            $node.Location = "$($n[0]),$($n[1])"
                        }
                    }
                    if ($node.MaximumSize){
                        $n = ($node.MaximumSize).split(',')
                        $n[0] = [math]::round(($n[0]/1) / $ctscale)
                        $n[1] = [math]::round(($n[1]/1) / $ctscale)
                        if ("$($n[0]),$($n[1])" -ne ",") {
                            $node.MaximumSize = "$($n[0]),$($n[1])"
                        }
                    }
                    if ($node.MinimumSize){
                        $n = ($node.MinimumSize).split(',')
                        $n[0] = [math]::round(($n[0]/1) / $ctscale)
                        $n[1] = [math]::round(($n[1]/1) / $ctscale)
                        if ("$($n[0]),$($n[1])" -ne ",") {
                            $node.MinimumSize = "$($n[0]),$($n[1])"
                        }
                    }
                    if ($node.ImageScalingSize){
                        $n = ($node.ImageScalingSize).split(',')
                        $n[0] = [math]::round(($n[0]/1) / $ctscale)
                        $n[1] = [math]::round(($n[1]/1) / $ctscale)
                        if ("$($n[0]),$($n[1])" -ne ",") {
                            $node.ImageScalingSize = "$($n[0]),$($n[1])"
                        }
                    }
                    $nodes.RemoveAttribute('ContextMenuStrip')
                    $nodes.RemoveAttribute('Image')
                    $nodes.RemoveAttribute('Icon')
                    $nodes.RemoveAttribute('BackgroundImage')
                    $nodes.RemoveAttribute('ErrorImage')
                    $nodes.RemoveAttribute('InitialImage')
                }
                if ( $ReturnXML ) {return $xml}
                else {
                    $xml.Save($global:projectDirName)
                    $refs['tpg_Form1'].Text = $projectName
                    $generationPath = "$(Split-Path -Path $global:projectDirName)\$($projectName -replace "\..*$")"
                    if (Test-Path -path $generationPath) {
                    }
                    else {
                        New-Item -ItemType directory -Path $generationPath
                    }
                    $utf8 = [System.Text.Encoding]::UTF8
                    $FastText.SaveToFile("$generationPath\Events.ps1",$utf8)
                    Assert-List $lst_Find SaveFile "$generationPath\Finds.txt"
                    if ( $Suppress -eq $false ) {$Script:refs['tsl_StatusLabel'].text = 'Successfully Saved!'}
                }
            } 
            catch {
                if ( $ReturnXML ) {
                    Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered while generating Form XML."
                    return $xml
                }
                else {
                    Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered while saving project."
                }
            } 
            finally {
                if ( $tempPGrid ) {
                    $tempPGrid.Dispose()
                }
            }
        } 
        else {
            throw 'SaveCancelled'
        }
    }
 
    function ChangeView {($e, $r)
        try {
            switch ($this.Text) {
                'Toolbox' {
                    $pnlChanged = $refs['pnl_Left']
                    $sptChanged = $refs['spt_Left']
                    $tsViewItem = $refs['Toolbox']
                    $tsMenuItem = $refs['ms_Toolbox']
                    $tsBtn = $tsToolBoxBtn
                    $thisNum = '1'
                    $otherNum = '2'
                    $side = 'Left'
                }
                'Form Tree' {
                    $pnlChanged = $refs['pnl_Left']
                    $sptChanged = $refs['spt_Left']
                    $tsViewItem = $refs['FormTree']
                    $tsMenuItem = $refs['ms_FormTree']
                    $tsBtn = $tsFormTreeBtn
                    $thisNum = '2'
                    $otherNum = '1'
                    $side = 'Left'
                }
                'Properties' {
                    $pnlChanged = $refs['pnl_Right']
                    $sptChanged = $refs['spt_Right']
                    $tsViewItem = $refs['Properties']
                    $tsMenuItem = $refs['ms_Properties']
                    $tsBtn = $tsPropertiesBtn
                    $thisNum = '1'
                    $otherNum = '2'
                    $side = 'Right'
                }
                'Events' {
                    $pnlChanged = $refs['pnl_Right']
                    $sptChanged = $refs['spt_Right']
                    $tsViewItem = $refs['Events']
                    $tsMenuItem = $refs['ms_Events']
                    $tsBtn = $tsEventsBtn
                    $thisNum = '2'
                    $otherNum = '1'
                    $side = 'Right'
                }
            }
            if (( $pnlChanged.Visible ) -and ( $sptChanged."Panel$($thisNum)Collapsed" )) {
                $sptChanged."Panel$($thisNum)Collapsed" = $false
                $tsViewItem.Checked = $true
                $tsBtn.Checked = $true
                $tsMenuItem.BackColor = 'RoyalBlue'
            } 
            elseif (( $pnlChanged.Visible ) -and ( $sptChanged."Panel$($thisNum)Collapsed" -eq $false )) {
                $tsViewItem.Checked = $false
                $tsBtn.Checked = $false
                $tsMenuItem.BackColor = 'MidnightBlue'
                if ( $sptChanged."Panel$($otherNum)Collapsed" ) {$pnlChanged.Visible = $false} else {$sptChanged."Panel$($thisNum)Collapsed" = $true}
            } 
            else {
                $tsViewItem.Checked = $true
                $tsBtn.Checked = $true
                $tsMenuItem.BackColor = 'RoyalBlue'
                $sptChanged."Panel$($thisNum)Collapsed" = $false
                $sptChanged."Panel$($otherNum)Collapsed" = $true
                $pnlChanged.Visible = $true
            }
            if ( $pnlChanged.Visible -eq $true ) {$refs["lbl_$($side)"].Visible = $true} else {$refs["lbl_$($side)"].Visible = $false}
        } 
        catch {
            Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered during View change."
        }
    }
    
    function NewProjectClick {
        try {               
            if ( [System.Windows.Forms.MessageBox]::Show("Unsaved changes to the current project will be lost.  Are you sure you want to start a new project?", 'Confirm', 4) -eq 'Yes' ) {
                $global:control_track = @{}
                $projectName = "NewProject.fbs"
                $FastText.Clear()
                $FastText.SelectedText = "#region Images
                
#endregion

"
                Assert-List $lst_Find Clear
                try{$FastText.CollapseFoldingBlock(0)}catch{}
                $refs['tpg_Form1'].Text = $projectName
                $Script:refs['TreeView'].Nodes.ForEach({
                    $controlName = $_.Name
                    $controlType = $_.Text -replace " - .*$"
                    if ( $controlType -eq 'Form' ) {
                        $Script:refsFID.Form.Objects[$controlName].Dispose()
                    }
                    else {
                        $Script:refsFID[$controlType][$controlName].Objects[$ControlName].Dispose()
                    }
                })
                $Script:refs['TreeView'].Nodes.Clear()
                Add-TreeNode -TreeObject $Script:refs['TreeView'] -ControlType Form -ControlName MainForm
                #brandoncomputer_newResize
                $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].height = $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].height * $ctscale
                $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].width = $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].width * $ctscale
                $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].tag = "VisualStyle,DPIAware"
                $baseicon = $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].Icon          
            }
        } 
        catch {
            Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered during start of New Project."
        }
    }
    
    function OpenProjectClick ([string]$fileName){
        if ($fileName -eq ''){
            if ( [System.Windows.Forms.MessageBox]::Show("You will lose all changes to the current project.  Are you sure?", 'Confirm', 4) -eq 'No' ) {
                return
            }   
            $openDialog = ConvertFrom-WinFormsXML -Xml @"
<OpenFileDialog InitialDirectory="$($Script:projectsDir)" AddExtension="True" DefaultExt="fbs" Filter="fbs files (*.fbs)|*.fbs" FilterIndex="1" ValidateNames="True" CheckFileExists="True" RestoreDirectory="True" />
"@
        }
        try {
            $Script:openingProject = $true
            if ($fileName -eq ''){
                if ( $openDialog.ShowDialog() -ne 'OK' ) {return}
                $fileName = $openDialog.FileName
            }
            if ($fileName) {
                for($i=0; $i -lt $lst_Functions.Items.Count; $i++){
                    $lst_Functions.SetItemChecked($i,$false)
                }
                $global:control_track = @{}
                New-Object -TypeName XML | ForEach-Object {
                   # info $fileName
                    $_.Load("$($fileName)")             
                    $Script:refs['TreeView'].BeginUpdate()
                    $Script:refs['TreeView'].Nodes.ForEach({
                        $controlName = $_.Name
                        $controlType = $_.Text -replace " - .*$"
                        if ( $controlType -eq 'Form' ) {$Script:refsFID.Form.Objects[$controlName].Dispose()}
                        else {$Script:refsFID[$controlType][$controlName].Objects[$ControlName].Dispose()}
                    })
                    $Script:refs['TreeView'].Nodes.Clear()
                    Convert-XmlToTreeView -XML $_.Data.Form -TreeObject $Script:refs['TreeView']
                    $_.Data.ChildNodes.Where({$_.ToString() -notmatch 'Form' -and $_.ToString() -notmatch 'Events'}) | ForEach-Object {Convert-XmlToTreeView -XML $_ -TreeObject $Script:refs['TreeView']}
                    $Script:refs['TreeView'].EndUpdate()
                    if ( $_.Data.Events.ChildNodes.Count -gt 0 ) {
                        $_.Data.Events.ChildNodes | ForEach-Object {
                            $rootControlType = $_.Root.Split('|')[0]
                            $rootControlName = $_.Root.Split('|')[1]
                            $controlName = $_.Name
                            if ( $rootControlType -eq 'Form' ) {
                                $Script:refsFID.Form.Events[$controlName] = @()
                                $_.Events.Split(' ') | ForEach-Object {$Script:refsFID.Form.Events[$controlName] += $_}
                            } else {
                                $Script:refsFID[$rootControlType][$rootControlName].Events[$controlName] = @()
                                $_.Events.Split(' ') | ForEach-Object {$Script:refsFID[$rootControlType][$rootControlName].Events[$controlName] += $_}
                            }
                        }
                    }
                    if ( $_.Data.Functions.ChildNodes.Count -gt 0 ) {
                        $_.Data.Functions.ChildNodes | ForEach-Object {
                            try{
                                $lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf($_.Name),$true)
                            }
                            catch{}
                        }
                    }
                }
                $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode
                if ( $objRef.Events[$Script:refs['TreeView'].SelectedNode.Name] ) {
                    $Script:refs['lst_AssignedEvents'].BeginUpdate()
                    $Script:refs['lst_AssignedEvents'].Items.Clear()
                    [void]$Script:refs['lst_AssignedEvents'].Items.AddRange($objRef.Events[$Script:refs['TreeView'].SelectedNode.Name])
                    $Script:refs['lst_AssignedEvents'].EndUpdate()
                    $Script:refs['lst_AssignedEvents'].Enabled = $true
                }
            }
            $Script:openingProject = $false
            
            if ($fileName) {
                $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].Visible = $true
                $Script:refs['tpg_Form1'].Text = "$($fileName -replace "^.*\\")"
                $Script:refs['TreeView'].SelectedNode = $Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }
                $global:projectDirName = $fileName
                $projectName = $Script:refs['tpg_Form1'].Text
                $generationPath = "$(Split-Path -Path $global:projectDirName)\$($projectName -replace "\..*$")"
                if (Test-Path -path "$generationPath\Events.ps1") {
                    $FastText.OpenFile("$generationPath\Events.ps1")
                    Assert-List $lst_Find Clear
                    try{Assert-List $lst_Find LoadFile "$generationPath\Finds.txt"}catch{}
                    $fastArr = ($FastText.Text).split("
")
                    foreach ($arrItem in $fastArr){
                        $dotSplit = $arrItem.split(".")
                        if ($dotSplit[1]) {
                            $spaceSplit = $dotSplit[1].Split(" ")
                            $baseStr = $arrItem.split(" ")[0]
                            $noCash = $baseStr.split("`$")[1]
                            if ($noCash.count -gt 0) {
                                $Control = $noCash.Split(".")[0]
                                $b64 = $arrItem.split("`"")[1]
                                switch ($spaceSplit[0]) {
                                    'Icon'{
                                        $objRef.Objects[$Control].Icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap][System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String($b64))).GetHicon())
                                    }
                                    'Image'{
                                        $objRef.Objects[$Control].Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String($b64))
                                    }
                                    'BackgroundImage'{
                                        $objRef.Objects[$Control].BackgroundImage = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String($b64))
                                    }
                                    'ErrorImage'{
                                        $objRef.Objects[$Control].ErrorImage = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String($b64))
                                    }
                                    'InitialImage'{
                                        $objRef.Objects[$Control].BackgroundImage = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String($b64))
                                    }
                                }
                            }
                        }
                    }
                }
                try{$FastText.CollapseFoldingBlock(0)}catch{}
            }
        
        } 
        catch {
            Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered while opening $($fileName)."
        }
        finally {
            $Script:openingProject = $false
            
            if ($openDialog){
                $openDialog.Dispose()
                Remove-Variable -Name openDialog
            }

            $Script:refs['TreeView'].Focus()
            
        }
    }
    
    function RenameClick {
        if ( $Script:refs['TreeView'].SelectedNode.Text -notmatch "^SplitterPanel" ) {
            $currentName = $Script:refs['TreeView'].SelectedNode.Name
            $userInput = Get-UserInputFromForm -SetText $currentName

            if ( $userInput.Result -eq 'OK' ) {
                try {
                    $newName = $userInput.NewName
                    $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode
                    $objRef.Objects[$currentName].Name = $newName
                    $objRef.Objects[$newName] = $objRef.Objects[$currentName]
                    $objRef.Objects.Remove($currentName)
                    if ( $objRef.Changes[$currentName] ) {
                        $objRef.Changes[$newName] = $objRef.Changes[$currentName]
                        $objRef.Changes.Remove($currentName)
                    }
                    if ( $objRef.Events[$currentName] ) {
                        $objRef.Events[$newName] = $objRef.Events[$currentName]
                        $objRef.Events.Remove($currentName)
                    }
                    $objRef.TreeNodes[$currentName].Name = $newName
                    $objRef.TreeNodes[$currentName].Text = $Script:refs['TreeView'].SelectedNode.Text -replace "-.*$","- $($newName)"
                    $objRef.TreeNodes[$newName] = $objRef.TreeNodes[$currentName]
                    $objRef.TreeNodes.Remove($currentName)
                    if ( $objRef.TreeNodes[$newName].Text -match "^SplitContainer" ) {
                        @('Panel1','Panel2').ForEach({
                            $objRef.Objects["$($currentName)_$($_)"].Name = "$($newName)_$($_)"
                            $objRef.Objects["$($newName)_$($_)"] = $objRef.Objects["$($currentName)_$($_)"]
                            $objRef.Objects.Remove("$($currentName)_$($_)")
                            if ( $objRef.Changes["$($currentName)_$($_)"] ) {
                                $objRef.Changes["$($newName)_$($_)"] = $objRef.Changes["$($currentName)_$($_)"]
                                $objRef.Changes.Remove("$($currentName)_$($_)")
                            }
                            if ( $objRef.Events["$($currentName)_$($_)"] ) {
                                $objRef.Events["$($newName)_$($_)"] = $objRef.Events["$($currentName)_$($_)"]
                                $objRef.Events.Remove("$($currentName)_$($_)")
                            }
                            $objRef.TreeNodes["$($currentName)_$($_)"].Name = "$($newName)_$($_)"
                            $objRef.TreeNodes["$($currentName)_$($_)"].Text = $Script:refs['TreeView'].SelectedNode.Text -replace "-.*$","- $($newName)_$($_)"
                            $objRef.TreeNodes["$($newName)_$($_)"] = $objRef.TreeNodes["$($currentName)_$($_)"]
                            $objRef.TreeNodes.Remove("$($currentName)_$($_)")
                        })
                    }
                } 
                catch {
                    Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered renaming '$($Script:refs['TreeView'].SelectedNode.Text)'."
                }
            }
        } 
        else {
            [void][System.Windows.Forms.MessageBox]::Show("Cannot perform any action from the 'Edit' Menu against a SplitterPanel control.",'Restricted Action')
        }   
    }
    
    function DeleteClick{
        if ( $Script:refs['TreeView'].SelectedNode.Text -notmatch "^SplitterPanel" ) {
            try {
                $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode
                if (( $objRef.Success -eq $true ) -and ( $Script:refs['TreeView'].SelectedNode.Level -ne 0 ) -or ( $objRef.RootType -ne 'Form' )) {
                    if ( [System.Windows.Forms.MessageBox]::Show("Are you sure you wish to remove the selected node and all child nodes? This cannot be undone." ,"Confirm Removal" , 4) -eq 'Yes' ) {
                        $nodesToDelete = @($($Script:refs['TreeView'].SelectedNode).Name)
                        $nodesToDelete += Get-ChildNodeList -TreeNode $Script:refs['TreeView'].SelectedNode
                        (($nodesToDelete.Count-1)..0).ForEach({
                            if ( $objRef.TreeNodes[$nodesToDelete[$_]] -eq $Script:nodeClipboard.Node ) {
                                $Script:nodeClipboard = $null
                                Remove-Variable -Name nodeClipboard -Scope Script
                            }
                            if ( $objRef.TreeNodes[$nodesToDelete[$_]].Text -notmatch "^SplitterPanel" ) {$objRef.Objects[$nodesToDelete[$_]].Dispose()}
                            $objRef.Objects.Remove($nodesToDelete[$_])
                            $objRef.TreeNodes[$nodesToDelete[$_]].Remove()
                            $objRef.TreeNodes.Remove($nodesToDelete[$_])
                            if ( $objRef.Changes[$nodesToDelete[$_]] ) {$objRef.Changes.Remove($nodesToDelete[$_])}
                            if ( $objRef.Events[$nodesToDelete[$_]] ) {$objRef.Events.Remove($nodesToDelete[$_])}
                        })
                    }
                } else {
                    $Script:refs['tsl_StatusLabel'].text = 'Cannot delete the root Form.  Start a New Project instead.'
                }
            } 
            catch {
                Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered deleting '$($Script:refs['TreeView'].SelectedNode.Text)'."
            }
        }
        else {
            [void][System.Windows.Forms.MessageBox]::Show("Cannot perform any action from the 'Edit' Menu against a SplitterPanel control.",'Restricted Action')
        }
    }
    
    function CopyNodeClick {
        if ( $Script:refs['TreeView'].SelectedNode.Level -gt 0 ) {
            $Script:nodeClipboard = @{
                ObjRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode
                Node = $Script:refs['TreeView'].SelectedNode
            }
        } 
        else {
            [void][System.Windows.Forms.MessageBox]::Show('You cannot copy a root node.  It will be necessary to copy each individual subnode separately after creating the root node manually.')
        }
    }
    
    function PasteNodeClick {
        try {
            if ( $Script:nodeClipboard ) {
                $pastedObjType = $Script:nodeClipboard.Node.Text -replace " - .*$"
                $currentObjType = $Script:refs['TreeView'].SelectedNode.Text -replace " - .*$"
                if ( $Script:supportedControls.Where({$_.Name -eq $currentObjType}).ChildTypes -contains $Script:supportedControls.Where({$_.Name -eq $pastedObjType}).Type ) {
                    $pastedObjName = $Script:nodeClipboard.Node.Name
                    $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode
                    $xml = Save-Project -ReturnXML
                    $pastedXML = Select-Xml -Xml $xml -XPath "//$($Script:nodeClipboard.ObjRef.RootType)[@Name=`"$($Script:nodeClipboard.ObjRef.RootName)`"]//$($pastedObjType)[@Name=`"$($pastedObjName)`"]"
                    $Script:refs['TreeView'].BeginUpdate()
                    if (( $objRef.RootType -eq $Script:nodeClipboard.ObjRef.RootType ) -and ( $objRef.RootName -eq $Script:nodeClipboard.ObjRef.RootName )) {
                        [array]$newNodeNames = Convert-XmlToTreeView -TreeObject $Script:refs['TreeView'].SelectedNode -Xml $pastedXml.Node -IncrementName
                    } 
                    else {
                        [array]$newNodeNames = Convert-XmlToTreeView -TreeObject $Script:refs['TreeView'].SelectedNode -Xml $pastedXml.Node
                    }
                    $Script:refs['TreeView'].EndUpdate()
                    Move-SButtons -Object $refs['PropertyGrid'].SelectedObject
                    $newNodeNames.ForEach({if ( $Script:nodeClipboard.ObjRef.Events["$($_.OldName)"] ) {$objRef.Events["$($_.NewName)"] = $Script:nodeClipboard.ObjRef.Events["$($_.OldName)"]}})
                } 
                else {
                    $pastedObjName = $Script:nodeClipboard.Node.Name
                    $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].TopNode
                    $xml = Save-Project -ReturnXML
                    $pastedXML = Select-Xml -Xml $xml -XPath "//$($Script:nodeClipboard.ObjRef.RootType)[@Name=`"$($Script:nodeClipboard.ObjRef.RootName)`"]//$($pastedObjType)[@Name=`"$($pastedObjName)`"]"
                    $Script:refs['TreeView'].BeginUpdate()
                    if (( $objRef.RootType -eq $Script:nodeClipboard.ObjRef.RootType ) -and ( $objRef.RootName -eq $Script:nodeClipboard.ObjRef.RootName )) {
                        [array]$newNodeNames = Convert-XmlToTreeView -TreeObject $Script:refs['TreeView'].TopNode -Xml $pastedXml.Node -IncrementName
                    }
                    else {
                        [array]$newNodeNames = Convert-XmlToTreeView -TreeObject $Script:refs['TreeView'].TopNode -Xml $pastedXml.Node
                    }
                    $Script:refs['TreeView'].EndUpdate()
                    Move-SButtons -Object $refs['PropertyGrid'].SelectedObject
                    $newNodeNames.ForEach({if ( $Script:nodeClipboard.ObjRef.Events["$($_.OldName)"] ) {$objRef.Events["$($_.NewName)"] = $Script:nodeClipboard.ObjRef.Events["$($_.OldName)"]}})               
                }
            }
        } 
        catch {
            Update-ErrorLog -ErrorRecord $_ -Message 'Exception encountered while pasting node from clipboard.'         
        }
    }
    
    function MoveUpClick {
        try {
            $selectedNode = $Script:refs['TreeView'].SelectedNode
            $objRef = Get-RootNodeObjRef -TreeNode $selectedNode
            $nodeName = $selectedNode.Name
            $nodeIndex = $selectedNode.Index
            if ( $nodeIndex -gt 0 ) {
                $parentNode = $selectedNode.Parent
                $clone = $selectedNode.Clone()

                $parentNode.Nodes.Remove($selectedNode)
                $parentNode.Nodes.Insert($($nodeIndex-1),$clone)

                $objRef.TreeNodes[$nodeName] = $parentNode.Nodes[$($nodeIndex-1)]
                $Script:refs['TreeView'].SelectedNode = $objRef.TreeNodes[$nodeName]
            }
        } 
        catch {
            Update-ErrorLog -ErrorRecord $_ -Message 'Exception encountered increasing index of TreeNode.'
        }
    }
    
    function MoveDownClick {
        try {
            $selectedNode = $Script:refs['TreeView'].SelectedNode
            $objRef = Get-RootNodeObjRef -TreeNode $selectedNode
            $nodeName = $selectedNode.Name
            $nodeIndex = $selectedNode.Index
            if ( $nodeIndex -lt $($selectedNode.Parent.Nodes.Count - 1) ) {
                $parentNode = $selectedNode.Parent
                $clone = $selectedNode.Clone()
                $parentNode.Nodes.Remove($selectedNode)
                if ( $nodeIndex -eq $($parentNode.Nodes.Count - 1) ) {$parentNode.Nodes.Add($clone)}
                else {$parentNode.Nodes.Insert($($nodeIndex+1),$clone)}
                $objRef.TreeNodes[$nodeName] = $parentNode.Nodes[$($nodeIndex+1)]
                $Script:refs['TreeView'].SelectedNode = $objRef.TreeNodes[$nodeName]
            }
        } 
        catch {
            Update-ErrorLog -ErrorRecord $_ -Message 'Exception encountered decreasing index of TreeNode.'
        }
    }
    
    function GenerateClick {
        $projectName = $Script:refs['tpg_Form1'].Text
        if ("$global:projectDirName" -eq "") {
            $Script:refs['tsl_StatusLabel'].text = "Please save this project before generating a script file","Script not generated"
            return
        }
        $generationPath = "$(Split-Path -Path $global:projectDirName)\$($projectName -replace "\..*$")"
        $designerpath = ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\functions.psm1")
        New-Variable astTokens -Force
        New-Variable astErr -Force
        $AST = [System.Management.Automation.Language.Parser]::ParseFile($designerpath, [ref]$astTokens, [ref]$astErr)
        $functions = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
        $outstring = "#region VDS
`$RunSpace = [RunspaceFactory]::CreateRunspacePool(); `$RunSpace.ApartmentState = `"STA`"; `$RunSpace.Open(); `$PowerShell = [powershell]::Create();`$PowerShell.RunspacePool = `$RunSpace; [void]`$PowerShell.AddScript({"
    foreach ($item in $lst_Functions.items){
        $checkItem = $lst_Functions.GetItemCheckState($lst_Functions.Items.IndexOf($item)).ToString()
        $i = $lst_Functions.Items.IndexOf($item)
        if ($checkItem -eq 'Checked') {
            if (($functions[$i].Extent) -ne $null){
        $outstring = "$outstring

$(($functions[$i].Extent).text)"    
            }
        }
    }
    $xmlObj = [xml](([xml](Get-Content "$global:projectDirName" -Encoding utf8)).Data.Form.OuterXml)
    $FormName = $xmlObj.Form.Name
    $Script:refs['TreeView'].Nodes.ForEach({
        $controlName = $_.Name
        $controlType = $_.Text -replace " - .*$"
        if ( $controlType -eq 'Form' ) {
            if ($Script:refsFID.Form.Objects[$controlName].Tag.Contains("IsMDIContainer")){
                $xmlObj.Form.SetAttribute("IsMDIContainer","True")
            }
        }
    })
    $xmlText = $xmlObj.OuterXml | Out-String
    $outstring = "$outstring
Set-Types
ConvertFrom-WinFormsXML -Reference refs -Suppress -Xml @""
$xmlText""@
#endregion VDS
$($FastText.Text)
Show-Form `$$FormName}); `$PowerShell.AddParameter('File',`$args[0]);`$PowerShell.Invoke(); `$PowerShell.Dispose()"

        if ( (Test-Path -Path "$($generationPath)" -PathType Container) -eq $false ) {
            New-Item -Path "$($generationPath)" -ItemType Directory | Out-Null
        }
        $utf8 = [System.Text.Encoding]::UTF8
        $FastText.SaveToFile("$generationPath\Events.ps1",$utf8)
        $outstring | Out-File "$($generationPath)\$($projectName -replace "fbs$","ps1")" -Encoding utf8 -Force
        $Script:refs['tsl_StatusLabel'].text = "Script saved to $($generationPath)\$($projectName -replace "fbs$","ps1")"
    }
    $eventSB = @{
        'New' = @{
            Click = {
                NewProjectClick
            }
        }
        'Open' = @{
            Click = {
                OpenProjectClick
            }
        }
        'Rename' = @{
            Click = {
                RenameClick
            }
        }
        'Delete' = @{
            Click = {
                DeleteClick
            }
        }
        'CopyNode' = @{
            Click = {
                CopyNodeClick
            }
        }
        'PasteNode' = @{
            Click = {
                PasteNodeClick
            }
        }
        'Move Up' = @{
            Click = {
                MoveUpClick
            }
        }
        'Move Down' = @{
            Click = {
                MoveDownClick
            }
        }
        'Generate Script File' = @{
            Click = {
                GenerateClick
            }
        }
        'TreeView' = @{
            AfterSelect = {
                if ( $Script:openingProject -eq $false ) {
                    try {
                        $objRef = Get-RootNodeObjRef -TreeNode $this.SelectedNode
                        $nodeName = $this.SelectedNode.Name
                        $nodeType = $this.SelectedNode.Text -replace " - .*$"
                        $Script:refs['PropertyGrid'].SelectedObject = $objRef.Objects[$nodeName]
                        if ( $objRef.Objects[$nodeName].Parent ) {
                            if (( @('FlowLayoutPanel','TableLayoutPanel') -notcontains $objRef.Objects[$nodeName].Parent.GetType().Name ) -and
                               ( $objRef.Objects[$nodeName].Dock -eq 'None' ) -and
                               ( @('SplitterPanel','ToolStripMenuItem','ToolStripComboBox','ToolStripTextBox','ToolStripSeparator','ContextMenuStrip') -notcontains $nodeType ) -and
                               ( $Script:supportedControls.Where({
                                    $_.Type -eq 'Parentless'
                                }).Name -notcontains $nodeType )) {
                                $objRef.Objects[$nodeName].BringToFront()
                            }
                            Move-SButtons -Object $objRef.Objects[$nodeName]
                        } 
                        else {
                            $Script:sButtons.GetEnumerator().ForEach({$_.Value.Visible = $false})
                        }
                        $Script:refs['lst_AssignedEvents'].Items.Clear()
                        if ( $objRef.Events[$this.SelectedNode.Name] ) {
                            $Script:refs['lst_AssignedEvents'].BeginUpdate()
                            $objRef.Events[$nodeName].ForEach({[void]$Script:refs['lst_AssignedEvents'].Items.Add($_)})
                            $Script:refs['lst_AssignedEvents'].EndUpdate()
                            $Script:refs['lst_AssignedEvents'].Enabled = $true
                        }
                        else {
                            $Script:refs['lst_AssignedEvents'].Items.Add('No Events')
                            $Script:refs['lst_AssignedEvents'].Enabled = $false
                        }
                        $eventTypes = $($Script:refs['PropertyGrid'].SelectedObject | Get-Member -Force).Name -match "^add_"
                        $Script:refs['lst_AvailableEvents'].Items.Clear()
                        $Script:refs['lst_AvailableEvents'].BeginUpdate()
                        if ( $eventTypes.Count -gt 0 ) {
                            $eventTypes | ForEach-Object {[void]$Script:refs['lst_AvailableEvents'].Items.Add("$($_ -replace "^add_")")}
                        }
                        else {
                            [void]$Script:refs['lst_AvailableEvents'].Items.Add('No Events Found on Selected Object')
                            $Script:refs['lst_AvailableEvents'].Enabled = $false
                        }
                        $Script:refs['lst_AvailableEvents'].EndUpdate()
                    } 
                    catch {
                        Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered after selecting TreeNode."
                    }
                }
            }
        }
        
        'PropertyGrid' = @{
            PropertyValueChanged = {
                param($Sender,$e)
                try {
                    $changedProperty = $e.ChangedItem
                    if ( @('Location','Size','Dock','AutoSize','Multiline') -contains $changedProperty.PropertyName ) {Move-SButtons -Object $Script:refs['PropertyGrid'].SelectedObject}
                    if ( $e.ChangedItem.PropertyDepth -gt 0 ) {
                        $stopProcess = $false
                        ($e.ChangedItem.PropertyDepth-1)..0 | ForEach-Object {
                            if ( $stopProcess -eq $false ) {
                                if ( $changedProperty.ParentGridEntry.HelpKeyword -match "^System.Windows.Forms.SplitContainer.Panel" ) {
                                    $stopProcess = $true
                                    $value = $changedProperty.GetPropertyTextValue()
                                    $Script:refs['TreeView'].SelectedNode = $objRefs.Form.TreeNodes["$($Script:refs['TreeView'].SelectedNode.Name)_$($changedProperty.ParentGridEntry.HelpKeyword.Split('.')[-1])"]
                                }
                                else {
                                    $changedProperty = $changedProperty.ParentGridEntry
                                    $value = $changedProperty.GetPropertyTextValue()
                                }
                            }
                        }
                    }
                    else {
                        $value = $changedProperty.GetPropertyTextValue()
                    }
                    $changedControl = $Script:refs['PropertyGrid'].SelectedObject
                    $controlType = $Script:refs['TreeView'].SelectedNode.Text -replace " - .*$"
                    $controlName = $Script:refs['TreeView'].SelectedNode.Name
                    $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode
                    if ( $changedProperty.PropertyDescriptor.ShouldSerializeValue($changedProperty.Component) ) {
                        
                        switch ($changedProperty.PropertyType) {
                            'System.Drawing.Image' {
                                $MemoryStream = New-Object System.IO.MemoryStream
                                $Script:refsFID.Form.Objects[$controlName].($changedProperty.PropertyName).save($MemoryStream, [System.Drawing.Imaging.ImageFormat]::Jpeg)
                                $Bytes = $MemoryStream.ToArray()
                                $MemoryStream.Flush()
                                $MemoryStream.Dispose()
                                $decodedimage = [convert]::ToBase64String($Bytes)
                                
                                if ($FastText.GetLineText(0) -eq "#region Images") 
                                {
                                    $FastText.ExpandFoldedBlock(0)
                                    $FastText.SelectionStart = 16
                                }
                                $string = "`$$controlName.$($changedProperty.PropertyName) = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String(`"$decodedimage`"))
"
                                $FastText.SelectedText = $string
                                if ($FastText.GetLineText(0) -eq "#region Images") 
                                {
                                    $FastText.CollapseFoldingBlock(0)
                                }
                            }
                            'System.Drawing.Icon'{
                                $MemoryStream = New-Object System.IO.MemoryStream
                                $Script:refsFID.Form.Objects[$controlName].Icon.save($MemoryStream)
                                $Bytes = $MemoryStream.ToArray()
                                $MemoryStream.Flush()
                                $MemoryStream.Dispose()
                                $decodedimage = [convert]::ToBase64String($Bytes)
                                if ($FastText.GetLineText(0) -eq "#region Images") 
                                {
                                    $FastText.ExpandFoldedBlock(0)
                                    $FastText.SelectionStart = 16
                                }                       
                                $string = "`$$controlName.Icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap][System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String(`"$decodedimage`"))).GetHicon())
"
                                $FastText.SelectedText = $string
                                if ($FastText.GetLineText(0) -eq "#region Images")
                                {
                                    $FastText.CollapseFoldingBlock(0)
                                }
                            }
                            default {
                                if ( $null -eq $objRef.Changes[$controlName] ) {$objRef.Changes[$controlName] = @{}}
                                $objRef.Changes[$controlName][$changedProperty.PropertyName] = $value
                            }
                        }

                    } 
                    elseif ( $objRef.Changes[$controlName] ) {
                        if ( $objRef.Changes[$controlName][$changedProperty.PropertyName] ) {
                            $objRef.Changes[$controlName].Remove($changedProperty.PropertyName)
                            if ( $objRef.Changes[$controlName].Count -eq 0 ) {$objRef.Changes.Remove($controlName)}
                        }
                    }
                } 
                catch {
                    Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered after changing property value ($($controlType) - $($controlName))."
                }
            }
        }
        'trv_Controls' = @{
            DoubleClick = {
                $controlName = $this.SelectedNode.Name
                switch ($controlName) {
                    'MenuStrip' {
                        $Script:refs['tsl_StatusLabel'].text = "Please do not use item collections in the property grid. Build onto controls by stacking controls from the selection on the left."
                    }
                    'ContextMenuStrip' {
                        $Script:refs['tsl_StatusLabel'].text = "Please do not use item collections in the property grid. Build onto controls by stacking controls from the selection on the left."
                    }
                    'StatusStrip' {
                        $Script:refs['tsl_StatusLabel'].text = "Please do not use item collections in the property grid. Build onto controls by stacking controls from the selection on the left."
                    }
                    'ToolStrip' {
                        $Script:refs['tsl_StatusLabel'].text = "Please do not use item collections in the property grid. Build onto controls by stacking controls from the selection on the left."
                    }
                    'ToolStripDropDownButton' {
                        $Script:refs['tsl_StatusLabel'].text = "Please do not use item collections in the property grid. Build onto controls by stacking controls from the selection on the left."
                    }
                    'ToolStripSplitButton' {
                        $Script:refs['tsl_StatusLabel'].text = "Please do not use item collections in the property grid. Build onto controls by stacking controls from the selection on the left."
                    }
                    'ToolStripMenuItem' {
                        $Script:refs['tsl_StatusLabel'].text = "Please do not use item collections in the property grid. Build onto controls by stacking controls from the selection on the left."
                    }
                    default{}
                }
                if ( $controlName -eq 'ContextMenuStrip' ) {
                    $context = 1
                } 
                else {
                    $context = 2
                }
                if ( @('All Controls','Common','Containers', 'Menus and ToolStrips','Miscellaneous') -notcontains $controlName ) {
                    $controlObjectType = $Script:supportedControls.Where({$_.Name -eq $controlName}).Type
                    try {
                        if (( $controlObjectType -eq 'Parentless' ) -or ( $context -eq 0 )) {
                            $controlType = $controlName
                            $Script:newNameCheck = $false
                            $Script:newNameCheck = $true
                            if ( $Script:refs['TreeView'].Nodes.Text -match "$($controlType) - $($userInput.NewName)" ) {
                                [void][System.Windows.Forms.MessageBox]::Show("A $($controlType) with the Name '$($userInput.NewName)' already exists.",'Error')
                            } 
                            else {
                                if ($control_track.$controlName -eq $null){
                                    $control_track[$controlName] = 1
                                }
                                else {
                                    $control_track.$controlName = $control_track.$controlName + 1
                                }
                                if ( $Script:refs['TreeView'].Nodes.Text -match "$($controlType) - $controlName$($control_track.$controlName)" ) {
                                    [void][System.Windows.Forms.MessageBox]::Show("A $($controlType) with the Name '$controlName$($control_track.$controlName)' already exists.",'Error')
                                }
                                else {
                                    Add-TreeNode -TreeObject $Script:refs['TreeView'] -ControlType $controlName "$controlName$($control_track.$controlName)" "$controlName$($control_track.$controlName)"
                                }
                            }
                        }
                        else {
                            if ( $Script:supportedControls.Where({
                                $_.Name -eq $($refs['TreeView'].SelectedNode.Text -replace " - .*$")}).ChildTypes -contains $controlObjectType ) {
                                if ($control_track.$controlName -eq $null){
                                    $control_track[$controlName] = 1
                                }
                                else {
                                    $control_track.$controlName = $control_track.$controlName + 1
                                }
                                if ($Script:refs['TreeView'].Nodes.Nodes | Where-Object { 
                                $_.Text -eq "$($controlName) - $controlName$($control_track.$controlName)" }) {
                                    [void][System.Windows.Forms.MessageBox]::Show("A $($controlName) with the Name '$controlName$($control_track.$controlName)' already exists. Try again to create '$controlName$($control_track.$controlName + 1)'",'Error')
                                }
                                else {
                                    Add-TreeNode -TreeObject $Script:refs['TreeView'].SelectedNode -ControlType $controlName "$controlName$($control_track.$controlName)" "$controlName$($control_track.$controlName)"
                                }
                            } 
                            else {
                                if ($control_track.$controlName -eq $null) {
                                    $control_track[$controlName] = 1
                                }
                                else {
                                    $control_track.$controlName = $control_track.$controlName + 1
                                }
                                if ($Script:refs['TreeView'].Nodes.Nodes | Where-Object { 
                                    $_.Text -eq "$($controlName) - $controlName$($control_track.$controlName)" }) {
                                    [void][System.Windows.Forms.MessageBox]::Show("A $($controlName) with the Name '$controlName$($control_track.$controlName)' already exists. Try again to create '$controlName$($control_track.$controlName + 1)'",'Error')
                                }
                                else {
                                    Add-TreeNode -TreeObject $Script:refs['TreeView'].TopNode -ControlType $controlName "$controlName$($control_track.$controlName)" "$controlName$($control_track.$controlName)"
                                }
                            }
                        }
                    }
                    catch {
                        Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered while adding '$($controlName)'."
                    }
                }
            }
        }
        'lst_AvailableEvents' = @{
            DoubleClick = {
                $controlName = $Script:refs['TreeView'].SelectedNode.Name
                $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode
                if ( $Script:refs['lst_AssignedEvents'].Items -notcontains $this.SelectedItem ) {
                    if ( $Script:refs['lst_AssignedEvents'].Items -contains 'No Events' ) {$Script:refs['lst_AssignedEvents'].Items.Clear()}
                    [void]$Script:refs['lst_AssignedEvents'].Items.Add($this.SelectedItem)
                    $Script:refs['lst_AssignedEvents'].Enabled = $true
                    $objRef.Events[$controlName] = @($Script:refs['lst_AssignedEvents'].Items)
                    $FastText.SelectedText = "`$$ControlName.add_$($this.SelectedItem)({param(`$sender, `$e)
    
})

"
                }
            }
        }
        'lst_AssignedEvents' = @{
            DoubleClick = {
                $controlName = $Script:refs['TreeView'].SelectedNode.Name
                $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode
                $Script:refs['lst_AssignedEvents'].Items.Remove($this.SelectedItem)
                if ( $Script:refs['lst_AssignedEvents'].Items.Count -eq 0 ) {
                    $Script:refs['lst_AssignedEvents'].Items.Add('No Events')
                    $Script:refs['lst_AssignedEvents'].Enabled = $false
                }
                if ( $Script:refs['lst_AssignedEvents'].Items[0] -ne 'No Events' ) {
                    $objRef.Events[$controlName] = @($Script:refs['lst_AssignedEvents'].Items)
                } 
                else {
                    if ( $objRef.Events[$controlName] ) {
                        $objRef.Events.Remove($controlName)
                    }
                }
            }
        }
        'ChangeView' = {
            ChangeView
        }
        'ChangePanelSize' = @{
            'MouseMove' = {
                param($Sender, $e)
                if (( $e.Button -eq 'Left' ) -and ( $e.Location.X -ne 0 )) {
                    $side = $Sender.Name -replace "^lbl_"
                    if ( $side -eq 'Right' ) {$newX = $refs["pnl_$($side)"].Size.Width - $e.Location.X} else {$newX = $refs["pnl_$($side)"].Size.Width + $e.Location.X}
                    if ( $newX -ge 100 ) {$refs["pnl_$($side)"].Size = New-Object System.Drawing.Size($newX,$refs["pnl_$($side)"].Size.Y)}
                    $Sender.Parent.Refresh()
                }
            }
        }
        'CheckedChanged' = {
            param ($Sender)
            if ( $Sender.Checked ) {
                $Sender.Parent.Controls["$($Sender.Name -replace "^c",'t')"].Enabled = $true
                $Sender.Parent.Controls["$($Sender.Name -replace "^c",'t')"].Focus()
            } 
            else {
                $Sender.Parent.Controls["$($Sender.Name -replace "^c",'t')"].Enabled = $false
            }
        }
    }
    $Script:childFormInfo = @{
        'NameInput' = @{
            XMLText = @"
  <Form Name="NameInput" ShowInTaskbar="False" MaximizeBox="False" Text="Enter Name" Size="700, 125" StartPosition="CenterParent" MinimizeBox="False" BackColor="171, 171, 171" FormBorderStyle="FixedDialog" Font="Arial, 18pt">
    <Label Name="label" TextAlign="MiddleCenter" Location="25, 25" Size="170, 40" Text="Control Name:" />
    <TextBox Name="UserInput" Location="210, 25" Size="425, 25"/>
    <Button Name="StopDingOnEnter" Visible="False" />
  </Form>
"@
            Events = @(
                [pscustomobject]@{
                    Name = 'NameInput'
                    EventType = 'Activated'
                    ScriptBlock = {$this.Controls['UserInput'].Focus()
                    $this.Controls['UserInput'].Select(5,0)}
                }
                [pscustomobject]@{
                    Name = 'UserInput'
                    EventType = 'KeyUp'
                    ScriptBlock = {
                        if ( $_.KeyCode -eq 'Return' ) {
                            $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode
                            if ( $((Get-Date)-$($Script:lastUIKeyUp)).TotalMilliseconds -lt 250 ) {
                                # Do nothing
                            }
                            elseif ( $this.Text -match "(\||<|>|&|\$|'|`")" ) {
                                [void][System.Windows.Forms.MessageBox]::Show("Names cannot contain any of the following characters: `"|<'>`"&`$`".", 'Error')
                            }
                            elseif (( $objref.TreeNodes[$($this.Text.Trim())] ) -and ( $Script:newNameCheck -eq $true )) {
                                [void][System.Windows.Forms.MessageBox]::Show("All elements must have unique names for this application to function as intended. The name '$($this.Text.Trim())' is already assigned to another element.", 'Error')
                            }
                            elseif ( $($this.Text -replace "\s") -eq '' ) {
                                [void][System.Windows.Forms.MessageBox]::Show("All elements must have names for this application to function as intended.", 'Error')
                                $this.Text = ''
                            }
                            else {
                                $this.Parent.DialogResult = 'OK'
                                $this.Text = $this.Text.Trim()
                                $this.Parent.Close()
                            }
                            $Script:lastUIKeyUp = Get-Date
                        }
                    }
                }
            )
        }
    }
    $reuseContextInfo = @{
        'TreeNode' = @{
            XMLText = @"
  <ContextMenuStrip Name="TreeNode">
    <ToolStripMenuItem Name="MoveUp" ShortcutKeys="F5" Text="Move Up" ShortcutKeyDisplayString="F5" />
    <ToolStripMenuItem Name="MoveDown" ShortcutKeys="F6" ShortcutKeyDisplayString="F6" Text="Move Down" />
    <ToolStripSeparator Name="Sep1" />
    <ToolStripMenuItem Name="CopyNode" ShortcutKeys="Ctrl+Alt+C" Text="Copy" ShortcutKeyDisplayString="Ctrl+Alt+C" />
    <ToolStripMenuItem Name="PasteNode" ShortcutKeys="Ctrl+Alt+V" Text="Paste" ShortcutKeyDisplayString="Ctrl+Alt+V" />
    <ToolStripSeparator Name="Sep2" />
    <ToolStripMenuItem Name="Rename" ShortcutKeys="Ctrl+R" Text="Rename" ShortcutKeyDisplayString="Ctrl+R" />
    <ToolStripMenuItem Name="Delete" ShortcutKeys="Ctrl+D" Text="Delete" ShortcutKeyDisplayString="Ctrl+D" />
  </ContextMenuStrip>
"@
            Events = @(
                [pscustomobject]@{
                    Name = 'TreeNode'
                    EventType = 'Opening'
                    ScriptBlock = {
                        $parentType = $Script:refs['TreeView'].SelectedNode.Text -replace " - .*$"
                        
                        if ( $parentType -eq 'Form' ) {
                            $this.Items['Delete'].Visible = $false
                            $this.Items['CopyNode'].Visible = $false
                            $isCopyVisible = $false
                        } 
                        else {
                            $this.Items['Delete'].Visible = $true
                            $this.Items['CopyNode'].Visible = $true
                            $isCopyVisible = $true
                        }
                        if ( $Script:nodeClipboard ) {
                            $this.Items['PasteNode'].Visible = $true
                            $this.Items['Sep2'].Visible = $true
                        } 
                        else {
                            $this.Items['PasteNode'].Visible = $false
                            $this.Items['Sep2'].Visible = $isCopyVisible
                        }
                    }
                },
                [pscustomobject]@{
                    Name = 'MoveUp'
                    EventType = 'Click'
                    ScriptBlock = $eventSB['Move Up'].Click
                },
                [pscustomobject]@{
                    Name = 'MoveDown'
                    EventType = 'Click'
                    ScriptBlock = $eventSB['Move Down'].Click
                },
                [pscustomobject]@{
                    Name = 'CopyNode'
                    EventType = 'Click'
                    ScriptBlock = $eventSB['CopyNode'].Click
                },
                [pscustomobject]@{
                    Name = 'PasteNode'
                    EventType = 'Click'
                    ScriptBlock = $eventSB['PasteNode'].Click
                },
                [pscustomobject]@{
                    Name = 'Rename'
                    EventType = 'Click'
                    ScriptBlock = $eventSB['Rename'].Click
                },
                [pscustomobject]@{
                    Name = 'Delete'
                    EventType = 'Click'
                    ScriptBlock = $eventSB['Delete'].Click
                }
            )
        }
    }
    $noIssues = $true
    try {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        $Script:projectsDir = ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer")
        if ( (Test-Path -Path "$($Script:projectsDir)") -eq $false ) {New-Item -Path "$($Script:projectsDir)" -ItemType Directory | Out-Null}
        $Script:lastUIKeyUp = Get-Date
        $Script:newNameCheck = $true
        $Script:openingProject = $false
        $Script:MouseMoving = $false
        $Script:supportedControls = @(
            [pscustomobject]@{Name='Button';Prefix='btn';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='CheckBox';Prefix='cbx';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='CheckedListBox';Prefix='clb';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='ColorDialog';Prefix='cld';Type='Parentless';ChildTypes=@()},
            [pscustomobject]@{Name='ComboBox';Prefix='cmb';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='ContextMenuStrip';Prefix='cms';Type='Context';ChildTypes=@('MenuStrip-Root','MenuStrip-Child')},
            [pscustomobject]@{Name='DataGrid';Prefix='dgr';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='DataGridView';Prefix='dgv';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='DateTimePicker';Prefix='dtp';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='FlowLayoutPanel';Prefix='flp';Type='Container';ChildTypes=@('Common','Container','MenuStrip','Context')},
            [pscustomobject]@{Name='FolderBrowserDialog';Prefix='fbd';Type='Parentless';ChildTypes=@()},
            [pscustomobject]@{Name='FontDialog';Prefix='fnd';Type='Parentless';ChildTypes=@()},
            [pscustomobject]@{Name='GroupBox';Prefix='gbx';Type='Container';ChildTypes=@('Common','Container','MenuStrip','Context')},
            [pscustomobject]@{Name='Label';Prefix='lbl';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='LinkLabel';Prefix='llb';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='ListBox';Prefix='lbx';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='ListView';Prefix='lsv';Type='Common';ChildTypes=@('Context')},  # need to fix issue with VirtualMode when 0 items
            [pscustomobject]@{Name='MaskedTextBox';Prefix='mtb';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='MenuStrip';Prefix='mst';Type='MenuStrip';ChildTypes=@('MenuStrip-Root')},
            [pscustomobject]@{Name='MonthCalendar';Prefix='mcd';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='NumericUpDown';Prefix='nud';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='OpenFileDialog';Prefix='ofd';Type='Parentless';ChildTypes=@()},
            [pscustomobject]@{Name='PageSetupDialog';Prefix='psd';Type='Parentless';ChildTypes=@()},
            [pscustomobject]@{Name='Panel';Prefix='pnl';Type='Container';ChildTypes=@('Common','Container','MenuStrip','Context')},
            [pscustomobject]@{Name='PictureBox';Prefix='pbx';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='PrintDialog';Prefix='prd';Type='Parentless';ChildTypes=@()},
            [pscustomobject]@{Name='PrintPreviewDialog';Prefix='ppd';Type='Parentless';ChildTypes=@()},
            [pscustomobject]@{Name='ProgressBar';Prefix='pbr';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='PropertyGrid';Prefix='pgd';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='RadioButton';Prefix='rdb';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='RichTextBox';Prefix='rtb';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='SaveFileDialog';Prefix='sfd';Type='Parentless';ChildTypes=@()},
            [pscustomobject]@{Name='SplitContainer';Prefix='scr';Type='Container';ChildTypes=@('Context')},
            [pscustomobject]@{Name='SplitterPanel';Prefix='spl';Type='Container';ChildTypes=@('Common','Container','MenuStrip','Context')},
            [pscustomobject]@{Name='StatusStrip';Prefix='sta';Type='MenuStrip';ChildTypes=@('StatusStrip-Child','MenuStrip-Child','MenuStrip-Root')},
            [pscustomobject]@{Name='TabControl';Prefix='tcl';Type='Common';ChildTypes=@('Context','TabControl')},
            [pscustomobject]@{Name='TabPage';Prefix='tpg';Type='TabControl';ChildTypes=@('Common','Container','MenuStrip','Context')},
            [pscustomobject]@{Name='TableLayoutPanel';Prefix='tlp';Type='Container';ChildTypes=@('Common','Container','MenuStrip','Context')},
            [pscustomobject]@{Name='TextBox';Prefix='tbx';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='ToolStrip';Prefix='tls';Type='MenuStrip';ChildTypes=@('MenuStrip-Root')},
            [pscustomobject]@{Name='ToolStripButton';Prefix='tsb';Type='MenuStrip-Root';ChildTypes=@()},
            [pscustomobject]@{Name='ToolStripDropDownButton';Prefix='tdd';Type='MenuStrip-Root';ChildTypes=@('MenuStrip-Root')},
            [pscustomobject]@{Name='ToolStripProgressBar';Prefix='tpb';Type='MenuStrip-Root';ChildTypes=@()},
            [pscustomobject]@{Name='ToolStripSplitButton';Prefix='tsp';Type='MenuStrip-Root';ChildTypes=@('MenuStrip-Root')},
            [pscustomobject]@{Name='ToolStripStatusLabel';Prefix='tsl';Type='StatusStrip-Child';ChildTypes=@()},
            [pscustomobject]@{Name='Timer';Prefix='tmr';Type='Parentless';ChildTypes=@()}, 
            [pscustomobject]@{Name='TrackBar';Prefix='tbr';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='TreeView';Prefix='tvw';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='WebBrowser';Prefix='wbr';Type='Common';ChildTypes=@('Context')},
            [pscustomobject]@{Name='ToolStripMenuItem';Prefix='tmi';Type='MenuStrip-Root';ChildTypes=@('MenuStrip-Root','MenuStrip-Child')},
            [pscustomobject]@{Name='ToolStripComboBox';Prefix='tcb';Type='MenuStrip-Root';ChildTypes=@()},
            [pscustomobject]@{Name='ToolStripTextBox';Prefix='ttb';Type='MenuStrip-Root';ChildTypes=@()},
            [pscustomobject]@{Name='ToolStripSeparator';Prefix='tss';Type='MenuStrip-Root';ChildTypes=@()},
            [pscustomobject]@{Name='Form';Prefix='frm';Type='Special';ChildTypes=@('Common','Container','Context','MenuStrip')}
        )
        $Script:specialProps = @{
            All = @('(DataBindings)','FlatAppearance','Location','Size','AutoSize','Dock','TabPages','SplitterDistance','UseCompatibleTextRendering','TabIndex',
                    'TabStop','AnnuallyBoldedDates','BoldedDates','Lines','Items','DropDownItems','Panel1','Panel2','Text','AutoCompleteCustomSource','Nodes')
            Before = @('Dock','AutoSize')
            After = @('SplitterDistance','AnnuallyBoldedDates','BoldedDates','Items','Text')
            BadReflector = @('UseCompatibleTextRendering','TabIndex','TabStop','IsMDIContainer')
            Array = @('Items','AnnuallyBoldedDates','BoldedDates','MonthlyBoldedDates')
        }
    } 
    catch {
        Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered during Environment Setup."
        $noIssues = $false
    }
    if ( $noIssues ) {
        try {
            Get-CustomControl -ControlInfo $reuseContextInfo['TreeNode'] -Reference reuseContext -Suppress
        } 
        catch {
            Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered during Child Form Initialization."
            $noIssues = $false
        }
    }

    try {
        $Script:refs['MainForm'].Add_Load($eventSB['MainForm'].Load)
        $Script:refs['ms_Toolbox'].Add_Click($eventSB.ChangeView)
        $Script:refs['ms_FormTree'].Add_Click($eventSB.ChangeView)
        $Script:refs['ms_Properties'].Add_Click($eventSB.ChangeView)
        $Script:refs['ms_Events'].Add_Click($eventSB.ChangeView)
        $Script:refs['Toolbox'].Add_Click($eventSB.ChangeView)
        $Script:refs['FormTree'].Add_Click($eventSB.ChangeView)
        $Script:refs['Properties'].Add_Click($eventSB.ChangeView)
        $Script:refs['Events'].Add_Click($eventSB.ChangeView)
        $Script:refs['lbl_Left'].Add_MouseMove($eventSB.ChangePanelSize.MouseMove)
        $Script:refs['lbl_Right'].Add_MouseMove($eventSB.ChangePanelSize.MouseMove)
        $Script:refs['New'].Add_Click($eventSB['New'].Click)
        $Script:refs['Open'].Add_Click($eventSB['Open'].Click)
        $Script:refs['Rename'].Add_Click($eventSB['Rename'].Click)
        $Script:refs['Delete'].Add_Click($eventSB['Delete'].Click)
        $Script:refs['CopyNode'].Add_Click($eventSB['CopyNode'].Click)
        $Script:refs['PasteNode'].Add_Click($eventSB['PasteNode'].Click)
        $Script:refs['Move Up'].Add_Click($eventSB['Move Up'].Click)
        $Script:refs['Move Down'].Add_Click($eventSB['Move Down'].Click)
        $Script:refs['Generate'].Add_Click($eventSB['Generate Script File'].Click)
        $Script:refs['TreeView'].Add_AfterSelect($eventSB['TreeView'].AfterSelect)
        $Script:refs['PropertyGrid'].Add_PropertyValueChanged($eventSB['PropertyGrid'].PropertyValueChanged)
        $Script:refs['trv_Controls'].Add_DoubleClick($eventSB['trv_Controls'].DoubleClick)
        $Script:refs['lst_AvailableEvents'].Add_DoubleClick($eventSB['lst_AvailableEvents'].DoubleClick)
        $Script:refs['lst_AssignedEvents'].Add_DoubleClick($eventSB['lst_AssignedEvents'].DoubleClick)
        function RunLast {
            $projectName = $refs['tpg_Form1'].Text  
            if ($projectName -ne "NewProject.fbs") {                
            $generationPath = "$(Split-Path -Path $global:projectDirName)\$($projectName -replace "\..*$")"
                if (Test-Path -path $generationPath) {
                    #do nothing
                }
                else {
                New-Item -ItemType directory -Path $generationPath
                }
                $file = "`"$($generationPath)\$($projectName -replace "fbs$","ps1")`""
                start-process -filepath powershell.exe -argumentlist '-ep bypass','-sta','-noexit',"-file $file"
            }
        }
        $Script:refs['RunLast'].Add_Click({
            RunLast
        })
        function LoadFunctionModule {
            start-process -filepath powershell.exe -argumentlist '-noexit', "-command import-module '$([Environment]::GetFolderPath('MyDocuments'))\PowerShell Designer\functions\functions.psm1'" #-workingdirectory "$($global:projectDirName)"
            start-sleep -s 1
            $PS = Get-WindowExists "Windows PowerShell"
            if ($PS -eq $Null){
                $PS = Get-WindowExists "Administrator: Windows PowerShell"
            }
            Set-WindowText $PS "Windows PowerShell - PowerShell Designer Custom Functions Enabled"
        }

        $functionsModule.Add_Click({
            LoadFunctionModule
        })
        $Script:refs['Undo'].Add_Click({
            $FastText.Undo()
        })
        $Script:refs['Redo'].Add_Click({
            $FastText.Redo()
        })
        $Script:refs['Cut'].Add_Click({
            $FastText.Cut()
        })
        $Script:refs['Copy'].Add_Click({
            $FastText.Copy()
        })
        $Script:refs['Paste'].Add_Click({
            $FastText.Paste()
        })
        $Script:refs['Select All'].Add_Click({
            $FastText.SelectAll()
        })
        $Script:refs['Find'].Add_Click({
            $FastText.ShowFindDialog()
        })
        $Script:refs['Replace'].Add_Click({
            $FastText.ShowReplaceDialog()
        })
        $Script:refs['Goto'].Add_Click({
            $FastText.ShowGotoDialog()
        })
        $Script:refs['Expand All'].Add_Click({
            $FastText.ExpandAllFoldingBlocks()
        })
        $Script:refs['Collapse All'].Add_Click({
            $FastText.CollapseAllFoldingBlocks()
        })
        function SaveProjectClick{
             try {Save-Project} catch {if ( $_.Exception.Message -ne 'SaveCancelled' ) {throw $_}}
        }
        function SaveAsProjectClick{
             try {Save-Project -SaveAs} catch {if ( $_.Exception.Message -ne 'SaveCancelled' ) {throw $_}} 
        }
        function bookmarkTS{}
        $MainForm.Add_FormClosing({($e)
            $ClosingAsk = Get-Answer "Have you saved your work?" "Close PowerShell Designer?"
            if ($ClosingAsk -eq 'Yes'){
                try {
                    $Script:refs['TreeView'].Nodes.ForEach({
                        $controlName = $_.Name
                        $controlType = $_.Text -replace " - .*$"
                        if ( $controlType -eq 'Form' ) {$Script:refsFID.Form.Objects[$controlName].Dispose()}
                        else {$Script:refsFID[$controlType][$controlName].Objects[$controlName].Dispose()}
                        $MainForm.Dispose()
                    })
                } 
                catch {
                    Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered during Form closure."
                }
            }
            else {$e.cancel}
        })
        $tsNewBtn.Add_Click({NewProjectClick})
        $tsSaveBtn.Add_Click({SaveProjectClick})
        $tsSaveAsBtn.Add_Click({SaveAsProjectClick})
        $tsOpenbtn.Add_Click({OpenProjectClick})
        $tsRenameBtn.Add_Click({RenameClick})
        $tsDeleteBtn.Add_Click({DeleteClick})
        $tsControlCopyBtn.Add_Click({CopyNodeClick})
        $tsControlPasteBtn.add_Click({PasteNodeClick})
        $tsMoveUpBtn.Add_Click({MoveUpClick})
        $tsMoveDownBtn.Add_Click({MoveDownClick})
        $tsGenerateBtn.Add_Click({GenerateClick})
        $tsUndoBtn.Add_Click({$FastText.Undo()})
        $tsRedoBtn.Add_Click({$FastText.Redo()})
        $tsCutBtn.Add_Click({$FastText.Cut()})
        $tsCopyBtn.Add_Click({$FastText.Copy()})
        $tsPasteBtn.Add_Click({$FastText.Paste()})
        $tsSelectAllBtn.Add_Click({$FastText.SelectAll()})
        $tsFindBtn.Add_Click({$FastText.ShowFindDialog()})
        $tsReplaceBtn.Add_Click({$FastText.ShowReplaceDialog()})
        $tsGoToLineBtn.Add_Click({$FastText.ShowGotoDialog()})
        $tsCollapseAllBtn.Add_Click({$FastText.CollapseAllFoldingBlocks()})
        $tsExpandAllBtn.Add_Click({$FastText.ExpandAllFoldingBlocks()})
        $tsToolBoxBtn.Add_Click({ChangeView})
        $tsFormTreeBtn.Add_Click({ChangeView})
        $tsPropertiesBtn.Add_Click({ChangeView})
        $tsEventsBtn.Add_Click({ChangeView})
        $tsTermBtn.Add_Click({LoadFunctionModule})
        $tsRunBtn.Add_Click({RunLast})
        $Script:refs['Exit'].Add_Click({$Script:refs['MainForm'].Close()})
        $Script:refs['Save'].Add_Click({SaveProjectClick})
        $Script:refs['Save As'].Add_Click({SaveAsProjectClick})
        $Script:refs['TreeView'].Add_DrawNode({$args[1].DrawDefault = $true})
        $Script:refs['TreeView'].Add_NodeMouseClick({$this.SelectedNode = $args[1].Node})
    } 
    catch {
        Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered during Event Assignment."
    }
    if ( $noIssues ) {
        try {
            @('All Controls','Common','Containers','Menus and ToolStrips','Miscellaneous').ForEach({
                $treeNode = $Script:refs['trv_Controls'].Nodes.Add($_,$_)
                switch ($_) {
                    'All Controls'         {$Script:supportedControls.Where({ @('Special','SplitContainer') -notcontains $_.Type }).Name.ForEach({$treeNode.Nodes.Add($_,$_)})}
                    'Common'               {$Script:supportedControls.Where({ $_.Type -eq 'Common' }).Name.ForEach({$treeNode.Nodes.Add($_,$_)})}
                    'Containers'           {$Script:supportedControls.Where({ $_.Type -eq 'Container' }).Name.ForEach({$treeNode.Nodes.Add($_,$_)})}
                    'Menus and ToolStrips' {$Script:supportedControls.Where({ $_.Type -eq 'Context' -or $_.Type -match "^MenuStrip" -or  $_.Type -match "Status*" -or $_.Type -eq "ToolStrip"}).Name.ForEach({$treeNode.Nodes.Add($_,$_)})}
                    'Miscellaneous'        {$Script:supportedControls.Where({ @('TabControl','Parentless') -match "^$($_.Type)$" }).Name.ForEach({$treeNode.Nodes.Add($_,$_)})}
                }
            })
            $Script:refs['trv_Controls'].Nodes.Where({$_.Name -eq 'Common'}).Expand()
            [void]$Script:refs['lst_AssignedEvents'].Items.Add('No Events')
            $Script:refs['lst_AssignedEvents'].Enabled = $false
            Add-TreeNode -TreeObject $Script:refs['TreeView'] -ControlType Form -ControlName MainForm
            $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].height = $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].height * $ctscale
            $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].width = $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].width * $ctscale
            $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].tag = "VisualStyle,DPIAware"
            Remove-Variable -Name eventSB, reuseContextInfo
        } 
        catch {
            Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered before ShowDialog."
            $noIssues = $false
        }
    }
    try {
        $eventForm = New-Object System.Windows.Forms.Form
        $eventForm.Text = "Events"
        try {
            if ((Get-Module -ListAvailable powershell-designer).count -gt 1){
            [Reflection.Assembly]::LoadFile("$(split-path -path (Get-Module -ListAvailable powershell-designer)[0].path)\FastColoredTextBox.dll") | out-null
            }
            else{
            [Reflection.Assembly]::LoadFile("$(split-path -path (Get-Module -ListAvailable powershell-designer).path)\FastColoredTextBox.dll") | out-null
            }
        }
        
        
        catch {
            [Reflection.Assembly]::LoadFile("$BaseDir\FastColoredTextBox.dll") | out-null
        }
        $designerpath = ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\functions.psm1")
        New-Variable astTokens -Force
        New-Variable astErr -Force
        $AST = [System.Management.Automation.Language.Parser]::ParseFile($designerpath, [ref]$astTokens, [ref]$astErr)
        $functions = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
        for ( $i=0;$i -le $functions.count -1;$i++ ) {
            $lst_Functions.Items.Add("$($functions[$i].name)")
            }
        $FastText = New-Object FastColoredTextBoxNS.FastColoredTextBox
        $FastText.Language = "DialogShell"
        $FastText.ShowFoldingLines = $True
        $FastText.BackColor = "Azure"
        $FastText.Dock = "Fill"
        $FastText.Zoom = 100
        $eventForm.Controls.Add($FastText)
        $eventForm.MDIParent = $MainForm
        $eventForm.Dock = "Bottom"
        $eventForm.ControlBox = $false
        $eventForm.ShowIcon = $false
        $xpopup = New-Object System.Windows.Forms.ContextMenuStrip
        $undo = new-object System.Windows.Forms.ToolStripMenuItem
        $undo.text = "Undo"
        $undo.Add_Click({$FastText.Undo()})
        $xpopup.Items.Add($undo)
        $redo = new-object System.Windows.Forms.ToolStripMenuItem
        $redo.text = "Redo"
        $redo.Add_Click({$FastText.Redo()})
        $xpopup.Items.Add($redo)
        $xpSep1 = new-object System.Windows.Forms.ToolStripSeparator
        $xpopup.Items.Add($xpSep1)
        $Cut = new-object System.Windows.Forms.ToolStripMenuItem
        $Cut.text = "Cut"
        $Cut.Add_Click({$FastText.Cut()
        })
        $xpopup.Items.Add($Cut)
        $Copy = new-object System.Windows.Forms.ToolStripMenuItem
        $Copy.text = "Copy"
        $Copy.Add_Click({$FastText.Copy()})
        $xpopup.Items.Add($Copy)
        $Paste = new-object System.Windows.Forms.ToolStripMenuItem
        $Paste.text = "Paste"
        $Paste.Add_Click({$FastText.Paste()})
        $xpopup.Items.Add($Paste)
        $SelectAll = new-object System.Windows.Forms.ToolStripMenuItem
        $SelectAll.text = "Select All"
        $SelectAll.Add_Click({$FastText.SelectAll()})
        $xpopup.Items.Add($SelectAll)
        $xpSep2 = new-object System.Windows.Forms.ToolStripSeparator
        $xpopup.Items.Add($xpSep2)
        $Find = new-object System.Windows.Forms.ToolStripMenuItem
        $Find.text = "Find"
        $Find.Add_Click({$FastText.ShowFindDialog()})
        $xpopup.Items.Add($Find)
        $Replace = new-object System.Windows.Forms.ToolStripMenuItem
        $Replace.text = "Replace"
        $Replace.Add_Click({$FastText.ShowReplaceDialog()})
        $xpopup.Items.Add($Replace)
        $Goto = new-object System.Windows.Forms.ToolStripMenuItem
        $Goto.text = "Go to Line ..."
        $Goto.Add_Click({$FastText.ShowGotoDialog()})
        $xpopup.Items.Add($Goto)
        $xpSep3 = new-object System.Windows.Forms.ToolStripSeparator
        $xpopup.Items.Add($xpSep3)
        $ExpandAll = new-object System.Windows.Forms.ToolStripMenuItem
        $ExpandAll.text = "Expand All"
        $ExpandAll.Add_Click({$FastText.ExpandAllFoldingBlocks()})
        $xpopup.Items.Add($ExpandAll)
        $CollapseAll = new-object System.Windows.Forms.ToolStripMenuItem
        $CollapseAll.text = "Collapse All"
        $CollapseAll.Add_Click({$FastText.CollapseAllFoldingBlocks()})
        $xpopup.Items.Add($CollapseAll)
        $eventForm.ContextMenuStrip = $xpopup
        $Script:refs['ms_Left'].visible = $false
        $Script:refs['ms_Right'].visible = $false
        $Script:refs['ms_Left'].Width = 0
        $eventform.height = $eventform.height * $ctscale
        $FastText.SelectedText = "#region Images

#endregion

"
        try {
            $FastText.CollapseFoldingBlock(0)
        }
        catch{
        }
        $eventForm.Show()
        $Script:refs['tsl_StatusLabel'].text = "Current DPIScale: $ctscale - for resize events multiply all location and size modifiers by `$ctscale."
        $Script:refs['spt_Right'].splitterdistance = $Script:refs['spt_Right'].splitterdistance * $ctscale
        iex (Get-Content (([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\Dependencies.ps1")) | Out-String)
        $lst_Functions.Add_DoubleClick({
            $lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf($lst_Functions.SelectedItem.ToString()), $true)
            $bldStr = "$($lst_Functions.SelectedItem.ToString())"
            $parameters = (get-command ($lst_Functions.SelectedItem.ToString())).Parameters
            foreach ($param in $parameters){
                foreach ($key in $param.Keys) {
                    switch ($key) {
                        Verbose{};Debug{};ErrorAction{};WarningAction{};InformationAction{};ErrorVariable{};WarningVariable{};InformationVariable{};OutVariable{};OutBuffer{};PipelineVariable{};
                        Default {
                            $bldStr = "$bldStr -$((($Key) | Out-String).Trim()) `$$((($Key) | Out-String).Trim())"
                        }
                    }
                }
            }
            $FastText.SelectedText = $bldStr
        })
        
        $lst_Functions.add_SelectedIndexChanged({param($sender, $e)
            $lst_Params.text = "$(((Get-Help $lst_Functions.SelectedItem.ToString() -detailed) | Out-String))"
        })
        
        function EmptyListString{
            foreach ($item in $lst_Functions.items){
                if ($item.ToString() -eq ""){
                    $lst_Functions.items.Remove($item)
                    EmptyListString
                    return
                }
            }
        }
        EmptyListString
        
        $tsRunBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Run Script File | F9"})
        $tsGenerateBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Generate Script File | F8"})
        $tsTermBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Load Functions Module in PowerShell | F7"})
        $tsFormTreeBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Form Tree | F2"})
        $tsEventsBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Events | F4"})
        $tsPropertiesBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Properties | F3"})
        $tsToolBoxBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "ToolBox | F1"})
        $tsMoveDownBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Move Down | F5"})
        $tsMoveUpBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Move Up | F6"})
        $tsControlPasteBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Paste Control | Ctrl+Alt+V"})
        $tsControlCopyBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Copy Control | Ctrl+Alt+C"})
        $tsDeleteBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Delete Control | Ctrl+D"})
        $tsRenameBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Rename Control | Ctrl+R"})
        $tsExpandAllBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Expand All | F11"})
        $tsCollapseAllBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Collapse All | F10"})
        $tsGoToLineBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Go To Line... | Ctrl+G"})
        $tsReplaceBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Replace | Ctrl+H"})
        $tsFindBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Find | Ctrl+F"})
        $tsSelectAllBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Select All | Ctrl+A"})
        $tsPasteBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Paste | Ctrl+V"})
        $tsCopyBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Copy | Ctrl+C"})
        $tsCutBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Cut | Ctrl+X"})
        $tsRedoBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Redo | Ctrl+Z"})
        $tsUndoBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Undo | Ctrl+Y"})
        $tsSaveAsbtn.Add_MouseEnter{($tsl_StatusLabel.Text = "Save As | Ctrl+Alt+S")}
        $tsSavebtn.Add_MouseEnter{($tsl_StatusLabel.Text = "Save | Ctrl+S")}
        $tsOpenbtn.Add_MouseEnter({$tsl_StatusLabel.Text = "Open | Ctrl+O"})
        $tsNewBtn.Add_MouseEnter({$tsl_StatusLabel.Text = "New | Ctrl+N"})
        
        $btn_Find.add_Click({param($sender, $e)
            if ($lst_Find.SelectedIndex -eq -1){
            Assert-List $lst_Find Add $txt_Find.text
            }
            else{
            Assert-List $lst_Find Insert $txt_Find.text
            }
                $txt_Find.text = ""
        })
        
        $btn_RemoveFind.add_Click({param($sender, $e)
        $lst_Find.Items.Remove($lst_Find.SelectedItem)
        })
        
        $lst_Find.add_DoubleClick({
           $FastText.ShowFindDialog($lst_Find.SelectedItem)       
           Send-Window $FindWindowHandle $(Get-CarriageReturn)
           Send-Window $FindWindowHandle $(Get-CarriageReturn)
        })
        
        $MainForm.WindowState = "Maximized"
        Assert-List $lst_Find Add ""
        $FastText.ShowFindDialog()
        $FindWindowHandle = (winexists 'Find')
        Set-WindowParent $FindWindowHandle $MainForm.Handle
        $FastText.ShowReplaceDialog()
        $ReplaceWindowHandle = (winexists 'Find and replace')
        Set-WindowParent $ReplaceWindowHandle $MainForm.Handle
        Move-Window $FindWindowHandle ($MainForm.Width - 625) 75 ((winpos $FindWindowHandle).Width) ((winpos $FindWindowHandle).Height)
        Move-Window $ReplaceWindowHandle ($MainForm.Width - 625) 225 ((winpos $ReplaceWindowHandle).Width) ((winpos $ReplaceWindowHandle).Height)
        Hide-Window $FindWindowHandle
        Hide-Window $ReplaceWindowHandle
     
        $FastText.Add_Click({param($sender, $e)
            $FastText.OnTextChanged()
        })   
        
        if ($null -ne $args[1]){
            if (($args[0].tolower() -eq "-file") -and (Test-File $args[1])){OpenProjectClick $args[1]}
        }
    }
    catch {
        Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered unexpectedly at ShowDialog."
    }





Show-Form $MainForm}); $PowerShell.AddParameter('File',$args[0]);$PowerShell.Invoke(); $PowerShell.Dispose()
