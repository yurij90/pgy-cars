#!/bin/bash

# Bekérés
read -p "Add meg a teljes nevet: " name
read -p "Add meg a felhasználónevet: " username
read -sp "Add meg a jelszót: " password
echo ""
username=$(echo "$username" | tr '[:upper:]' '[:lower:]')

# Fájl útvonalak
seederFile="./database/seeders/UserSeeder.php"
sqlitePath="./database/database.sqlite"

# Új blokk
newBlock="User::factory()->create([
    'name' => '$name',
    'username' => '$username',
    'role' => 'admin',
    'password' => '$password',
]);"

# Regex csere perl-el
perl -0777 -i -pe "s/User::factory\(\)->create\(\[\s*'name'.*?\]\s*\);/$newBlock/s" "$seederFile"

# SQLite fájl létrehozása
mkdir -p ./database
: > "$sqlitePath"

echo "UserSeeder.php frissítve, SQLite fájl létrehozva."

# Projekt indítása
echo "Projekt indítása folyamatban..."
npm install
npm run build
php artisan migrate:fresh --seed
composer run dev
