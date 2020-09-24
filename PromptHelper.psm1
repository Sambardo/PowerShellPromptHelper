<#MISC TODO
1. make time work better/differently
2. more presets
3. help data
4. github
5. gallery

CURRENT ISSUE: using -emoji seems to jack up the prompt, but without -emoji is fine. Reproducible on CLI, terminal and ISE, but works fine in PS7???
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

<# CURRENTLY REPLACED WITH CALL TO SET-PROMPT at the bottom. This is due to extra prompt being required anyways to trigger this
function prompt 
{
    #$Time = (Get-Date).ToString("hh:mm") 
    Set-Prompt -promptText "💪🐚" -emoji -TitlebarPath
}
#>

#region Public Functions
function Set-Prompt
{
    [cmdletbinding()]
    param(
        $promptText = "PowerShellRocks",
        $dbg = "[DBG]",
        $divider = "> ",
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
#Set-Prompt -promptText "💪🐚" -TitlebarPath #-emoji
Select-Prompt -selection 'Rocks with Title Path'