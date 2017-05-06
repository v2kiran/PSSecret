PSSecret
=======

PSSecret acts as your personal secure vault where you can store and retrive data securely.
You can store the following types of information :

* Strings
* Credentials 
* Hashtables 
* Objects

The values are encrypted and stored in the current user's registry. Information is encrypted using PKI.

## Requires

* PowerShell V5

## PSSecret exports the following cmdlets

* Get-CMSSecret
* Add-CMSSecret
* Remove-CMSSecret

bJhT]CuV9Uk]fmq#2AnN3-*n

## Installation

You have 2 choices:
* Download From [PowerShell Gallery](https://www.powershellgallery.com/packages/PSSecret/1.0.0) (requires PowerShell V5).

```
Install-Module PSSecret -scope CurrentUser
```
* Download from Github [PSSecret-master.zip](https://github.com/v2kiran/PSSecret/archive/master.zip) and extract it to a folder named `PSSecret` in any of the PowerShell module paths. 
(Run `$env:PSModulePath` to see them.)



## Configuration

Since this module makes use of PKI, a certificate that can encrypt documents is needed which the module will install automatically for you during the time of import or first run.
To import the module run:
```
Import-Module PSSecret
```

#### Note: The certificate install is a one-time action and does not need to be installed on every use.

## Usage

All cmdlets come with built-in help. To see sample usage of a cmdlet, just type:

```
Get-Help Get-CMSSecret -Examples
```

Samples:


#### Add a string:
```
AddCMS mystring secretstringvalue
```
#### Add a credential with the same name:
```
AddCMS mystring -Credential Get-Credential
```
#### Add a hashtable with the same name:
```
AddCMS mystring -Hashtable @{Username='Kiran';Password='Passw0rd123'}
```
#### Add an object with the same name:
```
AddCMS mystring -Object ([pscustomobject]@{name='John';age='15';LastName='Doe'})
```


### Now lets retrieve what we stored:

#### Get the String secret
```
CMS mystring String -v
```
#### Get the Credential secret
```
CMS mystring PSCredential -v
```
#### Get the Hashtable secret
```
CMS mystring Hashtable -v
```
#### Get the Object secret
```
CMS mystring Object -v
```
#### Display all stored secrets.
```
CMS
```

## About PSSecret

PSSecret is based on the awesome powershell module called [SecureSettings](https://github.com/StartAutomating/SecureSettings) by James Brundage.
While securesettings used Microsoft's DPAPI for encryption this module PSSecret uses the "Crytographic Message Syntax" [CMS cmdlets](https://technet.microsoft.com/en-us/library/dn807171.aspx) 
introduced in PowerShell V5 which use the public key infrastructure [PKI](https://msdn.microsoft.com/en-us/library/windows/desktop/bb427432(v=vs.85).aspx) to encrypt data.
 
The CMS cmdlets requires a public key from a digital certificate, but not just any certificate will work. Here are the requirements for the public key certificate:

* The certificate must include the "Data Encipherment" or "Key Encipherment" Key Usage in the property details of the certificate.
* The certificate must include the "Document Encryption" Enhanced Key Usage (EKU), which is identified by OID number 1.3.6.1.4.1.311.80.1.


Links:

[SecureSettings](https://github.com/StartAutomating/SecureSettings)

[CMS Cmdlets in PowerShell V5](https://technet.microsoft.com/en-us/library/dn807171.aspx)

[PKI](https://msdn.microsoft.com/en-us/library/windows/desktop/bb427432(v=vs.85).aspx)

