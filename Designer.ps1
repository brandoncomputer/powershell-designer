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
#region CustomFunctions

function CustomFunctions{}

function Open-FormFromFBS {
<#
    .SYNOPSIS
		Opens a form from an FBS file created with 'powershell-designer' or its
		predecessor, PowerShell WinForms Creator
			 
	.DESCRIPTION
		This function will open a form from an FBS file created with
		'powershell-designer' or its predecessor, PowerShell WinForms Creator
	 
	.PARAMETER Path
		The path to the FBS file.
	
	.EXAMPLE
		Open-FormFromPSD 'C:\Users\Brandon\OneDrive\Documents\PowerShell Designer\testing.fbs'
	
	.EXAMPLE
		Open-FormFromPSD -path 'C:\Users\Brandon\OneDrive\Documents\PowerShell Designer\testing.fbs'
	
	.EXAMPLE
		'C:\Users\Brandon\OneDrive\Documents\PowerShell Designer\testing.fbs' | Open-FormFromPSD
	
	.INPUTS
		Path as String
	
	.OUTPUTS
		Object
		
	.NOTES
		Each object created has a variable created to access the object 
		according to its Name attribute e.g. $Button1
#>
		param(
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Path
	)
	$content = [xml](get-content $Path)
	ConvertFrom-WinformsXML -xml $content.Data.Form.OuterXml
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

function Set-CurrentDirectory {
<#
	.SYNOPSIS
		Changes the current working directory to the path specified.
		
    .DESCRIPTION
		This function will change the current working directory to the path
		specified.
	
	.PARAMETER Path
		The path to change to.
	
	.EXAMPLE
		Set-CurrentDirectory 'c:\temp'
	
	.EXAMPLE
		Set-CurrentDirectory -path 'c:\temp'

	.EXAMPLE
		'c:\temp' | Set-CurrentDirectory

	.INPUTS
		Path as String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Path
	)
	Set-Location $Path
    [Environment]::CurrentDirectory = $Path
}


function Get-Abs {
<#
    .SYNOPSIS
		Returns the absolute value of a number.
			 
	.DESCRIPTION
		This function will call upon the math module to take the input of a 
		number and return the absolute value of that number.
	 
	.PARAMETER NumberValue
		The number being passed to the function.
	
	.EXAMPLE
		Get-Abs -34.6
	
	.EXAMPLE
		Get-Abs -NumberValue -34.6
	
	.EXAMPLE
		-34.6 | Get-Abs
	
	.EXAMPLE
		Write-Host "The absolute value of -34.6 is $(Get-Abs -34.6)"
	
	.INPUTS
		NumberValue as Decimal
	
	.Outputs
		Decimal
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [decimal]$NumberValue
    )
    return [math]::abs($NumberValue)
}

function Get-Arctangent {
<#
	.SYNOPSIS
		Returns arctangent
		
    .DESCRIPTION
		This function returns the arctangent of a number
	
	.PARAMETER Number
	
	.EXAMPLE
		$arc = Get-Arctangent 36
	
	.EXAMPLE
		$arc = Get-Arctangent -Number 36
		
	.EXAMPLE
		$arc = 36 | Get-Arctangent
		
	.INPUTS
		Number as Decimal
	
	.OUTPUTS
		Decimal
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [decimal]$Number
	)
    return [math]::atn($Number)
}

function Get-Cosine {
<#
	.SYNOPSIS
		Returns cosine
		
    .DESCRIPTION
		This function returns the cosine of a number
	
	.PARAMETER Number
	
	.EXAMPLE
		$cos = Get-Cosine 36
	
	.EXAMPLE
		$cos = Get-Cosine -Number 36
		
	.EXAMPLE
		$cos = 36 | Get-Cosine
		
	.INPUTS
		Number as Decimal
	
	.OUTPUTS
		Decimal
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [decimal]$Number
	)
    return [math]::cos($Number)
}

function Get-Exponent {
<#
	.SYNOPSIS
		Returns exponent
		
    .DESCRIPTION
		This function returns the exponent of a number
	
	.PARAMETER Number
	
	.EXAMPLE
		$exp = Get-Exponent 36
	
	.EXAMPLE
		$exp = Get-Exponent -Number 36
		
	.EXAMPLE
		$exp = 36 | Get-Exponent
		
	.INPUTS
		Number as Decimal
	
	.OUTPUTS
		Decimal
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [decimal]$Number
	)
    return [math]::exp($Number)
}

function Get-Log {
<#
    .SYNOPSIS
		Returns the logarithm value of a number.
			 
	.DESCRIPTION
		This function will call upon the math module to take the input of a 
		number and return the logarithm value of that number.
	 
	.PARAMETER NumberValue
		The number being passed to the function.
	
	.EXAMPLE
		Get-Log 34.6
	
	.EXAMPLE
		Get-Log -NumberValue 34.6
	
	.EXAMPLE
		34.6 | Get-Log
	
	.EXAMPLE
		Write-Host "The logarithm value of 34.6 is $(Get-Log 34.6)"
	
	.INPUTS
		NumberValue as Decimal
	
	.Outputs
		Decimal
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [decimal]$NumberValue
    )
	return [math]::log($NumberValue)
}

function Get-Fractional {
<#
    .SYNOPSIS
		Returns the portion of a number after the decimal point
			 
	.DESCRIPTION
		This function returns the portion of a number after the decimal point
	 
	.PARAMETER Decimal
		The decimal number to return the fractonal part of.
		
	.EXAMPLE
		Get-Fractional 1.123
	
	.EXAMPLE
		Get-Fractional -decimal 1.123
	
	.EXAMPLE
		1.123 | Get-Fractional
	
	.INPUTS
		Number as Decimal
	
	.OUTPUTS
		Integer
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [decimal]$Decimal
	)
    $Decimal = $Decimal | Out-String 
    return $Decimal.split(".")[1]/1	
}

function Get-Sine {
<#
    .SYNOPSIS
		Returns sine from a number
			 
	.DESCRIPTION
		This function returns sine from a given number
	 
	.PARAMETER Number
		The decimal number to return sine from
		
	.EXAMPLE
		Get-Sine 1.123
	
	.EXAMPLE
		Get-Sine -Number 1.123
	
	.EXAMPLE
		1.123 | Get-Sine
	
	.INPUTS
		Number as Decimal
	
	.OUTPUTS
		Decimal
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [decimal]$Number
	)
	return [math]::sin($Number)
}

function Get-SquareRoot {
<#
    .SYNOPSIS
		Returns square root from a number
			 
	.DESCRIPTION
		This function returns  square root from a given number
	 
	.PARAMETER Number
		The decimal number to return square root from
		
	.EXAMPLE
		Get-SqaureRoot 36
	
	.EXAMPLE
		Get-SquareRoot -Number 36
	
	.EXAMPLE
		36 | Get-SquareRoot
	
	.INPUTS
		Number as Decimal
	
	.OUTPUTS
		Decimal
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [decimal]$Number
	)
	return [math]::sqt($Number)
}

function Set-ActiveWindow {
<#
    .SYNOPSIS
		Sets the window as active
			 
	.DESCRIPTION
		This function sets the active window

	.PARAMETER Handle
		The handle of the window

	.EXAMPLE
		Set-ActiveWindow (Get-WindowExists "Untitled - Notepad")

	.EXAMPLE
		Set-ActiveWindow -handle (Get-WindowExists "Untitled - Notepad")
		
	.EXAMPLE
		(Get-WindowExists "Untitled - Notepad") | Set-ActiveWindow
		
	.INPUTS
		Handle as Handle
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
	[vds]::SetForegroundWindow($Handle)
}

function Send-Window {
<#
    .SYNOPSIS
		Sends a string to a window
			 
	.DESCRIPTION
		This function sends a string to a window

	.PARAMETER Handle
		The handle of the window
		
	.PARAMETER String
		The string to send to the window

	.EXAMPLE
		Send-Window (Get-WindowExists "Untitled - Notepad") "Hello World"

	.EXAMPLE
		Send-Window -handle (Get-WindowExists "Untitled - Notepad") -string "Hello World"
		
	.EXAMPLE
		(Get-WindowExists "Untitled - Notepad") | Send-Window -string "Hello World"
		
	.INPUTS
		Handle as Handle, String as String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle,
		[string]$String
	)
	Set-ActiveWindow $Handle
	$wshell = New-Object -ComObject wscript.shell
	$wshell.SendKeys("$String")
}

function Add-Alt {
<#
    .SYNOPSIS
		Sends the ALT key plus string. 
     
    .DESCRIPTION
		This function will prepend a the string parameter with the alt key
		commonly specified by the '%' character.
	
	.PARAMETER TextValue
		The text being passed to the Function
	
	.EXAMPLE
		$altfs = "$(Add-Alt F) S"
	
	.EXAMPLE
		$altfs = "$(Add-Alt -TextValue F) S"
	
	.EXAMPLE
		$altfs = "$('F' | Add-Alt) S"
	
	.EXAMPLE
		Send-Window (Get-Window notepad) "$(Add-Alt F) S"
	
	.INPUTS
		TextValue as String
	
	.OUTPUTS
		String
		
	.NOTES
		Only useful with 'Send-Window'.
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$TextValue
    )

    return "%$TextValue"
}

function Add-Shift {
<#
    .SYNOPSIS
		Sends the SHIFT key plus string. 
     
    .DESCRIPTION
		This function will prepend a the string parameter with the shift key
		commonly specified by the '+' character.
	
	.PARAMETER TextValue
		The text being passed to the Function
	
	.EXAMPLE
		$shift = Add-Shift f
	
	.EXAMPLE
		$shift = Add-Shift -textvalue f
		
	.EXAMPLE
		$shift = f | Add-Shift
	
	.EXAMPLE
		Send-Window (Get-Window notepad) (Add-Shift f)
	
	.INPUTS
		TextValue as String
	
	.OUTPUTS
		String
		
	.NOTES
		Only useful with 'Send-Window'.
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$TextValue
    )
	return "+$TextValue"
}

function Add-CTRL {
<#
    .SYNOPSIS
		Sends the CTRL key plus string. Only useful with 'Send-Window'.
     
    .DESCRIPTION
		This function will prepend a the string parameter with the ctrl key
		commonly specified by the '^' character.
	
	.PARAMETER TextValue
		The text being passed to the Function
	
	.EXAMPLE
		$ctrls = "$(Add-CTRL S)"
	
	.EXAMPLE
		$ctrls = "$(Add-CTRL -TextValue S)"
	
	.EXAMPLE
		$ctrls = "$('S' | Add-CTRL)"
	
	.EXAMPLE
		Send-Window (Get-Window notepad) "$(Add-CTRL S)"
	
	.INPUTS
		TextValue as String
	
	.OUTPUTS
		String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$TextValue
    )

    return "^$TextValue"
}

function Add-Tab {
<#
    .SYNOPSIS
		Sends the tab key 
     
    .DESCRIPTION
		This function sends the tab key
		
	.EXAMPLE
		Send-Window (Get-Window notepad) Add-Tab
	
	.OUTPUTS
		String
		
	.NOTES
		Only useful with 'Send-Window'.
#>
    return "`t" 
}

function Get-Ascii {
<#
	.SYNOPSIS
		Returns the ascii code number related to the character specified 
		in the string parameter.
     
    .DESCRIPTION
		This function will return the ascii code number or 'byte character'
		related to the character specified in the string parameter.
	
	.PARAMETER CharacterText
		The character being passed to the function.
	
	.EXAMPLE
		Get-Ascii A
	
	.EXAMPLE
		Get-Ascii -CharacterText A
	
	.EXAMPLE
		'A' | Get-Ascii
	
	.EXAMPLE
		Write-Host Get-Ascii -CharacterText 'A'
		
	.INPUTS
		CharacterText as String
	
	.OUTPUTS
		Int
#>
	[CmdletBinding()]
    param (
		[ValidateLength(1, 1)]
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$CharacterText
    )
	
    return [byte][char]$CharacterText
}

function Get-Character {
<#
	.SYNOPSIS
		Returns the text character related to the ascii code specified 
		in the string parameter.
     
    .DESCRIPTION
		This function will return the text character or 'character byte'
		related to the ascii code specified in the string parameter.
	
	.PARAMETER AsciiCode
		The character being passed to the function.
	
	.EXAMPLE
		Get-Character 34
	
	.EXAMPLE
		Get-Character -AsciiCode 34
	
	.EXAMPLE
		34 | Get-Character
	
	.EXAMPLE
		Write-Host Get-Character -AsciiCode 34
	
	.INPUTS
		AsciiCode as String
		
	.OUTPUTS
		String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$AsciiCode
    )
	return [char][byte]$AsciiCode
}

function Get-Key {
<#
    .SYNOPSIS
		Gets a operation character for the Send-Window function.
			 
	.DESCRIPTION
		This function gets a operation character for the Send-Window function.

	.PARAMETER Key
		Validated character from from the following set:
		BACKSPACE, BS, BKSP, BREAK, CAPSLOCK, DELETE,
		DEL, DOWN, END, ENTER, ESC, HELP, HOME, INSERT, INS,
		LEFT, NUMLOCK, PGDN, PGUP, PRTSC, RIGHT, SCROLLLOCK, 
		TAB, UP, F1, F2, F3, F4, F5, F6, F7, F8, F9, 
		F10, F11, F12, F13, F14, F15, F16

	.EXAMPLE
		Send-Window (Get-Window 'notepad') (Get-Key 'Home')

	.EXAMPLE
		$Key = Get-Key -key 'Home'
		
	.EXAMPLE
		$Key = 'Home' | Get-Key
		
	.INPUTS
		Key as ValidatedString
	
	.OUTPUTS
		String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
		[ValidateSet('BACKSPACE', 'BS', 'BKSP', 'BREAK', 'CAPSLOCK', 'DELETE',
		'DEL', 'DOWN', 'END', 'ENTER', 'ESC', 'HELP', 'HOME', 'INSERT', 'INS',
		'LEFT', 'NUMLOCK', 'PGDN', 'PGUP', 'PRTSC', 'RIGHT', 'SCROLLLOCK', 
		'TAB', 'UP', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 
		'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16')]
        [string[]]$Key
	)
   return $(Get-Character $(Get-Ascii "{"))+$Key+$(Get-Character $(Get-Ascii "}"))
}

function Get-Escape {
<#
	.SYNOPSIS
		Returns a escape character
		     
    .DESCRIPTION
		This function returns a escape character
		
	.EXAMPLE
		Send-Window (Get-Window 'Save As...') Get-Escape
	
	.OUTPUTS
		string
#>
    return Get-Character 27
}

function Get-CarriageReturn {
<#
	.SYNOPSIS
		Returns a carriage return character.
		     
    .DESCRIPTION
		This function returns a carriage return character and does not include a line feed.
		
	.EXAMPLE
		$Label1.Text = "Item 1$(Get-CarriageReturn)$(Get-LineFeed)Item 2$(Get-CarriageReturn)$(Get-LineFeed)Item 3"
	
	.OUTPUTS
		string
#>
    return Get-Character(13)
}

function Get-LineFeed {
<#
    .SYNOPSIS
		Returns a line feed character.
			 
	.DESCRIPTION
		This function returns a line feed character.

	.EXAMPLE
		$lf = Get-LineFeed
	
	.OUTPUTS
		String
#>
    return Get-Character 10
}

function Set-Format {
<#
    .SYNOPSIS
		Formats text according to a specification string
			 
	.DESCRIPTION
		This function formats text according to a specification string
	 
	.PARAMETER Text
		The text to format
		
	.PARAMETER Format
		The specification string to format the text with.
		
	.EXAMPLE
		Set-Format '5556667777' '###-###-####'
	
	.EXAMPLE
		Set-Format -text '5556667777' -format '###-###-####'
	
	.EXAMPLE
		'5556667777' | Set-Format -format '###-###-####'
	
	.INPUTS
		Text as String, Format as String
	
	.OUTPUTS
		String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Text,
		[Parameter(Mandatory)]
		[string]$Format
    )
    return $a | % {
        $_.ToString($b)
    }
}

function Get-Hex {
<#
    .SYNOPSIS
		Returns hexidecimal from text
			 
	.DESCRIPTION
		This function returns hexidecimal from text
	 
	.PARAMETER Text
		The string to return hex from.
		
	.EXAMPLE
		Get-Hex 'Division'
	
	.EXAMPLE
		Get-Hex -string 'Division'
	
	.EXAMPLE
		'Division' | Get-Hex
	
	.INPUTS
		Text as String
	
	.OUTPUTS
		Hexidecimal
#>	
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Text
	)
	return $Text | format-hex
}

function Get-Innertext {
<#
    .SYNOPSIS
		Returns the inner text of a string.
			 
	.DESCRIPTION
		This function returns the inner text of a string

	.PARAMETER Text
		The text to parse the inner text from
	 
	.PARAMETER LeftText
		The left parse string

	.PARAMETER RightText
		The right parse string

	.EXAMPLE
		$innertext = Get-Innertext "They don't know" "hey" "kno"

	.EXAMPLE
		$innertext = Get-Innertext -Text "They don't know" -LeftText "hey" -RightText "kno"
		
	.EXAMPLE
		$innertext = "They don't know" | Get-Innertext -LeftText "hey" -RightText "kno"
		
	.INPUTS
		Text as String, LeftText as String, RightText as String
	
	.OUTPUTS
		String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Text,
		[Parameter(Mandatory)]
		[string]$LeftText,
		[Parameter(Mandatory)]
		[string]$RightText
	)
    $split1 = $Text -Split $LeftText
    $split2 = ($split1[1] | out-string) -Split $RightText
	return ($split2[0] | out-string)
}

function Set-Innertext {
<#
    .SYNOPSIS
		Returns the inner text of a string.
			 
	.DESCRIPTION
		This function sets the inner text of a string

	.PARAMETER Text
		The text to parse the inner text from
	 
	.PARAMETER LeftText
		The left parse string

	.PARAMETER RightText
		The right parse string

	.PARAMETER InnerText
		The new inside text

	.EXAMPLE
		$innertext = Set-Innertext "They don't know" "hey" "kno" " do "

	.EXAMPLE
		$innertext = set-Innertext -Text "They don't know" -LeftText "hey" -RightText "kno" -Innertext " do "
		
	.EXAMPLE
		$innertext = "They don't know" | Get-Innertext -LeftText "hey" -RightText "kno" -Innertext " do "
		
	.INPUTS
		Text as String, LeftText as String, RightText as String, "InnerText"
	
	.OUTPUTS
		String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Text,
		[Parameter(Mandatory)]
		[string]$LeftText,
		[Parameter(Mandatory)]
		[string]$RightText,
		[Parameter(Mandatory)]
		[string]$InnerText
	)
    $split1 = $Text -Split $LeftText
    $split2 = ($split1[1] | out-string) -Split $RightText
	return ($split1[0]+$LeftText+$InnerText+$RightText+$split2[1] | out-string)	
}

function Get-TextPosition {
<#
    .SYNOPSIS
		Retrieves the Text position within a specified string.
			 
	.DESCRIPTION
		This function retrieves the Text position within a specified string.
		
	.PARAMETER String
		The source string to search for the position of text within
	
	.PARAMETER Text
		The text to retrieve the postion of.
	
	.EXAMPLE
		Get-TextPosition "Is Brandon there?" "there"
		
	.EXAMPLE
		Get-TextPosition -string "Is Brandon there?" -text "there"

	.EXAMPLE
		"Is Brandon there?" | Get-TextPosition -text "there"
		
	.INPUTS
		String as String, Text as String
	
	.OUTPUTS
		Integer || Boolean
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$String,
		[Parameter(Mandatory)]
		[string]$Text
	)
    $regEx = [regex]$String
    $pos = $regEx.Match($Text)
    if ($pos.Success){ 
        return $pos.Index
    }
    else {
        return false
    }
}

function Get-SubString {
<#
	.SYNOPSIS
	Gets the value of a string between a start index and a end index.
		
    .DESCRIPTION
		This function returns the value of a string between a start index and a 
		end index.
	
	.PARAMETER Text
		The string to be manipulated.
	
	.PARAMETER Start
		The start index of the return string.
	
	.PARAMETER End
		The end index of the return string.

	.EXAMPLE
		$string = Get-Substring $string 3 7
		
	.EXAMPLE
		$string = Get-Substring -Text $string -Start 3 -End 7

	.INPUTS
		Text as String, Start as Integer, End as Integer

	.OUTPUTS
		String
#>

	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Text,
		[Parameter(Mandatory)]
		[string]$Start,
		[Parameter(Mandatory)]
		[string]$End
	)
    return $Text.substring($Start,($End-$Start))
}

function Get-StringRemove {
<#
    .SYNOPSIS
		Removes the portion of a string between the start index and the end index
     
    .DESCRIPTION
		This function removes the portion of a string between the start index and the end index
	
	.PARAMETER String
		The string to remove the portion of
		
	.PARAMETER StartIndex
		The index to start at
		
	.PARAMETER EndIndex
		The index to end at
	
	.EXAMPLE
		$strdel = Get-StringRemove Computer 2 4
	
	.EXAMPLE
		$strdel = Get-StringRemove -string Computer -StartIndex 2 -EndIndex 4
		
	.EXAMPLE
		$strdel = Computer | Get-StringRemove -StartIndex 2 -EndIndex
	
	.INPUTS
		String as String, StartIndex as Integer, EndIndex as Integer
	
	.OUTPUTS
		String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$String,
		[Parameter(Mandatory)]
		[int]$StartIndex,
		[Parameter(Mandatory)]
		[int]$EndIndex
	)
	return ($String.substring(0,$StartIndex)+$(Get-Substring $String $EndIndex $String.length))
}

function ConvertTo-String {
<#
    .SYNOPSIS
		Converts the input to string
     
    .DESCRIPTION
		This function converts the input to string
	
	.PARAMETER Input
		The input to convert to string
		
	.EXAMPLE
		$toString = ConvertTo-String $Object
	
	.EXAMPLE
		$toString = ConvertTo-String -input $Object
		
	.EXAMPLE
		$toString = $Object | ConvertTo-String
	
	.INPUTS
		Input as Variant
	
	.OUTPUTS
		String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        $Input
	)
	return ($Input | Out-String).trim()
}

function Show-InformationDialog {
<#
    .SYNOPSIS
		Displays a information dialog with a message and title specified.
			 
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
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Message,
		[string]$Title
	)
	[System.Windows.Forms.MessageBox]::Show($Message,$Title,'OK',64) | Out-Null
}

function Show-Warning {
	<#
    .SYNOPSIS
		Displays a warning dialog
			 
	.DESCRIPTION
		This function displays a warning dialog

	.PARAMETER Message
		The message to present to the user
	 
	.PARAMETER Title
		The title of the warning box

	.EXAMPLE
		$input = Show-Warning "System memory is sideways" "Encounter Issue"

	.EXAMPLE
		$input = Show-Warning -Message "System memory is sideways" -Title "Encounter Issue"
		
	.EXAMPLE
		$input = "System memory is sideways" | Show-Warning -Title "Encounter Issue"
		
	.INPUTS
		Message as String, Title as String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Message,
		[string]$Title
	)
	[System.Windows.Forms.MessageBox]::Show($Message,$Title,'OK',48)
}


function Get-InputBox {
<#
    .SYNOPSIS
		Displays a dialog for user input.
			 
	.DESCRIPTION
		This function displays a dialog for user input.

	.PARAMETER Message
		The message to present to the user for input
	 
	.PARAMETER Title
		The title of the input box

	.PARAMETER Default
		The default input

	.EXAMPLE
		$input = Get-InputBox "Please describe the problem" "Encounter Issue" "No Spawn"

	.EXAMPLE
		$input = Get-InputBox -Message "Please describe the problem" -Title "Encounter Issue" -Default "No Spawn"
		
	.EXAMPLE
		$input = "Please describe the problem" | Get-InputBox -Title "Encounter Issue" -Default "No Spawn"
		
	.INPUTS
		Message as String, Title as String, Default as String
	
	.OUTPUTS
		String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Message,
		[string]$Title,
		[string]$Default
	)
    $input = [Microsoft.VisualBasic.Interaction]::InputBox($Message,$Title,$Default)
    return $input
}

function Get-OKCancelDialog {
<#
    .SYNOPSIS
		Displays an OK Cancel dialog window for input from the user.
			 
	.DESCRIPTION
		This function displays an OK Cancel dialog window for input from the user.
	
	.PARAMETER Message
		The message to display
		
	.PARAMETER Title
		The title for the dialog window
		
	.EXAMPLE
		$ok = Get-OKCancelDialog "Message" "Title"
		
	.EXAMPLE
		$ok = Get-OKCancelDialog -message "Message" -title "Title"

	.EXAMPLE
		$ok = "Message" | Get-OKCancelDialog -title "Title"
	
	.INPUTS
		Message as String, Title as String
	
	.OUTPUTS
		MessageBox
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Message,
		[string]$Title
	)
    $query = [System.Windows.Forms.MessageBox]::Show($Message,$Title,"OKCancel",32)
    return $query
} 

