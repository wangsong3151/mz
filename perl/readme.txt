tar zxvf perl-5.22.1.tar.gz

cd perl-5.22.1

./Configure -des -Dprefix=/usr/local/perl

make 

make install

mv /usr/bin/perl /usr/bin/perl.bak

ln -s /usr/local/perl/bin/perl /usr/bin/perl


#���ģ��

perl -MCPAN -e shell

cpan> install xxx
