<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class AuthController extends Controller {

	public function register(Request $request) {
        $database = DB::table('users')->get();
        $email = $request->email;
        $inuse = 0;
        for($i=0; $i<count($database); ++$i) {
            if($database[$i]->email == $email) {
                $inuse = 1;
            }
        }
        if($inuse == 1) {
            return response()->json(['error'=>'Already in use', 'id'=>-1], 401);
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => bcrypt($request->password),
        ]);

        $token = auth()->login($user);
        return response()->json(['ok'=>'Logged in', 'id'=>auth()->id()], 200);
    }

    public function login(Request $request) {
        $credentials = $request->only(['email', 'password']);

        if ($token = auth()->attempt($credentials)) {
            return response()->json(['ok'=>'Logged in', 'id'=>auth()->id()], 200);
        } else {
            return response()->json(['error'=>'Unauthorized', 'id'=>-1], 401);
        }
    }
}