function Get-Answer {
<#
	.SYNOPSIS
		Opens a dialog window to ask the user a yes or no question.
     
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

function New-Beep {
<#
    .SYNOPSIS
		Beeps
     
    .DESCRIPTION
		Plays a system beep sound.
	
	.EXAMPLE
		New-Beep
	
	.OUTPUTS
		System Beep Sound
#>
    [console]::beep(500,300)
}

function New-Sound {
<#
    .SYNOPSIS
		Plays a sound according to the path specified. 
			 
	.DESCRIPTION
		This function plays a sound according to the path specified. If the 
		PlaySync switch is set, the program will pause until the sound has 
		completed.
		
	.PARAMETER Path
		The path to the file
	
	.PARAMETER PlaySync
		The switch that specifies if the program should wait for the sound to 
		complete.
	
	.EXAMPLE
		New-Sound c:\temp\temp.wav
		
	.EXAMPLE
		New-Sound -path c:\temp\temp.wav -playsync

	.EXAMPLE
		'c:\temp\temp.wav' | New-Sound
		
	.INPUTS
		Path as String, PlaySync as Switch
	
	.OUTPUTS
		Sound
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Path,
		[switch]$PlaySync
	)
	$PlayWav=New-Object System.Media.SoundPlayer
    $PlayWav.SoundLocation=$Path
	if ($PlaySync) {
		$PlayWav.playsync()
	}
	else {
		$PlayWav.play()
	}
}

function Clear-Clipboard {
<#
    .SYNOPSIS
    Clears the text from the clipboard.
     
    .DESCRIPTION
    This function will clear the value from the Text portion of the clipboard.
	
	.EXAMPLE
	Clear-Clipboard
#>
	echo $null | clip
}
 
 function Get-ColorByName {
<#
	.SYNOPSIS
		Returns the system drawing color related to the color name specified 
		in the string parameter.
     
    .DESCRIPTION
		This function will return the system drawing color related to the color 
		name specified by the text in the string parameter.
	
	.PARAMETER ColorName
		The name of the color specified in the string parameter.
	
	.EXAMPLE
		Get-ColorByName Brown
	
	.EXAMPLE
		Get-ColorByName -ColorName Brown
	
	.EXAMPLE
		Brown | Get-ColorByName
	
	.EXAMPLE
		Button1.BackColor = (Get-ColorByName 'Brown')
	
	.INPUTS
		ColorName as String
	
	.OUTPUTS
		System Drawing Color
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$ColorName
    )
	return [System.Drawing.Color]::FromName($ColorName)
}

function Get-ColorByRGB {
<#
	.SYNOPSIS
		Returns the system drawing color related to the RGB values specified 
		in the integer parameters.
     
    .DESCRIPTION
		This function will return the system drawing color related to the RGB 
		values specified by the values in the integer parameters.
	
	.PARAMETER R
		The value of Red in the RGB value set
		
	.PARAMETER G
		The value of Green in the RGB value set
		
	.PARAMETER B
		The value of Blue in the RGB value set
	
	.EXAMPLE
		Get-ColorByRGB 165 42 42
	
	.EXAMPLE
		Get-ColorByRGB -R 165 -G 42 -B 42
	
	.EXAMPLE
		Button1.BackColor = (Get-ColorByRGB 165 42 42)
	
	.INPUTS
		R as int, B as int, G as int
	
	.OUTPUTS
		System Drawing Color
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]$R,
        [Parameter(Mandatory)]
        [int]$G,
		[Parameter(Mandatory)]
        [int]$B
    )
	return  [System.Drawing.Color]::FromArgb($R,$G,$B)
}

function Show-ColorDialog {
<#
	.SYNOPSIS
		Presents a color dialog to the end user for color selection
		     
    .DESCRIPTION
		This function presents a color dialog to the end user and returns
		either the entire object or the common name of the color depending
		upon if the ColorNameText switch is utilized.
	
	.PARAMETER ColorNameText
		Switch that specifies if the color name only should be returned.
		
	.EXAMPLE
		$colorDialog = Show-ColorDialog
	
	.EXAMPLE
		$colorName = Show-ColorDialog -ColorNameText
	
	.EXAMPLE
		$colorDialog = Show-ColorDialog
		if ($colorDialog){
			Button1.BackColor = Get-ColorByRGB($colorDialog.color.R $colorDialog.color.G $colorDialog.color.B)
		}
	.INPUTS
		ColorNameText as Bool
	
	.OUTPUTS
		System Windows Forms ColorDialog or String or False
	
	.NOTES
		If cancel is not pressed which returns False, when the ColorNameText 
		switch is specified this will return the color name as string, 
		otherwise this will return a System Windows Forms ColorDialog object.
#>
	[CmdletBinding()]
	param([switch]$ColorNameText)
    $colorDialog = new-object System.Windows.Forms.ColorDialog
    if ($colorDialog.ShowDialog() -eq 'OK'){
		if ($ColorNameText -eq $False) {
			return $colorDialog
		}
		else {
			return $colorDialog.color.name
		}
	}
	else {
		return $False
	}
}


function Show-FolderBrowserDialog {
<#
	.SYNOPSIS
		Returns the value from a Foloder Browser Dialog.
		
    .DESCRIPTION
		This function presents a folder browser dialog and returns the user selection.
	
	.PARAMETER Description
		The description presented to the user on what they are looking for.
	
	.PARAMETER RootFolder
		The root folder for the user to begin making their selecton. Must be 
		one of the following values:
		Desktop, Programs, MyDocuments, Personal, 
		Favorites, Startup, Recent, SendTo, StartMenu, MyMusic,
		MyVideos, DesktopDirectory, MyComputer, NetworkShortcuts,
		Fonts, Templates, CommonStartMenu, CommonPrograms, 
		CommonStartup, CommonDesktopDirectory, ApplicationData, 
		PrinterShortcuts, LocalApplicationData, InternetCache, Cookies,
		History, CommonApplicationData, Windows, System, 
		ProgramFiles, MyPictures, UserProfile, SystemX86, 
		ProgramFilesX86, CommonProgramFiles, CommonProgramFilesX86, 
		CommonTemplates, CommonDocuments, CommonAdminTools, AdminTools, 
		CommonMusic, CommonPictures, CommonVideos, Resources,
		LocalizedResources, CommonOemLinks, CDBurning
	
	.EXAMPLE
		$Folder = Show-FolderBrowserDialog "Please select a folder" "MyComputer"
	
	.EXAMPLE
		$Folder = Show-FolderBrowserDialog -Description "Please select a folder" -RootFolder "MyComputer"

	.EXAMPLE
		$Folder = "Please select a folder" | Show-FolderBrowserDialog -RootFolder "MyComputer"

	.INPUTS
		Description as String, RootFolder as ValidatedString
	
	.OUTPUTS
		String
#>
	[CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]$Description,
		[ValidateSet('Desktop', 'Programs', 'MyDocuments', 'Personal', 
		'Favorites', 'Startup', 'Recent', 'SendTo', 'StartMenu', 'MyMusic',
		'MyVideos', 'DesktopDirectory', 'MyComputer', 'NetworkShortcuts',
		'Fonts', 'Templates', 'CommonStartMenu', 'CommonPrograms', 
		'CommonStartup', 'CommonDesktopDirectory', 'ApplicationData', 
		'PrinterShortcuts', 'LocalApplicationData', 'InternetCache', 'Cookies',
		'History', 'CommonApplicationData', 'Windows', 'System', 
		'ProgramFiles', 'MyPictures', 'UserProfile', 'SystemX86', 
		'ProgramFilesX86', 'CommonProgramFiles', 'CommonProgramFilesX86', 
		'CommonTemplates', 'CommonDocuments', 'CommonAdminTools', 'AdminTools', 
		'CommonMusic', 'CommonPictures', 'CommonVideos', 'Resources',
		'LocalizedResources', 'CommonOemLinks', 'CDBurning')]
		[string[]]$RootFolder
	)
	
$dirdlg = New-Object System.Windows.Forms.FolderBrowserDialog
$dirdlg.description = $Descriptiion
$dirdlg.rootfolder = $RootFolder
    if($dirdlg.ShowDialog() -eq "OK")   {
        $folder += $dirdlg.SelectedPath
    }
        return $folder
}

function Show-OpenFileDialog {
<#
	.SYNOPSIS
		Shows a window for opening a file.
		
    .DESCRIPTION
		This function shows a window for opening a file.
	
	.PARAMETER InitialDirectory
		The initial path for the file dialog.
		
	.PARAMETER Filter
		The extension filter to apply
	
	.EXAMPLE	
		$file = Show-OpenFileDialog '%userprofile%' 'Text Files|*.txt'

	.EXAMPLE	
		$file = Show-OpenFileDialog -InitialDirectory '%userprofile%' -Filter 'Text Files|*.txt'
		
	.EXAMPLE	
		$file = '%userprofile%' | Show-OpenFileDialog -Filter 'Text Files|*.txt'
	
	.INPUTS
		InitialDirectory as String, Filter as String
	
	.OUTPUTS
		String
#>	
	[CmdletBinding()]
    param (
		[Parameter(ValueFromPipeline)]
		[string]$InitialDirectory,
		[string]$Filter
	)
	$filedlg = New-Object System.Windows.Forms.OpenFileDialog
	$filedlg.initialDirectory = $initialDirectory
	$filedlg.filter = $Filter
	$filedlg.ShowDialog() | Out-Null
	return $filedlg.FileName
}

function Show-SaveFileDialog {
<#
	.SYNOPSIS
		Shows a window for saving a file.
		
    .DESCRIPTION
		This function shows a window for saving a file.
	
	.PARAMETER InitialDirectory
		The initial path for the file dialog.
		
	.PARAMETER Filter
		The extension filter to apply
	
	.EXAMPLE	
		$file = Show-SaveFileDialog '%userprofile%' 'Text Files|*.txt'

	.EXAMPLE	
		$file = Show-SaveFileDialog -InitialDirectory '%userprofile%' -Filter 'Text Files|*.txt'
		
	.EXAMPLE	
		$file = '%userprofile%' | Show-SaveFileDialog -Filter 'Text Files|*.txt'
	
	.INPUTS
		InitialDirectory as String, Filter as String
	
	.OUTPUTS
		String
#>	
	[CmdletBinding()]
    param (
		[Parameter(ValueFromPipeline)]
		[string]$InitialDirectory,
		[string]$Filter
	)
	$filedlg = New-Object System.Windows.Forms.SaveFileDialog
	$filedlg.initialDirectory = $initialDirectory
	$filedlg.filter = $Filter
	$filedlg.ShowDialog() | Out-Null
	return $filedlg.FileName
}

function Show-FontDialog {
<#
    .SYNOPSIS
		Returns a font dialog
			 
	.DESCRIPTION
		This function returns a font dialog
	
	.EXAMPLE
		$font = Show-FontDialog
	
	.OUTPUTS
		Windows.Forms.FontDialog
#>
    $fontdlg = new-object windows.forms.fontdialog
    $fontdlg.showcolor = $true
    $fontdlg.ShowDialog()
    return $fontdlg
}

function Read-CSV {
<#
	.SYNOPSIS
		Reads a cell from a CSV file.
		     
    .DESCRIPTION
		This function will read in the value from a cell withinn a CSV file 
		according to column and row specified
	
	.PARAMETER FilePath
		The path to the file to read in the cell value from

	.PARAMETER Column
		The column of the cell to read in the value from
		
	.PARAMETER Row
		The row of the cell to read in the value from
		
	.PARAMETER ColumnCount
		Optional parameter for specifying the count of the columns if the value
		needs to be different than 256
	
	.EXAMPLE
		$Value = Read-CSV "c:\temp\temp.csv" 2 3 340
	
	.EXAMPLE
		$Value = Read-CSV "c:\temp\temp.csv" 2 3
		
	.EXAMPLE
		$Value = Read-CSV -FilePath "c:\temp\temp.csv" -Column 2 -Row 3 -ColumnCount 340
	
	.EXAMPLE
		$Value = Read-CSV -FilePath "c:\temp\temp.csv" -Column 2 -Row 3

	.EXAMPLE
		$Value = "c:\temp\temp.csv" | Read-CSV -Column 2 -Row 3
	
	.INPUTS
		FilePath as String, Column as Integer, Row as Integer, ColumnCount as Integer
	
	.OUTPUTS
		String
#>
	
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$FilePath,
        [Parameter(Mandatory)]
        [int]$Column,
		[Parameter(Mandatory)]
        [int]$Row,
        [int]$ColumnCount
    )
	
	
	if ($ColumnCount){
		while ($i -lt $ColumnCount) {
			$build += ($i+1),($i+2)
			$i = $i+2
		}
	}
	else {
		while ($i -lt 256) {
			$build += ($i+1),($i+2)
			$i = $i+2
		}
	}

	$csv = Import-Csv $FilePath -header $build.ForEach({ $_ })
	$i = 0
	$csv | %{
		$i = $i+1
		if ($i -eq $Row){
			return $_.$Column
		}
	}
}

function Write-CSV {
<#
	.SYNOPSIS
		Write a cell to a CSV file.
		     
    .DESCRIPTION
		This function will write in the value to a cell within a CSV file 
		according to column and row specified
	
	.PARAMETER FilePath
		The path to the file to write in the cell value to

	.PARAMETER Column
		The column of the cell to write in the value to
		
	.PARAMETER Row
		The row of the cell to write in the value to
		
	.PARAMETER ColumnCount
		Optional parameter for specifying the count of the columns if the value is greater than 256
	
	.EXAMPLE
		Write-CSV "c:\temp\temp.csv" 2 3 "Write" 340
	
	.EXAMPLE
		Write-CSV "c:\temp\temp.csv" 2 3 "Write"

	.EXAMPLE
		Write-CSV -FilePath "c:\temp\temp.csv" -Column 2 -Row 3 -Value "Write" -ColumnCount 340
	
	.EXAMPLE
		Write-CSV -FilePath "c:\temp\temp.csv" -Column 2 -Row 3 -Value "Write"
	
	.EXAMPLE
		"c:\temp\temp.csv" | Write-CSV -Column 2 -Row 3 -Value "Write"
	
	.INPUTS
		FilePath as String, Column as Int, Row as Int, Value as String, ColumnCount as Integer
	
	.OUTPUTS
		utf8 encoded modified CSV file at FilePath specified.
#>
	
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$FilePath,
        [Parameter(Mandatory)]
        [int]$Column,
		[Parameter(Mandatory)]
        [int]$Row,
        [Parameter(Mandatory)]
        [string]$Value,
		[int]$ColumnCount
		
    )
	
	
	if ($ColumnCount){
		while ($i -lt $ColumnCount) {
		$build += ($i+1),($i+2)
		$i = $i+2
		}
	}
	else {
		while ($i -lt 256) {
		$build += ($i+1),($i+2)
		$i = $i+2
		}
	}

	$csv = Import-Csv $FilePath -header $build.ForEach({ $_ })
	$i = 0
	$csv | %{
	$i = $i+1
		if ($i -eq $Row){
		$_.$Column = $Value
			$csv | export-csv $FilePath -NoTypeInformation
			$Content = Get-content $FilePath | select-object -skip 1
			$Content | out-file $FilePath -Encoding utf8       
		}
	}
}

function Initialize-ODBC {
<#
	.SYNOPSIS
		Returns an initialized ODBC object.
		     
    .DESCRIPTION
		This function returns the initialized ODBC object.
		
	.EXAMPLE
		$database = Initialize-ODBC
	
	.OUTPUTS
		System Data ODBC ODBCConnection
#>
	return new-object System.Data.Odbc.OdbcConnection
}

function Open-DataSourceName {
<#
	.SYNOPSIS
		Specifies a data source name to an initialized ODBC object.
		     
    .DESCRIPTION
		This function creates a connection to a data source via a previously 
		initialized ODBC object which was commonly specified in the 
		Initialize-ODBC function.
	
	.PARAMETER ODBCObject
		The ODBCObject, usually the return object from the Initialize-ODBC command.
	
	.PARAMETER DataSourceName
		The datasource that must exists in the Windows ODBC Data Sources.
	
	.EXAMPLE
		Open-DataSourceName $database $DSN
	
	.EXAMPLE
		Open-DataSourceName -ODBCObject $database -DataSourceName $DSN

	.EXAMPLE
		$database | Open-DataSourceName -DataSourceName $DSN
	
	.INPUTS
		ODBCObject as System Data ODBC ODBCConnection, DataSourceName as String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$ODBCObject,
        [Parameter(Mandatory)]
        [string]$DataSourceName
    )
	$ODBCObject.connectionstring = "DSN="+$DataSourceName
    $ODBCObject.Open()	
}

function Close-DataSourceName {
<#
	.SYNOPSIS
		Closes the connection to a data source name in the ODBC object 
		referenced.
		     
    .DESCRIPTION
		This function closes the connection to a Data Source Name (DSN) that an 
		ODBC Object to connected to. The ODBC Object is the parameter for this 
		command.

	.PARAMETER ODBCObject
		The ODBCObject, usually the return object from the Initialize-ODBC command.

	.EXAMPLE
		Close-DataSourceName $database
	
	.EXAMPLE
		Close-DataSourceName -ODBCObject $database
	
	.EXAMPLE
		$database | Close-DataSourceName
		
	.INPUTS
		System Data ODBC ODBCConnection
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$ODBCObject
	)
	$ODBCObject.Close()
}

function Get-DataTables {
<#
	.SYNOPSIS
		Executes a query to the Data Source opened in a ODBC Object. Returns
		back the tables impacted as a dataset.
		     
    .DESCRIPTION
		This function executes a query specified by the string parameter and
		returns the dataset that was impacted.

	.PARAMETER ODBCObject
		The ODBCObject, usually the return object from the Initialize-ODBC command.

	.PARAMETER Query
		The SQL query to execute upon the ODBCObject.

	.EXAMPLE
		$dataset = Get-DataTables $database ("select * from TestStruct where name like '%"+$SearchBox.text+"%'")

	.EXAMPLE
		$dataset = Get-DataTables -ODBCObject $database -Query ("select * from TestStruct where name like '%"+$SearchBox.text+"%'")

	.EXAMPLE
		$dataset = $database | Get-DataTables -Query ("select * from TestStruct where name like '%"+$SearchBox.text+"%'")
	
	.INPUTS
		ODBCObject as System Data ODBC ODBCConnection, Query as String
	
	.OUTPUTS
		Tables
#>

	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$ODBCObject,
        [Parameter(Mandatory)]
        [string]$Query
    )
	$command = New-object System.Data.Odbc.OdbcCommand($Query,$ODBCObject)
	$getdata = new-object System.Data.Dataset
	(new-object System.Data.odbc.Odbcdataadapter($command)).Fill($getdata)
	return $getdata.tables
}

function ConvertTo-DateTime {
<#
	.SYNOPSIS
		Returns back the value of a string as datetime.
		
    .DESCRIPTION
		This function will return the value of the string parameter as a 
		datetime object.
	
	.PARAMETER DateTime
		The text to convert Date/Time format.
	
	.EXAMPLE
		$Date = ConvertTo-DateTime '7/7/2024'

	.EXAMPLE
		$Date = ConvertTo-DateTime -DateTime '7/7/2024'
	
	.EXAMPLE
		$Date = '7/7/2024' | ConvertTo-DateTime
	
	.EXAMPLE
		write-host (ConvertTo-DateTime '7/17/2020 8:52:33 pm').AddDays(-1)
	
	.INPUTS
		DateTime as String
	
	.OUTPUTS
		DateTime
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$DateTime
    )
	return [System.Convert]::ToDateTime($DateTime)
}

function Protect-Secret {
<#
	.SYNOPSIS
		Encrypts a secret with a value key pair.
		
    .DESCRIPTION
		This function takes the text that you input and returns the encrypted 
		value locked with a AES Key to a single object that has "Secret" and 
		"Key" property attributes than can then be passed to the 
		Unprotect-Secret function for decryption.
	
	.PARAMETER Secret
		The text to protect.
	
	.EXAMPLE
		$Secret = Protect-Secret '9/27/1975'

	.EXAMPLE
		$Secret = Protect-Secret -secret '9/27/1975'
	
	.EXAMPLE
		$Secret = '9/27/1975' | Protect-Secret	
	
	.INPUTS
		Secret as String
	
	.OUTPUTS
		PSCustomObject
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Secret
    )
	$SecureString = $Secret | ConvertTo-SecureString -AsPlainText -Force
	$AESKey = New-Object Byte[] 32
	[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($AESKey)
	$Secret = $SecureString | ConvertFrom-SecureString -Key $AESKey
	$return = [PSCustomObject] | Select-Object -Property Secret, Key
	$return.Secret = $Secret
	$return.Key = "$($AESKey)"
	return $return
}

function Unprotect-Secret {
<#
	.SYNOPSIS
		Decrypts a secret from a value key pair.
		
    .DESCRIPTION
		This function decrypts a secret that has been created using the 
		Protect-Secret function using the "Secret" and "Key" property that was
		returned.
	
		This function takes the text that you input and returns the encrypted 
		value locked with a AES Key to a single object that has "Secret" and 
		"Key" property attributes than can then be passed to the 
		Unprotect-Secret function for decryption.
	
	.PARAMETER Secret
		The text to unprotect.
	
	.PARAMETER Key
		The text that locked the secret.
	
	.EXAMPLE
		$Secret = Unprotect-Secret $Secret.Secret $Secret.Key

	.EXAMPLE
		$Secret = Unprotect-Secret -secret $Secret.Secret -key $Secret.Key
	
	.INPUTS
		Secret as String, Key as String
	
	.OUTPUTS
		String
	
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Secret,
		[Parameter(Mandatory)]
		[string]$Key
    )
	[byte[]]$Key = $Key.split(" ")
	$secure = $Secret | ConvertTo-SecureString -Key $Key
	$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
	$UnprotectedSecret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
	[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
	return $UnprotectedSecret
}

function Get-WebFile {
<#
	.SYNOPSIS
		Downloads a file from a URL
		
    .DESCRIPTION
		This function downloads a file from a URL
	
	.PARAMETER URL
		The URL to download the file from.
		
	.PARAMETER Path
		The file path to save the URL to.
	
	.EXAMPLE
		Get-WebFile https://neverplaywithgod.com/image1.jpg c:\temp\image1.jpg
	
	.EXAMPLE
		Get-WebFile -URL 'https://neverplaywithgod.com/image1.jpg' -Path 'c:\temp\image1.jpg'		
	
	.EXAMPLE
		'https://neverplaywithgod.com/image1.jpg' | Get-WebFile -Path 'c:\temp\image1.jpg'
		
	.INPUTS
		URL as String, Path as String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$URL,
		[Parameter(Mandatory)]
		[string]$Path
	)
	$file = New-Object System.Net.WebClient
	$file.DownloadFile($URL,$Path)
}

function Get-ImageFromStream {
<#
	.SYNOPSIS
		Gets an image from http protocol.
		
    .DESCRIPTION
		This function returns an image from the world wide web.
	
	.PARAMETER URL
		The URL of the image.

	.EXAMPLE
		$PictureBox1.Image = Get-ImageFromStream https://imagegallery.com/image2.png
		
	.EXAMPLE
		$PictureBox1.Image = Get-ImageFromStream -URL 'https://imagegallery.com/image2.png'

	.EXAMPLE
		$PictureBox1.Image = 'https://imagegallery.com/image2.png' | Get-ImageFromStream 

	.INPUTS
		URL as String

	.OUTPUTS
		System Drawing Image
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$URL
	)
    $s = iwr $URL
    $r = New-Object IO.MemoryStream($s.content, 0, $s.content.Length)
    $r.Write($s.content, 0, $s.content.Length)
    return [System.Drawing.Image]::FromStream($r, $true)       
}

function Get-ImageFromFile {
<#
	.SYNOPSIS
		Gets an image from a file.
		
    .DESCRIPTION
		This function returns an image from a file location.
	
	.PARAMETER File
		The path of the file.

	.EXAMPLE
		$PictureBox1.Image = Get-ImageFromFile "c:\images\img1.jpg"
		
	.EXAMPLE
		$PictureBox1.Image = Get-ImageFromFile -File 'c:\images\img2.jpg'

	.EXAMPLE
		$PictureBox1.Image = 'c:\images\img3.png' | Get-ImageFromFile 

	.INPUTS
		File as String

	.OUTPUTS
		System Drawing Image
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$File
	)
return [System.Drawing.Image]::FromFile($File)
}

function New-Form {
<#
	.SYNOPSIS
		Creates a new vdsForm.
		
    .DESCRIPTION
		This function creates a new vdsForm.
	
	.PARAMETER Title
		The title of the vdsForm.
	
	.PARAMETER Top
		The value of the Top property of the control.
		
	.PARAMETER Left
		The value of the Left property of the control.
		
	.PARAMETER Width
		The value of the Width property of the control.
		
	.PARAMETER Hieght
		The value of the Height property of the control.

	.EXAMPLE
		$Form1 = New-Form "This is the size of a monitor from 1993" 30 30 640 480

	.EXAMPLE
		$Form1 = New-Form -Title "Form1" -Top 30 -Left 30 -Width 640 -Height 480 
	
	.EXAMPLE
		$Form1 = "Form1" | New-Form -Top 30 -Left 30 -Width 640 -Height 480 

	.INPUTS
		Title as String, Top as Int, Left as Int, Width as Int, Height as Int
	
	.OUTPUTS
		vdsForm
	
	.NOTES
		Usually precedes the Add-CommonControl command and is usually followed by the Show-Form or Show-FormModal command.
	
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory, 
			ValueFromPipeline)]
		[string]$Title,
		[Parameter(Mandatory)]
		[int]$Top,
		[Parameter(Mandatory)]
		[int]$Left,
		[Parameter(Mandatory)]
		[int]$Width,
		[Parameter(Mandatory)]
		[int]$Height
    )
	$Form = [vdsForm] @{
	ClientSize = New-Object System.Drawing.Point 0,0}
	$Form.Text = $Title
	$Form.Top = $Top * $ctscale
	$Form.Left = $Left * $ctscale
	$Form.Width = $Width * $ctscale
	$Form.Height = $Height * $ctscale
	return $Form
}

