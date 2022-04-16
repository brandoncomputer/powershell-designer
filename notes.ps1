[Reflection.Assembly]::LoadFile("$(curdir)\FastColoredTextBox.dll") | out-null
$FastText = New-Object FastColoredTextBoxNS.FastColoredTextBox
dialog property $FastText language $language
$FastTab.SelectedTab.Controls.Add($FastText)
$FastText.OpenFile($fileOpen)
$FastText.SaveFile($fileOpen)