#��װLAMP��������apche 2.4.6  php 5.5.3��

#apache

tar jxvf apr-1.5.0.tar.bz2 && cd apr-1.5.0
#ע�͵�configure�ļ��е�ĳ�У������/bin/rm: cannot remove `libtoolT��: No such file or directory ��
sed -i '/$RM "$cfgfile"/ s/^/#/' configure
./configure --prefix=/usr/local/apr && make && make install || exit 1
cd ..
#apr-util
tar jxvf apr-util-1.5.3.tar.bz2  &&  apr-util-1.5.3
./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr/bin/apr-1-config  && make && make install

#pcre
cd ..
echo "Start the installation of pcre..."
tar jxvf pcre-8.34.tar.bz2 && cd pcre-8.34
./configure --prefix=/usr/local/pcre && make && make install 

sleep 2
tar zxvf httpd-2.4.9.tar.gz && cd httpd-2.4.9 && ./configure --prefix=/usr/local/apache2 --sysconfdir=/etc/httpd --with-apr=/usr/local/apr/bin/apr-1-config --with-apr-util=/usr/local/apr-util/bin/apu-1-config  --with-pcre=/usr/local/pcre/ --enable-mods-shared=most  --enable-rewirte --enable-so --enable-ssl=static --with-ssl  && make && make install

#php��ذ���snmp��sockets��PDO_MYSQL��json��չ(jsonĬ�ϰ���) #sockets��snmpΪcacti���裬����sockets��չ����װ�����޷��򿪣���ʾȱ��sockets��չ����װ������Ҫָ��snmp��·��  
#pdo_mysql��json��չΪNPC�������Ҫ ��nagios plugin for cacti��


yum install net-snmp net-snmp-devel net-snmp-utils
#snmpd.conf���Ա���ԭ����ֱ���������񼴿�

#php�������       
./configure --prefix=/usr/local/php5.3  --with-config-file-path=/usr/local/php5.3/etc --with-apxs2=/usr/local/apache2/bin/apxs --with-libxml-dir --with-iconv-dir --with-png-dir --with-jpeg-dir=/usr/local/jpeg --with-zlib --with-gd=/usr/local/gd --with-freetype-dir=/usr/local/freetype --with-mcrypt --with-mhash --enable-gd-native-ttf  --with-curl --with-bz2 --enable-mysqlnd --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-openssl-dir --without-pear --enable-xml --enable-zip --enable-sockets --with-snmp
make
make install

# php.ini������
# 1 phpһ��Ҫ����exec()������ִ��
# 2 date.timezone = Asia/Chongqing

#��װrrdtool
yum install rrdtool

#����cactiʹ�õ����ݿ�,������û�

mysql --user=root <<EOF
CREATE DATABASE cacti;
GRANT ALL PRIVILEGES ON cacti.* TO cactiuser@localhost IDENTIFIED BY 'cactiuser';
FLUSH PRIVILEGES;
EOF

#cacti��װ
tar zxvf cacti-0.8.8f.tar.gz -C ${apache_DocumentRoot}
#��ѹ������cacti.sql��cacti��,��дmysql������Ϣ��URL����(include/config.php)��web���ʿ�ʼ��װ

#��װ��������Ҫ��ָ���������·����php snmp��

#��װ��ɺ��������Ҫ��Console->Settings->general���ø�����İ汾
net-snmp -->5.x
rrdtool -->1.3x
snmp ---> version2

#Devices-->���õ�����������Ϣ
snmp--> version2

#��Ӽƻ�����
*/5 * * * * php poller.php > /dev/null 2&1

#������Ļ�������apache����־�����кܶ���ʾ


==========================================================



#��װspine,һ�ָ���Ч����ѯ���ƣ��滻cacti�Դ���[poller type]--- cmd.php
#http://www.cacti.net/downloads/spine/ ���ص�ַ��ע����cacti�汾����һ��
tar zxvf cacti-spine-0.8.8f.tar.gz && cd cacti-spine-0.8.8b
./configure --prefix=/usr/local/spine --with-mysql=/Data/app/mysql
make && make install

#�༭spine�����ļ� /usr/local/spine/etc/spine.conf,��д��ȷ�����ݿ�������Ϣ

#cacti��Console-->Settings-->Poller,����ѯ��ʽ����Ϊspine

============================================================


# ndoutils,��nagios�ռ������ݴ���mysql,Ȼ����cacti��ȡ����ʾ����
tar zxvf ndoutils-2.0.0.tar.gz && cd  ndoutils-2.0.0
./configure --enable-mysql --with-mysql=/Data/app/mysql/

make

cp -v src/{ndomod-4x.o,ndo2db-4x,file2sock,log2ndo}  /usr/local/nagios/bin
#����ndodb��
mysql --user=root --password=123456 <<EOF
CREATE DATABAS ndodb;
GRANT ALL PRIVILEGES ON ndodb.* TO ndouser@localhost IDENTIFIED BY '123456';
FLUSH PRIVILEGES;
EOF
 
cd ndoutils-2.0.0/db
#����ndoutils����Ҫ�����ݿ��ȣ���Щ��Ĭ���ԡ�nagios_��Ϊǰ׺
./installdb -u ndouser -p 123456 -h localhost -d ndodb
#installdb��һ��perl�ű���ִ������Ҫ�õ�perl��DBI��DBD::mysqlģ�飬���û���Ȱ�װ 

