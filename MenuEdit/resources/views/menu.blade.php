@extends('layouts.app')

@section('title', 'Menu')

@section('sidebar')
    @parent

    <div align="center">
        <p>メニューの編集</p>
    </div>
    <div align="right">
        <input type="button" value="ホームへ戻る" onClick="goBack()">
    </div>

@endsection

@section('content')
    <script>
        function goBack() {
            location.href = "/home";
        }

        function uploadimage(id) {
            location.href = "uploadimage?id="+id;
        }

        function deleteMenu(id) {
            if (window.confirm("削除していいですか?")) { 
                location.href = "deletemenu?id="+id;
            }
        }

        function addmenu() {
            location.href = "addmenu";
        }

        function addMenuStuff(id) {
            location.href = "addmenustuff?id="+id;
        }

        function deleteMenuStuff(param) {
            if (window.confirm("削除していいですか?")) { 
                location.href = "deletemenustuff?"+param;;
            }
        }
    </script>


    <form action="updatemenu" method="post">
        @csrf


    <p>
        <input type="button" value="メニューの追加" onClick="addmenu()">
    </p>
    @foreach ($menus as $menu)
        <textarea name="{{$menu->id}}" rows="1" cols="8 font="5"">{{$menu->name}}</textarea>
        <input type="submit" value="送信" >
        <br>
        <input type="button" value="このメニューを削除" onClick="deleteMenu({{$menu->id}})">
        <br>
        <img name={{"image".$menu->id}} src={{"storage/".$menu->image_name}} width="128" alt="">
        <br>
        <input type="button" value="画像アップロード" onClick="uploadimage({{$menu->id}})">

        <br>
        <?php $ok = ($menu->stuff16 == NULL) ? 1 : 0; ?>
        @if ($ok == 1)
            <br>
            <input type="button" value="食材の追加" onClick="addMenuStuff({{$menu->id}})">
        @endif
        <input type="submit" value="送信" >
        <br>

        @for ($i = 1; $i <= 16; $i++)
            <?php $stuff = 'stuff'.$i; ?>
            @if ($menu->$stuff == NULL)
                @break
            @endif

            <input type="button" value="x" onClick="deleteMenuStuff('id={{$menu->id}}&column={{$i}}')">
            {{ Form::select($menu->id . '_' .  $stuff, [null=>'選択してください']+$stuffarray, $menu->$stuff, ['class' => 'form-control']) }}

            @if ($i % 4 == 0)
                <br>
            @endif
        @endfor
        <br><br>
    @endforeach

    </form>


@endsection
