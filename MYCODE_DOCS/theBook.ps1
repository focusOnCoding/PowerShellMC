# Set up my font
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox


# Check the current execution policy:
Get-ExecutionPolicy

# Change the PowerShell execution policy to remote signed
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

# Get help
Get-Help -Name Get-Help

# Update Help
Update-Help

# help parameteis || man
• Full
• Detailed
• Examples
• Online
• Parameter
• ShowWindow
#

# get help online
Get-Help -Name Get-Help -Online

# To see the examples, type: 
get-help Get-Help -example

# For more information, type: 
get-help Get-Help -detailed

# For technical information, type: 
get-help Get-Help -full

# For online help, type: 
get-help Get-Help -online

# ways i can get help
Get-Help Get-Alias
Help Get-Alias
Get-Alias -?

Get-Help Get-Command

# Get help for the alias ls and gcm
Get-Help ls -Detailed

# get help for format-table full docs
Get-Help Format-Table -Full

# displays examples of using the Start-Service cmdlets
Get-Help Start-Service -Examples

# This command uses the Parameter parameter of Get-Help to display a detailed
#description of the GroupBy parameter of the Format-List cmdlet
Get-Help Format-List -Parameter GroupBy

#  command searches for the word Clixml in the full version of the help topic for the
# Add-Member cmdlet.
Get-Help Add-Member -Full | Out-String -Stream | Select-String -Pattern Clixml

#This command displays a list of topics that include the word remoting.
Get-Help remoting

#Gets the item at the specified location
Get-Item

Get-Help -Name Get-Help -Full
help -Name Get-Help -Full
help Get-Help -Full

# if i want to get help but dont want to display the entire help file
Get-Help -Name Get-Command -Full
Get-Help -Name Get-Command -Detailed
Get-Help -Name Get-Command -Examples
Get-Help -Name Get-Command -Online
Get-Help -Name Get-Command -Parameter Noun
Get-Help -Name Get-Command -ShowWindow

# show help file in another window
Get-Command -Full | Out-GridView

# to use help to find commands, use the asterisk (*) 
help *process*

# . As soon as you add a wildcard character in the middle
# of the value, they’re no longer automatically added behind the scenes to the # value you specified.
help pr*cess

# look for commands the end with -process 
help *-process

# this returns all processes (search for every help topic and returns any matches it finds)
help processes

# If only one result is found, the help topic itself will be displayed instead of a list of commands.
get-help *hotfix*

# Now to debunk the myth that Help in PowerShell can only find commands that have help topics.
help *more*
# returns basic syntax because it does not have help files

#  The following command can be used
# to return a list of all About help topics on your system.
help About_*

# Limiting the results to one single About help topic displays the actual help topic instead of returning a list.
help About_*

# update about help
help about_Updatable_Help

# Get all commands in PowerShell
Get-Command

# determine what commands exist for working with processes:
Get-Command -Noun Process

# wildcards are used with the Name parameter.
Get-Command -Name *service*
# but this also returns Windows executables that are not native PowerShell commands.

#If you are going to use wildcard characters with the Name parameter, I recommend limiting the
# results with the CommandType parameter.
Get-Command -Name *service* -CommandType Cmdlet, Function, Alias

# retrieve information about the Windows Time service running on my Windows 10 lab environment computer
Get-Service -Name w32time
# pipe this command to Get-Member
Get-Service -Name w32time | Get-Member # this also returns the object type

# once i know what type of object is returned i can find commands that accept that type of object as input
Get-Command -ParameterType ServiceController

#selects all of the properties by piping the results of Get-Service to Select-Object and specifying the * wildcard character as the value for the Property parameter
Get-Service -Name W32Time | Select-Object -Property *

# Specific properties can also be selected by specifying them individually via a comma separated list for the value of the Property parameter.
Get-Service -Name W32Time | Select-Object -Property Status, Name, DisplayName, ServiceType

# Wildcard characters can be used when specifying the property names with Select-Object.
# this returns all the property names that have Can in their name
Get-Service -Name w32time | Select-Object -Property Status, DisplayName, Can*

# show all methods of Get-Service
# use MemberType param to narrow down the result
Get-Service -Name w32time | Get-Member -MemberType Method

# stop a service
(Get-Service -Name W32Time).Stop()
# Now to verify the Windows time service has indeed been stopped.
Get-Service -Name w32time

# use cmdlet to start Service w32time
Get-Service -Name w32time | Start-Service -PassThru

# get process for Powershell
Get-Process -Name PowerShell

# because this returns an output i can pipe it to get-member
Get-Process -Name powershell | Get-Member

# Start Service does not return a object so i can not pipe it
Start-Service -Name W32Time | Get-Member

# use the PassTru param to make Start-Service return an output so i can pipe it to get-member
Start-Service -Name w32time -PassThru | Get-Member

# Get-Member, a command must not only produce output, but it must also produce object based output.
Get-Service -Name w32time | Out-Host | Get-Member 
#Although Out-Host produces output, it doesn’t produce object based output so it can’t be piped to Get-Member.

# Use Get-Command with the Module parameter to determine what commands were added as part of the ActiveDirectory PowerShell module when the remote server administration tools were installed
Get-Command -Module ActiveDirectory

