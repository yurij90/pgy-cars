<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        User::factory(10)->create();

        User::factory()->create([
            'name' => 'Admin User',
            'username' => 'admin',
            'role' => 'admin',
            'password' => 'admin',
        ]);

        User::factory()->create([
            'name' => 'Test User',
            'username' => 'test',
            'password' => 'test',
        ]);

        User::factory()->create([
            'name' => 'Inactive User',
            'username' => 'inactive',
            'password' => 'inactive',
            'isActive' => false,
        ]);
    }
}
