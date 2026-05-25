<?php

namespace App\Controllers\Api;

use App\Libraries\JwtHelper;
use App\Models\UserModel;
use CodeIgniter\HTTP\ResponseInterface;

class AuthController extends BaseApiController
{
    // ── POST /api/v1/auth/register ────────────────────────────────────────

    public function register()
    {
        $rules = [
            'email'      => 'required|valid_email',
            'password'   => 'required|min_length[6]',
            'first_name' => 'permit_empty|max_length[100]',
            'last_name'  => 'permit_empty|max_length[100]',
        ];

        if (! $this->validate($rules)) {
            return $this->error('Validation failed.', ResponseInterface::HTTP_UNPROCESSABLE_ENTITY, $this->validator->getErrors());
        }

        $model = new UserModel();

        // Check for duplicate email
        if ($model->findByEmail($this->request->getVar('email'))) {
            return $this->error('Email already registered.', ResponseInterface::HTTP_CONFLICT);
        }

        $userId = $this->uuid();

        $model->insert([
            'id'            => $userId,
            'email'         => $this->request->getVar('email'),
            'password_hash' => password_hash($this->request->getVar('password'), PASSWORD_BCRYPT),
            'first_name'    => $this->request->getVar('first_name'),
            'last_name'     => $this->request->getVar('last_name'),
        ]);

        // Create default account
        $accountModel = new \App\Models\AccountModel();
        $accountModel->insert([
            'id'       => $this->uuid(),
            'user_id'  => $userId,
            'name'     => 'Main Wallet',
            'type'     => 'cash',
            'balance'  => 0,
            'currency' => 'INR',
        ]);

        // Create default categories
        $categoryModel = new \App\Models\CategoryModel();
        $categoryModel->insertBatch([
            ['id' => $this->uuid(), 'user_id' => $userId, 'name' => 'Salary',    'type' => 'income',  'icon' => 'money',         'color' => '#00C48C'],
            ['id' => $this->uuid(), 'user_id' => $userId, 'name' => 'Groceries', 'type' => 'expense', 'icon' => 'shopping_cart', 'color' => '#FF644B'],
            ['id' => $this->uuid(), 'user_id' => $userId, 'name' => 'Utilities', 'type' => 'expense', 'icon' => 'bolt',          'color' => '#F4A261'],
        ]);

        $token = JwtHelper::encode(['sub' => $userId]);

        return $this->success(['token' => $token], 'Registration successful.', ResponseInterface::HTTP_CREATED);
    }

    // ── POST /api/v1/auth/login ───────────────────────────────────────────

    public function login()
    {
        $rules = [
            'email'    => 'required|valid_email',
            'password' => 'required',
        ];

        if (! $this->validate($rules)) {
            return $this->error('Validation failed.', ResponseInterface::HTTP_UNPROCESSABLE_ENTITY, $this->validator->getErrors());
        }

        $throttler = \Config\Services::throttler();
        if ($throttler->check($this->request->getIPAddress(), 5, MINUTE) === false) {
            return $this->error('Too many login attempts. Please try again later.', ResponseInterface::HTTP_TOO_MANY_REQUESTS);
        }

        $model = new UserModel();
        $user  = $model->findByEmail($this->request->getVar('email'));
        if(! $user){
            return $this->error('Invalid credentials.', ResponseInterface::HTTP_UNAUTHORIZED);
        }
        if (! password_verify($this->request->getVar('password'), $user['password_hash'])) {
            return $this->error('Invalid credentials.', ResponseInterface::HTTP_UNAUTHORIZED);
        }

        $token = JwtHelper::encode(['sub' => $user['id']]);

        return $this->success([
            'token' => $token,
            'user'  => [
                'id'         => $user['id'],
                'email'      => $user['email'],
                'first_name' => $user['first_name'],
                'last_name'  => $user['last_name'],
            ],
        ], 'Login successful.');
    }

    // ── GET /api/v1/auth/me ───────────────────────────────────────────────

    public function me()
    {
        $model = new UserModel();
        $user  = $model->find($this->userId());

        if (! $user) {
            return $this->error('User not found.', ResponseInterface::HTTP_NOT_FOUND);
        }

        unset($user['password_hash']);

        return $this->success($user);
    }
}