# only return a portion of the available properties by default
Get-ADUser -Identity mike | Get-Member

# The Get-ADUser cmdlet has a properties parameter which is used to specify which additional (nondefault) properties you want to return. Specifying the * wildcard character returns all of them.
Get-ADUser -Identity mike -Properties * | Get-Member

# If you’re going to perform some huge query from something such as Active Directory, query it once and store the results in a variable and then work with the contents of the variable instead of constantly performing some expensive query over and over again.
$Users = Get-ADUser -Identity mike -Properties *

# pipe the Users variable to Get-Member to determine what the properties are.
$Users | Get-Member

# Then select the individual properties by piping the Users variable to Select-Object, all without ever having to query Active Directory more than one time.
$Users | Select-Object -Property Name, LastLogonDate, LastBadPasswordAttempt

# If you are going to query Active Directory more than one time, specify any of the non-default properties individually via the Properties parameter once you’ve determined what they are.
Get-ADUser -Identity mike -Properties LastLogonDate, LastBadPasswordAttempt

# One line commands
Get-Service | 
Where-Object CanPauseAndContinue -eq $true | 
Select-Object -Property *

# not a one liner but in one line
$Service = 'w32time'; Get-Service -Name $Service

# The following example uses the Name parameter of Get-Service to immediately filter down the results to only the Windows Time service.
Get-Service -Name w32time

# using the where-object to filter
Get-Service | where-object -Name -eq w32time

<# The order that the commands are specified in does indeed matter when
performing filtering. For example, if you’re using Select-Object to select only a few properties, but
need to perform filtering with Where-Object on properties that won’t be in the selection. In that
scenario, the filtering must occur first, otherwise the property wouldn’t exist in the pipeline when
trying to perform the filtering.#>
Get-Service |
Select-Object -Property DisplayName, Running, Status |
Where-Object CanPauseAndContinue

# Reversing the order of Select-Object and Where-Object produces the desired results
Get-Service |
Where-Object CanPauseAndContinue |
Select-Object -Property DisplayName, Running, Status

# Determine what type of output the Get-Service command produces.
Get-Service -Name w32time | Get-Member

<# the InputObject parameter of Stop-Service accepts ServiceController objects via the pipeline by value (by type). This means that when the results of the Get-Service
cmdlet are piped to Stop-Service, they bind to the InputObject parameter of Stop-Service.#>
Get-Service -Name w32time | Stop-Service

# Now to try string input. Pipe w32time to Get-Member just to confirm that it’s a string.
'w32time' | Get-Member

# piping a string to Stop-Service will bind it to the Name parameter of Stop-Service by value (by type
'w32time' | Stop-Service

<# reate a custom object to test pipeline input by property name for the Name parameter of StopService.
#>
$CustomObject = [pscustomobject]@{
Name = 'w32time'
}

# The contents of the CustomObject variable is a PSCustomObject object type and it contains a property named “Name”.
$CustomObject | Get-Member

<# Although piping the contents of the CustomObject variable to Stop-Service cmdlet binds to the
Name parameter, this time it binds by property name instead of by value because the contents of
the CustomObject variable aren’t a string, but they do contain a property named “Name”.#>
$CustomObject = [PSCustomObject]@{
    Service = 'w32time'
}

# this returns an error because of single '.....'
$CustomObject | Stop-Service

<# If the output of one command doesn’t line up with the pipeline input options for another command
as shown in the previous example, Select-Object can be used to rename the property to make the
properties lineup correctly#>
$CustomObject | Select-Object -Property @{label = 'Name'; Expression = {$_.Service}} | Stop-Service

<# To demonstrate using the output of one command as parameter input for another, first save the
display name for a couple of Windows services into a text file.#>
'Background Intelligent Transfer Service', 'Windows Time' |
Out-File -FilePath $env:TEMP\services.txt

<# Simple run the command that you want to provide the output from within parenthesis as the value
for the parameter of the command to provide the input for, or Stop-Service in this scenario as shown
in the following example.#>
Stop-Service -DisplayName (Get-Content -Path $env:TEMP\services.txt)

<# Use the Find-Module cmdlet that’s part of the PowerShellGet module to find a module in the
PowerShell Gallery that I wrote named MrToolkit.
#>
Find-Module -Name MrToolkit

<# To install the MrToolkit module, simply pipe the previous command to Install-Module.#>
Find-Module -Name MrToolkit | Install-Module

<# The MrToolkit module contains a function named Get-MrPipelineInput that can be used to easily
determine what parameters of a command accept pipeline input and what type of object they accept
as well as if they accept pipeline input by value or by property name.#>
Get-MrPipelineInput -Name Stop-Service
# this did not execut

# format Right all the -Properties that start with the name Can* and status and displayname
Get-Service -Name W32Time | Select-Object -Property Status, DisplayName, Can*

<# Use the Format-Table cmdlet to manually override the formatting and show the output in a table instead of a list.#>
Get-Service -Name w32time | Select-Object -Property Status, DisplayName, Can* | Format-Table

# The default output for Get-Service is three properties in a table.
Get-Service -Name w32time

# Use the Format-List cmdlet to override the default formatting and return the results in a list.
Get-Service -Name w32time | Format-List