function Add-CommonControl {
<#
	.SYNOPSIS
		Adds a common control to a vdsForm object
		
    .DESCRIPTION
		This function adds a common control to a vdsForm object.
	
	.PARAMETER Form
		The vdsForm to add the object to.
	
	.PARAMETER ControlType
		The type of control to add to the vdsForm from the following set:
		'Button','CheckBox','CheckedListBox','ComboBox', 'DataGrid',
		'DataGridView','DateTimePicker','GroupBox','HScrollBar',
		'Label','LinkLabel','ListBox','MaskedTextBox','MonthCalendar',
		'NumericUpDown','Panel','PictureBox','ProgressBar','RadioButton',
		'RichTextBox','TextBox','TrackBar','TreeView','VScrollBar',
		'WebBrowser'
	
	.PARAMETER Top
		The value of the Top property of the control.
		
	.PARAMETER Left
		The value of the Left property of the control.
		
	.PARAMETER Width
		The value of the Width property of the control.
		
	.PARAMETER Hieght
		The value of the Height property of the control.

	.PARAMETER Text
		The value of the Text property of the control.
	
	.EXAMPLE
		$Button1 = Add-CommonControl $Form1 Button 60 30 200 25 "Execute"

	.EXAMPLE
		$TextBox1 = Add-CommonControl -Form $Form1 -ControlType TextBox -Top 30 -Left 30 -Width 200 -Height 25 

	.EXAMPLE
		$TextBox1 = $Form1 | Add-CommonControl -ControlType TextBox -Top 30 -Left 30 -Width 200 -Height 25 
	
	.INPUTS
		Form as Object, ControlType as ValidatedString, Top as Int, Left as Int, Width as Int, Height as Int, Text as String
	
	.OUTPUTS
		System Windows Forms (ControlType)
	
	.NOTES
		Normally precedented by the New-Form command.
	
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Form,
		[Parameter(Mandatory)]
		[ValidateSet('Button','CheckBox','CheckedListBox','ComboBox',
		'DataGrid','DataGridView','DateTimePicker','GroupBox','HScrollBar',
		'Label','LinkLabel','ListBox','MaskedTextBox','MonthCalendar',
		'NumericUpDown','Panel','PictureBox','ProgressBar','RadioButton',
		'RichTextBox','TextBox','TrackBar','TreeView','VScrollBar',
		'WebBrowser')]
		[string[]]$ControlType,
		[Parameter(Mandatory)]
		[int]$Top,
		[Parameter(Mandatory)]
		[int]$Left,
		[Parameter(Mandatory)]
		[int]$Width,
		[Parameter(Mandatory)]
		[int]$Height,
		[string]$Text
    )
	$Control = New-Object System.Windows.Forms.$ControlType
	$Control.Top = $Top * $ctscale
    $Control.Left = $Left * $ctscale
    $Control.Width = $Width * $ctscale
    $Control.Height = $Height * $ctscale
    $Control.Text = $Text
	$Form.Controls.Add($Control)
	return $Control
}

function Add-StatusStrip {
<#
	.SYNOPSIS
		Creates a StatusStrip control
		
    .DESCRIPTION
		This function creates a StatusStrip control to be added to a form.
	
	.PARAMETER Form
		The vdsForm to add the StatusStrip to.

	.EXAMPLE
		$StatusStrip1 = Add-StatusStrip $Form1
		$StatusStrip1.items[0].Text = "Ready"
		
	.EXAMPLE
		$StatusStrip1 = Add-StatusStrip -Form $Form1
		$StatusStrip1.items[0].Text = "Ready"	
		
	.EXAMPLE
		$StatusStrip1 = $Form1 | Add-StatusStrip
		$StatusStrip1.items[0].Text = "Ready"	

	.INPUTS
		Form as Object

	.OUTPUTS
		System Windows Forms StatusStrip with System Windows Forms ToolStripStatusLabel as a child object.	
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Form
	)
	$statusstrip = new-object System.Windows.Forms.StatusStrip
	$Form.controls.add($statusstrip)
	$ToolStripStatusLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
	$statusstrip.Items.AddRange($ToolStripStatusLabel)
	return $statusstrip
}

function Add-MenuStrip {
<#
	.SYNOPSIS
		Adds a MenuStrip control to an existing form.
		
    .DESCRIPTION
		This function will add a MenuStrip control to a specified existing form.
	
	.PARAMETER Form
		The form to add a MenuStrip to.
	
	.EXAMPLE
		$MenuStrip1 = Add-MenuStrip $Form1
		
	.EXAMPLE
		$MenuStrip1 = Add-MenuStrip -Form $Form1
		
	.EXAMPLE
		$MenuStrip1 = $Form1 | Add-MenuStrip

	.INPUTS
		Form as Object

	.OUTPUTS
		System Windows Forms MenuStrip
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Form
	)
	$MenuStrip = new-object System.Windows.Forms.MenuStrip
	$MenuStrip.imagescalingsize = new-object System.Drawing.Size([int]($ctscale * 16),[int]($ctscale * 16))
	$Form.Controls.Add($MenuStrip)
	return $MenuStrip
}

function Add-ContextMenuStrip {
<#
	.SYNOPSIS
		Adds a ContextMenuStrip control to an existing object.
		
    .DESCRIPTION
		This function will add a ContextMenuStrip control to a specified existing object.
	
	.PARAMETER Object
		The object to add a ContextMenuStrip to.
	
	.EXAMPLE
		$CMenuStrip1 = Add-ContextMenuStrip $Form1
		
	.EXAMPLE
		$ContextMenuStrip1 = Add-MenuStrip -object $Taskicon1
		
	.EXAMPLE
		$CMenuStrip1 = $Form1 | Add-MenuStrip
		
	.EXAMPLE

	.INPUTS
		Object as Object

	.OUTPUTS
		System Windows Forms ContextMenuStrip
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Object
	)
	$MenuStrip = new-object System.Windows.Forms.ContextMenuStrip
	$MenuStrip.imagescalingsize = new-object System.Drawing.Size([int]($ctscale * 16),[int]($ctscale * 16))
	$Object.ContextMenuStrip = $MenuStrip
	return $MenuStrip
}

function Add-ContextMenuStripItem{
<#
	.SYNOPSIS
		Adds an item to a context menu strip.
		
    .DESCRIPTION
		This function will add an item to an existing context menu strip.
	
	.PARAMETER ContextMenuStrip
		The ContextMenuStrip to add an item to.
	
	.PARAMETER Title
		The title to apply to the item.
		
	.PARAMETER Image
		The image from file or stream to apply to the menu row item.

	.PARAMETER ShortCutKeys
		The ShortCutKey to apply to the menu row item.

	.EXAMPLE
		$ContextMenuStripRow1 = Add-ContextMenuStripItem $ContextMenuStrip1 "&New"
	
	.EXAMPLE
		$ContextMenuStripRow1 = Add-ContextMenuStripItem $ContextMenuStrip1 "&New" -Image "c:\images\new.png" -ShortCutKeys "Ctrl+N"

	.EXAMPLE
		$ContextMenuStripRow1 = Add-ContextMenuStripItem -ContextMenuStrip $ContextMenuStrip1 -Title "&New" -Image "c:\images\new.png" -ShortCutKeys "Ctrl+N"

	.EXAMPLE
		$ContextMenuStripRow1 = $ContextMenuStrip1 | Add-ContextMenuStripItem -Title "&New" -Image "c:\images\new.png" -ShortCutKeys "Ctrl+N"
		
	.INPUTS
		ContextMenuStrip as System Windows Forms ContextMenuStrip, Title as String, Image as String, ShortCutKeys as String

	.OUTPUTS
		System Windows Forms ToolStripMenuItem
#>

	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[System.Windows.Forms.ContextMenuStrip]$ContextMenuStrip,
		[string]$Title,
		[string]$Image,
		[string]$ShortCutKeys
	)
	
	$MenuRow = New-Object System.Windows.Forms.ToolStripMenuItem
	if ($Image -ne ""){
		if ((Get-SubString $Image 0 2) -eq 'ht') {
			$MenuRow.Image = Get-ImageFromStream $Image
		}
		else{
			$MenuRow.Image = Get-ImageFromFile $Image
		}
	}
	if ($ShortCutKeys -ne ""){
		$MenuRow.ShortCutKeys = $ShortCutKeys
		$MenuRow.ShowShortCutKeys = $True
	}
	$MenuRow.Name = $Title
	$MenuRow.Text = $Title
	$ContextMenuStrip.Items.add($MenuRow) | Out-Null
	return $MenuRow
}

function Add-MenuColumn {
<#
	.SYNOPSIS
		Adds a Menu column header to an existing MenuStrip control.
		
    .DESCRIPTION
		This function will add a menu column header tool strip menu item to an 
		existing menustrip control.
	
	.PARAMETER MenuStrip
		The menustrip to add a column header to.
	
	.PARAMETER Title
		The title to apply to the column header.
	
	.EXAMPLE
		$FileColumn = Add-MenuColumn $MenuStrip1 "&File"
		
	.EXAMPLE
		$FileColumn = Add-MenuColumn -MenuStrip $MenuStrip1 -Title "&File"
		
	.EXAMPLE
		$FileColumn = $MenuStrip1 | Add-MenuColumn -Title "&File"

	.INPUTS
		MenuStrip as System Windows Forms MenuStrip, Title as String

	.OUTPUTS
		System Windows Forms ToolStripMenuItem
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[System.Windows.Forms.MenuStrip]$MenuStrip,
		[string]$Title
	)
	$MenuColumn = new-object System.Windows.Forms.ToolStripMenuItem
	$MenuColumn.Name = $Title
	$MenuColumn.Text = $Title
	$MenuStrip.Items.add($MenuColumn) | Out-Null
	return $MenuColumn
}

function Add-MenuRow {
<#
	.SYNOPSIS
		Adds a Menu row to an existing menu column header or context menu.
		
    .DESCRIPTION
		This function will add a menu column header tool strip menu item to an 
		existing menustrip control or context menu.
	
	.PARAMETER MenuStrip
		The menustrip to add a column header to.
	
	.PARAMETER Title
		The title to apply to the column header.
	
	.PARAMETER Image
		The image from file or stream to apply to the menu row item.

	.PARAMETER ShortCutKeys
		The ShortCutKey to apply to the menu row item.

	.EXAMPLE
		$FileMenuRow1 = Add-MenuRow $FileMenu "&New"
	
	.EXAMPLE
		$FileMenuSubRow1 = Add-MenuRow $FileMenuRow1 "&Text File"
	
	.EXAMPLE
		$FileMenuRow1 = Add-MenuRow $FileMenu "&New" -Image "c:\images\new.png" -ShortCutKeys "Ctrl+N"

	.EXAMPLE
		$FileMenuRow1 = Add-MenuRow -MenuColumn $FileMenu -Title "&New" -Image "c:\images\new.png" -ShortCutKeys "Ctrl+N"
		
	.EXAMPLE
		$FileMenuRow1 = $FileMenu | Add-MenuRow -Title "&New" -Image "c:\images\new.png" -ShortCutKeys "Ctrl+N"
		
	.INPUTS
		MenuStrip as System Windows Forms MenuStrip, Title as String

	.OUTPUTS
		System Windows Forms ToolStripMenuItem
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[System.Windows.Forms.ToolStripMenuItem]$MenuColumn,
		[string]$Title,
		[string]$Image,
		[string]$ShortCutKeys
	)
	
	$MenuRow = New-Object System.Windows.Forms.ToolStripMenuItem
	if ($Image -ne ""){
		if ((Get-SubString $Image 0 2) -eq 'ht') {
			$MenuRow.Image = Get-ImageFromStream $Image
		}
		else{
			$MenuRow.Image = Get-ImageFromFile $Image
		}
	}
	if ($ShortCutKeys -ne ""){
		$MenuRow.ShortCutKeys = $ShortCutKeys
		$MenuRow.ShowShortCutKeys = $True
	}
	$MenuRow.Name = $Title
	$MenuRow.Text = $Title
	$MenuColumn.DropDownItems.Add($MenuRow) | Out-Null
	return $MenuRow
}

function Add-MenuColumnSeperator {
<#
	.SYNOPSIS
		Adds a seperator in the rows of a menu column.
		
    .DESCRIPTION
		This function will add a seperator in the rows of a menu column.
	
	.PARAMETER MenuColumn
		The MenuColumn to add a seperator to.
	
	.EXAMPLE
		$Sep1 = Add-MenuColumnSeperator $FileMenu
	
	.EXAMPLE
		$Sep1 = Add-MenuColumnSeperator -MenuColumn $FileMenu
	
	.EXAMPLE
		$Sep1 = $FileMenu | Add-MenuColumnSeperator

	.INPUTS
		MenuColumn as System Windows Forms MenuStripItem

	.OUTPUTS
		System.Windows.Forms.ToolStripSeparator
#>
		[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[System.Windows.Forms.ToolStripMenuItem]$MenuColumn
		
	)
	$item = new-object System.Windows.Forms.ToolStripSeparator
	$MenuColumn.DropDownItems.Add($item) | Out-Null
}

function Add-ContextMenuStripSeperator {
<#
	.SYNOPSIS
		Adds a seperator in the rows of a context menu strip.
		
    .DESCRIPTION
		This function will add a seperator in the rows of a context menu strip.
	
	.PARAMETER ContextMenuStrip
		The ContextMenuStrip to add a seperator to.
	
	.EXAMPLE
		$Sep1 = Add-ContextMenuStripSeperator $TaskIcon1ContextMenu
	
	.EXAMPLE
		$Sep1 = Add-ContextMenuStripSeperator -ContextMenuStrip $TaskIcon1ContextMenu
	
	.EXAMPLE
		$Sep1 = $TaskIcon1ContextMenu | Add-ContextMenuStripSeperator

	.INPUTS
		ContextMenuStrip as System.Windows.Forms.ContextMenuStrip

	.OUTPUTS
		System.Windows.Forms.ToolStripSeparator
#>
		[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[System.Windows.Forms.ContextMenuStrip]$ContextMenuStrip
	)
	$item = new-object System.Windows.Forms.ToolStripSeparator
	$ContextMenuStrip.Items.Add($item) | Out-Null
}

function Add-ToolStripSeperator {
<#
	.SYNOPSIS
		Adds a seperator in the items of a tool strip.
		
    .DESCRIPTION
		This function will add a seperator in the items of a tool strip.
	
	.PARAMETER ToolStrip
		The ToolStrip to add a seperator to.
	
	.EXAMPLE
		$Sep1 = Add-ContextMenuStripSeperator $TaskIcon1ContextMenu
	
	.EXAMPLE
		$Sep1 = Add-ContextMenuStripSeperator -ContextMenuStrip $TaskIcon1ContextMenu
	
	.EXAMPLE
		$Sep1 = $TaskIcon1ContextMenu | Add-ContextMenuStripSeperator

	.INPUTS
		ContextMenuStrip as System.Windows.Forms.ContextMenuStrip

	.OUTPUTS
		System.Windows.Forms.ToolStripSeparator
#>
		[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[System.Windows.Forms.ToolStrip]$ToolStrip
	)
	$item = new-object System.Windows.Forms.ToolStripSeparator
	$ToolStrip.Items.Add($item) | Out-Null
}


function New-Taskicon {
<#
	.SYNOPSIS
		This function creates a TaskIcon in the TaskTray.
		
    .DESCRIPTION
		This function will create a taskicon in the system tasktray.
	
	.PARAMETER Icon
		The file path of the icon
	
	.PARAMETER Text
		The mouseover text of the tasktray icon.
		
	.PARAMETER BalloonTipText
		The main body of the Balloon.

	.PARAMETER BalloonTipTitle
		The title of the Balloon.

	.EXAMPLE
		$TaskIcon1 = New-Taskicon "c:\images\res.ico"
	
	.EXAMPLE
		$TaskIcon1 = New-Taskicon -Icon "c:\images\res.ico" -Text "Resource TaskIcon"
	
	.EXAMPLE
		$TaskIcon1 = New-Taskicon -Icon "c:\images\res.ico" -Text "Resource TaskIcon" -BalloonTipTitle "Resources" -BalloonTipText "Here you will find the resources you need"

	.EXAMPLE
		$TaskIcon1 = "c:\images\res.ico" | New-Taskicon -Text "Resource TaskIcon" -BalloonTipTitle "Resources" -BalloonTipText "Here you will find the resources you need"
		
	.INPUTS
		Icon as String, Text as String, BallonTipText as String, BalloonTipTitle as String

	.OUTPUTS
		System Windows Forms Taskicon
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Icon,
		[string]$Text,
		[string]$BalloonTipText,
		[string]$BalloonTipTitle
	)	
	$taskicon = New-Object System.Windows.Forms.NotifyIcon
	$taskicon.Text = $Text
	$taskicon.Icon = $Icon
	$taskicon.BalloonTipText = $BalloonTipText
	$taskicon.BalloonTipTitle = $BalloonTipTitle
	return $taskicon
}

function Add-ToolStrip {
<#
	.SYNOPSIS
		Adds a ToolStrip to an existing Form.
		
    .DESCRIPTION
		This function adds a ToolStrip to an existing Form.
	
	.PARAMETER Form
		The Form to add the ToolStrip to.
	
	.EXAMPLE
		$ToolStrip1 = Add-ToolStrip $Form1
	
	.EXAMPLE
		$ToolStrip1 = Add-ToolStrip -Form $Form1

	.EXAMPLE
		$ToolStrip1 = $Form1 | Add-ToolStrip
		
	.INPUTS
		Form as Object

	.OUTPUTS
		System Windows Forms ToolStrip
#>
		[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Form
	)
	$ToolStrip = New-Object System.Windows.Forms.ToolStrip
	$ToolStrip.imagescalingsize = new-object System.Drawing.Size([int]($ctscale * 16),[int]($ctscale * 16))
	$ToolStrip.Height = $ToolStrip.Height * $ctscale
	$Form.Controls.Add($ToolStrip)
	return $ToolStrip
}

function Add-ToolStripItem {
<#
	.SYNOPSIS
		Adds a ToolStripItem to an existing ToolStrip.
		
    .DESCRIPTION
		This function adds a ToolStripItem to an existing ToolStrip.
	
	.PARAMETER Form
		The Form to add the ToolStrip to.
	
	.EXAMPLE
		$ToolStripItem1 = Add-ToolStripItem 
	
	.EXAMPLE
		$ToolStrip1 = Add-ToolStrip -Form $Form1

	.EXAMPLE
		$ToolStrip1 = $Form1 | Add-ToolStrip
		
	.INPUTS
		ToolStrip as System.Windows.Forms.ToolStrip, Name as String, Image as String, ToolTipText as String, VisibleText as String

	.NOTES
		This function does not return an output because after a ToolStripButton
		is initialized it must be referenced by name or index by the parent 
		ToolStrip object, this is why Name is required. If it where to be 
		returned from this function it would have to be as global, which is 
		outside of style. This is a problem with non-standard behavior of the 
		ToolStrip object and would need fixed by the Microsoft.NET team.
		.Example
			$ToolStrip1.Items["Undo"].Add_Click({Write-Host "Process Undo"})
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[System.Windows.Forms.ToolStrip]$ToolStrip,
		[Parameter(Mandatory)]
		[string]$Name,
		[string]$Image,
		[string]$ToolTipText,
		[string]$VisibleText
	)
    $btn = new-object System.Windows.Forms.ToolStripButton
	$btn.text = $VisibleText
	$btn.Name = $Name
	if ((Get-Substring $Image 0 2) -eq 'ht') {
		$btn.image = Get-ImageFromStream $Image
    }
	else {
    $btn.image = Get-ImageFromFile $Image
    }
	$btn.ToolTipText = $ToolTipText
	$ToolStrip.Items.Add($btn)
}

function Set-ObjectPosition {
<#
	.SYNOPSIS
		Properly sets the position of a DPIAware object created with this module.
		
    .DESCRIPTION
		This function properly sets the position of a DPIAware object created with this module.
	
	.PARAMETER Object
		The Object to position
	
	.PARAMETER Top
		The Top postion to set the object to.
	
	.PARAMETER LEFT
		The Left postion to set the object to.
		
	.PARAMETER Width
		The Width to set the object to.
	
	.PARAMETER Height
		The Height to set the object to.
	
	.EXAMPLE
		Set-ObjectPosition $Form1 12 12 800 640
	
	.EXAMPLE
		Set-ObjectPosition -Object $Form1 -Top 12 -Left 12 -Width 800 -Height 640

	.EXAMPLE
		$Form1 | Set-ObjectPosition -Top 12 -Left 12 -Width 800 -Height 640
		
	.INPUTS
		Object as Object, Top as Int, Left as Int, Width as Int, Height as Int

	.NOTES
		If you directly modify a position properly of a DPIAware object you 
		will mistake by a factor of the current system scale. This function 
		allows you to reposition DPIAware objects properly.
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[Object]$Object,
		[int]$Top,
		[int]$Left,
		[int]$Width,
		[int]$Height
	)
	$Object.Top = $Top * $ctscale
	$Object.Left = $Left * $ctscale
	$Object.Width = $Width * $ctscale
	$Object.Height = $Height * $ctscale
}

function Get-ObjectPosition {
<#
	.SYNOPSIS
		Returns the position of an object specified
		
    .DESCRIPTION
		This function will return the top, left, width and height properties of
		an object as the same properties in a custom object.
	
	.PARAMETER Object
		The object to get the dimensions of
	
	.EXAMPLE
		$position = Get-ObjectPosition $Button1
	
	.EXAMPLE
		$position = Get-ObjectPosition -Object $Button1

	.EXAMPLE
		$position = $Button1 | Get-ObjectPosition

	.INPUTS
		Object as Object
	
	.OUTPUTS
		Object
#>

		[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Object
	)
	$Position = [PSCustomObject] | Select-Object -Property Top, Left, Width, Height
	$Position.Top = $Object.Top / $ctscale
	$Position.Left = $Object.Left / $ctscale
	$Position.Width = $Object.Width / $ctscale
	$Position.Height = $Object.Width / $ctscale
	return $Position
}

function Get-Focus {
<#
    .SYNOPSIS
		Returns the control that has focus on a given form.
			 
	.DESCRIPTION
		This function returns the control that has focus on a given form.
	 
	.PARAMETER Form
		The form to get the activecontrol from.
	
	.EXAMPLE
		$Focus = Get-Focus $Form1
	
	.EXAMPLE
		$Focus = Get-Focus -Form $Form1
	
	.EXAMPLE
		$Focus = $Form1 | Get-Focus
	
	.INPUTS
		Form as object
	
	.Outputs
		Active Control
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Form
    )
	return $Form.ActiveControl
}

function Set-Focus {
<#
    .SYNOPSIS
		Sets the focus of a form to a control
			 
	.DESCRIPTION
		This function Sets the focus of a form to a control
	 
	.PARAMETER Form
		The form to set the control focus
		
	.PARAMETER Control
		The control to set the focus to on the form
	
	.EXAMPLE
		Set-Focus $Form1 $Button1
	
	.EXAMPLE
		Set-Focus -Form $Form1 -Control $Button1
	
	.EXAMPLE
		$Form1 | Set-Focus -Control $Button1
	
	.INPUTS
		Form as Object, Control as Object
	
	.OUTPUTS
		Object
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Form,
		[Parameter(Mandatory)]
		[Object]$Control
    )
	$Form.ActiveControl = $Control
}

