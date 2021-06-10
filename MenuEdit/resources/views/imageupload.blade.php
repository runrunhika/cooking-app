@extends('layouts.app')

@section('title', 'メニュー画像')

@section('sidebar')
    @parent

    <div align="center">
        <p>メニュー画像のアップロード</p>
    </div>
@endsection

@section('content')
    <div align="center">
    <form action="saveimage" method="POST" enctype="multipart/form-data">
        @csrf
    
        <input type="file" class="form-control" name="file">
        <br><br>
        <input type="submit">
    </form>
    </div>
@endsection
