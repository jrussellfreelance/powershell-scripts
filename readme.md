## My PowerShell Scripts
As requested, here is a list of all the scripts I could make generic, and that aren't exclusive to where I work.  I am still new to PowerShell, so forgive me if my scripts seem stupid or not helpful.  If you open up a script, I explain what it does in the comments.  Also, in general I need to add in some more error checking and verification of success, because normally I am so used to being the only person who uses the script, so I know what not to do.

Notes:
* The scripts inside the two folders have GUIs.  To open the GUI, run the script that does not say designer at the end.
* I use the BurntToast module a decent bit for notifications, so if you think you might use any of these scripts, I would go ahead and install that module. `Install-Module BurntToast`
* I am in the process of changing almost every Read-Host or variable declaration to a script parameter, so that these scripts are automation friendly.  I have updated most scripts already, but still need to add parameter value validation and parameter description comments.

PowerShellHelp is a script that launches a GUI allowing you to view the Powershell help for a cmdlet.

Screenshot:
![alt text](https://www.jesserussell.net/wp-content/uploads/2017/11/powershellhelp1.png)

Powershell-Cmdlet-Explorer lists all installed modules, and by clicking on a module, you can see the cmdlets for that module. When you click on a cmdlet, you can see the help information for it.

Screenshot:
![alt text](https://www.jesserussell.net/wp-content/uploads/2018/01/powershell-cmdlet-explorer2.png)

You can check each script's file for a description of what it does.

That's it!  If you have any tips on how to improve these scripts, let me know!
