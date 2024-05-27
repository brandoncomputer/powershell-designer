install-module powershell-designer

Contributing:  
It's better to make changes to functions.ps1, events.ps1 and designer.fbs. Changes to designer.ps1 will be lost in the next 'compile' if the changes are made there and not elsewhere.

Made decision that there will not be a 'dark mode'.  
        It's not that 'dark mode' isn't good, it's that there are a variety of other solutions that work solidly with this software, and anything developed will be inferior.  
            Windows screen filters  
            Windows Magnifier Negative Mode at 100%  
            Best Solution: NegativeScreen by Melvyn Laily 'Smart Inversion' mode (This is usually even better than applications native 'dark mode' setting', and it works on everything)  
            WindowTop by gileli121@gmail.com.  
              
There will be no exe compiler. It's not that I can't, it's that I can't make it NetInfoSec compliant, and it would be inferior to other listed solutions. See bottom recommendation.  
            Best solution: Develop a custom solution using a program that is not .Net based that allows a Text embed section that is changable via Resource Hacker by Angus Johnson. AES Encrypt/decrypt text using native function in program.  
            Next solution: Same as above but use base64  
            Next Solution: Same as above but don't encode or encrypt  
            Next Solution: ps12exe by steve02081504  
            Next Solution: ps2exe by MScholtes  
            Next Solution: vds-exe compiler by brandoncomputer  

My goal is not the best at everything. My goal is to be the best WinForms Designer/RAD IDE for PowerShell.
