��������� RHEL �ĸ������������ܡ��߿ɿ��ԣ�����Ҫ��������(�ؼ������)����������¹��ܣ���ô Fedora Project �Ƴ��� EPEL(Extra Packages for Enterprise Linux)�����ʺ��㡣EPEL(http://fedoraproject.org/wiki/EPEL) ���� Fedora �������죬Ϊ RHEL ���������а��� CentOS��Scientific Linux ���ṩ���������������Ŀ

## centos 7
yum install epel-release
yum repolist
yum --disablerepo="*" --enablerepo="epel" list available




###CentOS/RedHat 6
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6


###CentOS/RedHat 5

rpm -ivh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
rpm -ivh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL
