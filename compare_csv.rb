# リクエストの抽出結果、レスポンスの抽出結果をマージして
# 以下の内容を出力
# ユーザ,送信時間,レスポンス時間,発生理由
#

time_user_port = []
req = File::open('request.csv')
req.each_line{|line|
  time_user_port << line.strip!
}

time_port = []
res = File::open('response.csv')
res.each_line{|line|
  time_user_port << line.strip!
}

result = []

puts "===== Response Times ====="
puts "USERNAME, ResuestTime, ResponseTime, Reason"
time_user_port.each do |u|
  time_port.each do |p|
    if u.split(',')[3] == p.split(',')[2]
      if u.split(',')[0] <= p.split(',')[0]
	if u.split(',')[4] == p.split(',')[3]
	  if (u.split(',')[1] == p.split(',')[1] || (u.split(',')[1].to_i + 1).to_s == p.split(',')[1])
	    ret = u.split(',')[2]
	    ret << "," << u.split(',')[0]
	    ret << "," << p.split(',')[0]
	    ret << "," << p.split(',')[4]
	    result << ret
	  end
	end
      end
    end
  end
end

puts result.uniq
