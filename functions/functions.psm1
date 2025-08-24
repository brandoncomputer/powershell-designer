<#
This project merges a restyled Visual DialogShell vds 0.3.38 and 
powershell-designer 2.1.7
The intent of this project is to bring the functionality of Visual DialogShell
into PowerShell refactoring from the Visual DialogScript style guide and 
switching to the PowerShell style guide. In addition, this project will
refactor the output of scripts generated with powershell-designer to better
conform with the PowerShell style guide. This project breaks compatibility with
code written in Visual DialogShell, even so, it supercedes that previous
product and contains bug fixes that will not be implemented in the previous 
project. Compatibility will be maintained with powershell-designer 2.1.7 but may
include bug fixes not found in the previous product. 

MIT License

Copyright (c) 2024 Brandon Cunningham

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

function Add-Alt {
<#
    .SYNOPSIS
        Sends the ALT key plus string.

    .ALIASES
        Alt

    .DESCRIPTION
        Prepends the string parameter with the ALT key symbol `%` for use in Send-Window sequences.

    .PARAMETER TextValue
        The text to be prefixed with ALT.

    .EXAMPLE
        $altfs = "$(Add-Alt F) S"

    .EXAMPLE
        $altfs = "$(Add-Alt -TextValue F) S"

    .EXAMPLE
        $altfs = "$('F' | Add-Alt) S"

    .EXAMPLE
        Send-Window (Get-Window notepad) "$(Add-Alt F) S"

    .INPUTS
        [string]

    .OUTPUTS
        [string]

    .NOTES
        Only useful with 'Send-Window'.
#>
    [Alias("Alt")]
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$TextValue
    )

    Write-Output "%$TextValue"
}

function Add-CommonControl {
<#
    .SYNOPSIS
        Adds a common control to a vdsForm object

    ALIASES
        Dialog-Add

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

    .PARAMETER Height
        The value of the Height property of the control.

    .PARAMETER LabelText
        The value of the Text property of the control.

    .EXAMPLE
        $Button1 = Add-CommonControl $Form1 Button 60 30 200 25 "Execute"

    .EXAMPLE
        $TextBox1 = Add-CommonControl -Form $Form1 -ControlType TextBox -Top 30 -Left 30 -Width 200 -Height 25 

    .EXAMPLE
        $TextBox1 = $Form1 | Add-CommonControl -ControlType TextBox -Top 30 -Left 30 -Width 200 -Height 25 

    .INPUTS
        Form as Object, ControlType as ValidatedString, Top as Int, Left as Int, Width as Int, Height as Int, LabelText as String

    .OUTPUTS
        System Windows Forms (ControlType)

    .NOTES
        Normally precedented by the New-Form command.
#>
    [Alias("Dialog-Add")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$Form,

        [Parameter(Mandatory)]
        [ValidateSet('Button','CheckBox','CheckedListBox','ComboBox',
        'DataGrid','DataGridView','DateTimePicker','GroupBox','HScrollBar',
        'Label','LinkLabel','ListBox','MaskedTextBox','MonthCalendar',
        'NumericUpDown','Panel','PictureBox','ProgressBar','RadioButton',
        'RichTextBox','TextBox','TrackBar','TreeView','VScrollBar',
        'WebBrowser')]
        [string]$ControlType,

        [Parameter(Mandatory)]
        [int]$Top,

        [Parameter(Mandatory)]
        [int]$Left,

        [Parameter(Mandatory)]
        [int]$Width,

        [Parameter(Mandatory)]
        [int]$Height,

        [string]$LabelText
    )

    $Control = New-Object "System.Windows.Forms.$ControlType"
    $Control.Top = $Top * $ctscale
    $Control.Left = $Left * $ctscale
    $Control.Width = $Width * $ctscale
    $Control.Height = $Height * $ctscale
    $Control.Text = $LabelText
    $Form.Controls.Add($Control)
    return $Control
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
        $ContextMenuStrip1 = Add-ContextMenuStrip -Object $Taskicon1

    .EXAMPLE
        $CMenuStrip1 = $Form1 | Add-ContextMenuStrip

    .INPUTS
        Object as Object

    .OUTPUTS
        System.Windows.Forms.ContextMenuStrip
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$Object
    )

    if (-not ($Object -is [System.Windows.Forms.Control])) {
        throw "Object must be a Windows Forms control with a ContextMenuStrip property."
    }

    $MenuStrip = New-Object System.Windows.Forms.ContextMenuStrip
    $MenuStrip.ImageScalingSize = New-Object System.Drawing.Size([int]($ctscale * 16), [int]($ctscale * 16))
    $Object.ContextMenuStrip = $MenuStrip
    return $MenuStrip
}

function Add-ContextMenuStripItem {
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
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Windows.Forms.ContextMenuStrip]$ContextMenuStrip,
        [string]$Title,
        [string]$Image,
        [string]$ShortCutKeys
    )

    $MenuRow = New-Object System.Windows.Forms.ToolStripMenuItem

    if ($Image -ne "") {
        try {
            $MenuRow.Image = if ((Get-SubString $Image 0 2) -eq 'ht') {
                Get-ImageFromStream $Image
            } else {
                Get-ImageFromFile $Image
            }
        } catch {
            Write-Warning "Image load failed for '$Image'. Continuing without image."
        }
    }

if (-not [string]::IsNullOrWhiteSpace($ShortCutKeys)) {
    $MenuRow.ShortCutKeys = $ShortCutKeys
    $MenuRow.ShowShortCutKeys = $True
}

    $MenuRow.Name = $Title
    $MenuRow.Text = $Title
    $null = $ContextMenuStrip.Items.add($MenuRow)
    return $MenuRow
}

function Add-ContextMenuStripSeparator {
<#
    .SYNOPSIS
        Adds a separator to a context menu strip.

    .DESCRIPTION
        Inserts a ToolStripSeparator into the specified ContextMenuStrip.

    .PARAMETER ContextMenuStrip
        The ContextMenuStrip to modify.

    .EXAMPLE
        $Sep1 = Add-ContextMenuStripSeparator $TaskIcon1ContextMenu

    .EXAMPLE
        $Sep1 = Add-ContextMenuStripSeparator -ContextMenuStrip $TaskIcon1ContextMenu

    .EXAMPLE
        $Sep1 = $TaskIcon1ContextMenu | Add-ContextMenuStripSeparator

    .INPUTS
        System.Windows.Forms.ContextMenuStrip

    .OUTPUTS
        System.Windows.Forms.ToolStripSeparator
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Windows.Forms.ContextMenuStrip]$ContextMenuStrip
    )

    $Separator = New-Object System.Windows.Forms.ToolStripSeparator
    $null = $ContextMenuStrip.Items.Add($Separator)
    return $Separator
}

function Add-CTRL {
<#
    .SYNOPSIS
        Sends the CTRL key plus string. Only useful with 'Send-Window'.

    .ALIASES
        Ctrl

    .DESCRIPTION
        This function will prepend the string parameter with the Ctrl key,
        commonly specified by the '^' character.

    .PARAMETER TextValue
        The text being passed to the function.

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
    [Alias("Ctrl")]
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$TextValue
    )
    return "^$TextValue"
}

function Add-ExcelWorkbook {
<#
    .SYNOPSIS
        Adds a new Excel workbook to an initialized Excel.Application object.

    .DESCRIPTION
        This function adds a new workbook to an existing Excel COM object.
        It assumes the object is properly initialized and exposes a Workbooks collection.

    .PARAMETER Excel
        The initialized Excel.Application COM object.

    .EXAMPLE
        $Workbook = Add-ExcelWorkbook $ExcelObject

    .EXAMPLE
        $Workbook = Add-ExcelWorkbook -Excel $ExcelObject

    .EXAMPLE
        $Workbook = $ExcelObject | Add-ExcelWorkbook

    .INPUTS
        [Microsoft.Office.Interop.Excel.Application] via COM

    .OUTPUTS
        [Microsoft.Office.Interop.Excel.Workbook]
#>
    [CmdletBinding()]
    [OutputType([object])]  # You can refine this to [Microsoft.Office.Interop.Excel.Workbook] if strongly typed
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$Excel
    )

    if (-not ($Excel -and $Excel.Workbooks)) {
        throw "Invalid Excel object or missing Workbooks collection."
    }

    return $Excel.Workbooks.Add()
}

function Add-ExcelWorksheet {
<#
    .SYNOPSIS
        Adds a new Excel worksheet to an Excel workbook.

    .DESCRIPTION
        This function adds a new worksheet to a valid Excel workbook object.
        It assumes the workbook exposes a Worksheets collection.

    .PARAMETER Workbook
        The Excel workbook COM object to which a worksheet will be added.

    .EXAMPLE
        $Worksheet = Add-ExcelWorksheet $Workbook

    .EXAMPLE
        $Worksheet = Add-ExcelWorksheet -Workbook $Workbook

    .EXAMPLE
        $Worksheet = $Workbook | Add-ExcelWorksheet

    .INPUTS
        [Microsoft.Office.Interop.Excel.Workbook]

    .OUTPUTS
        [Microsoft.Office.Interop.Excel.Worksheet]
#>
    [CmdletBinding()]
    [OutputType([object])]  # Can be refined to [Microsoft.Office.Interop.Excel.Worksheet] if strongly typed
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$Workbook
    )

    if (-not ($Workbook -and $Workbook.Worksheets)) {
        throw "Invalid Workbook object or missing Worksheets collection."
    }

    return $Workbook.Worksheets.Add()
}

function Add-Font {
<#
    .SYNOPSIS
        Installs a font using Shell.Application COM method.

    .DESCRIPTION
        Uses the Windows Fonts shell namespace (0x14) to install a font file.
        Silent copy with no progress dialog.

    .PARAMETER Path
        The full path to the font file (.ttf, .otf, etc.).

    .EXAMPLE
        'C:\Temp\cgtr66w.ttf' | Add-Font
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Path
    )

    $resolvedPath = (Resolve-Path $Path).Path

    try {
        $shellapp = New-Object -ComObject Shell.Application
        $Fonts = $shellapp.NameSpace(0x14)
        $Fonts.CopyHere($resolvedPath, 0x10)
    } catch {
        throw "Font installation failed via COM. Error: $_"
    }
}

function Add-Hotkey {
<#
    .SYNOPSIS
        Registers a global hotkey to a form.

    .ALIAS
        Hotkey-Add

    .DESCRIPTION
        This function registers a hotkey to a form of type vdsForm.

    .PARAMETER Form
        The form to register the hotkey to.

    .EXAMPLE
        Add-Hotkey $Form1 1 ((Get-VirtualKey Alt)+(Get-VirtualKey Control)) (Get-VirtualKey v)
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
        Add-Hotkey -Form $Form1 -RegisterIndex 1 -ModifierVirtualKeys $null -VirtualKey (Get-VirtualKey F1)

    .EXAMPLE
        $Form1 | Add-Hotkey -RegisterIndex 1 -ModifierVirtualKeys $null -VirtualKey (Get-VirtualKey F1)

    .INPUTS
        Form as vdsForm, RegisterIndex as Integer,
        ModifierVirtualKeys as UInt32,
        VirtualKey as UInt32

    .OUTPUTS
        Registered Event

    .NOTES
        The use of this function REQUIRES the event to be caught by the
        hotkeyEvent function which processes the event by hotkey index.
#>
    [Alias("Hotkey-Add", "Hotkey")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [vdsForm]$Form,

        [Parameter(Mandatory)]
        [int]$RegisterIndex,

        [uint32]$ModifierVirtualKeys,

        [Parameter(Mandatory)]
        [uint32]$VirtualKey
    )

    [vdsForm]::RegisterHotKey($Form.handle, $RegisterIndex, $ModifierVirtualKeys, $VirtualKey) | Out-Null

    if ($global:hotkeyobject -ne $true) {
        $hotkey = Add-CommonControl -Form $Form -ControlType 'label' -top 0 -left 0 -width 0 -height 0
        $hotkey.Name = 'hotkey'
        $hotkey.add_TextChanged({
            if ($this.text -ne "") {
                hotkeyEvent $this.text
            }
            $this.text = ""
        })
        $global:hotkeyobject = $true
    }
}

