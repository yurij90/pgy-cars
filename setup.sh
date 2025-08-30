#!/bin/bash

# Read inputs
read -p "Enter full name: " name
read -p "Enter username: " username
read -sp "Enter password: " password
echo ""
username=$(echo "$username" | tr '[:upper:]' '[:lower:]')

# File paths
seederFile="./database/seeders/UserSeeder.php"
sqlitePath="./database/database.sqlite"

# New user block
newBlock="User::factory()->create([
    'name' => '$name',
    'username' => '$username',
    'role' => 'admin',
    'password' => '$password',
]);"

# Replace the first matching block using Perl with multiline regex
perl -0777 -i -pe "s/User::factory\(\)->create\(\[\s*'name'.*?\]\s*\);/$newBlock/s" "$seederFile"

# Create SQLite directory and empty file
mkdir -p ./database
: > "$sqlitePath"

echo "UserSeeder.php updated, SQLite file created."

# Start the project
echo "Starting project setup..."
composer install

# Check if .env file exists, create from example if missing, then generate app key
if [ ! -f ".env" ]; then
  cp .env.example .env
  php artisan key:generate
fi

php artisan migrate

npm install && npm run build

php artisan migrate:fresh --seed

composer run dev
