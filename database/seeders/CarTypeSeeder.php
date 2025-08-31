<?php

namespace Database\Seeders;

use App\Models\CarBrand;
use App\Models\CarType;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CarTypeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $types = [
            'Toyota' => ['Corolla', 'Camry', 'RAV4', 'Prius'],
            'BMW' => ['320i', '520i', 'X3', 'X5'],
            'Mercedes-Benz' => ['C-Class', 'E-Class', 'GLA', 'GLC'],
            'Audi' => ['A4', 'A6', 'Q3', 'Q5'],
            'Volkswagen' => ['Golf', 'Passat', 'Tiguan', 'Polo'],
            'Ford' => ['Focus', 'Mondeo', 'Kuga', 'Fiesta'],
            'Opel' => ['Astra', 'Corsa', 'Insignia', 'Mokka'],
            'Skoda' => ['Octavia', 'Fabia', 'Superb', 'Kodiaq'],
            'Hyundai' => ['i30', 'Tucson', 'Elantra', 'Santa Fe'],
            'Kia' => ['Ceed', 'Sportage', 'Rio', 'Sorento']
        ];

        foreach ($types as $brandName => $typeList) {
            $brand = CarBrand::where('name', $brandName)->first();
            if ($brand) {
                foreach ($typeList as $type) {
                    CarType::create([
                        'car_brand_id' => $brand->id,
                        'name' => $type
                    ]);
                }
            }
        }
    }
}