function Add-MenuColumn {
<#
    .SYNOPSIS
        Adds a Menu column header to an existing MenuStrip control.

    .DESCRIPTION
        This function will add a menu column header tool strip menu item to an 
        existing MenuStrip control.

    .PARAMETER MenuStrip
        The MenuStrip to add a column header to.

    .PARAMETER Title
        The title to apply to the column header.

    .EXAMPLE
        $FileColumn = Add-MenuColumn $MenuStrip1 "&File"

    .EXAMPLE
        $FileColumn = Add-MenuColumn -MenuStrip $MenuStrip1 -Title "&File"

    .EXAMPLE
        $FileColumn = $MenuStrip1 | Add-MenuColumn -Title "&File"

    .INPUTS
        MenuStrip as System.Windows.Forms.MenuStrip, Title as String

    .OUTPUTS
        System.Windows.Forms.ToolStripMenuItem
#>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.ToolStripMenuItem])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Windows.Forms.MenuStrip]$MenuStrip,
        [string]$Title
    )

    $MenuColumn = New-Object System.Windows.Forms.ToolStripMenuItem
    $MenuColumn.Name = $Title
    $MenuColumn.Text = $Title
    $MenuStrip.Items.Add($MenuColumn) | Out-Null
    return $MenuColumn
}

function Add-MenuColumnSeparator {
<#
    .SYNOPSIS
        Adds a separator in the rows of a menu column.

    .DESCRIPTION
        This function adds a ToolStripSeparator to the DropDownItems of a ToolStripMenuItem.

    .PARAMETER MenuColumn
        The ToolStripMenuItem to add a separator to.

    .EXAMPLE
        $Sep1 = Add-MenuColumnSeparator $FileMenu

    .EXAMPLE
        $Sep1 = Add-MenuColumnSeparator -MenuColumn $FileMenu

    .EXAMPLE
        $Sep1 = $FileMenu | Add-MenuColumnSeparator

    .INPUTS
        System.Windows.Forms.ToolStripMenuItem

    .OUTPUTS
        System.Windows.Forms.ToolStripSeparator
#>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.ToolStripSeparator])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Windows.Forms.ToolStripMenuItem]$MenuColumn
    )

    $item = New-Object System.Windows.Forms.ToolStripSeparator
    $null = $MenuColumn.DropDownItems.Add($item)
    return $item
}

function Add-MenuRow {
<#
    .SYNOPSIS
        Adds a menu row item to an existing menu column or context menu.

    .DESCRIPTION
        This function adds a ToolStripMenuItem to the DropDownItems of a ToolStripMenuItem
        or ContextMenuStrip, optionally with an image and shortcut key.

    .PARAMETER MenuColumn
        The ToolStripMenuItem or ContextMenuStrip to add the row to.

    .PARAMETER Title
        The display text for the menu row.

    .PARAMETER Image
        The image path or stream source to apply to the menu row item.

    .PARAMETER ShortCutKeys
        The shortcut key combination to assign to the menu row item.

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
        System.Windows.Forms.ToolStripMenuItem, String

    .OUTPUTS
        System.Windows.Forms.ToolStripMenuItem
#>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.ToolStripMenuItem])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Windows.Forms.ToolStripMenuItem]$MenuColumn,

        [string]$Title,
        [string]$Image,
        [string]$ShortCutKeys
    )

    $MenuRow = New-Object System.Windows.Forms.ToolStripMenuItem

    if ($Image -ne "") {
        if ((Get-SubString $Image 0 2) -eq 'ht') {
            $MenuRow.Image = Get-ImageFromStream $Image
        } else {
            $MenuRow.Image = Get-ImageFromFile $Image
        }
    }

    if ($ShortCutKeys -ne "") {
        $MenuRow.ShortCutKeys = $ShortCutKeys
        $MenuRow.ShowShortCutKeys = $true
    }

    $MenuRow.Name = $Title
    $MenuRow.Text = $Title
    $null = $MenuColumn.DropDownItems.Add($MenuRow)

    return $MenuRow
}

function Add-MenuStrip {
<#
    .SYNOPSIS
        Adds a MenuStrip control to an existing form.

    .DESCRIPTION
        This function adds a MenuStrip control to a specified form and sets its image scaling size.

    .PARAMETER Form
        The form to add a MenuStrip to.

    .EXAMPLE
        $MenuStrip1 = Add-MenuStrip $Form1

    .EXAMPLE
        $MenuStrip1 = Add-MenuStrip -Form $Form1

    .EXAMPLE
        $MenuStrip1 = $Form1 | Add-MenuStrip

    .INPUTS
        System.Windows.Forms.Form

    .OUTPUTS
        System.Windows.Forms.MenuStrip
#>
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.MenuStrip])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$Form
    )

    $MenuStrip = New-Object System.Windows.Forms.MenuStrip
    $MenuStrip.ImageScalingSize = New-Object System.Drawing.Size([int]($ctscale * 16), [int]($ctscale * 16))
    $null = $Form.Controls.Add($MenuStrip)

    return $MenuStrip
}

function Add-Shift {
<#
    .SYNOPSIS
		Sends the SHIFT key plus string. 

		ALIASES
			Shift
     
    .DESCRIPTION
		This function will prepend the string parameter with the shift key
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
	[Alias("Shift")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$TextValue
    )
	return "+$TextValue"
}

function Add-StatusStrip {
<#
    .SYNOPSIS
        Creates a StatusStrip control and adds it to a form-like container.

    .DESCRIPTION
        This function creates a System.Windows.Forms.StatusStrip control and adds it to the specified form or compatible UI container.
        It also adds a default ToolStripStatusLabel to the strip for immediate use.

    .PARAMETER Form
        The form or UI container object to which the StatusStrip will be added.
        Must expose a .Controls property compatible with Windows Forms.

    .EXAMPLE
        $StatusStrip1 = Add-StatusStrip $Form1
        $StatusStrip1.Items[0].Text = "Ready"

    .EXAMPLE
        $StatusStrip1 = Add-StatusStrip -Form $Form1
        $StatusStrip1.Items[0].Text = "Ready"

    .EXAMPLE
        $StatusStrip1 = $Form1 | Add-StatusStrip
        $StatusStrip1.Items[0].Text = "Ready"

    .INPUTS
        [object] - Must expose a .Controls property compatible with Windows Forms.

    .OUTPUTS
        System.Windows.Forms.StatusStrip containing a ToolStripStatusLabel.

    .NOTES
        Primarily intended for use with System.Windows.Forms.Form or vdsForm containers.
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$Form
    )

    # Validate that the input object has a .Controls property
    if (-not ($Form.PSObject.Properties['Controls'])) {
        throw "Input object must expose a .Controls property compatible with Windows Forms."
    }

    $statusstrip = New-Object System.Windows.Forms.StatusStrip
    $Form.Controls.Add($statusstrip)

    $ToolStripStatusLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
    $statusstrip.Items.Add($ToolStripStatusLabel)

    return $statusstrip
}

function Add-Tab {
<#
    .SYNOPSIS
        Returns the tab key character for use in SendKeys-style input.

    .ALIASES
        Tab

    .DESCRIPTION
        This function returns the tab key character (`t), which can be used with Send-Window to simulate a tab key press.

    .EXAMPLE
        Send-Window (Get-Window notepad) (Add-Tab)

    .OUTPUTS
        String

    .NOTES
        Only useful with 'Send-Window'.
#>
    [Alias("Tab")]
    param()
    return "`t"
}

function Add-ToolStrip {
<#
    .SYNOPSIS
        Adds a ToolStrip to an existing form or compatible UI container.

    .DESCRIPTION
        Creates a System.Windows.Forms.ToolStrip, applies DPI-aware scaling,
        and adds it to the specified form or container. Compatible with both
        native Windows Forms and vdsForm abstractions.

    .PARAMETER Form
        The form or container object to which the ToolStrip will be added.

    .EXAMPLE
        $ToolStrip1 = Add-ToolStrip $Form1

    .EXAMPLE
        $ToolStrip1 = Add-ToolStrip -Form $Form1

    .EXAMPLE
        $ToolStrip1 = $Form1 | Add-ToolStrip

    .INPUTS
        [object]

    .OUTPUTS
        System.Windows.Forms.ToolStrip
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$Form
    )

    $ToolStrip = New-Object System.Windows.Forms.ToolStrip
    $ToolStrip.ImageScalingSize = New-Object System.Drawing.Size(
        [int]($ctscale * 16),
        [int]($ctscale * 16)
    )
    $ToolStrip.Height = [int]($ToolStrip.Height * $ctscale)

    $Form.Controls.Add($ToolStrip)
    return $ToolStrip
}

function Add-ToolStripItem {
<#
    .SYNOPSIS
        Adds a ToolStripButton to an existing ToolStrip.

    .DESCRIPTION
        This function adds a ToolStripButton to a specified ToolStrip.
        The button is configured with name, image, tooltip, and visible text.
        It must be referenced by name or index from the parent ToolStrip after creation.

    .PARAMETER ToolStrip
        The ToolStrip control to which the button will be added.

    .PARAMETER Name
        The internal name of the ToolStripButton. Required for later reference.

    .PARAMETER Image
        The image path or URL to assign to the button.

    .PARAMETER ToolTipText
        The tooltip text displayed when hovering over the button.

    .PARAMETER VisibleText
        The text label shown on the button.

    .EXAMPLE
        $ToolStrip1 = Add-ToolStrip -Form $Form1
        Add-ToolStripItem -ToolStrip $ToolStrip1 -Name "Undo" -Image "undo.png" -ToolTipText "Undo last action" -VisibleText "Undo"

    .EXAMPLE
        $ToolStrip1.Items["Undo"].Add_Click({ Write-Host "Process Undo" })

    .INPUTS
        System.Windows.Forms.ToolStrip, String

    .OUTPUTS
        None

    .NOTES
        This function does not return the ToolStripButton object because it must be referenced by name or index from the parent ToolStrip.
        Returning it would require global exposure, which is outside of style.
        This limitation stems from non-standard behavior in the ToolStrip object and would need to be addressed by the Microsoft.NET team.
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Windows.Forms.ToolStrip]$ToolStrip,

        [Parameter(Mandatory)]
        [string]$Name,

        [string]$Image,
        [string]$ToolTipText,
        [string]$VisibleText
    )

    $btn = New-Object System.Windows.Forms.ToolStripButton
    $btn.Text = $VisibleText
    $btn.Name = $Name

    if ((Get-Substring $Image 0 2) -eq 'ht') {
        $btn.Image = Get-ImageFromStream $Image
    } else {
        $btn.Image = Get-ImageFromFile $Image
    }

    $btn.ToolTipText = $ToolTipText
    $ToolStrip.Items.Add($btn)
}

