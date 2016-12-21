# deps
yum -y install gcc gcc-c++ libtool openssl openssl-devel ncurses ncurses-devel libxml2 libxml2-devel bison libXpm libXpm-devel fontconfig-devel libtiff libtiff-devel curl curl-devel readline readline-devel bzip2 bzip2-devel sqlite sqlite-devel zlib zlib-devel libpng-devel gd-devel freetype-devel perl perl-devel perl-ExtUtils-Embed openldap openldap-devel

APP_DIR=/usr/local/
SOURCE_DIR=/Data/software
[ "$PWD" != "${SOURCE_DIR}" ] && cd ${SOURCE_DIR}

#apr
tar jxvf apr-1.5.2.tar.bz2  && cd apr-1.5.2
sed -i '/$RM "$cfgfile"/ s/^/#/' configure
./configure --prefix=${APP_DIR}apr
make && make install
cd ..

#��װapr-util
tar jxvf apr-util-1.5.4.tar.bz2 && cd  apr-util-1.5.4
./configure --prefix=${APP_DIR}apr-util --with-apr=${APP_DIR}apr/bin/apr-1-config --with-ldap
make && make install
cd ..

#��װpcre
tar jxvf pcre-8.38.tar.bz2 && cd pcre-8.37
./configure --prefix=${APP_DIR}pcre
make && make install
cd ..

#����openssl
tar zxvf openssl-1.0.2f.tar.gz
cd openssl-1.0.2f
./config shared zlib
make && make install
mv /usr/bin/openssl /usr/bin/openssl.OFF
mv /usr/include/openssl /usr/include/openssl.OFF
ln -s ${APP_DIR}ssl/bin/openssl /usr/bin/openssl
ln -s ${APP_DIR}ssl/include/openssl /usr/include/openssl
echo "${APP_DIR}ssl/lib" >> /etc/ld.so.conf
ldconfig
cd ..

#��װapache
tar jxvf httpd-2.4.17.tar.bz2 && cd httpd-2.4.17
./configure --prefix=${APP_DIR}apache-2.4.17 --sysconfdir=/etc/httpd --with-apr=${APP_DIR}apr/bin/apr-1-config --with-apr-util=${APP_DIR}apr-util/bin/apu-1-config  --with-pcre=${APP_DIR}pcre/ --enable-so --enable-mods-shared=all --enable-rewirte  --enable-ssl=shared --with-ssl=${APP_DIR}ssl --enable-ldap --enable-authnz-ldap
make && make install
cd ..

#re2c (for php)
tar zxvf re2c-0.14.3.tar.gz && cd re2c-0.14.3
./configure && make &&  make install
cd ..

# libiconv (for php)
tar zxvf libiconv-1.14.tar.gz && cd libiconv-1.14
#centos7 ����
#cd ..
#gunzip libiconv-glibc-2.16.patch.gz
#cd libiconv-1.14/srclib
#patch -p1 < ../../libiconv-glibc-2.16.patch
#cd ..
./configure --prefix=/usr && make && make install
cd ..

# php (for iF.SVNADMIN)
tar jxvf php-5.3.29.tar.bz2 && cd php-5.3.29
./configure --prefix=${APP_DIR}php-5.3.29  --with-config-file-path=${APP_DIR}php-5.3.29/etc --with-apxs2=${APP_DIR}apache-2.4.12/bin/apxs --with-libxml-dir --with-iconv-dir --with-png-dir --with-jpeg-dir --with-zlib --with-gd  --with-freetype-dir  --enable-gd-native-ttf  --with-readline --with-curl --with-bz2 --enable-mysqlnd --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-openssl-dir --without-pear  --enable-mbstring --enable-soap --enable-xml --enable-zip --enable-bcmath
make ZEND_EXTRA_LIBS='-liconv' && make install

#php���ldap֧��
cd ext/ldap
${APP_DIR}php-5.3.29/bin/phpize
./configure --with-ldap  --with-ldap-sasl --with-php-config=${APP_DIR}php-5.3.29/bin/php-config 
make && make install
mkdir ${APP_DIR}php-5.3.29/ext
cp ${APP_DIR}php-5.3.29/lib/php/extensions/no-debug-zts-20090626/ldap.so ${APP_DIR}php-5.3.29/ext
#echo "extension = ldap.so" >> php.ini

cd ../../

#��װsqlite
#http://www.sqlite.org/download.html
tar zxvf sqlite-autoconf-3090200.tar.gz  && cd  sqlite-autoconf-3090200/
./configure --prefix=${APP_DIR}sqlite
make && make install
cd ..

