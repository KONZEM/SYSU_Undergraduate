# 一、实验简介
本次实验的目的是在系统上部署Hive，了解其原理及使用。Hadoop是个开源的计算处理框架，可以处理大数据，可以利用大量的廉价机器组成算力超强的集群，提供可靠的，分布式的，弹性的计算。Hive是一个数据仓库基础工具，可以在Hadoop中用来处理结构化数据。
## 1.1实验目标
学会在Linux环境中部署、操作Hive。
## 1.2实验环境
Ubuntu 18.04 64位
MySQL
MySQL Connector/J
Java
Hadoop 2.10.0
Hive 2.3.6

## 1.3实验时间
一周内完成

# 二、实验步骤
## 2.1 MySQL的安装
1.安装MySQL软件包

```shell
sudo apt-get install mysql-server
```
注意：通过这种方式安装的MySQL，用户名是debian-sys-maint，初始密码是个随机字符串。在/etc/mysql/debian.cnf中找。找到之后，登陆数据库，更改root或者其它账户密码即可。如果mysql服务没有运行，要使用超级账号权限运行其服务。



2.登陆MySQL
```shell
mysql -udebian-sys-maint -p
```
输入用户密码（在/etc/mysql/debian.cnf中找)

## 2.2 Java环境配置
1.下载Java。

```shell
wget https://repo.huaweicloud.com/java/jdk/8u152-b16/jdk-8u152-linux-x64.tar.gz
```
2.解压tar包
```shell
# Untar
sudo tar -xzvf jdk-8u152-linux-x64.tar.gz -C /usr/local

# Rename
sudo mv /usr/local/jdk1.8.0_152 /usr/local/java
```

3.配置环境变量，在~/.bashrc中加入

```shell
export JAVA_HOME=/usr/local/java
export PATH=$PATH:$JAVA_HOME/bin
```
4.测试Java环境
```shell
java -version
```
5.如果能够输出版本信息，则Java环境部署成功。

## 2.3 Hadoop环境配置

参考之前的Hadoop安装教程。
用户为hadoop，需要设置ssh免密码登陆localhost。

## 2.4 Hive安装

1.下载Hive的tar包
```shell
wget https://mirrors.tuna.tsinghua.edu.cn/apache/hive/hive-2.3.6/apache-hive-2.3.6-bin.tar.gz
```
2.解压

```shell
sudo tar -xzvf apache-hive-2.3.6-bin.tar.gz -C /usr/local
```
3.重命名
```shell
sudo mv /usr/local/apache-hive-2.3.6-bin /usr/local/hive
```
4.环境变量设置

```shell
export HIVE_HOME=/usr/local/hive
```
5.更改文件归属用户

```shell
sudo chown -R hadoop:hadoop /usr/local/hive
```
6.配置Hive

说明：hive 有关于 metastore 具有三种配置，分别为内嵌模式、本地元存储以及远程
元存储。使用本地元存储。基于伪分布式Hadoop进行实验。

在/usr/local/hive/conf下创建文件hive-site.xml
注意配置好自己的MySQL数据库用户名及密码

```xml
<configuration>
<property>
  <name>javax.jdo.option.ConnectionURL</name>
  <value>jdbc:mysql://localhost:3306/hive?createDatabaseIfNotExist=true</value>
  <description>JDBC connect string for a JDBC metastore</description>
</property>
<property>
  <name>javax.jdo.option.ConnectionDriverName</name>
  <value>com.mysql.cj.jdbc.Driver</value>
  <description>Driver class name for a JDBC metastore</description>
</property>
<property>
  <name>javax.jdo.option.ConnectionUserName</name>
  <value>debian-sys-maint</value>
  <description>username to use against metastore database</description>
</property>
<property>
  <name>javax.jdo.option.ConnectionPassword</name>
  <value>123456</value>
  <description>password to use against metastore database</description>
</property>
<property>
        <name>hive.metastore.warehouse.dir</name>
        <value>/usr/local/hive/warehouse</value>
</property>
<property>
    	<name>hive.metastore.local</name>
        <value>true</value>
</property>
<property>
        <name>hive.metastore.schema.verification</name>
        <value>false</value>
</property>

<property>
    <name>hive.support.concurrency</name>
    <value>true</value>
  </property>
    <property>
    <name>hive.enforce.bucketing</name>
    <value>true</value>
  </property>
    <property>
    <name>hive.exec.dynamic.partition.mode</name>
    <value>nonstrict</value>
  </property>
  <property>
    <name>hive.txn.manager</name>
    <value>org.apache.hadoop.hive.ql.lockmgr.DbTxnManager</value>
  </property>
    <property>
    <name>hive.compactor.initiator.on</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.compactor.worker.threads</name>
    <value>1</value>
  </property>
  <property>
	<name>hive.in.test</name>
	<value>true</value>
    </property>
</configuration>
```
6.检查 jline 版本，hive 与 hadoop 的 jline 版本不对应可能导致运行错误，将 hive 上 jline 的 jar 包拷贝至 hadoop 的对应目录下

