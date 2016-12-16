#apache/tomcat��װ������

##һЩ����###

#apache��װĿ¼
APACHE_PREFIX=/Data/app/apache

#apache�����ļ�
APACHE_CONF=/etc/httpd/httpd.conf

#tomcat ��װĿ¼
TOMCAT1_PREFIX=/Data/app/tomcat1
TOMCAT2_PREFIX=/Data/app/tomcat2
#tomcat��Ŀ¼
TOMCAT_ROOT=/Data/code


# Ϊtomcat�����Ŀ��Ҳ��������tomcat��Ŀ¼,�޸�$TOMCAT_PREFIX/conf/server.xml
# ��<Host></Host>�����Context,��������Ϊ/Data/code/
<Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
<Context path="" docBase="/Data/code"></Context>
.....
.....
</Host>


#jk��װ��apache tomcat ��������

wget  http://archive.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.39-src.tar.gz

tar zxvf tomcat-connectors-1.2.39-src.tar.gz && cd tomcat-connectors-1.2.39-src/native

./configure --with-apxs=/Data/app/apache/bin/apxs --with-java-home=/Data/app/jdk

make # mod_jk.so��������apache��װĿ¼�µ�modulesĿ¼


#��װtomcat native��������tomcat������־�л��й���libnative�ı���

cd /Data/app/tomcat/bin  # tomcat ��װĿ¼�µ�binĿ¼

tar zxvf tomcat-native.tar.gz && cd tomcat-native-1.1.29-src/jni/native

./configure --with-apr=/Data/app/apr/bin/apr-1-config --with-ssl=/usr/local/ssl/

make && make install

cp  /usr/local/apr/lib/libtcnative* /usr/lib  #������/usr/lib  /usr/lib64��λ�ö��ɣ��ο�tomcat������־



#�������tomcat�������������tomcat��Ҫע���޸�tomcat�˿ڣ�server.xml��8080,8005,8009�˿ڶ�Ҫ�����ͻ����Ȼ�޷��������tomcat

#���豾����װ������tomcat�ֱ�Ϊ$TOMCAT1_PREFIX��$TOMCAT2_PREFIX,ȷ�϶˿��޳�ͻ������
$TOMCAT1_PREFIX/bin/catalina.sh start
$TOMCAT2_PREFIX/bin/catalina.sh start

#����apache��Ϊǰ�ˣ�������ת�������tomcat��Ⱥ

#��/etc/httpd/extraĿ¼�´���mod_jk.conf,�ļ�����Ϊ��

LoadModule jk_module modules/mod_jk.so  #����mod_jkģ��
JkWorkersFile /etc/httpd/extra/workers.properties  #����ļ������õ���tomcat��Ⱥ�����ؾ���
JkMountFile /etc/httpd/extra/uriworkermap.properties  # �������õ���ת�����򣬼���Щ��apache�Լ�������Щ����tomcat
JkLogFile logs/mod_jk.log
JkLogLevel info

#��extra�´���workers.properties��uriworkermap.properties

####################################
##file name workers.properties####
worker.list=tomcatserver,status  # tomcatserverΪ���������ƣ��Զ���
# localhost server 1
# ------------------------
worker.s1.port=8009       #s1��Ϊtomcat��������ƣ����tomcat���ó�ͻ
worker.s1.host=localhost
worker.s1.type=ajp13
worker.s1.lbfactor = 1    #�ڼ�Ⱥ�е�Ȩ��
# localhost server 2
# ------------------------
worker.s2.port=8010       #s2������ͬs1
worker.s2.host=localhost
worker.s2.type=ajp13
worker.s2.lbfactor = 1

#-----------------------------
worker.tomcatserver.type=lb   #���ؾ������ͣ�
worker.retries=3
worker.tomcatserver.balance_workers=s1,s2   #s1,s2�����ϱ߶��������
worker.tomcatserver.sticky_session=false  #����session���ƣ���ѡ�����Ϊfalse,���Ϊtrue�����ʾͬһ�û������󲻻��ڶ��tomcat֮���ƶ����̶���һ��tomcat����
worker.tomcatserver.sticky_session_force=1 #Ĭ��tomcat �޷�Ӧ���Ƿ�����ת������tomcat
worker.status.type=status




