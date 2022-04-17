$MainForm.AcceptButton = $ButtonEq

function match($a,$b,$c) {
    if ($c -eq $null){
        $c = -1
    }
    else {
        $c = $c
    }
    try{$return = $a.FindString($b,$c)}
    catch{$return = $a.Items.IndexOf($b)}
        return $return
}

function substr($a,$b,$c) {
    return $a.substring($b,($c-$b))
}

$ButtonEq.add_Click({
    $match = (match $ComboBox1 $TextBox1.Text)
    if ($match -gt -1){
    }
    else{
        $ComboBox1.Items.Add($TextBox1.Text)
    }
    
    $textbox1.text = invoke-expression $textbox1.text
    $textbox1.select($textbox1.text.length,0)
})

$ComboBox1.add_SelectedIndexChanged({
    $textbox1.text = $combobox1.text
})

$Button0.add_Click({
    $textbox1.text = $textbox1.text+0
})

$Button1.add_Click({
    $textbox1.text = $textbox1.text+1
})

$Button2.add_Click({
    $textbox1.text = $textbox1.text+2
})

$Button3.add_Click({
    $textbox1.text = $textbox1.text+3
})

$Button4.add_Click({
    $textbox1.text = $textbox1.text+4
})

$Button5.add_Click({
    $textbox1.text = $textbox1.text+5
})

$Button6.add_Click({
    $textbox1.text = $textbox1.text+6
})

$Button7.add_Click({
    $textbox1.text = $textbox1.text+7
})

$Button8.add_Click({
    $textbox1.text = $textbox1.text+8
})

$Button9.add_Click({
    $textbox1.text = $textbox1.text+9
})

$ButtonBSP.add_Click({
    $textbox1.text = (substr $textbox1.text 0 ($textbox1.text.length -1))
})

$ButtonXSQ.add_Click({
    $textbox1.text = invoke-expression $textbox1.text
    $textbox1.text = invoke-expression "$($textbox1.text)*$($textbox1.text)"
})

$ButtonDiv.add_Click({
    $textbox1.text = (($textbox1.text)+'/')
})

$ButtonMult.add_Click({
    $textbox1.text = (($textbox1.text)+'*')
})

$ButtonMinus.add_Click({
    $textbox1.text = (($textbox1.text)+'-')
})

$ButtonPlus.add_Click({
    $textbox1.text = (($textbox1.text)+'+')
})

$ButtonRv.add_Click({
    $textbox1.text = invoke-expression $textbox1.text
    if ((substr $textbox1.text 0 1) -eq '-'){
        $textbox1.text = (substr $textbox1.text 1 $textbox1.text.length)
        }
    else {
        $textbox1.text = "-$($textbox1.text)"
    }
})



