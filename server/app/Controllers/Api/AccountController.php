<?php

namespace App\Controllers\Api;

use App\Models\AccountModel;
use CodeIgniter\HTTP\ResponseInterface;

class AccountController extends BaseApiController
{
    private AccountModel $model;

    public function __construct()
    {
        $this->model = new AccountModel();
    }

    // ── GET /api/v1/accounts ──────────────────────────────────────────────

    public function index()
    {
        $accounts = $this->model->activeForUser($this->userId());
        return $this->success($accounts);
    }

    // ── POST /api/v1/accounts ─────────────────────────────────────────────

    public function create()
    {
        $rules = [
            'name'     => 'required|max_length[100]',
            'type'     => 'required|in_list[cash,bank,credit]',
            'balance'  => 'permit_empty|decimal',
            'currency' => 'permit_empty|max_length[10]',
        ];

        if (! $this->validate($rules)) {
            return $this->error('Validation failed.', ResponseInterface::HTTP_UNPROCESSABLE_ENTITY, $this->validator->getErrors());
        }

        $id = $this->uuid();

        $this->model->insert([
            'id'       => $id,
            'user_id'  => $this->userId(),
            'name'     => $this->request->getVar('name'),
            'type'     => $this->request->getVar('type'),
            'balance'  => $this->request->getVar('balance') ?? 0,
            'currency' => $this->request->getVar('currency') ?? 'INR',
        ]);

        // Return the full persisted record (includes DB-set created_at / updated_at)
        return $this->success($this->model->find($id), 'Account created.', ResponseInterface::HTTP_CREATED);
    }

    // ── GET /api/v1/accounts/:id ──────────────────────────────────────────

    public function show(string $id)
    {
        $account = $this->model->where('id', $id)->where('user_id', $this->userId())->first();

        if (! $account || $account['is_deleted']) {
            return $this->error('Account not found.', ResponseInterface::HTTP_NOT_FOUND);
        }

        return $this->success($account);
    }

    // ── PUT /api/v1/accounts/:id ──────────────────────────────────────────

    public function update(string $id)
    {
        $account = $this->model->where('id', $id)->where('user_id', $this->userId())->first();

        if (! $account || $account['is_deleted']) {
            return $this->error('Account not found.', ResponseInterface::HTTP_NOT_FOUND);
        }

        $rules = [
            'name'     => 'permit_empty|max_length[100]',
            'type'     => 'permit_empty|in_list[cash,bank,credit]',
            'balance'  => 'permit_empty|decimal',
            'currency' => 'permit_empty|max_length[10]',
        ];

        if (! $this->validate($rules)) {
            return $this->error('Validation failed.', ResponseInterface::HTTP_UNPROCESSABLE_ENTITY, $this->validator->getErrors());
        }

        $updateData = array_filter([
            'name'     => $this->request->getVar('name'),
            'type'     => $this->request->getVar('type'),
            'balance'  => $this->request->getVar('balance'),
            'currency' => $this->request->getVar('currency'),
        ], fn($v) => $v !== null);

        $this->model->update($id, $updateData);

        return $this->success($this->model->find($id), 'Account updated.');
    }

    // ── DELETE /api/v1/accounts/:id ───────────────────────────────────────

    public function delete(string $id)
    {
        $account = $this->model->where('id', $id)->where('user_id', $this->userId())->first();

        if (! $account || $account['is_deleted']) {
            return $this->error('Account not found.', ResponseInterface::HTTP_NOT_FOUND);
        }

        $this->model->update($id, ['is_deleted' => 1, 'updated_at' => date('Y-m-d H:i:s')]);

        return $this->success(null, 'Account deleted.');
    }
}