function Set-Hotkey {
<#
    .SYNOPSIS
		Registers a global hotkey to a form.
			 
	.DESCRIPTION
		This function registers a hotkey to a form of type vdsForm
	 
	.PARAMETER Form
		The form to register the hotkey to.
		
	.EXAMPLE
		Set-Hotkey $Form1 1 ((Get-VirtualKey Alt)+(Get-VirtualKey Control)) (Get-VirtualKey v)
		function hotkeyEvent {
			[CmdletBinding()]
			param (
				[Parameter(Mandatory)]
				[string]$Event
			)
			switch ($Event) {
				'1' {
					#Process event here
				}
			}
		}
	
	.EXAMPLE
		Set-Hotkey -form $Form1 -registerindex 1 -ModifierVirtualKeys $null -VirtualKey (Get-VirtualKey F1)
		function hotkeyEvent {
			[CmdletBinding()]
			param (
				[Parameter(Mandatory)]
				[string]$Event
			)
			switch ($Event) {
				'1' {
					#Process event here
				}
			}
		}
		
	.EXAMPLE
		$Form1 | Set-Hotkey -registerindex 1 -ModifierVirtualKeys $null -VirtualKey (Get-VirtualKey F1)
		function hotkeyEvent {
			[CmdletBinding()]
			param (
				[Parameter(Mandatory)]
				[string]$Event
			)
			switch ($Event) {
				'1' {
					#Process event here
				}
			}
		}
		
	.INPUTS
		Form as vdsForm, RegisterIndex as Integer, 
		ModifierVirtualKeys[] as Hexidecimal, 
		VirtualKey as Hexidecimal
	
	.OUTPUTS
		Registered Event
	
	.NOTES
		The use of this function REQUIRES the event to be caught by the 
		hotkeyEvent function which processes the event by hotkey index.
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [vdsForm]$Form,
		[Parameter(Mandatory)]
        [int]$RegisterIndex,
		[Parameter(Mandatory)]
		[string]$ModifierVirtualKeys,
		[Parameter(Mandatory)]
		[string]$VirtualKey
	)
	[vdsForm]::RegisterHotKey($Form.handle,$RegisterIndex,$ModifierVirtualKeys,$VirtualKey) | out-null
	if ($global:hotkeyobject -ne $true) {
		$hotkey = Add-CommonControl -Form $Form -ControlType 'label' -top 0 -left 0 -width 0 -height 0
		$hotkey.Name = 'hotkey'
		$hotkey.add_TextChanged({
			if ($this.text -ne ""){
				hotkeyEvent $this.text
			}
			$this.text = ""
		})
		$global:hotkeyobject = $true
	}
}

function Get-VirtualKey {
<#
    .SYNOPSIS
		Returns a virtual key
     
    .DESCRIPTION
		This function returns a virtual key
	
	.PARAMETER VirtualKey
		The virtual key to return, must be a member of the following set:
		'None', 'Alt', 'Control', 'Shift', 'WinKey', 'LBUTTON', 
		'RBUTTON', 'CANCEL', 'MBUTTON', 'XBUTTON1', 'XBUTTON2', 'BACK', 'TAB',
		'CLEAR', 'RETURN', 'SHIFT', 'CONTROL', 'MENU', 'PAUSE', 'CAPITAL', 
		'KANA', 'HANGUEL', 'HANGUL', 'IME_ON', 'JUNJA', 'FINAL', 'HANJA', 
		'KANJI', 'IME_OFF', 'ESCAPE', 'CONVERT', 'NONCONVERT', 'ACCEPT', 
		'MODECHANGE', 'SPACE', 'PRIOR', 'NEXT', 'END', 'HOME', 'LEFT', 'UP',
		'RIGHT', 'DOWN', 'SELECT', 'PRINT', 'EXECUTE', 'SNAPSHOT', 'INSERT',
		'DELETE', 'HELP', '0', '1', '3', '4', '6', '7', '8', '9', 'A', 'B', 
		'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 
		'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'LWIN', 'RWIN', 
		'APPS', 'SLEEP', 'NUMPAD0', 'NUMPAD1', 'NUMPAD2', 'NUMPAD3', 'NUMPAD4',
		'NUMPAD5', 'NUMPAD6', 'NUMPAD7', 'NUMPAD8', 'NUMPAD9', 'MULTIPLY', 
		'ADD', 'SEPARATOR', 'SUBTRACT', 'DECIMAL', 'DIVIDE', 'F1', 'F2', 'F3', 
		'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'F13', 'F14', 
		'F15', 'F16', 'F17', 'F18', 'F19', 'F20', 'F21', 'F22', 'F23', 'F24', 
		'NUMLOCK', 'SCROLL', 'LSHIFT', 'RSHIFT', 'LCONTROL', 'RCONTROL', 
		'LMENU', 'RMENU', 'BROWSER_BACK', 'BROWSER_FORWARD', 'BROWSER_REFRESH', 
		'BROWSER_STOP', 'BROWSER_SEARCH', 'BROWSER_FAVORITES', 'BROWSER_HOME', 
		'VOLUME_MUTE', 'VOLUME_DOWN', 'VOLUME_UP', 'MEDIA_NEXT_TRACK', 
		'MEDIA_PREV_TRACK', 'MEDIA_STOP', 'MEDIA_PLAY_PAUSE', 'LAUNCH_MAIL', 
		'LAUNCH_MEDIA_SELECT', 'LAUNCH_APP1', 'LAUNCH_APP2', 'OEM_1', 
		'OEM_PLUS', 'OEM_COMMA', 'OEM_MINUS', 'OEM_PERIOD', 'OEM_2', 'OEM_3', 
		'OEM_4', 'OEM_5', 'OEM_6', 'OEM_7', 'OEM_8', 'OEM_102', 'PROCESSKEY', 
		'PACKET', 'ATTN', 'CRSEL', 'EXSEL', 'EREOF', 'PLAY', 'ZOOM', 'NONAME', 
		'PA1', 'OEM_CLEAR'
		
	.EXAMPLE
		$vkeyF16 = Get-VirtualKey F16
	
	.EXAMPLE
		$vkeyF16 = Get-VirtualKey -VirtualKey 'F16'
		
	.EXAMPLE
		$vkeyF16 = 'F16' | Get-VirtualKey
	
	.INPUTS
		VirtualKey as String
	
	.OUTPUTS
		Hex
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
		[ValidateSet('None', 'Alt', 'Control', 'Shift', 'WinKey', 'LBUTTON', 
		'RBUTTON', 'CANCEL', 'MBUTTON', 'XBUTTON1', 'XBUTTON2', 'BACK', 'TAB',
		'CLEAR', 'RETURN', 'SHIFT', 'CONTROL', 'MENU', 'PAUSE', 'CAPITAL', 
		'KANA', 'HANGUEL', 'HANGUL', 'IME_ON', 'JUNJA', 'FINAL', 'HANJA', 
		'KANJI', 'IME_OFF', 'ESCAPE', 'CONVERT', 'NONCONVERT', 'ACCEPT', 
		'MODECHANGE', 'SPACE', 'PRIOR', 'NEXT', 'END', 'HOME', 'LEFT', 'UP',
		'RIGHT', 'DOWN', 'SELECT', 'PRINT', 'EXECUTE', 'SNAPSHOT', 'INSERT',
		'DELETE', 'HELP', '0', '1', '3', '4', '6', '7', '8', '9', 'A', 'B', 
		'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 
		'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'LWIN', 'RWIN', 
		'APPS', 'SLEEP', 'NUMPAD0', 'NUMPAD1', 'NUMPAD2', 'NUMPAD3', 'NUMPAD4',
		'NUMPAD5', 'NUMPAD6', 'NUMPAD7', 'NUMPAD8', 'NUMPAD9', 'MULTIPLY', 
		'ADD', 'SEPARATOR', 'SUBTRACT', 'DECIMAL', 'DIVIDE', 'F1', 'F2', 'F3', 
		'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'F13', 'F14', 
		'F15', 'F16', 'F17', 'F18', 'F19', 'F20', 'F21', 'F22', 'F23', 'F24', 
		'NUMLOCK', 'SCROLL', 'LSHIFT', 'RSHIFT', 'LCONTROL', 'RCONTROL', 
		'LMENU', 'RMENU', 'BROWSER_BACK', 'BROWSER_FORWARD', 'BROWSER_REFRESH', 
		'BROWSER_STOP', 'BROWSER_SEARCH', 'BROWSER_FAVORITES', 'BROWSER_HOME', 
		'VOLUME_MUTE', 'VOLUME_DOWN', 'VOLUME_UP', 'MEDIA_NEXT_TRACK', 
		'MEDIA_PREV_TRACK', 'MEDIA_STOP', 'MEDIA_PLAY_PAUSE', 'LAUNCH_MAIL', 
		'LAUNCH_MEDIA_SELECT', 'LAUNCH_APP1', 'LAUNCH_APP2', 'OEM_1', 
		'OEM_PLUS', 'OEM_COMMA', 'OEM_MINUS', 'OEM_PERIOD', 'OEM_2', 'OEM_3', 
		'OEM_4', 'OEM_5', 'OEM_6', 'OEM_7', 'OEM_8', 'OEM_102', 'PROCESSKEY', 
		'PACKET', 'ATTN', 'CRSEL', 'EXSEL', 'EREOF', 'PLAY', 'ZOOM', 'NONAME', 
		'PA1', 'OEM_CLEAR')]
		[string[]]$VirtualKey
    )
    switch($VirtualKey) {
        None{return 0}
        Alt{return 1}
        Control{return 2}
        Shift{return 4}
        WinKey{return 8}
        LBUTTON{return 0x01}
        RBUTTON{return 0x02}
        CANCEL{return 0x03}
        MBUTTON{return 0x04}
        XBUTTON1{return 0x05}
        XBUTTON2{return 0x06}
        BACK{return 0x08}
        TAB{return 0x09}
        CLEAR{return 0x0C}
        RETURN{return 0x0D}
        SHIFT{return 0x10}
        CONTROL{return 0x11}
        MENU{return 0x12}
        PAUSE{return 0x13}
        CAPITAL{return 0x14}
        KANA{return 0x15}
        HANGUEL{return 0x15}
        HANGUL{return 0x15}
        IME_ON{return 0x16}
        JUNJA{return 0x17}
        FINAL{return 0x18}
        HANJA{return 0x19}
        KANJI{return 0x19}
        IME_OFF{return 0x1A}
        ESCAPE{return 0x1B}
        CONVERT{return 0x1C}
        NONCONVERT{return 0x1D}
        ACCEPT{return 0x1E}
        MODECHANGE{return 0x1F}
        SPACE{return 0x20}
        PRIOR{return 0x21}
        NEXT{return 0x22}
        END{return 0x23}
        HOME{return 0x24}
        LEFT{return 0x25}
        UP{return 0x26}
        RIGHT{return 0x27}
        DOWN{return 0x28}
        SELECT{return 0x29}
        PRINT{return 0x2A}
        EXECUTE{return 0x2B}
        SNAPSHOT{return 0x2C}
        INSERT{return 0x2D}
        DELETE{return 0x2E}
        HELP{return 0x2F}
        0{return 0x31}
        1{return 0x32}
        3{return 0x34}
        4{return 0x35}
        6{return 0x36}
        7{return 0x37}
        8{return 0x38}
        9{return 0x39}
        A{return 0x41}
        B{return 0x42}
        C{return 0x43}
        D{return 0x44}
        E{return 0x45}
        F{return 0x46}
        G{return 0x47}
        H{return 0x48}
        I{return 0x49}
        J{return 0x4A}
        K{return 0x4B}
        L{return 0x4C}
        M{return 0x4D}
        N{return 0x4E}
        O{return 0x4F}
        P{return 0x50}
        Q{return 0x51}
        R{return 0x52}
        S{return 0x53}
        T{return 0x54}
        U{return 0x55}
        V{return 0x56}
        W{return 0x57}
        X{return 0x58}
        Y{return 0x59}
        Z{return 0x5A}
        LWIN{return 0x5B}
        RWIN{return 0x5C}
        APPS{return 0x5D}
        SLEEP{return 0x5F}
        NUMPAD0{return 0x60}
        NUMPAD1{return 0x61}
        NUMPAD2{return 0x62}
        NUMPAD3{return 0x63}
        NUMPAD4{return 0x64}
        NUMPAD5{return 0x65}
        NUMPAD6{return 0x66}
        NUMPAD7{return 0x67}
        NUMPAD8{return 0x68}
        NUMPAD9{return 0x69}
        MULTIPLY{return 0x6A}
        ADD{return 0x6B}
        SEPARATOR{return 0x6C}
        SUBTRACT{return 0x6D}
        DECIMAL{return 0x6E}
        DIVIDE{return 0x6F}
        F1{return 0x70}
        F2{return 0x71}
        F3{return 0x72}
        F4{return 0x73}
        F5{return 0x74}
        F6{return 0x75}
        F7{return 0x76}
        F8{return 0x77}
        F9{return 0x78}
        F10{return 0x79}
        F11{return 0x7A}
        F12{return 0x7B}
        F13{return 0x7C}
        F14{return 0x7D}
        F15{return 0x7E}
        F16{return 0x7F}
        F17{return 0x80}
        F18{return 0x81}
        F19{return 0x82}
        F20{return 0x83}
        F21{return 0x84}
        F22{return 0x85}
        F23{return 0x86}
        F24{return 0x87}
        NUMLOCK{return 0x90}
        SCROLL{return 0x91}
        LSHIFT{return 0xA0}
        RSHIFT{return 0xA1}
        LCONTROL{return 0xA2}
        RCONTROL{return 0xA3}
        LMENU{return 0xA4}
        RMENU{return 0xA5}
        BROWSER_BACK{return 0xA6}
        BROWSER_FORWARD{return 0xA7}
        BROWSER_REFRESH{return 0xA8}
        BROWSER_STOP{return 0xA9}
        BROWSER_SEARCH{return 0xAA}
        BROWSER_FAVORITES{return 0xAB}
        BROWSER_HOME{return 0xAC}
        VOLUME_MUTE{return 0xAD}
        VOLUME_DOWN{return 0xAE}
        VOLUME_UP{return 0xAF}
        MEDIA_NEXT_TRACK{return 0xB0}
        MEDIA_PREV_TRACK{return 0xB1}
        MEDIA_STOP{return 0xB2}
        MEDIA_PLAY_PAUSE{return 0xB3}
        LAUNCH_MAIL{return 0xB4}
        LAUNCH_MEDIA_SELECT{return 0xB5}
        LAUNCH_APP1{return 0xB6}
        LAUNCH_APP2{return 0xB7}
        OEM_1{return 0xBA}
        OEM_PLUS{return 0xBB}
        OEM_COMMA{return 0xBC}
        OEM_MINUS{return 0xBD}
        OEM_PERIOD{return 0xBE}
        OEM_2{return 0xBF}
        OEM_3{return 0xC0}
        OEM_4{return 0xDB}
        OEM_5{return 0xDC}
        OEM_6{return 0xDD}
        OEM_7{return 0xDE}
        OEM_8{return 0xDF}
        OEM_102{return 0xE2}
        PROCESSKEY{return 0xE5}
        PACKET{return 0xE7}
        ATTN{return 0xF6}
        CRSEL{return 0xF7}
        EXSEL{return 0xF8}
        EREOF{return 0xF9}
        PLAY{return 0xFA}
        ZOOM{return 0xFB}
        NONAME{return 0xFC}
        PA1{return 0xFD}
        OEM_CLEAR{return 0xFE}
    }
}

function Send-KeyPress {
<#
    .SYNOPSIS
		Holds down a specified virtual key
			 
	.DESCRIPTION
		This function returns an object with Left, Top, Width and Height properties of a windows position according to a handle specified

	.PARAMETER vKey
		The virtual key to hold down
	
	.PARAMETER Seconds
		Seconds to hold the key, as decimal

	.EXAMPLE
		Send-KeyPress (Get-VirtualKey "w") 5.5

	.EXAMPLE
		Send-KeyPress -vKey (Get-VirtualKey "w") -seconds 5.5
		
	.INPUTS
		vKey as Hex, Seconds as Decimal	
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $vKey,
		[Parameter(Mandatory)]
		[decimal]$Seconds
	)
	[vds]::keybd_event($vKey,0,0,[UIntPtr]::new(0))
	Start-Sleep ($Seconds * 1000)
	[vds]::keybd_event($vKey,0,2,[UIntPtr]::new(0))
}

function New-SendMessage {
<#
    .SYNOPSIS
		Sends a message to a window object using sendmessage API
			 
	.DESCRIPTION
		This function sends a message to a window object using sendmessage API
	
	.PARAMETER hWnd
		The identifier of the window object
		
	.PARAMETER Msg
		The message to be sent, usually in hex
		
	.PARAMETER wParam
		Additonal message specific information
		
	.PARAMETER lParam
		Additonal message specific information
		
	.EXAMPLE
		$currentrow = (New-SendMessage -hWnd $RichEdit.hWnd -Msg 0x00c1 -wParam $RichEdit.SelectionStart -lParam 0)
		
	.INPUTS
		hWnd as HWND, Msg as UINT, wParam as WPARAM, lParam as LPARAM
		
	.NOTES
		A powerful magic, from an ancient time.
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		$hWnd,
		[Parameter(Mandatory)]
		$Msg,
		[Parameter(Mandatory)]
		$wParam,	
		[Parameter(Mandatory)]
		$lParam
	)
	[vds]::SendMessage($hWnd, $Msg, $wParam, $lParam)
}

function New-ShellVerb {
<#
    .SYNOPSIS
		Invokes a shell call by verb
			 
	.DESCRIPTION
		This function invokes a shell call by verb
	
	.PARAMETER Verb
		A valid verb for the file type.
		
	.PARAMETER Path
		The path of the file
		
	.EXAMPLE
		New-ShellVerb "&Print" c:\windows\win.ini
	
	.EXAMPLE
		New-ShellVerb -verb "&Print" -path c:\windows\win.ini
	
	.EXAMPLE
		"&Print" | New-ShellVerb -path c:\windows\win.ini
		
	.INPUTS
		Verb as String, Path as String

#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Verb,
		[string]$Path
	)
	$shell = new-object -com shell.application
	$f = $shell.NameSpace((Get-FilePath $Path))
	$file = $f.ParseName((Get-FileName $Path)+'.'+(Get-FileExtension $Path))
	$file.Verbs() | ForEach-Object {
		if($_.Name -eq $Verb) {
			$_.DoIt() 
		}
	}
}

function New-Folder {
<#
	.SYNOPSIS
		Creates a new folder at the path specified
		
    .DESCRIPTION
		This function with create a new folder at the path specified
	
	.PARAMETER Path
		The folder to create
	
	.EXAMPLE
		New-Folder 'c:\temp'
	
	.EXAMPLE
		New-Folder -path 'c:\temp'

	.EXAMPLE
		'c:\temp' | New-Folder

	.INPUTS
		Path as String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Path
	)
	New-Item -ItemType directory -Path $Path
}

function Remove-Folder {
<#
	.SYNOPSIS
		Removes a folder at the path specified
		
    .DESCRIPTION
		This function will remove a folder at the path specified
	
	.PARAMETER Path
		The folder to remove
	
	.EXAMPLE
		Remove-Folder 'c:\temp'
	
	.EXAMPLE
		Remove-Folder -path 'c:\temp'

	.EXAMPLE
		'c:\temp' | Remove-Folder

	.INPUTS
		Path as String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Path
	)
	Remove-Item -path $Path -recurse -force
}

function Rename-Folder {
<#
	.SYNOPSIS
		Renames a folder at the path specified
		
    .DESCRIPTION
		This function will rename a folder at the path specified
	
	.PARAMETER Path
		The folder to rename
	
	.PARAMETER NewName
		The new name of the folder
	
	.EXAMPLE
		Rename-Folder 'c:\temp' 'c:\pmet'
	
	.EXAMPLE
		Rename-Folder -path 'c:\temp' -newname 'c:\pmet'

	.EXAMPLE
		'c:\temp' | Rename-Folder -newname 'c:\pmet'

	.INPUTS
		Path as String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Path,
		[Parameter(Mandatory)]
		[string]$NewName
	)
	Rename-Item -path $Path -NewName $NewName
}

function Get-WindowsDirectory {
<#
    .SYNOPSIS
		Returns the windows directory
			 
	.DESCRIPTION
		This function returns the windows directory

	.EXAMPLE
		$windir = Get-WindowsDirectory
	
	.OUTPUTS
		String
#>

	return Get-EnvironmentVariable windir
}

function Get-SystemDirectory {
<#
    .SYNOPSIS
		Returns the system directory
			 
	.DESCRIPTION
		This function returns the system directory

	.EXAMPLE
		$windir = Get-SystemDirectory
	
	.OUTPUTS
		String
#>
	return [System.Environment]::SystemDirectory
}

function Get-EnvironmentVariable {
<#
	.SYNOPSIS
		Returns the environment variable specified
		
    .DESCRIPTION
		This function will return an environment variable
	
	.PARAMETER Variable
		The variable to return
	
	.EXAMPLE
		$windir = Get-EnvironmentVariable 'windir'
	
	.EXAMPLE
		$windir = Get-EnvironmentVariable -variable 'windir'

	.EXAMPLE
		$windir = 'windir' | Get-EnvironmentVariable

	.INPUTS
		Variable as String
	
	.OUTPUTS
		String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Variable
	)
    $loc = Get-Location | select -ExpandProperty Path
    Set-Location Env:
    $return = Get-ChildItem Env:$a | select -ExpandProperty Value
    Set-Location $loc
	return $return
}

function Get-ExitCode {
<#
	.SYNOPSIS
		Returns the last error exit code of an application called in session.
		
    .DESCRIPTION
		This function will return the last error exit code of an application
		called in session.
		
	.EXAMPLE
		$err = Notepad | Get-ExitCode
	
	.OUTPUTS
		Integer
#>
    return $LASTEXITCODE
}

function Set-ExitCode {
<#
	.SYNOPSIS
		Sets the application exit code
		
    .DESCRIPTION
		This function sets the application exit code
	
	.PARAMETER ExitCode
		The code to exit the application with
		
	.EXAMPLE
		Set-ExitCode 32
	
	.EXAMPLE
		Set-ExitCode -exitcode 32
		
	.EXAMPLE
		32 | Set-ExitCode
		
	.INPUTS
		ExitCode as Integer
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$ExitCode
	)	
	exit $ExitCode
}

function Get-Event {
<#
	.SYNOPSIS
		Returns the last event in the call stack.
		     
    .DESCRIPTION
		This function returns the last event in the call stack.
		
	.EXAMPLE
		$event = Get-Event
	
	.OUTPUTS
		string
#>
    return (Get-PSCallStack)[1].Command
}
function Get-OK {
<#
    .SYNOPSIS
		Returns if the previous command was successful.
			 
	.DESCRIPTION
		This function returns if the previous command was successful.

	.EXAMPLE
		$ok = Get-OK
	
	.OUTPUTS
		Boolean
#>
    return $?
}

function Initialize-Excel {
<#
	.SYNOPSIS
		Returns an Excel object.
		     
    .DESCRIPTION
		This function returns an Excel object.
		
	.EXAMPLE
		$ExcelObject = Initialize-Excel
	
	.OUTPUTS
		Excel.Application
#>
	
	return new-object -comobject Excel.Application
}

function Show-Excel {
<#
	.SYNOPSIS
		Shows an initialized excel application object
		
    .DESCRIPTION
		This function will show an initialized excel application object
	
	.PARAMETER Excel
		The initialized excel object to show
	
	.EXAMPLE
		Show-Excel $Excel
	
	.EXAMPLE
		Show-Excel -Excel $Excel

	.EXAMPLE
		$Excel | Show-Excel

	.INPUTS
		$Excel as Excel.Application
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Excel
	)
	$Excel.visible = $true
}

function Hide-Excel {
<#
	.SYNOPSIS
		Hides an initialized excel application object
		
    .DESCRIPTION
		This function will hide an initialized excel application object
	
	.PARAMETER Excel
		The initialized excel object to hide
	
	.EXAMPLE
		Hide-Excel $Excel
	
	.EXAMPLE
		Hide-Excel -Excel $Excel

	.EXAMPLE
		$Excel | Hide-Excel

	.INPUTS
		$Excel as Excel.Application
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Excel
	)
	$Excel.visible = $false
}

function Add-ExcelWorkbook {
<#
	.SYNOPSIS
		Adds a new excel workbook to a initialized excel object.
		
    .DESCRIPTION
		This function will add a excel workbook to a initialized excel object.
	
	.PARAMETER Excel
		The initialized excel object to add a workbook to.
	
	.EXAMPLE
		$Workbook = Add-ExcelWorkbook $ExcelObject
	
	.EXAMPLE
		$Workbook = Add-ExcelWorkbook -Excel $ExcelObject

	.EXAMPLE
		$Workbook = $ExcelObject | Add-ExcelWorkbook

	.INPUTS
		$Excel as Excel.Application
	
	.OUTPUTS
		Excel.Application.Workbook
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Excel
	)
	return $Excel.Workbooks.add()
}

function Add-ExcelWorksheet {
<#
	.SYNOPSIS
		Adds a new excel worksheet to an excel workbook
		
    .DESCRIPTION
		This function will add a excel worksheet to a excel workbook
	
	.PARAMETER Workbook
		The workbook to add a worksheet to
	
	.EXAMPLE
		$Worksheet = Add-ExcelWorksheet $Workbook
	
	.EXAMPLE
		$Worksheet = Add-ExcelWorksheet -workbook $Workbook

	.EXAMPLE
		$Worksheet = $Workbook | Add-ExcelWorksheet

	.INPUTS
		$Excel as Excel.Application.Workbook
	
	.OUTPUTS
		Excel.Application.Workbook.Worksheet
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Workbook
	)
	return $Workbook.Worksheets.Add()
}

function Open-ExcelWorkbook {
<#
	.SYNOPSIS
		Has a initialized excel object open a workbook at a specified path.
		
    .DESCRIPTION
		This function has a initialized excel object open a workbook at a specified path.
	
	.PARAMETER Excel
		The initialized excel object
	
	.PARAMETER Path
		The path of the workbook to open
	
	.EXAMPLE
		$Workbook = Add-ExcelWorkbook $ExcelObject
	
	.EXAMPLE
		$Workbook = Add-ExcelWorkbook -Excel $ExcelObject

	.EXAMPLE
		$Workbook = $ExcelObject | Add-ExcelWorkbook

	.INPUTS
		$Excel as Excel.Application
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Excel,
		[Parameter(Mandatory)]
		[string]$Path
	)
	$Excel.Workbooks.Open($Path)
}

function Save-ExcelWorkbook {
<#
	.SYNOPSIS
		Saves an open workbook
		
    .DESCRIPTION
		This function has saves an open workbook
	
	.PARAMETER Workbook
		The workbook object
		
	.PARAMETER Path
		The path of the workbook file
	
	.EXAMPLE
		Save-ExcelWorkbook $Workbook
		
	.EXAMPLE
		Save-ExcelWorkbook $Workbook "c:\temp\temp.xlsx"
	
	.EXAMPLE
		Save-ExcelWorkbook -workbook $Workbook

	.EXAMPLE
		Save-ExcelWorkbook -workbook $Workbook -path "c:\temp\temp.xlsx"

	.EXAMPLE
		$Workbook = $ExcelObject | Save-ExcelWorkbook
	
	.EXAMPLE
		$Workbook = $ExcelObject | Save-ExcelWorkbook -path "c:\temp\temp.xlsx"

	.INPUTS
		Workbook as Excel.Application.Workbook
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Excel,
		[string]$Path
	)
	if ($Path -eq "") {
		$Excel.Workbooks.Save()
	}
	else {
		$Excel.ActiveWorkbook.SaveAs($Path)
	}
}

function Select-ExcelSheet {
<#
	.SYNOPSIS
		Selects an excel sheet
		
    .DESCRIPTION
		This function selects an excel sheet
	
	.PARAMETER Excel
		The Excel object
		
	.PARAMETER Sheet
		The sheet to select
	
	.EXAMPLE
		Select-ExcelSheet $excel 'Sheet1'
		
	.EXAMPLE
		Select-ExcelSheet -excel $excel -sheet 'Sheet1'
	
	.EXAMPLE
		$excel | Select-ExcelSheet -sheet 'Sheet1'

	.INPUTS
		Excel as Object, Sheet as String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Excel,
		[Parameter(Mandatory)]
		[string]$Sheet
	)
	$Excel.Worksheets.Item($Sheet).Select()
}

function Set-ExcelCell {
<#
	.SYNOPSIS
		Sets an excel cell to a value specified
		
    .DESCRIPTION
		This function Sets an excel cell to a value specified from the provided row and column parameters
	
	.PARAMETER Excel
		The Excel object
		
	.PARAMETER Row
		The row by number to set to a value

	.PARAMETER Column
		The column by number to set to a value
		
	.PARAMETER Value
		The value to set the cell to
	
	.EXAMPLE
		Set-ExcelCell $excel 2 4 'Two-Four'
		
	.EXAMPLE
		Set-ExcelCell -excel $excel -row 2 -column 4 -value 'Two-Four'
		
	.EXAMPLE
		$excel | Set-ExcelCell -row 2 -column 4 -value 'Two-Four'

	.INPUTS
		Excel as Object, Row as Integer, Column as Integer, Value as Variant
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Excel,
		[Parameter(Mandatory)]
		[int]$Row,
		[Parameter(Mandatory)]
		[int]$Column,
		[Parameter(Mandatory)]
		$Value
	)
	$Excel.ActiveSheet.Cells.Item($Row,$Column) = $Value
}

function Get-ExcelCell {
<#
	.SYNOPSIS
		Gets an excel value
		
    .DESCRIPTION
		This function gets an excel value specified from the provided row and column parameters
	
	.PARAMETER Excel
		The Excel object
		
	.PARAMETER Row
		The row by number to get to a value

	.PARAMETER Column
		The column by number to get to a value
	
	.EXAMPLE
		$2x4 = Get-ExcelCell $excel 2 4
		
	.EXAMPLE
		$2x4 = Get-ExcelCell -excel $excel -row 2 -column 4
		
	.EXAMPLE
		$2x4 = $excel | Get-ExcelCell -row 2 -column 4

	.INPUTS
		Excel as Object, Row as Integer, Column as Integer
	
	.OUTPUTS
		Variant
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Excel,
		[Parameter(Mandatory)]
		[int]$Row,
		[Parameter(Mandatory)]
		[int]$Column
	)
	return $Excel.ActiveSheet.Cells.Item($Row,$Column).Value2
}

function Remove-ExcelColumn {
<#
	.SYNOPSIS
		Deletes an excel column
		
    .DESCRIPTION
		This function deletes an excel column
	
	.PARAMETER Excel
		The Excel object
		
	.PARAMETER Column
		The column by number
	
	.EXAMPLE
		Remove-ExcelColumn $excel 3
		
	.EXAMPLE
		Remove-ExcelColumn -excel $excel -column 3
		
	.EXAMPLE
		$excel | Remove-ExcelColumn -column 4

	.INPUTS
		Excel as Object, Column as Integer
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Excel,
		[Parameter(Mandatory)]
		[int]$Column
	)
	$Excel.ActiveSheet.Columns[$Column].Delete()
}

function Remove-ExcelRow {
<#
	.SYNOPSIS
		Deletes an excel row
		
    .DESCRIPTION
		This function deletes an excel row
	
	.PARAMETER Excel
		The Excel object
		
	.PARAMETER Row
		The row by number
	
	.EXAMPLE
		Remove-ExcelRow $excel 3
		
	.EXAMPLE
		Remove-ExcelRow -excel $excel -row 3
		
	.EXAMPLE
		$excel | Remove-ExcelRow -Row 3

	.INPUTS
		Excel as Object, Row as Integer
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Excel,
		[Parameter(Mandatory)]
		[int]$Row
	)
	$Excel.ActiveSheet.Rows[$Row].Delete()
}

function New-ExcelColumn {
<#
	.SYNOPSIS
		Inserts an excel column
		
    .DESCRIPTION
		This function inserts an excel column
	
	.PARAMETER Excel
		The Excel object
		
	.PARAMETER Column
		The column by number
	
	.EXAMPLE
		New-ExcelColumn $excel 3
		
	.EXAMPLE
		New-ExcelColumn -excel $excel -column 3
		
	.EXAMPLE
		$excel | New-ExcelColumn -column 4

	.INPUTS
		Excel as Object, Column as Integer
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Excel,
		[Parameter(Mandatory)]
		[int]$Column
	)
	$Excel.ActiveSheet.Columns[$Column].Insert()	
}

function New-ExcelRow {
<#
	.SYNOPSIS
		Inserts an excel row
		
    .DESCRIPTION
		This function inserts an excel row
	
	.PARAMETER Excel
		The Excel object
		
	.PARAMETER Row
		The row by number
	
	.EXAMPLE
		New-ExcelRow $excel 3
		
	.EXAMPLE
		New-ExcelRow -excel $excel -row 3
		
	.EXAMPLE
		$excel | New-ExcelRow -Row 4

	.INPUTS
		Excel as Object, Row as Integer
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Excel,
		[Parameter(Mandatory)]
		[int]$Row
	)
	$Excel.ActiveSheet.Rows[$Row].Insert()
}

function Get-ExcelColumnCount {
<#
	.SYNOPSIS
		Returns the column count
		
    .DESCRIPTION
		This function returns the column count
	
	.PARAMETER Excel
		The Excel object
	
	.EXAMPLE
		$columncount = Get-ExcelColumnCount $excel
		
	.EXAMPLE
		$columncount = Get-ExcelColumnCount -excel $excel
		
	.EXAMPLE
		$columncount = $excel | Get-ExcelColumnCount

	.INPUTS
		Excel as Object
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Excel
	)
	return $Excel.ActiveSheet.UsedRange.Columns.Count	
}

function Get-ExcelRowCount {
<#
	.SYNOPSIS
		Returns the row count
		
    .DESCRIPTION
		This function returns the row count
	
	.PARAMETER Excel
		The Excel object
	
	.EXAMPLE
		$rowcount = Get-ExcelRowCount $excel
		
	.EXAMPLE
		$rowcount = Get-ExcelRowCount -excel $excel
		
	.EXAMPLE
		$rowcount = $excel | Get-ExcelRowCount

	.INPUTS
		Excel as Object
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Excel
	)
	return $Excel.ActiveSheet.UsedRange.Rows.Count
}

function Get-FileName {
<#
    .SYNOPSIS
		Returns the name of the file from the full path
			 
	.DESCRIPTION
		This function returns the name of the file from the full path

	.PARAMETER Path
		The path to the file
	
	.EXAMPLE
		Get-FileName 'c:\temp\temp.txt'
		
	.EXAMPLE 
		Get-FileName -path 'c:\temp\temp.txt'

	.EXAMPLE
		'c:\temp\temp.txt' | Get-FileName
		
	.INPUTS
		Path as string
	
	.OUTPUTS
		String
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Path
	)
    return [io.path]::GetFileNameWithoutExtension($Path)
}

function Get-FilePath {
<#
    .SYNOPSIS
		This function returns the root folder of the file specified
			 
	.DESCRIPTION
		This function returns the root folder of the file specified

	.PARAMETER Path
		The path to the file
	
	.EXAMPLE
		Get-FilePath 'c:\windows\win.ini'
		
	.EXAMPLE 
		Get-FilePath -path 'c:\windows\win.ini'

	.EXAMPLE
		'c:\windows\win.ini' | Get-FilePath
		
	.INPUTS
		Path as String
	
	.OUTPUTS
		String
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Path
	)
    return Split-Path -Path $Path
}

function Get-FileExtension {
<#
	.SYNOPSIS
		Gets the extension of a file at the path specified.
		
    .DESCRIPTION
		This function will get the extension of a file at the path specified.
	
	.PARAMETER Path
		The path to the file to get the extension from
		
	.EXAMPLE
		$ext = Get-FileExtension 'c:\temp\text.txt'
	
	.EXAMPLE
		$ext = Get-FileExtension -Path 'c:\temp\text.txt'
		
	.EXAMPLE
		$ext = 'c:\temp\text.txt' | Get-FileExtension
		
	.INPUTS
		Path as String
	
	.OUTPUTS
		String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Path
	)
    $split = $Path.Split('.')
	if ($split.count -gt 1) {
		return $split[$split.count -1]
	}
}

function Get-FileShortname {
<#
    .SYNOPSIS
		Returns the shortname from a path
     
    .DESCRIPTION
		This function returns the 8.3 shortname from a path specified
	
	.PARAMETER Path
		The path of the file to return the shortname from
	
	.EXAMPLE
		$shortname = Get-FileShortname 'C:\Program Files\Common Files\Microsoft Shared\VS7Debug\vsjitdebuggerps.dll'
	
	.EXAMPLE
		$shortname = Get-FileShortname -file 'C:\Program Files\Common Files\Microsoft Shared\VS7Debug\vsjitdebuggerps.dll'
		
	.EXAMPLE
		$shortname = 'C:\Program Files\Common Files\Microsoft Shared\VS7Debug\vsjitdebuggerps.dll' | Get-FileShortname 
	
	.INPUTS
		Path as String
	
	.OUTPUTS
		String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Path
	)
	if ((Get-Item $Path).PSIsContainer -eq $true) {
        $SFSO = New-Object -ComObject Scripting.FileSystemObject
        $short = $SFSO.GetFolder($Path).ShortPath
    } 
    else {
        $SFSO = New-Object -ComObject Scripting.FileSystemObject
        $short = $SFSO.GetFile($Path).ShortPath
    }
    return $short

}

function Copy-File {
<#
	.SYNOPSIS
		Copies a file to a destination
		
    .DESCRIPTION
		This function copies a file to a destination
	
	.PARAMETER Path
		Path to copy the file from
		
	.PARAMETER Destination
		The destination to copy the file to
	
	.EXAMPLE
		Copy-File 'c:\temp\temp.txt' 'c:\temp\rename.txt'
	
	.EXAMPLE
		Copy-File -Path 'c:\temp\temp.txt' -Destination 'c:\temp\rename.txt'
	
	.EXAMPLE
		'c:\temp\temp.txt' | Copy-File -Destination 'c:\temp\rename.txt'
		
	.INPUTS
		Path as String, Destination as String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Path,
		[Parameter(Mandatory)]
		[string]$Destination
	)	
	copy-item -path $Path -destination $Destination -recurse
}

function Move-File {
<#
	.SYNOPSIS
		Moves a file to a destination
		
    .DESCRIPTION
		This function moves a file to a destination
	
	.PARAMETER Path
		Path to move the file from
		
	.PARAMETER Destination
		The destination to move the file to
	
	.EXAMPLE
		Move-File 'c:\temp\temp.txt' 'c:\temp\rename.txt'
	
	.EXAMPLE
		Move-File -Path 'c:\temp\temp.txt' -Destination 'c:\temp\rename.txt'
	
	.EXAMPLE
		'c:\temp\temp.txt' | Move-File -Destination 'c:\temp\rename.txt'
		
	.INPUTS
		Path as String, Destination as String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Path,
		[Parameter(Mandatory)]
		[string]$Destination
	)	
	Move-item -path $Path -destination $Destination 
}

function Remove-File {
<#
	.SYNOPSIS
		Removes a file at the path specified
		
    .DESCRIPTION
		This function removes a file at the path specified
	
	.PARAMETER Path
		The path to the file.
		
	.EXAMPLE
		Remove-File 'c:\temp\temp.txt'
	
	.EXAMPLE
		Remove-File -Path 'c:\temp\temp.txt'
	
	.EXAMPLE
		'c:\temp\temp.txt' | Remove-File
		
	.INPUTS
		Path as String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Path
	)	
	Remove-item -path $Path -force
}

function Rename-File {
<#
	.SYNOPSIS
		Renames a file
		
    .DESCRIPTION
		This function renames a file
	
	.PARAMETER Path
		The path to the file.
		
	.PARAMETER NewName
		The new name of the file.
		
	.EXAMPLE
		Rename-File 'c:\temp\temp.txt' 'c:\temp\newname.txt'
	
	.EXAMPLE
		Rename-File -Path 'c:\temp\temp.txt' -NewName 'c:\temp\newname.txt'
	
	.EXAMPLE
		'c:\temp\temp.txt' | Rename-File -NewName 'c:\temp\newname.txt'
		
	.INPUTS
		Path as String, NewName as String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Path,
		[Parameter(Mandatory)]
		[string]$NewName
	)
	Rename-Item -Path $Path -NewName $NewName
}

function Set-FileAttribute {
<#
	.SYNOPSIS
		Sets the attribute of a file
		
    .DESCRIPTION
		This function sets the attributes of a file
	
	.PARAMETER Path
		The path to the file.
		
	.PARAMETER Attribute
		The attribute to set (or unset)
		
	.PARAMETER Unset
		Switch that specifies to unset the attribute
	
	.EXAMPLE	
		Set-FileAttribute 'c:\temp\temp.txt' 'Hidden'

	.EXAMPLE	
		Set-FileAttribute 'c:\temp\temp.txt' 'Hidden' -unset
		
	.EXAMPLE
		Set-FileAttribute -Path 'c:\temp\temp.txt' -Attribute 'Hidden'
	
	.EXAMPLE
		Set-FileAttribute -Path 'c:\temp\temp.txt' -Attribute 'Hidden' -unset
	
	.EXAMPLE
		'c:\temp\temp.txt' | Set-FileAttribute -Attribute 'Hidden'
		
	.INPUTS
		Path as String, Attribute as ValidatedString, Unset as Switch
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Path,
		[Parameter(Mandatory)]
    	[ValidateSet('Archive', 'Compressed', 'Device', 'Directory',
		'Encrypted', 'Hidden', 'IntegrityStream', 'None', 'Normal', 
		'NoScrubData', 'NotContentIndexed', 'Offline', 'ReadOnly', 
		'ReparsePoint', 'SparseFile', 'System', 'Temporary')]
		[string[]]$Attribute,
		[switch]$Unset
	)
		
	if ($Unset) {
		$Path = (Get-ChildItem $Path -force)
		$Path.Attributes = $Path.Attributes -bxor ([System.IO.FileAttributes]$Attributes).value__	
	}
	else {
		$Path = (Get-ChildItem $Path -force)
		$Path.Attributes = $Path.Attributes -bor ([System.IO.FileAttributes]$Attributes).value__	
	}
}

function Test-File {
<#
	.SYNOPSIS
		Test for the existance of a file
		
    .DESCRIPTION
		This function test for the existance of a file
	
	.PARAMETER Path
		The path to the file.
	
	.EXAMPLE	
		$fileExists = Test-File 'c:\temp\temp.txt'

	.EXAMPLE	
		$fileExists = Test-File -Path 'c:\temp\temp.txt'
		
	.EXAMPLE	
		$fileExists = 'c:\temp\temp.txt' | Test-File
	
	.INPUTS
		Path as String
	
	.OUTPUTS
		Boolean
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Path
	)
	if (Test-Path -path $Path) {
		return $true
	}
	else {
		return $false
	}
}

function Show-HTMLHelp {
<#
    .SYNOPSIS
		Displays a page in a compiled html manual.
			 
	.DESCRIPTION
		This function displays a page in a compiled html manual.
	 
	.PARAMETER chm
		The string to send to the html help process.
		
	.EXAMPLE
		Show-HTMLHelp 'mk:@MSITStore:C:\Users\Brandon\Documents\textpad.chm::/Help/new.htm'

	.EXAMPLE
		Show-HTMLHelp -chm 'mk:@MSITStore:C:\Users\Brandon\Documents\textpad.chm::/Help/new.htm'
	
	.EXAMPLE
		'mk:@MSITStore:C:\Users\Brandon\Documents\textpad.chm::/Help/new.htm' | Show-HTMLHelp
	
	.INPUTS
		Text as String
	
	.OUTPUTS
		Html Help Process displaying specified argument.
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$chm
	)
	start-process -filepath hh.exe -argumentlist $chm
 }
 
function Write-InitializationFile {
<#
    .SYNOPSIS
		Writes a key value pair to a section of a initialization file.
			 
	.DESCRIPTION
		This function writes a key value pair to a section of a initialization file.
	 
	.PARAMETER File
		The initialization file to write to

	.PARAMETER Section
		The section to write the key value pair to.

	.PARAMETER Key
		The key of the key value pair.

	.PARAMETER Value
		The value of the key value pair.
		
	.EXAMPLE
		Write-InitializationFile "c:\temp\temp.ini" "Section" "Key" "Value"

	.EXAMPLE
		Write-InitializationFile -File "c:\temp\temp.ini" -section "Section" -key "Key" -value "Value"

	.EXAMPLE
		"c:\temp\temp.ini" | Write-InitializationFile -section "Section" -key "Key" -value "Value"

	.INPUTS
		File as String, Section as String, Key as String, Value as String
	
	.OUTPUTS
		Initialization File
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$File,
		[Parameter(Mandatory)]
		[string]$Section,
		[Parameter(Mandatory)]
		[string]$Key,
		[Parameter(Mandatory)]
		[string]$Value
	)
	$Items = New-Object System.Collections.Generic.List[System.Object]
	$content = get-content $File
	if ($content) {
		$Items.AddRange($content)
	}
	if ($Items.indexof("[$Section]") -eq -1) {
		$Items.add("")
		$Items.add("[$Section]")
		$Items.add("$Key=$Value")
		$Items | Out-File $File -enc ascii
		}
	else {
		For ($i=$Items.indexof("[$Section]")+1; $i -lt $Items.count; $i++) {
		if ($Items[$i].length -gt $Key.length) {
			if ($Items[$i].substring(0,$Key.length) -eq $Key -and ($tgate -ne $true)) {
					$Items[$i] = "$Key=$Value"
					$tgate = $true
				}
			}
			if ($Items[$i].length -gt 0) {
				if (($Items[$i].substring(0,1) -eq "[") -and ($tgate -ne $true)) {
					$i--
					$Items.insert(($i),"$Key=$Value")
					$tgate = $true
					$i++
				}
			}               
		}
		if ($Items.indexof("$Key=$Value") -eq -1) {
			$Items.add("$Key=$Value")
		}
		$Items | Out-File $File -enc ascii
	}
}

function Read-InitializationFile {
<#
    .SYNOPSIS
		Reads a key value pair from a section of a initialization file.
			 
	.DESCRIPTION
		This function reads a key value pair from a section of a initialization file.
	 
	.PARAMETER File
		The initialization file to read from

	.PARAMETER Section
		The section to read the key value pair from.

	.PARAMETER Key
		The key of the key value pair.

	.EXAMPLE
		Read-InitializationFile "c:\temp\temp.ini" "Section" "Key"

	.EXAMPLE
		Read-InitializationFile -File "c:\temp\temp.ini" -section "Section" -key "Key"

	.EXAMPLE
		"c:\temp\temp.ini" | Read-InitializationFile -section "Section" -key "Key"

	.INPUTS
		File as String, Section as String, Key as String
	
	.OUTPUTS
		Value
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$File,
		[Parameter(Mandatory)]
		[string]$Section,
		[Parameter(Mandatory)]
		[string]$Key
	)
    $Items = New-Object System.Collections.Generic.List[System.Object]
    $content = get-content $File
    if ($content) {
        $Items.AddRange($content)
    }
    if ($Items.indexof("[$Section]") -eq -1) {
        $return = ""
    }
    else {
        $return = ""
        For ($i=$Items.indexof("[$Section]")+1; $i -lt $Items.count; $i++) {
            if ($Items[$i].length -gt $Key.length) {
                if ($Items[$i].substring(0,$Key.length) -eq $Key -and $gate -ne $true) {
					$return = $Items[$i].split("=")[1]
					$gate = $true
                }
            }
            if ($Items[$i].length -gt 0) {
                if (($Items[$i].substring(0,1) -eq "[") -and ($tgate -ne $true)) {
                    $gate = $true
                }
            }
        }
    }
    return $return	
}

