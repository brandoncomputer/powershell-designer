#region Images
 
#endregion

<#
The MIT License (MIT)

Copyright (c) 2015 Microsoft

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


$page = @"
<Page xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" 
      xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
      x:Class="ControlsAndLayout.Scene"
      WindowTitle="XAMLPad Express">
    <Grid Name="MainGrid">
        <Grid.Resources>

            <XmlDataProvider x:Key="SamplesList" XPath="/Samples">
<x:XData>
<Samples xmlns="" >

    <Category Title="Layout">
        <Sample Path="samps\border_samp.xaml" Title="Border" Description="Border draws a border, background, or both around another element."
                >
            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <Border Background="LightGray" CornerRadius="10" Padding="10"  HorizontalAlignment="Center" VerticalAlignment="center" BorderBrush="Black" BorderThickness="4">
        <TextBlock>Content inside of a Border</TextBlock>
    </Border>
</Grid>]]>
            </Syntax>
        </Sample>
        <Sample Path="samps\canvas_samp.xaml"   Title="Canvas" Description="Canvas defines an area within which you can explicitly position child elements by coordinates relative to the Canvas area.">
            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <Canvas Margin="10">
        <Canvas Height="100" Width="100"  Top="0" Left="0">
            <Rectangle Width="100" Height="100" Fill="red"/>
        </Canvas>
        <Canvas Height="100" Width="100" Top="100" Left="100">
            <Rectangle Width="100" Height="100" Fill="green"/>
         </Canvas>
         <Canvas Height="100" Width="100" Top="50" Left="50">
            <Rectangle Width="100" Height="100" Fill="blue"/>
         </Canvas>
     </Canvas>
