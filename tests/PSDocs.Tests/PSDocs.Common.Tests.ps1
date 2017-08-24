#
# Unit tests for core PSDocs functionality
#

[CmdletBinding()]
param (

)

# Setup error handling
$ErrorActionPreference = 'Stop';
Set-StrictMode -Version latest;

# Setup tests paths
$rootPath = (Resolve-Path $PSScriptRoot\..\..).Path;
$here = Split-Path -Parent $MyInvocation.MyCommand.Path;
$src = ($here -replace '\\tests\\', '\\src\\') -replace '\.Tests', '';
$temp = "$here\..\..\build";
# $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.';

Import-Module $src -Force;

$outputPath = "$temp\PSDocs.Tests\Common";
Remove-Item -Path $outputPath -Force -Recurse -Confirm:$False -ErrorAction SilentlyContinue;
New-Item -Path $outputPath -ItemType Directory -Force | Out-Null;

$dummyObject = New-Object -TypeName PSObject;

$Global:TestVars = @{ };

Describe 'PSDocs' {
    Context 'Generate a document without an instance name' {

        # Define a test document with a table
        document 'WithoutInstanceName' {
            $InstanceName;
        }

        $outputDoc = "$outputPath\WithoutInstanceName.md";
        Invoke-PSDocument -Name 'WithoutInstanceName' -InputObject $dummyObject -OutputPath $outputPath;

        It 'Should generate an output named WithoutInstanceName.md' {
            Test-Path -Path $outputDoc | Should be $True;
        }

        It 'Should contain document name' {
            Get-Content -Path $outputDoc -Raw | Should match 'WithoutInstanceName';
        }
    }

    Context 'Generate a document with an instance name' {
        
        # Define a test document with a table
        document 'WithInstanceName' {
            $InstanceName;
        }

        Invoke-PSDocument -Name 'WithInstanceName' -InstanceName 'Instance1' -InputObject $dummyObject -OutputPath $outputPath;

        It 'Should not create a output with the document name' {
            Test-Path -Path "$outputPath\WithInstanceName.md" | Should be $False;
        }

        It 'Should generate an output named Instance1.md' {
            Test-Path -Path "$outputPath\Instance1.md" | Should be $True;
        }

        It 'Should contain instance name' {
            Get-Content -Path "$outputPath\Instance1.md" -Raw | Should match 'Instance1';
        }
    }

    Context 'Generate a document with multiple instance names' {
        
        # Define a test document with a table
        document 'WithMultiInstanceName' {
            $InstanceName;
        }

        Invoke-PSDocument -Name 'WithMultiInstanceName' -InstanceName 'Instance2','Instance3' -InputObject $dummyObject -OutputPath $outputPath;

        It 'Should not create a output with the document name' {
            Test-Path -Path "$outputPath\WithMultiInstanceName.md" | Should be $False;
        }

        It 'Should generate an output named Instance2.md' {
            Test-Path -Path "$outputPath\Instance2.md" | Should be $True;
        }

        It 'Should contain instance name Instance2' {
            Get-Content -Path "$outputPath\Instance2.md" -Raw | Should match 'Instance2';
        }

        It 'Should generate an output named Instance3.md' {
            Test-Path -Path "$outputPath\Instance3.md" | Should be $True;
        }

        It 'Should contain instance name Instance3' {
            Get-Content -Path "$outputPath\Instance3.md" -Raw | Should match 'Instance3';
        }
    }
}