# The number one thing to be aware of with the format cmdlets is they produce format objects which are different than normal objects in PowerShell.
Get-Service -Name w32time | Format-List | Get-Member

# The Get-Alias cmdlet is used to find aliases. If you already know the alias for a command, the Name parameter is used to determine what command the alias is associated with.
Get-Alias -Name gcm

# Multiple aliases can be specified for the value of the Name parameter.
Get-Alias -Name gcm, gm

# You’ll often see the Name parameter omitted since it’s a positional parameter.
Get-Alias gm

# If you want to find aliases for a command, you’ll need to use the Definition parameter.
Get-Alias -Definition Get-Command, Get-Member

# A provider in PowerShell is an interface that allows file system like access to a datastore
Get-PSProvider

<# The actual drives that these providers use to expose their datastore can be determined with the GetPSDrive cmdlet. The Get-PSDrive cmdlet not only displays drives exposed by providers, but it also
displays Windows logical drives including drives mapped to network shares.#>
Get-PSDrive

# Import the Active Directory and SQL Server PowerShell modules.
Import-Module -Name ActiveDirectory, SQLServer

# Check to see if any additional PowerShell providers were added.
Get-PSProvider

# PSDrives can be accessed just like a traditional file system.
Get-ChildItem -Path Cert:\LocalMachine\CA

# Proper case PowerShell is equal to lower case powershell using the equals comparison operator.
'PowerShell' -eq 'powershell'

# It’s not equal using the case-sensitive version of the equals comparison operator.
'PowerShell' -ceq 'powershell'

# The not equal comparison operator reverses the condition.
'PowerShell' -ne 'powershell'

# Greater than, greater than or equal to, less than, and less than or equal to are all designed for working with numeric values.
5 -gt 5

# Using greater than or equal to instead of greater than with the previous example returns the Boolean true since five is equal to five.
5 -ge 5

# Based on the results from the previous two examples, you can probably guess how both less than and less than or equal to work.
5 -lt 10

# The Like and Match operators can be confusing, even for experienced PowerShell users. Like is used with wildcard characters such as * and ? to perform “like” matches.
'PowerShell' -like '*shell'

# Match uses a regular expression to perform the matching.
'PowerShell' -match '^*.shell$'
 
# Use the range operator to store the numbers one through ten in a variable.
$Numbers = 1..10

# Determine if the Numbers variable includes fifteen.
$Numbers -contains 15

# Determine if it includes the number ten.
$Numbers -contains 10

# NotContains reverses the logic to see if the Numbers variable doesn’t contain a value.
$Numbers -notcontains 15

# previous example returns the Boolean true because it’s true that the Numbers variable doesn’t contain fifteen. It does however contain the number ten so it’s false when it’s tested to see if it doesn’t contain ten.
$Numbers -notcontains 10

# The “in” comparison operator was first introduced in PowerShell version 3.0. It’s used to determine if a value is “in” an array. The Numbers variable is an array since it contains multiple values.
15 -in $Numbers

<# In other words, “in” performs the same test as the contain comparison operator except from the pposite direction.#>
10 -in $Numbers

# Fifteen is not in the Numbers array so false is returned in the following example.
15 -in $Numbers

# Just like the contains operator, not reverses the logic for the “in” operator.
10 -notin $Numbers

<# The previous example returns false because the Numbers array does include ten and the condition was testing to determine if it didn’t contain ten. Fifteen is “not in” the Numbers array so it returns the Boolean true.#>
15 -notin $Numbers

<# The replace operator does just want you would think. It’s used to replace something. Specifying one value replaces that particular value with nothing as shown in the following example where I’ll replace Shell with nothing.#>
'PowerShell' -replace 'Shell'

<# If you want to replace a value with a different value, specify the new value in the second position after what you want to replace. SQL Saturday in Baton Rouge is an event that I try to speak at every year. In the following example, I’ll replace the word “Saturday” with the abbreviation “Sat”.#>
'SQL Saturday - Baton Rouge' -Replace 'saturday','Sat'

<# There are also methods such as the Replace method which can be used to replace things very similar to the way the replace operator works. However, while the Replace operator is case-insensitive by default, the Replace method is case-sensitive.#>
'SQL Saturday - Baton Rouge'.Replace('saturday','Sat')

<# Notice that the word Saturday was not replaced in the previous example. This is because it was specified in a different case than the original. When the word Saturday is specified in the same case as the original, the Replace method does indeed perform the replace as expected.#>
'SQL Saturday - Baton Rouge'.Replace('Saturday','Sat')
#SQL Sat - Baton Rouge


'ActiveDirectory', 'SQLServer' |
ForEach-Object {Get-Command -Module $_} |
Group-Object -Property ModuleName -NoElement |
Sort-Object -Property Count -Descending

# ForEach-Object is a cmdlet for iterating through items inline such as with PowerShell one-liners.
ForEach-Object streams the objects through the pipeline.

# foreach objects loops throu properties
$ComputerName = 'DC01', 'WEB01'
foreach ($Computer in $ComputerName) {
Get-ADComputer -Identity $Computer
}