</Grid>]]>
            </Syntax>
        </Sample>

        <Sample Path="samps\grid_samp.xaml"         Title="Grid"  Description="Grid defines a flexible grid area consisting of columns and rows. Child elements of a Grid can be positioned precisely using the Margin property." >
            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <Grid ShowGridLines="false" Background="White">
            <Grid.Resources>
                <Style TargetType="{x:Type ColumnDefinition}">
                    <Setter Property="ColumnDefinition.Width" Value="30"/>
                </Style>
                <Style TargetType="{x:Type Rectangle}">
                    <Setter Property="Rectangle.RadiusX" Value="6"/>
                    <Setter Property="Rectangle.RadiusY" Value="6"/>
                </Style>
                <Style x:Key="DayOfWeek">
                    <Setter Property="Grid.Row" Value="1"></Setter>
                    <Setter Property="TextBlock.Margin" Value="5"></Setter>
                </Style>
                <Style x:Key="OneDate">
                    <Setter Property="TextBlock.Margin" Value="5"></Setter>
                </Style>                
            </Grid.Resources>
            <Grid.ColumnDefinitions>
            <ColumnDefinition/>
            <ColumnDefinition/>
            <ColumnDefinition/>
            <ColumnDefinition/>
            <ColumnDefinition/>
            <ColumnDefinition/>
            <ColumnDefinition/>
            <ColumnDefinition Width="*"/>
            <!-- This column will receive all remaining width -->
            </Grid.ColumnDefinitions>
            <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition/>
            <!-- This row will receive all remaining Height -->
            </Grid.RowDefinitions>
            <!-- These Rectangles constitute the backgrounds of the various Rows and Columns -->

            <Rectangle Grid.ColumnSpan="7" Fill="#73B2F5"/>
            <Rectangle Grid.Row="1" Grid.RowSpan="6"  Fill="#73B2F5"/>
            <Rectangle Grid.Column="6" Grid.Row="1" Grid.RowSpan="6" Fill="#73B2F5"/>
            <Rectangle Grid.Column="1" Grid.Row="1" Grid.ColumnSpan="5" Grid.RowSpan="6"
            Fill="#efefef"/>

            <!-- Month row -->
            <TextBlock Grid.ColumnSpan="7" Margin="0,5,0,5" HorizontalAlignment="Center">
                January 2004</TextBlock>

            <!-- Draws a separator under the days-of-the-week row -->

            <Rectangle Grid.Row="1" Grid.ColumnSpan="7" 
            Fill="Black" RadiusX="1" RadiusY="1" Height="2" Margin="0,20,0,0"/>

            <!-- Day-of-the-week row -->
            <TextBlock Grid.Column="0" Style="{StaticResource DayOfWeek}">Sun</TextBlock>
            <TextBlock Grid.Column="1" Style="{StaticResource DayOfWeek}">Mon</TextBlock>
            <TextBlock Grid.Column="2" Style="{StaticResource DayOfWeek}">Tue</TextBlock>
            <TextBlock Grid.Column="3" Style="{StaticResource DayOfWeek}">Wed</TextBlock>
            <TextBlock Grid.Column="4" Style="{StaticResource DayOfWeek}">Thu</TextBlock>
            <TextBlock Grid.Column="5" Style="{StaticResource DayOfWeek}">Fri</TextBlock>
            <TextBlock Grid.Column="6" Style="{StaticResource DayOfWeek}">Sat</TextBlock>

            <!-- Dates go here -->
            <TextBlock Grid.Column="4" Grid.Row="2" Style="{StaticResource OneDate}">1</TextBlock>
            <TextBlock Grid.Column="5" Grid.Row="2" Style="{StaticResource OneDate}">2</TextBlock>
            <TextBlock Grid.Column="6" Grid.Row="2" Style="{StaticResource OneDate}">3</TextBlock>
            <TextBlock Grid.Column="0" Grid.Row="3" Style="{StaticResource OneDate}">4</TextBlock>
            <TextBlock Grid.Column="1" Grid.Row="3" Style="{StaticResource OneDate}">5</TextBlock>
            <TextBlock Grid.Column="2" Grid.Row="3" Style="{StaticResource OneDate}">6</TextBlock>
            <TextBlock Grid.Column="3" Grid.Row="3" Style="{StaticResource OneDate}">7</TextBlock>
            <TextBlock Grid.Column="4" Grid.Row="3" Style="{StaticResource OneDate}">8</TextBlock>
            <TextBlock Grid.Column="5" Grid.Row="3" Style="{StaticResource OneDate}">9</TextBlock>
            <TextBlock Grid.Column="6" Grid.Row="3" Style="{StaticResource OneDate}">10</TextBlock>
            <TextBlock Grid.Column="0" Grid.Row="4" Style="{StaticResource OneDate}">11</TextBlock>
            <TextBlock Grid.Column="1" Grid.Row="4" Style="{StaticResource OneDate}">12</TextBlock>
            <TextBlock Grid.Column="2" Grid.Row="4" Style="{StaticResource OneDate}">13</TextBlock>
            <TextBlock Grid.Column="3" Grid.Row="4" Style="{StaticResource OneDate}">14</TextBlock>
            <TextBlock Grid.Column="4" Grid.Row="4" Style="{StaticResource OneDate}">15</TextBlock>
            <TextBlock Grid.Column="5" Grid.Row="4" Style="{StaticResource OneDate}">16</TextBlock>
            <TextBlock Grid.Column="6" Grid.Row="4" Style="{StaticResource OneDate}">17</TextBlock>
            <TextBlock Grid.Column="0" Grid.Row="5" Style="{StaticResource OneDate}">18</TextBlock>
            <TextBlock Grid.Column="1" Grid.Row="5" Style="{StaticResource OneDate}">19</TextBlock>
            <TextBlock Grid.Column="2" Grid.Row="5" Style="{StaticResource OneDate}">20</TextBlock>
            <TextBlock Grid.Column="3" Grid.Row="5" Style="{StaticResource OneDate}">21</TextBlock>
            <TextBlock Grid.Column="4" Grid.Row="5" Style="{StaticResource OneDate}">22</TextBlock>
            <TextBlock Grid.Column="5" Grid.Row="5" Style="{StaticResource OneDate}">23</TextBlock>
            <TextBlock Grid.Column="6" Grid.Row="5" Style="{StaticResource OneDate}">24</TextBlock>
            <TextBlock Grid.Column="0" Grid.Row="6" Style="{StaticResource OneDate}">25</TextBlock>
            <TextBlock Grid.Column="1" Grid.Row="6" Style="{StaticResource OneDate}">26</TextBlock>
            <TextBlock Grid.Column="2" Grid.Row="6" Style="{StaticResource OneDate}">27</TextBlock>
            <TextBlock Grid.Column="3" Grid.Row="6" Style="{StaticResource OneDate}">28</TextBlock>
            <TextBlock Grid.Column="4" Grid.Row="6" Style="{StaticResource OneDate}">29</TextBlock>
            <TextBlock Grid.Column="5" Grid.Row="6" Style="{StaticResource OneDate}">30</TextBlock>
            <TextBlock Grid.Column="6" Grid.Row="6" Style="{StaticResource OneDate}">31</TextBlock>
        </Grid>
</Grid>]]>
            </Syntax>
        </Sample>
        <Sample Path="samps\dockpanel_samp.xaml"    Title="DockPanel" Description="DockPanel defines an area within which you can arrange child elements either horizontally or vertically, relative to each other.">
            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <DockPanel>
        <Border Height="25" Background="SkyBlue" BorderBrush="Black" BorderThickness="1" DockPanel.Dock="Top">
            <TextBlock Foreground="black">Dock = "Top"</TextBlock>
        </Border>
        <Border Height="25" Background="SkyBlue" BorderBrush="Black" BorderThickness="1" DockPanel.Dock="Top">
            <TextBlock Foreground="black">Dock = "Top"</TextBlock>
        </Border>
        <Border Height="25" Background="#ffff99" BorderBrush="Black" BorderThickness="1" DockPanel.Dock="Bottom">
            <TextBlock Foreground="black">Dock = "Bottom"</TextBlock>
        </Border>
        <Border Width="200" Background="PaleGreen" BorderBrush="Black" BorderThickness="1" DockPanel.Dock="Left">
            <TextBlock Foreground="black">Dock = "Left"</TextBlock>
        </Border>
        <Border Background="White" BorderBrush="Black" BorderThickness="1">
            <TextBlock Foreground="black">This content fills the remaining, unallocated space.</TextBlock>
        </Border>
    </DockPanel>
