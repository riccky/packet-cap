# -*- coding: utf-8 -*
# 特定の文字列をフックしてパケットベースで存在を確認
# 利用方法 $ruby http_scan.rb <<file_name>>
# ファイルにマッチする文字列がパケットに存在する場合は当該パケットの
# 以下の内容を出力
# 日時,期待されるACK番号（TCPシーケンス番号＋TCP Len）,送信元ポート,送信先IP
#

require 'pcap'

match_str = []
file_name = ARGV[0]

f = File::open(file_name)
f.each_line{|line|
  match_str << line.strip!
}

Dir.glob(File.join('*.pcap')) do |file|
  pcaplet = Pcap::Capture.open_offline(file)
  fil_pcaplet = Pcap::Filter.new('tcp and dst port 80',pcaplet)
  pcaplet.setfilter(fil_pcaplet)
  pcaplet.each_packet { |pkt|
    if pkt.tcp_data_len > 0 then
      match_str.each do |m|
        if pkt.tcp_data.include?(m)
	  expected_ack = pkt.tcp_seq + pkt.tcp_data_len
          print pkt.time
	  print ","
	  print expected_ack
   	  ret = ","
	  ret << m << "," << pkt.tcp_sport.to_s << "," << pkt.ip_dst.to_s
          puts ret
	end
      end
    end
  }
  pcaplet.close
end
