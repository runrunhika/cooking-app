<html>
    <head>
        <title>Cooking - @yield('title')</title>
    </head>
    <body>
        @section('sidebar')
<!--            ここがメインのサイドバー -->
        @show

        <div class="container">
            @yield('content')
        </div>
    </body>
</html>
