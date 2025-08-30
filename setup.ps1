# Inputs
$name = Read-Host "Enter full name: "
$username = Read-Host "Enter username: "
$password = Read-Host "Enter password: "
$username = $username.ToLower()

# File paths
$seederFile = ".\database\seeders\UserSeeder.php"
$sqlitePath = ".\database\database.sqlite"

# New block
$newBlock = @"
User::factory()->create([
    'name' => '$name',
    'username' => '$username',
    'role' => 'admin',
    'password' => '$password',
]);
"@

# Read file
$content = Get-Content $seederFile -Raw

# Regex to find block
$pattern = "User::factory\(\)->create\(\[\s*'name'.*?\]\s*\);"

# Change the first block
$regex = [regex]::new($pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
$updated = $regex.Replace($content, $newBlock, 1)

# Write file
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText((Resolve-Path $seederFile), $updated, $utf8NoBom)

# Creating empty SQLite file
if (-Not (Test-Path ".\database")) {
    New-Item -ItemType Directory -Path ".\database" | Out-Null
}
New-Item -ItemType File -Path $sqlitePath -Force | Out-Null

Write-Host "UserSeeder.php updated, SQLite file created."

# Starting project
Write-Host "Starting project..."
Invoke-Expression "composer install"
Invoke-Expression "npm install"
Invoke-Expression "npm run build"

# .env check
if (-Not (Test-Path ".env")) {
    Copy-Item -Path ".env.example" -Destination ".env"
    Invoke-Expression "php artisan key:generate"
}

Invoke-Expression "php artisan migrate"
Invoke-Expression "php artisan migrate:fresh --seed"
Start-Process "http://localhost:8000/"
Invoke-Expression "composer run dev"
