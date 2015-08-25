#===============================================================================
#[[Information]]
# TITLE:	url-crawler.ps1
# LANGUAGE:	Windows PowerShell
# DESCRIPTION:	スクリプト内で指示するURLのウェブデータをダウンロードする
# AUTHOR:	muzina (https://github.com/muzina)
# VERSION:	2015/08/25
#
#[[Environment]]
# Windows7以降
#
#[[Methods]]
#1 $array内に取得したいサイトのURLリストを記入する。
#2 本ソースを全てWindowsのメモ帳などにコピーし保存。ファイル名を「url-crawler.ps1」とする。
#3 ファイルを右クリックし「PowerShellで実行」を選択すると、同ディレクトリにダウンロードを開始します。
#
#[[Disclaimer]]
#* 本スクリプトによって生じた如何なる不利益に対してもAUTHORの責任の範囲外とします
#* 本スクリプトの利用者は本スクリプトによって生じる影響を理解した上で実行をお願いします。
#* URLリストにはデフォルトで法令データベースの著作権法サイトのURLを記入しています。
#===============================================================================

###URLリスト
$array = @(`
"http://law.e-gov.go.jp/htmldata/S45/S45HO048.html",`
"http://law.e-gov.go.jp/htmldata//miseko/S45HO048/H26HO035.html",`
"http://law.e-gov.go.jp/htmldata//miseko/S45HO048/H26HO069.html",`
"http://law.e-gov.go.jp/htmldata//miseko/S45HO048/H27HO046.html"`
)

###詳細設定情報
$waittime=1 #1回ごとの遅延時間（秒）
$timeouttime=10 #タイムアウト時間（秒）
$useras="Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36" #UserAgent
$pading=4 #ファイル番号の桁数
$extension=".html" #拡張子(.をつけて)

###メインルーチン
$number=1
$arraycount=0
$allcount=$array.Length
while($number -le $allcount){
 cls
 Write-Output "Processing $number / $allcount`n"
 $filename=([string]$number).PadLeft($pading,"0")
 $filename=$filename+$extension
 iwr -Uri $array[$arraycount] -TimeoutSec $timeouttime -UserAgent $useras -OutFile ./$filename
 $number++
 $arraycount++
 Start-Sleep -s $waittime
}
Read-Host "完了するにはENTERキーを押して下さい" 