##########################################
#####file name uriworkermap.properties####
/*=tomcatserver             #����������controller���server����
/jkstatus=status           #���а���jkstatus����Ķ���status���server����
!/*.gif=tomcatserver         #������.gif��β�����󶼲���tomcatserver���server�������¼�������һ������˼
!/*.jpg=tomcatserver
!/*.png=tomcatserver
!/*.css=tomcatserver
!/*.js=tomcatserver
!/*.htm=tomcatserver
!/*.html=tomcatserver


#�޸�$APACHE_CONF��

Include /etc/httpd/extra/mod_jk.conf

#����httpd

#����apache�Ѿ�����ʹ��jk��ʽ��tomcatͨ�ţ����ҽ�����ƽ���ַ���s1,s2����tomcat.����װjk�Ļ�,apache����ʹ��proxy��ʽ��tomcatͨ��


#���tomcat session����,���ֿͻ��˻Ự

# �޸�$TOMCAT1_PREFIX/conf/server.xml��$TOMCAT2_PREFIX/conf/server.xml

#####TOMCAT1_PREFIX/conf/server.xml######

<Engine name="Catalina" defaultHost="localhost" jvmRoute="s1">  #jvmRoute�������ã�s1��workers.properties�����õ�����һ�£���һ��ΪjvmRoute="s2"

      <!--For clustering, please take a look at documentation at:
          /docs/cluster-howto.html  (simple how to)
          /docs/config/cluster.html (reference documentation) -->
      <!--
      <Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"/>
      -->

        <Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"
                 channelSendOptions="8">

          <Manager className="org.apache.catalina.ha.session.DeltaManager"
                   expireSessionsOnShutdown="false"
                   notifyListenersOnReplication="true"/>

          <Channel className="org.apache.catalina.tribes.group.GroupChannel">
            <Membership className="org.apache.catalina.tribes.membership.McastService"
                        address="228.0.0.4"
                        port="45564"
                        frequency="500"
                        dropTime="3000"/>
<Receiver className="org.apache.catalina.tribes.transport.nio.NioReceiver"
                      address="auto"      #auto�Ļ��������127.0.0.1��
                      port="4000"         #����˿ں�����tomcat���벻һ�£����ó�ͻ
                      autoBind="100"
                      selectorTimeout="5000"
                      maxThreads="6"/>

            <Sender className="org.apache.catalina.tribes.transport.ReplicationTransmitter">
              <Transport className="org.apache.catalina.tribes.transport.nio.PooledParallelSender"/>
            </Sender>
            <Interceptor className="org.apache.catalina.tribes.group.interceptors.TcpFailureDetector"/>
            <Interceptor className="org.apache.catalina.tribes.group.interceptors.MessageDispatch15Interceptor"/>
          </Channel>

          <Valve className="org.apache.catalina.ha.tcp.ReplicationValve"
                 filter=""/>
          <Valve className="org.apache.catalina.ha.session.JvmRouteBinderValve"/>

          <Deployer className="org.apache.catalina.ha.deploy.FarmWarDeployer"
                    tempDir="/tmp/war-temp/"
                    deployDir="/tmp/war-deploy/"
                    watchDir="/tmp/war-listen/"
                    watchEnabled="false"/>
					<ClusterListener className="org.apache.catalina.ha.session.JvmRouteSessionIDBinderListener"/>
          <ClusterListener className="org.apache.catalina.ha.session.ClusterSessionListener"/>
        </Cluster>


# ��$TOMCAT_ROOT�´���WEB-INFĿ¼��WEB-INFĿ¼�´���web.xml

<web-app xmlns="http://java.sun.com/xml/ns/javaee"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://java.sun.com/xml/ns/javaee
                      http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
  version="3.0"
  metadata-complete="true">

  <display-name>Welcome to Tomcat</display-name>
  <description>
     Welcome to Tomcat
  </description>
<distributable/>    #������������ǩ
</web-app>


# ��������tomcat

		
		
route add -net 224.0.0.0 netmask 240.0.0.0 dev eth0