</Grid>]]>
            </Syntax>
        </Sample>

        <Sample Path="samps\viewbox_samp.xaml"      Title="ViewBox" Description="Viewbox is a content decorator, wherein a single child can be stretched and scaled to fill the available space." >
            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <Viewbox MaxWidth="500" MaxHeight="500" StretchDirection="Both" Stretch="Fill">
            <Grid >
            <Ellipse Fill="#99ccff" Stroke="RoyalBlue" StrokeDashArray="3"  />
            <TextBlock Text="Viewbox" />
            </Grid>
    </Viewbox>
</Grid>]]>
            </Syntax>
        </Sample>

        <Sample Path="samps\stackpanel_samp.xaml"   Title="StackPanel" Description="StackPanel arranges child elements into a single line that can be oriented horizontally or vertically." >
            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <StackPanel>
        <Border Background="SkyBlue" BorderBrush="Black" BorderThickness="1">
            <TextBlock Foreground="black" FontSize="12">Stacked Item #1</TextBlock>
        </Border>
        <Border Width="400" Background="CadetBlue" BorderBrush="Black" BorderThickness="1">
            <TextBlock Foreground="black" FontSize="14">Stacked Item #2</TextBlock>
        </Border>
        <Border Background="#ffff99" BorderBrush="Black" BorderThickness="1">
            <TextBlock Foreground="black" FontSize="16">Stacked Item #3</TextBlock>
        </Border>
        <Border Width="200" Background="PaleGreen" BorderBrush="Black" BorderThickness="1">
            <TextBlock Foreground="black" FontSize="18">Stacked Item #4</TextBlock>
        </Border>
        <Border Background="White" BorderBrush="Black" BorderThickness="1">
            <TextBlock Foreground="black" FontSize="20">Stacked Item #5</TextBlock>
        </Border>
    </StackPanel>
</Grid>]]>
            </Syntax>
        </Sample>

    </Category>
    <Category Title="Control">
        <Sample Path="samps\button_samp.xaml"  Category="Components and Controls"   Title="Button" Description="Button represents the standard button component that inherently reacts to the Click event. The Button control is one of the most basic forms of user interface (UI).">

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <Button HorizontalAlignment="Center" VerticalAlignment="center">Click Me</Button>
</Grid>]]>
            </Syntax>
        </Sample>

        <Sample Path="samps\checkbox_samp.xaml"     Title="CheckBox" Description="Represents a button that can be selected and cleared by a user.">

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <CheckBox HorizontalAlignment="Center" VerticalAlignment="Center" Name="cb1">Check Box</CheckBox>
</Grid>]]>
            </Syntax>
        </Sample>
        <Sample Path="samps\combobox_samp.xaml"     Title="ComboBox"  Description="Represents a selection control in a drop-down list form. The items in the ComboBox can be shown and hidden by clicking the button on the control.">

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <ComboBox HorizontalAlignment="Center" VerticalAlignment="Center">
    <ComboBoxItem>Item1</ComboBoxItem>
    <ComboBoxItem>Item2</ComboBoxItem>
    <ComboBoxItem>Item3</ComboBoxItem>
</ComboBox>
</Grid>]]>
            </Syntax>
        </Sample>
        <Sample Path="samps\expander_samp.xaml"     Title="Expander" Description="Control that allows a user to view a header that expands to display more content or collapses to save space." >

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <Expander Width="100" Height="100" VerticalAlignment="Top" HorizontalAlignment="Left" IsExpanded="false" Background="Red" Header="header" Content="content"/>

</Grid>]]>
            </Syntax>
        </Sample>   
        <Sample Path="samps\hyperlink_samp.xaml"    Title="Hyperlink" Description="Implements a Hyperlink element that can provides linking support to other content." >

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <TextBlock><Hyperlink NavigateUri="http://msdn.microsoft.com/library">Navigate to MSDN</Hyperlink></TextBlock>
</Grid>]]>
                </Syntax>
            </Sample>
        <Sample Path="samps\image_samp.xaml" Title="Image" Description="Provides an easy way to include an image in a document or an application.">

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <Image Source="Images\tulip_farm.jpg" Stretch="None" HorizontalAlignment="Center" VerticalAlignment="Center"/>
</Grid>]]>
            </Syntax>
        </Sample>
        <Sample Path="samps\inkcanvas_samp.xaml"    Title="InkCanvas" Description="Defines an area that receives and displays ink strokes." >

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <InkCanvas EditingMode="Ink" MaxWidth="300" MaxHeight="300">
                <TextBlock>Use your Mouse or Stylus to draw on the screen.</TextBlock>
            </InkCanvas>
</Grid>]]>
            </Syntax>
        </Sample>
        <Sample Path="samps\listbox_samp.xaml"      Title="ListBox" Description="Control that implements a list of selectable items.">

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <ListBox VerticalAlignment="Center" HorizontalAlignment="Center">
        <ListBoxItem>Item 1</ListBoxItem>
        <ListBoxItem>Item 2</ListBoxItem>
        <ListBoxItem>Item 3</ListBoxItem>
        <ListBoxItem>Item 4</ListBoxItem>
        <ListBoxItem>Item 5</ListBoxItem>
