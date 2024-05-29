#region Images

#endregion

ConvertFrom-WPFXaml -xaml @"
<Window x:Name="MainWindow" x:Class="Button_Test.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:Button_Test"
        mc:Ignorable="d"
        Title="MainWindow" Height="6000" Width="8000" WindowStyle="None" ResizeMode="NoResize">
    <Grid>
        <Button x:Name="Button" Content="Button" HorizontalAlignment="Left" Margin="85,87,0,0" VerticalAlignment="Top" Width="75"/>

    </Grid>
</Window>
"@

$Button.Add_Click({Show-InformationDialog -Message 'Hello' -Title $Title})

$MainWindow.Show()
$MainWindow.Top = 0
$MainWindow.Left = 0

Set-WindowParent (Get-WindowExists "MainWindow") $MainForm.Handle

#end region



