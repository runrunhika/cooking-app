#!/bin/bash

# URL=http://cooking.upbrightinc.com/uploadmenu_
URL=http://cooking.gohannozikan.xyz/uploadmenu_

curl -F "message=牛丼,牛肉,玉ねぎ,紅生姜" -F "file=@beafbowl.png" $URL
curl -F "message=カレー,牛肉,豚肉,鶏肉,じゃがいも,人参,玉ねぎ,カレールー" -F "file=@curry.png" $URL
curl -F "message=カツ丼,豚肉,玉ねぎ,小麦粉,卵,パン粉" -F "file=@katsudon.png" $URL
curl -F "message=親子丼,鶏肉,玉ねぎ,卵" -F "file=@oyakodon.png" $URL
curl -F "message=ペペロンチーノ,ニンニク,唐辛子,スパゲッティ" -F "file=@pasta.png" $URL
curl -F "message=ポトフ,ウィンナソーセージ,キャベツ,人参,ピーマン" -F "file=@soup.png" $URL
curl -F "message=野菜炒め,豚肉,キャベツ,ピーマン,人参" -F "file=@yasaiitame.png" $URL
curl -F "message=チキンライス,鶏肉,玉ねぎ,ピーマン,人参,ケチャップ" -F "file=@chickenraice.png" $URL