</ListBox>
</Grid>]]>
            </Syntax>
        </Sample>
        <Sample Path="samps\menu_samp.xaml"         Title="Menu" Description="Represents the control that enables you to hierarchically organize elements associated with commands and event handlers." >

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
<Menu Background="Gray" HorizontalAlignment="Center" VerticalAlignment="Center">
   <MenuItem Header="File">
          <MenuItem Header="New"/>
          <MenuItem Header="Open"/>
            <Separator/>
          <MenuItem Header="submenu">
                <MenuItem Header="submenuitem1"/>
                <MenuItem Header="submenuitem2">          
                      <MenuItem Header="submenuitem2.1"/>
                </MenuItem>
         </MenuItem>
   </MenuItem>
   <MenuItem Header="View">
       <MenuItem Header="Source"/>
    </MenuItem>   
</Menu>
</Grid>]]>
            </Syntax>
        </Sample>
        <Sample Path="samps\passwordbox_samp.xaml"      Title="PasswordBox" Description="Represents a text box control used for password processing." >

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <PasswordBox HorizontalAlignment="Center" VerticalAlignment="Center"/>
</Grid>]]>
            </Syntax>
        </Sample>
        <Sample Path="samps\radiobutton_samp.xaml"      Title="RadioButton" Description="Represents a radio button control which presents a set of two or more mutually exclusive choices to the user. While radio buttons and check boxes might appear to function similarly, there is an important difference: when a user selects a radio button, the other radio buttons in the same group cannot be selected as well. In contrast, any number of check boxes can be selected." >

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <RadioButton Name="rb1" HorizontalAlignment="Center" VerticalAlignment="Center" FontSize="14">Radio Button</RadioButton>

</Grid>]]>
            </Syntax>
        </Sample>
        <Sample Path="samps\richtextbox_samp.xaml"      Title="RichTextBox" Description="Represents a text box with rich editing capabilities." >

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <RichTextBox HorizontalAlignment="Center" VerticalAlignment="Center" Height="100" Width="100">
        <FlowDocument>
            <Paragraph>
                Some Content
            </Paragraph>
        </FlowDocument>
    </RichTextBox>
</Grid>]]>
            </Syntax>
        </Sample>
        <Sample Path="samps\scrollviewer_samp.xaml"     Title="ScrollViewer" Description="ScrollViewer represents a scrollable area that can contain other visible elements. The ScrollViewer element encapsulates a content element and possibly up to two ScrollBar controls.">

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <ScrollViewer >          
    <StackPanel VerticalAlignment="Top" HorizontalAlignment="Left">
        <TextBlock TextWrapping="Wrap" Margin="0,0,0,20">Scrolling is
        enabled when it is necessary.</TextBlock>
        <Rectangle Fill="Red" Width="400" Height="800"></Rectangle>
    </StackPanel>
</ScrollViewer> 
</Grid>]]>
            </Syntax>
        </Sample>
        
<Sample Path="samps\documentviewer_samp.xaml" Title="SinglePageViewer"  Description="The SinglePageViewer control enables applications to host a customized reading experience for paginated content.">

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
<Grid.Resources>
        <Style x:Key="SubHeaderStyle" TargetType="Paragraph">
            <Setter Property="Foreground" Value="Gray" />
            <Setter Property="FontSize" Value="14" />
        </Style>
        <Style x:Key="mainContentStyle" TargetType="Paragraph">
            <Setter Property="Foreground" Value="Black" />
            <Setter Property="FontSize" Value="12" />
        </Style>
        <Style x:Key="HeaderStyle" TargetType="Paragraph">
            <Setter Property="Foreground" Value="Gray" />
            <Setter Property="FontSize" Value="24" />
        </Style>
        <Style x:Key="DisStyle" TargetType="Paragraph">
            <Setter Property="Foreground" Value="Silver" />
            <Setter Property="FontSize" Value="18" />
        </Style>   
</Grid.Resources>
<FlowDocumentPageViewer>          
<FlowDocument xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">

    <Paragraph Style="{StaticResource HeaderStyle}">Canvas Overview</Paragraph>
    <Paragraph><Rectangle Fill="Black" Height="1" Width="500" HorizontalAlignment="Left" /><LineBreak/></Paragraph>
    
    <Paragraph Style="{StaticResource DisStyle}">[This topic is pre-release documentation and is subject to change in future releases. Blank topics are included as placeholders.]<LineBreak/></Paragraph>
<Paragraph Style="{StaticResource mainContentStyle}">The Canvas element is used to position content according to absolute x- and y-coordinates. Canvas provides ultimate flexibility for positioning and arranging elements on the screen. Elements can be drawn in a unique location, or in the event that elements occupy the same coordinates, the order in which they appear in markup determines the order in which elements are drawn.</Paragraph>

<Paragraph Style="{StaticResource mainContentStyle}">This topic contains the following sections.</Paragraph>

<List>

