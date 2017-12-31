## My PowerShell Scripts
As requested, here is a list of all the scripts I could make generic, and that aren't exclusive to where I work.  I am still new to PowerShell, so forgive me if my scripts seem stupid or not helpful.  If you open up a script, I explain what it does in the comments.

Notes:
The scripts inside the two folders have GUIs.  To open the GUI, run the script that does not say designer at the end.

PowerShellHelp is a script that launches a GUI allowing you to view the Powershell help for a cmdlet.

Screenshot:
![alt text](https://www.jesserussell.net/wp-content/uploads/2017/11/powershellhelp1.png)
Powershell-Cmdlet-Explorer lists all installed modules, and by clicking on a module, you can see the cmdlets for that module.

Screenshot:
![alt text](https://www.jesserussell.net/wp-content/uploads/2017/12/powershell-cmdlet-explorer.png)

Here is a brief description of each script:

AD-computers-html-report.ps1: Produces an html file listing all computers in Active Directory.

AD-passwords-expiring-csv.ps1: Creates a csv of Active Directory users whose passwords are expiring in the next 7 days.

AD-passwords-expiring-soon-email.ps1: Sends an email to any user whose password expires in the next 7 days

azure-upload-vhd.ps1: Uploads a Hyper-V VHD to Azure.

clean-system-local.ps1: Calls a couple of clean up utilities on your local machine.

create-cmdlets-js.ps1: Creates a JSON array of all cmdlets and stores in a Javascript file.

delete-IIS-site.ps1: Deletes a website, app pool, and dns entry on remote servers.

download-web-files.ps1: Downloads all the files in a web file directory.

get-cmdlets-list.ps1: Creates a list of cmdlets.

get-inactive-servers.ps1: Tests to see if all the computers in AD are up and running.

get-module-commands.ps1: Creates a list of cmdlets for the specified module.

git-init.ps1: Creates git repository and pushes code to remote repository

git-pull.ps1: Loops through every folder inside a root folder and runs `git pull` inside each.

hyperv-backup-vm.ps1: Exports all Hyper-V virtual machines to a path and removes all but the last 7 days of backups.

nodejs-forever-startapps.ps1: Loops through every folder inside a root folder and starts a Node.js app inside each.

ping-server.ps1: Periodically pings a server to keep it alive.

plex-manufacturing-cloud.ps1: Contains functions that can be used to connect to Plex Manufacturing Cloud web services.

send-email.ps1: Contains a function that sends an email.

setup-domain-controller.ps1: Installs features for a domain controller.

setup-file-server.ps1: Installs features for a file server.

setup-print-server.ps1: Installs features for a print server.

system-info-html-report-local.ps1: Generates an HTML report of the local machine's system information.

system-info-local-json.ps1: Creates a JSON file containing the local machine's system information.

test-server.ps1: THIS IS NOT MY SCRIPT. I just use it in get-inactive-servers.ps1 to test connections to servers.

transfer-365-user.ps1: Transfers an Office 365 account from one Active Directory domain user to another.

That's it!  If you have any tips on how to improve these scripts, let me know!