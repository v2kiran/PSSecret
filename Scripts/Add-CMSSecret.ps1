function Add-CMSSecret
{
	<#
			.Synopsis
			Adds an encrypted setting to the registry
			.Description
			Stores secured user settings in the registry
			.Example
			Add-CMSSecret -Name MySimpleString -String 'A String'
			.Example
			Add-CMSSecret -Name MyHashTable -Hashtable @{a='b';c='d'}
			.Example
			Add-CMSSecret -Name 'my-AzureCredential' -Credential Get-Credential
			.Example
			Add-CMSSecret -Name 'ServiceObject' -Object (Get-Service -Name Bits)
			.Link
			Get-CMSSecret
	#>
	[CmdletBinding(DefaultParameterSetName = 'String')]
	[Alias('Set-CMSSecret','New-CMSSecret','AddCMS')]
	param(   
		# The name of the secure setting
		[Parameter(Mandatory,Position = 0,ValueFromPipelineByPropertyName = $true)]
		[String]
		$Name,
		
		# The name of the secure setting
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]
		$CMSCertName = "powershellcms@$env:COMPUTERNAME",
    
		# A string value to store.  This will be encrypted and stored in the registry. 
		[Parameter(Mandatory,Position = 1,ParameterSetName = 'String',ValueFromPipelineByPropertyName = $true,ValueFromPipeline = $true)]
		[string]
		$String,
    
		# A table of values.  The table will be converted to a string, and this string will be stored in the registry.
		[Parameter(Mandatory,ParameterSetName = 'Hashtable',ValueFromPipelineByPropertyName = $true)]
		[Collections.Hashtable]
		$Hashtable,
    
		# Any object.  The object will stored in the registry in the JSON format.
		[Parameter(Mandatory,ParameterSetName = 'Object',ValueFromPipelineByPropertyName = $true)]
		[Object]
		$Object,
		
		# A PScredential.  
		[Parameter(Mandatory=$true,ParameterSetName='PSCredential',ValueFromPipelineByPropertyName=$true)]
		[Management.Automation.PSCredential]
		$Credential	,

		# The Name of the Registry Key to store the encrypted information.
		[Parameter()]
		[string]
		$cmsFolderName = 'CMSData'
			
	)
    
	process 
	{       
		#region Create Registry Location If It Doesn't Exist 
		$registryPath = "HKCU:\Software\$cmsFolderName\"
		$fullRegistryPath = "$registryPath\$($psCmdlet.ParameterSetName)"
		if (-not (Test-Path $fullRegistryPath)) 
		{
			$null = New-Item $fullRegistryPath  -Force
		}   
		
              
		if ($psCmdlet.ParameterSetName -eq 'String') 
		{
			#region Encrypt and Store Strings
			$newSecureString = Protect-CmsMessage -Content $String -To "CN=$CMSCertName"
                  
			try
			{
				Write-Verbose ('Add-CMSSecret:`tAdding CMS item [{0}] as [{1}] at path [{2}]' -f $name, $psCmdlet.ParameterSetName,$fullRegistryPath)
				
				# Add value to Registry
				Set-ItemProperty $fullRegistryPath -Name $Name -Value $newSecureString -ErrorAction Stop			
			}
			catch
			{
				Throw ('An Error Occurred on Line [{0}]...[{1}]' -f   $_.InvocationInfo.ScriptLineNumber,$_)				
			}
				
		}
		elseif ($psCmdlet.ParameterSetName -eq 'Hashtable') 
		{
			#region Embed And Store Hashtables
			$newSecureString = Write-PowerShellHashtable -InputObject $Hashtable | Protect-CmsMessage -To "CN=$CMSCertName" 
			
			try
			{
				Write-Verbose ('Add-CMSSecret:`tAdding CMS item [{0}] as [{1}] at path [{2}]' -f $name, $psCmdlet.ParameterSetName,$fullRegistryPath)
				
				# Add value to Registry
				Set-ItemProperty $fullRegistryPath -Name $Name -Value $newSecureString -ErrorAction Stop			
			}
			catch
			{
				Throw ('An Error Occurred on Line [{0}]...[{1}]' -f   $_.InvocationInfo.ScriptLineNumber,$_)				
			}
			
		}
		elseif ($psCmdlet.ParameterSetName -eq 'Object') 
		{
			# Convert object to Json
			$newSecureString = ($Object | ConvertTo-Json) | Protect-CmsMessage -To "CN=$CMSCertName"
                  
			try
			{
				Write-Verbose ('Add-CMSSecret:`tAdding CMS item [{0}] as [{1}] at path [{2}]' -f $name, $psCmdlet.ParameterSetName,$fullRegistryPath)
				
				# Add value to Registry
				Set-ItemProperty $fullRegistryPath -Name $Name -Value $newSecureString -ErrorAction Stop			
			}
			catch
			{
				Throw ('An Error Occurred on Line [{0}]...[{1}]' -f   $_.InvocationInfo.ScriptLineNumber,$_)				
			}

		} 
		elseif ($psCmdlet.ParameterSetName -eq 'PSCredential') 
		{
			$CredObject = [PScustomobject]@{UserName = $Credential.UserName;Password = $Credential.GetNetworkCredential().Password}
			
			# Encrypt Object
			$newSecureString = ($CredObject | ConvertTo-Json)  | Protect-CmsMessage -To "CN=$CMSCertName"
                  
			try
			{
				Write-Verbose ('Add-CMSSecret:`tAdding CMS item [{0}] as [{1}] at path [{2}]' -f $name, $psCmdlet.ParameterSetName,$fullRegistryPath)
				
				# Add value to Registry
				Set-ItemProperty $fullRegistryPath -Name $Name -Value $newSecureString -ErrorAction Stop			
			}
			catch
			{
				Throw ('An Error Occurred on Line [{0}]...[{1}]' -f   $_.InvocationInfo.ScriptLineNumber,$_)				
			}

		} # Credential

                   
	}
} 
