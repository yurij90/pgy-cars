<?php

namespace Database\Factories;

use App\Models\CarBrand;
use App\Models\CarType;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\CarType>
 */
class CarTypeFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = CarType::class;

    public function definition(): array
    {
        return [
            'car_brand_id' => CarBrand::factory(),
            'name' => $this->faker->word() . ' ' . $this->faker->randomNumber(3)
        ];
    }
}
