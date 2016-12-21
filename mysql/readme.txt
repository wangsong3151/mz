����mysql�Ĳ�ѯ����

mysql> show global status like 'qcache%';  
+-------------------------+-----------+  
| Variable_name | Value |  
+-------------------------+-----------+  
| Qcache_free_blocks | 22756 |  
| Qcache_free_memory | 76764704 |  
| Qcache_hits | 213028692 |  
| Qcache_inserts | 208894227 |  
| Qcache_lowmem_prunes | 4010916 |  
| Qcache_not_cached | 13385031 |  
| Qcache_queries_in_cache | 43560 |  
| Qcache_total_blocks | 111212 |  
+-------------------------+-----------+ 
MySQL��ѯ����������ͣ�
Qcache_free_blocks�������������ڴ��ĸ�������Ŀ��˵����������Ƭ��FLUSH QUERY CACHE��Ի����е���Ƭ���������Ӷ��õ�һ�����п顣
Qcache_free_memory�������еĿ����ڴ档
Qcache_hits��ÿ�β�ѯ�ڻ���������ʱ������
Qcache_inserts��ÿ�β���һ����ѯʱ���������д������Բ���������ǲ��б��ʡ�
Qcache_lowmem_prunes����������ڴ治�㲢�ұ���Ҫ���������Ա�Ϊ�����ѯ�ṩ�ռ�Ĵ��������������ó�ʱ������;�����������ڲ����������ͱ�ʾ������Ƭ�ǳ����أ������ڴ���١�(����� free_blocks��free_memory���Ը����������������)
Qcache_not_cached�����ʺϽ���MySQL��ѯ���������ͨ����������Щ��ѯ���� SELECT ����������now()֮��ĺ�����
Qcache_queries_in_cache����ǰ����Ĳ�ѯ(����Ӧ)��������
Qcache_total_blocks�������п��������
�����ٲ�ѯһ�·���������query_cache�����ã�

mysql> show variables like 'query_cache%';  
+------------------------------+-----------+  
| Variable_name | Value |  
+------------------------------+-----------+  
| query_cache_limit | 2097152 |  
| query_cache_min_res_unit | 4096 |  
| query_cache_size | 203423744 |  
| query_cache_type | ON |  
| query_cache_wlock_invalidate | OFF |  
+------------------------------+-----------+ 
���ֶεĽ��ͣ�
query_cache_limit�������˴�С�Ĳ�ѯ��������
query_cache_min_res_unit����������С��С
query_cache_size����ѯ�����С
query_cache_type���������ͣ���������ʲô���Ĳ�ѯ��ʾ���б�ʾ������ select sql_no_cache ��ѯ
query_cache_wlock_invalidate�����������ͻ������ڶ�MyISAM�����д����ʱ�������ѯ��query cache�У��Ƿ񷵻�cache������ǵ�д��������ٶ����ȡ�����
query_cache_min_res_unit��������һ����˫�н�����Ĭ����4KB������ֵ��Դ����ݲ�ѯ�кô����������Ĳ�ѯ����С���ݲ�ѯ������������ڴ���Ƭ���˷ѡ�
��ѯ������Ƭ�� = Qcache_free_blocks / Qcache_total_blocks * 100%
�����ѯ������Ƭ�ʳ���20%��������FLUSH QUERY CACHE��������Ƭ���������Լ�Сquery_cache_min_res_unit�������Ĳ�ѯ����С�������Ļ���
��ѯ���������� = (query_cache_size - Qcache_free_memory) / query_cache_size * 100%
��ѯ������������25%���µĻ�˵��query_cache_size���õĹ��󣬿��ʵ���С;��ѯ������������80%���϶���Qcache_lowmem_prunes > 50�Ļ�˵��query_cache_size�����е�С��Ҫ��������Ƭ̫�ࡣ
��ѯ���������� = (Qcache_hits - Qcache_inserts) / Qcache_hits * 100%
ʾ�������� ��ѯ������Ƭ�� = 20.46%����ѯ���������� = 62.26%����ѯ���������� = 1.94%�������ʺܲ����д�����Ƚ�Ƶ���ɣ����ҿ�����Щ��Ƭ��