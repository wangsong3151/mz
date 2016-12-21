#�������������������apache��mysql
#��װrsyslog
yum install rsyslog
#��װrsyslog��mysqlģ�飬ʹ֮���Խ���־д��mysql
yum install rsyslog-mysql

#�޸�rsyslog�������ļ�
vi /etc/rsyslog.conf

#һ�����е�ע��ȥ������rsyslog������UDP514�˿ڣ��ͻ��˻Ὣ�Լ�����־���͵�����˵�UDP514�˿�
$ModLoad imudp
$UDPServerRun 514

$ModLoad ommysql.so   #�¼Ӵ��У�rsyslog����mysqlģ��
*.* :ommysql:localhost,Syslog,rsyslog,123456  #�¼Ӵ��У�rsyslogʹ���û�rsyslog,��������־д��mysql��Syslog���У�123456���û�rsyslog������

#����rsyslog��Ҫ�����ݿ�
cd /usr/share/doc/rsyslog-mysql-5.8.10/
mysql -u root -p < createDB.sql  #�ò����ᴴ��Syslog�⣬���к����ű����е�SystemEvents����loganalyzerҪ��ȡ�ı�


#��¼mysql����������Ȩrsyslog�û����Զ�дSyslog��
grant all privileges on Syslog.* to rsyslog@'localhost' identified by '123456';

flush privileges;

#����rsyslog

service rsyslog restart #�����Ļ���ʱSystemEvents����Ӧ���Ѿ���д�����ݣ���Ϊrsyslog�Ѿ���ʼ����־�洢��mysql

#���ϲ���ʹ��rsyslog��ϵͳ��־д��mysql����������װloganalyzer,�����ǽ���־��mysql������������web��ʽչʾ

#����loganalyzer

wget http://download.adiscon.com/loganalyzer/loganalyzer-3.6.3.tar.gz

#��apache���Է��ʵ���λ�ô���Ŀ¼���������loganalyzer�ĳ���
mkdir /data/www/loganalyzer

tar zxvf loganalyzer-3.6.3.tar.gz
cd loganalyzer-3.6.3

#����װ�ļ����Ƶ�������loganalyzerĿ¼

cp -a src/* /data/www/loganalyzer/
cp -a contrib/* /data/www/loganalyzer/

cd /data/www/loganalyzer

sh configure.sh #����config.php�ļ���������д��Ȩ��

http://ip/loganalyzer  #����web��װ����

��װ��ɺ�ִ��secure.sh,��config.phpȨ���޸�Ϊ644��


#��ʾip��ַ��Ĭ��loganalyzerֻ��ʾ��־����Դ������������������־����������̨����������������ʾ��־����ԴIP

#��Syslog���е�SystemEvents�������һ���ֶΣ�������¼��ԴIP
ALTER TABLE SystemEvents ADD FromIP VARCHAR(60) DEFAULT NULL AFTER FromHost;

#�޸�rsyslog.conf

#�������ݵ���������rsyslog�ڽ���־д��Mysql��ʱ����ԴIPд�뵽FromIP�ֶΣ�������loganalyzer��ȡ��־��ʱ��ſ���ȡ��ip��Ϣ
$template insertpl,"insert into SystemEvents (Message, Facility, FromHost, FromIP, Priority, DeviceReportedTime, ReceivedAt, InfoUnitID, SysLogTag) values ('%msg%', %syslogfacility%, '%HOSTNAME%', '%fromhost-ip%', %syslogpriority%, '%timereported:::date-mysql%', '%timegenerated:::date-mysql%', %iut%, '%syslogtag%')",SQL

$ModLoad ommysql.so
*.* :ommysql:localhost,Syslog,rsyslog,123456;insertpl

#����rsyslog

#����Ա��ݵ�¼loganalyzer����Aamin Center���½�Field  View ��DBmapping��Ȼ�����µ�view����ʾ��ҳ���Ͼͻ���ip��Ϣ��

#field����ı�����view������Щ��������ʾ��ҳ���ϣ�DBmapping�����field����ȡʲôֵ
