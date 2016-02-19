[DscResource()]
class xFileResource
{
    [DscProperty(key)]
    [string]
    $DestinationPath

    [DscProperty()]
    [string]
    $SourcePath

    [DscProperty()]
    [string]
    $Content

    [DscProperty()]
    [PSCredential]
    $Credential

    [DscProperty()]
    [ValidateSet('Present', 'Absent')]
    [string]
    $Ensure

    [DscProperty()]
    [bool]
    $Force

    [DscProperty()]
    [string]
    [ValidateSet('File', 'Directory')]
    $Type 

    [DscProperty()]
    [string]
    [ValidateSet("SHA-1", "SHA-256", "SHA-512", "CreatedDate", "ModifiedDate")]
    $CheckSum

    [DscProperty()]
    [bool]
    $Recurse

    [DscProperty(NotConfigurable)]
    [Datetime]
    $CreatedDate

    [DscProperty(NotConfigurable)]
    [Datetime]
    $ModifiedDate

    [DscProperty()]
    [string[]]
    [ValidateSet("ReadOnly", "Hidden", "System", "Archive")]
    $Attributes

    [DscProperty(NotConfigurable)]
    [uint64]
    $Size

    [DscProperty()]
    [bool]
    $MatchSource

    <#[DscProperty(NotConfigurable)]
    [xFileResource[]]
    $SubItems#>

    #region InventorySpecificProperties

    [DscProperty()]
    [int]
    $MaxFileSizeKB

    <#[DscProperty(NotConfigurable)]
    [System.Security.AccessControl.FileSecurity]
    $Acl#>
     
    #endregion InventorySpecificProperties

    #region Dsc Methods

    [bool] Test()
    {
        return $false
    }

    [void] Set()
    {

    }

    [xFileResource] Get()
    {
        return $this
    }

    #endregion Dsc Methods

    #region Inventory

    [xFileResource[]] GetInventory()
    {
        if (! (Test-Path $this.DestinationPath) )
        {
            return [xFileResource[]]@()
        }

        $files = @()
        Get-Item $this.DestinationPath | % {
            $Files += New-Object xFileResource $item
        }
        return $files
    }

    #endregion Inventory

    xFileResource()
    {

    }

    xFileResource([System.IO.FileInfo]$FileInfo)
    {
        $this.DestinationPath = $FileInfo.FullName
        $this.SourcePath = [string]::Empty
    }
}

function Test-GetInventory1
{
    $xFile = New-Object xFileResource

    $xFile.DestinationPath = 'c:\windows\system32\dsccore.dll'

    $xFile.GetInventory()
}

function Test-GetInventoryMany
{
    $xFile = New-Object xFileResource

    $xFile.DestinationPath = 'c:\windows\system32\dsc*'

    $xFile.GetInventory()
}