<ListItem><Paragraph Style="{StaticResource mainContentStyle}">What Can I Do with the Canvas?</Paragraph></ListItem>
<ListItem><Paragraph Style="{StaticResource mainContentStyle}">Adding a Border to a Canvas Element</Paragraph></ListItem>
<ListItem><Paragraph Style="{StaticResource mainContentStyle}">Order of Elements in a Canvas</Paragraph></ListItem>
<ListItem><Paragraph Style="{StaticResource mainContentStyle}">Creating a Canvas in "XAML"</Paragraph></ListItem>
<ListItem><Paragraph Style="{StaticResource mainContentStyle}">Creating a Canvas in Code</Paragraph></ListItem>

</List>
    
    <Paragraph Style="{StaticResource SubHeaderStyle}">What Can I Do with the Canvas?</Paragraph>
    <Paragraph Style="{StaticResource mainContentStyle}">Canvas provides the most flexible layout support of any Panel element. Height and Width properties are used to define the area of the canvas, and elements inside are assigned absolute coordinates relative to the upper left corner of the parent Canvas. This allows you to position and arrange elements precisely where you want them on the screen.</Paragraph>

<Paragraph Style="{StaticResource SubHeaderStyle}">Adding a Border to a Canvas Element</Paragraph>
<Paragraph Style="{StaticResource mainContentStyle}">In order for a Canvas element to have a border, it must be encapsulated within a Border element.</Paragraph>
</FlowDocument>
</FlowDocumentPageViewer>
</Grid>]]>
            </Syntax>
        </Sample>
            <Sample Path="samps\horizontalslider_samp.xaml"  Title="Slider" Description="Composite control that enables a user to select from a range of values." >

                <Syntax>
                    <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <Slider Orientation="Horizontal" VerticalAlignment="Center" HorizontalAlignment="Center" Width="150" Value="0"/>
</Grid>]]>
            </Syntax>
        </Sample>        
     

        <Sample Path="samps\tabcontrol_samp.xaml"   Title="TabControl" Description="Represents a control that allows visual content to be arranged in a tabular form.">

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <TabControl HorizontalAlignment="Center" VerticalAlignment="Center">
    <TabItem Header="Background" IsSelected="true"><Button Name="btn" Background="LightGray">Background</Button>
    </TabItem>
    <TabItem Header="Foreground"><Button Name="btn1" Foreground="Black">Foreground</Button>
    </TabItem>
    <TabItem Header="FontFamily"><Button Name="btn2" FontFamily="Arial">FontFamily</Button></TabItem>
    <TabItem Header="FontSize"><Button Name="btn3" FontSize="10">FontSize</Button></TabItem>
    <TabItem Header="FontStyle"><Button Name="btn4" FontStyle="Normal">FontStyle</Button></TabItem>
    <TabItem Header="FontWeight"><Button Name="btn5" FontWeight="Normal">FontWeight</Button></TabItem>
    <TabItem Header="BorderBrush"><Button Name="btn6" BorderBrush="Red">BorderBrush</Button></TabItem>