# A For loop iterates through an array while a specified condition is true. The For loop is not something
# that I use often, but it does have its uses.
for ($i = 1; $i -lt 5; $i++) {
    Write-Output "Sleeping for $i seconds"
  Start-Sleep -Seconds $i
 }

 # There are two different Do loops in PowerShell. Do Until runs while the specified condition is false.
 $number = Get-Random -Minimum 1 -Maximum 10
do {
$guess = Read-Host -Prompt "What's your guess?"
if ($guess -lt $number) {
Write-Output 'Too low!'
}
elseif ($guess -gt $number) {
Write-Output 'Too high!'
}
 }
 until ($guess -eq $number)

# Do While is just the opposite, it runs as long as the specified condition is evaluated to true.
$number = Get-Random -Minimum 1 -Maximum 10
do {
$guess = Read-Host -Prompt "What's your guess?"
 if ($guess -lt $number) {
 Write-Output 'Too low!'
 }
 elseif ($guess -gt $number) {
 Write-Output 'Too high!'
 }
 }
while ($guess -ne $number)

# 
$date = Get-Date -Date 'November 22'
while ($date.DayOfWeek -ne 'Thursday') {
$date = $date.AddDays(1)
}
Write-Output $date

# Similar to the Do While loop, a While loop runs as long as the specified condition is true. The
#difference however, is that a While loop evaluates the condition at the top of the loop before any
#code is run so it doesn’t run at all if the condition evaluates to false.
$date = Get-Date -Date 'November 22'
while ($date.DayOfWeek -ne 'Thursday') {
$date = $date.AddDays(1)
}
Write-Output $date

<# Break, Continue, and Return
Break is designed to break out of a loop. It’s also commonly used with the switch statement. #>
for ($i = 1; $i -lt 5; $i++) {
Write-Output "Sleeping for $i seconds"
Start-Sleep -Seconds $i
break
}

# Break is designed to break out of a loop. It’s also commonly used with the switch statement.
for ($i = 1; $i -lt 5; $i++) {
Write-Output "Sleeping for $i seconds"
Start-Sleep -Seconds $i
break
}

# Continue is designed to skip to the next iteration of a loop.
while ($i -lt 5) {
 $i += 1
 if ($i -eq 3) {
 continue
 }
 Write-Output $i
 }

# Return is designed to exit out of the existing scope
$number = 1..10
foreach ($n in $number) {
 if ($n -ge 4) {
 Return $n
 }
}

<# WMI CIM #>
<# . Get-Command can be used to
determine what WMI cmdlets exist in PowerShell#>
Get-Command -Noun WMI*

# The CIM cmdlets are all contained within a module. To obtain a list of the CIM cmdlets, simply use
#Get-Command with the Module parameter as shown in the following example.
Get-Command -Module CimCmdlets

<# As I previously mentioned, WMI is a separate technology from PowerShell and you’re simply using
the CIM cmdlets for accessing WMI. You may find an old VBScript that uses WQL (Windows
Management Instrumentation Query Language) to query WMI such as in the following example.#>
strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set colBIOS = objWMIService.ExecQuery _
("Select * from Win32_BIOS")

Foreach objBIOS in colBIOS
Wscript.Echo "Manufacturer: " & objBIOS.Manufacturer
Wscript.Echo "Name: " & objBIOS.Name
Wscript.Echo "Serial Number: " & objBIOS.SerialNumber
Wscript.Echo "SMBIOS Version: " & objBIOS.SMBIOSBIOSVersion
Wscript.Echo "Version: " & objBIOS.Version

# You can take the WQL query from that VBScript and use it with the Get-CimInstance cmdlet in
#PowerShell without any modifications.
Get-CimInstance -Query 'Select * from Win32_BIOS'

# That’s not how I typically query WMI with PowerShell, but it does work and allows you to easily
#migrate existing VBScripts to PowerShell. If I start out writing a one-liner in PowerShell to query
#WMI, I’ll use the following syntax.
Get-CimInstance -ClassName Win32_BIOS

# If I only want the serial number, I can pipe the output to Select-Object and specify only the
#SerialNumber property.
Get-CimInstance -ClassName Win32_BIOS | Select-Object -Property SerialNumber

<# Get-CimInstance
has a Property parameter which can limit the information that’s retrieved in order to minimize the
network traffic if querying a remote computer. This makes the query to WMI more efficient#>
Get-CimInstance -ClassName Win32_BIOS -Property SerialNumber |
Select-Object -Property SerialNumber

# The previous results returned an object. To return a simple string, use the ExpandProperty parameter.
Get-CimInstance -ClassName Win32_BIOS -Property SerialNumber |
Select-Object -ExpandProperty SerialNumber

# You could also use the dotted notation style of syntax to return a simple string which eliminates the
#need to pipe to Select-Object altogether.
(Get-CimInstance -ClassName Win32_BIOS -Property SerialNumber).SerialNumber

# Query Remote Computers with the CIM cmdlets
<#I’m still running PowerShell as a local admin who is a domain user. When I try to query information
from a remote computer using the Get-CimInstance cmdlet, I receive an access denied error message.#>
Get-CimInstance -ComputerName dc01 -ClassName Win32_BIOS # this returns an error

