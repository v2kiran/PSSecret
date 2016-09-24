function Get-CMSSecret
{
  <#
      .Synopsis
      Gets encrypted settings stored in the registry
      .Description
      Gets encrypted settings stored in the registry
      .Example
      Get-CMSSecret

      The above example gets all encrypted MCS secrets currently stored in the current user's registry.
      .Example
      PS C:\> Get-CMSSecret -Name my-AzureCredential 

      Name                 Type                                      EncryptedData                                                                                                                    
      ----                 ----                                      -------------                                                                                                                    
      my-AzureCredential System.Management.Automation.PSCredential -----BEGIN CMS-----...   
      .Example
      PS C:\> Get-CMSSecret -Name my-AzureCredential -Decrypted

      Name                 Type                                      DecryptedData                            
      ----                 ----                                      -------------                            
      my-AzureCredential System.Management.Automation.PSCredential System.Management.Automation.PSCredential
      .Example
      PS C:\> Get-CMSSecret -Name my-AzureCredential -ValueOnly

      UserName                           Password
      --------                           --------
      ad\adUsername System.Security.SecureString
      .Link
      Add-CMSSecret
      .Link
      Remove-CMSSecret
  #>    
  [Alias('cms')]
  [OutputType('PSObj.CMSData')]
  param(
    # The name of the secure setting
    [Parameter(Position=0,ValueFromPipelineByPropertyName=$true)]
    [String]
    $Name,
    
    # The type of the secure setting
    [Validateset('String','Object','PSCredential','Hashtable')]
    [Parameter(Position=1,ValueFromPipelineByPropertyName=$true)]
    [String]
    $Type,
    
    # If set, will decrypt the setting value
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [Switch]
    $Decrypted,
    
    # If set, will decrypt the setting value and return the data
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [switch]
    $ValueOnly,

    # Parameter help description
    [Parameter()]
    [string]
    $cmsFolderName = 'CMSData'		    
  )
    
  begin 
  {

    # region Create Registry Location If It Doesn't Exist 
    # If we dont do this when we run get-cmssecret the first time we get an error about missing reg key
    $registryPath = "HKCU:\Software\$cmsFolderName\"
    $fullRegistryPath = "$registryPath\$($psCmdlet.ParameterSetName)"
    if (-not (Test-Path $fullRegistryPath)) 
    {
      $null = New-Item $fullRegistryPath  -Force
    } 		
		
				
    $getSecureSetting = {
      $Obj = $_
      $typeName = $_.pschildName
      foreach ($propName in ($obj.psobject.properties | Select-Object -ExpandProperty Name)) 
      {
        if ('PSPath', 'PSParentPath', 'PSChildName', 'PSProvider' -contains $propName) 
        {
          $obj.psobject.properties.Remove($propname)
        }
      }
      $Obj.psobject.properties | 
      ForEach-Object {
        $secureSetting = New-Object PSObject 
        $null = $secureSetting.pstypenames.insert(0,'PSObj.CMSData')
        $secureSetting | 
        Add-Member NoteProperty Name $_.Name -PassThru |
        Add-Member NoteProperty Type ($typename -as [Type]) -PassThru |
        Add-Member NoteProperty EncryptedData $_.Value -PassThru 

      }
    }
  }
   
  process 
  {
   		        
    Get-ChildItem $registryPath | Get-ItemProperty | ForEach-Object $getSecureSetting |
    Where-Object {
      if ($psBoundParameters.Name -and $_.Name -ne $name){return}
      if ($psBoundParameters.Type -and $_.Type -ne ($Type -as [type])) { return } 
      $true
    } |
    ForEach-Object -Begin {
      $TempCredTable = @{}
    } -Process {
      if (-not ($decrypted -or $ValueOnly)) { return $_ }
                
      #region Decrypt and Convert Output
      $inputObject = $_
      if ([Hashtable], [string] -contains $_.Type) 
      {
                        
        $decryptedValue= $_.EncryptedData | Unprotect-CmsMessage 
                    
        if ($_.Type -eq [Hashtable]) 
        {

          $decryptedValue = . ([ScriptBlock]::Create($decryptedValue))
        }

      } 
      elseif($_.Type -eq [Object])
      {
        $decryptedValue = $_.EncryptedData | Unprotect-CmsMessage | ConvertFrom-Json
			
      }
      elseif($_.Type -eq [Management.Automation.PSCredential])
      {
        $decryptedCredObject = $_.EncryptedData | Unprotect-CmsMessage | ConvertFrom-Json
        $secpasswd = ConvertTo-SecureString $decryptedCredObject.Password -AsPlainText -Force
        $decryptedValue = New-Object Management.Automation.PSCredential ($decryptedCredObject.UserName,$secpasswd)
							
      }			
      $null = $inputObject.psobject.properties.Remove('EncryptedData')
      $inputObject | Add-Member NoteProperty DecryptedData $decryptedValue -PassThru | ForEach-Object {
          if ($ValueOnly) 
          {
            $_.DecryptedData
          } 
          else 
          {
            $_
          }
				  
      }# Foreach inputobject 			

    }
                    
  }

} 
 
