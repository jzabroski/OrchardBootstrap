# RunAs Administrator!
cinst tortoisehg
hg clone https://hg01.codeplex.com/orchard c:\repos\hg\orchard
C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe /t:Build C:\repos\hg\orchard\Orchard.proj
cp -recurse C:\inetpub\wwwroot\* C:\inetpub\wwwroot.backup
rm -recurse C:\inetpub\wwwroot\*
cp -recurse c:\repos\hg\orchard\build\Stage\* c:\inetpub\wwwroot
# May need to stop IIS here
Stop-WebItem 'IIS:\Sites\Default Web Site'
rm -recurse C:\inetpub\wwwroot\App_Data\*

Import-Module WebAdministration
# Assign write permissions to BUILTIN\IIS_IUSRS
$file = $(get-item "iis:\sites\Default Web Site\App_Data\")
$dacl = $file.GetAccessControl()
# Debug statement:
# $dacl.Access | ? { $_.IdentityReference -eq "BUILTIN\IIS_IUSRS" }
$newRule = New-Object Security.AccessControl.FileSystemAccessRule "BUILTIN\IIS_IUSRS", Write, Allow
$modified = $false
$dacl.ModifyAccessRule("Add", $newRule, [ref]$modified)
$file.SetAccessControl($dacl)
$file.GetAccessControl().GetAccessRules($true, $true, [System.Security.Principal.NTAccount])

$file = $(get-item "iis:\sites\Default Web Site\Media\")
$dacl = $file.GetAccessControl()
# Debug statement:
# $dacl.Access | ? { $_.IdentityReference -eq "BUILTIN\IIS_IUSRS" }
$newRule = New-Object Security.AccessControl.FileSystemAccessRule "BUILTIN\IIS_IUSRS", Write, Allow
$modified = $false
$dacl.ModifyAccessRule("Add", $newRule, [ref]$modified)
$file.SetAccessControl($dacl)
$file.GetAccessControl().GetAccessRules($true, $true, [System.Security.Principal.NTAccount])

Start-WebItem 'IIS:\Sites\Default Web Site'

# TODO: Ideally, convert even the below portion into a CLI prompt so user doesn't need to go to a Web page.

# What is the name of your site?
# blog

# Choose a user name:
# admin

# Choose a password:
# MustBe7AtleastCharacters

# Confirm the password:
# MustBe7AtleastCharacters

# How would you like to store your data?
# Use Built-in data storage (SQL Server Compact)

# Choose an Orchard recipe
# Blog

