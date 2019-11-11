### 「プログラミング言語の基礎概念」の自動導出システムをOCamlによって自作するリポジトリ

### 自作を決意した経緯

- 書籍、プログラミング言語の基礎概論の演習問題を解くにあたり、中盤移行の導出フローに手書き導出による困難を感じたため。
  - スニペットでは単純に実装が追いつかない

- 参考献立:
  - 「プログラミング in OCaml」
  - 「コンパイラ 作りながら学ぶ」
  - 「Goで作るインタプリタ」
  - 「プログラミングの基礎」

導出までのおおまかなプロセス
---

自動導出を実装するための資料として、コンパイラ本を参考にしている。
 (参考: 「コンパイラ 作りながら学ぶ」)

|プロセス1|プロセス2|プロセス3|プロセス4|プロセス5|プロセス6|プロセス7|
|:---|:---:|:---:|:---:|:---:|:---:|---:|
|文字列読み込み|字句解析|構文解析|中間語作成|最適化|コード生成|目的プログラム|

上記のプロセスを参考にして、解答の自動導出までのフローを以下のようにした。

|プロセス1|プロセス2|プロセス3|プロセス4|プロセス5|
|:---|:---:|:---:|:---:|:---:|
|文字列読み込み|字句解析|構文解析|定義導出|導出出力|

字句解析編(トークン解析実装編)
---

(ペアノ自然数参考: 「プログラミング言語の基礎概念」)

- 文字列の読み込み

文字列を空白文字区切りでリストの作成をして、トークン解析する。この段階でペアノ自然数トークン・計算トークンの2つに切り分ける。この段階で、字句解析を呼び出す際の引数として、ペアノ自然数と、計算トークンとに分けたリストトークンを中間言語として、字句解析に投げ込む準備が整う

- ペアノ自然数トークンの字句解析

ペアノ自然数として呼び込まれた文字列が、確かにペアノ自然数として成立しているかの判別を行う。解析段階で成立していないと判断される場合、適当に作成したエラーを出力して、文字列の入力修正を促す。

- 計算トークンの字句解析

予め計算トークンのテーブルを作成しておく。実装は簡単となっており、いずれかの計算トークンと文字列が一致するかの比較を再帰関数として呼び込むことで実装した。

中間語作成
---

ここでポイントとなるのは、ペアノ自然数はそれ自身が自然数であり定義が定められている為、四則演算を用いることなく、ペアノ自然数導出の定義に則って推論システムを実装することが望ましいことになる。(各定義参照:「プログラミング言語の基礎概念」)
