<!DOCTYPE html>
<!-- <html lang="{{ str_replace('_', '-', app()->getLocale()) }}"> -->
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Cooking</title>
    </head>

    <body class="antialiased">

        <div align="center">
            <p>食材・メニュー編集</p>
            @if (Route::has('login'))
                <div class="hidden fixed top-0 right-0 px-6 py-4 sm:block">
                    @auth
                        <a href="{{ url('/foodstuff') }}" class="text-sm text-gray-700 underline">食材</a>
                        <br><br>
                        <a href="{{ url('/menu') }}" class="text-sm text-gray-700 underline">メニュー</a>
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
