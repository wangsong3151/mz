#CentOS 6.4

# ��װruby,puppetʹ��ruby��д
yum install ruby ruby-libs ruby-rdoc

# �޸���������puppetҪ��ÿ̨��������������������FQDN�������û��DNSֻ��ͨ���޸���������hosts����֤hostname�����Ľ����hosts�ļ�����һ�µ�

# /etc/hosts
192.168.119.129 master.puppet.cn
192.168.119.128 client.puppet.cn

#/etc/sysconfig/network

HOSTNAME=master.puppet.cn


# ͬ����������ʱ��
ntpdate tick.ucla.edu tock.gpsclock.com

#���puppet�ٷ�Դ

rpm -ivh http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-1.noarch.rpm

yum update


#�����
yum install puppet-server

service puppet start  # ���Լ�Ҳ��Ϊһ���ͻ��˹�������
service puppetmaster start

#�ͻ���
yum install puppet

service puppet start

#�޸�/etc/puppet/puppet.conf�����������

server = master.puppet.cn  #�趨����˵ĵ�ַ


#����֤�鲢���͸�����������ǩ��
puppet agent  --no-daemonize --verbose


#�������˲���

puppet cert --sign node08.chenshake.com  #ǩ��֤��

puppet cert list --all #�鿴����֤�飬֤��ǰ��+���ŵ����Ѿ�ͨ��ǩ����֤��

puppet cert revoke node08.chenshake.com # ע��֤��

puppet cert --clean node08.chenshake.com # ���֤�飬����ע�������������Ҫ����puppetmaster����

# �ͻ�������֤�飬��������
rm -f /var/lib/puppet/ssl/certs/node08.chenshake.com.pem

rm -rf /var/lib/puppet/ssl