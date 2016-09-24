#
# Module manifest for module 'PSSecret'
#
# Generated by: Kiran Reddy
#
# Generated on: 9/25/2016
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'PSSecret.psm1'

# Version number of this module.
ModuleVersion = '1.0.0'

# ID used to uniquely identify this module
GUID = '6abe1400-6663-4dde-9500-19a8d63f3822'

# Author of this module
Author = 'Kiran Reddy'

# Company or vendor of this module
CompanyName = 'https://github.com/v2kiran/PSSecret'

# Copyright statement for this module
Copyright = 'Kiran Reddy (c) 2016 . All rights reserved.'

# Description of the functionality provided by this module
 Description = 'Store and retrieve secrets using PowerShell V5 CMS and PKI'

# Minimum version of the Windows PowerShell engine required by this module
 PowerShellVersion = '5.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module
#FunctionsToExport = @()

# Cmdlets to export from this module
CmdletsToExport = @('Add-CMSSecret','Get-CMSSecret','Remove-CMSSecret')

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module
AliasesToExport = @('cms','New-CMSSecret','Set-CMSSecret','AddCMS')

# List of all modules packaged with this module
 ModuleList = @('PSSecret.psm1')

# List of all files packaged with this module
# FileList = @()

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

