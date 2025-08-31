<?php

namespace Database\Seeders;

use App\Models\CarType;
use App\Models\FavoriteCar;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class FavoriteCarSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = User::all();
        $carTypes = CarType::all();

        $colors = ['Black', 'White', 'Silver', 'Red', 'Blue', 'Green'];
        $fuelTypes = ['Gasoline', 'Diesel', 'Electric', 'Hybrid'];

        foreach ($users as $user) {
            for ($i = 0; $i < rand(0, 3); $i++) {
                FavoriteCar::create([
                    'car_type_id' => $carTypes->random()->id,
                    'user_id' => $user->id,
                    'year' => rand(2015, 2024),
                    'color' => $colors[array_rand($colors)],
                    'fuel_type' => $fuelTypes[array_rand($fuelTypes)]
                ]);
            }
        }
    }
}
