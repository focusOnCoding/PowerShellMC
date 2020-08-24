Param(
[string]$computername='savazuusscdc01')
#` cerry on the comand
Get-WmiObject -class win32_computersystem ` 
	-ComputerName $computername |
	fl numberofprocessors,totalphysicalmemory