function New-ShortCut {
<#
    .SYNOPSIS
		Creates a shortcut to a file.
			 
	.DESCRIPTION
		This function creates a shortcut to a file.

	.PARAMETER ShortCut
		The path for the shortcut to be created at
	
	.PARAMETER TargetPath
		The path to the target of the shortcut

	.PARAMETER IconLocation
		The path to the icon for the shortcut
	
	.PARAMETER WorkingDirectory
		The working directory to launch the program in
	
	.PARAMETER Arguments
		Any additional parameters to launch the target with
	
	.PARAMETER RequireAdmin
		Swith that forces the shortcut to run the program elevated
	
	.PARAMETER WindowStyle
		1 for Normal, 3 for Maximized, 7 for Minimized

	.EXAMPLE
		New-ShortCut "c:\temp\temp.lnk" "c:\windows\explorer.exe" "c:\windows\explorer.exe"
		
	.EXAMPLE
		New-ShortCut -shortcut "c:\temp\temp.lnk" -targetpath "c:\windows\explorer.exe" -iconlocation "c:\windows\explorer.exe"

	.EXAMPLE
		"c:\temp\temp.lnk" | New-ShortCut -targetpath "c:\windows\explorer.exe" -iconlocation "c:\windows\explorer.exe"
		
	.INPUTS
		ShortCut as String, TargetPath as String, IconLocation as String, WorkingDirectory as String, Arguments as String, RequireAdmin as Switch, WindowStyle as ValidatedInteger
	
	.OUTPUTS
		ShortCut file
#>

	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$ShortCut,
		[Parameter(Mandatory)]
		[string]$TargetPath,
		[Parameter(Mandatory)]
		[string]$IconLocation,
		[string]$WorkingDirectory,
		[string]$Arguments,
		[switch]$RequireAdmin,
		[ValidateSet(1,3,7)]
		[int]$WindowStyle
	)
    $Shell = New-Object -ComObject ("WScript.Shell")
    $Shell = $Shell.CreateShortcut($ShortCut)
    $Shell.TargetPath = $TargetPath
    $Shell.Arguments = $Arguments
    $Shell.WorkingDirectory = $WorkingDirectory
	if ($WindowStyle -ne $null){
		$Shell.WindowStyle = $WindowStyle
	}
	else {
		$Shell.WindowStyle = 1
	}
    $Shell.Hotkey = ""
    $Shell.IconLocation = $IconLocation
    $Shell.Save()
	
	if ($RequireAdmin -eq $true) {
		$bytes = [System.IO.File]::ReadAllBytes($ShortCut)
		$bytes[0x15] = $bytes[0x15] -bor 0x20
		[System.IO.File]::WriteAllBytes($ShortCut, $bytes)
	}
}

 function Assert-List {
<#
    .SYNOPSIS
		Asserts a list operation
			 
	.DESCRIPTION
		This function asserts a list operation.

	.PARAMETER List
		The list to assert the operation.
	
	.PARAMETER Assertion
		The assertion for the list.
		Add, Append, Assign, Clear, Create, Copy,
		Delete, Insert, Paste, Put, Reverse, Seek, Sort, 
		Dropfiles, Filelist, Folderlist, Fontlist, Loadfile, 
		Loadtext, Modules, Regkeys, Regvals, Savefile, Tasklist,
		Winlist

	.PARAMETER Parameter
		The Parameter to the assertion.
		Add=Text, Append=LineFeedItems, Assign=List, Insert=Text, Put=Text,
		Seek=Text, DropFiles=$_, Filelist=Path, Folderlist=Path,
		Loadfile=Path, Loadtext=LineFeedItems, Modules=Process, Regkeys=Path,
		Regvals=Path, Savefile=Path
	
	.EXAMPLE
		Assert-List $list1 Add "item"
		
	.EXAMPLE
		Assert-List -list $list1 -assertion Add -parameter "item"
	
	.EXAMPLE
		$list1 | Assert-List -assertion Add -parameter "item"
	
	.EXAMPLE
		Assert-List $list1 append "Banana
apple
pear"
	
	.EXAMPLE
		Assert-List $list1 assign $list2
	
	.EXAMPLE
		Assert-List $list1 clear
	
	.EXAMPLE
		$list1 = Assert-List -assertion Create
		
	.EXAMPLE
		Assert-List $list1 copy
	
	.EXAMPLE
		Assert-List $list1 delete
	
	.EXAMPLE
		Assert-List $list1 insert $item
	
	.EXAMPLE
		Assert-List $list1 paste
	
	.EXAMPLE
		Assert-List $list1 put $item
	
	.EXAMPLE
		Assert-List $list1 reverse
	
	.EXAMPLE
		Assert-List $list1 seek 5

	.EXAMPLE
		Assert-List $list1 sort

	.EXAMPLE
		$list1.AllowDrop = $true
		$list1.add_DragEnter({
			Assert-List $list1 dropfiles $_
		})
		
	.EXAMPLE
		Assert-List $list1 filelist "c:\temp\"
	
	.EXAMPLE
		Assert-List $list1 folderlist "c:\temp\"

	.EXAMPLE
		Assert-List $ComboBox1 Fontlist
		
	.EXAMPLE
		Assert-List $list1 Loadfile 'c:\temp\temp.txt'

	.EXAMPLE
		Assert-List $list1 loadtext "Rice
Beans
Butter"

	.EXAMPLE
		Assert-List $list1 modules "c:\windows\explorer.exe"
	
	.EXAMPLE
		Assert-List $list1 regkeys hkcu:\software\dialogshell
		
	.EXAMPLE
		Assert-List $list1 regvals hkcu:\software\dialogshell
		
	.EXAMPLE
		Assert-List $list1 savefile "c:\temp\temp-modifled.txt"
	
	.EXAMPLE
		Assert-List $list1 tasklist
		
	.EXAMPLE
		Assert-List $list1 winlist
		
	.INPUTS
		List as Object, Assertion as String, Parameter as String
	
	.OUTPUTS
		Assertion
#>
	[CmdletBinding()]
    param (
		[Parameter(ValueFromPipeline)]
		[object]$List,
        [Parameter(Mandatory)]
		[ValidateSet('Add', 'Append', 'Assign', 'Clear', 'Create', 'Copy',
		'Delete', 'Insert', 'Paste', 'Put', 'Reverse', 'Seek', 'Sort', 
		'Dropfiles', 'Filelist', 'Folderlist', 'Fontlist', 'Loadfile', 
		'Loadtext', 'Modules', 'Regkeys', 'Regvals', 'Savefile', 'Tasklist',
		'Winlist')]
        [string[]]$Assertion,
		[string]$Parameter
	)
    switch ($Assertion) {
	    add {
            $List.Items.Add($Parameter) | Out-Null
		}
        append {
            $List.Items.AddRange($Parameter.Split([char][byte]10))
        }
        assign {
            $List.Items.AddRange($Parameter.Items)
        }
        clear {
            $List.Items.Clear()
        }
		create{
		return New-Object System.Windows.Forms.listbox
		}
        copy {
            Set-Clipboard $List.items
        } 
        delete {
            $List.Items.RemoveAt($List.SelectedIndex)
        }
        insert {
            $List.items.Insert($List.SelectedIndex,$Parameter)
        }
        paste {     
                $clip = Get-Clipboard
                $List.Items.AddRange($clip.Split())
            }
        put {
                $sel = $List.selectedIndex
                $List.Items.RemoveAt($List.SelectedIndex)
                $List.items.Insert($sel,$Parameter)
            }
        reverse {
            $rev = [array]$List.items
            [array]::Reverse($rev)
            $List.items.clear()
            $List.items.AddRange($rev)
        }
        seek {
            $List.selectedIndex = $Parameter
        }
        sort {
            $List.sorted = $true
        }
        dropfiles {
            if ($Parameter.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
                foreach ($filename in $Parameter.Data.GetData([Windows.Forms.DataFormats]::FileDrop)) {
                    list add $List $filename
                }
            }
        }#  list dropfiles $List1 $_
         # declare: $List1.AllowDrop = $true
         # Use $List1.add_DragEnter
        filelist {
			$items = Get-ChildItem -Path $Parameter
			foreach ($item in $items) {
				if ($item.Attributes -ne "Directory") {
					list add $List $item
				}
			}
		}
		folderlist {
			$items = Get-ChildItem -Path $Parameter
			foreach ($item in $items) {
				if ($item.Attributes -eq "Directory") {
					list add $List $item
				}
			}
		}
        fontlist {  
            [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
            $r = (New-Object System.Drawing.Text.InstalledFontCollection).Families
            foreach ($s in $r){
                $List.items.AddRange($s.name)
            }
        }
        loadfile {
            $content = get-content $Parameter
            $List.items.addrange($content)
        }
        loadtext {
			$List.Items.Clear()
            $List.items.addrange($Parameter.Split([char][byte]10))
        }
        modules {
            $process = Get-Process $Parameter -module
            foreach ($module in $process) {
                $List.items.Add($module) | Out-Null
            }
        }
        regkeys {
            $keys = Get-ChildItem -Path $Parameter
            foreach ($key in $keys) {
                $List.items.add($key) | Out-Null
            }
        }
        
        regvals {
            #$name = Get-Item -Path $Parameter | Select-Object -ExpandProperty Property | Out-String
            $name = $(out-string -inputobject $(select-object -inputobject $(get-item -path $Parameter) -expandproperty property))
            $List.items.addrange($name.Split([char][byte]13))
        } 
        savefile {
        $List.items | Out-File $Parameter
        }
        tasklist {
            $proc = Get-Process | Select-Object -ExpandProperty ProcessName | Out-String
            $List.items.addrange($proc.Split([char][byte]13))
        }
        winlist {
            $win = Get-Process | Where-Object {$_.MainWindowTitle -ne ""} | Select-Object -ExpandProperty MainWindowTitle | Out-String
            $List.items.addrange($win.Split([char][byte]13))
        }
    }
}

function Find-ListMatch {
<#
    .SYNOPSIS
		Finds and seeks the index of an item in a list
			 
	.DESCRIPTION
		This function finds and seeks the index of an item in a list

	.PARAMETER List
		The list to seek
	
	.PARAMETER Text
		The text to seek
		
	.PARAMETER Start
		The start point (optional)
	
	.EXAMPLE
		$index = FindListMatch $ListBox1 "Guitar" 
		
	.EXAMPLE 
		$index = FindListMatch -list $ListBox1 -text "Guitar" -start ($index + 1)

	.EXAMPLE
		$index = $ListBox1 | FindListMatch -text "Guitar"
		
	.INPUTS
		List as Object, Text as String, Start as Integer
	
	.OUTPUTS
		Integer
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$List,
		[Parameter(Mandatory)]
		[string]$Text,
		[int]$Start
	)
    if ($Start -eq $null){
        $Start = -1
    }
    try {
		$return = $List.FindString($Text,$Start)
	}
    catch {
		$return = $List.Items.IndexOf($Text)
	}
    return $return
}

function Step-ListNext {
<#
    .SYNOPSIS
		Steps to the next item in a list
			 
	.DESCRIPTION
		This function steps to the next item in a list

	.PARAMETER List
		The list object
	
	.EXAMPLE
		Step-ListNext $ListBox1
		
	.EXAMPLE 
		Step-ListNext -list $ComboBox1

	.EXAMPLE
		$ListBox1 | Step-ListNext
		
	.INPUTS
		List as Object
	
	.OUTPUTS
		String || Boolean
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$List
	)
    if ($List.items.count -gt $List.selectedIndex + 1) {
        $List.selectedIndex = $List.selectedIndex + 1
        return $List.selectedItems
    }
	else {
		return $false
    }
}

function Get-ListText {
<#
    .SYNOPSIS
		Gets all the items in a list object and converts them to string
     
    .DESCRIPTION
		This function gets all the items in a list object and converts them to string
	
	.PARAMETER List
		The list to convert the items to text from
		
	.EXAMPLE
		$toString = Get-ListText $List1
	
	.EXAMPLE
		$toString = Get-ListText -list $List1
		
	.EXAMPLE
		$toString = $List1 | Get-ListText
	
	.INPUTS
		List as Object
	
	.OUTPUTS
		String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$List
	)
	return [array]$List.items | Out-String
}

function Open-DynamicLinkLibrary {
<#
    .SYNOPSIS
		Opens a Dynamic Link Library
			 
	.DESCRIPTION
		This function opens a Dynamic Link Library

	.PARAMETER Path
		The path for the shortcut to be created at
	
	.EXAMPLE
		Open-DynamicLinkLibrary 'c:\temp\FastColoredTextBox.dll'
		
	.EXAMPLE
		Open-DynamicLinkLibrary -path 'c:\temp\FastColoredTextBox.dll'

	.EXAMPLE
		'c:\temp\FastColoredTextBox.dll' | Open-DynamicLinkLibrary
		
	.INPUTS
		Path as String
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Path
	)
	[Reflection.Assembly]::LoadFile($Path) | Out-Null
}

function Add-Font {
<#
    .SYNOPSIS
		Installs a font from a font file
			 
	.DESCRIPTION
		This function installs a font from a font file

	.PARAMETER Path
		The path of the font file
	
	.EXAMPLE
		Add-Font 'c:\temp\cgtr66w.ttf'
		
	.EXAMPLE 
		Add-Font -path 'c:\temp\cgtr66w.ttf'

	.EXAMPLE
		'c:\temp\cgtr66w.ttf' | Add-Font
		
	.INPUTS
		Path as String
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Path
	)
	$shellapp =  New-Object -ComoObject Shell.Application
	$Fonts = $shellapp.NameSpace(0x14)
	$Fonts.CopyHere($Path)
}

function Remove-Font {
<#
    .SYNOPSIS
		Removes a font from the system
			 
	.DESCRIPTION
		This function removes a font from the system

	.PARAMETER FontName
		The name of the font
	
	.EXAMPLE
		Remove-Font 'CG Times'
		
	.EXAMPLE 
		Remove-Font -fontname 'CG Times'

	.EXAMPLE
		'CG Times' | Remove-Font
		
	.INPUTS
		FontName as String
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$FontName
	)
	$name = Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' | Select-Object -ExpandProperty Property | Out-String
	$keys = $name.Split([char][byte]10)
	foreach ($key in $keys) {
		$key = $key.Trim()
		if ($(Get-SubString $key 0 ($FontName.length)) -eq $FontName) {
			$file = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' -Name $key | Select -ExpandProperty $key
			$file = $file.trim() 
			Remove-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' -Name $key 
		}
	}
}

function Get-MouseButtonDown {
<#
    .SYNOPSIS
		Returns the mouse button that is pressed down.
			 
	.DESCRIPTION
		This function returns the mouse button that is pressed down.

	.EXAMPLE
		$mousedown = Get-MouseButtonDown
	
	.OUTPUTS
		MouseButtons as String
#>
	return [System.Windows.Forms.UserControl]::MouseButtons | Out-String
}

function Get-MousePosition {
<#
    .SYNOPSIS
		Returns the X and Y of the mouse position.
			 
	.DESCRIPTION
		This function returns the X and Y of the mouse position.

	.EXAMPLE
		$mouseX = (Get-MousePosition).X
	
	.EXAMPLE
		$mouseY = (Get-MousePosition).Y
	
	.OUTPUTS
		PSCustomObject
#>
	$return = [PSCustomObject] | Select-Object -Property X, Y
	$return.X = [System.Windows.Forms.Cursor]::Position.X
	$return.Y = [System.Windows.Forms.Cursor]::Position.Y
	return $return
}

function Assert-WPF {
<#
    .SYNOPSIS
		Transforms XAML string into a Windows Presentation Foundation window
			 
	.DESCRIPTION
		This function transforms XAML string into a Windows Presentation 
		Foundation window (ambiguous)
		
	.PARAMETER xaml
		The source XAML string to transform
	
	.EXAMPLE
		Assert-WPF $xaml
		
	.EXAMPLE
		Assert-WPF -xaml $xaml

	.EXAMPLE
		$xaml | Assert-WPF
		
	.INPUTS
		xaml as String
	
	.OUTPUTS
		Windows.Markup.XamlReader and Global Variables for Controls within the window by Control Name
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$xaml
	)
	$xaml = $xaml -replace "x:N", 'N' -replace 'd:DesignHeight="\d*?"', '' -replace 'x:Class=".*?"', '' -replace 'mc:Ignorable="d"', '' -replace 'd:DesignWidth="\d*?"', '' 
	[xml]$xaml = $xaml
	$presentation = [Windows.Markup.XamlReader]::Load((new-object System.Xml.XmlNodeReader $xaml))
	$xaml.SelectNodes("//*[@Name]") | %{
		Set-Variable -Name $_.Name.ToString() -Value $presentation.FindName($_.Name) -Scope global
	}
	return $presentation
}

function Assert-WPFCreate {
<#
    .SYNOPSIS
		Creates a Windows Presentation Foundation window
			 
	.DESCRIPTION
		This function Creates a Windows Presentation Foundation window
		
	.PARAMETER Title
		The title for the window
		
	.PARAMETER Height
		The height for the window
	
	.PARAMETER Width
		The width for the window
	
	.PARAMETER Grid
		A name property for the grid created within the window.
	
	.EXAMPLE
		Assert-WPFCreate "Brandon's Window" "480" "800" "Grid1"
		
	.EXAMPLE
		Assert-WPFCreate -title "Brandon's Window" -height "480" -width "800" -grid "Grid1"

	.EXAMPLE
		"Brandon's Window" | Assert-WPFCreate -height "480" -width "800" -grid "Grid1"
		
	.INPUTS
		Title as String, Height as String, Width as String, Grid as String
	
	.OUTPUTS
		Windows.Markup.XamlReader
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Title,
		[Parameter(Mandatory)]
		[string]$Height,
		[Parameter(Mandatory)]
		[string]$Width,
		[Parameter(Mandatory)]
		[string]$Grid
	)
	$xaml = @"
		<Window
				xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
				xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
				Title="$Title" Height="$Height" Width="$Width">
				<Grid Name="$Grid">
				</Grid>
		</Window>
"@
		$MainWindow = (Assert-WPF $xaml)
		return $MainWindow
}

function Assert-WPFAddControl {
<#
    .SYNOPSIS
		Creates a control inside of a wpf container object
			 
	.DESCRIPTION
		This function creates a control inside of a wpf container object
		
	.PARAMETER ControlType
		The type of control to add from the following validated list:
		Button, Calendar, CheckBox,ComboBox, 
		ComboBoxItem, DatePicker, DocumentViewer, Expander, 
		FlowDocumentReader, GroupBox, Hyperlink, Image, InkCanvas, 
		Label, ListBox, ListBoxItem, Menu, MenuItem, PasswordBox, 
		ProgressBar, RadioButton, RichTextBox, SrollViewer,
		SinglePageViewer,Slider, TabControl, TabItem, Table, 
		TextBlock, TextBox, ToolBar, ToolTip, TreeView, 
		TreeViewItem, WebBrowser
		
	.PARAMETER Container
		The container to add the control to
		
	.PARAMETER Text
		The text to display on the control
		
	.PARAMETER Top
		The top position for the control

	.PARAMETER Left
		The left position for the control
		
	.PARAMETER Height
		The height for the control
	
	.PARAMETER Width
		The width for the control
	
	.EXAMPLE
		$Button1 = Assert-WPFAddControl 'Button' 'Grid1' 'Button1' 20 20 20 200
		
	.EXAMPLE
		$Button1 = Assert-WPFAddControl -ControlType 'Button' -Container 'Grid1' -Text 'Button1' -top 20 -left 20 -height 20 -width 200

	.EXAMPLE
		$Button1 = 'Button' | Assert-WPFAddControl -Container 'Grid1' -Text 'Button1' -top 20 -left 20 -height 20 -width 200
		
	.INPUTS
		ControlType as ValidatedString, Container as Object, Text as String, Top as String, Left as String, Height as String, Width as String
	
	.OUTPUTS
		System.Windows.Controls.$ControlType
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[ValidateSet('Button', 'Calendar', 'CheckBox','ComboBox', 
		'ComboBoxItem', 'DatePicker', 'DocumentViewer', 'Expander', 
		'FlowDocumentReader', 'GroupBox', 'Hyperlink', 'Image', 'InkCanvas', 
		'Label', 'ListBox', 'ListBoxItem', 'Menu', 'MenuItem', 'PasswordBox', 
		'ProgressBar', 'RadioButton', 'RichTextBox', 'SrollViewer',
		'SinglePageViewer','Slider', 'TabControl', 'TabItem', 'Table', 
		'TextBlock', 'TextBox', 'ToolBar', 'ToolTip', 'TreeView', 
		'TreeViewItem', 'WebBrowser')]
		[string[]]$ControlType,
		[Parameter(Mandatory)]
		[object]$Container,
		[Parameter(Mandatory)]
		[string]$Text,
		[Parameter(Mandatory)]
		[string]$Top,
		[Parameter(Mandatory)]
		[string]$Left,
		[Parameter(Mandatory)]
		[string]$Height,
		[Parameter(Mandatory)]
		[string]$Width
	)
	$control = new-object System.Windows.Controls.$ControlType
	$control.Content = "$Text"
	$Container.Children.Insert($Container.Children.Count, $control)
	$control.VerticalAlignment = "Top"
	$control.HorizontalAlignment = "Left"
	$control.Margin = "$Left,$Top,0,0"
	$control.Height = "$Height"
	$control.Width = "$Width"
	return $control
}

function Assert-WPFInsertControl {
<#
    .SYNOPSIS
		Inserts a control inside of a wpf container object
			 
	.DESCRIPTION
		This function inserts a control inside of a wpf container object
		
	.PARAMETER ControlType
		The type of control to add from the following validated list:
		Button, Calendar, CheckBox,ComboBox, 
		ComboBoxItem, DatePicker, DocumentViewer, Expander, 
		FlowDocumentReader, GroupBox, Hyperlink, Image, InkCanvas, 
		Label, ListBox, ListBoxItem, Menu, MenuItem, PasswordBox, 
		ProgressBar, RadioButton, RichTextBox, SrollViewer,
		SinglePageViewer,Slider, TabControl, TabItem, Table, 
		TextBlock, TextBox, ToolBar, ToolTip, TreeView, 
		TreeViewItem, WebBrowser
		
	.PARAMETER Container
		The container to add the control to
	
	.EXAMPLE
		$Button1 = Assert-WPFInsertControl 'Button' 'Grid1'
		
	.EXAMPLE
		$Button1 = Assert-WPFInsertControl -ControlType 'Button' -Container 'Grid1'

	.EXAMPLE
		$Button1 = 'Button' | Assert-WPFInsertControl -Container 'Grid1'
		
	.INPUTS
		ControlType as ValidatedString, Container as Object
	
	.OUTPUTS
		System.Windows.Controls.$ControlType
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[ValidateSet('Button', 'Calendar', 'CheckBox','ComboBox', 
		'ComboBoxItem', 'DatePicker', 'DocumentViewer', 'Expander', 
		'FlowDocumentReader', 'GroupBox', 'Hyperlink', 'Image', 'InkCanvas', 
		'Label', 'ListBox', 'ListBoxItem', 'Menu', 'MenuItem', 'PasswordBox', 
		'ProgressBar', 'RadioButton', 'RichTextBox', 'SrollViewer',
		'SinglePageViewer','Slider', 'TabControl', 'TabItem', 'Table', 
		'TextBlock', 'TextBox', 'ToolBar', 'ToolTip', 'TreeView', 
		'TreeViewItem', 'WebBrowser')]
		[string[]]$ControlType,
		[Parameter(Mandatory)]
		[object]$Container
	)
	$control = new-object System.Windows.Controls.$ControlType
	$Container.Children.Insert($Container.Children.Count, $control)
	return $control
}

function Assert-WPFGetControlByName {
<#
    .SYNOPSIS
		Returns the control associated with the name specified. 
			 
	.DESCRIPTION
		This function returns the control associated with the name specified. 
	
	.PARAMETER Presentation
		The presentation window that contains the control
		
	.PARAMETER Name
		The name of the control
		
	.EXAMPLE
		Assert-WPFGetControlByName $Form1 "Button1"
		
	.EXAMPLE
		Assert-WPFGetControlByName -presentation $Form1 -control "Button1"

	.EXAMPLE
		$Form1 | Assert-WPFGetControlByName -presentation $Form1 -control "Button1"
		
	.INPUTS
		Presentation as Object, Name as String
	
	.OUTPUTS
		Object
	
	.NOTES
		Normally only useful with externally sourced XAML loaded by Assert-WPF.
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Presentation,
		[Parameter(Mandatory)]
		[string]$Name
	)
	return $Presentation.FindName($Name)
}

function Assert-WPFValign {
<#
    .SYNOPSIS
		Vertically aligns an object according to the specified parameter.
			 
	.DESCRIPTION
		This function vertically aligns an object according to the specified parameter.
	
	.PARAMETER Object
		The object to align
		
	.PARAMETER Valign
		The position to vertically align the control to. May be the value 
		Top, Center, Bottom or Stretch.
		
	.EXAMPLE
		Assert-WPFValign $Button1 'Top'
		
	.EXAMPLE
		Assert-WPFValign -Object $Button1 -valign 'Top'

	.EXAMPLE
		$Button1 | Assert-WPFValign -valign 'Top'
		
	.INPUTS
		Object as Object, Valign as String
	
	.OUTPUTS
		Format of Vertical Alignment
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Object,
		[Parameter(Mandatory)]
		[ValidateSet('Top', 'Center', 'Bottom', 'Stretch')]
		[string[]]$Valign
	)
	$Object.VerticalAlignment = $Valign
}

function Assert-WPFHAlign {
<#
    .SYNOPSIS
		Horizontally aligns an object according to the specified parameter.
			 
	.DESCRIPTION
		This function Horizontally aligns an object according to the specified parameter.
	
	.PARAMETER Object
		The object to align
		
	.PARAMETER Halign
		The position to horizontally align the control to. May be the value 
		Left, Center, Right or Stretch.
		
	.EXAMPLE
		Assert-WPFHalign $Button1 'Left'
		
	.EXAMPLE
		Assert-WPFHalign -Object $Button1 -halign 'Center'

	.EXAMPLE
		$Button1 | Assert-WPFHalign -halign 'Right'
		
	.INPUTS
		Object as Object, Halign as String
	
	.OUTPUTS
		Format of Horizontal Alignment
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Object,
		[Parameter(Mandatory)]
		[ValidateSet('Left', 'Center', 'Right', 'Stretch')]
		[string[]]$Halign
	)
	$Object.HorizontalAlignment = $Halign
}

function Get-RegistryExists {
<#
    .SYNOPSIS
		Returns if a registry key or value exists as boolean.
			 
	.DESCRIPTION
		This function returns if a registry key or value exists as boolean.
	
	.PARAMETER Path
		The path to the registry key to check for
		
	.PARAMETER Name
		Optional, the name of the value to check for
		
	.EXAMPLE
		$exists = Get-RegistryExists 'Registry::HKEY_CURRENT_USER\Software\Adobe\Acrobat Reader\10.0\AdobeViewer'
		
	.EXAMPLE
		$exists = Get-RegistryExists -path 'Registry::HKEY_CURRENT_USER\Software\Adobe\Acrobat Reader\10.0\AdobeViewer' -name 'EULA'

	.EXAMPLE
		$exists = 'Registry::HKEY_CURRENT_USER\Software\Adobe\Acrobat Reader\10.0\AdobeViewer' | Get-RegistryExists
	
	.INPUTS
		Path as String, Name as String
	
	.OUTPUTS
		Boolean
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Path,
		[string]$Name
	)
	if ($Name -eq '') {
		$return = Test-Path -path $Path
	}
	else {
		if (Test-Path -path $Path) {
			try {
				$return = Get-ItemProperty -Path $Path -Name $Name -erroraction 'silentlycontinue'
			}
			catch {
				$return = $false
			}
		}
		else {
			$return = $false
		}
	}
    if ($return) {
		return $true
    }
    else {
		return $false
    }
}

function Copy-RegistryKey {
<#
    .SYNOPSIS
		Copies a registry key to another location
			 
	.DESCRIPTION
		This function copies a registry key to another location.
	
	.PARAMETER Path
		The path to the registry key
		
	.PARAMETER Destination
		The path to copy the key to
		
	.EXAMPLE
		Copy-RegistryKey 'Registry::HKEY_CURRENT_USER\Software\Adobe\Acrobat Reader\10.0\AdobeViewer' 'Registry::HKEY_CURRENT_USER\Software\Policies\Adobe\Acrobat Reader\10.0\AdobeViewer'
		
	.EXAMPLE
		Copy-RegistryKey -path 'Registry::HKEY_CURRENT_USER\Software\Adobe\Acrobat Reader\10.0\AdobeViewer' -destination 'Registry::HKEY_CURRENT_USER\Software\Policies\Adobe\Acrobat Reader\10.0\AdobeViewer'
	
	.INPUTS
		Path as String, Destination as String
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory)]
		[string]$Path,
		[Parameter(Mandatory)]
		[string]$Destination
	)
	Copy-Item -Path $Path -Destination $Destination
}

