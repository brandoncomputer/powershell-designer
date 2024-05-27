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