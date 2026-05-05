<?php

namespace App\Models;

use CodeIgniter\Model;

class CategoryModel extends Model
{
    protected $table            = 'categories';
    protected $primaryKey       = 'id';
    protected $useAutoIncrement = false;   // UUID primary key
    protected $returnType       = 'array';
    protected $useSoftDeletes   = false;
    protected $protectFields    = true;

    protected $allowedFields = [
        'id',
        'user_id',
        'name',
        'type',       // income | expense
        'icon',
        'color',
        'is_deleted',
        'synced_at',
        'created_at',
        'updated_at',
    ];

    protected $useTimestamps = true;
    protected $createdField  = 'created_at';
    protected $updatedField  = 'updated_at';

    // ── Scopes ────────────────────────────────────────────────────────────

    public function activeForUser(string $userId): array
    {
        return $this
            ->where('user_id', $userId)
            ->where('is_deleted', 0)
            ->findAll();
    }

    public function modifiedSince(string $userId, string $since): array
    {
        return $this
            ->where('user_id', $userId)
            ->where('updated_at >=', $since)
            ->findAll();
    }
}
