tar jxvf pdsh-2.29.tar.bz2 && cd pdsh-2.29

./configure --with-ssh --without-rsh --with-dshgroups && make && make install


pdsh -R ssh -w 192.168.119.130 [-l root] uptime
pdsh -R ssh -w 192.168.119.13[0-9] -x 192.168.119.135 uptime
#-x �ų�

#����������,�����ļ�Ϊ /etc/dsh/group/webs����~/.dsh/group/webs

pdsh -R ssh -g webs [-l root] uptime


#pdcp��ǰ����Ҫÿ���ڵ�Ҳ��װpdsh

pdcp -R ssh -g webs  /home/1 /tmp/

#���һ������  alias pdsh='pdsh -R ssh'���Լ򻯲���
 
