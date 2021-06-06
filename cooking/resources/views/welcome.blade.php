<!DOCTYPE html>
<!-- <html lang="{{ str_replace('_', '-', app()->getLocale()) }}"> -->
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>BanhmiByMe</title>
    </head>

    <body class="antialiased">
        <div align="center">
            @if (Route::has('login'))
                <div class="hidden fixed top-0 right-0 px-6 py-4 sm:block">
                    @auth
                        <a href="{{ url('/menu') }}" class="text-sm text-gray-700 underline">メニュー編集</a>
                        <br><br>
                        <a href="{{ url('/sales') }}" class="text-sm text-gray-700 underline">売上状況</a>
                    @else
                        <a href="{{ route('login') }}" class="text-sm text-gray-700 underline">ログイン</a>

                        @if (Route::has('register'))
                            <a href="{{ route('register') }}" class="ml-4 text-sm text-gray-700 underline">登録</a>
                        @endif
                    @endif
                </div>
            @endif
        </div>
    </body>
</html>
