<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */

// ─── API v1 ──────────────────────────────────────────────────────────────────
// All API routes have the CORS filter applied so Android / any HTTP client can
// communicate with this server without origin restrictions.
$routes->group('api/v1', ['namespace' => 'App\Controllers\Api', 'filter' => 'cors'], function ($routes) {

    // ── Auth (public) ──────────────────────────────────────────────────────
    $routes->post('auth/register', 'AuthController::register');
    $routes->post('auth/login',    'AuthController::login');
    $routes->get('auth/me',        'AuthController::me',        ['filter' => 'jwt']);

    // ── Sync (requires JWT) ────────────────────────────────────────────────
    $routes->post('sync', 'SyncController::sync', ['filter' => 'jwt']);

    // ── Accounts (requires JWT) ────────────────────────────────────────────
    $routes->group('accounts', ['filter' => 'jwt'], function ($routes) {
        $routes->get('',              'AccountController::index');
        $routes->post('',             'AccountController::create');
        $routes->get('(:uuidv4)',     'AccountController::show/$1');
        $routes->put('(:uuidv4)',     'AccountController::update/$1');
        $routes->delete('(:uuidv4)', 'AccountController::delete/$1');
    });

    // ── Categories (requires JWT) ──────────────────────────────────────────
    $routes->group('categories', ['filter' => 'jwt'], function ($routes) {
        $routes->get('',              'CategoryController::index');
        $routes->post('',             'CategoryController::create');
        $routes->get('(:uuidv4)',     'CategoryController::show/$1');    // Added missing show route
        $routes->put('(:uuidv4)',     'CategoryController::update/$1');
        $routes->delete('(:uuidv4)', 'CategoryController::delete/$1');
    });

    // ── Transactions (requires JWT) ────────────────────────────────────────
    $routes->group('transactions', ['filter' => 'jwt'], function ($routes) {
        $routes->get('',              'TransactionController::index');
        $routes->post('',             'TransactionController::create');
        $routes->get('(:uuidv4)',     'TransactionController::show/$1');
        $routes->put('(:uuidv4)',     'TransactionController::update/$1');
        $routes->delete('(:uuidv4)', 'TransactionController::delete/$1');
    });
});
