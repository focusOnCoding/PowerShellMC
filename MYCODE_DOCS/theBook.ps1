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

#retrieve information about the Windows Time service running on my Windows 10 lab environment computer
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

#Use Get-Command with the Module parameter to determine what commands were added as part of the ActiveDirectory PowerShell module when the remote server administration tools were installed
Get-Command -Module ActiveDirectory

# only return a portion of the available properties by default
Get-ADUser -Identity mike | Get-Member

# The Get-ADUser cmdlet has a properties parameter which is used to specify which additional (nondefault) properties you want to return. Specifying the * wildcard character returns all of them.
Get-ADUser -Identity mike -Properties * | Get-Member

#If you’re going to perform some huge query from something such as Active Directory, query it once and store the results in a variable and then work with the contents of the variable instead of constantly performing some expensive query over and over again.
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

#The following example uses the Name parameter of Get-Service to immediately filter down the results to only the Windows Time service.
Get-Service -Name w32time

# using the where-object to filter
Get-Service | where-object -Name -eq w32time

<#  The order that the commands are specified in does indeed matter when
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

<#the InputObject parameter of Stop-Service accepts ServiceController objects via the pipeline by value (by type). This means that when the results of the Get-Service
cmdlet are piped to Stop-Service, they bind to the InputObject parameter of Stop-Service.#>
Get-Service -Name w32time | Stop-Service

# Now to try string input. Pipe w32time to Get-Member just to confirm that it’s a string.
'w32time' | Get-Member

# piping a string to Stop-Service will bind it to the Name parameter of Stop-Service by value (by type
'w32time' | Stop-Service

<#reate a custom object to test pipeline input by property name for the Name parameter of StopService.
#>
$CustomObject = [pscustomobject]@{
Name = 'w32time'
}

# The contents of the CustomObject variable is a PSCustomObject object type and it contains a property named “Name”.
$CustomObject | Get-Member

<#Although piping the contents of the CustomObject variable to Stop-Service cmdlet binds to the
Name parameter, this time it binds by property name instead of by value because the contents of
the CustomObject variable aren’t a string, but they do contain a property named “Name”.#>
$CustomObject = [PSCustomObject]@{
    Service = 'w32time'
}
# this returns an error because of single '.....'
$CustomObject | Stop-Service

<#If the output of one command doesn’t line up with the pipeline input options for another command
as shown in the previous example, Select-Object can be used to rename the property to make the
properties lineup correctly#>
$CustomObject | Select-Object -Property @{label = 'Name'; Expression = {$_.Service}} | Stop-Service

<#To demonstrate using the output of one command as parameter input for another, first save the
display name for a couple of Windows services into a text file.#>
'Background Intelligent Transfer Service', 'Windows Time' |
Out-File -FilePath $env:TEMP\services.txt

<#Simple run the command that you want to provide the output from within parenthesis as the value
for the parameter of the command to provide the input for, or Stop-Service in this scenario as shown
in the following example.#>
Stop-Service -DisplayName (Get-Content -Path $env:TEMP\services.txt)

<#Use the Find-Module cmdlet that’s part of the PowerShellGet module to find a module in the
PowerShell Gallery that I wrote named MrToolkit.
#>
Find-Module -Name MrToolkit

<#To install the MrToolkit module, simply pipe the previous command to Install-Module.#>
Find-Module -Name MrToolkit | Install-Module

<#The MrToolkit module contains a function named Get-MrPipelineInput that can be used to easily
determine what parameters of a command accept pipeline input and what type of object they accept
as well as if they accept pipeline input by value or by property name.#>
Get-MrPipelineInput -Name Stop-Service