</TabControl>
</Grid>]]>
            </Syntax>
        </Sample>
        <Sample Path="samps\table_samp.xaml"    Title="Table" Description="Table defines a typographic table element comprised of a TableHeader, TableBody, and TableFooter. Table content can be spread across multiple TableColumns or paginated across multiple pages.">

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
<FlowDocumentPageViewer>
<FlowDocument>          
<Table CellSpacing="5">
    <Table.Columns>
    <TableColumn />
    <TableColumn />
    <TableColumn />
    <TableColumn />
  </Table.Columns>
    <TableRowGroup>
      <TableRow>
         <TableCell ColumnSpan="4"><Paragraph FontSize="24pt" FontWeight="Bold">Planetary Information</Paragraph></TableCell>
      </TableRow>
      <TableRow>
         <TableCell><Paragraph>Planet</Paragraph></TableCell>
         <TableCell><Paragraph>Distance from Sun</Paragraph></TableCell>
         <TableCell><Paragraph>Diameter</Paragraph></TableCell>
         <TableCell><Paragraph>Mass</Paragraph></TableCell>
      </TableRow>


      <TableRow>
         <TableCell ColumnSpan="4"><Paragraph FontSize="14pt" FontWeight="Bold">The Inner Planets</Paragraph></TableCell>
      </TableRow>
      <TableRow>
         <TableCell><Paragraph>Mercury</Paragraph></TableCell>
         <TableCell><Paragraph>57,910,000 km</Paragraph></TableCell>
         <TableCell><Paragraph>4,880 km</Paragraph></TableCell>
         <TableCell><Paragraph>3.30e23 kg</Paragraph></TableCell>
      </TableRow>
      <TableRow Background="lightgray">
         <TableCell><Paragraph>Venus</Paragraph></TableCell>
         <TableCell><Paragraph>108,200,000 km</Paragraph></TableCell>
         <TableCell><Paragraph>12,103.6 km</Paragraph></TableCell>
         <TableCell><Paragraph>4.869e24 kg</Paragraph></TableCell>
      </TableRow>
      <TableRow>
         <TableCell><Paragraph>Earth</Paragraph></TableCell>
         <TableCell><Paragraph>149,600,000 km</Paragraph></TableCell>
         <TableCell><Paragraph>12,756.3 km</Paragraph></TableCell>
         <TableCell><Paragraph>5.972e24 kg</Paragraph></TableCell>
      </TableRow>
      <TableRow Background="lightgray">
         <TableCell><Paragraph>Mars</Paragraph></TableCell>
         <TableCell><Paragraph>227,940,000 km</Paragraph></TableCell>
         <TableCell><Paragraph>6,794 km</Paragraph></TableCell>
         <TableCell><Paragraph>6.4219e23 kg</Paragraph></TableCell>
      </TableRow>
      <TableRow>
         <TableCell ColumnSpan="4"><Paragraph FontSize="14pt" FontWeight="Bold">The Outer Planets</Paragraph></TableCell>
      </TableRow>
      <TableRow>
         <TableCell><Paragraph>Jupiter</Paragraph></TableCell>
         <TableCell><Paragraph>778,330,000 km</Paragraph></TableCell>
         <TableCell><Paragraph>142,984 km</Paragraph></TableCell>
         <TableCell><Paragraph>1.900e27 kg</Paragraph></TableCell>
      </TableRow>
      <TableRow Background="lightgray">
         <TableCell><Paragraph>Saturn</Paragraph></TableCell>
         <TableCell><Paragraph>1,429,400,000 km</Paragraph></TableCell>
         <TableCell><Paragraph>120,536 km</Paragraph></TableCell>
         <TableCell><Paragraph>5.68e26 kg</Paragraph></TableCell>
      </TableRow>
      <TableRow>
         <TableCell><Paragraph>Uranus</Paragraph></TableCell>
         <TableCell><Paragraph>2,870,990,000 km</Paragraph></TableCell>
         <TableCell><Paragraph>51,118 km</Paragraph></TableCell>
         <TableCell><Paragraph>8.683e25 kg</Paragraph></TableCell>
      </TableRow>
      <TableRow Background="lightgray">
         <TableCell><Paragraph>Neptune</Paragraph></TableCell>
         <TableCell><Paragraph>4,504,000,000 km</Paragraph></TableCell>
         <TableCell><Paragraph>49,532 km</Paragraph></TableCell>
         <TableCell><Paragraph>1.0247e26 kg</Paragraph></TableCell>
      </TableRow>


      <TableRow>
         <TableCell ColumnSpan="4"><Paragraph FontSize="10pt" FontStyle="Italic">Information from the <Hyperlink 
NavigateUri="http://encarta.msn.com/encnet/refpages/artcenter.aspx">Encarta</Hyperlink> web site.</Paragraph></TableCell>
      </TableRow>
    </TableRowGroup>
</Table>
</FlowDocument>
</FlowDocumentPageViewer>
</Grid>]]>
            </Syntax>
        </Sample>
        <Sample Path="samps\textblock_samp.xaml"    Title="TextBlock" Description="TextBlock displays a block of text.">

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <TextBlock Background="Orange" FontFamily="Verdana" FontSize="14" FontWeight="Bold">
            Hello World!
    </TextBlock> 
</Grid>]]>
            </Syntax>
        </Sample>
        <Sample Path="samps\textbox_samp.xaml"      Title="TextBox" Description="Represents the control that provides an editable region that accepts text input.">

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <TextBox Name="tbSelectSomeText" VerticalAlignment="Center" HorizontalAlignment="Center">
        Some text to select...
</TextBox>
</Grid>]]>
            </Syntax>
        </Sample>
        
        <Sample Path="samps\toolbar_samp.xaml"      Title="ToolBar" Description="Provides a container for a group of commands or controls.">

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
    <ToolBar HorizontalAlignment="Center" VerticalAlignment="Center">
        <Button>1</Button>
        <Button>2</Button>
    </ToolBar>
</Grid>]]>
            </Syntax>
        </Sample>
        <Sample Path="samps\tooltip_samp.xaml"      Title="ToolTip" Description="Small pop-up window that displays information after particular events are raised in the system, or when a user hovers over a control." >

            <Syntax>
                <![CDATA[<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" >
<TextBox HorizontalAlignment="Center" VerticalAlignment="Center">TextBox with ToolTip
    <TextBox.ToolTip>
        <ToolTip><TextBlock>useful information goes here</TextBlock></ToolTip>
    </TextBox.ToolTip>
</TextBox>
</Grid>]]>
            </Syntax>
        </Sample>
            
        </Category>
