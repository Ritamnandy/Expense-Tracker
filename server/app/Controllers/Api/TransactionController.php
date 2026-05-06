<?php

namespace App\Controllers\Api;

use App\Models\TransactionModel;
use CodeIgniter\HTTP\ResponseInterface;

class TransactionController extends BaseApiController
{
    private TransactionModel $model;

    public function __construct()
    {
        $this->model = new TransactionModel();
    }

    // ── GET /api/v1/transactions ──────────────────────────────────────────
    // Query params: start_date, end_date, account_id, type

    public function index()
    {
        $filters = [
            'start_date' => $this->request->getGet('start_date'),
            'end_date'   => $this->request->getGet('end_date'),
            'account_id' => $this->request->getGet('account_id'),
            'type'       => $this->request->getGet('type'),
        ];

        $transactions = $this->model->getForUser($this->userId(), $filters);
        $summary      = $this->model->getSummary($this->userId());

        return $this->success([
            'transactions' => $transactions,
            'summary'      => $summary,
        ]);
    }

    // ── POST /api/v1/transactions ─────────────────────────────────────────

    public function create()
    {
        // Determine type first so we can conditionally require category_id.
        // Transfer transactions move money between accounts — category is not applicable.
        $type = $this->request->getVar('type');

        $rules = [
            'account_id'  => 'required',
            'category_id' => ($type !== 'transfer') ? 'required' : 'permit_empty',
            'amount'      => 'required|decimal|greater_than[0]',
            'type'        => 'required|in_list[income,expense,transfer]',
            'date'        => 'required|valid_date[Y-m-d H:i:s]',
            'note'        => 'permit_empty|max_length[500]',
        ];

        if (! $this->validate($rules)) {
            return $this->error('Validation failed.', ResponseInterface::HTTP_UNPROCESSABLE_ENTITY, $this->validator->getErrors());
        }

        $id = $this->uuid();

        $this->model->insert([
            'id'          => $id,
            'user_id'     => $this->userId(),
            'account_id'  => $this->request->getVar('account_id'),
            'category_id' => $this->request->getVar('category_id'),
            'amount'      => $this->request->getVar('amount'),
            'type'        => $type,
            'date'        => $this->request->getVar('date'),
            'note'        => $this->request->getVar('note'),
        ]);

        // Return the full persisted record (includes DB-set created_at / updated_at)
        return $this->success($this->model->find($id), 'Transaction created.', ResponseInterface::HTTP_CREATED);
    }

    // ── GET /api/v1/transactions/:id ──────────────────────────────────────

    public function show(string $id)
    {
        $transaction = $this->model->where('id', $id)->where('user_id', $this->userId())->first();

        if (! $transaction || $transaction['is_deleted']) {
            return $this->error('Transaction not found.', ResponseInterface::HTTP_NOT_FOUND);
        }

        return $this->success($transaction);
    }

    // ── PUT /api/v1/transactions/:id ──────────────────────────────────────

    public function update(string $id)
    {
        $transaction = $this->model->where('id', $id)->where('user_id', $this->userId())->first();

        if (! $transaction || $transaction['is_deleted']) {
            return $this->error('Transaction not found.', ResponseInterface::HTTP_NOT_FOUND);
        }

        $rules = [
            'account_id'  => 'permit_empty',
            'category_id' => 'permit_empty',
            'amount'      => 'permit_empty|decimal|greater_than[0]',
            'type'        => 'permit_empty|in_list[income,expense,transfer]',
            'date'        => 'permit_empty|valid_date[Y-m-d H:i:s]',
            'note'        => 'permit_empty|max_length[500]',
        ];

        if (! $this->validate($rules)) {
            return $this->error('Validation failed.', ResponseInterface::HTTP_UNPROCESSABLE_ENTITY, $this->validator->getErrors());
        }

        $updateData = array_filter([
            'account_id'  => $this->request->getVar('account_id'),
            'category_id' => $this->request->getVar('category_id'),
            'amount'      => $this->request->getVar('amount'),
            'type'        => $this->request->getVar('type'),
            'date'        => $this->request->getVar('date'),
            'note'        => $this->request->getVar('note'),
        ], fn($v) => $v !== null);

        $this->model->update($id, $updateData);

        return $this->success($this->model->find($id), 'Transaction updated.');
    }

    // ── DELETE /api/v1/transactions/:id ───────────────────────────────────

    public function delete(string $id)
    {
        $transaction = $this->model->where('id', $id)->where('user_id', $this->userId())->first();

        if (! $transaction || $transaction['is_deleted']) {
            return $this->error('Transaction not found.', ResponseInterface::HTTP_NOT_FOUND);
        }

        $this->model->update($id, ['is_deleted' => 1]);

        return $this->success(null, 'Transaction deleted.');
    }
}