<# Using the principle of least privilege, I elevate to my domain admin account on a per command basis
using the Credential parameter if a command has one. Get-CimInstance doesn’t have a Credential
parameter so the solution in this scenario is to create a CimSession first and then use it instead of a
computer name to query WMI on the remote computer.#>
$CimSession = New-CimSession -ComputerName dc01 -Credential (Get-Credential)

# The CIM session created in the previous example can now be used with the Get-CimInstance cmdlet
#to query the BIOS information from WMI on the remote computer.
Get-CimInstance -CimSession $CimSession -ClassName Win32_BIOS

<# The Get-CimInstance cmdlet uses the WSMan protocol by default which means the remote computer
needs PowerShell version 3.0 or higher in order for it to be able to connect. It’s actually not the
PowerShell version that matters, it’s the stack version. The stack version can be determined using
the Test-WSMan cmdlet. It needs to be version 3.0 and that’s the version you’ll find with PowerShell
version 3.0 and higher.
#>
Test-WSMan -ComputerName dc01

# for older verssion Create the DCOM protocol option using the New-CimSessionOption cmdlet and store it in a variable.
$DCOM = New-CimSessionOption -Protocol Dcom

<# Now back to the topic of making the entry of alternate credentials more efficient when they’re
specified on a command by command basis. Store your domain administrator or elevated credentials
in a variable so you don’t have to constantly enter them manually for each command.#>
$Cred = Get-Credential

<#I have a server named SQL03 which runs Windows Server 2008 (non-R2). It’s the newest Windows
Server operating system that doesn’t have PowerShell installed by default.
Create a CimSession to SQL03 using the DCOM protocol.#>
$CimSession = New-CimSession -ComputerName sql03 -SessionOption $DCOM -Credential
$Cred

# The Get-CimSession cmdlet is used to see what CimSessions are currently connected and what protocols they’re using.
Get-CimSession

# Retrieve and store both of the previously created CimSessions in a variable named CimSession.
$CimSession = Get-CimSession

# Query both of the computers with one command, one using the WSMan protocol and the other one with DCOM.
Get-CimInstance -CimSession $CimSession -ClassName Win32_BIOS
<#When you’re finished with the CIM sessions, you should remove them with the Remove-CimSession
cmdlet. To remove all CIM sessions, simply pipe Get-CimSession to Remove-CimSession.#>
Get-CimSession | Remove-CimSession


<# As shown in the following example, Get-Command can be used with the ParameterName parameter
to determine what commands have a ComputerName parameter.#>
Get-Command -ParameterName ComputerName

# PowerShell remoting can be enabled or re-enabled using the Enable-PSRemoting cmdlet.
Enable-PSRemoting

<# In the last chapter, I stored my domain admin credentials in a variable named Cred. If you haven’t
already done so, go ahead and store your domain admin credentials in the Cred variable.#>
$Cred = Get-Credential

# Create a one-to-one PowerShell remoting session to the domain controller named dc01.
Enter-PSSession -ComputerName dc01 -Credential $Cred

# When you’re done working with the remote computer, exit the one-to-one remoting session by using the Exit-PSSession cmdlet. dc01 is the server or domain name for the remote pc | server
[dc01]: PS C:\> Exit-PSSession

<# Sometimes you may need to perform a task interactively on a remote computer, but remoting is
much more powerful when performing a task on multiple remote computers at the same time. The
Invoke-Command cmdlet is used to remotely run a command against one or more remote computers
at the same time.#>
Invoke-Command -ComputerName dc01, sql02, web01 {Get-Service -Name W32time} -Credentia\
l $Cred

# Piping the previous command to Get-Member shows that the results are indeed deserialized objects.
Invoke-Command -ComputerName dc01, sql02, web01 {Get-Service -Name W32time} -Credentia\
l $Cred | Get-Member

<# You can’t start or stop a service using a deserialized object because
it’s a snapshot of the state of that object from the point in time when the command was run on the
remote computer .I’ll stop the Windows Time service on all three of those remote servers using the stop method to
prove this point. #>
Invoke-Command -ComputerName dc01, sql02, web01 {(Get-Service -Name W32time).stop(
)} -Credential $Cred
Invoke-Command -ComputerName dc01, sql02, web01 {Get-Service -Name W32time} -Credential $Cred

<# Create a PowerShell session to each of the three computers we’ve been working with in this chapter,
DC01, SQL02, and WEB01.
#>
$Session = New-PSSession -ComputerName dc01, sql02, web01 -Credential $Cred

# Now use the variable named Session that the PowerShell sessions are stored in to start the Windows Time service using a method and then check the status of the service.
Invoke-Command -Session $Session {(Get-Service -Name W32time).start()}
Invoke-Command -Session $Session {Get-Service -Name W32time}

# When you’re finished using the sessions, be sure to remove them.
Get-PSSession | Remove-PSSession

<# By default there are a number of properties that are retrieved behind the scenes that are simply
thrown away. While it may not matter much when querying WMI on the local computer, once you
start querying remote computers, it’s not only additional processing time to return that information,
but also additional unnecessary information to have to pull across the network. Get-CimInstance
has a Property parameter which can limit the information that’s retrieved in order to minimize the
network traffic if querying a remote computer. This makes the query to WMI more efficient.#>
Get-CimInstance -ClassName Win32_BIOS -Property SerialNumber |
Select-Object -Property SerialNumber

