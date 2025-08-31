<?php

namespace Database\Seeders;

use App\Models\CarBrand;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CarBrandSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $brands = [
            'Toyota',
            'BMW',
            'Mercedes-Benz',
            'Audi',
            'Volkswagen',
            'Ford',
            'Opel',
            'Skoda',
            'Hyundai',
            'Kia'
        ];

        foreach ($brands as $brand) {
            CarBrand::create(['name' => $brand]);
        }
    }
}