function Add-ToolStripSeparator {
<#
    .SYNOPSIS
        Adds a separator to the items of a ToolStrip.

    .DESCRIPTION
        This function adds a ToolStripSeparator to the specified ToolStrip.

    .PARAMETER ToolStrip
        The ToolStrip control to which the separator will be added.

    .EXAMPLE
        $Sep1 = Add-ToolStripSeparator $ToolStrip1

    .EXAMPLE
        $Sep1 = Add-ToolStripSeparator -ToolStrip $ToolStrip1

    .EXAMPLE
        $Sep1 = $ToolStrip1 | Add-ToolStripSeparator

    .INPUTS
        System.Windows.Forms.ToolStrip

    .OUTPUTS
        System.Windows.Forms.ToolStripSeparator
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Windows.Forms.ToolStrip]$ToolStrip
    )

    $item = New-Object System.Windows.Forms.ToolStripSeparator
    $ToolStrip.Items.Add($item) | Out-Null
}

function Add-WPFControl {
<#
    .SYNOPSIS
        Creates a control inside a WPF container object.

    .DESCRIPTION
        This function creates a WPF control of the specified type and inserts it into the given container.
        Positioning and sizing are applied via Margin, Height, and Width.

    .PARAMETER ControlType
        The type of control to add. Must be one of the validated types:
        Button, Calendar, CheckBox, ComboBox, ComboBoxItem, DatePicker, DocumentViewer, Expander,
        FlowDocumentReader, GroupBox, Hyperlink, Image, InkCanvas, Label, ListBox, ListBoxItem,
        Menu, MenuItem, PasswordBox, ProgressBar, RadioButton, RichTextBox, ScrollViewer,
        SinglePageViewer, Slider, TabControl, TabItem, Table, TextBlock, TextBox, ToolBar,
        ToolTip, TreeView, TreeViewItem, WebBrowser

    .PARAMETER Container
        The WPF container to which the control will be added.

    .PARAMETER Text
        The text to display on the control.

    .PARAMETER Top
        The top position for the control.

    .PARAMETER Left
        The left position for the control.

    .PARAMETER Height
        The height of the control.

    .PARAMETER Width
        The width of the control.

    .EXAMPLE
        $Button1 = Add-WPFControl 'Button' $Grid1 'Button1' 20 20 20 200

    .EXAMPLE
        $Button1 = Add-WPFControl -ControlType 'Button' -Container $Grid1 -Text 'Button1' -Top 20 -Left 20 -Height 20 -Width 200

    .EXAMPLE
        $Button1 = 'Button' | Add-WPFControl -Container $Grid1 -Text 'Button1' -Top 20 -Left 20 -Height 20 -Width 200

    .INPUTS
        ControlType as ValidatedString, Container as Object, Text as String, Top as String, Left as String, Height as String, Width as String

    .OUTPUTS
        System.Windows.Controls.$ControlType
#>
    [Alias("Assert-WPFAddControl")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateSet('Button', 'Calendar', 'CheckBox', 'ComboBox',
        'ComboBoxItem', 'DatePicker', 'DocumentViewer', 'Expander',
        'FlowDocumentReader', 'GroupBox', 'Hyperlink', 'Image', 'InkCanvas',
        'Label', 'ListBox', 'ListBoxItem', 'Menu', 'MenuItem', 'PasswordBox',
        'ProgressBar', 'RadioButton', 'RichTextBox', 'ScrollViewer',
        'SinglePageViewer', 'Slider', 'TabControl', 'TabItem', 'Table',
        'TextBlock', 'TextBox', 'ToolBar', 'ToolTip', 'TreeView',
        'TreeViewItem', 'WebBrowser')]
        [string]$ControlType,

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

    $control = New-Object "System.Windows.Controls.$ControlType"
    $control.Content = $Text
    $Container.Children.Insert($Container.Children.Count, $control)
    $control.VerticalAlignment = "Top"
    $control.HorizontalAlignment = "Left"
    $control.Margin = "$Left,$Top,0,0"
    $control.Height = $Height
    $control.Width = $Width

    return $control
}
function Assert-List {
<#
    .SYNOPSIS
		Asserts a list operation
		
		ALIASES
			List
			 
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
	[Alias("List")]
	[CmdletBinding()]
    param (
		[Parameter(Mandatory)]
		[object]$List,
        [Parameter(Mandatory)]
		[ValidateSet('Add', 'Append', 'Assign', 'Clear', 'Create', 'Copy',
		'Delete', 'Insert', 'Paste', 'Put', 'Reverse', 'Seek', 'Sort', 
		'Dropfiles', 'Filelist', 'Folderlist', 'Fontlist', 'Loadfile', 
		'Loadtext', 'Modules', 'Regkeys', 'Regvals', 'Savefile', 'Tasklist',
		'Winlist')]
        [string]$Assertion,
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
                    Assert-List $List Add $filename
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
            $content = (get-content $Parameter).Split([char][byte]10)
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

function Assert-WPF {
<#
    .SYNOPSIS
        Transforms a XAML string into a Windows Presentation Foundation window.

    .DESCRIPTION
        This function parses and loads a XAML string into a live WPF window object.
        It strips design-time attributes and exposes named controls as global variables
        for direct access and manipulation.

    .PARAMETER xaml
        The source XAML string to transform.

    .EXAMPLE
        Assert-WPF $xaml

    .EXAMPLE
        Assert-WPF -xaml $xaml

    .EXAMPLE
        $xaml | Assert-WPF

    .INPUTS
        String

    .OUTPUTS
        System.Windows.Window (or root element from XAML)
        Named controls are exposed as global variables by their x:Name.
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$xaml
    )

    # Strip design-time and ambiguous attributes
    $xaml = $xaml -replace 'x:N', 'N' `
                  -replace 'd:DesignHeight="\d*?"', '' `
                  -replace 'd:DesignWidth="\d*?"', '' `
                  -replace 'x:Class=".*?"', '' `
                  -replace 'mc:Ignorable="d"', ''

    # Parse and load the XAML
    [xml]$xaml = $xaml
    $presentation = [Windows.Markup.XamlReader]::Load(
        (New-Object System.Xml.XmlNodeReader $xaml)
    )

    # Expose named controls as global variables
    $xaml.SelectNodes("//*[@Name]") | ForEach-Object {
        Set-Variable -Name $_.Name.ToString() `
                     -Value $presentation.FindName($_.Name) `
                     -Scope Global
    }

    return $presentation
}

function Assert-WPFAddControl {
<#
    .SYNOPSIS
        Dynamically creates and inserts a WPF control into a container.

    .DESCRIPTION
        Instantiates a validated WPF control type, sets its content and layout properties,
        and injects it into the specified container. Supports dynamic UI generation in PowerShell-driven WPF apps.

    .PARAMETER ControlType
        The type of control to create. Must be one of the validated WPF control types.

    .PARAMETER Container
        The WPF container (e.g., Grid, StackPanel) to insert the control into.

    .PARAMETER Text
        The text or content to display on the control.

    .PARAMETER Top
        The top margin (Y offset) of the control.

    .PARAMETER Left
        The left margin (X offset) of the control.

    .PARAMETER Height
        The height of the control.

    .PARAMETER Width
        The width of the control.

    .EXAMPLE
        $Button1 = Assert-WPFAddControl 'Button' $Grid1 'Click Me' 20 20 30 100

    .INPUTS
        String, Object

    .OUTPUTS
        System.Windows.Controls.Control
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateSet('Button', 'Calendar', 'CheckBox', 'ComboBox',
            'ComboBoxItem', 'DatePicker', 'DocumentViewer', 'Expander',
            'FlowDocumentReader', 'GroupBox', 'Hyperlink', 'Image', 'InkCanvas',
            'Label', 'ListBox', 'ListBoxItem', 'Menu', 'MenuItem', 'PasswordBox',
            'ProgressBar', 'RadioButton', 'RichTextBox', 'ScrollViewer',
            'SinglePageViewer', 'Slider', 'TabControl', 'TabItem', 'Table',
            'TextBlock', 'TextBox', 'ToolBar', 'ToolTip', 'TreeView',
            'TreeViewItem', 'WebBrowser')]
        [string]$ControlType,

        [Parameter(Mandatory)]
        [System.Windows.Controls.Panel]$Container,

        [Parameter(Mandatory)]
        [string]$Text,

        [Parameter(Mandatory)]
        [int]$Top,

        [Parameter(Mandatory)]
        [int]$Left,

        [Parameter(Mandatory)]
        [int]$Height,

        [Parameter(Mandatory)]
        [int]$Width
    )

    # Instantiate control
    $control = New-Object "System.Windows.Controls.$ControlType"

    # Set content or text depending on control type
    if ($control -is [System.Windows.Controls.ContentControl]) {
        $control.Content = $Text
    } elseif ($control -is [System.Windows.Controls.TextBox]) {
        $control.Text = $Text
    }

    # Layout properties
    $control.VerticalAlignment = 'Top'
    $control.HorizontalAlignment = 'Left'
    $control.Margin = [System.Windows.Thickness]::new($Left, $Top, 0, 0)
    $control.Height = $Height
    $control.Width = $Width

    # Inject into container using original Insert logic
    $Container.Children.Add($Container.Children.Count, $control)

    return $control
}

function Assert-WPFCreate {
<#
    .SYNOPSIS
        Creates a Windows Presentation Foundation window with a named grid container.

    .DESCRIPTION
        Dynamically constructs a WPF window using XAML markup, embedding a grid with a specified name.
        Returns the instantiated window object for further manipulation or control injection.

    .PARAMETER Title
        The title of the window.

    .PARAMETER Height
        The height of the window in pixels.

    .PARAMETER Width
        The width of the window in pixels.

    .PARAMETER Grid
        The name of the grid container within the window.

    .EXAMPLE
        Assert-WPFCreate "Brandon's Window" 480 800 "Grid1"

    .EXAMPLE
        Assert-WPFCreate -Title "Brandon's Window" -Height 480 -Width 800 -Grid "Grid1"

    .EXAMPLE
        "Brandon's Window" | Assert-WPFCreate -Height 480 -Width 800 -Grid "Grid1"

    .INPUTS
        String, Int

    .OUTPUTS
        System.Windows.Window
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Title,

        [Parameter(Mandatory)]
        [int]$Height,

        [Parameter(Mandatory)]
        [int]$Width,

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

    $MainWindow = Assert-WPF $xaml
    return $MainWindow
}

function Assert-WPFGetControlByName {
<#
    .SYNOPSIS
        Retrieves a named control from a WPF presentation object.

    .DESCRIPTION
        This function returns the control associated with the specified name
        from a WPF window or container previously loaded via Assert-WPF.

    .PARAMETER Presentation
        The WPF window or container object that contains the control.

    .PARAMETER Name
        The x:Name of the control to retrieve.

    .EXAMPLE
        Assert-WPFGetControlByName $Form1 "Button1"

    .EXAMPLE
        Assert-WPFGetControlByName -Presentation $Form1 -Name "Button1"

    .EXAMPLE
        $Form1 | Assert-WPFGetControlByName -Name "Button1"

    .INPUTS
        System.Object, System.String

    .OUTPUTS
        System.Object (the control instance)

    .NOTES
        Most useful when working with externally sourced XAML loaded via Assert-WPF.
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$Presentation,

        [Parameter(Mandatory)]
        [string]$Name
    )

    return $Presentation.FindName($Name)
}