function Remove-RegistryKey {
<#
    .SYNOPSIS
		Removes a registry key
			 
	.DESCRIPTION
		This function removes a registry key
	
	.PARAMETER Path
		The path to the registry key
		
	.EXAMPLE
		Remove-RegistryKey 'Registry::HKEY_CURRENT_USER\Software\Adobe\Acrobat Reader\10.0\AdobeViewer'
		
	.EXAMPLE
		Remove-RegistryKey -path 'Registry::HKEY_CURRENT_USER\Software\Adobe\Acrobat Reader\10.0\AdobeViewer'
	
	.EXAMPLE
		'Registry::HKEY_CURRENT_USER\Software\Adobe\Acrobat Reader\10.0\AdobeViewer' | Remove-RegistryKey
	
	.INPUTS
		Path as String
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Path
	)
       Remove-Item -Path $Path -Recurse
}

function Move-RegistryKey {
<#
    .SYNOPSIS
		Moves a registry key
			 
	.DESCRIPTION
		This function moves a registry key
	
	.PARAMETER Path
		The path to the registry key to move
	
	.PARAMETER Destination
		The destination for the new key location
		
	.EXAMPLE
		Move-RegistryKey 'Registry::HKEY_CURRENT_USER\Software\Adobe\Acrobat Reader\10.0\AdobeViewer' 'Registry::HKEY_CURRENT_USER\Software\Policies\Adobe\Acrobat Reader\10.0\AdobeViewer'
		
	.EXAMPLE
		Move-RegistryKey -path 'Registry::HKEY_CURRENT_USER\Software\Adobe\Acrobat Reader\10.0\AdobeViewer' -destination 'Registry::HKEY_CURRENT_USER\Software\Policies\Adobe\Acrobat Reader\10.0\AdobeViewer'
	
	.INPUTS
		Path as String, Destination as String
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory)]
		[string]$Path,
		[Parameter(Mandatory)]
		[string]$Destination
	)
	Copy-Item -Path $Path -Destination $Destination
    Remove-Item -Path $Path -Recurse
}

function Rename-RegistryKey {
<#
    .SYNOPSIS
		Renames a registry key
			 
	.DESCRIPTION
		This function renames a registry key
	
	.PARAMETER Path
		The path to the registry key to rename
	
	.PARAMETER NewName
		The new name for the key.
		
	.EXAMPLE
		Rename-RegistryKey 'Registry::HKEY_CURRENT_USER\Software\Adobe\Acrobat Reader\10.0\AdobeViewer' 'AdobeEditor'
		
	.EXAMPLE
		Rename-RegistryKey -path 'Registry::HKEY_CURRENT_USER\Software\Adobe\Acrobat Reader\10.0\AdobeViewer' -newname 'AdobeEditor'
	
	.INPUTS
		Path as String, NewName as String
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory)]
		[string]$Path,
		[Parameter(Mandatory)]
		[string]$NewName
	)
	Rename-Item -Path $Path -NewName $NewName
}

function New-RegistryKey {
<#
    .SYNOPSIS
		Creates a registry key
			 
	.DESCRIPTION
		This function creates a registry key
	
	.PARAMETER Path
		The path to the registry key to rename
	
	.PARAMETER Name
		The name for the key.
		
	.EXAMPLE
		New-RegistryKey 'Registry::HKEY_CURRENT_USER\Software\Adobe\Acrobat Reader\10.0\' 'AdobeNotes'
		
	.EXAMPLE
		New-RegistryKey -path 'Registry::HKEY_CURRENT_USER\Software\Adobe\Acrobat Reader\10.0\' -name 'AdobeNotes'
	
	.INPUTS
		Path as String, Name as String
#>
	[CmdletBinding()]
    param (
		[Parameter(Mandatory)]
		[string]$Path,
		[Parameter(Mandatory)]
		[string]$Name
	)
	New-Item -Path $Path -Name $Name
}

function New-RegistryValue {
<#
    .SYNOPSIS
		Creates a registry value
			 
	.DESCRIPTION
		This function creates a registry value
	
	.PARAMETER Path
		The path to the registry key containing the value
	
	.PARAMETER Name
		The name for the value
	
	.PARAMETER PropertyType
		The values' property type from the following:
		String, ExpandString, Binary, DWord, MultiString, Qword, Unknown
		This parameter is not required

	.PARAMETER Value
		The value of registry object
		
	.EXAMPLE
		New-RegistryValue -Path "HKLM:\Software\MyCompany" -Name "NoOfEmployees" -Value 822
		
	.EXAMPLE
		New-RegistryValue -path HKLM:\Software\MyCompany" -Name "NoOfEmployees" -PropertyType "String" -Value "822"
	
	.INPUTS
		Path as String, Name as String, PropertyType as ValidatedString, Value as Variant
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string]$Path,
		[Parameter(Mandatory)]
		[string]$Name,
		[ValidateSet('String', 'ExpandString', 'Binary', 'DWord', 'MultiString', 'Qword', 'Unknown')]
		[string[]]$PropertyType,
		[Parameter(Mandatory)]
		$Value
	)
	New-ItemProperty -Path $Path -Name $Name -PropertyType $PropertyType -Value $Value
}

function Set-RegistryValue {
<#
    .SYNOPSIS
		Modifies a registry value
			 
	.DESCRIPTION
		This function modifies a registry value
	
	.PARAMETER Path
		The path to the registry key containing the value
	
	.PARAMETER Name
		The name of the value

	.PARAMETER Value
		The new value of registry object
		
	.EXAMPLE
		Set-RegistryValue -Path "HKLM:\Software\MyCompany" -Name "NoOfEmployees" -Value 823
		
	.INPUTS
		Path as String, Name as String, Value as Variant
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string]$Path,
		[Parameter(Mandatory)]
		[string]$Name,
		[Parameter(Mandatory)]
		$Value
	)
	Set-ItemProperty -Path $Path -Name $Name -Value $Value
}

function Rename-RegistryValue {
<#
    .SYNOPSIS
		Renames a registry value
			 
	.DESCRIPTION
		This function renames a registry value
	
	.PARAMETER Path
		The path to the registry key containing the value
	
	.PARAMETER Name
		The name of the value

	.PARAMETER NewName
		The new name for the registry object containing the value
		
	.EXAMPLE
		Rename-RegistryValue -Path "HKLM:\Software\MyCompany" -Name "NoOfEmployees" -NewName "NumberOfEmployees"
		
	.INPUTS
		Path as String, Name as String, NewName as String
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string]$Path,
		[Parameter(Mandatory)]
		[string]$Name,
		[Parameter(Mandatory)]
		[string]$NewName
	)	
	Rename-ItemProperty -Path $Path -Name $Name -NewName $NewName
}

function Remove-RegistryValue {
<#
    .SYNOPSIS
		Removes a registry value
			 
	.DESCRIPTION
		This function removes a registry value
	
	.PARAMETER Path
		The path to the registry key containing the value
	
	.PARAMETER Name
		The name of the value

	.EXAMPLE
		Remove-RegistryValue -Path "HKLM:\Software\MyCompany" -Name "NumberOfEmployees"
		
	.INPUTS
		Path as String, Name as String
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string]$Path,
		[Parameter(Mandatory)]
		[string]$Name
	)		
	Remove-ItemProperty -Path $Path -Name $Name
}

function Get-RegistryValue {
<#
    .SYNOPSIS
		Returns a registry value
			 
	.DESCRIPTION
		This function returns a registry value
	
	.PARAMETER Path
		The path to the registry key containing the value
	
	.PARAMETER Name
		The name of the value

	.EXAMPLE
		$numemp = Get-RegistryValue -Path "HKLM:\Software\MyCompany" -Name "NumberOfEmployees"
		
	.INPUTS
		Path as String, Name as String
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string]$Path,
		[Parameter(Mandatory)]
		[string]$Name
	)
	return Get-ItemProperty -Path $Path -Name $Name | Select -ExpandProperty $Name
}

function Get-RegistryType {
<#
    .SYNOPSIS
		Returns a registry type from the path to the value
			 
	.DESCRIPTION
		This function returns a registry type from the path to the value
	
	.PARAMETER Path
		The path to the registry key containing the value
	
	.PARAMETER Name
		The name of the value

	.EXAMPLE
		$type = Get-RegistryType -Path "HKLM:\Software\MyCompany" -Name "NumberOfEmployees"
		
	.INPUTS
		Path as String, Name as String
		
	.OUTPUTS
		String
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string]$Path,
		[Parameter(Mandatory)]
		[string]$Name
	)
	switch ((Get-ItemProperty -Path $Path -Name $Name).$Name.gettype().Name){ 
        "String" {
            return "String"
        }
        "Int32" {
			return "DWord"
        }
        "Int64" {
			return "QWord"
        }
        "String[]" {
			return "ExpandString"
        }
        "Byte[]" {
			return "Binary"
        } 
        default {
			return "Unknown"
        }
    }
}

function Get-ScreenVirtualHeight {
<#
    .SYNOPSIS
		Returns the screen height
			 
	.DESCRIPTION
		This function gets the virtual screen height according to how the
		application currently perceives it.
	
	.EXAMPLE
		$return = Get-ScreenVirtualHeight
				
	.OUTPUTS
		Integer
	
	.NOTES
		The return will be different according to before and after Set-DPIAware
		is called and it addresses the screen controlling the DPI of the application.
#>
	return [System.Windows.Forms.SystemInformation]::VirtualScreen.height
}

function Get-ScreenVirtualWidth {
<#
    .SYNOPSIS
		Returns the screen width
			 
	.DESCRIPTION
		This function gets the virtual screen width according to how the
		application currently perceives it.
	
	.EXAMPLE
		$return = Get-ScreenVirtualWidth
				
	.OUTPUTS
		Integer
	
	.NOTES
		The return will be different according to before and after Set-DPIAware
		is called and it addresses the screen controlling the DPI of the application.
#>
	
	return [System.Windows.Forms.SystemInformation]::VirtualScreen.width
}

function Get-ScreenScale {
<#
    .SYNOPSIS
		Returns the screen scale
			 
	.DESCRIPTION
		This function gets the virtual screen scale according to how the
		application currently perceives it.
	
	.EXAMPLE
		$return = Get-ScreenScale
				
	.OUTPUTS
		Decimal
	
	.NOTES
		The return will be different according to before and after Set-DPIAware is called.
#>
	return $ctscale
}

function Initialize-Selenium {
<#
    .SYNOPSIS
		Initializes a session between Google Chrome and W3C Selenium.
			 
	.DESCRIPTION
		This function initializes a session between Google Chrome and W3C Selenium.
	
	.PARAMETER Path
		The path to the ChromeDriver.exe and WebDriver.dll
		
	.EXAMPLE
		$Selenium = initialize-selenium -path C:\Users\Brandon\Downloads\chromedriver_win32\
		
	.EXAMPLE
		$Selenium = C:\Users\Brandon\Downloads\chromedriver_win32\ | initialize-selenium 
				
	.INPUTS
		Path as String
	
	.OUTPUTS
		Object
	
	.NOTES
		Requires chromedriver.exe and Webdriver.dll be present in the path specified.
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Path
	)
	$env:PATH += ";$Path"
    Add-Type -Path ($Path + 'WebDriver.dll')
    $ChromeOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions
    return New-Object OpenQA.Selenium.Chrome.ChromeDriver($ChromeOptions)
}

function Open-SeleniumURL {
<#
    .SYNOPSIS
		Opens a URL via Selenium WebDriver
			 
	.DESCRIPTION
		This function opens a URL via Selenium WebDriver
	
	.PARAMETER Selenium
		The Selenium object to open the URL
	
	.PARAMETER URL
		The path of the URL
		
	.EXAMPLE
		Open-SeleniumURL $Selenium 'https://google.com'
		
	.EXAMPLE
		Open-SeleniumURL -selenium $Selenium -url 'https://google.com'
	
	.EXAMPLE
		$Selenium | Open-SeleniumURL -url 'https://google.com'
				
	.INPUTS
		Selenium as Object, URL as String
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Selenium,
		[Parameter(Mandatory)]
		[string]$URL
	)
	$Selenium.Navigate().GoToURL($URL)
}

function Get-SeleniumElementByAttribute {
<#
    .SYNOPSIS
		Gets an object through Selenium by the attribute specified
			 
	.DESCRIPTION
		This function gets an object through Selenium by the attribute specified
	
	.PARAMETER Selenium
		The Selenium object
	
	.PARAMETER Attribute
		The attribute to search by
		
	.PARAMETER Value
		The value to search for
		
	.EXAMPLE
		$Element = Get-SeleniumElementByAttribute $Selenium 'class' 'DisplayTable'
		
	.EXAMPLE
		$Element = Get-SeleniumElementByAttribute -selenium $Selenium -Attribute 'class' -Value 'DisplayTable'
		
	.EXAMPLE
		$Element = $Selenium | Get-SeleniumElementByAttribute -Attribute 'class' -Value 'DisplayTable'
		
	.INPUTS
		Selenium as Object, Attribute as String, Value as String
	
	.OUTPUTS
		Object
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Selenium,
		[Parameter(Mandatory)]
		[string]$Attribute,
		[Parameter(Mandatory)]
		[string]$Value
	)
	return $Selenium.FindElementsByXPath("//*[contains(@$Attribute, '$Value')]")
}

function Get-SeleniumElementByXPath {
<#
    .SYNOPSIS
		Gets an object through Selenium by XPath
			 
	.DESCRIPTION
		This function gets an object through Selenium by by XPath
	
	.PARAMETER Selenium
		The Selenium object
	
	.PARAMETER XPath
		The XPath of the object

	.EXAMPLE
		$Element = Get-SeleniumElementByXPath $Selenium '/html/body/ntp-app//div/ntp-logo//div'
		
	.EXAMPLE
		$Element = Get-SeleniumElementByAttribute -selenium $Selenium -XPath '/html/body/ntp-app//div/ntp-logo//div'
		
	.EXAMPLE
		$Element = $Selenium | Get-SeleniumElementByAttribute -XPath '/html/body/ntp-app//div/ntp-logo//div'
		
	.INPUTS
		Selenium as Object, XPath as String
	
	.OUTPUTS
		Object
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Selenium,
		[Parameter(Mandatory)]
		[string]$XPath
	)
	return $Selenium.FindElementsByXPath($XPath)
}

function Send-SeleniumElementByAttribute {
<#
    .SYNOPSIS
		Sends text to an object through Selenium by the attribute specified
			 
	.DESCRIPTION
		This function sends text to an object through Selenium by the attribute specified
	
	.PARAMETER Selenium
		The Selenium object
	
	.PARAMETER Attribute
		The attribute to search by
		
	.PARAMETER Value
		The value inside the element attribute to search for
		
	.PARAMETER Send
		The text to send into the element
		
	.EXAMPLE
		Send-SeleniumElementByAttribute $Selenium 'class' 'DisplayTable' '<td>No Values Set</td>'
		
	.EXAMPLE
		Send-SeleniumElementByAttribute -selenium $Selenium -Attribute 'class' -Value 'DisplayTable' -Send '<td>No Values Set</td>'
		
	.EXAMPLE
		$Selenium | Send-SeleniumElementByAttribute -Attribute 'class' -Value 'DisplayTable' -Send '<td>No Values Set</td>'
		
	.INPUTS
		Selenium as Object, Attribute as String, Value as String, Send as String
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Selenium,
		[Parameter(Mandatory)]
		[string]$Attribute,
		[Parameter(Mandatory)]
		[string]$Value,
		[Parameter(Mandatory)]
		[string]$Send
	)
	$Selenium.FindElementsByXPath("//*[contains(@$Attribute, '$Value')]").SendKeys($Send)
}

function Send-SeleniumElementByXPath {
<#
    .SYNOPSIS
		Sends text to an object through Selenium by XPath
			 
	.DESCRIPTION
		This function sends text to an object through Selenium by by XPath
	
	.PARAMETER Selenium
		The Selenium object
	
	.PARAMETER XPath
		The XPath of the object
	
	.PARAMETER Send
		The text to send into the element

	.EXAMPLE
		Send-SeleniumElementByXPath $Selenium '/html/body/input' 'Hello'
		
	.EXAMPLE
		Send-SeleniumElementByAttribute -selenium $Selenium -XPath '/html/body/input' -Send 'Hello'
		
	.EXAMPLE
		$Selenium | Send-SeleniumElementByAttribute -XPath '/html/body/input' -Send 'Hello'
		
	.INPUTS
		Selenium as Object, XPath as String, Send as String
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Selenium,
		[Parameter(Mandatory)]
		[string]$XPath,
		[Parameter(Mandatory)]
		[string]$Send
	)
	$Selenium.FindElementsByXPath($XPath).SendKeys($Send)
}

function Send-ClickToSeleniumElementByAttribute {
<#
    .SYNOPSIS
		Clicks an object through Selenium by the attribute specified
			 
	.DESCRIPTION
		This function clicks an object through Selenium by the attribute specified
	
	.PARAMETER Selenium
		The Selenium object
	
	.PARAMETER Attribute
		The attribute to search by
		
	.PARAMETER Value
		The value inside the element attribute to search for
		
	.EXAMPLE
		Send-ClickToSeleniumElementByAttribute $Selenium 'class' 'DisplayTable'
		
	.EXAMPLE
		Send-ClickToSeleniumElementByAttribute -selenium $Selenium -Attribute 'class' -Value 'DisplayTable'
		
	.EXAMPLE
		$Selenium | Send-ClickToSeleniumElementByAttribute -Attribute 'class' -Value 'DisplayTable'
		
	.INPUTS
		Selenium as Object, Attribute as String, Value as String
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Selenium,
		[Parameter(Mandatory)]
		[string]$Attribute,
		[Parameter(Mandatory)]
		[string]$Value
	)
	$Selenium.FindElementsByXPath("//*[contains(@$Attribute, '$Value')]").Click()
}

function Send-ClickToSeleniumElementByXPath {
<#
    .SYNOPSIS
		Sends text to an object through Selenium by XPath
			 
	.DESCRIPTION
		This function sends text to an object through Selenium by by XPath
	
	.PARAMETER Selenium
		The Selenium object to open the URL
	
	.PARAMETER XPath
		The XPath of the object
	
	.PARAMETER Send
		The text to send into the element

	.EXAMPLE
		Send-ClickToSeleniumElementByXPath $Selenium '/html/body/input'
		
	.EXAMPLE
		Send-ClickToSeleniumElementByAttribute -selenium $Selenium -XPath '/html/body/input'
		
	.EXAMPLE
		$Selenium | Send-ClickToSeleniumElementByAttribute -XPath '/html/body/input' 
		
	.INPUTS
		Selenium as Object, XPath as String
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Selenium,
		[Parameter(Mandatory)]
		[string]$XPath
	)
	$Selenium.FindElementsByXPath($XPath).Click()
}

function Stop-Selenium {
<#
    .SYNOPSIS
		Ends a Selenium session
			 
	.DESCRIPTION
		This function ends a Selenium session
	
	.PARAMETER Selenium
		The Selenium object

	.EXAMPLE
		Stop-Selenium $Selenium
		
	.EXAMPLE
		Stop-Selenium -selenium $Selenium
		
	.EXAMPLE
		$Selenium | Stop-Selenium
		
	.INPUTS
		Selenium as Object
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Selenium
	)
		$Selenium.Close()
		$Selenium.Quit()
}

function Start-WebServer {
<#
    .SYNOPSIS
		Starts a WebServer
			 
	.DESCRIPTION
		This function starts a WebServer
	
	.PARAMETER ServerPath
		The path of the server
		
	.PARAMETER ServerPort
		The port for the server to listen on

	.EXAMPLE
		$Server = Start-WebServer http://localhost 5051
	
	.EXAMPLE
		$Server = Start-WebServer -ServerPath http://localhost -ServerPort 5051

	.EXAMPLE
		#PS
		$Server = Start-WebServer http://localhost 5051
		while (1){
			#Script pauses on the line below until $Context contains a value
			$Context = Get-WebServerContext $Server
			$Path = Get-WebServerLocalPath $Context
			if ($Path -eq "/") {
				Set-WebServerResponse $Context "Hello World"
			}
			elseif ($Path -eq "/Beans") {
				Set-WebServerResponse $Context "Beans"
			}
			elseif($Path -eq "/SecretStop") {
				Stop-WebServer $Server
			exit
			}
			else{
				Set-WebServerResponse $Context "404"
			}
		}
		
	.INPUTS
		ServerPath as String, ServerPort as String
	
	.OUTPUTS
		Net.HttpListener
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string]$ServerPath,
		[Parameter(Mandatory)]
		[string]$ServerPort
	)
	$Server = New-Object Net.HttpListener
	$serverURL = $ServerPath + ':' + $ServerPort + '/'
	$Server.Prefixes.Add($serverURL)
	$Server.Start()
	return $Server
}

function Stop-WebServer {
<#
    .SYNOPSIS
		Stops a WebServer
			 
	.DESCRIPTION
		This function stops a WebServer
	
	.PARAMETER Server
		The server object

	.EXAMPLE
		Stop-WebServer $Server
		
	.EXAMPLE
		Stop-WebServer -server $Server
	
	.EXAMPLE
		$Server | Stop-WebServer

	.EXAMPLE
		#PS
		$Server = Start-WebServer http://localhost 5051
		while (1){
			#Script pauses on the line below until $Context contains a value
			$Context = Get-WebServerContext $Server
			$Path = Get-WebServerLocalPath $Context
			if ($Path -eq "/") {
				Set-WebServerResponse $Context "Hello World"
			}
			elseif ($Path -eq "/Beans") {
				Set-WebServerResponse $Context "Beans"
			}
			elseif($Path -eq "/SecretStop") {
				Stop-WebServer $Server
			exit
			}
			else{
				Set-WebServerResponse $Context "404"
			}
		}
		
	.INPUTS
		Server as Object
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Server
	)
	$Server.Stop()
}

function Get-WebServerContext {
<#
    .SYNOPSIS
		Gets a client request
			 
	.DESCRIPTION
		This function gets a client request
	
	.PARAMETER Server
		The server object

	.EXAMPLE
		$Context = Get-WebServerContext $Server
		
	.EXAMPLE
		$Context = Get-WebServerContext -server $Server
	
	.EXAMPLE
		$Context = $Server | Get-WebServerContext

	.EXAMPLE
		#PS
		$Server = Start-WebServer http://localhost 5051
		while (1){
			#Script pauses on the line below until $Context contains a value
			$Context = Get-WebServerContext $Server
			$Path = Get-WebServerLocalPath $Context
			if ($Path -eq "/") {
				Set-WebServerResponse $Context "Hello World"
			}
			elseif ($Path -eq "/Beans") {
				Set-WebServerResponse $Context "Beans"
			}
			elseif($Path -eq "/SecretStop") {
				Stop-WebServer $Server
			exit
			}
			else{
				Set-WebServerResponse $Context "404"
			}
		}
		
	.INPUTS
		Server as Object
	
	.OUTPUTS
		Client Context
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Server
	)
    return $Server.GetContext()
}

function Get-WebServerLocalPath {
<#
    .SYNOPSIS
		Gets the path of a client request
			 
	.DESCRIPTION
		This function gets the path of a client request
	
	.PARAMETER Context
		The client context request

	.EXAMPLE
		$Path = Get-WebServerLocalPath $Context
		
	.EXAMPLE
		$Path = Get-WebServerLocalPath -context $Context
	
	.EXAMPLE
		$Path = $Context | Get-WebServerLocalPath
		
	.EXAMPLE
		#PS
		$Server = Start-WebServer http://localhost 5051
		while (1){
			#Script pauses on the line below until $Context contains a value
			$Context = Get-WebServerContext $Server
			$Path = Get-WebServerLocalPath $Context
			if ($Path -eq "/") {
				Set-WebServerResponse $Context "Hello World"
			}
			elseif ($Path -eq "/Beans") {
				Set-WebServerResponse $Context "Beans"
			}
			elseif($Path -eq "/SecretStop") {
				Stop-WebServer $Server
			exit
			}
			else{
				Set-WebServerResponse $Context "404"
			}
		}
		
	.INPUTS
		Context as Object
	
	.OUTPUTS
		LocalPath as String
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Context
	)
    return $Context.Request.Url.LocalPath
}

