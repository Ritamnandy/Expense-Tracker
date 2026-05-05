<?php

namespace App\Models;

use CodeIgniter\Model;

class TransactionModel extends Model
{
    protected $table            = 'transactions';
    protected $primaryKey       = 'id';
    protected $useAutoIncrement = false;   // UUID primary key
    protected $returnType       = 'array';
    protected $useSoftDeletes   = false;
    protected $protectFields    = true;

    protected $allowedFields = [
        'id',
        'user_id',
        'account_id',
        'category_id',
        'amount',
        'type',        // income | expense | transfer
        'date',
        'note',
        'is_deleted',
        'synced_at',
        'created_at',
        'updated_at',
    ];

    protected $useTimestamps = true;
    protected $createdField  = 'created_at';
    protected $updatedField  = 'updated_at';

    // ── Scopes ────────────────────────────────────────────────────────────

    /**
     * List transactions with optional filters.
     *
     * @param array $filters Supported keys: start_date, end_date, account_id, type
     */
    public function getForUser(string $userId, array $filters = []): array
    {
        $this->where('user_id', $userId)->where('is_deleted', 0);

        if (! empty($filters['start_date'])) {
            $this->where('date >=', $filters['start_date']);
        }
        if (! empty($filters['end_date'])) {
            $this->where('date <=', $filters['end_date']);
        }
        if (! empty($filters['account_id'])) {
            $this->where('account_id', $filters['account_id']);
        }
        if (! empty($filters['type'])) {
            $this->where('type', $filters['type']);
        }

        return $this->orderBy('date', 'DESC')->findAll();
    }

    public function modifiedSince(string $userId, string $since): array
    {
        return $this
            ->where('user_id', $userId)
            ->where('updated_at >=', $since)
            ->findAll();
    }

    // ── Summary Helpers ───────────────────────────────────────────────────

    /**
     * Get total income and expense for a user (non-deleted).
     */
    public function getSummary(string $userId): array
    {
        $db     = \Config\Database::connect();
        $income = $db->table($this->table)
            ->selectSum('amount', 'total')
            ->where('user_id', $userId)
            ->where('type', 'income')
            ->where('is_deleted', 0)
            ->get()->getRow()->total ?? 0;

        $expense = $db->table($this->table)
            ->selectSum('amount', 'total')
            ->where('user_id', $userId)
            ->where('type', 'expense')
            ->where('is_deleted', 0)
            ->get()->getRow()->total ?? 0;

        return [
            'income'        => (float) $income,
            'expense'       => (float) $expense,
            'safe_to_spend' => (float) $income - (float) $expense,
        ];
    }
}
