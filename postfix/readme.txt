
#���Ի��� CentOS-6.4����С����װ

=========================================================================

1  ��װapache mysql

==========================================================================
2  ��װcyrus-sasl

yum install -y cyrus-sasl  cyrus-sasl-devel

vi /usr/lib/sasl2/smtpd.conf

pwcheck_method: saslauthd #ʹ��saslauthd����֤����������֤
mech_list: PLAIN LOGIN

#����saslauthd
/usr/sbin/saslauthd -a shadow

3  ��װpostfix

echo "/usr/local/mysql/lib" >> /etc/ld.so.conf && ldconfig #��mysql��LibĿ¼���뵽��̬�⻺��·������Ȼ��߻���ʾ�Ҳ���mysql��client������
yum install db4-devel #������ִ��make makefiles��ʱ�����ʾ�Ҳ���db.h
tar zxvf postfix-2.10.1.tar.gz && cd postfix-2.10.1

make makefiles CCARGS='-DUSE_SASL_AUTH -DUSE_CYRUS_SASL -DHAS_SSL -DHAS_MYSQL  -I/usr/local/mysql/include -I/usr/include/sasl/' AUXLIBS='-L/usr/local/mysql/lib -L/usr/lib/sasl2 -lsasl2 -lcrypto -lssl -lmysqlclient -lz -lm '

make 

make install

newaliases  #���ɱ����������ļ����������������ԣ������postfixЧ�ʼ���

4 ��������Postfix

myhostname = mail.test.com    #ָ������postfix�ʼ�ϵͳ�������� 
myorigin = test.com     #�������˵���Ϣ����ϸʱ��ʹ�����Ĭ���� 
mydomain = test.com     #ָ��������Ĭ�������postfix��myhostname�ĵ�һ����ɾ������Ϊmydomain��ֵ 
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain    #ָ������������ʼ�postfix������������� 
mynetworks = 192.168.0.0/24, 127.0.0.0/8  #ָ��postfixΪ��Щ���ε��û������ʼ��м� 
inet_interfaces = all

smtpd_sasl_auth_enable = yes  #postfix����sasl��֤
broken_sasl_auth_clients = yes  #��ҪΪ�˼���һЩ�ϵ�����MUA
#����


/usr/sbin/postfix  start #postfix�������Ŀ¼��Ȩ�����ã�����ʾĳЩĿ¼��Ȩ�޲��ԣ�������ʾ���޸ļ���

#���ˣ�postfix�Ѿ��߱��˳�����sasl��֤���ܣ���Ȼ����ֻ����֤ϵͳ�˻���

#����������һ���Ƚϵ��͵������ǣ�ϵͳ����һ��cyrus-sasl,���ֱ��밲װ��һ�ף����������saslauthd���Լ�װ���Ǹ���Postfix������ȴ��ϵͳĬ�ϵģ�����һֱ��ʾ�Ҳ���saslauthd����Ϊ�������е�Ŀ¼��ͬ���Ų��ʱ���õ���ldd�������鿴postfix����ʹ�����ĸ�sasl������
postfix reload #���¼��������ļ�







5 ����postfix��������cyrus-sasl����֤
postconf -a #����������£������postfix֧��cyrus������֤
cyrus
dovecot

#�༭postfix�������ļ������һ������

smtpd_recipient_restrictions=permit_mynetworks,permit_sasl_authenticated,reject_invalid_hostname,reject_non_fqdn_hostname,reject_unknown_sender_domain,reject_non_fqdn_sender,reject_non_fqdn_recipient,reject_unknown_recipient_domain,reject_unauth_pipelining,reject_unauth_destination 

smtpd_sasl_local_domain = $myhostname 
smtpd_sasl_security_options = noanonymous 
smtpd_banner = Welcome to our $myhostname ESMTP,Warning: Version not Available!

postfix reload  #���¼��������ļ�


6 ��װ Courier authentication library 
  ��װCourier authentication library����postfix�ܹ���mysql���ݿ����ӣ����û����ʺź�����������ݿ��У��Ա��ܹ��ṩ�û���֤
tar jxvf courier-authlib-0.65.0.tar.bz2 && cd courier-authlib-0.65.0

./configure --prefix=/usr/local/courier-authlib --without-stdheaderdir --with-authmysql --with-mysql-lib=/usr/local/mysql/lib/ --with-mysql-includes=/usr/local/mysql/include/ --with-ltdl-lib=/usr/lib --with-ltdl-include=/usr/include/
#configure��������ʾȱ��expect�����޷���webmail���޸�����,yum ��װ
 yum install expect
 
make && make install

7 ��װdevecot

mkdir /data/mailbox

chown -R postfix:postfix /data/mailbox

useradd -M -s /bin/false devecot

tar zxvf dovecot-2.2.4.tar.gz && cd dovecot-2.2.4

./configure --prefix=/usr/local/dovecot --with-sql --with-sql-drivers --with-mysql

#���������ļ�

make && make install



