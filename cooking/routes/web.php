<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/register_', 'App\Http\Controllers\AuthController@register');
Route::get('/login_', 'App\Http\Controllers\AuthController@login');
Route::get('/logout_', 'App\Http\Controllers\AuthController@logout');

Route::get('/foodstuffs_', 'App\Http\Controllers\MenuController@foodstuffs');
Route::post('/uploadmenu_', 'App\Http\Controllers\MenuController@uploadmenu');
Route::get('/searchmenu_', 'App\Http\Controllers\MenuController@searchmenu');

