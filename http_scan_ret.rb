# -*- coding: utf-8 -*
# 特定の文字列をフックしてパケットベースで存在を確認
# 利用方法 $ruby http_scan_ret.rb <<file_name>>
# ファイルにマッチする条件がパケットに存在する場合は当該パケットの
# 以下の内容を出力
# 条件
# TCP の送信元ポート
# 出力内容
# 日時,ACK番号,送信元IP,発生理由
#

require 'pcap'

req = []
file_name = ARGV[0]

f = File::open(file_name)
f.each_line{|line|
  req << line.strip!
}

Dir.glob(File.join('*.pcap')) do |file|
  match_str = '<<keyword>>'
  pcaplet = Pcap::Capture.open_offline(file)
  fil_pcaplet = Pcap::Filter.new('80',pcaplet)
  pcaplet.setfilter(fil_pcaplet)
  pcaplet.each_packet { |pkt|
    if pkt.tcp_data_len > 0 then
      req.each do |d|
        if pkt.tcp_dport == d.split(',')[3].to_i
          if  pkt.tcp_data.include?(match_str)
            print pkt.time
	    print ","
	    print pkt.tcp_ack
	    ret = ","
	    ret << d.split(',')[3] << "," << pkt.ip_src.to_s
	    if pkt.tcp_data.include?(match_str)
 	      ret << ",Timeout Error"
            else
              ret << ",Unknown Error"
            end
	    puts ret
	  end
        end
      end
    end
  }
  pcaplet.close
end