function Set-WebServerResponse {
<#
    .SYNOPSIS
		Generates a response to a client request
			 
	.DESCRIPTION
		This function generates a response to a client request
	
	.PARAMETER Context
		The client context request
	
	.PARAMETER Response
		The response to the client request

	.EXAMPLE
		Set-WebServerResponse $Context "404"
		
	.EXAMPLE
		Set-WebServerResponse -context $Context -response "404"
	
	.EXAMPLE
		$Context | Set-WebServerResponse -response "404"
		
	.EXAMPLE
		#PS
		$Server = Start-WebServer http://localhost 5051
		while (1){
			#Script pauses on the line below until $Context contains a value
			$Context = Get-WebServerContext $Server
			$Path = Get-WebServerLocalPath $Context
			if ($Path -eq "/") {
				Set-WebServerResponse $Context "Hello World"
			}
			elseif ($Path -eq "/Beans") {
				Set-WebServerResponse $Context "Beans"
			}
			elseif($Path -eq "/SecretStop") {
				Stop-WebServer $Server
			exit
			}
			else{
				Set-WebServerResponse $Context "404"
			}
		}
		
	.INPUTS
		Context as Object
	
	.OUTPUTS
		LocalPath as String
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[object]$Context,
		[string]$Response
	)
	$buffer = [System.Text.Encoding]::ASCII.GetBytes($Response)
	$Context.Response.ContentLength64 = ($buffer.length)
	$Context.Response.OutputStream.Write($buffer, 0, $buffer.length)
	$Context.Response.Close()
}

function Get-FreeMemory {
<#
    .SYNOPSIS
		Returns the free memory in kilobytes
		
    .DESCRIPTION
		This function returns the free memory in kilobytes

	.EXAMPLE
		$memory = Get-FreeMemory

#>
	return (Get-CIMInstance Win32_OperatingSystem | Select FreePhysicalMemory).FreePhysicalMemory
}

function Get-ScreenHeight {
<#
    .SYNOPSIS
		Returns screen physical screen height as a PSCustomObject
		
    .DESCRIPTION
		This function returns screen physical screen height as a PSCustomObject
	
	.EXAMPLE
		$ScreenHeight = Get-ScreenHeight
		$ScreenHeight.Primary
		$ScreenHeight.Screen1
	
	.OUTPUTS
		PSCustomObject
	
	.NOTES
		The 'Primary' attribute of the object returns the primary screen. Each
		screen height is returned in the Screen# property.
#>
	$return = [PSCustomObject] | Select-Object -Property Primary
	$i = 1
	foreach ($screen in [system.windows.forms.screen]::AllScreens) {
		$return | Add-Member -NotePropertyName "Screen$($i)" -NotePropertyValue $screen.Bounds.Height
		if ($screen.Primary) {
			$return.Primary = "Screen$($i)"
		}
		$i = $i + 1
	}
	return $return
}

function Get-ScreenWidth {
<#
    .SYNOPSIS
		Returns screen physical screen width as a PSCustomObject
		
    .DESCRIPTION
		This function returns screen physical screen width as a PSCustomObject
	
	.EXAMPLE
		$ScreenWidth = Get-ScreenWidth
		$ScreenWidth.Primary
		$ScreenWidth.Screen1
	
	.OUTPUTS
		PSCustomObject
	
	.NOTES
		The 'Primary' attribute of the object returns the primary screen. Each
		screen Width is returned in the Screen# property.
#>
	$return = [PSCustomObject] | Select-Object -Property Primary
	$i = 1
	foreach ($screen in [system.windows.forms.screen]::AllScreens) {
		$return | Add-Member -NotePropertyName "Screen$($i)" -NotePropertyValue $screen.Bounds.Width
		if ($screen.Primary) {
			$return.Primary = "Screen$($i)"
		}
		$i = $i + 1
	}
	return $return
}

function Get-WindowsVersion {
<#
    .SYNOPSIS
		Returns the current version of Microsoft Windows.

    .DESCRIPTION
		This function returns the current version of Microsoft Windows.

	.EXAMPLE
		$WinVersion = Get-WindowsVersion
#>
	$major = [System.Environment]::OSVersion.Version | Select-Object -expandproperty Major | Out-String
	$minor = [System.Environment]::OSVersion.Version | Select-Object -expandproperty Minor | Out-String
	$build = [System.Environment]::OSVersion.Version | Select-Object -expandproperty Build | Out-String
	$revision = [System.Environment]::OSVersion.Version | Select-Object -expandproperty Revision | Out-String
	return $major.Trim()+'.'+$minor.Trim()+'.'+$build.Trim()+'.'+$revision.Trim()
}

function Get-OSWordSize {
<#
    .SYNOPSIS
		Returns the current version of Microsoft Windows.
	
    .DESCRIPTION
		This function returns the current version of Microsoft Windows.

	.EXAMPLE
		$Bitness = Get-OSWordSize
#>
	return ([IntPtr]::size * 8)
}

function Get-PowerShellVersion {
<#
    .SYNOPSIS
		Returns the current version of PowerShell.

    .DESCRIPTION
		This function returns the current version of PowerShell.

	.EXAMPLE
		$PSVersion = Get-PowerShellVersion
#>
	$major = $psversiontable.psversion.major | Out-String
	$minor = $psversiontable.psversion.minor | Out-String
	$build = $psversiontable.psversion.build | Out-String
	$revision = $psversiontable.psversion.revision | Out-String
	return $major.Trim()+'.'+$minor.Trim()+'.'+$build.Trim()+'.'+$revision.Trim()
}

function Get-VisualDesignerShellVersion {
<#
    .SYNOPSIS
		Returns the current version of Visual Designer Shell.

    .DESCRIPTION
		This function returns the current version of Visual Designer Shell.

	.EXAMPLE
		$VDSVersion = Get-VisualDesignerShellVersion
#>
	return 4.0.0.0
}

function Get-BootTime {
<#
    .SYNOPSIS
		Returns the system boot time

    .DESCRIPTION
		This function returns the system boot time

	.EXAMPLE
		$BootTime = Get-BootTime
#>
	$return = Get-CimInstance -ClassName win32_operatingsystem | fl lastbootuptime | Out-String
	$return = $return.split('e')[1].Trim()
	$return = $(Get-Substring $return 2 $return.length)
	return $return
}

function Get-SystemLanguage {
<#
    .SYNOPSIS
		Returns the system language

    .DESCRIPTION
		This function returns the system language

	.EXAMPLE
		$Lang = Get-SystemLanguage
#>
	return Get-UICulture.Name
}

function Show-TaskBar {
<#
    .SYNOPSIS
		Shows the taskbar
     
    .DESCRIPTION
		This function will show the taskbar
		
	.EXAMPLE
		Show-TaskBar
#>
	$hWnd = [vds]::FindWindowByClass("Shell_TrayWnd")
	[vds]::ShowWindow($hWnd, "SW_SHOW_DEFAULT")
}

function Hide-TaskBar {
<#
    .SYNOPSIS
		Hides the taskbar
     
    .DESCRIPTION
		This function will hide the taskbar
		
	.EXAMPLE
		Hide-TaskBar
#>
	$hWnd = [vds]::FindWindowByClass("Shell_TrayWnd")
	[vds]::ShowWindow($hWnd, "SW_HIDE")	
}

function Get-ActiveWindow {
<#
    .SYNOPSIS
		Returns the handle of the active window
			 
	.DESCRIPTION
		This function returns the handle of the active window

	.EXAMPLE
		$winactive = Get-ActiveWindow
	
	.OUTPUTS
		Handle
#>
	return [vds]::GetForegroundWindow()
}

function Get-WindowFromPoint {
<#
    .SYNOPSIS
		Returns the window panel from an x y point
			 
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

function Get-ChildWindow {
<#
    .SYNOPSIS
		Gets the first child window handle from a window handle
			 
	.DESCRIPTION
		This function gets the first child window handle from a window handle

	.PARAMETER Handle
		The handle of the parent window

	.EXAMPLE
		$child = Get-ChildWindow (Get-WindowExists notepad)

	.EXAMPLE
		$child = Get-ChildWindow -handle (Get-WindowExists notepad)
		
	.EXAMPLE
		$child = (Get-WindowExists notepad) | Get-ChildWindow
		
	.INPUTS
		Handle as Handle
	
	.OUTPUTS
		Handle
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
	return [vds]::GetWindow($Handle, 5)
}

function Get-WindowClass {
<#
    .SYNOPSIS
		Gets the class of a window by handle
			 
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

function Move-Window {
<#
    .SYNOPSIS
		Moves a window
			 
	.DESCRIPTION
		This function moves a window per left, top, width and height parameters

	.PARAMETER Handle
		The handle of the window
	
	.PARAMETER Left
		The left position of the window
		
	.PARAMETER Top
		The top position of the window
	
	.PARAMETER Width
		The width of the window
	
	.PARAMETER Height
		The height of the window

	.EXAMPLE
		Move-Window -handle (Get-WindowExists "Untitled - Notepad") 10 100 1000 100

	.EXAMPLE
		Move-Window -handle (Get-WindowExists "Untitled - Notepad") -left 10 -height 100 -width 1000 -height 100
		
	.EXAMPLE
		(Get-WindowExists "Untitled - Notepad") | Move-Window -left 10 -height 100 -width 1000 -height 100
		
	.INPUTS
		Handle as Handle
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle,
		[Parameter(Mandatory)]
		[int]$Left,
		[Parameter(Mandatory)]
		[int]$Top,
		[Parameter(Mandatory)]
		[int]$Width,
		[Parameter(Mandatory)]
		[int]$Height
	)
	[vds]::MoveWindow($Handle,$Left,$Top,$Width,$Height,$true)
}

function Get-WindowPosition {
<#
    .SYNOPSIS
		Returns an object with Left, Top, Width and Height properties of a windows position
			 
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

function Send-ClickToWindow {
<#
    .SYNOPSIS
		Sends a click to a window by the handle, x and y specified.
			 
	.DESCRIPTION
		This function sends a click to a window by the handle, x and y specified.

	.PARAMETER Handle
		The handle of the window
		
	.PARAMETER x
		The x position for the click
	
	.PARAMETER y
		The y position for the click

	.EXAMPLE
		Send-ClickToWindow (Get-WindowExists "Untitled - Notepad") 25 50

	.EXAMPLE
		Send-ClickToWindow -handle (Get-WindowExists "Untitled - Notepad") 25 50
		
	.EXAMPLE
		(Get-WindowExists "Untitled - Notepad") | Send-ClickToWindow 25 50
		
	.INPUTS
		Handle as Handle
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle,
		[Parameter(Mandatory)]
		[int]$x,
		[Parameter(Mandatory)]
		[int]$y
	)
	Set-ActiveWindow $Handle
	$yp = $y + (Get-WindowPosition $Handle).Top
	$xp = $x + (Get-WindowPosition $Handle).Left
	[vds]::LeftClickAtPoint($xp,$yp,[System.Windows.Forms.Screen]::PrimaryScreen.bounds.width,[System.Windows.Forms.Screen]::PrimaryScreen.bounds.height) | out-null
}

function Send-RightClickToWindow {
<#
    .SYNOPSIS
		Sends a right click to a window by the handle, x and y specified.
			 
	.DESCRIPTION
		This function sends a right click to a window by the handle, x and y specified.

	.PARAMETER Handle
		The handle of the window
		
	.PARAMETER x
		The x position for the click
	
	.PARAMETER y
		The y position for the click

	.EXAMPLE
		Send-RightClickToWindow (Get-WindowExists "Untitled - Notepad") 25 50

	.EXAMPLE
		Send-RightClickToWindow -handle (Get-WindowExists "Untitled - Notepad") 25 50
		
	.EXAMPLE
		(Get-WindowExists "Untitled - Notepad") | Send-RightClickToWindow 25 50
		
	.INPUTS
		Handle as Handle
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle,
		[Parameter(Mandatory)]
		[int]$x,
		[Parameter(Mandatory)]
		[int]$y
	)
	Set-ActiveWindow $Handle
	$yp = $y + (Get-WindowPosition $Handle).Top
	$xp = $x + (Get-WindowPosition $Handle).Left
	[vds]::RightClickAtPoint($xp,$yp,[System.Windows.Forms.Screen]::PrimaryScreen.bounds.width,[System.Windows.Forms.Screen]::PrimaryScreen.bounds.height) | out-null
}

function Close-Window {
<#
    .SYNOPSIS
		Closes a window
			 
	.DESCRIPTION
		This function closes a window

	.PARAMETER Handle
		The handle of the window

	.EXAMPLE
		Close-Window (Get-WindowExists "Untitled - Notepad")

	.EXAMPLE
		Close-Window -handle (Get-WindowExists "Untitled - Notepad")
		
	.EXAMPLE
		(Get-WindowExists "Untitled - Notepad") | Close-Window
		
	.INPUTS
		Handle as Handle
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
	New-SendMessage $Handle 0x0112 0xF060 0
}

function Set-FlashWindow {
<#
    .SYNOPSIS
		Flashes the icon of a window
			 
	.DESCRIPTION
		This function flashes the tasktray icon of a window

	.PARAMETER Handle
		The handle of the window

	.EXAMPLE
		Set-FlashWindow (Get-WindowExists "Untitled - Notepad")

	.EXAMPLE
		Set-FlashWindow -handle (Get-WindowExists "Untitled - Notepad")
		
	.EXAMPLE
		(Get-WindowExists "Untitled - Notepad") | Set-FlashWindow
		
	.INPUTS
		Handle as Handle
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
	[Window]::FlashWindow($Handle,150,10)
}

function Set-WindowParent {
<#
    .SYNOPSIS
		This function fuses a window into another window
			 
	.DESCRIPTION
		This function fuses a child window into a parent window

	.PARAMETER Child
		The child window
		
	.PARAMETER Parent
		The parent window

	.EXAMPLE
		Set-WindowParent (Get-WindowExists "Untitled - Notepad") (Get-WindowExists "Libraries") 

	.EXAMPLE
		Set-WindowParent -child (Get-WindowExists "Untitled - Notepad") -parent (Get-WindowExists "Libraries")
		
	.EXAMPLE
		(Get-WindowExists "Untitled - Notepad") | Set-WindowParent -parent (Get-WindowExists "Libraries")
		
	.INPUTS
		Child as Handle,Parent as Handle
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Child,
        [Parameter(Mandatory)]
		[int]$Parent
	)
	[vds]::SetParent($Child,$Parent)
}

function Hide-Window {
<#
    .SYNOPSIS
		Hides a window
			 
	.DESCRIPTION
		This function hides a window

	.PARAMETER Handle
		The handle of the window

	.EXAMPLE
		Hide-Window (Get-WindowExists "Untitled - Notepad")

	.EXAMPLE
		Hide-Window -handle (Get-WindowExists "Untitled - Notepad")
		
	.EXAMPLE
		(Get-WindowExists "Untitled - Notepad") | Hide-Window
		
	.INPUTS
		Handle as Handle
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
	[vds]::ShowWindow($Handle, "SW_HIDE")
}

function Show-Window {
<#
    .SYNOPSIS
		Shows a window
			 
	.DESCRIPTION
		This function shows a window

	.PARAMETER Handle
		The handle of the window

	.EXAMPLE
		Show-Window (Get-WindowExists "Untitled - Notepad")

	.EXAMPLE
		Show-Window -handle (Get-WindowExists "Untitled - Notepad")
		
	.EXAMPLE
		(Get-WindowExists "Untitled - Notepad") | Show-Window
		
	.INPUTS
		Handle as Handle
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
	[vds]::ShowWindow($Handle, "SW_SHOW_NORMAL")
}

function Compress-Window {
<#
    .SYNOPSIS
		Minimizes a window
			 
	.DESCRIPTION
		This function minimizes a window

	.PARAMETER Handle
		The handle of the window

	.EXAMPLE
		Compress-Window (Get-WindowExists "Untitled - Notepad")

	.EXAMPLE
		Compress-Window -handle (Get-WindowExists "Untitled - Notepad")
		
	.EXAMPLE
		(Get-WindowExists "Untitled - Notepad") | Compress-Window
		
	.INPUTS
		Handle as Handle
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
	[vds]::ShowWindow($Handle, "SW_MINIMIZE")
}

function Expand-Window {
<#
    .SYNOPSIS
		Maximizes a window
			 
	.DESCRIPTION
		This function maximizes a window

	.PARAMETER Handle
		The handle of the window

	.EXAMPLE
		Expand-Window (Get-WindowExists "Untitled - Notepad")

	.EXAMPLE
		Expand-Window -handle (Get-WindowExists "Untitled - Notepad")
		
	.EXAMPLE
		(Get-WindowExists "Untitled - Notepad") | Expand-Window
		
	.INPUTS
		Handle as Handle
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
	[vds]::ShowWindow($Handle, "SW_MAXIMIZE")
}

function Set-WindowOnTop {
<#
    .SYNOPSIS
		Causes a window to be on top of other windows
			 
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
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
	[vds]::SetWindowPos($Handle, -1, (Get-WindowPosition $Handle).Left, (Get-WindowPosition $Handle).Top, (Get-WindowPosition $Handle).Width, (Get-WindowPosition $Handle).Height, 0x0040) | out-null
}

function Set-WindowNotOnTop {
<#
    .SYNOPSIS
		Causes a window to not be on top of other windows
			 
	.DESCRIPTION
		This function causes a window to not be on top of other windows

	.PARAMETER Handle
		The handle of the window

	.EXAMPLE
		Set-WindowNotOnTop (Get-WindowExists "Untitled - Notepad")

	.EXAMPLE
		Set-WindowNotOnTop -handle (Get-WindowExists "Untitled - Notepad")
		
	.EXAMPLE
		(Get-WindowExists "Untitled - Notepad") | Set-WindowNotOnTop
		
	.INPUTS
		Handle as Handle
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
	[vds]::SetWindowPos($Handle, -2, (Get-WindowPosition $Handle).Left, (Get-WindowPosition $Handle).Top, (Get-WindowPosition $Handle).Width, (Get-WindowPosition $Handle).Height, 0x0040) | out-null
}

function Set-WindowText {
<#
    .SYNOPSIS
		Sets the text of a window
			 
	.DESCRIPTION
		This function sets the text of a window

	.PARAMETER Handle
		The handle of the window
		
	.PARAMETER Text
		The text to set the window to

	.EXAMPLE
		Set-WindowText (Get-WindowExists "Untitled - Notepad") "Hello World"

	.EXAMPLE
		Set-WindowText -handle (Get-WindowExists "Untitled - Notepad") -text "Hello World"
		
	.EXAMPLE
		(Get-WindowExists "Untitled - Notepad") | Set-WindowText -text "Hello World"
		
	.INPUTS
		Handle as Handle, String as String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle,
		[string]$Text
	)
	[vds]::SetWindowText($Handle,$Text)
}

function Get-WindowExists {
<#
    .SYNOPSIS
		Returns the handle of a window, or null if it doesn't exists
			 
	.DESCRIPTION
		This function returns the handle of a window, or null if it doesn't exists

	.PARAMETER Window
		The title of a window, the class of a window, or the window as a powershell object

	.EXAMPLE
		Set-WindowText (Get-WindowExists "Untitled - Notepad") "Hello World"

	.EXAMPLE
		Set-WindowText -handle (Get-WindowExists -window "Untitled - Notepad") -text "Hello World"
		
	.EXAMPLE
		("Untitled - Notepad" | Get-WindowExists) | Set-WindowText -text "Hello World"
		
	.INPUTS
		Window as String
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Window
	)
    $class = [vds]::FindWindowByClass($Window)
    if ($class) {
        return $class/1
    }
    else {
        $title = [vds]::FindWindowByTitle($Window)
        if ($title){
            return $title/1
        }
        else {
            if ($Window.handle) {
                return $Window.handle
            }
        }   
    }
}

function Get-WindowParent {
<#
    .SYNOPSIS
		Returns the handle of a windows parent
			 
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
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
	return [vds]::GetParent($Handle)
}

function Get-WindowSibling {
<#
    .SYNOPSIS
		Returns the sibling of a window
			 
	.DESCRIPTION
		This function returns the sibling of a window
		
	.PARAMETER Handle
		The handle of the window to return the sibling of

	.EXAMPLE
		$winsibling = Get-WindowSibling (Get-WindowExists "Untitled - Notepad")

	.EXAMPLE
		$winsibling = Get-WindowSibling -handle (Get-WindowExists "Untitled - Notepad")
		
	.EXAMPLE
		$winsibling = (Get-ChildWindow "Libraries") | Get-WindowSibling
		
	.INPUTS
		Handle as Integer
	
	.OUTPUTS
		Integer
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [int]$Handle
	)
	return [vds]::GetWindow($Handle, 2)
}

function Get-WindowText {
<#
    .SYNOPSIS
		Returns the text of a window
			 
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

function EndCustomFunctions{}

#endregion

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
				$generationPath = "$(Split-Path -Path $global:projectDirName)\$($projectName -replace "\..*$")"
				$designerpath = "$(get-currentdirectory)\designer.ps1"
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
    <TabControl Name="tcl_Top" Dock="Top" Size="358, 20">
      <TabPage Name="tpg_Form1" Size="350, 0" Text="NewProject.fbs" />
    </TabControl>
    <Label Name="lbl_Left" Dock="Left" BackColor="35, 35, 35" Cursor="VSplit" Size="3, 570" />
    <Label Name="lbl_Right" Dock="Right" BackColor="35, 35, 35" Cursor="VSplit" Size="3, 570" />
    <Panel Name="pnl_Left" Dock="Left" BorderStyle="Fixed3D" Size="200, 570">
      <SplitContainer Name="spt_Left" Dock="Fill" BackColor="ControlDark" Orientation="Horizontal" SplitterDistance="278">
        <SplitterPanel Name="spt_Left_Panel1">
          <TreeView Name="trv_Controls" Dock="Fill" BackColor="Azure" />
        </SplitterPanel>
        <SplitterPanel Name="spt_Left_Panel2" BackColor="ControlLight">
          <TreeView Name="TreeView" Dock="Fill" BackColor="Azure" DrawMode="OwnerDrawText" HideSelection="False" />
        </SplitterPanel>
      </SplitContainer>
    </Panel>
    <Panel Name="pnl_Right" Dock="Right" BorderStyle="Fixed3D" Size="200, 570">
      <SplitContainer Name="spt_Right" Dock="Fill" BackColor="ControlDark" Orientation="Horizontal" SplitterDistance="210">
        <SplitterPanel Name="spt_Right_Panel1">
          <PropertyGrid Name="PropertyGrid" Dock="Fill" ViewBackColor="Azure" />
        </SplitterPanel>
        <SplitterPanel Name="spt_Right_Panel2" BackColor="Control">
          <TabControl Name="TabControl2" Dock="Fill">
            <TabPage Name="Tab 1" Size="188, 326" Text="Events">
              <SplitContainer Name="SplitContainer3" Dock="Fill" Orientation="Horizontal" SplitterDistance="144">
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
            <TabPage Name="TabPage3" Size="188, 144" Text="Functions">
              <CheckedListBox Name="lst_Functions" Dock="Fill" BackColor="Azure" />
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

				$designerpath = "$(get-currentdirectory)\designer.ps1"
				New-Variable astTokens -Force
				New-Variable astErr -Force
				$AST = [System.Management.Automation.Language.Parser]::ParseFile($designerpath, [ref]$astTokens, [ref]$astErr)
				$functions = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)

for ( $i=0;$i -le $functions.count -10;$i++ ) {
	$lst_Functions.Items.Add("$($functions[$i].name)")
#	$lst_Functions.SetItemChecked($i,$true)
}

for ( $i=0;$i -le 6;$i++ ) {
#	$lst_Functions.Items.Add("$($functions[$i].name)")
	$lst_Functions.SetItemChecked($i,$true)
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

function FunctionTimer{}
$functionTimer = (New-Timer -Interval 1000)

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
	
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-Types"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-EnableVisualStyle"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-DPIAware"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Show-Form"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Update-ErrorLog"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-CurrentDirectory"), $true)
	$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("ConvertFrom-WinFormsXML"), $true)
	
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
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Stop-WebServer")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Start-WebServer"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-WebServerContext"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-WebServerLocalPath"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-WebServerResponse"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Get-WebServerContext")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Start-WebServer"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Stop-WebServer"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-WebServerLocalPath"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-WebServerResponse"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Get-WebServerLocalPath")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Start-WebServer"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Stop-WebServer"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-WebServerContext"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Set-WebServerResponse"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Set-WebServerResponse")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Start-WebServer"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Stop-WebServer"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-WebServerContext"), $true)
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-WebServerLocalPath"), $true)
	}
	
	if ($lst_Functions.GetItemChecked($lst_Functions.Items.IndexOf("Get-StringRemove")) -eq $True) {
		$lst_Functions.SetItemChecked($lst_Functions.Items.IndexOf("Get-SubString"), $true)
	}

	if ($lst_Functions.SelectedIndex -ne -1){
		$global:functionSelItem = $lst_Functions.SelectedItem.ToString()
	}
	else {
		$global:functionSelItem = "[null]"
	}
})



	$lst_Functions.add_Click({param($sender, $e)
	
	
		if ($global:functionSelItem -eq $lst_Functions.SelectedItem.ToString()){
			return
		}
	
		#$lst_Functions.items.add($lst_Functions.SelectedItem.ToString())
		$ast = (Get-Command $lst_Functions.SelectedItem.ToString()).ScriptBlock.Ast
		$parameters = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.ParameterAst] }, $true)
		#$lst_Functions.items.add($parameters.count)
		
		$bldStr = "
"
		$bldStr = "$bldStr<# $($lst_Functions.SelectedItem.ToString())"
		foreach ($param in $parameters){
			$bldStr = "$bldStr 
			
$param"
		}
		
		$bldStr = "$bldStr
#>
"
		$FastText.SelectedText = "$bldStr"
		
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
