
awstats+nginx:

�����߼���

1 ����nginx������־����������и�洢����ӦĿ¼

2 �޸�aws�����ļ���ָ��LogFile��Ҳ���ǵ�һ���и�õ���־��aws����Ը���־���з�������

3  ����/usr/local/awstats/tools/awstats_buildstaticpages.pl -update -config=bbs.phpchina.com -lang=cn -dir=/backup/www/awstats/bbs.phpchina.com -awstatsprog=/usr/local/awstats/wwwroot/cgi-bin/awstats.pl ����ÿ�����־���з�����������html�ļ���

4 http����html�ļ�

5 ����ʹ�üƻ�����1��3�Զ���

������
#nginx�����ļ�
# aws.phpchina.com
server {
    listen      80;
    server_name aws.phpchina.com;
    index           index.html;
    root            /backup/www/awstats/bbs.phpchina.com;
    access_log  off;
     if  ( $fastcgi_script_name ~ \..*\/.*php )  {
                 return 403;
        }

    location / {
    auth_basic "auth";
    auth_basic_user_file /backup/www/awstats/bbs.phpchina.com/htpasswd;
    autoindex       on;
    }
    location /icon/ {
    alias /usr/local/awstats/wwwroot/icon/;
    index index.html;
    access_log off;
    }
}

aws�����ļ�����Ҫ�޸�LogFile��������������Ĭ�ϼ��ɡ�


����־�ϲ�����(����30.0206.vblog.log��31.0206.vblog.log)
LogFile="/opt/awstats/tools/logresolvemerge.pl /var/apachelogs/30.0206.vblog.log /var/apachelogs/31.0206.vblog.log|"
��
LogFile="/opt/awstats/tools/logresolvemerge.pl /var/apachelogs/*.0206.vblog.log|"

(2)����ʹ��gzipѹ��������־�ļ�
LogFile="gzip -d </var/log/apache/access.log.gz|"

awstats+apache:

tar zxvf awstats-6.6.tar.gz
mv awstats-6.6 awstats
cd awstats/tools/
perl awstats_configure.pl


3��Perl�ű�awstats_configure.pl��װ����(������������AWStatsӢ��ʹ��˵��)

(1)
-----> Running OS detected: Linux, BSD or Unix
Warning: AWStats standard directory on Linux OS is '/usr/local/awstats'.
If you want to use standard directory, you should first move all content
of AWStats distribution from current directory:
/opt/awstats
to standard directory:
/usr/local/awstats
And then, run configure.pl from this location.
Do you want to continue setup from this NON standard directory [yN] ?

��ʱѡ��y�س���

(2)
-----> Check for web server install

Enter full config file path of your Web server.
Example: /etc/httpd/httpd.conf
Example: /usr/local/apache2/conf/httpd.conf
Example: c:\Program files\apache group\apache\conf\httpd.conf
Config file path ('none' to skip web server setup):

��һ��ʹ��������Apache��httpd.conf·��������/opt/sina/apache/conf/httpd.conf
�Ժ������ʹ��perl awstats_configure.pl���������ļ������������none������

(3)
-----> Check and complete web server config file '/opt/sina/apache/conf/httpd.conf'
Warning: You Apache config file contains directives to write 'common' log files
This means that some features can't work (os, browsers and keywords detection).
Do you want me to setup Apache to write 'combined' log files [y/N] ?

ѡ��y������־��¼��ʽ��CustomLog /yourlogpath/yourlogfile common��Ϊ����ϸ��CustomLog /yourlogpath/yourlogfile combined

(4)
-----> Update model config file '/opt/awstats/wwwroot/cgi-bin/awstats.model.conf'
 File awstats.model.conf updated.

-----> Need to create a new config file ?
Do you want me to build a new AWStats config/profile
file (required if first install) [y/N] ?

����һ���µ������ļ���ѡ��y

(5)
-----> Define config file name to create
What is the name of your web site or profile analysis ?
Example: www.mysite.com
Example: demo
Your web site, virtual server or profile name:
>
����վ�����ƣ�����xxxx

(6)
-----> Define config file path
In which directory do you plan to store your config file(s) ?
Default: /etc/awstats
Directory path to store config file(s) (Enter for default):
>

