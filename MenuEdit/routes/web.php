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

Route::get('/', function () { return view('welcome'); });
Route::get('/home', function () { return view('welcome'); });

Auth::routes();

Route::get('/menu', 'App\Http\Controllers\EditMenuController@menu');
Route::get('/addmenu', 'App\Http\Controllers\EditMenuController@addmenu');
Route::get('/deletemenu', 'App\Http\Controllers\EditMenuController@deletemenu');
Route::get('/addmenustuff', 'App\Http\Controllers\EditMenuController@addmenustuff');
Route::get('/deletemenustuff', 'App\Http\Controllers\EditMenuController@deletemenustuff');
Route::post('/updatemenu', 'App\Http\Controllers\EditMenuController@updatemenu');

Route::get('/foodstuff', 'App\Http\Controllers\EditMenuController@foodstuff');
Route::get('/addstuff', 'App\Http\Controllers\EditMenuController@addstuff');
Route::get('/deletestuff', 'App\Http\Controllers\EditMenuController@deletestuff');
Route::post('/updatestuff', 'App\Http\Controllers\EditMenuController@updatestuff');

Route::get('/uploadimage', 'App\Http\Controllers\ImageController@uploadimage');
Route::post('/saveimage', 'App\Http\Controllers\ImageController@saveimage');