function Assert-WPFHAlign {
<#
    .SYNOPSIS
        Horizontally aligns a WPF control to the specified alignment.

    .DESCRIPTION
        Sets the HorizontalAlignment property of a WPF control to one of the valid alignment options:
        Left, Center, Right, or Stretch.

    .PARAMETER Object
        The WPF control to align.

    .PARAMETER Halign
        The horizontal alignment value to apply.

    .EXAMPLE
        Assert-WPFHAlign $Button1 'Left'

    .EXAMPLE
        Assert-WPFHAlign -Object $Button1 -Halign 'Center'

    .EXAMPLE
        $Button1 | Assert-WPFHAlign -Halign 'Right'

    .INPUTS
        System.Object, System.String

    .OUTPUTS
        System.String (alignment value applied)
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$Object,

        [Parameter(Mandatory)]
        [ValidateSet('Left', 'Center', 'Right', 'Stretch')]
        [string]$Halign
    )

    $Object.HorizontalAlignment = $Halign
    return $Halign
}

function Assert-WPFInsertControl {
<#
    .SYNOPSIS
        Inserts a WPF control into a container object.

    .DESCRIPTION
        Instantiates a validated WPF control type and inserts it into the specified container.
        Useful for dynamic UI composition in PowerShell-driven WPF applications.

    .PARAMETER ControlType
        The type of control to create. Must be one of the validated WPF control types.

    .PARAMETER Container
        The WPF container (e.g., Grid, StackPanel) to insert the control into.

    .EXAMPLE
        $Button1 = Assert-WPFInsertControl 'Button' $Grid1

    .EXAMPLE
        $Button1 = Assert-WPFInsertControl -ControlType 'Button' -Container $Grid1

    .EXAMPLE
        'Button' | Assert-WPFInsertControl -Container $Grid1

    .INPUTS
        System.String, System.Object

    .OUTPUTS
        System.Windows.Controls.Control
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateSet('Button', 'Calendar', 'CheckBox', 'ComboBox',
            'ComboBoxItem', 'DatePicker', 'DocumentViewer', 'Expander',
            'FlowDocumentReader', 'GroupBox', 'Hyperlink', 'Image', 'InkCanvas',
            'Label', 'ListBox', 'ListBoxItem', 'Menu', 'MenuItem', 'PasswordBox',
            'ProgressBar', 'RadioButton', 'RichTextBox', 'ScrollViewer',
            'SinglePageViewer', 'Slider', 'TabControl', 'TabItem', 'Table',
            'TextBlock', 'TextBox', 'ToolBar', 'ToolTip', 'TreeView',
            'TreeViewItem', 'WebBrowser')]
        [string]$ControlType,

        [Parameter(Mandatory)]
        [System.Windows.Controls.Panel]$Container
    )

    $control = New-Object "System.Windows.Controls.$ControlType"
    $Container.Children.Insert($Container.Children.Count, $control)
    return $control
}

function Assert-WPFValign {
<#
    .SYNOPSIS
        Vertically aligns a WPF control to the specified alignment.

    .DESCRIPTION
        Sets the VerticalAlignment property of a WPF control to one of the valid alignment options:
        Top, Center, Bottom, or Stretch.

    .PARAMETER Object
        The WPF control to align.

    .PARAMETER Valign
        The vertical alignment value to apply.

    .EXAMPLE
        Assert-WPFValign $Button1 'Top'

    .EXAMPLE
        Assert-WPFValign -Object $Button1 -Valign 'Center'

    .EXAMPLE
        $Button1 | Assert-WPFValign -Valign 'Bottom'

    .INPUTS
        System.Object, System.String

    .OUTPUTS
        System.String (alignment value applied)
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$Object,

        [Parameter(Mandatory)]
        [ValidateSet('Top', 'Center', 'Bottom', 'Stretch')]
        [string]$Valign
    )

    $Object.VerticalAlignment = $Valign
    return $Valign
}

function Clear-Clipboard {
<#
    .SYNOPSIS
        Clears the text and data content from the Windows clipboard.

    .DESCRIPTION
        Uses the .NET Clipboard API to clear all formats from the clipboard, including text, images, and file drops.
        This method is more robust than shell-based approaches and avoids external dependencies.

    .ALIASES
        Clipboard-Clear

    .EXAMPLE
        Clear-Clipboard

    .INPUTS
        None

    .OUTPUTS
        None
#>
    [Alias("Clipboard-Clear")]
    param()

    [System.Windows.Forms.Clipboard]::Clear()
}

function Close-DataSourceName {
<#
    .SYNOPSIS
        Closes the connection to a Data Source Name (DSN) via an ODBC object.

    .DESCRIPTION
        This function closes an active ODBC connection represented by the provided object.
        Typically used to release resources after querying or interacting with a DSN.
        The object is usually returned from Initialize-ODBC or similar connection logic.

    .PARAMETER ODBCObject
        The ODBC connection object to close.

    .EXAMPLE
        Close-DataSourceName $database

    .EXAMPLE
        Close-DataSourceName -ODBCObject $database

    .EXAMPLE
        $database | Close-DataSourceName

    .INPUTS
        System.Data.Odbc.OdbcConnection

    .OUTPUTS
        None
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Data.Odbc.OdbcConnection]$ODBCObject
    )

    $ODBCObject.Close()
}

function Close-Window {
<#
    .SYNOPSIS
        Sends a close command to a window via its handle.

    .DESCRIPTION
        This function closes a window by sending a WM_SYSCOMMAND message with the SC_CLOSE parameter.
        It requires a valid window handle, typically retrieved via Get-WindowExists or similar logic.

    .ALIASES
        Window-Close

    .PARAMETER Handle
        The window handle (IntPtr) to target for closure.

    .EXAMPLE
        Close-Window (Get-WindowExists "Untitled - Notepad")

    .EXAMPLE
        Close-Window -Handle (Get-WindowExists "Untitled - Notepad")

    .EXAMPLE
        (Get-WindowExists "Untitled - Notepad") | Close-Window

    .INPUTS
        System.IntPtr

    .OUTPUTS
        None
#>
    [Alias("Window-Close")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.IntPtr]$Handle
    )

    # WM_SYSCOMMAND = 0x0112, SC_CLOSE = 0xF060
    New-SendMessage $Handle 0x0112 0xF060 0
}

function Set-WindowMinimized {
<#
    .SYNOPSIS
        Minimizes a window via its handle.

    .DESCRIPTION
        Sends a ShowWindow command with the SW_MINIMIZE flag to the specified window handle.
        This function is purpose-built for minimizing windows and aliased for intuitive usage.

    .ALIASES
        Minimize-Window
        Window-Iconize
		Compress-Window

    .PARAMETER Handle
        The window handle (IntPtr) to minimize.

    .EXAMPLE
        Set-WindowStateMinimize -Handle $h

    .EXAMPLE
        Minimize-Window -Handle $h

    .EXAMPLE
        Window-Iconize -Handle $h
#>
    [Alias("Minimize-Window", "Window-Iconize")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.IntPtr]$Handle
    )

    [vds]::ShowWindow($Handle, "SW_MINIMIZE")
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
								try{$newControl.$attribName = $value}catch{}
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

