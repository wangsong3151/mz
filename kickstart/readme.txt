kickstart������

#��װhttp/vsftp/nfs(pxe֧������������һ�ַ�ʽ��ȡ��װ�ļ�)

#��װdhcp

ddns-update-style none;

ignore client-updates;
subnet 192.168.127.0 netmask 255.255.255.0 {
        option routers 192.168.127.2;
        option subnet-mask 255.255.255.0;
        option domain-name "ipw.com";
        option domain-name-servers 192.168.127.2;
        range 192.168.127.139 192.168.127.150;
        filename "pxelinux.0"    #������Ҫ�ģ�pxe client����dhcp����������ip��ַ������dhcp�������ϵ�tftp������������pxelinux.0(bootloader)ȡ�ر���ִ�С�
	default-lease-time 21600;
        max-lease-time 43200;
	#�̶�ip����
        #host ipw2 {
        #       hardware ethernet 00:0C:29:8F:81:FB;
        #       fixed-address 192.168.127.130;
        #}
}

#��װtftp

yum install tftp-server

vi /etc/xinetd.d/tftp

# default: off
# description: The tftp server serves files using the trivial file transfer \
#       protocol.  The tftp protocol is often used to boot diskless \
#       workstations, download configuration files to network-aware printers, \
#       and to start the installation process for some operating systems.
service tftp
{
        socket_type             = dgram
        protocol                = udp
        wait                    = yes
        user                    = root
        server                  = /usr/sbin/in.tftpd
        server_args             = -s /var/lib/tftpboot
        disable                 = no  #�����Ϊno,��tftp��xinetd����
        per_source              = 11
        cps                     = 100 2
        flags                   = IPv4
}

#����xinetd

/etc/init.d/xinetd start

#����ISO����

mount -o loop /path/xxx.iso  /data/www/centos #�����õ���http��ʽ

#���Ʊ�Ҫ�ļ���tftpboot

cp /usr/share/syslinux/pxelinux.0  /var/lib/tftpboot  #����pxe��ʽ��bootloader,��Ҫ��װsyslinux(yum install syslinux)

cp /data/www/centos/images/pxeboot/initrd.img /var/lib/tftpboot 

cp /data/www/centos/images/pxeboot/vmlinuz /var/lib/tftpboot

# ����bootloader,Ҳ����pxelinux.0����Ҫ�Ĳ����ļ���û�в����ļ�����װֻ��ͣ����boot>����

mkdir /var/lib/tftpboot/pxelinux.cfg

cp /data/www/centos/isolinux/isolinux.cfg /var/lib/tftpboot/pxelinux.cfg/default  #bootloaderҪ���ļ��ز���ϵͳ�ں���������װ������������ļ���ָ���ġ�

#derault������

default text
prompt 1
timeout 600

display boot.msg

menu background splash.jpg
menu title Welcome to CentOS 6.4!
menu color border 0 #ffffffff #00000000
menu color sel 7 #ffffffff #ff000000
menu color title 0 #ffffffff #00000000
menu color tabmsg 0 #ffffffff #00000000
menu color unsel 0 #ffffffff #00000000
menu color hotsel 0 #ff000000 #ffffffff
menu color hotkey 7 #ffffffff #ff000000
menu color scrollbar 0 #ffffffff #00000000

label text
kernel vmlinuz
append ks=http://192.168.127.129/ks.cfg initrd=initrd.img #���������bootloaderҪ���ص��ں��ļ���������װ��Ȼ����߿ͻ���ks.cfg�����ks.cfg����߰�װ������Ѱ�Ұ�װ�ļ����Լ���Ҫ��װ��Щ�׼��������ڰ�װ��ɺ���Ҫִ����Щ������


����pxe��װ�������������ģ�

�ͻ�����������pxe��������ip��ַ�����䵽ip��ַ������tftp�ӷ���˻�ȡbootloader,����bootloader�ͽ����˰�װ���棬����Ҫ���ص��ں��ļ����ģ�pxelinux.0�Ĳ����ļ�Ҳ����default�������������ص����ں��ļ��Ϳ���������װ�ˣ���������Ҫ�İ�װ�ļ����ģ�����default�ļ���ָ����ks=xxxx/ks.cfg,ks.cfg�����þ��Ǹ��߰�װ��������ȥѰ�Ұ�װ�ļ���������Ҫ��װ��Щ�׼��Լ���װ�����������Ĳ����������������ʽ������װ���ԡ�ʱ��ѡ��ȵȡ�



�������μ��ص��ļ��� pxelinux.0  --> default --->ks.cfg
#kickstartѡ��˵��
http://man.ddvip.com/os/redhat9.0cut/s1-kickstart2-options.html


#####CentOS 7#####

�������һ�£���������������Ʊ�Ҫ�ļ���tftpboot(pxelinux.0 initrd.img vmlinuz default),Ҫע��6��7���⼸���ļ��ǲ���ͨ�õ�

# CentOS 7�� default

default text
timeout 30

display boot.msg

# Clear the screen when exiting the menu, instead of leaving the menu displayed.
# For vesamenu, this means the graphical background is still displayed without
# the menu itself for as long as the screen remains in graphics mode.
menu clear
menu background splash.png
menu title CentOS 7
menu vshift 8
menu rows 18
menu margin 8
#menu hidden
menu helpmsgrow 15
menu tabmsgrow 13

# Border Area
menu color border * #00000000 #00000000 none

# Selected item
menu color sel 0 #ffffffff #00000000 none

# Title bar
menu color title 0 #ff7ba3d0 #00000000 none

# Press [Tab] message
menu color tabmsg 0 #ff3a6496 #00000000 none

# Unselected menu item
menu color unsel 0 #84b8ffff #00000000 none

# Selected hotkey
menu color hotsel 0 #84b8ffff #00000000 none

# Unselected hotkey
menu color hotkey 0 #ffffffff #00000000 none

# Help text
menu color help 0 #ffffffff #00000000 none

# A scrollbar of some type? Not sure.
menu color scrollbar 0 #ffffffff #ff355594 none

# Timeout msg
menu color timeout 0 #ffffffff #00000000 none
menu color timeout_msg 0 #ffffffff #00000000 none

# Command prompt text
menu color cmdmark 0 #84b8ffff #00000000 none
menu color cmdline 0 #ffffffff #00000000 none

# Do not display the actual menu unless the user presses a key. All that is displayed is a timeout message.

menu tabmsg Press Tab for full configuration options on menu items.

menu separator # insert an empty line
menu separator # insert an empty line

label text
  menu label ^Install CentOS 7
  kernel vmlinuz
  append initrd=initrd.img inst.repo=http://10.10.67.168/pxe ks=http://10.10.67.168/ks.cfg


##���� 7��6��ks.cfgѡ��Ҳ����ͨ�ã�Ҫע���޸�
