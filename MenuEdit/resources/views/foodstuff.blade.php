@extends('layouts.app')

@section('title', 'Foodstuff')

@section('sidebar')
    @parent

    <div align="center">
        <p>食材の編集</p>
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

        function addFoodstuff(id) {
            location.href = "addstuff?id="+id;
        }

        function deleteFoodstuff(param) {
            if (window.confirm("削除していいですか?")) { 
                location.href = "deletestuff?"+param;
            }
        }
    </script>


    <form action="updatestuff" method="post">
        @csrf

    @foreach ($foodstuffs as $foodstuff)
        <p>
            {{$foodstuff->category}}
            <?php $ok = ($foodstuff->stuff32 == NULL) ? 1 : 0; ?>
            @if ($ok == 1)
                <input type="button" value="食材の追加" onClick="addFoodstuff({{$foodstuff->id}})">
            @endif
            <input type="submit" value="送信" >
        </p>


        @for ($i = 1; $i <= 32; $i++)
            <?php $stuff = 'stuff'.$i; ?>
            @if ($foodstuff->$stuff == NULL)
                @break
            @endif

            <input type="button" value="x" onClick="deleteFoodstuff('id={{$foodstuff->id}}&column={{$i}}')">
            <textarea name="{{$foodstuff->id}}.{{$stuff}}" rows="1" cols="8">{{$foodstuff->$stuff}}</textarea>
            @if ($i % 8 == 0)
                <br>
            @endif
        @endfor
    @endforeach
    </form>

@endsection