# In PowerShell, there’s a specific list of approved verbs which can be obtained by running Get-Verb.
Get-Verb | Sort-Object -Property Verb

# A function in PowerShell is declared with the function keyword followed by the function name and then an open and closing curly brace. The code that the function will execute is contained within those curly braces.
function Get-Version {
$PSVersionTable.PSVersion
}

#The PowerShell function shown in the previous example is a very simple example. It returns the version of PowerShell.
Get-Version

<#This is why I recommend prefixing
the noun portion of your functions to help prevent naming conflicts. In the following example, I’ll
use the prefix “PS”.#>
function Get-PSVersion {
$PSVersionTable.PSVersion
}

# Even when prefixing the noun with something like PS, there’s still a good chance of having a name conflict. I typically prefix my function nouns with my initials. Develop a standard and stick to it.
function Get-MrPSVersion {
$PSVersionTable.PSVersion
}

# see all the functions i have created Once loaded into memory, you can see functions on the Function PSDrive.
Get-ChildItem -Path Function:\Get-*Version

# If you want to remove these functions from your current session, you’ll have to remove them from the Function PSDrive or close and re-open PowerShell.
Get-ChildItem -Path Function:\Get-*Version | Remove-Item

# Verify that the functions were indeed removed.
Get-ChildItem -Path Function:\Get-*Version

# If the functions were loaded as part of a module, the module can simply be unloaded to remove them.
Remove-Module -Name <ModuleName>

# Don’t statically assign values! Use parameters and variables. When it comes to naming your parameters, use the same name as the default cmdlets for your parameter names whenever possible.
function Test-MrParameter {

param (
$ComputerName
)

Write-Output $ComputerName

}

# I’ll create a function to query all of the commands on a system and return the number of them that have specific parameter names.
function Get-MrParameterCount {
 param (
[string[]]$ParameterName
)
 foreach ($Parameter in $ParameterName) {
$Results = Get-Command -ParameterName $Parameter -ErrorAction SilentlyContinue
 [pscustomobject]@{
 ParameterName = $Parameter
 NumberOfCmdlets = $Results.Count
 }
 }
 }function Get-MrParameterCount {
param (
 [string[]]$ParameterName
 )

 foreach ($Parameter in $ParameterName) {
 $Results = Get-Command -ParameterName $Parameter -ErrorAction SilentlyContinue

[pscustomobject]@{
 ParameterName = $Parameter
 NumberOfCmdlets = $Results.Count
}
}
}

# As you can see in the results shown below, there are 39 commands that have a ComputerName parameter and there aren’t any that have parameters such as Computer, ServerName, Host, or Machine.
Get-MrParameterCount -ParameterName ComputerName, Computer,
ServerName, Host, Machine

# Advanced functions
function Test-MrParameter {
 param (
 $ComputerName
 )
Write-Output $ComputerName
}

# What I want you to notice is that the Test-MrParameter function doesn’t have any common parameters. There are a couple of different ways to see the common parameters. One is by viewing the syntax using Get-Command.
Get-Command -Name Test-MrParameter -Syntax

# Another is to drill down into the parameters with Get-Command.
(Get-Command -Name Test-MrParameter).Parameters.Keys

# Add CmdletBinding to turn the function into an advanced function.
function Test-MrCmdletBinding {
[CmdletBinding()] #<<-- This turns aregular function into an advanced fnction
param (
$ComputerName
)
Write-Output $ComputerName
}

<# now this will return more parameters becuase its an advance function
Simply adding CmdletBinding adds the common parameters automatically. CmdletBinding does
require a param block, but the param block can be empty.
Chapter 9 - Functions 127
#>
Get-Command -Name Test-MrCmdletBinding -Syntax

# Drilling down into the parameters with Get-Command shows the actual parameter names including the common ones.
(Get-Command -Name Test-MrCmdletBinding).Parameters.Keys

# SupportsShouldProcess adds WhatIf and Confirm parameters. This is only needed for commands that make changes.
function Test-MrSupportsShouldProcess {
 [CmdletBinding(SupportsShouldProcess)]
 param (
 $ComputerName
 )
 Write-Output $ComputerName
}

# Notice that there are now WhatIf and Confirm parameters.
Get-Command -Name Test-MrSupportsShouldProcess -Syntax

# Once again, you can also use Get-Command to return a list of the actual parameter names including the common ones along with WhatIf and Confirm.
(Get-Command -Name Test-MrSupportsShouldProcess).Parameters.Keys

# Always type the variables that are being used for your parameters (specify a datatype)
function Test-MrParameterValidation {

 [CmdletBinding()]
 param (
 [string]$ComputerName
 )

 Write-Output $ComputerName

 }

<#In the previous example, I’ve specified String as the datatype for the ComputerName parameter. This
causes it to allow only a single computer name to be specified. If more than one computer name is
specified via a comma separated list, an error will be generated.#>
Test-MrParameterValidation -ComputerName Server01, Server02 # this returns an error 

