##CentOS-

#��������װ
yum install hmaccalc ncurses-devel zlib-devel openssl-devel python-devel bridge-utils libtool-ltdl iasl xorg-x11-drv-evdev xorg-x11-drv-fbdev xorg-x11-drv-i810-devel xorg-x11-drv-via-devel xorg-x11-proto-devel xorg-x11-server-sdk xorg-x11-xtrans-devel

# flex  bison(��װacpica��Ҫ)
yum install flex bison

#��װacpi ca (https://acpica.org/downloads)
#���������԰�װ���°棬��δ�ɹ��������������⣬��ͨ������߰汾Ϊacpica-unix-20130823.tar.gz

tar zxvf acpica-unix-20130823.tar.gz && cd acpica-unix-20130823
make 
make install

# ��װ Xen hypervisor �� tools

# ���Ȱ�װ����������dev86��uuid��glib��yajl��git��texinfo)
#wget  http://rdebath.nfshost.com/dev86/Dev86bin-0.16.19.tar.gz

#tar zxvf Dev86bin-0.16.19.tar.gz  && cd  usr

#cp lib/* /usr/lib
#cp bin/* /usr/binyum install dev86yum install libuuid libuuid-devel
yum install glib2 glib2-devel
yum install yajl yajl-devel
yum install git
yum install texinfo
#xen��װ�����л�ʹ��git�������ݣ������������

#xen��װ

tar zxvf  xen-4.3.1.tar.gz  && cd xen-4.3.1

make xen tools stubdom

make install-xen install-tools install-stubdom


# ����linux�ںˣ�ʹ֧֮��xen

xz -d linux-3.11.8.tar.xz && tar xvf linux-3.11.8.tar && cd linux-3.11.8

make menuconfig

#ѡ��������

Processor type and features--> Linux guest support--> Xen guest support

Device Drivers-->Network device support-->Xen network device frontend driver/Xen backend network device

Device Drivers-->Block devices-->Xen virtual block device support/Xen block-device backend driver

Device Drivers-->Xen driver support

make

make modules

make modules_install

make install

depmod 3.11.8

# �޸������ļ���ʹ��xen����ϵͳ

vi /etc/grub.conf

title CentOS6.0 (linux-3.11.8-xen)
kernel /xen.gz               
module /vmlinuz-3.11.8 ro root=/dev/sda3
module /initramfs-3.11.8.img

# ���/boot���ǵ��������Ļ���kernel /boot/xen.gz  modules /boot/vmlinuz-3.11.8

# ����ϵͳ

reboot