</Samples>
      </x:XData>
    </XmlDataProvider>

            <Style TargetType="{x:Type TextBlock}">
                <Setter Property="FontFamily" Value="Calibri" />
                <Setter Property="FontSize" Value="10pt" />
            </Style>
            <DataTemplate x:Key="SamplesListItemTemplate">
                <StackPanel>
                    <TextBlock Text="{Binding XPath=@Title}" />
                </StackPanel>
            </DataTemplate>
            <Style x:Key="SamplesListBox" TargetType="{x:Type ListBox}">
                <Setter Property="ItemTemplate" Value="{DynamicResource SamplesListItemTemplate}" />
                <Setter Property="ItemContainerStyle" Value="{DynamicResource SamplesListBoxItem}" />
                <Setter Property="BorderBrush" Value="Transparent" />
                <Setter Property="Width" Value="186" />
            </Style>
            <Style x:Key="SamplesListBoxItem" TargetType="{x:Type ListBoxItem}">
                <Setter Property="Background" Value="Transparent" />
                <Setter Property="Margin" Value="1" />
                <Setter Property="Cursor" Value="Hand" />
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="{x:Type ListBoxItem}">
                            <Grid>
                                <Rectangle x:Name="ListBG" Fill="{TemplateBinding Background}" RadiusX="5" RadiusY="5" Stroke="transparent" />
                                <Rectangle x:Name="GelShine" Margin="2,2,2,0" VerticalAlignment="top" RadiusX="3" RadiusY="3" Opacity="0" Fill="#ccffffff" Stroke="transparent" Height="15px" />
                                <ContentPresenter x:Name="ContentSite" HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" VerticalAlignment="{TemplateBinding VerticalContentAlignment}" Margin="15,5,5,5" />
                            </Grid>
                            <ControlTemplate.Triggers>
                                <Trigger Property="IsSelected" Value="true" />
                                <Trigger Property="IsFocused" Value="true">
                                    <Setter Property="Background" Value="sc#1.000000, 0.769689, 0.831936, 1.000000" />
                                    <Setter Property="FontWeight" Value="bold" />
                                    <Setter Property="Foreground" Value="black" />
                                    <Setter TargetName="ListBG" Property="Rectangle.Stroke" Value="sc#1.000000, 0.250141, 0.333404, 0.884413" />
                                    <Setter TargetName="GelShine" Property="Rectangle.Opacity" Value="1" />
                                </Trigger>
                                <Trigger Property="IsMouseOver" Value="true">
                                    <Setter Property="Background" Value="sc#1.000000, 0.769689, 0.831936, 1.000000" />
                                    <Setter Property="Foreground" Value="black" />
                                </Trigger>
                            </ControlTemplate.Triggers>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
            </Style>
        </Grid.Resources>
        <Grid  Background="sc#1.000000, 0.769689, 0.831936, 1.000000" Name="DocumentRoot" >
            <Grid.RowDefinitions>
                <RowDefinition Height="50" />
                <RowDefinition Height="*" />
                <RowDefinition Height="20" />
            </Grid.RowDefinitions>
            <TextBlock  Grid.RowSpan="2"  Margin="20,5,20,5" TextAlignment="left"  Foreground="sc#1.000000, 0.250141, 0.333404, 0.884413" FontStyle="Italic" FontSize="30pt" FontFamily="Calibri" FontWeight="bold">XAMLPad Express</TextBlock>
            <Grid Grid.Row="1">
                <Rectangle Fill="white" RadiusX="14" RadiusY="14" Margin="10" Stroke="sc#1.000000, 0.250141, 0.333404, 0.884413" StrokeDashArray="2"/>
                <DockPanel LastChildFill="True"   Margin="20">
                    <Grid  Width="200px">
                        <Rectangle Fill="sc#1.000000, 0.769689, 0.831936, 1.000000" RadiusX="10" RadiusY="10" Stroke="sc#1.000000, 0.250141, 0.333404, 0.884413" StrokeDashArray="2" />
                        <DockPanel Margin="7" LastChildFill="False">
                            <TextBlock Margin="0,0,0,10"   Text="Sample Library" Foreground="sc#1.000000, 0.250141, 0.333404, 0.884413" TextAlignment="center"   FontWeight="Bold" FontSize="14pt"   DockPanel.Dock="top"  />
                            <Expander  Margin="0,0,0,10" DockPanel.Dock="top" Background="white" FocusVisualStyle="{x:Null}">
                                <Expander.Header>
                                    <TextBlock Margin="10,0,0,0"  FontFamily="Calibri" FontWeight="bold" >Layout</TextBlock>
                                </Expander.Header>
                                <ListBox Name="LayoutListBox" DataContext="{Binding Source={StaticResource SamplesList}, XPath=/Samples/Category[1]/Sample}"    ItemsSource="{Binding}" Style="{DynamicResource SamplesListBox}"  IsSynchronizedWithCurrentItem="True"  />
                            </Expander>
                            <Expander  Margin="0,0,0,10" DockPanel.Dock="top" Background="white" FocusVisualStyle="{x:Null}">
                                <Expander.Header>
                                    <TextBlock Margin="10,0,0,0"  FontFamily="Calibri" FontWeight="bold"  TextTrimming="WordEllipsis">Controls</TextBlock>
                                </Expander.Header>
                                <ListBox MaxHeight="300" Name="SecondLayOutListBox" DataContext="{Binding Source={StaticResource SamplesList}, XPath=/Samples/Category[2]/Sample}" ItemsSource="{Binding}" Style="{DynamicResource SamplesListBox}"  IsSynchronizedWithCurrentItem="True" SelectedValue="X" />
                            </Expander>
                        </DockPanel>
                    </Grid>
                    <DockPanel Name="Details" LastChildFill="True">
                        <DockPanel.DataContext>
                            <Binding Source="{StaticResource SamplesList}" XPath="/Samples/Category[1]/Sample"/>
                        </DockPanel.DataContext>
                        <StackPanel Margin="20,10,0,0" DockPanel.Dock="top" Orientation="Horizontal" >
                            <TextBlock  Text="{Binding XPath=@Title}" FontWeight="Bold" FontSize="16pt"    />
                        </StackPanel>
                        <TextBlock Margin="20,10,20,0" FontSize="11pt"  Text="{Binding XPath=@Description}" DockPanel.Dock="top" TextWrapping="Wrap" />
                        <Grid Margin="20,20,20,0">
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"  x:Name="PreviewRow" />
                                <RowDefinition Height="0.5*"  x:Name="CodeRow" />
                                <RowDefinition Height="40"  x:Name="ButtonRow" />
                            </Grid.RowDefinitions>
                            <Rectangle Fill="white" RadiusX="14" RadiusY="14" Margin="0,0,0,8"    StrokeDashArray="2"/>
                            <Grid Name="cc" Grid.Row="0" Margin="0,0,0,8" ClipToBounds="True" />
                            <Rectangle Height="16" VerticalAlignment="bottom" >
                                <Shape.Fill>
                                    <RadialGradientBrush>
                                        <GradientBrush.GradientStops>
                                            <GradientStopCollection>
                                                <GradientStop Color="sc#0.300000, 0.000000, 0.000000, 0.000000" Offset="0.019230769230769232" />
                                                <GradientStop Color="#FFFFFFFF" Offset="1" />
                                            </GradientStopCollection>
                                        </GradientBrush.GradientStops>
                                        <Brush.RelativeTransform>
                                            <TransformGroup>
                                                <TransformGroup.Children>
                                                    <TransformCollection>
                                                        <TranslateTransform X="-0.0052816901408450721" Y="0.5185185185185186" />
                                                    </TransformCollection>
                                                </TransformGroup.Children>
                                            </TransformGroup>
                                        </Brush.RelativeTransform>
                                    </RadialGradientBrush>
                                </Shape.Fill>
                            </Rectangle>
                            <GridSplitter Margin="10,0,10,0" Opacity="0" HorizontalAlignment="Stretch" VerticalAlignment="Bottom" Width="Auto" Height="5" Background="White" Cursor="SizeNS"/>
                            <TextBox Name="TextBox1" Margin="0,20,0,0"  HorizontalScrollBarVisibility="Auto" VerticalScrollBarVisibility="Auto"  FontFamily="Segoi UI" FontSize="12pt" BorderBrush="transparent"     Grid.Row="1" AcceptsTab="True" AcceptsReturn="True" Text="{Binding XPath=Syntax}" />
                            <StackPanel Grid.Row="2"  Orientation="Horizontal" Margin="0,5,0,0">

                            <RadioButton Name="rPreview" HorizontalAlignment="left" Margin="5" Content="Preview" VerticalAlignment="top"/>
                            <RadioButton Name="rXaml" HorizontalAlignment="left" Margin="5" Content="XAML" VerticalAlignment="top"/>
                            <RadioButton Name="rSplit" HorizontalAlignment="left" Margin="5" Content="Split" VerticalAlignment="top" IsChecked="True"/>

                                <TextBlock Name="ErrorText" Margin="100,5,60,0" TextTrimming="WordEllipsis" Foreground="red" FontSize="10pt" FontWeight="bold" />
                            </StackPanel>
                        </Grid>
                    </DockPanel>
                </DockPanel>
            </Grid>
        </Grid>
    </Grid>
