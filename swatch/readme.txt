tar zxvf swatch-3.2.3.tar.gz

cd swatch-3.2.3

perl MakeFile.PL

#����ʾȱ��perlģ�飬�����Ȱ�װ��ʾ��ģ��

make 

make test

make install

make realclean


###

ʹ��

touch /root/swatchrc

vi /root/swatchrc

watchfor /[Ff]ail/

echo red

exec "psad --fw-block-ip ��������"

swatch -c /root/swatchrc -t /var/log/messages