#cyrus-sasl
#ע���ɵ�cyrus-sasl
mv /usr/lib64/sasl2/ /usr/lib64/sasl2.OFF
tar zxvf cyrus-sasl-2.1.26.tar.gz && cd cyrus-sasl-2.1.26
./configure --disable-sample --disable-saslauthd --disable-pwcheck --disable-krb4 --disable-gssapi --disable-anon --enable-plain --enable-login --enable-cram --enable-digest --with-saslauthd=/var/run/saslauthd
make && make install
ln -s ${APP_DIR}lib/sasl2/ /usr/lib64/sasl2
echo "${APP_DIR}lib/sasl2/lib" >> /etc/ld.so.conf
ldconfig
cd ..



### serf [��svn���Դ���http/htps��ʽ�İ汾��]
#scons# [http://sourceforge.net/projects/scons/files/scons/]
tar zxvf scons-2.4.0.tar.gz  && cd scons-2.4.0
python setup.py install 

# serf# [https://serf.apache.org/download]
tar jxvf serf-1.3.8.tar.bz2 && cd serf-1.3.8
scons PREFIX=/Data/app/serf APR=/Data/app/apr APU=/Data/app/apr-util/
scons install
scons -c




#��װsubversion
tar  jxvf subversion-1.9.2.tar.bz2 && cd  subversion-1.9.2
./configure --prefix=${APP_DIR}subversion --with-apxs=${APP_DIR}apache-2.4.12/bin/apxs --with-apr=${APP_DIR}apr --with-apr-util=${APP_DIR}apr-util/ --with-sqlite=${APP_DIR}sqlite/ --with-serf=/Data/app/serf --with-sasl=/usr/lib64/sasl2
make && make install
#�ڰ�װĿ¼������svn-toolsĿ¼�������һЩ��չ���ߣ�����svnauthz-validate
make install-tools
ln -s  /Data/app/serf/lib/libserf-1.so.1.3.0 /Data/app/subversion/lib/libserf-1.so.1 
cd ..

#########svnserve --version################
##Cyrus SASL authentication is available.##
###########################################

# $PATH
cat >> ~/.bashrc << EOF
APACHE_HOME=${APP_DIR}apache-2.4.12
SUBVERSION_HOME=${APP_DIR}subversion
PATH=$PATH:\${APACHE_HOME}/bin:\${SUBVERSION_HOME}/bin
export APACHE_HOME SUBVERSIOIN_HOME PATH
EOF
source ~/.bashrc

#Ϊapache���ģ��
cd ${SUBVERSOIN_HOME}
cp libexec/*svn.so  ${APACHE_HOME}/modules/

#ȷ��apache����������ģ�飺
LoadModule authz_user_module modules/mod_authz_user.so
LoadModule dav_module modules/mod_dav.so
LoadModule dav_svn_module modules/mod_dav_svn.so
LoadModule authz_svn_module modules/mod_authz_svn.so
LoadModule authnz_ldap_module modules/mod_authnz_ldap.so
LoadModule ldap_module modules/mod_ldap.so


#����saslauthd����
cat > /etc/saslauthd.conf << EOF
ldap_servers: ldap://192.168.1.100
ldap_default_domain: selboo.com.cn
ldap_search_base: DC=selboo,DC=com,DC=cn
ldap_bind_dn: administrator@selboo.com.cn
ldap_bind_pw: 123456
ldap_deref: never
ldap_restart: yes
ldap_scope: sub
ldap_use_sasl: no
ldap_start_tls: no
ldap_version: 3
ldap_auth_method: bind
ldap_filter: sAMAccountName=%u
ldap_password_attr: userPassword
ldap_timeout: 10
ldap_cache_ttl: 30
ldap_cache_mem: 32768
EOF
sed -i '/^MECH/ s/pam/ldap/' /etc/sysconfig/saslauthd

#����svn��sasl
#cat /etc/sasl2/svn.conf
pwcheck_method: saslauthd
auxprop_plugin: ldap
mech_list: PLAIN LOGIN
ldapdb_mech: PLAIN LOGIN

#����saslauthd����
service saslauthd start

#��֤sasl
testsaslzuthd -u xxx -p xxx
##0: OK "Success."##

#svnadmin create /Data/svnroot/test1
# vi /Data/svnroot/test1/conf/svnserve.conf
[sasl]
use-sasl = true

#��httpd-vhosts.conf�������������
<VirtualHost *:80>
    ServerName svn.xxx.com
    <Location />
        DAV svn
        SVNParentPath /Data/svnroot
        AuthBasicProvider ldap
        AuthType Basic
        #AuthzLDAPAuthoritative on
        AuthName "My Subversion Server"
        AuthLDAPURL "ldap://10.10.xx.xx:389/DC=bj,DC=happigo,DC=com?sAMAccountName?sub?(objectClass=*)" NONE
        #AuthLDAPBindDN "CN=shidg,CN=Users,DC=bj,DC=happigo,DC=COM"
        AuthLDAPBindDN "shidg@bj.happigo.com"
        AuthLDAPBindPassword "xxxx"
        Require valid-user
        AuthzSVNAccessFile /Data/svnroot/authz
    </Location>
</VirtualHost>



##############################################�������htpasswd��֤####################################################
#<VirtualHost *:80>
#    ServerName svn.happigo.com
#    <Location />                         #�����/svnҪ������AliasĿ¼����
#        DAV svn
#        SVNParentPath /data/svn      #svn�汾���Ŀ¼,��Ŀ¼���ж���汾��ʹ��SVNParentPath,�����汾���ʹ��SVNPath
#        AuthType Basic
#        AuthName "Subversion repository"    #��֤ҳ����ʾ��Ϣ
#        AuthUserFile /data/svn/passwd          #�û�������
#        Require valid-user                              # ֻ����ͨ����֤���û�����
#        AuthzSVNAccessFile /data/svn/authz  #�汾��Ȩ�޿���
#    </Location>
#</VirtualHost>
# ����passwd��authz�ļ�
# ������֤�ļ�
# �û��������ļ���
#htpasswd -c  /data/svn/passwd  user1  #�״�����û���������û�ʹ��-m��������
# �汾��Ȩ����֤�ļ� authz
######################################################################################################################




# ����apache  https
# ������Ҫ��װ��openssl,�ϱߵĲ������Ѿ���װ��
# apacheҪ����sslģ����߰�װapache��ʱ���Ѿ�ʹ��enable-ssl��̬������ssl

#httpd.conf��ȥ�������е�ע�ͣ�ʹ֮��Ч
LoadModule ssl_module modules/mod_ssl.so
LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
Include /etc/httpd/extra/httpd-ssl.conf

#�༭httpd-ssl.conf�ļ�

<VirtualHost _default_:443>
ServerName svn.xx.com:443
<Location />
        DAV svn
        SVNParentPath /Data/svnroot
        AuthBasicProvider ldap
        AuthType Basic
        #AuthzLDAPAuthoritative on
        AuthName "My Subversion Server"
        AuthLDAPURL "ldap://10.10.xx.xx:389/DC=bj,DC=happigo,DC=com?sAMAccountName?sub?(objectClass=*)" NONE
        #AuthLDAPBindDN "CN=shidg,CN=Users,DC=bj,DC=happigo,DC=COM"
        AuthLDAPBindDN "shidg@bj.happigo.com"
        AuthLDAPBindPassword "xxxx"
        Require valid-user
        AuthzSVNAccessFile /Data/svnroot/authz
</Location>
SSLEngine on
SSLCertificateFile "/etc/httpd/server.crt"     
SSLCertificateKeyFile "/etc/httpd/server.key"
</VirtualHost >

# ����ssl֤��
openssl genrsa  -des3 -out  server.key 1024 #des3 ��˽Կ������룬������ȫ��

openssl req -new   -key server.key  -out server.csr # ��˽Կƥ��Ĺ�Կ�����ӽ�����ù�Կ������ͻ���

openssl  x509 -days 365 -req -signkey server.key -in server.csr  -out  server.crt  #����Կǩ��������֤��

cp server.key server.key.with_pass

openssl rsa -in server.key.with_pass -out server.key # ����һ���������˽Կ��ר�Ÿ�apache��nginxʹ�õģ���Ϊ���������Ҫʹ��˽Կ�Կͻ���ʹ�õĹ�Կ������֤��ƥ���������

#�����ɵ������ļ��ŵ�/et/httpdĿ¼�£�/etc/httpdĿ¼����һ��httpd-ssl.conf��ָ���ģ�

# ����apache����

#����

https://svn.xx.com/test1

#ע��������ģʽ�£�svn���񲢲�������ͨ��http��https������svn������svn�ύ���ݵ�ʱ��Ҫ��֤��������apache���û���svn�汾��Ŀ¼�ж�дȨ�ޣ���Ȼ��������db/txn-current-lock': Permission denied�� �Ĵ���
