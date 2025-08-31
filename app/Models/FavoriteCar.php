<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class FavoriteCar extends Model
{
    /** @use HasFactory<\Database\Factories\FavoriteCarFactory> */
    use HasFactory;

    protected $fillable = [
        'car_type_id',
        'user_id',
        'year',
        'color',
        'fuel_type'
    ];

    public function carType(): BelongsTo
    {
        return $this->belongsTo(CarType::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function carImages(): HasMany
    {
        return $this->hasMany(CarImage::class);
    }
}
