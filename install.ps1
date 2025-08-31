Write-Host "Checking dependencies for Windows..."

function Is-Installed($command) {
    return (Get-Command $command -ErrorAction SilentlyContinue) -ne $null
}

# Installing PHP if its not found
if (-not (Is-Installed "php")) {
    Write-Host "`nPHP not found. Installing PHP..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://php.new/install/windows/8.4'))

    # Adding PHP to PATH in session
    $phpPath = "C:\php"
    $env:Path += ";$phpPath"
    Write-Host "`nPHP has been added to PATH for this session."
} else {
    Write-Host "PHP is already installed."
}

# Installing composer if its not found
if (-not (Is-Installed "composer")) {
    Write-Host "`nComposer not found. Installing Composer..."

    # Checksum
    $EXPECTED_CHECKSUM = php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");'
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    $ACTUAL_CHECKSUM = php -r "echo hash_file('sha384', 'composer-setup.php');"

    if ($EXPECTED_CHECKSUM -ne $ACTUAL_CHECKSUM) {
        Write-Host "ERROR: Invalid installer checksum" -ForegroundColor Red
        Remove-Item composer-setup.php
        exit 1
    }

    php composer-setup.php --quiet
    $RESULT = $?
    Remove-Item composer-setup.php

    if ($RESULT -eq 0) {
        Write-Host "`nComposer has been successfully installed."
        $composerPath = "$env:USERPROFILE\composer"
        # Add to PATH
        if (-not (Test-Path "$composerPath\composer.phar")) {
            Move-Item .\composer.phar $composerPath\composer.phar -Force
            [Environment]::SetEnvironmentVariable("Path", "$env:Path;$composerPath", [EnvironmentVariableTarget]::User)
        }
        Write-Host "`nComposer has been added to PATH."
    } else {
        Write-Host "Composer installation failed."
    }
} else {
    Write-Host "Composer is already installed."
}
# Check winget
if (-not (Is-Installed "node") -or -not (Is-Installed "git") -and -not (Is-Installed "winget")) {
    Write-Host "`nWinGet not found. Installing WinGet PowerShell module..."
    try {
        $progressPreference = 'silentlyContinue'
        Write-Host "Installing WinGet PowerShell module from PSGallery..."
        Install-PackageProvider -Name NuGet -Force | Out-Null
        Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
        Write-Host "Using Repair-WinGetPackageManager cmdlet to bootstrap WinGet..."
        try {
            Repair-WinGetPackageManager -AllUsers -ErrorAction Stop
            Write-Host "WinGet PowerShell module installed successfully."
        } catch {
            Write-Warning "Repair-WinGetPackageManager error ignored: $($_.Exception.Message)"
        }
        Write-Host "WinGet PowerShell module installed successfully."
        $wingetPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps"
        if (Test-Path $wingetPath)
        {
            $env:PATH += ";$wingetPath"
            $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
            Write-Host "WinGet path added to current session PATH."
        }
    }
    catch {
        Write-Host "Failed to install WinGet PowerShell module: $_" -ForegroundColor Red
        Write-Host "Please install WinGet manually from Microsoft Store or GitHub releases."
        Start-Process "https://github.com/microsoft/winget-cli/releases"
    }
} else {
    Write-Host "WinGet is already installed."
}

# Check Node.js
if (-not (Is-Installed "node")) {
    try
    {
        winget install OpenJS.NodeJS --source winget
        $nodePath = 'C:\Program Files\nodejs'
        $env:PATH += ";$nodePath"
        Write-Host "Node.js path added to current session PATH."

        if ($LASTEXITCODE -ne 0) {
            throw "winget Node.js install failed with exit code $LASTEXITCODE"
        }
    }
    catch
    {
        Write-Host "`nNode.js is not installed."
        Write-Host "Please download and install it from https://nodejs.org/"
        Start-Process "https://nodejs.org/"
    }
} else {
    Write-Host "Node.js is installed."
}

#Check git
# Check if Git CLI is installed
if (-not (Is-Installed "git")) {
    Write-Host "Git CLI not found. Installing via WinGet..."

    try {
        # Install Git using WinGet
        winget install --id Git.Git -e --source winget

        # Git installation path
        $gitPath = 'C:\Program Files\Git\cmd'

        # Add Git to current session PATH
        $env:PATH += ";$gitPath"

        # Add Git to global PATH (Machine scope)
        $currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
        if (-not ($currentPath -like "*$gitPath*")) {
            [Environment]::SetEnvironmentVariable("Path", "$currentPath;$gitPath", [EnvironmentVariableTarget]::Machine)
        }

        Write-Host "Git CLI has been installed and added to PATH."
    }
    catch {
        Write-Host "Git installation failed. Please install it manually from https://git-scm.com/download/win"
        Start-Process "https://git-scm.com/download/win"
    }
} else {
    Write-Host "Git CLI is already installed."
}

Write-Host "`nDependency check completed."
