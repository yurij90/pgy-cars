<?php

namespace Database\Factories;

use App\Models\CarType;
use App\Models\FavoriteCar;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\FavoriteCar>
 */
class FavoriteCarFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = FavoriteCar::class;

    public function definition(): array
    {
        return [
            'car_type_id' => CarType::factory(),
            'user_id' => User::factory(),
            'year' => $this->faker->numberBetween(2010, 2024),
            'color' => $this->faker->randomElement(['Black', 'White', 'Silver', 'Red', 'Blue', 'Green']),
            'fuel_type' => $this->faker->randomElement(['Gasoline', 'Diesel', 'Electric', 'Hybrid'])
        ];
    }
}
