<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\Models\Image;
use Illuminate\Support\Facades\DB;

class ImageController extends Controller {

    public function input() {
        return view('image.input');
    }

    public function uploadimage(Request $request) {
        $id = $request->all()['id'];
        $request->session()->put('record', $id);
        return view('imageupload');
    }

    public function saveimage(Request $request) {
        $this->validate($request, [
            'file' => [
                // 必須
                'required',
                // アップロードされたファイルであること
                'file',
                // 画像ファイルであること
                'image',
                // MIMEタイプを指定
                'mimes:jpeg,png',
            ]
        ]);


        if ($request->file('file')->isValid([])) {
            $path = $request->file->store('public');

            $file_name = basename($path);
            $user_id = Auth::id();
            $new_image_data = new Image();
            $new_image_data->user_id = $user_id;
            $new_image_data->file_name = $file_name;

            $new_image_data->save();
            $id = $request->session()->get('record', '0');
            DB::table('menu')
                ->where('id', $id)
                ->update([
                    'image_name' => $file_name
            ]);

            $foodstuffs = DB::table('foodstuff')->get();
            $stuffarray = array();
            foreach($foodstuffs as $stuff) {
                $array = array();
                for($i=1; $i<=32; ++$i) {
                    $column = "stuff".$i;
                    if($stuff->$column == NULL) break;
                    $array += array($stuff->$column => $stuff->$column);
                }
                $stuffarray += array($stuff->category => $array);
            }
            $menus = DB::table('menu')->orderBy('id', 'desc')->get();
            return view('menu', compact('menus', 'stuffarray'));
        } else {
            return redirect()
                ->back()
                ->withInput()
                ->withErrors();
        }
    }

    public function output() {
        $user_id = Auth::id();
        $user_images = Image::whereUser_id($user_id)->get();
        return view('image.output', ['user_images' => $user_images]);
    }
}
