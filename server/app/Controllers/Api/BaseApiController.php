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

    /**
     * Generate a cryptographically secure UUID v4.
     * Uses random_bytes() instead of mt_rand() for unpredictability.
     */
    protected function uuid(): string
    {
        $data    = random_bytes(16);
        $data[6] = chr(ord($data[6]) & 0x0f | 0x40); // version 4
        $data[8] = chr(ord($data[8]) & 0x3f | 0x80); // variant RFC 4122
        return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($data), 4));
    }
}
