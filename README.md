# visualWhiteSpace
WhiteSpaceの再実装

ビルドするとき
```
stack build
```

Hello worldの実行
```
stack exec -- ws-exe ./example/hworld.ws
```

コードをTとSで表示する
```
stack exec -- ws-exe ./example/hworld.ws -show
```

TとSで書いたコードを実行する
```
stack exec -- ws-exe ./test.wss -simple
```

TとSで書いたコードをtabとspeaceに変換して出力する
```
stack exec -- ws-exe ./test.wss -simple-show
```

WhiteSpaceで書いたコードの命令を出力する
```
stack exec -- ws-exe ./examples/hworld.ws -vis
```

実行時のスタックなどの情報を出力する
```
stack exec -- ws-exe ./examples/hworld.ws -trace
```
