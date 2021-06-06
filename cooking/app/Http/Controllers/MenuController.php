<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\Models\Image;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class MenuController extends Controller {

    public function foodstuffs(Request $request) {
        $database = DB::table('foodstuff')->get();
        return response()->json(['ncategory'=>count($database), 'stuffs'=>$database], 200);
    }

    public function uploadmenu(Request $request) {
        $database = DB::table('menu')->get();

        $id = 1;
        for($i=0; $i<count($database); ++$i) {
           if ($id <= $database[$i]->id) {
                $id = $database[$i]->id + 1;
           }
        }
        $params = array('id'=>$id);

        $stuffs = explode(',', $request->message, 17);

        $params['name'] = $stuffs[0];
        for ($i=1; $i<count($stuffs); ++$i) {
            $stuff = 'stuff' . $i;
            $params[$stuff] = $stuffs[$i];
        }

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
            $new_image_data = new Image();
            $new_image_data->user_id = $id;
            $new_image_data->file_name = $file_name;
            $new_image_data->save();

            $params['image_name'] = $file_name;
            DB::table('menu')->insert($params);
            return response()->json(['ok'=>'uploadmenu'], 200);
        } else {
            return response()->json(['error'=>'uploadmenu'], 401);
        }
    }

    public function searchmenu(Request $request) {
        $keys = explode(',', $request->keys);
        $menus = DB::table('menu')->get();

        $scores = array();
        foreach ($menus as $menu) {
            $hits = 0;
            for ($i=0; $i<count($keys); ++$i) {
                for ($j=0; $j<16; ++$j) {
                    $stuff = 'stuff' . ($j+1);
                    if ($menu->$stuff == NULL) break;
                    if ($keys[$i] == $menu->$stuff) {
                        ++$hits;
                        break;
                    }
                }
            }
            array_push($scores, [$menu->id, $hits]);
        }

        $highscore = 0;
        foreach ($scores as $score) {
            if ($score[1] > $highscore)
                $highscore = $score[1];
        }
        if ($highscore == 0) return response()->json(['hits'=>0], 200);

        $ids = array();
        for ($i=0; $i<count($scores); ++$i) {
            if ($scores[$i][1] == $highscore)
                array_push($ids, $i);
        }
        $result = array();
        $result['hits'] = count($ids); 

        for ($i=0; $i<count($ids); ++$i) {
            $menu = array();
            $menu['menu'] = $menus[$ids[$i]]->name;
            $menu['image'] = $menus[$ids[$i]]->image_name;
            $stuffs = array();
            for ($j=0; $j<16; ++$j) {
                $stuff = 'stuff' . ($j+1);
                if ($menus[$ids[$i]]->$stuff == NULL) break;
                array_push($stuffs, $menus[$ids[$i]]->$stuff);
            }
            $menu['stuff'] = $stuffs;
            array_push($result, $menu);
        }
        return response()->json($result, 200);
    }
}
