function Remove-CMSSecret
{
  <#
      .Synopsis
      Removes an encrypted setting from the registry
      .Description
      Removes a stored secured user settings in the registry
      .Example
      PS C:\> Get-SPSCMSData -Name EMEA-CortexCredential -Type PSCredential | Remove-SPSCMSData -WhatIf
      What if: Performing the operation "Remove CMS item at path HKCU:\Software\SaaSplazaCMS\pscredential" on target "EMEA-CortexCredential".

      The above example shows what happens when you run the cmdlet without actually applying the action. 
      Remove '-whatif' to apply the action.
      .Example
      Remove-SPSCMSData -Name EMEA-CortexCredential -Type PSCredential
      .Link
      Add-SPSCMSData
      .Link
      Get-SPSCMSData
  #>    
  [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High',DefaultParameterSetName = 'CMSName')]
  [OutputType([Nullable])]
  param(
	
    # The name of the secure setting
    [Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName=$true,ValueFromPipeline = $true,ParameterSetName = 'CMSObject')]
    [Object]
    $CMSObject,	
		
    # The name of the secure setting
    [Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName=$true,ParameterSetName = 'CMSName')]
    [String]
    $Name,
    
    # The type of the secured setting
    [Validateset('String','Object','PSCredential','Hashtable')]
    [Parameter(Mandatory,Position=1,ValueFromPipelineByPropertyName=$true,ParameterSetName = 'CMSName')]
    [String]
    $Type,
    
		# Parameter help description
		[Parameter()]
		[string]
		$cmsFolderName = 'CMSData'    
  )
    
  begin 
  {
    #region Create Registry Location If It Doesn't Exist 
    $registryPath = "HKCU:\Software\$cmsFolderName\"
  }
    
  process 
  {
	
    if($PSCmdlet.ParameterSetName -eq 'CMSObject')
    {
      #region Filter and Remove Appropriate Settings
      $CMSObject | 
          ForEach-Object {
								
          if ($psCmdlet.ShouldProcess($_.Name,"Remove CMS item at path $registryPath\$($_.Type)"))  
          {
					  
          try
          {
              Write-Verbose ('Remove-SPSCMSData:`tRemove CMS item [{0}] at path [{1}]' -f $_.name,"$registryPath\$($_.Type)")
				
              # Remove value from Registry
              Remove-ItemProperty -Path "$registryPath\$($_.Type.Name)" -Name $_.Name -ErrorAction Stop			
          }
          catch
          {
              Throw ('An Error Occurred on Line [{0}]...[{1}]' -f   $_.InvocationInfo.ScriptLineNumber,$_)				
          }
								  
          }#should process				
								 
			              
      }# Foreach-object  
			
    }# CMSObject
		
    if($PSCmdlet.ParameterSetName -eq 'CMSName')
    {
                                  
      if(Get-ItemProperty -Path "$registryPath\$Type" -Name $Name -ErrorAction SilentlyContinue)
      {
          if ($psCmdlet.ShouldProcess($Name,"Remove CMS item at path $registryPath\$Type")) 
          {
					  
					  
            try
            {
                Write-Verbose ('Remove-SPSCMSData:`tRemove CMS item [{0}] at path [{1}]' -f $name,"$registryPath\$Type")
				
                # Remove value from Registry
                Remove-ItemProperty -Path "$registryPath\$Type" -Name $Name -ErrorAction Stop			
            }
            catch
            {
                Throw ('An Error Occurred on Line [{0}]...[{1}]' -f   $_.InvocationInfo.ScriptLineNumber,$_)				
            }
								  
          }#should process
					
      }
      Else
      {
          Write-Warning ("Remove-SPSCMSData:`tThe CMS item [{0}] could not be found at path [{1}]" -f $Name,"$registryPath\$Type")
      }
				
			  
			              			
    }# CMSName
        
 		

  }# Process

} # Function
 