</Page>
"@

$winhost = New-WPFWindow -Title 'XamlPad' -Height 600 -Width 800 -Grid HostGrid
$winhost.Content = ConvertFrom-WPFXaml -xaml $page

$LayoutListBox.add_SelectionChanged({
    $Details.DataContext = $LayoutListBox.DataContext
})

$SecondLayOutListBox.add_SelectionChanged({
    $Details.DataContext = $SecondLayOutListBox.DataContext
})

$TextBox1.add_KeyUp({
    $cc.Children.Clear();
    $cc.Children.Add([System.Windows.UIElement] (ConvertFrom-WPFXaml -xaml $TextBox1.Text))
})

$LayoutListBox.add_MouseUp({
    $cc.Children.Clear()
    $cc.Children.Add([System.Windows.UIElement] (ConvertFrom-WPFXaml -xaml $TextBox1.Text))
})

$SecondLayOutListBox.add_MouseUp({$cc.Children.Clear();
    $cc.Children.Add([System.Windows.UIElement] (ConvertFrom-WPFXaml -xaml $TextBox1.Text))
})

$rPreview.add_Click({
    $MainGrid.FindName('CodeRow').Height = 0
    $MainGrid.FindName('PreviewRow').Height = '*'
})

$rXaml.add_Click({
    $MainGrid.FindName('PreviewRow').Height = 0
    $MainGrid.FindName('CodeRow').Height = '*'
})

$rSplit.add_Click({
    $MainGrid.FindName('PreviewRow').Height = '*'
    $MainGrid.FindName('CodeRow').Height = '*'
})

$winhost.ShowDialog()