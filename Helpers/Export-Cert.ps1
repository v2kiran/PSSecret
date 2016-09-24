
$cert = Get-ChildItem Cert:\CurrentUser\My | where friendlyname -eq 'PowershellCMS'

# Password to protect the exported certificate that includes a Private Key
$mypwd = ConvertTo-SecureString -String 'MySecretString' -Force –AsPlainText

# Export certificate with private key and all other properties
Export-PfxCertificate -Cert $cert -FilePath c:\mypfx.pfx -Password $mypwd -Force

# This example imports the PFX file my.pfx into the My store for the current user with private key exportable. 
Import-PfxCertificate –FilePath C:\mypfx.pfx cert:\curentuser\my -Password $mypwd -Exportable
    