```shell
cp /usr/local/hive/lib/jline-2.12.jar /usr/local/hadoop/share/hadoop/yarn/lib
```
7.Hive配置文件中的hadoop_env.sh需要配置，添加一行

```shell
export HADOOP_HOME=/usr/local/hadoop
```

8.在hdfs上创建warehouse

```shell
hdfs dfs –mkdir /hive/warehouse
```
9.在hadoop上配置yarn-site.xml
```xml
<configuration>

<!-- Site specific YARN configuration properties -->
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.env-whitelist</name>
        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
    </property>

    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>127.0.0.1</value>
    </property>

    <property>
        <name>yarn.resourcemanager.address</name>
        <value>127.0.0.1:8032</value>
    </property>

    <property>
        <name>yarn.resourcemanager.scheduler.address</name>
        <value>127.0.0.1:8030</value>
    </property>
    <property>
        <name>yarn.resourcemanager.resource-tracker.address</name>
        <value>127.0.0.1:8031</value>
    </property>
</configuration>
```
10.启动Hadoop
```shell
/usr/local/hadoop/sbin/start-all.sh 
```
11.初始化 Schema
```shell
./hive/bin/schematool -dbType mysql -initSchema
```
如果用的数据库是-dbType用于指定数据库类型，这里是mysql

12.服务端启动 metastore

```shell
hive --service metastore
```

13.客户端启动Hive
```shell
hive
```

## 2.5 Hive操作
### 1.准备数据。样例：

```shell
1201 Gopal 45000 RD
1202 Manisha 45000 RD
1203 Masthaa 40000 QA
1204 Kiran 40000 HR
1205 Kranthi 30000 PM
1206 Liuyi 50000 PM
1308 Siyan 45000 QA
1403 Ruichen 50000 Admin
1401 Xintian 50000 Admin
1308 Yihuan 60000 Board
1301 Zichen 55000 RD
1302 MaChao 60000 RD
```
可以上传到用户家目录下。如/home/hadoop

### 2.登入Hive客户端
创建数据库：

```sql
create database companies;
```

显示数据库以及表：
```sql
show databases;
show tables;
```

创建数据表：
```shell
hive> 
create table employee(eid int, name string, salary string, dept string)
row format delimited
fields terminated by '\t'
lines terminated by '\n';
```
语法类似SQL语法

###3.把数据加载到表里。
1.本地模式
```shell
load data local inpath '/home/hadoop/emp.txt' into table employee;
```
2.HDFS导入模式
把上述语句中的local去掉即可。

3.查询数据
```sql
select * from employee;
```
4.通过查询结果建表
```sql
create table dept_admin 
as
select eid, name, salary from employee
where dept='Admin';
select * from dept_admin;
```


Hive的配置文件需要根据机器部署情况更改，具体可以到网上搜一搜配置文件。

### 4.实验要求
1.能够成功安装Hive（附上运行截图以及配置文件）
2.能够对数据库表进行增删改查（数据库表里加入自己的姓名作为作业标识）
3.附加加分项：将Hadoop下所有配置文件用MapReduce统计好词频后，存入Hive
4.附加加分项：配置不同Metastore存储模式

# 三、实验小结
本次实验主要实践了Hive的安装与部署。

