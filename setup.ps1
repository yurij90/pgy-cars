# Bekérjük az adatokat
$name = Read-Host "Add meg a teljes nevet"
$username = Read-Host "Add meg a felhasználónevet"
$password = Read-Host "Add meg a jelszót"
$username = $username.ToLower()

# Fájl útvonalak
$seederFile = ".\database\seeders\UserSeeder.php"
$sqlitePath = ".\database\database.sqlite"

# Új blokk
$newBlock = @"
User::factory()->create([
    'name' => '$name',
    'username' => '$username',
    'role' => 'admin',
    'password' => '$password',
]);
"@

# Teljes fájl beolvasása
$content = Get-Content $seederFile -Raw

# Regex a meglévő blokkra
$pattern = "User::factory\(\)->create\(\[\s*'name'.*?\]\s*\);"

# Csere
$updated = [regex]::Replace($content, $pattern, $newBlock, [System.Text.RegularExpressions.RegexOptions]::Singleline)

# Fájl visszaírása
$updated | Set-Content $seederFile -Encoding UTF8

# Üres SQLite fájl létrehozása
if (-Not (Test-Path ".\database")) {
    New-Item -ItemType Directory -Path ".\database" | Out-Null
}
New-Item -ItemType File -Path $sqlitePath -Force | Out-Null

Write-Host "UserSeeder.php frissítve, SQLite fájl létrehozva."

# Projekt indítása
Write-Host "Projekt indítása folyamatban..."
Invoke-Expression "npm install"
Invoke-Expression "npm run build"
Invoke-Expression "php artisan migrate:fresh --seed"
Invoke-Expression "composer run dev"
