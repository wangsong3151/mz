�ϴ��ű���ģ��

�ű����

 ./get_nginx_clients_status.pl http://172.16.83.162/nginx_status/  #���е�IpΪ����ض�

������ʾȱ��perl��LWP::UserAgentģ�飬�����ģ��

perl -MCPAN -e shell

cpan[1]> install LWP::UserAgent


����ض˴�nginx��stub_status

location /nginx_status/ {

stub_status on;
accesslog off;
allow xxx;
deny all;
}