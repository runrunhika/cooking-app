<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\Models\Image;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class EditMenuController extends Controller {

    public function menu() {
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
    }

    public function addmenu(Request $request) {
        $menus = DB::table('menu')->get();
        $id = 0;
        for($i=0; $i<count($menus); ++$i) {
            if($menus[$i]->id > $id) {
                $id = $menus[$i]->id;
            }
        }
        $id += 1;

        $newdata = ['id' => $id, 'name' => '料理名', 'image_name' => 'question.jpg'];
        DB::table('menu')
            ->insert($newdata);
        return $this->menu();
    }

    public function deletemenu(Request $request) {
        $id = $request->all()['id'];
        DB::table('menu')
            ->where('id', $id)
            ->delete();
        return $this->menu();
    }

    public function updatemenu(Request $request) {
        $data1 = $request->all();

        $menus = DB::table('menu')->get();
        for($i=0; $i<count($menus); ++$i) {
            $id = $menus[$i]->id;
            $name = $data1[$id];
            DB::table('menu')
                ->where('id', $id)
                ->update(['name' => $name]);

            $stuffs = array();
            for($s=1; $s<=16; ++$s) {
                $key = 'stuff' . $s;
                if(!array_key_exists($id . '_' . $key, $data1)) break;
                $stuffs += array($key => $data1[$id . '_' . $key]);
            }
            if(count($stuffs) != 0) {
                DB::table('menu')
                    ->where('id', $id)
                    ->update($stuffs);
            }
        }
        return $this->menu();
    }

    public function addmenustuff(Request $request) {
        $id = $request->all()['id'];
        $menu = DB::table('menu')->find($id);

        $i = 1;
        for(; $i<=16; ++$i) {
            $column = "stuff".$i;
            if($menu->$column == NULL) break;
        }
        $column = "stuff".$i;
        DB::table('menu')
            ->where('id', $id)
            ->update([
                $column => " "
        ]);
        return $this->menu();
    }

    public function deletemenustuff(Request $request) {
        $id = $request->all()['id'];
        $column = $request->all()['column'];

        $db = DB::table('menu')->find($id);
        $stuffs = array();
        for($s=$column; $s<16; ++$s) {
            $key = 'stuff' . $s;
            $key2 = 'stuff' . ($s+1);
            $stuffs += array($key => $db->$key2);
        }
        $stuffs += array("stuff16" => NULL);

        DB::table('menu')
            ->where('id', $id)
            ->update($stuffs);

        return $this->menu();
    }

    public function foodstuff() {
        $foodstuffs = DB::table('foodstuff')->get();
        return view('foodstuff', compact('foodstuffs'));
    }

    public function addstuff(Request $request) {
        $id = $request->all()['id'];
        $stuff = DB::table('foodstuff')->find($id);

        $i = 1;
        for(; $i<=32; ++$i) {
            $column = "stuff".$i;
            if($stuff->$column == NULL) break;
        }
        $column = "stuff".$i;
        DB::table('foodstuff')
            ->where('id', $id)
            ->update([
                $column => " "
        ]);
        
        return $this->foodstuff();
    }

    public function deletestuff(Request $request) {
        $id = $request->all()['id'];
        $column = $request->all()['column'];

        $db = DB::table('foodstuff')->find($id);
        $stuffs = array();
        for($s=$column; $s<32; ++$s) {
            $key = 'stuff' . $s;
            $key2 = 'stuff' . ($s+1);
            $stuffs += array($key => $db->$key2);
        }
        $stuffs += array("stuff32" => NULL);

        DB::table('foodstuff')
            ->where('id', $id)
            ->update($stuffs);

        return $this->foodstuff();
    }

    public function updatestuff(Request $request) {
        $data1 = $request->all();

        $foodstuffs = DB::table('foodstuff')->get();
        for($i=0; $i<count($foodstuffs); ++$i) {
            $id = $foodstuffs[$i]->id;
            $stuffs = array();
            for($s=1; $s<=32; ++$s) {
                $key = 'stuff' . $s;
                if(!array_key_exists($id . '_' . $key, $data1)) break;
                $stuffs += array($key => $data1[$id . '_' . $key]);
            }
            if(count($stuffs) != 0) {
                DB::table('foodstuff')
                    ->where('id', $id)
                    ->update($stuffs);
            }
        }
        return $this->foodstuff();
    }
}
