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
        Last Updated: 4/20/2024
        Version:      v3.0.0
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
		
BASIC MODIFICATIONS License
#This software has been modified from the original as tagged with #brandoncomputer
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

$folderExists = Test-Path -path ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions")
if ($folderExists -eq $false){
	New-Item -ItemType directory -Path ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions")
}

$functionsExists = Test-Path -path ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\functions.ps1")
if ($functionsExists -eq $false){
	Copy-Item -Path "$PSScriptRoot\functions.ps1" -destination ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\functions.ps1")
}

$dependenciesExists = Test-Path -path ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\Dependencies.ps1")
if ($dependenciesExists -eq $false){
	Copy-Item -Path "$PSScriptRoot\Dependencies.ps1" -destination ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\Dependencies.ps1")
}

# ScriptBlock to Execute in STA Runspace
$sbGUI = {
	    param($BaseDir,$DPI)
		
function Set-Types {
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
Set-Types

$global:control_track = @{}


    #region Functions

function Set-EnableVisualStyle {
	[vds]::SetCompat() | out-null
}

function Set-DPIAware {
	$vscreen = [System.Windows.Forms.SystemInformation]::VirtualScreen.height
	[vds]::SetProcessDPIAware() | out-null
	$screen = [System.Windows.Forms.SystemInformation]::VirtualScreen.height
	$global:ctscale = ($screen/$vscreen)
}

Set-EnableVisualStyle
Set-DPIAware

function Show-Form {
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

function Get-CurrentDirectory {
    return (Get-Location | Select-Object -expandproperty Path | Out-String).Trim()
}

function ConvertFrom-WinFormsXML {
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

function New-Timer {
<#
    .SYNOPSIS
		Returns a timer object that ticks at the interval specified
     
    .DESCRIPTION
		This function returns a timer object that ticks at the interval specified
	
	.PARAMETER Interval
		The interval in milliseconds
		
	.EXAMPLE
		$timer1 = New-Timer 1000
	
	.EXAMPLE
		$timer1 = New-Timer -interval 1000
		
	.EXAMPLE
		$timer1 = 1000 | New-Timer
		
	.EXAMPLE
		$timer1 = 1000 | New-Timer
		$timer1.Add_Tick({
			Write-Host "Tick"
		})
	
	.INPUTS
		Interval as Integer
	
	.OUTPUTS
		System.Windows.Forms.Timer
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Interval
	)
	$timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = $Interval
    $timer.Enabled = $true
    return $timer
}


    function Convert-XmlToTreeView {
        param(
            [System.Xml.XmlLinkedNode]$Xml,
            $TreeObject,
            [switch]$IncrementName
        )

        try {
            $controlType = $Xml.ToString()
            $controlName = "$($Xml.Name)"
			
			if ($controlType -eq "Functions" -or $controlType -eq "Function"){return}
            
            if ( $IncrementName ) {
                $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode
                $returnObj = [pscustomobject]@{OldName=$controlName;NewName=""}
                $loop = 1

                while ( $objRef.Objects.Keys -contains $controlName ) {
                    if ( $controlName.Contains('_') ) {
                        $afterLastUnderscoreText = $controlName -replace "$($controlName.Substring(0,($controlName.LastIndexOf('_') + 1)))"

                        if ( $($afterLastUnderscoreText -replace "\D").Length -eq $afterLastUnderscoreText.Length ) {
                            $controlName = $controlName -replace "_$($afterLastUnderscoreText)$","_$([int]$afterLastUnderscoreText + 1)"
                        } else {$controlName = $controlName + '_1'}
                    } else {$controlName = $controlName + '_1' }

                        # Make sure does not cause infinite loop
                    if ( $loop -eq 1000 ) {throw "Unable to determine incremented control name."}
                    $loop++
                }

                $returnObj.NewName = $controlName
                $returnObj
            }

            if ( $controlType -ne 'SplitterPanel' ) {Add-TreeNode -TreeObject $TreeObject -ControlType $controlType -ControlName $controlName}

            $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode
            $newControl = $objRef.Objects[$controlName]

            $Xml.Attributes.GetEnumerator().ForEach({
                if ( $_.ToString() -ne 'Name' ) {
                    if ( $null -eq $objRef.Changes[$controlName] ) {$objRef.Changes[$controlName] = @{}}

                    if ( $null -ne $($newControl.$($_.ToString())) ) {
						
						#brandoncomputer_loadformDPIFix
						
						#begin dpi
						
					#	info $_.ToString()
	
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
				
				
						
						#end dpi
						
						
                        if ( $($newControl.$($_.ToString())).GetType().Name -eq 'Boolean' ) {
                            if ( $_.Value -eq 'True' ) {$value = $true} else {$value = $false}
                        } else {$value = $_.Value}
                    } else {$value = $_.Value}
					
#brandoncomputer_ContextStripModify
				
                    try {if ($controlType -ne "ContextMenuStrip") {$newControl.$($_.ToString()) = $value}}
                    catch {if ( $_.Exception.Message -notmatch 'MDI container forms must be top-level' ) {throw $_}}

                    $objRef.Changes[$controlName][$_.ToString()] = $_.Value
                }
            })

            if ( $Xml.ChildNodes.Count -gt 0 ) {
                if ( $IncrementName ) {$Xml.ChildNodes.ForEach({Convert-XmlToTreeView -Xml $_ -TreeObject $objRef.TreeNodes[$controlName] -IncrementName})}
                else {$Xml.ChildNodes.ForEach({Convert-XmlToTreeView -Xml $_ -TreeObject $objRef.TreeNodes[$controlName]})}
            }
        } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered adding '$($Xml.ToString()) - $($Xml.Name)' to Treeview."}
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

            if ( $ControlInfo.Events ) {$ControlInfo.Events.ForEach({$refControl[$_.Name]."add_$($_.EventType)"($_.ScriptBlock)})}

            if ( $Reference -ne '' ) {New-Variable -Name $Reference -Scope Script -Value $refControl}

            Remove-Variable -Name refGuid -Scope Script

            if ( $Suppress -eq $false ) {return $control}
        } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered getting custom control."}
    }

    function Get-UserInputFromForm {
        param([string]$SetText)
        
        try {
            $inputForm = Get-CustomControl -ControlInfo $Script:childFormInfo['NameInput']

            if ( $inputForm ) {
                $inputForm.AcceptButton = $inputForm.Controls['StopDingOnEnter']

                $inputForm.Controls['UserInput'].Text = $SetText

                [void]$inputForm.ShowDialog()

                $returnVal = [pscustomobject]@{
                    Result = $inputForm.DialogResult
                    NewName = $inputForm.Controls['UserInput'].Text
                }
                return $returnVal
            }
        } catch {
            Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered setting new control name."
        } finally {
            try {$inputForm.Dispose()}
            catch {if ( $_.Exception.Message -ne "You cannot call a method on a null-valued expression." ) {throw $_}}
        }
    }

    function Add-TreeNode {
        param(
            $TreeObject,
            [string]$ControlType,
            [string]$ControlName,
			[string]$ControlText
        )
		
#		info $TreeObject.ToString()
		
		if ($ControlText)
		{}
		else {
		if ($control_track.$controlType -eq $null){
		$control_track[$controlType] = 1
		}
		else {
		$control_track.$controlType = $control_track.$controlType + 1
		}
		}
		
#brandoncomputer_ToolStripAlias2		
		if ($ControlType -eq 'ToolStrip')
		{$ControlType = 'MenuStrip'}
		
		

        if ( $ControlName -eq '' ) {
            $userInput = Get-UserInputFromForm -SetText "$($Script:supportedControls.Where({$_.Name -eq $ControlType}).Prefix)_"

            if ( $userInput.Result -eq 'OK' ) {$ControlName = $userInput.NewName}
        }

        try {
            if ( $TreeObject.GetType().Name -eq 'TreeView' ) {
                if ( $ControlType -eq 'Form' ) {
                        # Clear the Assigned Events ListBox
                    $Script:refs['lst_AssignedEvents'].Items.Clear()
                    $Script:refs['lst_AssignedEvents'].Items.Add('No Events')
                    $Script:refs['lst_AssignedEvents'].Enabled = $false
                    
                        # Create the TreeNode
                    $newTreeNode = $TreeObject.Nodes.Add($ControlName,"Form - $($ControlName)")

	
                        # Create the Form
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
					
                    $form.Add_Click({
                        if (( $Script:refs['PropertyGrid'].SelectedObject -ne $this ) -and ( $args[1].Button -eq 'Left' )) {
                            $Script:refs['TreeView'].SelectedNode = $Script:refsFID.Form.TreeNodes[$this.Name]
                        }
                    })
                    $form.Add_ReSize({
                        if ( $Script:refs['PropertyGrid'].SelectedObject -ne $this ) {$Script:refs['TreeView'].SelectedNode = $Script:refsFID.Form.TreeNodes[$this.Name]}

                        $Script:refs['PropertyGrid'].Refresh()

                        $this.ParentForm.Refresh()
						
                    })
                    $form.Add_LocationChanged({$this.ParentForm.Refresh()})
                    $form.Add_ReSizeEnd({
                        if ( $Script:refs['PropertyGrid'].SelectedObject -ne $this ) {$Script:refs['TreeView'].SelectedNode = $Script:refsFID.Form.TreeNodes[$this.Name]}
                        
                        $Script:refs['PropertyGrid'].Refresh()

                        $this.ParentForm.Refresh()
                    })

                        # Add the selected object control buttons
                    $Script:sButtons = $null
                    Remove-Variable -Name sButtons -Scope Script -ErrorAction SilentlyContinue
#brandoncomputer_sizeButtons
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_SizeAll" Cursor="SizeAll" BackColor="White" Size="8,8" Visible="False" />'
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_TLeft" Cursor="SizeNWSE" BackColor="White" Size="8,8" Visible="False" />'
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_TRight" Cursor="SizeNESW" BackColor="White" Size="8,8" Visible="False" />'
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_BLeft" Cursor="SizeNESW" BackColor="White" Size="8,8" Visible="False" />'
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_BRight" Cursor="SizeNWSE" BackColor="White" Size="8,8" Visible="False" />'
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_MLeft" Cursor="SizeWE" BackColor="White" Size="8,8" Visible="False" />'
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_MRight" Cursor="SizeWE" BackColor="White" Size="8,8" Visible="False" />'
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_MTop" Cursor="SizeNS" BackColor="White" Size="8,8" Visible="False" />'
                    ConvertFrom-WinFormsXML -ParentControl $form -Reference sButtons -Suppress -Xml '<Button Name="btn_MBottom" Cursor="SizeNS" BackColor="White" Size="8,8" Visible="False" />'

                        # Add the Mouse events to each of the selected object control buttons
                    $sButtons.GetEnumerator().ForEach({
                        $_.Value.Add_MouseMove({
                            param($Sender, $e)

                            try {
                                $currentMousePOS = [System.Windows.Forms.Cursor]::Position
                                    # If mouse button equals left and there was a change in mouse position (reduces flicker due to control refreshes during Move-SButtons)
                                if (( $e.Button -eq 'Left' ) -and (( $currentMousePOS.X -ne $Script:oldMousePOS.X ) -or ( $currentMousePOS.Y -ne $Script:oldMousePOS.Y ))) {
                                
                                    if ( @('SplitterPanel','TabPage') -notcontains $Script:refs['PropertyGrid'].SelectedObject.GetType().Name ) {
                                        $sObj = $Script:sRect

                                        $msObj = @{}

                                        switch ($Sender.Name) {
                                                btn_SizeAll {
                                                    if (( @('FlowLayoutPanel','TableLayoutPanel') -contains $Script:refs['PropertyGrid'].SelectedObject.Parent.GetType().Name ) -or
                                                       ( $Script:refs['PropertyGrid'].SelectedObject.Dock -ne 'None' )) {
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
                                } else {$Script:oldMousePos = [System.Windows.Forms.Cursor]::Position}
                            } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered while moving mouse over selected control."}
                        })
                        $_.Value.Add_MouseUp({
                          #  Move-SButtons -Object $Script:refs['PropertyGrid'].SelectedObject
                        })
                    })

                        # Set MDIParent and Show Form
                    $form.MDIParent = $refs['MainForm']
                    $form.Show()

                        # Create reference object for the Form In Design
                    $Script:refsFID = @{
                        Form = @{
                            TreeNodes=@{"$($ControlName)" = $newTreeNode}
                            Objects=@{"$($ControlName)" = $form}
                            Changes=@{}
                            Events=@{}
                        }
                    }
                } elseif (( @('ContextMenuStrip','Timer') -contains $ControlType ) -or ( $ControlType -match "Dialog$" )) {
                    $newTreeNode = $Script:refs['TreeView'].Nodes.Add($ControlName,"$($ControlType) - $($ControlName)")
                    
                    if ( $null -eq $Script:refsFID[$ControlType] ) {$Script:refsFID[$ControlType]=@{}}

                    $Script:refsFID[$ControlType][$ControlName] = @{
                        TreeNodes = @{"$($ControlName)" = $newTreeNode}
                        Objects = @{"$($ControlName)" = New-Object System.Windows.Forms.$ControlType}
                        Changes = @{}
                        Events = @{}
                    }
                }
            } else {
                if (( $ControlName -ne '' ) -and ( $ControlType -ne 'SplitterPanel' )) {
                    $objRef = Get-RootNodeObjRef -TreeNode $TreeObject

                    if ( $objRef.Success -ne $false ) {
                        $newControl = New-Object System.Windows.Forms.$ControlType
						$newControl.Name = $ControlName
						
						switch ($ControlType){
							'DateTimePicker'{}
							'WebBrowser'{}
							default{$newControl.Text = $controlText}
						}
						if ($newControl.height){
						$newControl.height = $newControl.height * $ctscale}
						if ($newControl.width){
						$newControl.width = $newControl.width * $ctscale}
#brandoncomputer_ImageScalingSize
						if ($newControl.ImageScalingSize)
						{
							$newControl.imagescalingsize = new-object System.Drawing.Size([int]($ctscale * $newControl.imagescalingsize.width),[int]($ctscale * $newControl.imagescalingsize.Height))} 
#brandoncomputer_ToolStripException
					if ( $ControlType -eq "ToolStrip" ) {
						$objRef.Objects[$TreeObject.Name].Controls.Add($newControl)}
					else{
                        if ( $ControlType -match "^ToolStrip" ) {
                            if ( $objRef.Objects[$TreeObject.Name].GetType().Name -match "^ToolStrip" ) {
								 if ($objRef.Objects[$TreeObject.Name].GetType().ToString() -eq "System.Windows.Forms.ToolStrip"){
									 [void]$objRef.Objects[$TreeObject.Name].Items.Add($newControl)
								 }
								 else {
									 [void]$objRef.Objects[$TreeObject.Name].DropDownItems.Add($newControl)
								}
							}
								
                            else {
								[void]$objRef.Objects[$TreeObject.Name].Items.Add($newControl)}
                        } elseif ( $ControlType -eq 'ContextMenuStrip' ) {
                            $objRef.Objects[$TreeObject.Name].ContextMenuStrip = $newControl
                        } else {$objRef.Objects[$TreeObject.Name].Controls.Add($newControl)}
					}
						
					
						if ($ControlType -ne 'WebBrowser')
						{						
                        try {
                            $newControl.Add_MouseUp({
                                if (( $Script:refs['PropertyGrid'].SelectedObject -ne $this ) -and ( $args[1].Button -eq 'Left' )) {
                                    $Script:refs['TreeView'].SelectedNode = $Script:refsFID.Form.TreeNodes[$this.Name]
                                }
                            })
                        } catch {
                            if ( $_.Exception.Message -notmatch 'not valid on this control' ) {throw $_}
                        }
						
						}

                        $newTreeNode = $TreeObject.Nodes.Add($ControlName,"$($ControlType) - $($ControlName)")
                        $objRef.TreeNodes[$ControlName] = $newTreeNode
                        $objRef.Objects[$ControlName] = $newControl

                        if ( $ControlType -eq 'SplitContainer' ) {
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

            if ( $newTreeNode ) {
                $newTreeNode.ContextMenuStrip = $Script:reuseContext['TreeNode']
                $Script:refs['TreeView'].SelectedNode = $newTreeNode

                if (( $ControlType -eq 'TabControl' ) -and ( $Script:openingProject -eq $false )) {Add-TreeNode -TreeObject $newTreeNode -ControlType TabPage -ControlName 'Tab 1'}
				
            }
        } catch {Update-ErrorLog -ErrorRecord $_ -Message "Unable to add $($ControlName) to $($objRef.Objects[$TreeObject.Name])."}
    }

    function Get-ChildNodeList {
        param(
            $TreeNode,
            [switch]$Level
        )

        $returnVal = @()

        if ( $TreeNode.Nodes.Count -gt 0 ) {
            try {
                $TreeNode.Nodes.ForEach({
                    $returnVal += $(if ( $Level ) { "$($_.Level):$($_.Name)" } else {$_.Name})
                    $returnVal += $(if ( $Level ) { Get-ChildNodeList -TreeNode $_ -Level } else { Get-ChildNodeList -TreeNode $_ })
                })
            } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered building Treenode list."}
        }

        return $returnVal
    }

    function Get-RootNodeObjRef {
        param([System.Windows.Forms.TreeNode]$TreeNode)

        try {
            if ( $TreeNode.Level -gt 0 ) {while ( $TreeNode.Parent ) {$TreeNode = $TreeNode.Parent}}

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

            if ( $type -eq 'Form' ) {
                $returnVal.TreeNodes = $Script:refsFID[$type].TreeNodes
                $returnVal.Objects = $Script:refsFID[$type].Objects
                $returnVal.Changes = $Script:refsFID[$type].Changes
                $returnVal.Events = $Script:refsFID[$type].Events
            } elseif (( @('ContextMenuStrip','Timer') -contains $type ) -or ( $type -match "Dialog$" )) {
                $returnVal.TreeNodes = $Script:refsFID[$type][$name].TreeNodes
                $returnVal.Objects = $Script:refsFID[$type][$name].Objects
                $returnVal.Changes = $Script:refsFID[$type][$name].Changes
                $returnVal.Events = $Script:refsFID[$type][$name].Events
            } else {$returnVal.Success = $false}

            return $returnVal
        } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered determining root node object reference."}
    }

    function Move-SButtons {
        param($Object)
			
			if ($Object.GetType().Name -eq 'ToolStripProgressBar')
			{return}
		
        if ( ($Script:supportedControls.Where({$_.Type -eq 'Parentless'}).Name + @('Form','ToolStripMenuItem','ToolStripComboBox','ToolStripTextBox','ToolStripSeparator','ContextMenuStrip')) -notcontains $Object.GetType().Name ) {
				      
		  $newSize = $Object.Size
            if ( $Object.GetType().Name -ne 'HashTable' ) {

                $refFID = $Script:refsFID.Form.Objects.Values.Where({$_.GetType().Name -eq 'Form'})
                $Script:sButtons.GetEnumerator().ForEach({$_.Value.Visible = $true})
                $newLoc = $Object.PointToClient([System.Drawing.Point]::Empty)
                
                if ( $Script:MouseMoving -eq $true ) {
                    $clientParent = $Object.Parent.PointToClient([System.Drawing.Point]::Empty)
                    $clientForm = $refFID.PointToClient([System.Drawing.Point]::Empty)
					
                    $clientOffset = New-Object System.Drawing.Point((($clientParent.X - $clientForm.X) * -1),(($clientParent.Y - $clientForm.Y) * -1))
                } else {$clientOffset = New-Object System.Drawing.Point(0,0)}
                
			#	info "bean"
		#	info ($Object.Left).ToString()
		#	$newLoc.X = ($newLoc.X * -1) - $Object.Left - ($refs['MainForm'].Location.X) - $clientOffset.X  - $Script:refs['ms_Left'].Size.Width #- (18 / $ctscale)
		#	$newLoc.Y = ($newLoc.Y * -1) - $Object.Top - ($refs['MainForm'].Location.Y) - $clientOffset.Y #- (108 / $ctscale)
		if ($ctscale -gt 1){
			if ($Object.Parent.WindowState -eq "Maximized"){
		$newLoc.X = ($newLoc.X * -1) - $refFID.Location.X - $refs['MainForm'].Location.X - $clientOffset.X - $Script:refs['ms_Left'].Size.Width - [math]::Round((15 * $ctscale))
		$newLoc.Y = ($newLoc.Y * -1) - $refFID.Location.Y - $refs['MainForm'].Location.Y - (20 * $ctscale) - $clientOffset.Y - [math]::Round((((108 - ($ctscale * 4 )) * $ctscale)/1))
			}
			else{
                $newLoc.X = ($newLoc.X * -1) - $refFID.Location.X - $refs['MainForm'].Location.X - $clientOffset.X - $Script:refs['ms_Left'].Size.Width - [math]::Round((15 * $ctscale))
		#$newLoc.Y = ($newLoc.Y * -1) - $refFID.Location.Y - $refs['MainForm'].Location.Y - $clientOffset.Y - (100 * $ctscale)
		$newLoc.Y = ($newLoc.Y * -1) - $refFID.Location.Y - $refs['MainForm'].Location.Y - $clientOffset.Y - [math]::Round((((108 - ($ctscale * 4 )) * $ctscale)/1))
			}
		}
		else
	{
			if ($Object.Parent.WindowState -eq "Maximized"){
			$newLoc.X = ($newLoc.X * -1) - $refFID.Location.X - $refs['MainForm'].Location.X - $clientOffset.X - $Script:refs['ms_Left'].Size.Width - [math]::Round((18 * $ctscale))
			$newLoc.Y = ($newLoc.Y * -1) - $refFID.Location.Y - $refs['MainForm'].Location.Y - (20 * $ctscale) - $clientOffset.Y - [math]::Round((108 * $ctscale))}
			else {$newLoc.X = ($newLoc.X * -1) - $refFID.Location.X - $refs['MainForm'].Location.X - $clientOffset.X - $Script:refs['ms_Left'].Size.Width - [math]::Round((18 * $ctscale))
			$newLoc.Y = ($newLoc.Y * -1) - $refFID.Location.Y - $refs['MainForm'].Location.Y - $clientOffset.Y - [math]::Round((108 * $ctscale))}
			
			}
		

		

                if ( $Script:refs['pnl_Left'].Visible -eq $true ) {$newLoc.X = $newLoc.X - $Script:refs['pnl_Left'].Size.Width - $Script:refs['lbl_Left'].Size.Width}
		} else {$newLoc = New-Object System.Drawing.Point(($Script:sButtons['btn_TLeft'].Location.X + $Object.LocOffset.X),($Script:sButtons['btn_TLeft'].Location.Y + $Object.LocOffset.Y))}

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
                        } else {$btn.Visible = $false}
                    }
                    btn_MRight {
                        if ( $Object.Size.Height -gt 28 ) {
                            $btn.Location = New-Object System.Drawing.Point(($newLoc.X + $newSize.Width - 8),($newLoc.Y + ($newSize.Height / 2) - 4))
                            $btn.Visible = $true
                        } else {$btn.Visible = $false}
                    }
                    btn_MTop {
                        if ( $Object.Size.Width -gt 40 ) {
                            $btn.Location = New-Object System.Drawing.Point(($newLoc.X + ($newSize.Width / 2) - 4),$newLoc.Y)
                            $btn.Visible = $true
                        } else {$btn.Visible = $false}
                    }
                    btn_MBottom {
                        if ( $Object.Size.Width -gt 40 ) {
                            $btn.Location = New-Object System.Drawing.Point(($newLoc.X + ($newSize.Width / 2) - 4),($newLoc.Y + $newSize.Height - 8))
                            $btn.Visible = $true
                        } else {$btn.Visible = $false}
                    }
                }

                $btn.BringToFront()
                $btn.Refresh()
            })

            $Script:refs['PropertyGrid'].SelectedObject.Refresh()
            $Script:refs['PropertyGrid'].SelectedObject.Parent.Refresh()
        } else {$Script:sButtons.GetEnumerator().ForEach({$_.Value.Visible = $false})}
	}

    function Save-Project {
        param(
            [switch]$SaveAs,
            [switch]$Suppress,
            [switch]$ReturnXML
        )

        $projectName = $refs['tpg_Form1'].Text

        if ( $ReturnXML -eq $false ) {
            if (( $SaveAs ) -or ( $projectName -eq 'NewProject.fbs' )) {
                $saveDialog = ConvertFrom-WinFormsXML -Xml @"
<SaveFileDialog InitialDirectory="$($Script:projectsDir)" AddExtension="True" DefaultExt="fbs" Filter="fbs files (*.fbs)|*.fbs" FileName="$($projectName)" OverwritePrompt="True" ValidateNames="True" RestoreDirectory="True" />
"@
                $saveDialog.Add_FileOK({
                    param($Sender,$e)
                    if ( $($this.FileName | Split-Path -Leaf) -eq 'NewProject.fbs' ) {
                        [void][System.Windows.Forms.MessageBox]::Show("You cannot save a project with the file name 'NewProject.fbs'",'Validation Error')
                        $e.Cancel = $true
                    }
                })

                try {
                    [void]$saveDialog.ShowDialog()

                    if (( $saveDialog.FileName -ne '' ) -and ( $saveDialog.FileName -ne 'NewProject.fbs' )) {$projectName = $saveDialog.FileName | Split-Path -Leaf} else {$projectName = ''}
                } catch {
                    Update-ErrorLog -ErrorRecord $_ -Message 'Exception encountered while selecting Save file name.'
                    $projectName = ''
                } finally {
                    $saveDialog.Dispose()
#brandoncomputer_SaveDialogFix
					$global:projectDirName = $saveDialog.FileName
                    Remove-Variable -Name saveDialog
                }
            }
        }

        if ( $projectName -ne '' ) {
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

                            # Set certain properties first
                        $Script:specialProps.Before.ForEach({
                            $prop = $_
                            $tempGI = $tempPGrid.SelectedGridItem.Parent.GridItems.Where({$_.PropertyLabel -eq $prop})

                            if ( $tempGI.Count -gt 0 ) {
                                if ( $tempGI.PropertyDescriptor.ShouldSerializeValue($tempGI.Component) ) {$newElement.SetAttribute($tempGI.PropertyLabel,$tempGI.GetPropertyTextValue())}
                            }
                        })

                            # Set other attributes
                        $tempPGrid.SelectedGridItem.Parent.GridItems.ForEach({
                            $checkReflector = $true
                            $tempGI = $_
                            
                            if ( $Script:specialProps.All -contains $tempGI.PropertyLabel ) {
                                switch ($tempGI.PropertyLabel) {
                                    Location {
                                        if (( $tempPGrid.SelectedObject.Dock -ne 'None' ) -or
                                           ( $tempPGrid.SelectedObject.Parent.GetType().Name -eq 'FlowLayoutPanel' ) -or
                                           (( $newElementType -eq 'Form' ) -and ( $tempPGrid.SelectedObject.StartPosition -ne 'Manual' )) -or
                                           ( $tempGI.GetPropertyTextValue() -eq '0, 0' )) {
                                               $checkReflector = $false
                                        }
                                    }
                                    Size {
                                            # Only check reflector for Size when AutoSize is false and Dock not set to Fill
                                        if (( $tempPGrid.SelectedObject.AutoSize -eq $true ) -or ( $tempPGrid.SelectedObject.Dock -eq 'Fill' )) {
                                                # If control is disabled sometimes AutoSize will return $true even if $false
                                            if (( $tempPGrid.SelectedObject.AutoSize -eq $true ) -and ( $tempPGrid.SelectedObject.Enabled -eq $false )) {
                                                $tempPGrid.SelectedObject.Enabled = $true

                                                if ( $tempGI.PropertyDescriptor.ShouldSerializeValue($tempGI.Component) ) {$newElement.SetAttribute($tempGI.PropertyLabel,$tempGI.GetPropertyTextValue())}

                                                $tempPGrid.SelectedObject.Enabled = $false
                                            }

                                            $checkReflector = $false

                                                # Textbox has an issue here
                                            if (( $newElementType -eq 'Textbox' ) -and ( $tempPGrid.SelectedObject.Size.Width -ne 100 )) {$checkReflector = $true}
                                        }
                                            # Form has an issue here
                                        if (( $newElementType -eq 'Form' ) -and ( $tempPGrid.SelectedObject.Size -eq (New-Object System.Drawing.Size(300,300)) )) {$checkReflector = $false}
                                    }
                                    FlatAppearance {
                                        if ( $tempPGrid.SelectedObject.FlatStyle -eq 'Flat' ) {
                                            $value = ''

                                            $tempGI.GridItems.ForEach({
                                                if ( $_.PropertyDescriptor.ShouldSerializeValue($_.Component.FlatAppearance) ) {$value += "$($_.PropertyLabel)=$($_.GetPropertyTextValue())|"}
                                            })

                                            if ( $value -ne '' ) {$newElement.SetAttribute('FlatAppearance',$($value -replace "\|$"))}
                                        }

                                        $checkReflector = $false
                                    }
                                    default {
                                            # If property has a bad reflector and it has been changed manually add the attribute
                                        if (( $Script:specialProps.BadReflector -contains $_ ) -and ( $null -ne $objRef.Changes[$_] )) {$newElement.SetAttribute($_,$objRef.Changes[$_])}

                                        $checkReflector = $false
                                    }
                                }
                            }

                            if ( $checkReflector ) {
                                if ( $tempGI.PropertyDescriptor.ShouldSerializeValue($tempGI.Component) ) {
                                    $newElement.SetAttribute($tempGI.PropertyLabel,$tempGI.GetPropertyTextValue())
                                } elseif (( $newElementType -eq 'Form' ) -and ( $tempGI.PropertyLabel -eq 'Size') -and ( $tempPGrid.SelectedObject.AutoSize -eq $false )) {
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
                                            } else {
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
                                    } else {
                                        if ( $objRef.Objects[$nodeName].$prop.Count -gt 0 ) {
                                            $value = ''

                                            $objRef.Objects[$nodeName].$prop.ForEach({$value += "$($_)|*BreakPT*|"})

                                            $newElement.SetAttribute($prop,$($value -replace "\|\*BreakPT\*\|$"))
                                        }
                                    }
                                } else {
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
				if ($dpi -eq 'dpi') {
					
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
#brandoncomputer_SaveFix
                    #$xml.Save("$($Script:projectsDir)\$($projectName)")
					$xml.Save($global:projectDirName)

                    $refs['tpg_Form1'].Text = $projectName
					
#brandoncomputer_FastTextSaveFile
					$generationPath = "$(Split-Path -Path $global:projectDirName)\$($projectName -replace "\..*$")"
					if (Test-Path -path $generationPath) {
						#do nothing
					}
					else {
					New-Item -ItemType directory -Path $generationPath
					}
					$ascii = new-object System.Text.ASCIIEncoding
					$FastText.SaveToFile("$generationPath\Events.ps1",$ascii)


                    if ( $Suppress -eq $false ) {$Script:refs['tsl_StatusLabel'].text = 'Successfully Saved!'}
                }
            } catch {
                if ( $ReturnXML ) {
                    Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered while generating Form XML."
                    return $xml
                }
                else {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered while saving project."}
            } finally {
                if ( $tempPGrid ) {$tempPGrid.Dispose()}
            }
        } else {throw 'SaveCancelled'}
    }
    
    #endregion Functions

    #region Event ScriptBlocks

    $eventSB = @{
        'MainForm' = @{
            FormClosing = {
                try {
                    $Script:refs['TreeView'].Nodes.ForEach({
                        $controlName = $_.Name
                        $controlType = $_.Text -replace " - .*$"

                        if ( $controlType -eq 'Form' ) {$Script:refsFID.Form.Objects[$controlName].Dispose()}
                        else {$Script:refsFID[$controlType][$controlName].Objects[$controlName].Dispose()}
                    })
                } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered during Form closure."}
            }
        }
        'New' = @{
            Click = {
				
                try {
					
					if ( [System.Windows.Forms.MessageBox]::Show("Unsaved changes to the current project will be lost.  Are you sure you want to start a new project?", 'Confirm', 4) -eq 'Yes' ) {
						$global:control_track = @{}
                        $projectName = "NewProject.fbs"
						$FastText.Clear()
$FastText.SelectedText = "#region Images
						
#endregion

"

						try{
						$FastText.CollapseFoldingBlock(0)}
						catch{}
						
						$refs['tpg_Form1'].Text = $projectName
						$Script:refs['TreeView'].Nodes.ForEach({
                            $controlName = $_.Name
                            $controlType = $_.Text -replace " - .*$"

                            if ( $controlType -eq 'Form' ) {$Script:refsFID.Form.Objects[$controlName].Dispose()}
                            else {$Script:refsFID[$controlType][$controlName].Objects[$ControlName].Dispose()}
                        })

                        $Script:refs['TreeView'].Nodes.Clear()

                        Add-TreeNode -TreeObject $Script:refs['TreeView'] -ControlType Form -ControlName MainForm
						#brandoncomputer_newResize
						$Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].height = $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].height * $ctscale
						$Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].width = $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].width * $ctscale
						$Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].tag = "VisualStyle,DPIAware"
						
						$baseicon = $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].Icon
					
					}
                } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered during start of New Project."}
            }
        }
        'Open' = @{
            Click = {
                if ( [System.Windows.Forms.MessageBox]::Show("You will lose all changes to the current project.  Are you sure?", 'Confirm', 4) -eq 'Yes' ) {
                    $openDialog = ConvertFrom-WinFormsXML -Xml @"
<OpenFileDialog InitialDirectory="$($Script:projectsDir)" AddExtension="True" DefaultExt="fbs" Filter="fbs files (*.fbs)|*.fbs" FilterIndex="1" ValidateNames="True" CheckFileExists="True" RestoreDirectory="True" />
"@
                    try {
                        $Script:openingProject = $true

                        if ( $openDialog.ShowDialog() -eq 'OK' ) {
                            $fileName = $openDialog.FileName
							 if ($openDialog.FileName) {
	
for($i=0; $i -lt $lst_Functions.Items.Count; $i++)
{$lst_Functions.SetItemChecked($i,$false)}
	
							 
								 $global:control_track = @{}
                            
                            New-Object -TypeName XML | ForEach-Object {
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
										$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf($_.Name),$true)
									}
								}
                            }
                            #>
                            $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode

                            if ( $objRef.Events[$Script:refs['TreeView'].SelectedNode.Name] ) {
                                $Script:refs['lst_AssignedEvents'].BeginUpdate()
                                $Script:refs['lst_AssignedEvents'].Items.Clear()

                                [void]$Script:refs['lst_AssignedEvents'].Items.AddRange($objRef.Events[$Script:refs['TreeView'].SelectedNode.Name])

                                $Script:refs['lst_AssignedEvents'].EndUpdate()

                                $Script:refs['lst_AssignedEvents'].Enabled = $true
                            }
                        }
						}

                        $Script:openingProject = $false
						
						 if ($openDialog.FileName) {

                        $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].Visible = $true
						$Script:refs['tpg_Form1'].Text = "$($openDialog.FileName -replace "^.*\\")"
                        $Script:refs['TreeView'].SelectedNode = $Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }
#brandoncomputer_OpenDialogFix					

						$global:projectDirName = $openDialog.FileName
#brandoncomputer_FastTextOpenFile
					$projectName = $Script:refs['tpg_Form1'].Text
					$generationPath = "$(Split-Path -Path $global:projectDirName)\$($projectName -replace "\..*$")"
					
						
					
						if (Test-Path -path "$generationPath\Events.ps1") {
							$FastText.OpenFile("$generationPath\Events.ps1")	
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
						
						try{
						$FastText.CollapseFoldingBlock(0)}
						catch{}
					


					}
					
                    } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered while opening $($fileName)."}
                    finally {
                        $Script:openingProject = $false

                        $openDialog.Dispose()
                        Remove-Variable -Name openDialog

                        $Script:refs['TreeView'].Focus()
						
                    }
                }
            }
        }
        'Rename' = @{
            Click = {
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
                        } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered renaming '$($Script:refs['TreeView'].SelectedNode.Text)'."}
                    }
                } else {[void][System.Windows.Forms.MessageBox]::Show("Cannot perform any action from the 'Edit' Menu against a SplitterPanel control.",'Restricted Action')}
            }
        }
        'Delete' = @{
            Click = {
                if ( $Script:refs['TreeView'].SelectedNode.Text -notmatch "^SplitterPanel" ) {
                    try {
                        $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode
                        
                        if (( $objRef.Success -eq $true ) -and ( $Script:refs['TreeView'].SelectedNode.Level -ne 0 ) -or ( $objRef.RootType -ne 'Form' )) {
                            if ( [System.Windows.Forms.MessageBox]::Show("Are you sure you wish to remove the selected node and all child nodes? This cannot be undone." ,"Confirm Removal" , 4) -eq 'Yes' ) {
                                    # Generate array of TreeNodes to delete
									
                                $nodesToDelete = @($($Script:refs['TreeView'].SelectedNode).Name)
                                $nodesToDelete += Get-ChildNodeList -TreeNode $Script:refs['TreeView'].SelectedNode
                                
                                (($nodesToDelete.Count-1)..0).ForEach({
                                        # If the node is currently copied remove nodeClipboard
                                    if ( $objRef.TreeNodes[$nodesToDelete[$_]] -eq $Script:nodeClipboard.Node ) {
                                        $Script:nodeClipboard = $null
                                        Remove-Variable -Name nodeClipboard -Scope Script
                                    }

                                        # Dispose of the Form control and remove it from the Form object
                                    if ( $objRef.TreeNodes[$nodesToDelete[$_]].Text -notmatch "^SplitterPanel" ) {$objRef.Objects[$nodesToDelete[$_]].Dispose()}
                                    $objRef.Objects.Remove($nodesToDelete[$_])

                                        # Remove the actual TreeNode from the TreeView control and remove it from the Form object
                                    $objRef.TreeNodes[$nodesToDelete[$_]].Remove()
                                    $objRef.TreeNodes.Remove($nodesToDelete[$_])

                                        # Remove any changes or assigned events associated with the deleted TreeNodes from the Form object
                                    if ( $objRef.Changes[$nodesToDelete[$_]] ) {$objRef.Changes.Remove($nodesToDelete[$_])}
                                    if ( $objRef.Events[$nodesToDelete[$_]] ) {$objRef.Events.Remove($nodesToDelete[$_])}
                                })
                            }
                        } else {$Script:refs['tsl_StatusLabel'].text = 'Cannot delete the root Form.  Start a New Project instead.'}
                    } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered deleting '$($Script:refs['TreeView'].SelectedNode.Text)'."}
                } else {[void][System.Windows.Forms.MessageBox]::Show("Cannot perform any action from the 'Edit' Menu against a SplitterPanel control.",'Restricted Action')}
            }
        }
        'CopyNode' = @{
            Click = {
                if ( $Script:refs['TreeView'].SelectedNode.Level -gt 0 ) {
                    $Script:nodeClipboard = @{
                        ObjRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode
                        Node = $Script:refs['TreeView'].SelectedNode
                    }
                } else {[void][System.Windows.Forms.MessageBox]::Show('You cannot copy a root node.  It will be necessary to copy each individual subnode separately after creating the root node manually.')}
            }
        }
        'PasteNode' = @{
            Click = {
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
                            } else {[array]$newNodeNames = Convert-XmlToTreeView -TreeObject $Script:refs['TreeView'].SelectedNode -Xml $pastedXml.Node}

                            $Script:refs['TreeView'].EndUpdate()

                            Move-SButtons -Object $refs['PropertyGrid'].SelectedObject

                            $newNodeNames.ForEach({if ( $Script:nodeClipboard.ObjRef.Events["$($_.OldName)"] ) {$objRef.Events["$($_.NewName)"] = $Script:nodeClipboard.ObjRef.Events["$($_.OldName)"]}})
                        } else {
							                           $pastedObjName = $Script:nodeClipboard.Node.Name
                            $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].TopNode

                            $xml = Save-Project -ReturnXML

                            $pastedXML = Select-Xml -Xml $xml -XPath "//$($Script:nodeClipboard.ObjRef.RootType)[@Name=`"$($Script:nodeClipboard.ObjRef.RootName)`"]//$($pastedObjType)[@Name=`"$($pastedObjName)`"]"

                            $Script:refs['TreeView'].BeginUpdate()

                            if (( $objRef.RootType -eq $Script:nodeClipboard.ObjRef.RootType ) -and ( $objRef.RootName -eq $Script:nodeClipboard.ObjRef.RootName )) {
                                [array]$newNodeNames = Convert-XmlToTreeView -TreeObject $Script:refs['TreeView'].TopNode -Xml $pastedXml.Node -IncrementName
                            } else {[array]$newNodeNames = Convert-XmlToTreeView -TreeObject $Script:refs['TreeView'].TopNode -Xml $pastedXml.Node}

                            $Script:refs['TreeView'].EndUpdate()

                            Move-SButtons -Object $refs['PropertyGrid'].SelectedObject

                            $newNodeNames.ForEach({if ( $Script:nodeClipboard.ObjRef.Events["$($_.OldName)"] ) {$objRef.Events["$($_.NewName)"] = $Script:nodeClipboard.ObjRef.Events["$($_.OldName)"]}})				
						}
                    }
                } catch {Update-ErrorLog -ErrorRecord $_ -Message 'Exception encountered while pasting node from clipboard.'}
            }
        }
        'Move Up' = @{
            Click = {
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
                } catch {Update-ErrorLog -ErrorRecord $_ -Message 'Exception encountered increasing index of TreeNode.'}
            }
        }
        'Move Down' = @{
            Click = {
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
                } catch {Update-ErrorLog -ErrorRecord $_ -Message 'Exception encountered decreasing index of TreeNode.'}
            }
        }

		'Generate Script File' = @{
		#bookmark
			Click = {
				$projectName = $Script:refs['tpg_Form1'].Text
				if ("$global:projectDirName" -eq "") {
					[System.Windows.Forms.MessageBox]::Show("Please save this project before generating a script file","Script not generated",'OK',64) | Out-Null
					return
				}
				#iex (Get-Content (([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\Dependencies.ps1")) | Out-String)

				$generationPath = "$(Split-Path -Path $global:projectDirName)\$($projectName -replace "\..*$")"
				$designerpath = ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\Functions.ps1")
				New-Variable astTokens -Force
				New-Variable astErr -Force
				$AST = [System.Management.Automation.Language.Parser]::ParseFile($designerpath, [ref]$astTokens, [ref]$astErr)
				$functions = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
				$outstring = "#region VDS
`$PowerShell = [powershell]::Create(); [void]`$PowerShell.AddScript({"

#string checkItem = CheckedListBox.GetItemCheckState(CheckedListBox.Items.IndexOf(checkeditem)).ToString();

foreach ($item in $lst_Functions.items){
	$checkItem = $lst_Functions.GetItemCheckState($lst_Functions.Items.IndexOf($item)).ToString()
	$i = $lst_Functions.Items.IndexOf($item)
	if ($checkItem -eq 'Checked') {
		$outstring = "$outstring
				
$(($functions[$i].Extent).text)"	
	}
}

<# 
				$outstring = "$outstring$(($functions[0].Extent).text)"

				for($i=1; $i -le 6; $i++){
				$outstring = "$outstring
				
$(($functions[$i].Extent).text)"
				}			
 #>
			
				
				$xmlObj = [xml](([xml](Get-Content "$global:projectDirName" -Encoding utf8)).Data.Form.OuterXml)
				$FormName = $xmlObj.Form.Name
				$xmlText = (([xml](Get-Content "$global:projectDirName" -Encoding utf8)).Data.Form.OuterXml) | Out-String
				
				$outstring = "$outstring
Set-Types
ConvertFrom-WinFormsXML -Reference refs -Suppress -Xml @""
$xmlText""@
#endregion VDS
$($FastText.Text)
Show-Form `$$FormName}); `$PowerShell.Invoke(); `$PowerShell.Dispose()"

				if ( (Test-Path -Path "$($generationPath)" -PathType Container) -eq $false ) {New-Item -Path "$($generationPath)" -ItemType Directory | Out-Null}
			
				$ascii = new-object System.Text.ASCIIEncoding
				$FastText.SaveToFile("$generationPath\Events.ps1",$ascii)
				$outstring | Out-File "$($generationPath)\$($projectName -replace "fbs$","ps1")" -Encoding ASCII -Force
				[System.Windows.Forms.MessageBox]::Show("Script saved to $($generationPath)\$($projectName -replace "fbs$","ps1")","Script output successful",'OK',64) | Out-Null
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
                               ( $Script:supportedControls.Where({$_.Type -eq 'Parentless'}).Name -notcontains $nodeType )) {
                                
                                $objRef.Objects[$nodeName].BringToFront()
                            }
                          #  if ($DPI -ne 'dpi'){
                            Move-SButtons -Object $objRef.Objects[$nodeName]
							#}
                        } else {$Script:sButtons.GetEnumerator().ForEach({$_.Value.Visible = $false})}

                        $Script:refs['lst_AssignedEvents'].Items.Clear()

                        if ( $objRef.Events[$this.SelectedNode.Name] ) {
                            $Script:refs['lst_AssignedEvents'].BeginUpdate()
                            $objRef.Events[$nodeName].ForEach({[void]$Script:refs['lst_AssignedEvents'].Items.Add($_)})
                            $Script:refs['lst_AssignedEvents'].EndUpdate()

                            $Script:refs['lst_AssignedEvents'].Enabled = $true
                        } else {
                            $Script:refs['lst_AssignedEvents'].Items.Add('No Events')
                            $Script:refs['lst_AssignedEvents'].Enabled = $false
                        }

                        $eventTypes = $($Script:refs['PropertyGrid'].SelectedObject | Get-Member -Force).Name -match "^add_"

                        $Script:refs['lst_AvailableEvents'].Items.Clear()
                        $Script:refs['lst_AvailableEvents'].BeginUpdate()

                        if ( $eventTypes.Count -gt 0 ) {
                            $eventTypes | ForEach-Object {[void]$Script:refs['lst_AvailableEvents'].Items.Add("$($_ -replace "^add_")")}}
                        else {
                            [void]$Script:refs['lst_AvailableEvents'].Items.Add('No Events Found on Selected Object')
                            $Script:refs['lst_AvailableEvents'].Enabled = $false
                        }

                        $Script:refs['lst_AvailableEvents'].EndUpdate()
                    } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered after selecting TreeNode."}
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
                                } else {
                                    $changedProperty = $changedProperty.ParentGridEntry
                                    $value = $changedProperty.GetPropertyTextValue()
                                }
                            }
                        }
                    } else {$value = $changedProperty.GetPropertyTextValue()}

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
								$FastText.SelectionStart = 16}

								$string = "`$$controlName.$($changedProperty.PropertyName) = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String(`"$decodedimage`"))
"
								$FastText.SelectedText = $string

								if ($FastText.GetLineText(0) -eq "#region Images"){
								$FastText.CollapseFoldingBlock(0)}
							
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
									$FastText.SelectionStart = 16}
								
$string = "`$$controlName.Icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap][System.Drawing.Image]::FromStream([System.IO.MemoryStream][System.Convert]::FromBase64String(`"$decodedimage`"))).GetHicon())
"
					$FastText.SelectedText = $string
					
						if ($FastText.GetLineText(0) -eq "#region Images"){
						$FastText.CollapseFoldingBlock(0)}
						

								
							}
							
							default {
                                if ( $null -eq $objRef.Changes[$controlName] ) {$objRef.Changes[$controlName] = @{}}
                                $objRef.Changes[$controlName][$changedProperty.PropertyName] = $value
                            }
                        }

                    } elseif ( $objRef.Changes[$controlName] ) {
                        if ( $objRef.Changes[$controlName][$changedProperty.PropertyName] ) {
                            $objRef.Changes[$controlName].Remove($changedProperty.PropertyName)
                            if ( $objRef.Changes[$controlName].Count -eq 0 ) {$objRef.Changes.Remove($controlName)}
                        }
                    }
                } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered after changing property value ($($controlType) - $($controlName))."}
            }
        }
        'trv_Controls' = @{
            DoubleClick = {
                $controlName = $this.SelectedNode.Name
				
				
						switch ($controlName)
						{
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
#brandoncomputer_RemoveGlobalContextMenuStrip
					$context = 1
                } else {$context = 2}

                if ( @('All Controls','Common','Containers', 'Menus and ToolStrips','Miscellaneous') -notcontains $controlName ) {
                    $controlObjectType = $Script:supportedControls.Where({$_.Name -eq $controlName}).Type
					

                    
                    try {
                        if (( $controlObjectType -eq 'Parentless' ) -or ( $context -eq 0 )) {
                            $controlType = $controlName
#brandoncomputer_autoname&autotext
                            $Script:newNameCheck = $false
                        #    $userInput = Get-UserInputFromForm -SetText "$($Script:supportedControls.Where({$_.Name -eq $controlType}).Prefix)_"
                            $Script:newNameCheck = $true
							
                         #   if ( $userInput.Result -eq 'OK' ) {
                                if ( $Script:refs['TreeView'].Nodes.Text -match "$($controlType) - $($userInput.NewName)" ) {
                                    [void][System.Windows.Forms.MessageBox]::Show("A $($controlType) with the Name '$($userInput.NewName)' already exists.",'Error')
                                } else {
                                  #  Add-TreeNode -TreeObject $Script:refs['TreeView'] -ControlType $controlType -ControlName $userInput.NewName
								if ($control_track.$controlName -eq $null){
									$control_track[$controlName] = 1
								}
								else {
									$control_track.$controlName = $control_track.$controlName + 1
								}
							#	info "$($controlType) - $controlName$($control_track.$controlName)"
								if ( $Script:refs['TreeView'].Nodes.Text -match "$($controlType) - $controlName$($control_track.$controlName)" )
								{[void][System.Windows.Forms.MessageBox]::Show("A $($controlType) with the Name '$controlName$($control_track.$controlName)' already exists.",'Error')}
								else{
								Add-TreeNode -TreeObject $Script:refs['TreeView'] -ControlType $controlName "$controlName$($control_track.$controlName)" "$controlName$($control_track.$controlName)"}
                            }
                             #   }
                            }
                         else {
                            if ( $Script:supportedControls.Where({$_.Name -eq $($refs['TreeView'].SelectedNode.Text -replace " - .*$")}).ChildTypes -contains $controlObjectType ) {
								if ($control_track.$controlName -eq $null){
									$control_track[$controlName] = 1
								}
								else {
									$control_track.$controlName = $control_track.$controlName + 1
								}

								if ($Script:refs['TreeView'].Nodes.Nodes | Where-Object { $_.Text -eq "$($controlName) - $controlName$($control_track.$controlName)" })
								{[void][System.Windows.Forms.MessageBox]::Show("A $($controlName) with the Name '$controlName$($control_track.$controlName)' already exists. Try again to create '$controlName$($control_track.$controlName + 1)'",'Error')}
								else{
								Add-TreeNode -TreeObject $Script:refs['TreeView'].SelectedNode -ControlType $controlName "$controlName$($control_track.$controlName)" "$controlName$($control_track.$controlName)"}
                            } else {


								if ($control_track.$controlName -eq $null){
									$control_track[$controlName] = 1
								}
								else {
									$control_track.$controlName = $control_track.$controlName + 1
								}
#brandoncomputer_SlickToTopNode
								
								if ($Script:refs['TreeView'].Nodes.Nodes | Where-Object { $_.Text -eq "$($controlName) - $controlName$($control_track.$controlName)" })
								{[void][System.Windows.Forms.MessageBox]::Show("A $($controlName) with the Name '$controlName$($control_track.$controlName)' already exists. Try again to create '$controlName$($control_track.$controlName + 1)'",'Error')}
								else{
								Add-TreeNode -TreeObject $Script:refs['TreeView'].TopNode -ControlType $controlName "$controlName$($control_track.$controlName)" "$controlName$($control_track.$controlName)"}
								#[void][System.Windows.Forms.MessageBox]::Show("Unable to add $($controlName) to $($refs['TreeView'].SelectedNode.Text -replace " - .*$").")
								}
                        }
                    } catch {
						Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered while adding '$($controlName)'."} 
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
					
#brandoncomputer_AddEventtoFastText
					$FastText.GoEnd()
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
                } else {
                    if ( $objRef.Events[$controlName] ) {
                        $objRef.Events.Remove($controlName)
                    }
                }
            }
        }
        'ChangeView' = {
            try {
                switch ($this.Text) {
                    'Toolbox' {
                        $pnlChanged = $refs['pnl_Left']
                        $sptChanged = $refs['spt_Left']
                        $tsViewItem = $refs['Toolbox']
                        $tsMenuItem = $refs['ms_Toolbox']
                        $thisNum = '1'
                        $otherNum = '2'
                        $side = 'Left'
                    }
                    'Form Tree' {
                        $pnlChanged = $refs['pnl_Left']
                        $sptChanged = $refs['spt_Left']
                        $tsViewItem = $refs['FormTree']
                        $tsMenuItem = $refs['ms_FormTree']
                        $thisNum = '2'
                        $otherNum = '1'
                        $side = 'Left'
                    }
                    'Properties' {
                        $pnlChanged = $refs['pnl_Right']
                        $sptChanged = $refs['spt_Right']
                        $tsViewItem = $refs['Properties']
                        $tsMenuItem = $refs['ms_Properties']
                        $thisNum = '1'
                        $otherNum = '2'
                        $side = 'Right'
                    }
                    'Events' {
                        $pnlChanged = $refs['pnl_Right']
                        $sptChanged = $refs['spt_Right']
                        $tsViewItem = $refs['Events']
                        $tsMenuItem = $refs['ms_Events']
                        $thisNum = '2'
                        $otherNum = '1'
                        $side = 'Right'
                    }
                }
#brandoncomputer_TabColorSchemeChange
                if (( $pnlChanged.Visible ) -and ( $sptChanged."Panel$($thisNum)Collapsed" )) {
                    $sptChanged."Panel$($thisNum)Collapsed" = $false
                    $tsViewItem.Checked = $true
                    $tsMenuItem.BackColor = 'RoyalBlue'
                } elseif (( $pnlChanged.Visible ) -and ( $sptChanged."Panel$($thisNum)Collapsed" -eq $false )) {
                    $tsViewItem.Checked = $false
                    $tsMenuItem.BackColor = 'MidnightBlue'

                    if ( $sptChanged."Panel$($otherNum)Collapsed" ) {$pnlChanged.Visible = $false} else {$sptChanged."Panel$($thisNum)Collapsed" = $true}
                } else {
                    $tsViewItem.Checked = $true
                    $tsMenuItem.BackColor = 'RoyalBlue'
                    $sptChanged."Panel$($thisNum)Collapsed" = $false
                    $sptChanged."Panel$($otherNum)Collapsed" = $true
                    $pnlChanged.Visible = $true
                }

                if ( $pnlChanged.Visible -eq $true ) {$refs["lbl_$($side)"].Visible = $true} else {$refs["lbl_$($side)"].Visible = $false}
            } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered during View change."}
        }
        'ChangePanelSize' = @{
            'MouseMove' = {
                param($Sender, $e)
                
                if (( $e.Button -eq 'Left' ) -and ( $e.Location.X -ne 0 )) {
                        # Determine which panel to resize
                    $side = $Sender.Name -replace "^lbl_"
                        # Determine the new X coordinate
                    if ( $side -eq 'Right' ) {$newX = $refs["pnl_$($side)"].Size.Width - $e.Location.X} else {$newX = $refs["pnl_$($side)"].Size.Width + $e.Location.X}
                        # Change the size of the panel
                    if ( $newX -ge 100 ) {$refs["pnl_$($side)"].Size = New-Object System.Drawing.Size($newX,$refs["pnl_$($side)"].Size.Y)}
                        # Refresh form to remove artifacts while dragging
                    $Sender.Parent.Refresh()
                }
            }
        }
        'CheckedChanged' = {
            param ($Sender)

            if ( $Sender.Checked ) {
                $Sender.Parent.Controls["$($Sender.Name -replace "^c",'t')"].Enabled = $true
                $Sender.Parent.Controls["$($Sender.Name -replace "^c",'t')"].Focus()
            } else {$Sender.Parent.Controls["$($Sender.Name -replace "^c",'t')"].Enabled = $false}
        }
    }
	

    #endregion Event ScriptBlocks

    #region Child Forms

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
#brandoncomputer_FixControlInput
                    ScriptBlock = {$this.Controls['UserInput'].Focus()
					$this.Controls['UserInput'].Select(5,0)}
                },
                [pscustomobject]@{
                    Name = 'UserInput'
                    EventType = 'KeyUp'
                    ScriptBlock = {
                        if ( $_.KeyCode -eq 'Return' ) {
                            $objRef = Get-RootNodeObjRef -TreeNode $Script:refs['TreeView'].SelectedNode

                            if ( $((Get-Date)-$($Script:lastUIKeyUp)).TotalMilliseconds -lt 250 ) {
                                # Do nothing
                            } elseif ( $this.Text -match "(\||<|>|&|\$|'|`")" ) {
                                [void][System.Windows.Forms.MessageBox]::Show("Names cannot contain any of the following characters: `"|<'>`"&`$`".", 'Error')
                            } elseif (( $objref.TreeNodes[$($this.Text.Trim())] ) -and ( $Script:newNameCheck -eq $true )) {
                                [void][System.Windows.Forms.MessageBox]::Show("All elements must have unique names for this application to function as intended. The name '$($this.Text.Trim())' is already assigned to another element.", 'Error')
                            } elseif ( $($this.Text -replace "\s") -eq '' ) {
                                [void][System.Windows.Forms.MessageBox]::Show("All elements must have names for this application to function as intended.", 'Error')
                                $this.Text = ''
                            } else {
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
#brandoncomputer_ChangeExports
        'Generate' = @{
            XMLText = @"
  <Form Name="Generate" FormBorderStyle="FixedDialog" MaximizeBox="False" MinimizeBox="False" ShowIcon="False" ShowInTaskbar="False" Size="410, 420" StartPosition="CenterParent" Text="Generate Script File(s)">
    <GroupBox Name="gbx_DotSource" Location="25, 115" Size="345, 219" Text="Dot Sourcing">
      <CheckBox Name="cbx_Functions" Location="25, 25" Text="Functions" />
      <TextBox Name="tbx_Functions" Enabled="False" Location="165, 25" Size="150, 20" Text="Functions.ps1" />
      <CheckBox Name="cbx_Events" Location="25, 55" Text="Events" />
      <TextBox Name="tbx_Events" Enabled="False" Location="165, 55" Size="150, 20" Text="Events.ps1" />
      <CheckBox Name="cbx_ChildForms" Location="25, 85" Text="Child Forms" />
      <TextBox Name="tbx_ChildForms" Enabled="False" Location="165, 85" Size="150, 20" Text="ChildForms.ps1" />
      <CheckBox Name="cbx_Timers" Location="25, 115" Text="Timers" />
      <TextBox Name="tbx_Timers" Enabled="False" Location="165, 115" Size="150, 20" Text="Timers.ps1" />
      <CheckBox Name="cbx_Dialogs" Location="25, 145" Text="Dialogs" />
      <TextBox Name="tbx_Dialogs" Enabled="False" Location="165, 145" Size="150, 20" Text="Dialogs.ps1" />
      <CheckBox Name="cbx_ReuseContext" Location="25, 175" Size="134, 24" Text="Reuse ContextStrips" Visible="False" />
      <TextBox Name="tbx_ReuseContext" Enabled="False" Location="165, 175" Size="150, 20" Text="ReuseContext.ps1" Visible="False" />
      <CheckBox Name="cbx_EnvSetup" Location="25, 175" Size="134, 24" Text="Environment Setup" />
      <TextBox Name="tbx_EnvSetup" Enabled="False" Location="165, 175" Size="150, 20" Text="EnvSetup.ps1" />
    </GroupBox>
    <GroupBox Name="gbx_ChildForms" Location="25, 25" Size="345, 65" Text="Child Forms">
      <Button Name="btn_Add" FlatStyle="System" Font="Microsoft Sans Serif, 14.25pt, style=Bold" Location="25, 25" Size="21, 19" Text="+" />
      <TextBox Name="tbx_ChildForm1" Enabled="False" Location="62, 25" Size="252, 20" />
    </GroupBox>
    <Button Name="btn_Generate" FlatStyle="Flat" Location="104, 346" Size="178, 23" Text="Generate Script File(s)" />
  </Form>
"@
            Events = @(
                [pscustomobject]@{
                    Name = 'cbx_Functions'
                    EventType = 'CheckedChanged'
                    ScriptBlock = $Script:eventSB.CheckedChanged
                },
                [pscustomobject]@{
                    Name = 'cbx_Events'
                    EventType = 'CheckedChanged'
                    ScriptBlock = $Script:eventSB.CheckedChanged
                },
                [pscustomobject]@{
                    Name = 'cbx_ChildForms'
                    EventType = 'CheckedChanged'
                    ScriptBlock = $Script:eventSB.CheckedChanged
                },
                [pscustomobject]@{
                    Name = 'cbx_Timers'
                    EventType = 'CheckedChanged'
                    ScriptBlock = $Script:eventSB.CheckedChanged
                },
                [pscustomobject]@{
                    Name = 'cbx_Dialogs'
                    EventType = 'CheckedChanged'
                    ScriptBlock = $Script:eventSB.CheckedChanged
                },
                [pscustomobject]@{
                    Name = 'cbx_ReuseContext'
                    EventType = 'CheckedChanged'
                    ScriptBlock = $Script:eventSB.CheckedChanged
                },
                [pscustomobject]@{
                    Name = 'cbx_EnvSetup'
                    EventType = 'CheckedChanged'
                    ScriptBlock = $Script:eventSB.CheckedChanged
                },
                [pscustomobject]@{
                    Name = 'btn_Add'
                    EventType = 'Click'
                    ScriptBlock = {
                        $openDialog = ConvertFrom-WinFormsXML -Xml @"
<OpenFileDialog InitialDirectory="$($Script:projectsDir)" AddExtension="True" DefaultExt="fbs" Filter="fbs files (*.fbs)|*.fbs" FilterIndex="1" ValidateNames="True" CheckFileExists="True" RestoreDirectory="True" />
"@
                        $openDialog.Add_FileOK({
                            param($Sender,$e)

                            if ( $Script:refsGenerate['gbx_ChildForms'].Controls.Tag -contains $this.FileName ) {
                                [void][System.Windows.Forms.MessageBox]::Show("The project '$($this.FileName | Split-Path -Leaf)' has already been added as a child form of this project.",'Validation Error')
                                $e.Cancel = $true
                            }
                        })

                        try {
                            if ( $openDialog.ShowDialog() -eq 'OK' ) {
                                $fileName = $openDialog.FileName

                                $childFormCount = $Script:refsGenerate['gbx_ChildForms'].Controls.Where({ $_.Name -match 'tbx_' }).Count

                                @('Generate','gbx_ChildForms').ForEach({
                                    $Script:refsGenerate[$_].Size = New-Object System.Drawing.Size($Script:refsGenerate[$_].Size.Width,($Script:refsGenerate[$_].Size.Height + 40))
                                })

                                @('btn_Add','gbx_DotSource','btn_Generate').ForEach({
                                    $Script:refsGenerate[$_].Location = New-Object System.Drawing.Size($Script:refsGenerate[$_].Location.X,($Script:refsGenerate[$_].Location.Y + 40))
                                })

                                $Script:refsGenerate['Generate'].Location = New-Object System.Drawing.Size($Script:refsGenerate['Generate'].Location.X,($Script:refsGenerate['Generate'].Location.Y - 20))

                                $defaultTextBox = $Script:refsGenerate['gbx_ChildForms'].Controls["tbx_ChildForm$($childFormCount)"]
                                $defaultTextBox.Location = New-Object System.Drawing.Size($defaultTextBox.Location.X,($defaultTextBox.Location.Y + 40))
                                $defaultTextBox.Name = "tbx_ChildForm$($childFormCount + 1)"

                                $button = ConvertFrom-WinFormsXML -ParentControl $Script:refsGenerate['gbx_ChildForms'] -Xml @"
<Button Name="btn_Minus$($childFormCount)" Font="Microsoft Sans Serif, 14.25pt, style=Bold" FlatStyle="System" Location="25, $(25 + ($childFormCount - 1) * 40)" Size="21, 19" Text="-" />
"@
                                $button.Add_Click({
                                    try {
                                        [int]$btnIndex = $this.Name -replace "\D"
                                        $childFormCount = $Script:refsGenerate['gbx_ChildForms'].Controls.Where({ $_.Name -match 'tbx_' }).Count

                                        $($Script:refsGenerate['gbx_ChildForms'].Controls["tbx_ChildForm$($btnIndex)"]).Dispose()
                                        $this.Dispose()

                                        @(($btnIndex + 1)..$childFormCount).ForEach({
                                            if ( $null -eq $Script:refsGenerate['gbx_ChildForms'].Controls["btn_Minus$($_)"] ) {$btnName = 'btn_Add'} else {$btnName = "btn_Minus$($_)"}

                                            $btnLocX = $Script:refsGenerate['gbx_ChildForms'].Controls[$btnName].Location.X
                                            $btnLocY = $Script:refsGenerate['gbx_ChildForms'].Controls[$btnName].Location.Y

                                            $Script:refsGenerate['gbx_ChildForms'].Controls[$btnName].Location = New-Object System.Drawing.Size($btnLocX,($btnLocY - 40))

                                            $tbxName = "tbx_ChildForm$($_)"

                                            $tbxLocX = $Script:refsGenerate['gbx_ChildForms'].Controls[$tbxName].Location.X
                                            $tbxLocY = $Script:refsGenerate['gbx_ChildForms'].Controls[$tbxName].Location.Y
                                            $Script:refsGenerate['gbx_ChildForms'].Controls[$tbxName].Location = New-Object System.Drawing.Size($tbxLocX,($tbxLocY - 40))

                                            if ( $btnName -ne 'btn_Add' ) {$Script:refsGenerate['gbx_ChildForms'].Controls[$btnName].Name = "btn_Minus$($_ - 1)"}
                                            $Script:refsGenerate['gbx_ChildForms'].Controls[$tbxName].Name = "tbx_ChildForm$($_ - 1)"
                                        })

                                        @('Generate','gbx_ChildForms').ForEach({
                                            $Script:refsGenerate[$_].Size = New-Object System.Drawing.Size($Script:refsGenerate[$_].Size.Width,($Script:refsGenerate[$_].Size.Height - 40))
                                        })

                                        @('gbx_DotSource','btn_Generate').ForEach({
                                            $Script:refsGenerate[$_].Location = New-Object System.Drawing.Size($Script:refsGenerate[$_].Location.X,($Script:refsGenerate[$_].Location.Y - 40))
                                        })

                                        $Script:refsGenerate['Generate'].Location = New-Object System.Drawing.Size($Script:refsGenerate['Generate'].Location.X,($Script:refsGenerate['Generate'].Location.Y + 20))

                                        if ( $Script:refsGenerate['gbx_ChildForms'].Controls.Count -le 2 ) {
                                            $Script:refsGenerate['cbx_ChildForms'].Checked = $false
                                            $Script:refsGenerate['cbx_ChildForms'].Enabled = $false
                                        }

                                        Remove-Variable -Name btnIndex, childFormCount, btnName, btnLocX, btnLocY, tbxName, tbxLocX, tbxLocY
                                    } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered while removing child form."}
                                })

                                ConvertFrom-WinFormsXML -ParentControl $Script:refsGenerate['gbx_ChildForms'] -Suppress -Xml @"
<TextBox Name="tbx_ChildForm$($childFormCount)" Location="62, $(25 + ($childFormCount - 1) * 40)" Size="252, 20" Text="...\$($fileName | Split-Path -Leaf)" Tag="$fileName" Enabled="False" />
"@
                                $Script:refsGenerate['cbx_ChildForms'].Enabled = $true
                                Remove-Variable -Name button, fileName, childFormCount, defaultTextBox
                            }
                        } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered while adding child form."}
                        finally {
                            $openDialog.Dispose()
                            Remove-Variable -Name openDialog
                        }
                    }
                },
                [pscustomobject]@{
                    Name = 'btn_Generate'
                    EventType = 'Click'
                    ScriptBlock = {
#brandoncomputer_CreateBackup(Removed)
					#$backup = "$(get-date -format 'yyyyMMddHHmm-dddd')"
						#if ( (Test-Path -Path "$($generationPath)\$backup" -PathType Container) -eq $false ) {New-Item -Path "$($generationPath)\$backup" -ItemType Directory | Out-Null}
                      #  copy-item -path "$($generationPath)\*.*" -destination "$($generationPath)\$backup"
						$fileError = 0
                        [array]$checked = $Script:refsGenerate['gbx_DotSource'].Controls.Where({$_.Checked -eq $true})

                        if ( $checked.Count -gt 0 ) {
                            $checked.ForEach({
                                $fileName = $($Script:refsGenerate[$($_.Name -replace "^cbx","tbx")]).Text
                                if ( $($fileName -match ".*\...") -eq $false ) {
                                    [void][System.Windows.Forms.MessageBox]::Show("Filename not valid for the dot sourcing of $($_.Name -replace "^cbx_")")
                                    $fileError++
                                }
                            })
                        }

                        if ( $fileError -eq 0 ) {
                            $Script:refsGenerate['Generate'].DialogResult = 'OK'
                            $Script:refsGenerate['Generate'].Visible = $false
                        }
					}
                }
            )
        }
    }

    #endregion Child Forms

    #region Reuseable ContextMenuStrips

    $reuseContextInfo = @{
        'TreeNode' = @{
            XMLText = @"
  <ContextMenuStrip Name="TreeNode">
    <ToolStripMenuItem Name="MoveUp" ShortcutKeys="F5" Text="Move Up" ShortcutKeyDisplayString="F5" />
    <ToolStripMenuItem Name="MoveDown" ShortcutKeys="F6" ShortcutKeyDisplayString="F6" Text="Move Down" />
    <ToolStripSeparator Name="Sep1" />
    <ToolStripMenuItem Name="CopyNode" ShortcutKeys="Ctrl+C" Text="Copy" ShortcutKeyDisplayString="Ctrl+C" />
    <ToolStripMenuItem Name="PasteNode" ShortcutKeys="Ctrl+P" Text="Paste" ShortcutKeyDisplayString="Ctrl+P" />
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
                        } else {
                            $this.Items['Delete'].Visible = $true
                            $this.Items['CopyNode'].Visible = $true
                            $isCopyVisible = $true
                        }

                        if ( $Script:nodeClipboard ) {
                            $this.Items['PasteNode'].Visible = $true
                            $this.Items['Sep2'].Visible = $true
                        } else {
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

    #endregion

    #region Environment Setup

    $noIssues = $true

    try {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing

            # Confirm SavedProjects directory exists and set SavedProjects directory
        $Script:projectsDir = ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer")
        if ( (Test-Path -Path "$($Script:projectsDir)") -eq $false ) {New-Item -Path "$($Script:projectsDir)" -ItemType Directory | Out-Null}

            # Set Misc Variables
        $Script:lastUIKeyUp = Get-Date
        $Script:newNameCheck = $true
        $Script:openingProject = $false
        $Script:MouseMoving = $false
#brandoncomputer_Controls
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
    } catch {
        Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered during Environment Setup."
        $noIssues = $false
    }

    #endregion Environment Setup

    #region Secondary Control Initialization

    if ( $noIssues ) {
        try {
            Get-CustomControl -ControlInfo $reuseContextInfo['TreeNode'] -Reference reuseContext -Suppress
        } catch {
            Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered during Child Form Initialization."
            $noIssues = $false
        }
    }

    #endregion Secondary Control Initialization

    #region Main Form Initialization

    try {
#brandoncomputer_FixWindowState
        ConvertFrom-WinFormsXML -Reference refs -Suppress -Xml @"
  <Form Name="MainForm" IsMdiContainer="True" Size="826, 654" WindowState="Maximized" Text="PowerShell Designer">
   <TabControl Name="tcl_Top" Dock="Top" Size="288, 20">
      <TabPage Name="tpg_Form1" Size="280, 0" Text="NewProject.fbs" />
    </TabControl>
    <Label Name="lbl_Left" Dock="Left" BackColor="35, 35, 35" Cursor="VSplit" Size="3, 570" />
    <Label Name="lbl_Right" Dock="Right" BackColor="35, 35, 35" Cursor="VSplit" Size="3, 570" />
    <Panel Name="pnl_Left" Dock="Left" BorderStyle="Fixed3D" Size="200, 570">
      <SplitContainer Name="spt_Left" Dock="Fill" BackColor="ControlDark" Orientation="Horizontal" SplitterDistance="237">
        <SplitterPanel Name="spt_Left_Panel1">
          <TreeView Name="trv_Controls" Dock="Fill" BackColor="Azure" />
        </SplitterPanel>
        <SplitterPanel Name="spt_Left_Panel2" BackColor="ControlLight">
          <TreeView Name="TreeView" Dock="Fill" BackColor="Azure" DrawMode="OwnerDrawText" HideSelection="False" />
        </SplitterPanel>
      </SplitContainer>
    </Panel>
    <Panel Name="pnl_Right" Dock="Right" BorderStyle="Fixed3D" Size="200, 570">
      <SplitContainer Name="spt_Right" Dock="Fill" BackColor="ControlDark" Orientation="Horizontal" SplitterDistance="179">
        <SplitterPanel Name="spt_Right_Panel1">
          <PropertyGrid Name="PropertyGrid" Dock="Fill" ViewBackColor="Azure" />
        </SplitterPanel>
        <SplitterPanel Name="spt_Right_Panel2" BackColor="Control">
          <TabControl Name="TabControl2" Dock="Fill">
            <TabPage Name="Tab 1" Size="188, 357" Text="Events">
              <SplitContainer Name="SplitContainer3" Dock="Fill" Orientation="Horizontal" SplitterDistance="121">
                <SplitterPanel Name="SplitContainer3_Panel1" AutoScroll="True">
                  <Label Name="lbl_AvailableEvents" Dock="Top" Size="184, 23" Text="Available Events" />
                  <ListBox Name="lst_AvailableEvents" BackColor="Azure" Location="1, 23" Size="183, 147" />
                </SplitterPanel>
                <SplitterPanel Name="SplitContainer3_Panel2" AutoScroll="True">
                  <Label Name="lbl_AssignedEvents" Dock="Top" Size="188, 23" Text="Assigned Events" />
                  <ListBox Name="lst_AssignedEvents" BackColor="Azure" Location="0, 23" Size="188, 160" />
                </SplitterPanel>
              </SplitContainer>
            </TabPage>
            <TabPage Name="TabPage3" Size="188, 357" Text="Functions">
              <SplitContainer Name="SplitContainer4" Dock="Fill" Orientation="Horizontal" SplitterDistance="169">
                <SplitterPanel Name="SplitContainer4_Panel1" AutoScroll="True">
                  <CheckedListBox Name="lst_Functions" Dock="Fill" BackColor="Azure" />
                </SplitterPanel>
                <SplitterPanel Name="SplitContainer4_Panel2" AutoScroll="True">
                  <Label Name="lst_Params" Dock="Fill" BackColor="Azure" />
                </SplitterPanel>
              </SplitContainer>
            </TabPage>
          </TabControl>
        </SplitterPanel>
      </SplitContainer>
    </Panel>
    <MenuStrip Name="ms_Left" Dock="Left" AutoSize="False" BackColor="ControlDarkDark" Font="Verdana, 9pt" LayoutStyle="VerticalStackWithOverflow" Size="23, 570" TextDirection="Vertical90">
      <ToolStripMenuItem Name="ms_Toolbox" AutoSize="False" BackColor="RoyalBlue" ForeColor="AliceBlue" Size="23, 100" Text="Toolbox" />
      <ToolStripMenuItem Name="ms_FormTree" AutoSize="False" BackColor="RoyalBlue" ForeColor="AliceBlue" Size="23, 100" TextAlign="MiddleLeft" TextDirection="Vertical90" Text="Form Tree" />
    </MenuStrip>
    <MenuStrip Name="ms_Right" Dock="Right" AutoSize="False" BackColor="ControlDarkDark" Font="Verdana, 9pt" LayoutStyle="VerticalStackWithOverflow" Size="23, 570" TextDirection="Vertical90">
      <ToolStripMenuItem Name="ms_Properties" AutoSize="False" BackColor="RoyalBlue" ForeColor="AliceBlue" Size="23, 100" TextAlign="MiddleLeft" TextDirection="Vertical270" Text="Properties" />
      <ToolStripMenuItem Name="ms_Events" AutoSize="False" BackColor="RoyalBlue" ForeColor="AliceBlue" Size="23, 100" TextDirection="Vertical270" Text="Events" />
    </MenuStrip>
    <MenuStrip Name="MenuStrip" RenderMode="System">
      <ToolStripMenuItem Name="ts_File" DisplayStyle="Text" Text="File">
        <ToolStripMenuItem Name="New" DisplayStyle="Text" ShortcutKeyDisplayString="Ctrl+N" ShortcutKeys="Ctrl+N" Text="New" />
        <ToolStripMenuItem Name="Open" DisplayStyle="Text" ShortcutKeyDisplayString="Ctrl+O" ShortcutKeys="Ctrl+O" Text="Open" />
        <ToolStripMenuItem Name="Save" DisplayStyle="Text" ShortcutKeyDisplayString="Ctrl+S" ShortcutKeys="Ctrl+S" Text="Save" />
        <ToolStripMenuItem Name="Save As" DisplayStyle="Text" ShortcutKeyDisplayString="Ctrl+Alt+S" ShortcutKeys="Ctrl+Alt+S" Text="Save As" />
        <ToolStripSeparator Name="FileSep" />
        <ToolStripMenuItem Name="Exit" DisplayStyle="Text" ShortcutKeyDisplayString="Ctrl+Alt+X" ShortcutKeys="Ctrl+Alt+X" Text="Exit" />
      </ToolStripMenuItem>
      <ToolStripMenuItem Name="ts_Edit" Text="Edit">
        <ToolStripMenuItem Name="Undo" ShortcutKeyDisplayString="Ctrl+Z" ShortcutKeys="Ctrl+Z" Text="Undo" />
        <ToolStripMenuItem Name="Redo" ShortcutKeyDisplayString="Ctrl+Y" ShortcutKeys="Ctrl+Y" Text="Redo" />
        <ToolStripSeparator Name="EditSep4" />
        <ToolStripMenuItem Name="Cut" ShortcutKeyDisplayString="Ctrl+X" ShortcutKeys="Ctrl+X" Text="Cut" />
        <ToolStripMenuItem Name="Copy" ShortcutKeyDisplayString="Ctrl+C" ShortcutKeys="Ctrl+C" Text="Copy" />
        <ToolStripMenuItem Name="Paste" ShortcutKeyDisplayString="Ctrl+V" ShortcutKeys="Ctrl+V" Text="Paste" />
        <ToolStripMenuItem Name="Select All" ShortcutKeyDisplayString="Ctrl+A" ShortcutKeys="Ctrl+A" Text="Select All" />
        <ToolStripSeparator Name="EditSep5" />
        <ToolStripMenuItem Name="Find" ShortcutKeyDisplayString="Ctrl+F" ShortcutKeys="Ctrl+F" Text="Find" />
        <ToolStripMenuItem Name="Replace" ShortcutKeyDisplayString="Ctrl+H" ShortcutKeys="Ctrl+H" Text="Replace" />
        <ToolStripMenuItem Name="Goto" ShortcutKeyDisplayString="Ctrl+G" ShortcutKeys="Ctrl+G" Text="Go To Line..." />
        <ToolStripSeparator Name="EditSep6" />
        <ToolStripMenuItem Name="Collapse All" ShortcutKeyDisplayString="F7" ShortcutKeys="F7" Text="Collapse All" />
        <ToolStripMenuItem Name="Expand All" ShortcutKeyDisplayString="F8" ShortcutKeys="F8" Text="Expand All" />
      </ToolStripMenuItem>
      <ToolStripMenuItem Name="ts_Controls" Text="Controls">
        <ToolStripMenuItem Name="Rename" ShortcutKeyDisplayString="Ctrl+R" ShortcutKeys="Ctrl+R" Text="Rename" />
        <ToolStripMenuItem Name="Delete" ShortcutKeyDisplayString="Ctrl+D" ShortcutKeys="Ctrl+D" Text="Delete" />
        <ToolStripSeparator Name="EditSep1" />
        <ToolStripMenuItem Name="CopyNode" Text="Copy Control" />
        <ToolStripMenuItem Name="PasteNode" Text="Paste Control" />
        <ToolStripSeparator Name="EditSep2" />
        <ToolStripMenuItem Name="Move Up" ShortcutKeyDisplayString="F5" ShortcutKeys="F5" Text="Move Up" />
        <ToolStripMenuItem Name="Move Down" ShortcutKeyDisplayString="F6" ShortcutKeys="F6" Text="Move Down" />
      </ToolStripMenuItem>
      <ToolStripMenuItem Name="ts_View" Text="View">
        <ToolStripMenuItem Name="Toolbox" Checked="True" CheckState="Checked" ShortcutKeyDisplayString="F1" ShortcutKeys="F1" Text="Toolbox" />
        <ToolStripMenuItem Name="FormTree" Checked="True" CheckState="Checked" DisplayStyle="Text" ShortcutKeyDisplayString="F2" ShortcutKeys="F2" Text="Form Tree" />
        <ToolStripMenuItem Name="Properties" Checked="True" CheckState="Checked" DisplayStyle="Text" ShortcutKeyDisplayString="F3" ShortcutKeys="F3" Text="Properties" />
        <ToolStripMenuItem Name="Events" Checked="True" CheckState="Checked" ShortcutKeyDisplayString="F4" ShortcutKeys="F4" Text="Events" />
      </ToolStripMenuItem>
      <ToolStripMenuItem Name="ts_Tools" DisplayStyle="Text" Text="Tools">
        <ToolStripMenuItem Name="Generate Script File" DisplayStyle="Text" Text="Generate Script File" />
        <ToolStripMenuItem Name="RunLast" DisplayStyle="Text" ShortcutKeys="F9" Text="Save Events.ps1 and Run Last Generated" />
      </ToolStripMenuItem>
    </MenuStrip>
    <StatusStrip Name="sta_Status">
      <ToolStripStatusLabel Name="tsl_StatusLabel" />
    </StatusStrip>
  </Form>
"@
    } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered during Form Initialization."}

    #endregion Form Initialization

    #region Event Assignment

    try {
            # Call to ScriptBlock
        $Script:refs['MainForm'].Add_FormClosing($eventSB['MainForm'].FormClosing)
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
        $Script:refs['Generate Script File'].Add_Click($eventSB['Generate Script File'].Click)
        $Script:refs['TreeView'].Add_AfterSelect($eventSB['TreeView'].AfterSelect)
        $Script:refs['PropertyGrid'].Add_PropertyValueChanged($eventSB['PropertyGrid'].PropertyValueChanged)
		
		
		
		$Script:refs['trv_Controls'].Add_DoubleClick($eventSB['trv_Controls'].DoubleClick)
        $Script:refs['lst_AvailableEvents'].Add_DoubleClick($eventSB['lst_AvailableEvents'].DoubleClick)
        $Script:refs['lst_AssignedEvents'].Add_DoubleClick($eventSB['lst_AssignedEvents'].DoubleClick)
		
		$Script:refs['RunLast'].Add_Click({
			$projectName = $refs['tpg_Form1'].Text	
			if ($projectName -ne "NewProject.fbs") { 					
			$generationPath = "$(Split-Path -Path $global:projectDirName)\$($projectName -replace "\..*$")"
				if (Test-Path -path $generationPath) {
					#do nothing
				}
				else {
				New-Item -ItemType directory -Path $generationPath
				}
				$ascii = new-object System.Text.ASCIIEncoding
				$FastText.SaveToFile("$generationPath\Events.ps1",$ascii)
				$file = "`"$($generationPath)\$($projectName -replace "fbs$","ps1")`""

				start-process -filepath powershell.exe -argumentlist '-ep bypass','-sta',"-file $file"
			}
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

            # ScriptBlock Here
        $Script:refs['Exit'].Add_Click({$Script:refs['MainForm'].Close()})
        $Script:refs['Save'].Add_Click({ try {Save-Project} catch {if ( $_.Exception.Message -ne 'SaveCancelled' ) {throw $_}} })
        $Script:refs['Save As'].Add_Click({ try {Save-Project -SaveAs} catch {if ( $_.Exception.Message -ne 'SaveCancelled' ) {throw $_}} })
        $Script:refs['TreeView'].Add_DrawNode({$args[1].DrawDefault = $true})
        $Script:refs['TreeView'].Add_NodeMouseClick({$this.SelectedNode = $args[1].Node})
    } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered during Event Assignment."}

    #endregion Event Assignment

    #region Other Actions Before ShowDialog

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

                # Add the Initial Form TreeNode
            Add-TreeNode -TreeObject $Script:refs['TreeView'] -ControlType Form -ControlName MainForm
			
						$Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].height = $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].height * $ctscale
						$Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].width = $Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].width * $ctscale
						$Script:refsFID.Form.Objects[$($Script:refs['TreeView'].Nodes | Where-Object { $_.Text -match "^Form - " }).Name].tag = "VisualStyle,DPIAware"
						
						
            Remove-Variable -Name eventSB, reuseContextInfo
        } catch {
            Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered before ShowDialog."
            $noIssues = $false
        }

            # Load icon from Base64String
            <#
                # Converts image to Base64String
                $encodedImage = [convert]::ToBase64String((get-content $inputfile -encoding byte))
                $encodedImage -replace ".{80}", "$&`r`n" | set-content $outputfile
            #>
 <#        try {
            $Script:refs['MainForm'].Icon = [System.Drawing.Icon]::FromHandle(
                ([System.Drawing.Bitmap][System.Drawing.Image]::FromStream(
                    [System.IO.MemoryStream][System.Convert]::FromBase64String(@"
iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAMAAACdt4HsAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8
YQUAAAMAUExURTg9Wy04ez9ARkBAQEBAQUVFR0VFSUZGSUtLUFJSWltbX1lZZVlaZV9fY2RlcWpqcWxs
cis5hSE0nyE0oAIn/AAm/wIo/wUq/wcs/wgt/wku/wsw/www/w4y/xAz/xA0/xM2/xQ3/xY5/xg6/xs9
/xw+/x9B/yJD/yZG/ylJ/ypK/yxL/y1M/y9O/zFP/zFQ/zVT/zdV/zhW/zxZ/z1a/0Je/0Vh/0Zi/0pl
/0xn/01o/1Bq/1Js/1Zv/1dw/1py/1x0/2F5/2R7/2Z8/2l//2uB/2yC/26E/3CF/3GG/3OI/3aK/3mN
/3qO/4WFj4qKkI6OlZycobi4vYOV/4SW/4eY/4uc/4yd/42e/5Gh/5Ki/5Sj/5am/5in/5mo/5uq/5yr
/56s/6Cu/6Ox/6Sy/6m2/6u4/625/666/7C7/7G8/7K+/7S//7bA/7fC/7jC/7rE/73G/8XFysbGycjI
zsnKztPT09nZ2sDJ/8HK/8PM/8TN/8fP/8nR/8vT/83U/8/W/9DX/9LY/9Ta/9bc/9je/9vg/9zh/9zi
/9/k/+Tk5eDk/+Lm/+To/+bq/+zt8Ojr/+ns/+vu/+7w//Ly9PX19/Dy//L0//f3+fX2//f4//j5//n6
//v8//z8//7+/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACQ1
dDwAAAAJcEhZcwAADsMAAA7DAcdvqGQAAALsSURBVFhH7ZfrV0xRGIeHk2u5VN6pmWboIrpR6CJF6UZl
hEhyS4lEEhlC0kyNQZMyKeV0fv+qd+9zqplmGtb0pbXM8+Hs335nr+ec/Z7LWmPCBjE54zaE0+RU4rZG
TZwiBIkHoiZRCpIpapJjgpiA2SyCJGMWBZtLkGK1WCypMnK26oEs1hQ9mJdL5rzTFcUZeg4StC0tqao6
9675IFG1pupLrAtajwxUq/0wi4LDJ75j2midRVQDBTflF47xHaNsoFIWi4EpGagbfXzMdgPzw/0uDXgi
qsECr9Vqz3PMw2cnDzpk0cHCHJkm0Uhkn8DvZrGV7HZ1QFSDBR45lgBNdA9jcjKAUdSKcAQoILoFrVzW
iU50iWM4AY2jl85hyc4xZWGmDt2iWAVuQaaKTjGRiI6EFwxikLKAMxyL0JuLb6J4l61UC+SKySphBZ/B
V+dGG8dG3vgMsjm5cYGoS5cFEE5QBlQR3cYI5z4UUg+qiTKAfKL3kJ0LIFRgqfLDxc9OJVQrmf1zZmrA
faIKzPCeXXgol64SLFDH3V9UwHOUZ3zKMioQZyzABFE7HnPxbwLJZKtNTj/hOtXDwd32a5n0EQ1ce4sX
8rdVggWTRUUF6TIz7Rjm7Z/i1IuztiXkcepcfixXCNdEg3IsWqYXxJt0ER2lmBG188BJMa4SQXBIQw1f
BFOIsVY8Eil9Ef1ilIgHLZKARuDhNjApc9oo6mWtTTzmOhXyLY0kuMEdLZOpj5NoAZHNBTzglyu15Cme
i0IkQSmgpsnUBEzLQJT1gWV+H99s3BHzQMEl76Acl7FNeJ/p6bjXK1cLzDUj/C3AVKfezUDBP5OWk3/Y
iNEJAokJYgJBTLAZBElSYNoSNSYp2BBO0+zQOuxRWow01KLsN9IaXg/Nrv+/cZ/y0kh4pVw1Uij/i+Ca
csVIoawV/NybkBAv2aHs0kN8/E5luxgSmMvGuhXWCr5vM27wOuz+ZSxcJmQLb5wR+WosMwD+AGFTGEws
vs7bAAAAAElFTkSuQmCC
"@                  )
                )).GetHicon()
            )
        } catch {
            Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered loading Form icon."
            $noIssues = $false
        } #>


    }

    #endregion Other Actions Before ShowDialog

        # Show the form
    try {
#brandoncomputer_FastTextEditWindowCreate
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
#bookmarkCode

				$designerpath = ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\Functions.ps1")
				New-Variable astTokens -Force
				New-Variable astErr -Force
				$AST = [System.Management.Automation.Language.Parser]::ParseFile($designerpath, [ref]$astTokens, [ref]$astErr)
				$functions = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)

for ( $i=0;$i -le $functions.count -1;$i++ ) {
	$lst_Functions.Items.Add("$($functions[$i].name)")
#	$lst_Functions.SetItemChecked($i,$true)
}

$FastText = New-Object FastColoredTextBoxNS.FastColoredTextBox
$FastText.Language = "DialogShell"
$FastText.Dock = "Fill"
$FastText.Zoom = 100
$eventForm.Controls.Add($FastText)
$eventForm.MDIParent = $refs['MainForm']
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
#Replace

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


						try{
						$FastText.CollapseFoldingBlock(0)}
						catch{}

$eventForm.Show()

$Script:refs['tsl_StatusLabel'].add_TextChanged({
		
		if ($Script:refs['tsl_StatusLabel'].text -ne "Current DPIScale: $ctscale")
		{
		$errT = new-object System.Windows.Forms.Timer
		$errT.Interval = 10000
		$errT.Enabled = $True
			$errT.add_Tick({$Script:refs['tsl_StatusLabel'].text ="Current DPIScale: $ctscale" 
			$this.Enabled = $false
			$this.Dispose()
		})
		}
		
})

$Script:refs['tsl_StatusLabel'].text = "Current DPIScale: $ctscale - for resize events multiply all location and size modifiers by `$ctscale."

$Script:refs['spt_Right'].splitterdistance = $Script:refs['spt_Right'].splitterdistance * $ctscale

iex (Get-Content (([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\Dependencies.ps1")) | Out-String)



	$lst_Functions.add_Click({param($sender, $e)
	
		$designerpath = ([Environment]::GetFolderPath("MyDocuments")+"\PowerShell Designer\functions\Functions.ps1")
		New-Variable astTokens -Force
		New-Variable astErr -Force
		$AST = [System.Management.Automation.Language.Parser]::ParseFile($designerpath, [ref]$astTokens, [ref]$astErr)
		$functions = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
		
		foreach ($function in $functions){
			if ($function.name -eq $lst_Functions.SelectedItem.ToString()){
				$parameters = $function.FindAll({ $args[0] -is [System.Management.Automation.Language.ParameterAst] }, $true)
			#	$lst_functions.items.Add($function.name)
			}
		}
		
		$bldStr = "$($lst_Functions.SelectedItem.ToString())"
		foreach ($param in $parameters){
			$bldStr = "$bldStr 
			
$param"
		}
		
		$bldStr = "$bldStr
"

	#	$lst_Params.items.clear()
		$lst_Params.text = ($bldStr)
		
	})
	
<# $lst_Functions.add_MouseLeave({param($sender, $e)
	$lst_Functions.ClearSelected()
}) #>

$lst_Functions.add_ItemCheck({param($sender, $e)
#    $FastText.Undo()
})

		[void]$Script:refs['MainForm'].ShowDialog()
	}
		catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered unexpectedly at ShowDialog."}

    <#
    #region Actions After Form Closed

    try {

    } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered after Form close."}

    #endregion Actions After Form Closed
    #>
}

#region Start Point of Execution

    # Initialize STA Runspace
$rsGUI = [Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace()
$rsGUI.ApartmentState = 'STA'
$rsGUI.ThreadOptions = 'ReuseThread'
$rsGUI.Open()

    # Create the PSCommand, Load into Runspace, and BeginInvoke
	#$cmdGUI = [Management.Automation.PowerShell]::Create().AddScript($sbGUI).AddParameter('DPI',$args[0])
$cmdGUI = [Management.Automation.PowerShell]::Create().AddScript($sbGUI).AddParameters(@{'BaseDir'=$PSScriptRoot; 'DPI'=$args[0]})
$cmdGUI.RunSpace = $rsGUI
$handleGUI = $cmdGUI.BeginInvoke()

    # Hide Console Window
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);

		[DllImport("user32.dll")]
		public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);
'

[Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)

    #Loop Until GUI Closure
while ( $handleGUI.IsCompleted -eq $false ) {Start-Sleep -Seconds 5}

    # Dispose of GUI Runspace/Command
$cmdGUI.EndInvoke($handleGUI)
$cmdGUI.Dispose()
$rsGUI.Dispose()

Exit

#endregion Start Point of Execution
