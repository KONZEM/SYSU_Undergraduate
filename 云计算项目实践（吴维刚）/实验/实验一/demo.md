# 一、实验简介
### 1.1 实验目标
  本实验的主要目标是学习和实现单机版的hadoop在Linux环境下的安装和配置

### 1.2 实验环境和时间安排
Ubuntu 18.04 64位 作为系统环境
hadoop 2.7.0
一周内完成
### 1.3 涉及知识点和基本知识
  当开始着手参与实践 Hadoop 时， Hadoop的安装和配置往往会成为新手的一道门槛。尽管安装简单，也有很多教程，但由于对 Linux 环境不熟悉，对hadoop的不熟悉，再加上网上不少教程不详细甚至有些还是是坑，导致新手折腾好几天没装好，对学习热情很是打击。本教程步骤详细，配图说明，只需按照步骤来，都能顺利完成hadoop的安装和配置。此外，也希望您能多了解些Linux的知识。

# 二、实验步骤
### 2.1创建hadoop用户
首先打开终端窗口，输入如下命令创建hadoop用户，这条命令创建可以登录的hadoop用户，并使用/bin/bash作为shell：
```bash
$ sudo useradd -m hadoop -s /bin/bash
```
接着为hadoop设置登录密码，可简单设为123456，按提示输入两次：
```bash
$ sudo passwd hadoop
```
为 hadoop 用户增加管理员权限，方便安装配置：
```bash
$ sudo adduser hadoop sudo
```
切换至hadoop用户，hadoop的安装和配置都是在hadoop用户下进行，提示时输入hadoop的用户名密码123456：
```bash
$ su hadoop
```
![](https://www.easyhpc.net/static/upload/md_images/20180531195428.png)

### 2.2更新apt
切换hadoop用户后需要更新一下apt-get，因为后续需要 apt 安装软件，如果没更新可能有一些软件安装不了。
```bash
$ sudo apt-get update
```
后续需要编辑一些配置文件，安装vim工具：
```bash
$ sudo apt-get install -y vim
```
![](https://www.easyhpc.net/static/upload/md_images/20180531195434.png)
### 2.3安装SSH、配置SSH无密码登录
1、hadoop不管是集群、单机版都需要用到 SSH 登陆，系统默认已安装了 SSH client，此外还需要安装 SSH server：
```bash
$ sudo apt-get install openssh-server
```
2、安装后，尝试登陆本机，提示时输入yes,然后按提示输入密码123456：
```bash
$ ssh localhost
```
![](https://www.easyhpc.net/static/upload/md_images/20180531195443.png)

3、在hadoop中，我们需要配置成SSH无密码登陆，首先退出输入exit，退出刚才的 ssh，回到我们原先的终端窗口，然后利用 ssh-keygen 生成密钥，并将密钥加入到授权中：
```bash
$ exit                           # 退出刚才的 ssh localhost
$ cd ~/.ssh/                     # 若没有该目录，请先执行一次ssh localhost
$ ssh-keygen -t rsa  # 会有提示，都按回车就可以
$ cat ./id_rsa.pub >> ./authorized_keys  # 加入授权
```
![](https://www.easyhpc.net/static/upload/md_images/20180531195448.png)

4、此时再用 ssh localhost 命令，无需输入密码就可以直接登陆了，如下图所示：
```bash
$ ssh localhost
$ exit
```
![](https://www.easyhpc.net/static/upload/md_images/20180531195454.png)

### 2.4安装java环境
hadoop的运行依赖java环境，使用下面的命令，如果出现以下输出，说明没有安装java
```bash
$ java -version
```
使用以下命令安装java：
```bash
$ sudo apt-get install -y  default-jdk
```
查询java版本，系统响应已安装的java版本时，代表已经成功安装了jdk：
```bash
$ java -version
```
![](https://www.easyhpc.net/static/upload/md_images/20180531195524.png)

### 2.5安装hadoop
hadoop可以到官网下载，首先访问hadoop官网https://archive.apache.org/dist/hadoop/common/ 找到Hadoop相应的版本，然后复制其版本连接：
![](https://www.easyhpc.net/static/upload/md_images/20180531155357.png)

![](https://www.easyhpc.net/static/upload/md_images/20180531154638.png)

在终端中执行命令下载hadoop (wget 后面的链接就是刚才复制的hadoop链接)：
```bash
$ cd  /usr/local/
$ sudo wget
```
![](https://www.easyhpc.net/static/upload/md_images/20180531195537.png)

解压文件并重命名：
```bash
$ sudo tar -zxvf hadoop-2.7.0.tar.gz 
$ sudo mv ./hadoop-2.7.0/ ./hadoop      # 将文件夹名改为hadoop
$ sudo chown -R hadoop ./hadoop
```

### 2.6配置hadoop环境
查看java的安装路径，从图可以得知，java安装在/usr/lib/jvm/java-11-openjdk-amd64：
```bash
$ update-alternatives --display Java
```
![](https://www.easyhpc.net/static/upload/md_images/20180531195613.png)

编辑~/.bashrc：
```bash
$ sudo vim ~/.bashrc
```
按“insert”建，如图输入如下内容（复制粘贴即可）：
```bash
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export HADOOP_HOME=/usr/local/hadoop
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="-DJava.library.path=$HADOOP_HOME/lib"
export JAVA_LIBRARY_PATH=$HADOOP_HOME/lib/native:$JAVA_LIBRARY_PATH
```
![](https://www.easyhpc.net/static/upload/md_images/20180531195630.png)

编辑完之后按“Esc”键，输入“:wq”退出。然后让~/.bashrc设置生效。
```bash
$ source ~/.bashrc
```

编辑hadoop-env.sh文件（和上面两个步骤一样）
```bash
$ sudo vim /usr/local/hadoop/etc/hadoop/hadoop-env.sh
```
在hadoop-env.sh中export JAVA_HOME后面添加以下信息(JAVA_HOME路径改为实际路径)：
```bash
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/
```
![](https://www.easyhpc.net/static/upload/md_images/20180602151348.png)

保存之后运行下面命令使配置生效
```bash
$ source /usr/local/hadoop/etc/hadoop/hadoop-env.sh
```
查看java和hadoop环境配置
如图，输入命令查看java和hadoop版本信息，说明环境配置成功

```bash
$ java -version
$ $JAVA_HOME/bin/java -version
$ hadoop version
```
![](https://www.easyhpc.net/static/upload/md_images/20180531193157.png)

### 2.7测试
在hadoop目录下新建input文件夹
```bash
$ cd /usr/local/hadoop
$ sudo mkdir input
```
将etc中的所有文件拷贝到input文件夹中
```bash
$ sudo cp -r  etc/*  input
```
![](https://www.easyhpc.net/static/upload/md_images/20180531195933.png)

在hadoop目录下运行wordcount程序，并将结果保存到output中(注意input所在路径、jar所在路径)
```bash
$ hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.0.jar wordcount  input/hadoop output
```
![](https://www.easyhpc.net/static/upload/md_images/20180602151506.png)

会看到conf所有文件的单词和频数都被统计出来。
```bash
$ cat output/*
```
![](https://www.easyhpc.net/static/upload/md_images/20180602151500.png)

注意的是，因为hadoop无法覆盖原来的文件，所以当执行了一次程序后想再次执行，需要手动删除output文件夹。

# 三、实验小结
  本实验主要学习了Linux环境下hadoop单机版的安装和配置，以及一些依赖环境：java和ssh免密登录的安装设置，最后做了一下简单测试，从结果来看，只要是按照实验步骤一步一步实施，是可以完成实验的。本实验最主要的还是要有些Linux命令的知识。