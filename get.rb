def full_to_half(str)
	str = str.gsub(/[‐－―ー]/, '-')
	str.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
end

#URLにアクセスする為のライブラリを読込
require 'open-uri'
#Nokogiriライブラリを読込
require 'nokogiri'

#切り出すURLを指定
url = 'http://hirose.sendai-nct.ac.jp/kyuko/kyuko.cgi'

charset = nil
html = open(url) do |f|
	charset = "CP932"
	f.read #htmlを読み込み変数htmlに引渡
end

#htmlを解析&オブジェクト化
doc = Nokogiri::HTML.parse(html, nil, charset)

#クラス・学科
room_array = ['1-1', '1-2', '1-3', 'IE2', 'IS2', 'IN2', 'IE3', 'IS3', 'IN3', 'IE4', 'IS4', 'IN4', 'IE5', 'IS5', 'IN5', '専1', '専2']
list = []
#テーブル毎にデータ読込
doc.xpath('.//table[@width="650"]').each do |info|
	data = []

	#日付,曜日
	date = info.xpath('.//tr[1]/td[1]/b[1]').text
	#クラス
	room = full_to_half(info.xpath('.//tr[1]/td[1]/font/b[1]').text)
	#時間
	time = info.xpath('.//tr[1]/td[1]/font/b[2]').text
	#先生
	name = info.xpath('.//tr[1]/td[@align="right"]/font').text.gsub(/(\s)/,"").gsub(/　/,"")
	#変更/休講
	if info.xpath('.//img').attribute('src').value == "./img/henko.gif"
		kind = "変更"
	else
		kind = "休講"
	end
	#詳細
	item = info.xpath('.//tr[2]/td/table[@width="100%"]').text.gsub(/(\n)/,"")

	#dataに格納
	data.push(date)
	data.push(room)
	data.push(time)
	data.push(kind)
	data.push(name)
	data.push(item)

	#listにdataを格納
	list.push(data)
end

#出力
room_array.each do |room|
	puts room + ": "
	list.each { |arr|
		if arr[1] == room
			p arr
		end
	}
end
