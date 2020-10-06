<#MISC TODO
1. make time work better/differently
2. more presets
3. better help data
#>

#region variables
#used to maintain whether they toggled title bar paths on or off so it can set back to a default UI path if they turn it off
$script:TiteleBar = $false
#endregion

#region private functions
Function Prompt_Append_Helper
{
    [CmdletBinding()]
    param($promptText = "PowerShellRocks",
          $dbg = "[DBG]",
          $divider = "> ",
          [switch]$emoji)

    if($emoji)
    {
        $promptText = "$promptText🤘"
        $dbg = "🐜"
    }

    if ($PSDebugContext)
    {
        $promptText = "$dbg $promptText"
    }

    if ($host.name -eq "ServerRemoteHost")
    {
        $promptText = "[$env:ComputerName] $promptText"
    }

    $promptText + $divider
}



#endregion

#region Public Functions

<#
    .SYNOPSIS
        Set-Prompt will replace your prompt function with a new one based on the text you choose. 

    .DESCRIPTION
        Set-Prompt will replace your prompt function with a new one based on the text you choose. 
        
        Your prompt function is what PowerShell uses to determine what it should display to you in the console when showing you a new line.

        This maintains remoting functionality to show "[REMOTE MACHINE NAME]PromptText> " if you're doing interactive remoting. 

    .PARAMETER PromptText
        This is the basic prompt text that you want to see on your console line. If you don't provide this then it will use the default "PowerShellRocks".

    .PARAMETER Divider
        This will control the text displayed between your prompt text and where you type in the console. By default it will use "> ". This is here for convenience to separate your prompt text, but you could always set it to "" and keep everything in the -promptText parameter.

    .PARAMETER DBG
        This controls the text pre-pended to your line when the debugger is active. If nothing is provided the default is "[DBG]".

    .PARAMETER Emoji
        If this switch is enabled, then it attaches an emoji rock-and-roll hand to your prompt text AND it replaces the debugger text with an emoji ant. 

    .PARAMETER TitlebarPath
        If this switch is enabled, it will replace your host title bar with your working directory. 

    .PARAMETER Time
        If this switch is enabled, your time stamp pre-pends each line such as:
        "[12:00] PromptText> "

    .INPUTS
        Pipe input is not supported.

    .OUTPUTS
        none.

    .EXAMPLE
        Set-Prompt -promptText "YOUR TEXT" -emoji -TitlebarPath -Time

        [12:24] YOUR TEXT🤘>

    .EXAMPLE
        Set-Prompt

        PowerShellRocks> 

    .LINK
        https://github.com/Sambardo/PowerShellPromptHelper

    .LINK
        about_prompts

    .NOTES
        The script will use your input to generate the text for a function and then replace the prompt code with that text. 
#>
function Set-Prompt
{
    [cmdletbinding()]
    param(
        $promptText = "PowerShellRocks",
        $divider = "> ",
        $dbg = "[DBG]",
        [switch]$emoji,
        [switch]$TitlebarPath,
        [switch]$Time #TODO make this time thing work better. Do I put it before/after/inplace of prompt text?
    )
   
    #Build the code for the new prompt, then set the code in the global prompt function
    $code = ""
    if($TitlebarPath)
    {
        $code+='$host.ui.rawui.WindowTitle = (Get-Location)'
        $script:TiteleBar = $true
    }
    elseif($script:TiteleBar)#if they previously had the title bar path and no longer do then it needs to change to a default
    {
        $host.ui.rawui.WindowTitle = "PowerShell"
    }

   if($Time)
    {
            $promptText = "`$((get-date).ToString('hh:mm')) $promptText"
    }

    $code+="`nPrompt_Append_Helper -promptText `"$promptText`"  -dbg '$dbg'  -divider '$divider'"
    if($emoji){$code+=" -emoji"}

    set-content Function:\global:prompt -value $code
}

#TODO refactor and integrate as parameter set for Set-Prompt

<#
    .SYNOPSIS
        Select-Prompt lets you select from some pre-made prompts

    .DESCRIPTION
        Select-Prompt lets you select from some pre-made prompts

    .PARAMETER selection
        This will have a limited set of accepted values to leverage pre-made prompts. Take a look at the examples or documentation to get more info on the existing ones. 


    .INPUTS
        Pipe input is not supported.

    .OUTPUTS
        none.

    .EXAMPLE
        Select-Prompt -Selection "Emoji with Title Path"

        💪🐚🤘>

    .EXAMPLE
        Select-Prompt -Selection "Rocks with Title Path"
        
        PowerShellRocks>

    .EXAMPLE
        Select-Prompt -Selection "Simple Time with Title Path"
        
        03:26 > 

    .LINK
        https://github.com/Sambardo/PowerShellPromptHelper

    .LINK
        about_prompts

#>
function Select-Prompt
{
    [cmdletbinding()]
    param([ValidateSet("Simple Time with Title Path","Emoji with Title Path","Rocks with Title Path")] $selection)

    switch($selection)
    {
        "Simple Time with Title Path"   {Set-Prompt -promptText "" -TitlebarPath -time}
        "Emoji with Title Path"         {Set-Prompt -promptText "💪🐚" -emoji -TitlebarPath}
        "Rocks with Title Path"         {Set-Prompt -TitlebarPath}
    }
}
#endregion

#Triggered on load to use default prompt 
#TODO pick a more neutral one -- commented out -emoji due to weird rendering issue
Set-Prompt -promptText "💪🐚" -TitlebarPath -emoji
#Select-Prompt -selection 'Rocks with Title Path'