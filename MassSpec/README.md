This folder contains scripts used on the GC/MS and LC/MS
* `Count-BatchesAndSamplesByMonth.ps1` - count the number of LC/MS batch folders and `.raw` files in the user.
* `Count-QgdByMonth.ps1` - count the number of GC/MS '.qgd' files in the user.

## Usage
### GC/MS computer
The computer is not online, use a USB to transfer the '.ps1' script into it. I put a copy of the count script in the folder `C:\GCMSsolution\Data`.    
Open PowerShell app, in the terminal, go into the data folder by
```bash
cd C:\GCMSsolution\Data
```
If you see the curser is after C:\GCMSsolution\Data>, that means you are in the right location. You should see everyone's data folder and the script in here, with 
```bash
ls
```

For the first time running the scripts, because it is written by myself, it triggers a execution permission error. This is the protection from Windows that not allowed a random transfer/download bash scripts to run. To overcome this, we will need to tell the system I trust the script and I am enable myself to run the script. 
```bash
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```
It will pop up asking if you give 'CurrentUser' permission to execute the script, enter 'Y'.      
Now the script is ready to run as:
```bash
.\Count-QgdByMonth.ps1 "C:\GCMSsolution\Data\FolderName"
```
Change the 'FolderName' to the user folder you want to count. The output should be: 
```txt
Time      samples
2025-03   20
...
```
The GCMS data files are not organized by batch folder, so we are only counting how many samples by month by each person. 

### LC/MS computer
I put a copy of the count script in the folder `C:\TraceFinderData\Projects`. 
Open PowerShell app, in the terminal, go into the data folder by
```bash
cd C:\TraceFinderData\Projects
```
If you see the curser is after C:\TraceFinderData\Projects>, that means you are in the right location. You should see everyone's project folder and the script in here, with 
```bash
ls
```
Same as the GCMS script, for the first time running it, we need to give it permission. 
```bash
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```
It will pop up asking if you give 'CurrentUser' permission to execute the script, enter 'Y'.      
Now the script is ready to run as:
```bash
.\Count-BatchesAndSamplesByMonth.ps1 "C:\TraceFinderData\Projects\FolderName"
```
Change the 'FolderName' to the user folder you want to count. The output should be: 
```txt
Time      batches    samples
2025-04   20          100
...
```
The script will count how many batches by month, and how many samples by month for each person. You will have to manually change the folder names. If you know who were using the instruments recently, you will only need to count their folders. Get the number and organize/sum up in excel. 

This does not tell us how many samples in each batch, but can be estimate. For example, if there are 4 batches with 20 samples in total, those are small batches. If there are 4 batches with 150 samples, they can be large batches. 

**Tips**
- The `Set-ExecutionPolicy` only need to run one time after we transfer/copy a new script into the computer. Restart the computer should not need it again.
- When typing the count file, try typing the first few letters like 'Count' and then press `Tab` key to autocomplete, to avoid any typo.
- Right click in the PowerShell is the way to paste the content you just copy
- Make sure the folder path is correct and in the " ". If you see no such file error, 100% is file path incorrect. 
