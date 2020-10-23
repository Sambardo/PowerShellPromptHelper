# PowerShellPromptHelper
A module to help customize your PowerShell Prompt

The default prompt on load is currently: `PowerShellRocks>` along with the flag to put your filepath in the title bar of your host. 

**Emoji characters don't work in PowerShell CLI, but do work in the windows terminal app** so make sure you use `$Profile.CurrentUserCurrentHost` to pick one that will load in the CLI.

## Quick Start 
1. `Install-Module -name PromptHelper` to get it from the gallery

  Alternatively, do a manual download and import it in your profile:
  
  `import-module 'M:\OneDrive\PowerShell\Projects\Prompt\PromptHelper.psd1 -force'`
  
2. `Select-Prompt` for some pre-made prompts:
```
Select-Prompt -selection 'Simple Time with Title Path'
Select-Prompt -selection 'Emoji with Title Path'
Select-Prompt -selection 'Rocks with Title Path'
```
  - Emoji with Title Path: `💪🐚🤘>`
  - Rocks with Title Path: `PowerShellRocks> `
  - Simple Time with Title Path: `03:26 > `

3. create your own prompt with `Set-Prompt`. 
  - `PromptText` is what you want to display, default is "PowerShell Rocks"
  - `Emoji` will use an ant for the debug symbol and add on a rock and roll hand. **This currently has unexpected behavior in some hosts I'm investigating.** 
  - `Time` prepends the current time
  - `TitlebarPath` will replace the title bar with your current file path
  - `Dbg` will cusotmize your debug text, default is [DBG] 
  - `Divider` is what you want between your text and where you type, default is "> "
  
  
```
Set-Prompt -promptText "YOUR TEXT" -emoji -TitlebarPath -Time

[12:24] YOUR TEXT🤘>
```
  
  ## Using your own profile
  Load it in, select or set the prompt you want. I use the default one, but for the normal PowerShell CLI I have a profile picking a non-emoji prompt. 
