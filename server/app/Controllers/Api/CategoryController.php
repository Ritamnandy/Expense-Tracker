<?php

namespace App\Controllers\Api;

use App\Models\CategoryModel;
use CodeIgniter\HTTP\ResponseInterface;

class CategoryController extends BaseApiController
{
    private CategoryModel $model;

    public function __construct()
    {
        $this->model = new CategoryModel();
    }

    // ── GET /api/v1/categories ────────────────────────────────────────────

    public function index()
    {
        $categories = $this->model->activeForUser($this->userId());
        return $this->success($categories);
    }

    // ── POST /api/v1/categories ───────────────────────────────────────────

    public function create()
    {
        $rules = [
            'name'  => 'required|max_length[100]',
            'type'  => 'required|in_list[income,expense]',
            'icon'  => 'permit_empty|max_length[100]',
            'color' => 'permit_empty|max_length[20]',
        ];

        if (! $this->validate($rules)) {
            return $this->error('Validation failed.', ResponseInterface::HTTP_UNPROCESSABLE_ENTITY, $this->validator->getErrors());
        }

        $data = [
            'id'      => $this->uuid(),
            'user_id' => $this->userId(),
            'name'    => $this->request->getVar('name'),
            'type'    => $this->request->getVar('type'),
            'icon'    => $this->request->getVar('icon'),
            'color'   => $this->request->getVar('color'),
        ];

        $this->model->insert($data);

        return $this->success($data, 'Category created.', ResponseInterface::HTTP_CREATED);
    }

    // ── PUT /api/v1/categories/:id ────────────────────────────────────────

    public function update(string $id)
    {
        $category = $this->model->where('id', $id)->where('user_id', $this->userId())->first();

        if (! $category || $category['is_deleted']) {
            return $this->error('Category not found.', ResponseInterface::HTTP_NOT_FOUND);
        }

        $rules = [
            'name'  => 'permit_empty|max_length[100]',
            'type'  => 'permit_empty|in_list[income,expense]',
            'icon'  => 'permit_empty|max_length[100]',
            'color' => 'permit_empty|max_length[20]',
        ];

        if (! $this->validate($rules)) {
            return $this->error('Validation failed.', ResponseInterface::HTTP_UNPROCESSABLE_ENTITY, $this->validator->getErrors());
        }

        $updateData = array_filter([
            'name'  => $this->request->getVar('name'),
            'type'  => $this->request->getVar('type'),
            'icon'  => $this->request->getVar('icon'),
            'color' => $this->request->getVar('color'),
        ], fn($v) => $v !== null);

        $this->model->update($id, $updateData);

        return $this->success($this->model->find($id), 'Category updated.');
    }

    // ── DELETE /api/v1/categories/:id ─────────────────────────────────────

    public function delete(string $id)
    {
        $category = $this->model->where('id', $id)->where('user_id', $this->userId())->first();

        if (! $category || $category['is_deleted']) {
            return $this->error('Category not found.', ResponseInterface::HTTP_NOT_FOUND);
        }

        $this->model->update($id, ['is_deleted' => 1]);

        return $this->success(null, 'Category deleted.');
    }
}
