# /bin/bash
# Double_line_spacing
# usage: Double_line_spacing.sh [filename] [filename] ..
if [ $# -eq 0 ];then
	echo "Usage:`basename $0` [filename] [filenmae]"
	exit 1
fi
#�жϴ���Ĳ����Ƿ�Ϊ�ļ�
for i in `echo $*`
do
	if [ ! -f $i ];then
	echo "sorry,$i is not a file"
	#kill -9 $$
	exit 1
	fi
done

# ��һ����ÿ���������û���ͬʱ�������ļ�
while [ -n "$1" ] #�������""�����٣������жϻ������
#until [ -z "$1" ]
do
file=$1
echo "Filename: $1"
#�ļ��п���ԭ�����пհ��У��Ƚ���Щ�հ���ȥ������Ȼ����ĳЩ��֮����ֶ���հ���
sed '/^$/d' $1 
sed '/^$/d' $file | sed '$!G' 
shift
done