����AWStats�����ļ����·����һ��ֱ�ӻس���ʹ��Ĭ��·��/etc/awstats

(7)
-----> Add update process inside a scheduler
Sorry, configure.pl does not support automatic add to cron yet.
You can do it manually by adding the following command to your cron:
/opt/awstats/wwwroot/cgi-bin/awstats.pl -update -config=sina
Or if you have several config files and prefer having only one command:
/opt/awstats/tools/awstats_updateall.pl now
Press ENTER to continue...

���س�������

(8)
A SIMPLE config file has been created: /opt/awstats/etc/awstats.sina.conf
You should have a look inside to check and change manually main parameters.
You can then manually update your statistics for 'sina' with command:
> perl awstats.pl -update -config=sina
You can also read your statistics for 'sina' with URL:
> http://localhost/awstats/awstats.pl?config=sina

Press ENTER to finish...

���س�������


4���޸�awstats.sina.conf����
vi /etc/awstats/awstats.xxxx.conf

��?����֮������Ҫ����������LogFile="
Ȼ��Ins�����ҵ�LogFile="/var/log/httpd/access_log"
��ΪҪ������Apache��־·�����ļ�����

(1)����־�ϲ�����(�������˲���������̨������2��6�յ���־30.0206.vblog.log��31.0206.vblog.log)
LogFile="/opt/awstats/tools/logresolvemerge.pl /var/apachelogs/30.0206.vblog.log /var/apachelogs/31.0206.vblog.log|"
��
LogFile="/opt/awstats/tools/logresolvemerge.pl /var/apachelogs/*.0206.vblog.log|"

(2)����ʹ��gzipѹ��������־�ļ�
LogFile="gzip -d </var/log/apache/access.log.gz|"


5�����·�������
perl /opt/awstats/wwwroot/cgi-bin/awstats.pl -config=xxxx -lang=cn -update

����������´�����ʾ���ܴ������Apache��Log�ļ��д�����ǰCustomLog /yourlogpath/yourlogfile common���ɵ���־��ɾ������Щ�е���־���ɣ�
This means each line in your web server log file need to have "combined log format" like this:
111.22.33.44 - - [10/Jan/2001:02:14:14 +0200] "GET / HTTP/1.1" 200 1234 "http://www.fromserver.com/from.htm" "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)"


6���鿴��������
http://localhost/awstats/awstats.pl?config=xxx



7 ��װ���
awstats�Դ�GeoIP�����ֻ��Ҫ����Geo��IP���ݿⲢΪ�������ϵ�perl��װGeo::IP::PurePerlģ��

�޸�awstats.xxx.conf

LoadPlugin="tooltips"
LoadPlugin="decodeutfkeys"
LoadPlugin="geoip GEOIP_STANDARD /path/GeoIP.dat"
LoadPlugin="geoip_city_maxmind GEOIP_STANDARD /path/GeoLiteCity.dat"

8 ��װqqhostinfo���

�ϴ������awstats/wwwroot/cgi-bin/pluginsĿ¼

vi qqhostinfo.pm

push @INC, "/path/plugins"
require "/path/qqwry.pl"

vi qqwry.pl

my $ipfile="/path/qqwry.dat"


Ȼ���������ļ��м��ز����
LoadPlugin="qqhostinfo"


#�����װ�Ժ�ҳ����"�ؼ���"����������Ļ�����Ҫ��awstats�����ļ��е�decodeutfkeys�������������UTF8�������ݣ���Ϊ���������ʹ��UTF8��ʽ
LoadPlugin="decodeutfkeys"�� #���������Ļ�������Ҫperl��װ��URI::Escapeģ��




###

ҳ�������ʹ�õ������ļ�����Ҫ��updateʱʹ�õ������ļ�����һ�£���Ȼ�����BUID���ɵ������ļ�����UPDATE��ͼ��ȡ�������ļ�����һ�£����ҳ����������Ϊ��

Ҳ���ǣ����perl awstats.pl config=3g.happigo.com -update

��ôҳ�����ʱ��http://host/awstats/awstats/pl?config=3g.happigo.com

���perl awstats.pl config=awstats.3g.happigo.com.conf -update

��ôҳ�����ʱ��http://host/awstats/awstats/pl?config=awstats.3g.happigo.com.conf