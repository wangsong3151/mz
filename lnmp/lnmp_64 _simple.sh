#!/bin/bash
##lnmp_64.sh
# install nginx+php-fpm+mysql on centos X86_64
# you can custom sourcedir and app_dir,upload tarball to the $sourcedir ,then run this script
# php mysql will be installed to $app_dir
# modified by shidg    20150126

source_dir="/usr/local/src/lnmp/"
[ "$PWD" != "${source_dir}" ] && cd ${source_dir}

app_dir="/Data/app/"

function ERRTRAP {
    echo "[LINE:$1] Error: exited with status $?"
    kill $!
    exit 1
}

function dots {
    while true;do
        for cha in '-' '\\' '|' '/'
        do
            echo -ne "executing...$cha\r"
            sleep 1
        done
    done
}

function success {
    printf "%20s"
    echo -e "\rSuccessful!"
    kill $!
}

##########################
stty -echo

exec 6>&1
exec 7>&2
exec 2>/dev/null
#exec 1>&6 6>&-
#exec 2>&7 7>&-

trap 'kill $!;exit' 1 2 3 15
trap 'ERRTRAP $LINENO' ERR

if [ ! -d ${app_dir} ];then
    mkdir -p ${app_dir}
fi

echo "install dependent libraries"
dots &
exec 1>&2
yum -y install gcc gcc-c++ libtool ncurses ncurses-devel openssl openssl-devel libxml2 libxml2-devel bison libXpm libXpm-devel fontconfig-devel libtiff libtiff-devel curl curl-devel readline readline-devel bzip2 bzip2-devel  sqlite sqlite-devel zlib zlib-devel libpng-devel gd-devel freetype-devel
exec 1>&6
success
#ncurses  openssl bison Ϊ����mysql5����
#libXpm libXpm-devel fontconfig-devel libtiff libtiff-devel Ϊ��װgd��������

echo "install libiconv..."
dots &
exec 1>&2
tar zxvf libiconv-1.14.tar.gz && cd libiconv-1.14 && ./configure --prefix=/usr && make && make install
exec 1>&6
success

## for CentOS 7 ##
#tar zxvf libiconv-1.14.tar.gz && cd libiconv-1.14 && ./configure --prefix=/usr
#(cd /Data/software/lnmp/libiconv-1.14;make)
#sed  -i -e '/_GL_WARN_ON_USE (gets/a\#endif' -e '/_GL_WARN_ON_USE (gets/i\#if defined(__GLIBC__) && !defined(__UCLIBC__) && !__GLIBC_PREREQ(2, 16)' srclib/stdio.h
#make && make install

cd ..
echo "install libxslt..."
dots &
exec 1>&2
tar zxvf libxslt-1.1.28.tar.gz && cd libxslt-1.1.28
#�����/bin/rm: cannot remove `libtoolT��: No such file or directory ��
sed -i '/$RM "$cfgfile"/ s/^/#/' configure
./configure --prefix=/usr && make && make install
exec 1>&6
success

cd ..
echo "install libmcrypt"
dots &
exec 1>&2
tar zxvf libmcrypt-2.5.8.tar.gz && cd libmcrypt-2.5.8 && ./configure --prefix=/usr && make && make install
cd libltdl && ./configure --prefix=/usr/ --enable-ltdl-install && make && make install
exec 1>&6
success

cd ../../
echo "install mhash"
dots &
exec 1>&2
tar jxvf mhash-0.9.9.9.tar.bz2 && cd mhash-0.9.9.9 && ./configure && make && make install
exec 1>&6
success

echo "/usr/local/lib" >> /etc/ld.so.conf
ldconfig

cd ..
echo "install mcrypt"
dots &
exec 1>&2
tar zxvf mcrypt-2.6.8.tar.gz && cd mcrypt-2.6.8  && ./configure && make && make install
exec 1>&6
success

cd ..
echo "install libevent"
dots &
exec 1>&2
tar zxvf libevent-2.0.22-stable.tar.gz && cd libevent-2.0.22-stable && ./configure --prefix=/usr && make && make install
exec 1>&6
success

cd ..
echo "install re2c"
dots &
exec 1>&2
tar zxvf re2c-0.14.3.tar.gz && cd re2c-0.14.3 && ./configure && make && make install
exec 1>&6
success

cd ..
echo "install php"
dots &
exec 1>&2
tar jxvf php-5.6.14.tar.bz2 && cd php-5.6.14 && ./configure --prefix=${app_dir}php-5.6.14  --with-config-file-path=${app_dir}php-5.6.14/etc --with-libxml-dir --with-iconv-dir --with-png-dir --with-jpeg-dir --with-zlib --with-gd --with-freetype-dir --with-mcrypt=/usr --with-mhash --enable-gd-native-ttf  --with-curl --with-bz2 --enable-mysqlnd --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-openssl-dir --without-pear --enable-fpm --enable-mbstring --enable-soap --enable-xml --enable-pdo --enable-ftp  --enable-zip --enable-bcmath --enable-sockets --enable-opcache && make ZEND_EXTRA_LIBS='-liconv' && make install 
exec 1>&6
success

cd ..
echo "install mysql"
dots &
exec 1>&2
tar zxvf mysql-5.5.40-linux2.6-x86_64.tar.gz -C ${app_dir}
exec 1>&6
success

#openssl
#cd ext/openssl
#mv mv config0.m4 config.m4
#/usr/local/php/bin/phpize
#./configure --with-openssl --with-php-config=/usr/local/php/bin/php-config && make && make install
#cp /usr/local/php/lib/php/extensions/no-debug-non-zts-20090626/openssl.so /usr/local/php/ext
#cd ..

cd ..

#add sticky module
#https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/
echo "install nginx"
dots &
exec 1>&2
tar jxvf pcre-8.39.tar.bz2 && tar zxvf openssl-1.0.2h.tar.gz && tar zxvf nginx-1.8.1.tar.gz && cd nginx-1.8.1 && ./configure --prefix=${app_dir}nginx-1.8.1  --with-pcre=../pcre-8.39 --with-openssl=../openssl-1.0.2h --with-http_sub_module --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --add-module=../nginx-sticky-module-ng && make && make install

exec 1>&6 6>&-
exec 2>&7 7>&-
stty echo
echo -ne "OK,That is all!\nThanks \n"