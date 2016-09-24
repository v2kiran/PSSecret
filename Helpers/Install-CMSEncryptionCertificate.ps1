#Function Install-CMSEncryptionCertificate
#{
  [Cmdletbinding(SupportsShouldProcess=$true)]
  param
  (
    [String]$FriendlyName = 'PowerShellCMS',

    [Parameter(HelpMessage='This is the text that is in the Subject Line of the encryption certificate')]
    [String]$CMSCertName = "powershellcms@$env:COMPUTERNAME"
  )

Begin {

$CertTemplate = @"

[Version]
Signature = "`$Windows NT$"

[Strings]
szOID_ENHANCED_KEY_USAGE = "2.5.29.37"
szOID_DOCUMENT_ENCRYPTION = "1.3.6.1.4.1.311.80.1"

[NewRequest]
Subject = cn=$CMSCertName
MachineKeySet = false
KeyLength = 2048
KeySpec = AT_KEYEXCHANGE
HashAlgorithm = Sha1
Exportable = true
RequestType = Cert
KeyUsage = "CERT_KEY_ENCIPHERMENT_KEY_USAGE | CERT_DATA_ENCIPHERMENT_KEY_USAGE"
ValidityPeriod = "Years"
ValidityPeriodUnits = "1000"
FriendlyName = "$FriendlyName"

[Extensions]
%szOID_ENHANCED_KEY_USAGE% = "{text}%szOID_DOCUMENT_ENCRYPTION%"
"@





  if(-not (Get-ChildItem -Path Cert:\CurrentUser\My -DocumentEncryptionCert | Where-Object FriendlyName -eq $FriendlyName))
  {

    if($PSCmdlet.ShouldContinue("Subject:`t[$CMSCertName] & FriendlyName:`t[$FriendlyName] to [CERT:CurrentUser\My] on localmachine","Install a 'Document Encryption' Certificate"))
    {

        $CMS_INF_Path = join-path -Path $env:TEMP -ChildPath pscms.inf
        $CMS_CER_Path = join-path -Path $env:TEMP -ChildPath pscms.cer

        # Create INF file
        $CertTemplate | Out-File -FilePath $CMS_INF_Path -Force

        # Install Certificate from INF file created above
        certreq.exe -new $CMS_INF_Path $CMS_CER_Path

        # Clean-Up INF and CER files
        Remove-Item -Path $CMS_INF_Path,$CMS_CER_Path -ErrorAction SilentlyContinue    

        if(-not (Get-ChildItem -Path Cert:\CurrentUser\My -DocumentEncryptionCert | Where-Object FriendlyName -eq $FriendlyName))
        {
            throw 'An error Occurred...PowerShell Encryption Certificate could not be installed'
        } 
        else 
        {
            Write-Host "`nSuccess:`tAn Encryption Certificate named [$FriendlyName] has been installed on this Computer" -ForegroundColor Green
        } 

    }# supports should process
    else 
    {
        Write-Warning "The CMSSecret PowerShell Module requires a certificate`nthat is 'Document Encryption' capable and must have the friendlyname 'PowerShellCMS'"
    }


  }
  Else
  {
      #Write-Verbose "A PowerShell Encryption Certificate named [$FriendlyName] has already been installed on this Computer"
  }
}#Begin
#}#function