<#
The problem at this point is that it’s perfectly valid to not specify a computer name at all and
at least one computer name needs to be specified otherwise the function can’t possibly complete
successfully. This is where the Mandatory parameter attribute comes in handy.#>
 function Test-MrParameterValidation {
 [CmdletBinding()]
 param (
 [Parameter(Mandatory)]
 [string]$ComputerName
 )
 Write-Output $ComputerName
 Write-Output $ComputerName
}

# If you want to allow for more than one value to be specified for the ComputerName parameter, use the String datatype but add open and closed square brackets to the datatype to allow for an array of strings.
function Test-MrParameterValidation {
 [CmdletBinding()]
 param (
 [Parameter(Mandatory)]
 [string[]]$ComputerName
 )
 Write-Output $ComputerName
 }
# Maybe you want to specify a default value for the ComputerName parameter if one is not specified. The problem is that default values cannot be used with mandatory parameters. Instead, you’ll need to use the ValidateNotNullOrEmpty parameter validation attribute with a default value.
function Test-MrParameterValidation {
[CmdletBinding()]
param (
[ValidateNotNullOrEmpty()]
[string[]]$ComputerName = $env:COMPUTERNAME
 )
Write-Output $ComputerName

}
# A better option is to use Write-Verbose instead of inline comments.
function Test-MrVerboseOutput {
 [CmdletBinding()]
 param (
[ValidateNotNullOrEmpty()]
[string[]]$ComputerName = $env:COMPUTERNAME
)
foreach ($Computer in $ComputerName) {
Write-Verbose -Message "Attempting to perform some action on $Computer"
 Write-Output $Computer
 }
}

# When the function is called without the Verbose parameter, the verbose output won’t be displayed.
Test-MrVerboseOutput -ComputerName Server01, Server02

# When it’s called with the Verbose parameter, the verbose output will be displayed.
Test-MrVerboseOutput -ComputerName Server01, Server02 -Verbose

<# Pipeline input comes in one item at a time similar to the way a foreach loop works. At a minimum,
a PROCESS block is required to process each of these items if you’re accepting an array as input. If
you’re only accepting a single value as input, a process block isn’t necessary, but I still recommend
going ahead and specifying it for consistency.#>
 function Test-MrPipelineInput {
[CmdletBinding()]
 param (
[Parameter(Mandatory,
ValueFromPipeline)]
 [string[]]$ComputerName
 )
 PROCESS {
 Write-Output $ComputerName
 }
}

# Accepting pipeline input by property name is similar except it’s specified with the ValueFromPipelineByPropertyName parameter attribute and it can be specified for any number of parameters regardless of datatype. The key is that the output of the command that’s being piped in has to have a property name that matches the name of the parameter or a parameter alias of your function.
function Test-MrPipelineInput {

 [CmdletBinding()]
 param (
[Parameter(Mandatory,
 ValueFromPipelineByPropertyName)]
 [string[]]$ComputerName
 )
PROCESS {
Write-Output $ComputerName
}
}

<#BEGIN and END blocks are optional. BEGIN would be specified before the PROCESS block and is
used to perform any initial work prior to the items being received from the pipeline. This is very
important to understand. Values that are piped in are NOT accessible in the BEGIN block. The END
block would be specified after the PROCESS block and is used for cleanup once all of the items that
are piped in have been processed#>

#The function shown in the following example will generate an unhandled exception if a computer cannot be contacted.
 function Test-MrErrorHandling {

 [CmdletBinding()]
 param (
 [Parameter(Mandatory,
 ValueFromPipeline,
 ValueFromPipelineByPropertyName)]
 [string[]]$ComputerName
 )

 PROCESS {
foreach ($Computer in $ComputerName) {
 Test-WSMan -ComputerName $Computer
 }
 }

 }

#There are a couple of different ways to handle errors in PowerShell. Try / Catch is the more modern way to handle errors.
function Test-MrErrorHandling {
[CmdletBinding()]
param (
[Parameter(Mandatory,
ValueFromPipeline,
ValueFromPipelineByPropertyName)]
[string[]]$ComputerName
)

 PROCESS {
 foreach ($Computer in $ComputerName) {
 try {
 Test-WSMan -ComputerName $Computer
 }
 catch {
 Write-Warning -Message "Unable to connect to Computer: $Computer"
 }
 }
 }
}

# Although the function shown in the previous example uses error handling, it also generates an unhandled exception because the command doesn’t generate a terminating error. This is also very important to understand. Only terminating errors are caught. Specify the ErrorAction parameter with Stop as the value to turn a non-terminating error into a terminating one.
function Test-MrErrorHandling {
[CmdletBinding()]
param (
[Parameter(Mandatory,
ValueFromPipeline,
ValueFromPipelineByPropertyName)]
[string[]]$ComputerName
)
PROCESS {
foreach ($Computer in $ComputerName) {
try {
Test-WSMan -ComputerName $Computer -ErrorAction Stop
}
catch {
Write-Warning -Message "Unable to connect to Computer: $Computer"
}
}
}
}