function ConvertFrom-WPFXaml {
<#
    .SYNOPSIS
		Transforms XAML string into a Windows Presentation Foundation window
			 
	.DESCRIPTION
		This function transforms XAML string into a Windows Presentation 
		Foundation window (ambiguous)
		
	.PARAMETER xaml
		The source XAML string to transform
	
	.EXAMPLE
		ConvertFrom-WPFXaml $xaml
		
	.EXAMPLE
		ConvertFrom-WPFXaml -xaml $xaml

	.EXAMPLE
		$xaml | ConvertFrom-WPFXaml
		
	.INPUTS
		xaml as String
	
	.OUTPUTS
		Windows.Markup.XamlReader and Global Variables for Controls within the window by Control Name
#>
	[Alias("Assert-WPF")]
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$xaml
	)
	$xaml = $xaml -replace "x:Name", 'Name' -replace 'd:DesignHeight="\d*?"', '' -replace 'x:Class=".*?"', '' -replace 'mc:Ignorable="d"', '' -replace 'd:DesignWidth="\d*?"', '' 
	$xaml = $xaml -replace 'Activated','Tag' -replace 'AutoSizeChanged','Tag' -replace 'AutoValidateChanged','Tag' -replace 'BackColorChanged','Tag' -replace 'BackgroundImageChanged','Tag' -replace 'BackgroundImageLayoutChanged','Tag' -replace 'BindingContextChanged','Tag' -replace 'CausesValidationChanged','Tag' -replace 'ChangeUICues','Tag' -replace 'Click','Tag' -replace 'ClientSizeChanged','Tag' -replace 'Closed','Tag' -replace 'Closing','Tag' -replace 'ContextMenuChanged','Tag' -replace 'ContextMenuStripChanged','Tag' -replace 'ControlAdded','Tag' -replace 'ControlRemoved','Tag' -replace 'CursorChanged','Tag' -replace 'Deactivate','Tag' -replace 'Disposed','Tag' -replace 'DockChanged','Tag' -replace 'DoubleClick','Tag' -replace 'DpiChanged','Tag' -replace 'DpiChangedAfterParent','Tag' -replace 'DpiChangedBeforeParent','Tag' -replace 'DragDrop','Tag' -replace 'DragEnter','Tag' -replace 'DragLeave','Tag' -replace 'DragOver','Tag' -replace 'EnabledChanged','Tag' 
	$xaml = $xaml -replace 'Enter','Tag' -replace 'FontChanged','Tag' -replace 'ForeColorChanged','Tag' -replace 'FormClosed','Tag' -replace 'FormClosing','Tag' -replace 'GiveFeedback','Tag' -replace 'GotFocus','Tag' -replace 'HandleCreated','Tag' -replace 'HandleDestroyed','Tag' -replace 'HelpButtonClicked','Tag' -replace 'HelpRequested','Tag' -replace 'ImeModeChanged','Tag' -replace 'InputLanguageChanged','Tag' -replace 'InputLanguageChanging','Tag' -replace 'Invalidated','Tag' -replace 'KeyDown','Tag' -replace 'KeyPress','Tag' -replace 'KeyUp','Tag' -replace 'Layout','Tag' -replace 'Leave','Tag' -replace 'Load','Tag' -replace 'LocationChanged','Tag' -replace 'LostFocus','Tag' -replace 'MarginChanged','Tag' -replace 'MaximizedBoundsChanged','Tag' -replace 'MaximumSizeChanged','Tag' -replace 'MdiChildActivate','Tag' -replace 'MenuComplete','Tag' -replace 'MenuStart','Tag' -replace 'MinimumSizeChanged','Tag' -replace 'MouseCaptureChanged','Tag' -replace 'MouseClick','Tag' -replace 'MouseDoubleClick','Tag' -replace 'MouseDown','Tag' 
	$xaml = $xaml -replace 'MouseEnter','Tag' -replace 'MouseHover','Tag' -replace 'MouseLeave','Tag' -replace 'MouseMove','Tag' -replace 'MouseUp','Tag' -replace 'MouseWheel','Tag' -replace 'Move','Tag' -replace 'PaddingChanged','Tag' -replace 'Paint','Tag' -replace 'ParentChanged','Tag' -replace 'PreviewKeyDown','Tag' -replace 'QueryAccessibilityHelp','Tag' -replace 'QueryContinueDrag','Tag' -replace 'RegionChanged','Tag' -replace 'Resize','Tag' -replace 'ResizeBegin','Tag' -replace 'ResizeEnd','Tag' 
	$xaml = $xaml -replace 'RightToLeftChanged','Tag' -replace 'RightToLeftLayoutChanged','Tag' -replace 'Scroll','Tag' -replace 'Shown','Tag' -replace 'SizeChanged','Tag' -replace 'StyleChanged','Tag' -replace 'SystemColorsChanged','Tag' -replace 'TabIndexChanged','Tag' -replace 'TabStopChanged','Tag' -replace 'TextChanged','Tag' -replace 'Validated','Tag' -replace 'Validating','Tag' -replace 'VisibleChanged','Tag' -replace 'AcceptsTabChanged','Tag' -replace 'BorderStyleChanged','Tag' 
	$xaml = $xaml -replace 'HideSelectionChanged','Tag' -replace 'ModifiedChanged','Tag' -replace 'MultilineChanged','Tag' -replace 'ReadOnlyChanged','Tag' -replace 'TextAlignChanged','Tag' -replace 'AppearanceChanged','Tag' -replace 'CheckedChanged','Tag' -replace 'CheckStateChanged','Tag' -replace 'DataSourceChanged','Tag' -replace 'DisplayMemberChanged','Tag' -replace 'DrawItem','Tag' -replace 'Format','Tag' -replace 'FormatInfoChanged','Tag' -replace 'FormatStringChanged','Tag' -replace 'FormattingEnabledChanged','Tag' -replace 'ItemCheck','Tag' -replace 'MeasureItem','Tag' -replace 'SelectedIndexChanged','Tag' -replace 'SelectedValueChanged','Tag' -replace 'ValueMemberChanged','Tag' -replace 'DropDown','Tag' -replace 'DropDownClosed','Tag' -replace 'DropDownStyleChanged','Tag' -replace 'SelectionChangeCommitted','Tag' -replace 'TextUpdate','Tag' -replace 'AllowNavigationChanged','Tag' -replace 'BackButtonClick','Tag' 
	$xaml = $xaml -replace 'BackgroundColorChanged','Tag' -replace 'CaptionVisibleChanged','Tag' -replace 'CurrentCellChanged','Tag' -replace 'FlatModeChanged','Tag' -replace 'Navigate','Tag' -replace 'ParentRowsLabelStyleChanged','Tag' -replace 'ParentRowsVisibleChanged','Tag' -replace 'ShowParentDetailsButtonClick','Tag' -replace 'AllowUserToAddRowsChanged','Tag' -replace 'AllowUserToDeleteRowsChanged','Tag' -replace 'AllowUserToOrderColumnsChanged','Tag' -replace 'AllowUserToResizeColumnsChanged','Tag' -replace 'AllowUserToResizeRowsChanged','Tag' -replace 'AlternatingRowsDefaultCellStyleChanged','Tag' -replace 'AutoGenerateColumnsChanged','Tag' -replace 'AutoSizeColumnModeChanged','Tag' -replace 'AutoSizeColumnsModeChanged','Tag' -replace 'AutoSizeRowsModeChanged','Tag' -replace 'CancelRowEdit','Tag' -replace 'CellBeginEdit','Tag' -replace 'CellBorderStyleChanged','Tag' -replace 'CellClick','Tag' -replace 'CellContentClick','Tag' -replace 'CellContentDoubleClick','Tag' -replace 'CellContextMenuStripChanged','Tag' -replace 'CellContextMenuStripNeeded','Tag' -replace 'CellDoubleClick','Tag' -replace 'CellEndEdit','Tag' -replace 'CellEnter','Tag' -replace 'CellErrorTextChanged','Tag' -replace 'CellErrorTextNeeded','Tag' -replace 'CellFormatting','Tag' -replace 'CellLeave','Tag' -replace 'CellMouseClick','Tag' -replace 'CellMouseDoubleClick','Tag' -replace 'CellMouseDown','Tag' -replace 'CellMouseEnter','Tag' -replace 'CellMouseLeave','Tag' -replace 'CellMouseMove','Tag' -replace 'CellMouseUp','Tag' -replace 'CellPainting','Tag' -replace 'CellParsing','Tag' -replace 'CellStateChanged','Tag' -replace 'CellStyleChanged','Tag' -replace 'CellStyleContentChanged','Tag' -replace 'CellToolTipTextChanged','Tag' -replace 'CellToolTipTextNeeded','Tag' -replace 'CellValidated','Tag' -replace 'CellValidating','Tag' -replace 'CellValueChanged','Tag' -replace 'CellValueNeeded','Tag' -replace 'CellValuePushed','Tag' -replace 'ColumnAdded','Tag' 
	$xaml = $xaml -replace 'ColumnContextMenuStripChanged','Tag' -replace 'ColumnDataPropertyNameChanged','Tag' -replace 'ColumnDefaultCellStyleChanged','Tag' -replace 'ColumnDisplayIndexChanged','Tag' -replace 'ColumnDividerDoubleClick','Tag' -replace 'ColumnDividerWidthChanged','Tag' -replace 'ColumnHeaderCellChanged','Tag' -replace 'ColumnHeaderMouseClick','Tag' -replace 'ColumnHeaderMouseDoubleClick','Tag' -replace 'ColumnHeadersBorderStyleChanged','Tag' -replace 'ColumnHeadersDefaultCellStyleChanged','Tag' -replace 'ColumnHeadersHeightChanged','Tag' -replace 'ColumnHeadersHeightSizeModeChanged','Tag' -replace 'ColumnMinimumWidthChanged','Tag' -replace 'ColumnNameChanged','Tag' -replace 'ColumnRemoved','Tag' -replace 'ColumnSortModeChanged','Tag' -replace 'ColumnStateChanged','Tag' -replace 'ColumnToolTipTextChanged','Tag' -replace 'ColumnWidthChanged','Tag' -replace 'CurrentCellDirtyStateChanged','Tag' -replace 'DataBindingComplete','Tag' -replace 'DataError','Tag' -replace 'DataMemberChanged','Tag' -replace 'DefaultCellStyleChanged','Tag' -replace 'DefaultValuesNeeded','Tag' -replace 'EditingControlShowing','Tag' -replace 'EditModeChanged','Tag' -replace 'GridColorChanged','Tag' -replace 'MultiSelectChanged','Tag' -replace 'NewRowNeeded','Tag' -replace 'RowContextMenuStripChanged','Tag' -replace 'RowContextMenuStripNeeded','Tag' -replace 'RowDefaultCellStyleChanged','Tag' -replace 'RowDirtyStateNeeded','Tag' -replace 'RowDividerDoubleClick','Tag' -replace 'RowDividerHeightChanged','Tag' -replace 'RowEnter','Tag' -replace 'RowErrorTextChanged','Tag' -replace 'RowErrorTextNeeded','Tag' -replace 'RowHeaderCellChanged','Tag' -replace 'RowHeaderMouseClick','Tag' -replace 'RowHeaderMouseDoubleClick','Tag' -replace 'RowHeadersBorderStyleChanged','Tag' -replace 'RowHeadersDefaultCellStyleChanged','Tag' -replace 'RowHeadersWidthChanged','Tag' -replace 'RowHeadersWidthSizeModeChanged','Tag' -replace 'RowHeightChanged','Tag' 
	$xaml = $xaml -replace 'RowHeightInfoNeeded','Tag' -replace 'RowHeightInfoPushed','Tag' -replace 'RowLeave','Tag' -replace 'RowMinimumHeightChanged','Tag' -replace 'RowPostPaint','Tag' -replace 'RowPrePaint','Tag' -replace 'RowsAdded','Tag' -replace 'RowsDefaultCellStyleChanged','Tag' -replace 'RowsRemoved','Tag' -replace 'RowStateChanged','Tag' -replace 'RowUnshared','Tag' -replace 'RowValidated','Tag' -replace 'RowValidating','Tag' -replace 'SelectionChanged','Tag' -replace 'SortCompare','Tag' -replace 'Sorted','Tag' -replace 'UserAddedRow','Tag' -replace 'UserDeletedRow','Tag' -replace 'UserDeletingRow','Tag' -replace 'CloseUp','Tag' -replace 'FormatChanged','Tag' -replace 'ValueChanged','Tag' -replace 'LinkClicked','Tag' -replace 'AfterLabelEdit','Tag' -replace 'BeforeLabelEdit','Tag' -replace 'CacheVirtualItems','Tag' -replace 'ColumnClick','Tag' -replace 'ColumnReordered','Tag' -replace 'ColumnWidthChanging','Tag' -replace 'DrawColumnHeader','Tag' -replace 'DrawSubItem','Tag' -replace 'ItemActivate','Tag' -replace 'ItemChecked','Tag' -replace 'ItemDrag','Tag' -replace 'ItemMouseHover','Tag' -replace 'ItemSelectionChanged','Tag' -replace 'RetrieveVirtualItem','Tag' -replace 'SearchForVirtualItem','Tag' -replace 'VirtualItemsSelectionRangeChanged','Tag' -replace 'IsOverwriteModeChanged','Tag' -replace 'MaskChanged','Tag' -replace 'MaskInputRejected','Tag' -replace 'TypeValidationCompleted','Tag' -replace 'DateChanged','Tag' -replace 'DateSelected','Tag' -replace 'LoadCompleted','Tag' -replace 'LoadProgressChanged','Tag' -replace 'SizeModeChanged','Tag' -replace 'PropertySortChanged','Tag' -replace 'PropertyTabChanged','Tag' -replace 'PropertyValueChanged','Tag' -replace 'SelectedGridItemChanged','Tag' -replace 'SelectedObjectsChanged','Tag' -replace 'ContentsResized','Tag' -replace 'HScroll','Tag' -replace 'ImeChange','Tag' -replace 'Protected','Tag' -replace 'VScroll','Tag' -replace 'AfterCheck','Tag' 
	$xaml = $xaml -replace 'AfterCollapse','Tag' -replace 'AfterExpand','Tag' -replace 'AfterSelect','Tag' -replace 'BeforeCheck','Tag' -replace 'BeforeCollapse','Tag' -replace 'BeforeExpand','Tag' -replace 'BeforeSelect','Tag' -replace 'DrawNode','Tag' -replace 'NodeMouseClick','Tag' -replace 'NodeMouseDoubleClick','Tag' -replace 'NodeMouseHover','Tag' -replace 'CanGoBackChanged','Tag' -replace 'CanGoForwardChanged','Tag' -replace 'DocumentCompleted','Tag' -replace 'DocumentTitleChanged','Tag' -replace 'EncryptionLevelChanged','Tag' -replace 'FileDownload','Tag' -replace 'Navigated','Tag' -replace 'Navigating','Tag' -replace 'NewWindow','Tag' -replace 'ProgressChanged','Tag' -replace 'StatusTextChanged','Tag' -replace 'SplitterMoved','Tag' -replace 'SplitterMoving','Tag' -replace 'CellPaint','Tag' -replace 'BeginDrag','Tag' -replace 'EndDrag','Tag' -replace 'ItemAdded','Tag' -replace 'ItemClicked','Tag' -replace 'ItemRemoved','Tag' -replace 'LayoutCompleted','Tag' -replace 'LayoutStyleChanged','Tag' -replace 'Opened','Tag' -replace 'Opening','Tag' -replace 'PaintGrip','Tag' -replace 'RendererChanged','Tag' -replace 'MenuActivate','Tag' -replace 'MenuDeactivate','Tag' -replace 'Deselected','Tag' -replace 'Deselecting','Tag' -replace 'Selected','Tag' -replace 'Selecting','Tag' -replace 'AvailableChanged','Tag' -replace 'DisplayStyleChanged','Tag' -replace 'OwnerChanged','Tag' -replace 'DropDownItemClicked','Tag' -replace 'DropDownOpened','Tag' -replace 'DropDownOpening','Tag' -replace 'ButtonClick','Tag' -replace 'ButtonDoubleClick','Tag' -replace 'DefaultItemChanged','Tag' -replace 'TextBoxTextAlignChanged','Tag' 
	[xml]$xaml = $xaml
	$presentation = [Windows.Markup.XamlReader]::Load((new-object System.Xml.XmlNodeReader $xaml))
	$xaml.SelectNodes("//*[@Name]") | %{
		Set-Variable -Name $_.Name.ToString() -Value $presentation.FindName($_.Name) -Scope global
	}
	return $presentation
}

