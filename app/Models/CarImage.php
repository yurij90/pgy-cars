<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CarImage extends Model
{
    /** @use HasFactory<\Database\Factories\CarImageFactory> */
    use HasFactory;

    protected $fillable = ['favorite_car_id', 'image_content'];

    public function favoriteCar(): BelongsTo
    {
        return $this->belongsTo(FavoriteCar::class);
    }
}
