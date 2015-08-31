#===============================================================================
#[[Information]]
# TITLE:	ie-crawler.ps1
# LANGUAGE:	Windows PowerShell
# DESCRIPTION:	スクリプト内で指示するURLのウェブデータを、IEの「名前を付けて保存」機能でダウンロードする
# AUTHOR:	muzina (https://github.com/muzina)
# VERSION:	2015/08/31
#
#[[Environment]]
# Windows7以降
#
#[[Methods]]
#1 ファイルの保存場所としてC:\TMP\TFを作成する。
#2 $array内に取得したいサイトのURLリストを記入する。
#3 本ソースを全てWindowsのメモ帳などにコピーし保存。ファイル名を「IE-crawler.ps1」とする。
#4 ファイルを右クリックし「PowerShellで実行」を選択すると、同ディレクトリにダウンロードを開始します。
#
#[[Disclaimer]]
#* 本スクリプトによって生じた如何なる不利益に対してもAUTHORの責任の範囲外とします
#* 本スクリプトの利用者は本スクリプトによって生じる影響を理解した上で実行をお願いします。
#* URLリストにはデフォルトで法令データベースの著作権法サイトのURLを記入しています。
#
#[[Reference]]
#* TechNet Blogs > フィールドSEあがりの安納です > 【PowerShell】WEB ページをアーカイブする
#  http://blogs.technet.com/b/junichia/archive/2012/01/31/3477951.aspx
#* Microsoft Developer Network > Windows Script Host > リファレンス > SendKeys メソッド
#  https://msdn.microsoft.com/ja-jp/library/cc364423.aspx
#
#[[Attention]]
#* もし途中で止まってしまったら、タスクマネージャを開いて一番メモリを消費しているＩＥのタスクを停止させると復旧する
#* スクリプト終了時も、タスクマネージャにＩＥのタスクが残ってしまっている場合があるため停止させた方が良い
#* 上記2件はStop-processで解消したかも
#* IEにおける保存方式（mhtなど）を変更したい場合は、「#下矢印」の行数を変更してください
#===============================================================================

###URLリスト
$array = @(`
"http://law.e-gov.go.jp/htmldata/S45/S45HO048.html",`
"http://law.e-gov.go.jp/htmldata//miseko/S45HO048/H26HO035.html",`
"http://law.e-gov.go.jp/htmldata//miseko/S45HO048/H26HO069.html",`
"http://law.e-gov.go.jp/htmldata//miseko/S45HO048/H27HO046.html"`
)

###変数設定
$counter=0
$number=$counter+1
$allcount=$array.Length

###ルーチン開始領域
while ($number -le $allcount){
cls
Write-Output "Processing $number / $allcount`n"
$url = $array[$counter]

###送信コード
$code = '$WShell = New-Object -comobject WScript.Shell; ' 
$code = $code + '$WShell.AppActivate(''Web ページの保存'', $true); ' 
$code = $code + '$WShell.SendKeys(''%N'') ; ' #ファイル名フォーム選択（alt N）
$code = $code + '$WShell.SendKeys('
$code = $code + $number
$code = $code + '); ' #ファイル名番号を入力する
$code = $code + '$WShell.SendKeys(''{HOME}'') ; ' #カーソルを一番左に寄せる
$code = $code + '$WShell.SendKeys(''C:\TMP\TF\'') ; ' #予めC:\TMP\TFを作成しておく
$code = $code + '$WShell.SendKeys(''%T'') ; ' #ファイルの種類フォーム選択（alt T）
$code = $code + '$WShell.SendKeys(''{DOWN}'') ; ' #下矢印
$code = $code + '$WShell.SendKeys(''{DOWN}'') ; ' #下矢印
$code = $code + '$WShell.SendKeys(''{DOWN}'') ; ' #下矢印
$code = $code + '$WShell.SendKeys(''{DOWN}'') ; ' #下矢印
$code = $code + '$WShell.SendKeys(''{ENTER}'') ; ' 
$code = $code + '$WShell.SendKeys(''%S'')' #保存ボタン

###ルーチン終了領域
$ie = New-Object -ComObject InternetExplorer.Application 
$ie.Navigate( $url ) 
while ($ie.ReadyState -ne 4) { Start-Sleep -Milliseconds 100} 
Start-Process powershell.exe -argument ('-version 2.0 -noprofile -windowstyle hidden -command "{0}"' -f $code) 
$ie.ExecWB(4,0,$null,[ref]$null)
Stop-process -name "iexplore" #毎回プロセスを切る
$counter++
$number++
}
Read-Host "完了するにはENTERキーを押して下さい" 
