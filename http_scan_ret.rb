# -*- coding: utf-8 -*
# ����̕�������t�b�N���ăp�P�b�g�x�[�X�ő��݂��m�F
# ���p���@ $ruby http_scan_ret.rb <<file_name>>
# �t�@�C���Ƀ}�b�`����������p�P�b�g�ɑ��݂���ꍇ�͓��Y�p�P�b�g��
# �ȉ��̓��e���o��
# ����
# TCP �̑��M���|�[�g
# �o�͓��e
# ����,ACK�ԍ�,���M��IP,�������R
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
