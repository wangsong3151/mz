How to install
==============

1 - Import cacti_host_template_varnish.xml to Cacti (tested with 0.8.8a)
2 - Copy getVarnishStats.sh to "scripts"
3 - Configure snmpd.conf into the varnish server
	3.1 - Add this line to snmpd.conf
			extend varnishstats "/etc/snmp/varnish_stats.sh"
	3.2 - Copy varnish_stats.sh to "/etc/snmp"

###############################################################################
IMPORTANT: You need to recompile spine with "./configure --with-results-buffer=2048"
###############################################################################

NOTE: Changing "getVarnishStats.sh" you can change your poll method.

��ΰ�װ
==============

1 - ���� cacti_host_template_varnish.xml ģ�嵽 Cacti (tested with 0.8.8a)
2 - ���� getVarnishStats.sh �� Cacti�� "scripts" Ŀ¼��
3 - ���� snmpd.conf ��֧��Varnish
	3.1 - �� snmpd.conf β�����һ������
			extend varnishstats "/etc/snmp/varnish_stats.sh"
	3.2 - ���� varnish_stats.sh �� "/etc/snmp"

###############################################################################
ע��: ��varnish����snmp���ݳ��ȹ�����Ҫ���±��� spine �����ϻ����С����
���磺 "./configure --with-results-buffer=2048"
###############################################################################

˵��: ���� "getVarnishStats.sh" �еĲ�������ѡ��SNMP�汾,SNMP V3��Ҫ�ڽű���ָ���û���������