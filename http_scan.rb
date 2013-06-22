# -*- coding: utf-8 -*
# ����̕�������t�b�N���ăp�P�b�g�x�[�X�ő��݂��m�F
# ���p���@ $ruby http_scan.rb <<file_name>>
# �t�@�C���Ƀ}�b�`���镶���񂪃p�P�b�g�ɑ��݂���ꍇ�͓��Y�p�P�b�g��
# �ȉ��̓��e���o��
# ����,���҂����ACK�ԍ��iTCP�V�[�P���X�ԍ��{TCP Len�j,���M���|�[�g,���M��IP
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
