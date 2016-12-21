#! /bin/bash
#��װǰ׼��
#gcc/apache/php/gd
#yum install gcc glibc glibc-common gd gd-devel
#apache/php��װ��,apacheҪ����mod_cgid.so����������cgi�ļ���ֱ�����شӶ��޷����ּ�ؽ���
#selinux -->disabled

useradd -m nagios
echo "123456" | passwd --stdin nagios
groupadd nagcmd
usermod -a -G nagcmd nagios 
usermod -a -G nagcmd apache
###-a append ��-Gһ���ã������û��ĸ����飬centos��-a���Ǳ����


##nagios core###
tar zxvf nagios-4.1.1.tar.gz && cd nagios-4.1.1
./configure --with-command-group=nagcmd
make all
make install
make install-init
make install-config
make install-commandmode
make install-webconf

htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

##nagios-plugin###
tar zxvf nagios-plugins-2.1.1.tar.gz && cd nagios-plugins-2.1.1
./configure --with-nagios-user=nagios --with-nagios-group=nagios (--with-mysql=dir)
make && make install

###nrpe,�������Զ������###
tar zxvf nrpe-2.15.tar.gz && cd nrpe-2.15
./configure --with-nrpe-user=nagios --with-nrpe-group=nagios --with-nagios-user=nagios --with-nagios-group=nagios --enable-command-args --enable-ssl
make all
make install-plugin
make install-daemon
make install-daemon-config
##nrpe��װ��ɺ����/usr/local/nagios/libexec/������check_nrpe#
##�޸�objects/commands.cfg,����check_nrpe
define command{
        command_name check_nrpe
        command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}


#��������ļ������﷨����
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg


###ssh��Ĭ�϶˿�ʱ��μ��##
##�޸����������ļ�:
##localhost.cfg###
check_command                   check_ssh!5122 # !5122!����ӵ����ݣ�5122��ssh�Ķ˿�

###commands.cfg##
#"check_ssh"���"check_command"�Ƕ�����"commands.cfg"�е�,�����ʽ���£�
define command{
        command_name    check_ssh #�����check_ssh���Զ��������������ȫ������check_openssh��������
        command_line    $USER1$/check_ssh  -p $ARG1$ $HOSTADDRESS$ #��һ���е�check_sshָ�ľ���/usr/local/nagios/libexec/�µ�check_ssh,��һ���е�$ARG1$��ᱻ�滻Ϊ��������ĵ�һ������,Ҳ�����ϱ���ӵ�!5122!
        }


#����ض�
##nagios-plugin##
yum -y install gcc gcc-c++ make openssl openssl-devel 
useradd -s /sbin/nologin nagios
tar zxvf nagios-plugins-2.1.1.tar.gz && cd nagios-plugins-2.1.1
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make && make install

##nrpe###
tar zxvf nrpe-2.15.tar.gz && cd nrpe-2.15
./configure --with-nrpe-user=nagios --with-nrpe-group=nagios --with-nagios-user=nagios --with-nagios-group=nagios --enable-command-args --enable-ssl
make all
make install-plugin
make install-daemon
make install-daemon-config

##�޸�/usr/local/nagios/etc/nrpe.cfg
command[check_users]=/usr/local/nagios/libexec/check_users -w 5 -c 10
command[check_load]=/usr/local/nagios/libexec/check_load -w 15,10,5 -c 30,25,20
command[check_Data]=/usr/local/nagios/libexec/check_disk -w 20% -c 10%  /Data
command[check_zombie_procs]=/usr/local/nagios/libexec/check_procs -w 5 -c 10 -s Z
command[check_total_procs]=/usr/local/nagios/libexec/check_procs -w 150 -c 200 
command[check_ssh]=/usr/local/nagios/libexec/check_ssh -p 5122 localhost
command[check_ping]=/usr/local/nagios/libexec/check_ping -H localhost -w 100.0,20% -c 500.0,60% -p 5
command[check_swap]=/usr/local/nagios/libexec/check_swap -w 20 -c 10

##����nrpe##
/usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d -4

## ����ǽҪ����tcp 5666�˿�##





###Զ�����������ļ�����###
define service{
        use                             local-service         ; Name of service template to use
        host_name                       no_in_use
        service_description             SSH
        check_command                   check_nrpe!check_ssh
        notifications_enabled           0
        }

####check_nrpe!check_ssh##
##ͨ��nrpeִ��Զ��������check_ssh�������ؽ��������check_ssh������Զ��������nrpe.cfg�ж�����Ǹ�check_ssh##
