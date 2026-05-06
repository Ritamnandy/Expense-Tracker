<?php

namespace Config;

use CodeIgniter\Config\BaseConfig;

/**
 * Cross-Origin Resource Sharing (CORS) Configuration
 *
 * @see https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
 */
class Cors extends BaseConfig
{
    /**
     * The default CORS configuration.
     *
     * @var array{
     *      allowedOrigins: list<string>,
     *      allowedOriginsPatterns: list<string>,
     *      supportsCredentials: bool,
     *      allowedHeaders: list<string>,
     *      exposedHeaders: list<string>,
     *      allowedMethods: list<string>,
     *      maxAge: int,
     *  }
     */
    public array $default = [
        /**
         * Allowed origins.
         * '*' permits any origin — correct for a mobile app REST API.
         * In production, restrict to your specific domain(s):
         *   e.g. ['https://yourdomain.com']
         *
         * NOTE: Cannot be '*' when supportsCredentials is true.
         */
        'allowedOrigins' => ['*'],

        /**
         * Origin regex patterns (not needed when allowedOrigins is '*').
         */
        'allowedOriginsPatterns' => [],

        /**
         * Whether to send the Access-Control-Allow-Credentials header.
         * Must be false when allowedOrigins is '*'.
         * JWT is passed in Authorization header, so cookies/credentials are not needed.
         */
        'supportsCredentials' => false,

        /**
         * Headers the client is allowed to send.
         *  - Authorization : Required for JWT Bearer tokens
         *  - Content-Type  : Required for JSON POST/PUT request bodies
         *  - Accept        : Polite hint to server about expected response format
         */
        'allowedHeaders' => ['Authorization', 'Content-Type', 'Accept', 'X-Requested-With'],

        /**
         * Response headers exposed to the client JavaScript / HTTP client.
         */
        'exposedHeaders' => [],

        /**
         * Allowed HTTP methods.
         * OPTIONS must be included for preflight requests to succeed.
         */
        'allowedMethods' => ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],

        /**
         * How long (in seconds) the browser may cache a preflight response.
         * 7200 = 2 hours.
         */
        'maxAge' => 7200,
    ];
}