# Comment-Based Help It’s considered to be a best practice to add comment based help to your functions so the peoplen you’re sharing them with will know how to use them.
function Get-MrAutoStoppedService {
<#
.SYNOPSIS
Returns a list of services that are set to start automatically, are not
currently running, excluding the services that are set to delayed start.
.DESCRIPTION
Get-MrAutoStoppedService is a function that returns a list of services from
 the specified remote computer(s) that are set to start automatically, are not
 currently running, and it excludes the services that are set to start automatically
with a delayed startup.
.PARAMETER ComputerName
The remote computer(s) to check the status of the services on.
.PARAMETER Credential
Specifies a user account that has permission to perform this action. The default
is the current user.
.EXAMPLE
Get-MrAutoStoppedService -ComputerName 'Server1', 'Server2'
.EXAMPLE
'Server1', 'Server2' | Get-MrAutoStoppedService
.EXAMPLE
Get-MrAutoStoppedService -ComputerName 'Server1' -Credential (Get-Credential)
.INPUTS
String
32
33 .OUTPUTS
34 PSCustomObject
35
36 .NOTES
37 Author: Mike F Robbins
38 Website: http://mikefrobbins.com
39 Twitter: @mikefrobbins
40 #>
[CmdletBinding()]
 param (
 )
#Function Body
}

# The following function has been saved as Get-MrPSVersion.ps1.
function Get-MrPSVersion {
$PSVersionTable
}

# If you simply run the script, nothing happens.
.\Get-MrPSVersion.ps1

# If you try to call the function, it generates an error message.
Get-MrPSVersion # error

# You can determine if functions are loaded into memory by checking to see if they exist on the function PSDrive.
Get-ChildItem -Path Function:\Get-MrPSVersion

# The function needs to be loaded into the Global scope and that can be accomplished by dot-sourcing the script that contains the function. The relative path can be used.
.\Get-MrPSVersion.ps1

# The fully qualified path can also be used. folder name demo script name 
C:\Demo\Get-MrPSVersion.ps1

# If a portion of the path is stored in a variable, it can be combined with the remainder of the path. There’s no reason to use string concatenation to combine the variable together with the remainder of the path.
$Path = 'C:\'
. $Path\Get-MrPSVersion.ps1

# Now when the function PSDrive in PowerShell is checked, the Get-MrPSVersion function does exist.
Get-ChildItem -Path Function:\Get-MrPSVersion

# While there is a command in PowerShell named New-Module, that command creates a dynamic module, not a script module. Always be sure to read the help for a command even when you think you’ve found the command you need.
help New-Module

# In the previous chapter I mentioned that functions should use approved verbs otherwise they’ll generate a warning message when the module is imported. The following code, which uses the NewModule cmdlet to create a dynamic module in memory, is used to demonstrate the unapproved verb warning.
New-Module -Name MyModule -ScriptBlock {

 function Return-MrOsVersion {
 Get-CimInstance -ClassName Win32_OperatingSystem |
 Select-Object -Property @{label='OperatingSystem';expression={$_.Caption}}
 }
Export-ModuleMember -Function Return-MrOsVersion
} | Import-Module

 # Save the following two functions in a file named MyScriptModule.psm1.
function Get-MrPSVersion {
$PSVersionTable
}
function Get-MrComputerName {
$env:COMPUTERNAME
}

# Try to call one of the functions.
Get-MrComputerName # error

# You could manually import the file with the Import-Module cmdlet.
Import-Module C:\MyScriptModule.psm1

<# Module autoloading is a feature that was introduced in PowerShell version 3. In order to take
advantage of module autoloading, a script module needs to be saved in a folder with the same
base name as the PSM1 file and in a location specified in $env:PSModulePath#>
$env:PSModulePath

# The results are kind of difficult to read. Since the paths are separated by a semicolon, you can split the results on those semicolons to return each path on a separate line. This will make them easier to read.
$env:PSModulePath -split ';'

# The version of a module without a manifest is 0.0 (This is a dead giveaway that the module doesn’t have a manifest).
Get-Module -Name MyScriptModule
 
# The module manifest can be created with all of the recommended information.
New-ModuleManifest -Path $env:ProgramFiles\WindowsPowerShell\Modules\MyScriptModule\MyScriptModule.psd1 -RootModule MyScriptModule -Author 'Siyabonga F Dlamini' -Description 'My
3 ScriptModule' -CompanyName 'mikefrobbins.com'

# If you’re not following the best practices and only have a PSM1 file then your only option is to use the Export-ModuleMember cmdlet.
function Get-MrPSVersion {
 $PSVersionTable
 }

function Get-MrComputerName {
$env:COMPUTERNAME
}
Export-ModuleMember -Function Get-MrPSVersion

# In the previous example, only the Get-MrPSVersion function will be available to the users of your module, but the Get-MrComputerName function will be available to other functions within the module itself.
Get-Command -Module MyScriptModule

# If you’ve added a module manifest to your module (and you should), then I recommend specifying the individual functions you want to export in the FunctionsToExport section of the module manifest.
FunctionsToExport = 'Get-MrPSVersion'

# View the syntax section of the help for a command such as in the following example where help is retrieved for the Get-EventLog cmdlet.
help Get-EventLog

# The syntax information for a command can also be retrieved using Get-Command by specifying the Syntax parameter. This is a handy shortcut that I use all the time. It allows me to quickly learn how to use a command without having to sift through multiple pages of help information. If I end up needing more information, then I’ll revert to using the actual help content.
Get-Command -Name Get-EventLog -Syntax