function ConvertTo-DateTime {
<#
	.SYNOPSIS
		Returns back the value of a string as datetime.

		ALIASES
			Datetime
		
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
	[Alias("Datetime")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$DateTime
    )
	return [System.Convert]::ToDateTime($DateTime)
}

function ConvertTo-String {
<#
    .SYNOPSIS
		Converts the input to string

		ALIASES
			String
     
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
	[Alias("String")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        $Input
	)
	return ($Input | Out-String).trim()
}

function Copy-File {
<#
    .SYNOPSIS
        Copies a file to a destination

    .ALIASES
        File-Copy
     
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
        System.String (Path), System.String (Destination)
#>
    [Alias("File-Copy")]
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
        Copy-RegistryKey -Path 'Registry::HKEY_CURRENT_USER\Software\Adobe\Acrobat Reader\10.0\AdobeViewer' -Destination 'Registry::HKEY_CURRENT_USER\Software\Policies\Adobe\Acrobat Reader\10.0\AdobeViewer'
    
    .INPUTS
        System.String (Path), System.String (Destination)
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

function Set-WindowMaximized {
<#
    .SYNOPSIS
        Sets a window to its maximized state

    .ALIASES
        Expand-Window
        Window-Maximize

    .DESCRIPTION
        This function sets a window to its maximized state using its handle.

    .PARAMETER Handle
        The handle of the window

    .EXAMPLE
        Set-WindowExpanded (Get-WindowExists "Untitled - Notepad")

    .EXAMPLE
        Set-WindowExpanded -Handle (Get-WindowExists "Untitled - Notepad")

    .EXAMPLE
        (Get-WindowExists "Untitled - Notepad") | Set-WindowExpanded

    .INPUTS
        System.IntPtr (Handle)
#>
    [Alias("Expand-Window", "Window-Maximize")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.IntPtr]$Handle
    )
    [vds]::ShowWindow($Handle, "SW_MAXIMIZE")
}

function Find-ListMatch {
<#
    .SYNOPSIS
        Finds and returns the index of an item in a list

    .ALIASES
        Match

    .DESCRIPTION
        This function searches for a string in a list control and returns its index.
        It attempts to use FindString first, falling back to IndexOf if necessary.

    .PARAMETER List
        The list control to search (e.g., ListBox)

    .PARAMETER Text
        The text to find

    .PARAMETER Start
        The starting index (optional). Defaults to -1.

    .EXAMPLE
        $index = Find-ListMatch $ListBox1 "Guitar"

    .EXAMPLE 
        $index = Find-ListMatch -List $ListBox1 -Text "Guitar" -Start ($index + 1)

    .EXAMPLE
        $index = $ListBox1 | Find-ListMatch -Text "Guitar"

    .INPUTS
        System.Object (List), System.String (Text), System.Int32 (Start)

    .OUTPUTS
        System.Int32 (Index of matching item, or -1 if not found)
#>
    [Alias("Match")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$List,

        [Parameter(Mandatory)]
        [string]$Text,

        [int]$Start = -1
    )

    if (-not $List) {
        throw "List parameter cannot be null."
    }

    try {
        $return = $List.FindString($Text, $Start)
    } catch {
        $return = $List.Items.IndexOf($Text)
    }

    return $return
}

