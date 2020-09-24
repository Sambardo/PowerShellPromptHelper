# PowerShellPromptHelper
A module to help customize your PowerShell Prompt

1. import-module M:\OneDrive\PowerShell\Projects\Prompt\PromptHelper.psd1 -force
2. Select-Prompt for some pre-made prompts:
```
Select-Prompt -selection 'Simple Time with Title Path'
Select-Prompt -selection 'Emoji with Title Path'
Select-Prompt -selection 'Rocks with Title Path'
```
3. create your own prompt with Set-Prompt. 
  - prompt text is what you want to display, default is "PowerShell Rocks"
  - Emoji will use an ant for the debug symbol and add on a rock and roll hand. **This currently has unexpected behavior in some hosts I'm investigating.** 
  - Time prepends the current time
  - dbg will cusotmize your debug text, default is [DBG] 
  - Divider is what you want between your text and where you type, default is "> "
  
```
Set-Prompt -promptText "YOUR TEXT" -emoji -TitlebarPath -Time
```
