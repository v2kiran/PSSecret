Get-ChildItem -Path "$PSScriptRoot\scripts" -Filter *.ps1 -File | ForEach-Object {
	Write-Verbose ("Importing Function {0} " -f $_.FullName)
	. $_.FullName

}
. "$PSScriptRoot\Helpers\Write-PowerShellHashTable.ps1"
&"$PSScriptRoot\Helpers\Install-CMSEncryptionCertificate.ps1"