function Get-Abs {
<#
    .SYNOPSIS
		Returns the absolute value of a number.

		ALIASES
			Abs
			 
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
	[Alias("Abs")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [decimal]$NumberValue
    )
    return [math]::abs($NumberValue)
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

function Get-Arctangent {
<#
	.SYNOPSIS
		Returns arctangent

		ALIASES
			Atan
		
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
	[Alias("Atan")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [decimal]$Number
	)
    return [math]::atan($Number)
}

function Get-Ascii {
<#
	.SYNOPSIS
		Returns the ascii code number related to the character specified 
		in the string parameter.

		ALIASES
			Asc
     
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
	[Alias("Asc")]
	[CmdletBinding()]
    param (
		[ValidateLength(1, 1)]
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$CharacterText
    )
	
    return [byte][char]$CharacterText
}

function Get-BootTime {
<#
    .SYNOPSIS
		Returns the system boot time

		ALIASES
			Winboot

    .DESCRIPTION
		This function returns the system boot time

	.EXAMPLE
		$BootTime = Get-BootTime
#>
	[Alias("Winboot")]
	param()
	$return = Get-CimInstance -ClassName win32_operatingsystem | fl lastbootuptime | Out-String
	$return = $return.split('e')[1].Trim()
	$return = $(Get-Substring $return 2 $return.length)
	return $return
}

function Get-CarriageReturn {
<#
	.SYNOPSIS
		Returns a carriage return character.

		ALIASES
			Cr
		     
    .DESCRIPTION
		This function returns a carriage return character and does not include a line feed.
		
	.EXAMPLE
		$Label1.Text = "Item 1$(Get-CarriageReturn)$(Get-LineFeed)Item 2$(Get-CarriageReturn)$(Get-LineFeed)Item 3"
	
	.OUTPUTS
		string
#>
	[Alias("Cr")]
	param()
    return Get-Character(13)
}

function Get-Character {
<#
	.SYNOPSIS
		Returns the text character related to the ascii code specified 
		in the string parameter.

		ALIASES
			Chr
     
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
	[Alias("Chr")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$AsciiCode
    )
	return [char][byte]$AsciiCode
}

function Get-ChildWindow {
<#
    .SYNOPSIS
		Gets the first child window handle from a window handle

		ALIASES
			Winchild
			 
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
	[Alias("Winchild")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [System.IntPtr]$Handle
	)
	return [vds]::GetWindow($Handle, 5)
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

function Get-Cosine {
<#
	.SYNOPSIS
		Returns cosine

		ALIASES
			Cos
		
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
	[Alias("Cos")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [decimal]$Number
	)
    return [math]::cos($Number)
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

function Get-EnvironmentVariable {
<#
	.SYNOPSIS
		Returns the environment variable specified

		ALIASES
			Env
		
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
	[Alias("Env")]
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

function Get-Escape {
<#
	.SYNOPSIS
		Returns a escape character

		ALIASES
			Esc
		     
    .DESCRIPTION
		This function returns a escape character
		
	.EXAMPLE
		Send-Window (Get-Window 'Save As...') Get-Escape
	
	.OUTPUTS
		string
#>
	[Alias("Esc")]
	param()
    return Get-Character 27
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

function Get-Exponent {
<#
	.SYNOPSIS
		Returns exponent

		ALIASES
			Exp
		
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
	[Alias("Exp")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [decimal]$Number
	)
    return [math]::exp($Number)
}

function Get-FileExtension {
<#
	.SYNOPSIS
		Gets the extension of a file at the path specified.

		ALIASES
			Ext
		
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
	[Alias("Ext")]
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

function Get-FileName {
<#
    .SYNOPSIS
		Returns the name of the file from the full path

		ALIASES
			Name
			 
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
	[Alias("Name")]
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

		ALIASES
			Path
			 
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
	[Alias("Path")]
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
			ValueFromPipeline)]
		[string]$Path
	)
    return Split-Path -Path $Path
}

function Get-FileShortname {
<#
    .SYNOPSIS
		Returns the shortname from a path

		ALIASES
			Shortname
     
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
	[Alias("Shortname")]
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

function Get-Focus {
<#
    .SYNOPSIS
		Returns the control that has focus on a given form.

		ALIASES
			Focus
			 
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
	[Alias("Focus")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Form
    )
	return $Form.ActiveControl
}

function Get-Fractional {
<#
    .SYNOPSIS
		Returns the portion of a number after the decimal point

		ALIASES
			Frac
			 
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
	[Alias("Frac")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [decimal]$Decimal
	)
    $Decimal = $Decimal | Out-String 
    return $Decimal.split(".")[1]/1	
}

function Get-FreeMemory {
<#
    .SYNOPSIS
		Returns the free memory in kilobytes

		ALIASES
			Mem
		
    .DESCRIPTION
		This function returns the free memory in kilobytes

	.EXAMPLE
		$memory = Get-FreeMemory

#>
	[Alias("Mem")]
	param()
	return (Get-CIMInstance Win32_OperatingSystem | Select FreePhysicalMemory).FreePhysicalMemory
}

function Get-Hex {
<#
    .SYNOPSIS
		Returns hexidecimal from text

		ALIASES
			Hex
			 
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
	[Alias("Hex")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Text
	)
	return $Text | format-hex
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

function Get-InputBox {
<#
    .SYNOPSIS
		Displays a dialog for user input.

		ALIASES
			Input
			 
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
	[Alias("Input")]
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

function Get-Key {
<#
    .SYNOPSIS
		Gets a operation character for the Send-Window function.

		ALIASES
			Key
			 
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
	[Alias("Key")]
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

function Get-LastEvent {
<#
	.SYNOPSIS
		Returns the last event in the call stack.

		ALIASES
			Event
		     
    .DESCRIPTION
		This function returns the last event in the call stack.
		
	.EXAMPLE
		$event = Get-LastEvent
	
	.OUTPUTS
		string
#>
	[Alias("Event")]
	param()
    return (Get-PSCallStack)[1].Command
}

function Get-LineFeed {
<#
    .SYNOPSIS
		Returns a line feed character.

		ALIASES
			Lf
			 
	.DESCRIPTION
		This function returns a line feed character.

	.EXAMPLE
		$lf = Get-LineFeed
	
	.OUTPUTS
		String
#>
	[Alias("Lf")]
	param()
    return Get-Character 10
}

function Get-ListText {
<#
    .SYNOPSIS
		Gets all the items in a list object and converts them to string

		ALIASES
			Text
     
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
	[Alias("Text")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$List
	)
	return [array]$List.items | Out-String
}

function Get-Log {
<#
    .SYNOPSIS
		Returns the logarithm value of a number.

		ALIASES
			Log
			 
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
	[Alias("Log")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [decimal]$NumberValue
    )
	return [math]::log($NumberValue)
}

function Get-MouseButtonDown {
<#
    .SYNOPSIS
		Returns the mouse button that is pressed down.

		ALIASES
			Mousedown
			 
	.DESCRIPTION
		This function returns the mouse button that is pressed down.

	.EXAMPLE
		$mousedown = Get-MouseButtonDown
	
	.OUTPUTS
		MouseButtons as String
#>
	[Alias("Mousedown")]
	param()
	return [System.Windows.Forms.UserControl]::MouseButtons | Out-String
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

function Get-ObjectPosition {
<#
	.SYNOPSIS
		Returns the position of an object specified

		ALIASES
			Dlgpos
		
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
	[Alias("Dlgpos")]
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

function Get-OK {
<#
    .SYNOPSIS
		Returns if the previous command was successful.

		ALIASES
			Ok
			 
	.DESCRIPTION
		This function returns if the previous command was successful.

	.EXAMPLE
		$ok = Get-OK
	
	.OUTPUTS
		Boolean
#>
	[Alias("Ok")]
	param()
    return $?
}

function Get-OKCancelDialog {
<#
    .SYNOPSIS
		Displays an OK Cancel dialog window for input from the user.

		ALIASES
			Query
			 
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
	[Alias("Query")]
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

function Get-PowerShellDesignerVersion {
<#
    .SYNOPSIS
		Returns the current version of PowerShell Designer.

    .DESCRIPTION
		This function returns the current version of PowerShell Designer.

	.EXAMPLE
		$PSDVersion = Get-PowerShellDesignerVersion
#>
	return '2.7.71'
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

function Get-RegistryExists {
<#
    .SYNOPSIS
		Returns if a registry key or value exists as boolean.

		ALIASES
			Regexists
			 
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
	[Alias("Regexists")]
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

function Get-RegistryType {
<#
    .SYNOPSIS
		Returns a registry type from the path to the value

		ALIASES
			Regtype
			 
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
	[Alias("Regtype")]
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

function Get-RegistryValue {
<#
    .SYNOPSIS
		Returns a registry value

		ALIASES
			Regread
			 
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
	[Alias("Regread")]
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string]$Path,
		[Parameter(Mandatory)]
		[string]$Name
	)
	return Get-ItemProperty -Path $Path -Name $Name | Select -ExpandProperty $Name
}

function Get-ScreenHeight {
<#
    .SYNOPSIS
		Returns screen physical screen height as a PSCustomObject

		ALIASES
			Screenheight
		
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
	[Alias("Screenheight")]
	param()
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

function Get-ScreenWidth {
<#
    .SYNOPSIS
		Returns screen physical screen width as a PSCustomObject

		ALIASES
			Screenwidth
		
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
	[Alias("Screenwidth")]
	param()
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

function Get-Sine {
<#
    .SYNOPSIS
		Returns sine from a number

		ALIASES
			Sin
			 
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
	[Alias("Sin")]
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

		ALIASES
			Sqt
			 
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
	[Alias("Sqt")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [decimal]$Number
	)
	return [math]::sqt($Number)
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

function Get-SubString {
<#
	.SYNOPSIS
	Gets the value of a string between a start index and a end index.

		ALIASES
			Substr
		
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
	[Alias("Substr")]
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

function Get-SystemDirectory {
<#
    .SYNOPSIS
		Returns the system directory

		ALIASES
			Sysdir
			 
	.DESCRIPTION
		This function returns the system directory

	.EXAMPLE
		$windir = Get-SystemDirectory
	
	.OUTPUTS
		String
#>
	[Alias("Sysdir")]
	param()
	return [System.Environment]::SystemDirectory
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

function Get-TextPosition {
<#
    .SYNOPSIS
		Retrieves the Text position within a specified string.

		ALIASES
			Pos
			 
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
	[Alias("Pos")]
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

function Get-VirtualKey {
<#
    .SYNOPSIS
		Returns a virtual key

		ALIASES
			VKey
     
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
[Alias("VKey")]
[CmdletBinding()]
[OutputType([uint32])]
param (
    [Parameter(Mandatory, ValueFromPipeline)]
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
		[string]$VirtualKey
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
        [System.IntPtr]$Handle
	)
    $stringbuilt = New-Object System.Text.StringBuilder 256
    $that = [vds]::GetClassName($Handle, $stringbuilt, 256)
    return $($stringbuilt.ToString())
}

function Get-WindowExists {
<#
    .SYNOPSIS
		Returns the handle of a window, or null if it doesn't exists

		ALIASES
			Winexists
			 
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
	[Alias("Winexists")]
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
        [System.IntPtr]$Handle
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
        [System.IntPtr]$Handle
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

function Get-WindowsDirectory {
<#
    .SYNOPSIS
		Returns the windows directory

		ALIASES
			Windir
			 
	.DESCRIPTION
		This function returns the windows directory

	.EXAMPLE
		$windir = Get-WindowsDirectory
	
	.OUTPUTS
		String
#>
	[Alias("Windir")]
	param()
	return Get-EnvironmentVariable windir
}

function Get-WindowSibling {
<#
    .SYNOPSIS
		Returns the sibling of a window
		
		ALIASES
			Winsib
			 
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
	[Alias("Winsib")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [System.IntPtr]$Handle
	)
	return [vds]::GetWindow($Handle, 2)
}

function Get-WindowsVersion {
<#
    .SYNOPSIS
		Returns the current version of Microsoft Windows.
		
		ALIASES
			Winver

    .DESCRIPTION
		This function returns the current version of Microsoft Windows.

	.EXAMPLE
		$WinVersion = Get-WindowsVersion
#>
	[Alias("Winver")]
	param()
	$major = [System.Environment]::OSVersion.Version | Select-Object -expandproperty Major | Out-String
	$minor = [System.Environment]::OSVersion.Version | Select-Object -expandproperty Minor | Out-String
	$build = [System.Environment]::OSVersion.Version | Select-Object -expandproperty Build | Out-String
	$revision = [System.Environment]::OSVersion.Version | Select-Object -expandproperty Revision | Out-String
	return $major.Trim()+'.'+$minor.Trim()+'.'+$build.Trim()+'.'+$revision.Trim()
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
        [System.IntPtr]$Handle
	)
    $strbld = [vds]::GetWindowTextLength($Handle)
    $stringbuilt = New-Object System.Text.StringBuilder $strbld+1
    $that = [vds]::GetWindowText($Handle, $stringbuilt, $strbld+1)
    return $($stringbuilt.ToString())
}

function Get-WPFControl {
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
		Get-WPFControl $Form1 "Button1"
		
	.EXAMPLE
		Get-WPFControl -presentation $Form1 -control "Button1"

	.EXAMPLE
		$Form1 | Get-WPFControl -presentation $Form1 -control "Button1"
		
	.INPUTS
		Presentation as Object, Name as String
	
	.OUTPUTS
		Object
	
	.NOTES
		Normally only useful with externally sourced XAML loaded by Assert-WPF.
#>
	[Alias("Assert-WPFGetControlByName")]
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

function Hide-TaskBar {
<#
    .SYNOPSIS
		Hides the taskbar
		
		ALIASES
			Taskbar-Hide
     
    .DESCRIPTION
		This function will hide the taskbar
		
	.EXAMPLE
		Hide-TaskBar
#>
	[Alias("Taskbar-Hide")]
	param()
	$hWnd = [vds]::FindWindowByClass("Shell_TrayWnd")
	[vds]::ShowWindow($hWnd, "SW_HIDE")	
}

function Hide-Window {
<#
    .SYNOPSIS
		Hides a window
		
		ALIASES
			Window-Hide
			 
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
	[Alias("Window-Hide")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [System.IntPtr]$Handle
	)
	[vds]::ShowWindow($Handle, "SW_HIDE")
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

function Invoke-Form {
<#
	.SYNOPSIS
		Runs a form as an application. 
		
    .DESCRIPTION
		Runs a form as an application. This differs from ShowDialog and Show.
	
	.PARAMETER Form
		The form to run as an application
	
	.EXAMPLE
		Invoke-Form $MainForm
	
	.EXAMPLE
		Invoke-Form -form $MainForm
		
	.EXAMPLE
		$MainWindow | Invoke-Form

	.INPUTS
		Form as Object
#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [object]$Form
	)
	[System.Windows.Forms.Application]::Run($Form) | Out-Null
}

function Move-Cursor {
<#
	.SYNOPSIS
		Sets the mouse cursor to a position without clicking
		
    .DESCRIPTION
		This function sets the position of the cursor to the x and y specified
	
	.PARAMETER x
		The x position to set the cursor to

	.PARAMETER y
		The y position to set the cursor to
	
	.EXAMPLE
		Move-Cursor 23 45
	
	.EXAMPLE
		Move-Cursor -x 23 -y 45

	.INPUTS
		x as Integer, y as Integer
#>

	[CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]$x,
        [Parameter(Mandatory)]
		[int]$y
	)
	[vds]::SetCursorPos($x, $y)
}

function Move-File {
<#
	.SYNOPSIS
		Moves a file to a destination
		
		ALIASES
			File-Move
		
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
	[Alias("File-Move")]
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

function Move-RegistryKey {
<#
    .SYNOPSIS
		Moves a registry key
		
		ALIASES
			Registry-Move
			 
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
	[Alias("Registry-Move")]
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

function Move-Window {
<#
    .SYNOPSIS
		Moves a window
		
		ALIASES
			Window-Position
			 
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
	[Alias("Window-Position")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [System.IntPtr]$Handle,
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

function New-Beep {
<#
    .SYNOPSIS
		Beeps
		
		ALIASES
			Beep
     
    .DESCRIPTION
		Plays a system beep sound.
	
	.EXAMPLE
		New-Beep
	
	.OUTPUTS
		System Beep Sound
#>
	[Alias("Beep")]
	param()
    [console]::beep(500,300)
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

function New-Folder {
<#
	.SYNOPSIS
		Creates a new folder at the path specified
		
		ALIASES
			Directory-Create
		
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
	[Alias("Directory-Create")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Path
	)
	New-Item -ItemType directory -Path $Path
}

function New-Form {
<#
	.SYNOPSIS
		Creates a new vdsForm
		
		ALIASES
			Dialog-Create
		
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
	[Alias("Dialog-Create")]
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

function New-RegistryKey {
<#
    .SYNOPSIS
		Creates a registry key
		
		ALIASES
			Regkey
			 
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
	[Alias("Regkey")]
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

function New-SendMessage {
<#
    .SYNOPSIS
		Sends a message to a window object using sendmessage API
		
		ALIASES
			Sendmsg
			 
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
	[Alias("Sendmsg")]
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
		
		ALIASES
			Shell
			 
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
	[Alias("Shell")]
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
	[Alias("Link")]
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

function New-Sound {
<#
    .SYNOPSIS
		Plays a sound according to the path specified. 

		ALIASES
			Play
			 
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
	[Alias("Play")]
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
	[Alias("taskicon")]
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
	[Alias("Timer")]
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

function New-WPFWindow {
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
		New-WPFWindow "Brandon's Window" "480" "800" "Grid1"
		
	.EXAMPLE
		New-WPFWindow -title "Brandon's Window" -height "480" -width "800" -grid "Grid1"

	.EXAMPLE
		"Brandon's Window" | New-WPFWindow -height "480" -width "800" -grid "Grid1"
		
	.INPUTS
		Title as String, Height as String, Width as String, Grid as String
	
	.OUTPUTS
		Windows.Markup.XamlReader
#>
	[Alias("Assert-WPFCreate")]
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

function Protect-Secret {
<#
	.SYNOPSIS
		Encrypts a secret with a value key pair.
		
		ALIASES
			Encrypt
		
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
	[Alias("Encrypt")]
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

function Push-WPFControl {
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
		$Button1 = Push-WPFControl 'Button' 'Grid1'
		
	.EXAMPLE
		$Button1 = Push-WPFControl -ControlType 'Button' -Container 'Grid1'

	.EXAMPLE
		$Button1 = 'Button' | Push-WPFControl -Container 'Grid1'
		
	.INPUTS
		ControlType as ValidatedString, Container as Object
	
	.OUTPUTS
		System.Windows.Controls.$ControlType
#>
	[Alias("Assert-WPFInsertControl")]
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

function Read-InitializationFile {
<#
    .SYNOPSIS
		Reads a key value pair from a section of a initialization file.
		
		ALIASES
			Iniread
			 
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
	[Alias("Iniread")]
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

function Remove-File {
<#
	.SYNOPSIS
		Removes a file at the path specified
		
		ALIASES
			File-Delete
		
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
	[Alias("File-Delete")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Path
	)	
	Remove-item -path $Path -force
}

function Remove-Folder {
<#
	.SYNOPSIS
		Removes a folder at the path specified
		
		ALIASES
			Directory-Delete
		
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
	[Alias("Directory-Delete")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Path
	)
	Remove-Item -path $Path -recurse -force
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

function Remove-RegistryValue {
<#
    .SYNOPSIS
		Removes a registry value
		
		ALIASES
			Registry-Delete
			 
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
	[Alias("Registry-Delete")]
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string]$Path,
		[Parameter(Mandatory)]
		[string]$Name
	)		
	Remove-ItemProperty -Path $Path -Name $Name
}

function Rename-File {
<#
	.SYNOPSIS
		Renames a file

		ALIASES
			File-Rename
		
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
	[Alias("File-Rename")]
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

function Rename-Folder {
<#
	.SYNOPSIS
		Renames a folder at the path specified
		
		ALIASES
			Directory-Rename
		
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
	[Alias("Directory-Rename")]
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

function Send-ClickToWindow {
<#
    .SYNOPSIS
		Sends a click to a window by the handle, x and y specified.
		
		ALIASES
			Window-Click
			 
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
	[Alias("Window-Click")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [System.IntPtr]$Handle,
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

function Send-KeyDown {
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
        $vKey
	)
	[vds]::keybd_event($vKey,0,0,[UIntPtr]::new(0))
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
	Start-Sleep -Milliseconds ($Seconds * 1000)
	[vds]::keybd_event($vKey,0,2,[UIntPtr]::new(0))
}

function Send-KeyUp {
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
        $vKey
	)
	[vds]::keybd_event($vKey,0,2,[UIntPtr]::new(0))
}

function Send-RightClickToWindow {
<#
    .SYNOPSIS
		Sends a right click to a window by the handle, x and y specified.

		ALIASES
			Window-RClick
			 
b
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
	[Alias("Window-RClick")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [System.IntPtr]$Handle,
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
		
	.PARAMETER Val
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

function Send-Window {
<#
    .SYNOPSIS
		Sends a string to a window

		ALIASES
			Window-Send
			 
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
	[Alias("Window-Send")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [System.IntPtr]$Handle,
		[string]$String
	)
	Set-ActiveWindow $Handle
	$wshell = New-Object -ComObject wscript.shell
	$wshell.SendKeys("$String")
}

function Set-ActiveWindow {
<#
    .SYNOPSIS
		Sets the window as active
		
		ALIASES
			Window-Activate
			 
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
	[Alias("Window-Activate")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [System.IntPtr]$Handle
	)
	[vds]::SetForegroundWindow($Handle)
}

function Set-CurrentDirectory {
<#
	.SYNOPSIS
		Changes the current working directory to the path specified.
		
		ALIASES
			Directory-Change
		
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
	[Alias("Directory-Change")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Path
	)
	Set-Location $Path
    [Environment]::CurrentDirectory = $Path
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

function Set-ExitCode {
<#
	.SYNOPSIS
		Exits the application with the code specified.
		
		ALIASES
			Exit
		
    .DESCRIPTION
		This function exits the application with the code specified.
	
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
	[Alias("Exit")]
	[CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [int]$ExitCode
	)	
	exit $ExitCode
}

function Set-FileAttribute {
<#
	.SYNOPSIS
		Sets the attribute of a file

		ALIAS
			File-Setattr
		
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
	[Alias("File-Setattr")]
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

function Set-FlashWindow {
<#
    .SYNOPSIS
		Flashes the icon of a window
		
		ALIAS
			Window-Flash
			 
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
	[Alias("Window-Flash")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [System.IntPtr]$Handle
	)
	[Window]::FlashWindow($Handle,150,10)
}

function Set-Focus {
<#
    .SYNOPSIS
		Sets the focus of a form to a control
		
		ALIAS
			Dialog-Focus
			 
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
	[Alias("Dialog-Focus")]
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

function Set-Format {
<#
    .SYNOPSIS
		Formats text according to a specification string
		
		ALIAS
			Format
			 
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
	[Alias("Format")]
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

function Set-ObjectPosition {
<#
	.SYNOPSIS
		Properly sets the position of a DPIAware object created with this module.
		
		ALIAS
			Dialog-Setpos
		
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
	[Alias("Dialog-Setpos")]
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

function Set-WindowNotOnTop {
<#
    .SYNOPSIS
		Causes a window to not be on top of other windows
		
		ALIAS
			Window-NotOnTop
			 
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
	[Alias("Window-NotOnTop")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [System.IntPtr]$Handle
	)
	[vds]::SetWindowPos($Handle, -2, (Get-WindowPosition $Handle).Left, (Get-WindowPosition $Handle).Top, (Get-WindowPosition $Handle).Width, (Get-WindowPosition $Handle).Height, 0x0040) | out-null
}

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
        [System.IntPtr]$Handle
	)
	[vds]::SetWindowPos($Handle, -1, (Get-WindowPosition $Handle).Left, (Get-WindowPosition $Handle).Top, (Get-WindowPosition $Handle).Width, (Get-WindowPosition $Handle).Height, 0x0040) | out-null
}

function Set-WindowParent {
<#
    .SYNOPSIS
		This function fuses a window into another window
		
		ALIAS
			Window-Fuse
			 
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
	[Alias("Window-Fuse")]
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

function Set-WindowText {
<#
    .SYNOPSIS
		Sets the text of a window
		
		ALIAS
			Window-Settext
			 
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
	[Alias("Window-Settext")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [System.IntPtr]$Handle,
		[string]$Text
	)
	[vds]::SetWindowText($Handle,$Text)
}

function Set-WPFHAlign {
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
		Set-WPFHAlign $Button1 'Left'
		
	.EXAMPLE
		Set-WPFHAlign -Object $Button1 -halign 'Center'

	.EXAMPLE
		$Button1 | Set-WPFHAlign -halign 'Right'
		
	.INPUTS
		Object as Object, Halign as String
	
	.OUTPUTS
		Format of Horizontal Alignment
#>
	[Alias("Assert-WPFHAlign")]
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

function Set-WPFValign {
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
		Set-WPFValign $Button1 'Top'
		
	.EXAMPLE
		Set-WPFValign -Object $Button1 -valign 'Top'

	.EXAMPLE
		$Button1 | Set-WPFValign -valign 'Top'
		
	.INPUTS
		Object as Object, Valign as String
	
	.OUTPUTS
		Format of Vertical Alignment
#>
	[Alias("Assert-WPFValign")]
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

function Show-ColorDialog {
<#
	.SYNOPSIS
		Presents a color dialog to the end user for color selection
		
		ALIAS
			Colordlg
		     
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
	[Alias("Colordlg")]
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

function Show-FolderBrowserDialog {
<#
	.SYNOPSIS
		Returns the value from a Foloder Browser Dialog.
		
		ALIAS
			Dirdlg
		
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
	[Alias("Dirdlg")]
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

function Show-FontDialog {
<#
    .SYNOPSIS
		Returns a font dialog
		
		ALIAS
			Fontdlg
			 
	.DESCRIPTION
		This function returns a font dialog
	
	.EXAMPLE
		$font = Show-FontDialog
	
	.OUTPUTS
		Windows.Forms.FontDialog
#>
	[Alias("Fontdlg")]
	param()
    $fontdlg = new-object windows.forms.fontdialog
    $fontdlg.showcolor = $true
    $fontdlg.ShowDialog()
    return $fontdlg
}

function Show-Form {
<#
	.SYNOPSIS
		Shows a form
								   
		
		ALIAS
			Dialog-Show
		
    .DESCRIPTION
		This function will show a form, or show a form modal according to the modal switch.
				   
	
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
									 
			$Form.Show() | Out-Null
   
		
							 
															
   
	}
}

function Show-HTMLHelp {
<#
    .SYNOPSIS
		Displays a page in a compiled html manual.
		
		ALIAS
			HTMLHelp
			 
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
	[Alias("HTMLHelp")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$chm
	)
	start-process -filepath hh.exe -argumentlist $chm
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


function Show-OpenFileDialog {
<#
	.SYNOPSIS
		Shows a window for opening a file.
		
		ALIAS
			Filedlg
		
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
	[Alias("Filedlg")]
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

function Show-PageSetupDialog {
<#
	.SYNOPSIS
		Shows a window for opening a file.
		
		ALIAS
			Filedlg
		
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
	[Alias("Filedlg")]
	[CmdletBinding()]
    param (
		[Parameter(ValueFromPipeline)]
		[string]$InitialDirectory,
		[string]$Filter
	)
	$filedlg = New-Object System.Windows.Forms.PageSetupDialog
	$filedlg.initialDirectory = $initialDirectory
	$filedlg.filter = $Filter
	$filedlg.ShowDialog() | Out-Null
	return $filedlg.FileName
}


function Show-SaveFileDialog {
<#
	.SYNOPSIS
		Shows a window for saving a file.
		
		ALIAS
			Savedlg
		
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
	[Alias("Savedlg")]
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

function Show-TaskBar {
<#
    .SYNOPSIS
		Shows the taskbar
		
		ALIASES
			Taskbar-Show
     
    .DESCRIPTION
		This function will show the taskbar
		
	.EXAMPLE
		Show-TaskBar
#>
	[Alias("Taskbar-Show")]
	param()
	$hWnd = [vds]::FindWindowByClass("Shell_TrayWnd")
	[vds]::ShowWindow($hWnd, "SW_SHOW_DEFAULT")
}

function Show-Warning {
	<#
    .SYNOPSIS
		Displays a warning dialog
		
		ALIAS
			Warn
			 
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
	[Alias("Warn")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [string]$Message,
		[string]$Title
	)
	[System.Windows.Forms.MessageBox]::Show($Message,$Title,'OK',48)
}

function Show-Window {
<#
    .SYNOPSIS
		Shows a window
		
		ALIAS
			Window-Normal
			 
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
	[Alias("Window-Normal")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory,
			ValueFromPipeline)]
        [System.IntPtr]$Handle
	)
	[vds]::ShowWindow($Handle, "SW_SHOW_NORMAL")
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

function Step-ListNext {
<#
    .SYNOPSIS
		Steps to the next item in a list
		
		ALIAS
			Next
			 
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
	[Alias("Next")]
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

function Test-File {
<#
	.SYNOPSIS
		Test for the existance of a file
		
		ALIAS
			File
		
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
	[Alias("File")]
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

function Unprotect-Secret {
<#
	.SYNOPSIS
		Decrypts a secret from a value key pair.
		
		ALIAS
			Decrypt
		
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
	[Alias("Decrypt")]
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

function Write-InitializationFile {
<#
    .SYNOPSIS
		Writes a key value pair to a section of a initialization file.
		
		ALIAS
			Inifile-Write
			 
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
	[Alias("Inifile-Write")]
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





