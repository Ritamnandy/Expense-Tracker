<?php

namespace App\Libraries;

use Exception;
use stdClass;

/**
 * Minimal HS256 JWT helper — no external library required.
 * Set JWT_SECRET in your .env file.
 */
class JwtHelper
{
    private static function secret(): string
    {
        $secret = env('JWT_SECRET', '');
        if (empty($secret)) {
            throw new Exception('JWT_SECRET is not configured.');
        }
        return $secret;
    }

    // ── Encoding ──────────────────────────────────────────────────────────

    public static function encode(array $payload, int $expiresInSeconds = 604800): string
    {
        $header = self::base64url(json_encode(['alg' => 'HS256', 'typ' => 'JWT']));

        $payload['iat'] = time();
        $payload['exp'] = time() + $expiresInSeconds;
        $body = self::base64url(json_encode($payload));

        $signature = self::base64url(
            hash_hmac('sha256', "{$header}.{$body}", self::secret(), true)
        );

        return "{$header}.{$body}.{$signature}";
    }

    // ── Decoding / Validation ─────────────────────────────────────────────

    public static function decode(string $token): stdClass
    {
        $parts = explode('.', $token);
        if (count($parts) !== 3) {
            throw new Exception('Invalid token structure.');
        }

        [$header, $body, $signature] = $parts;

        $expectedSig = self::base64url(
            hash_hmac('sha256', "{$header}.{$body}", self::secret(), true)
        );

        if (! hash_equals($expectedSig, $signature)) {
            throw new Exception('Token signature mismatch.');
        }

        $payload = json_decode(self::base64urlDecode($body));

        if (isset($payload->exp) && $payload->exp < time()) {
            throw new Exception('Token has expired.');
        }

        return $payload;
    }

    // ── Helpers ───────────────────────────────────────────────────────────

    private static function base64url(string $data): string
    {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }

    private static function base64urlDecode(string $data): string
    {
        return base64_decode(strtr($data, '-_', '+/'));
    }
}
