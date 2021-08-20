﻿# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

. $PSScriptRoot\..\New-TestResult.ps1
function Test-MissingDirectory {
    $installPath = (Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ExchangeServer\v15\Setup -ErrorAction SilentlyContinue).MsiInstallPath
    $owaVersion = (Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ExchangeServer\v15\Setup -ErrorAction SilentlyContinue).OwaVersion
    $checkLocations = @("UnifiedMessaging\Grammars", "UnifiedMessaging\Prompts")

    if ($null -ne $installPath -and
        (Test-Path $installPath) -and
        $owaVersion -notlike "15.2.*") {
        foreach ($path in $checkLocations) {
            $params = @{
                TestName   = "Missing Directories"
                CustomData = ([System.IO.Path]::Combine($installPath, $path))
            }
            if (-not (Test-Path ([System.IO.Path]::Combine($installPath, $path)))) {
                New-TestResult @params -Result "Failed"
            } else {
                New-TestResult @params -Result "Passed"
            }
        }
    }
}