#���ơ��༭�����ļ�
cd ndoutils-2.0.0/config
cp ndo2db.cfg-sample  /usr/local/nagios/etc/ndo2db.cfg
cp ndomod.cfg-sample  /usr/local/nagios/etc/ndomod.cfg
chmod 644 /usr/local/nagios/etc/ndo*
chown nagios:nagios /usr/local/nagios/etc/ndo*
chown nagios:nagios /usr/local/nagios/bin/*

vi /usr/local/nagios/etc/nagios.cfg
event_broker_options=-1
broker_module=/usr/local/nagios/bin/ndomod-4x.o config_file=/usr/local/nagios/etc/ndomod.cfg

#�༭ndo2db��ndomod�������ļ�
vi /usr/local/nagios/etc/ndo2db.cfg

socket_type=unix
socket_name=/usr/local/nagios/var/ndo.sock

db_servertype=mysql
db_host=localhost
db_port=3306
db_name=ndodb
db_prefix=nagios_
db_user=ndouser
db_pass=123456

vi /usr/local/nagios/etc/ndomod.cfg
output_type=unixsocket
output=/usr/local/nagios/var/ndo.sock

#����ndo2db
/usr/local/nagios/bin/ndo2db-4x -c /usr/local/nagios/etc/ndo2db.cfg

#�鿴ϵͳ��־ȷ����������

#����nagios,���׹ر�������
service nagios stop
rm -f /usr/local/nagios/var/nagios.lock
service nagios start

#����webҳ��鿴nagios����־�Ƿ�ɹ�����ndomodģ���Լ�ndo2db�Ƿ����ӵ��ɹ����ӵ�mysql

=============================================================
#��װntop

#���Ȱ�װGeoIP GeoIP-devel��Ĭ�ϵ�yumԴ��û���������������epel  yumԴ
wget http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
rpm -Uvh epel-release-6-8.noarch.rpm

yum install ntop
#����ntop����Ա������
ntop -A

#���һ����ͨ�û�������ntop
useradd -M -s /sbin/nologin -r ntop
#����ntop
ntop -i eth0 -d -L -u ntop
#�鿴ntop��Ч��
http://ip:3000

==========================================================

#��ntop��nagios���Ͻ�cacti��Ҳ���Ǹ�cacti��װ���

#����ntop,��װntop-v0.2-1.tgz���
tar zxvf ntop-v0.2-1.tgz -C /data/www/cacti/plugins

#��cacti��console->Settings->Misc����дntopd��url,����http://192.168.126.130:3000
#Ȼ����cacti��console->Plugin Management�а�װ������ntop����Ϳ�����


==========================================================

#����nagios,��װnpc(nagios-plgin-for-cacti)
tar zxvf npc-2.0.4.tar.gz -C /data/www/cacti/plugins
#��cacti��Console-->Plugin Management�а�װnpc�������װ�����л���cacti��������npc_*���ݱ��ṹ��֮ǰ��װndoutilsʱ������ndodb��
#���nagios_*��һ���ģ�����npc����Ժ�ԭ����ndodb���û���ˣ�Ӧ���޸�ndo2db�����ã�������nagios������ֱ��д��cacti���У�npc���
#���ȡndo2dbд������ݣ�Ȼ����cacti������չ�ֳ���

#Console-->Settings-->NPC����nagios�������Ϣ
# Remote Commands [ѡ��]
# Nagios Command File Path-->/usr/local/nagios/var/rw/nagios.cmd
# Nagios URL  http://xxxxx/nagios
#



# �޸�ndo2db�������ļ�
# db_name ��ndodb��Ϊcacti
# db_prefix ��nagios_��Ϊnpc_
# ��Ȼ��Ҫȷ��ndo2dbʹ�õ��û���Ȩ����cacti��npc_*��д����


#Ϊcacti���е�npc_*�����ȱʧ���ֶΣ�ndo2db�ڽ�nagios�ռ�������д��cacti��npc_��д�����ݵ�ʱ��ᱨȱ��long_output�ֶεĴ���
mysql --user=root --password=123456 <<EOF
use cacti;
ALTER TABLE npc_eventhandlers ADD long_output TEXT NOT NULL AFTER output;
ALTER TABLE npc_hostchecks ADD long_output TEXT NOT NULL AFTER output;
ALTER TABLE npc_hoststatus ADD long_output TEXT NOT NULL AFTER output;
ALTER TABLE npc_notifications ADD long_output TEXT NOT NULL AFTER output;
ALTER TABLE npc_servicechecks ADD long_output TEXT NOT NULL AFTER output;
ALTER TABLE npc_servicestatus ADD long_output TEXT NOT NULL AFTER output;
ALTER TABLE npc_statehistory ADD long_output TEXT NOT NULL  AFTER output;
ALTER TABLE npc_systemcommands ADD long_output TEXT NOT NULL  AFTER output;
EOF



#����ndo2db��nagios,ע�⳹�׹ر�������
# /usr/local/nagios/bin/ndo2db-4x -c /usr/local/nagios/etc/ndo2db.cfg
# service nagios start
#�鿴ϵͳ��־ȷ��ndo2db�Ѿ�������д��cacti����
