<?php

namespace App\Controllers\Api;

use CodeIgniter\Controller;
use CodeIgniter\HTTP\ResponseInterface;

/**
 * Base controller shared by all API controllers.
 * Provides JSON response helpers and user_id extraction.
 */
abstract class BaseApiController extends Controller
{
    // ── Response Helpers ──────────────────────────────────────────────────

    protected function success($data = null, string $message = 'OK', int $status = ResponseInterface::HTTP_OK)
    {
        return $this->response->setStatusCode($status)->setJSON([
            'success' => true,
            'message' => $message,
            'data'    => $data,
            'error'   => null,
        ]);
    }

    protected function error(string $message, int $status = ResponseInterface::HTTP_BAD_REQUEST, $errors = null)
    {
        return $this->response->setStatusCode($status)->setJSON([
            'success' => false,
            'message' => $message,
            'data'    => null,
            'error'   => $errors,
        ]);
    }

    // ── Auth helper ───────────────────────────────────────────────────────

    /**
     * Returns the authenticated user's UUID (set by JwtFilter).
     */
    protected function userId(): string
    {
        return $this->request->user_id ?? '';
    }

    // ── UUID Generator ────────────────────────────────────────────────────

    protected function uuid(): string
    {
        return sprintf(
            '%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
            mt_rand(0, 0xffff), mt_rand(0, 0xffff),
            mt_rand(0, 0xffff),
            mt_rand(0, 0x0fff) | 0x4000,
            mt_rand(0, 0x3fff) | 0x8000,
            mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff)
        );
    }
}
