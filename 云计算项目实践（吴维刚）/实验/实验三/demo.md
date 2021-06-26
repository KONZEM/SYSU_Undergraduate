# 实验三：Spark安装部署与基础实践

## 1、实验目的
（1）掌握Spark基本知识，通过实践进一步了解Spark相关知识。
（2）从零开始，一步步完成 Spark 的环境搭建以及安装测试。

## 2、实验内容及时间安排
（1）配置和测试Spark。
（2）实验时间大概两周。

## 3、实验步骤和操作
(1) Java安装。

`sudo apt install openjdk-8-jdk-headless`

  随后终端询问是否继续安装，如图：
 
 ![image.png](https://www.easyhpc.net/static/upload/md_images/20180601213906.png)

  输入“y”后，按回车，等待Jdk安装完成。
  测试 Java 是否安装成功:
  
  `java -version`
 ![image.png](https://www.easyhpc.net/static/upload/md_images/20180601214231.png)

(2) 下载 Spark 二进制安装包。
  
  `wget http://mirror.bit.edu.cn/apache/spark/spark-2.4.5/spark-2.4.5-bin-hadoop2.7.tgz`
  
  解压命令：`tar -xzvf spark-2.4.5-bin-hadoop2.7.tgz`

(3) 测试 Spark 是否安装成功

首先进入到刚刚解压出来的 Spark 目录：

`cd spark-2.3.0-bin-hadoop2.7`

运行 Spark 的示例程序：`./bin/run-example SparkPi 10`

该命令将在本地单机模式下执行 SparkPi 这个示例。在该模式下，所有Spark进程均运行于同一个 JVM 中，而并行处理则通过多线程来实现，而本次命令将线程数指定为10。示例运行完，应可在输出的结尾看到类似如下的提示：

![image.png](https://www.easyhpc.net/static/upload/md_images/20180602151551.png)

上图显示，Pi算出来的数值为3.1426511426511428。

(4) Spark Shell简介.

Spark Shell提供了一种学习API的简单方法，以及交互式分析数据的强大工具， 它可以在 Scala（运行在Java VM上）或 Python 中运行。

  计算Top N：
  
  创建数值文本文件
我们创建一个包含由' '空格分隔的数值文本文件，打开命令行。输入：

`echo {1..100} > /home/ehpc/number.txt`

  启动Spark Shell：
  
进入Spark的安装目录：

`cd spark-2.3.0-bin-hadoop2.7/`

![image.png](https://www.easyhpc.net/static/upload/md_images/20180602164541.png)

读取计算 Top N 的文件
输入：

`val textFile = sc.textFile("/home/ehpc/number.txt")`

![image.png](https://www.easyhpc.net/static/upload/md_images/20180606105351.png)

分割数值
输入：

`val nums = textFile.flatMap(line => line.split(" "))`

![image.png](https://www.easyhpc.net/static/upload/md_images/20180606105612.png)

将数值映射为key-val结构
输入：

`val nums_map= nums.map(x => (x.toInt, null))`

这里将每个数值映射为一个key-val的结构，为后续计算 Top N 做准备，由于我们只需要形式上的key-val结构，所以这里val的部分用null代替。

![image.png](https://www.easyhpc.net/static/upload/md_images/20180606105945.png)

对数值进行排序
输入：

`val sorted_nums_map = nums_map.sortByKey(false)`

对数值以降序的方式进行排序。

![image.png](https://www.easyhpc.net/static/upload/md_images/20180606111135.png)

将排序后数值的key-val结构进行映射，只取key部分
输入：

`val sorted_nums = sorted_nums_map.map(_._1)`

![image.png](https://www.easyhpc.net/static/upload/md_images/20180606111222.png)

取出前10个数值
输入：

`val top_10 = sorted_nums.take(10)`

![image.png](https://www.easyhpc.net/static/upload/md_images/20180606111351.png)

打印最大的10个数值
输入：

`top_10.foreach(println)`

![image.png](https://www.easyhpc.net/static/upload/md_images/20180606111503.png)


(5) word count示例实验。

启动Spark Shell
进入Spark的安装目录：

`cd spark-2.3.0-bin-hadoop2.7/`

![image.png](https://www.easyhpc.net/static/upload/md_images/20180606104939.png)

打开 Spark Shell：

`./bin/spark-shell`

进入 Spark Shell 工作环境，如下图所示。

![image.png](https://www.easyhpc.net/static/upload/md_images/20180602164541.png)

读取统计单词数的文件
输入：

`val textFile = sc.textFile("README.md")`

![image.png](https://www.easyhpc.net/static/upload/md_images/20180602193511.png)

分割单词
输入：

`val words = textFile.flatMap(line => line.split(" "))`

![image.png](https://www.easyhpc.net/static/upload/md_images/20180602193758.png)

将单词映射为key-val结构
输入：

`val ones = words.map(w => (w, 1))`

![image.png](https://www.easyhpc.net/static/upload/md_images/20180602194101.png)

统计单词出现次数
输入：

`val counts = ones.reduceByKey(_ + _)`

![image.png](https://www.easyhpc.net/static/upload/md_images/20180602194319.png)

打印统计结果
输入：

`counts.foreach(println)`

![image.png](https://www.easyhpc.net/static/upload/md_images/20180602194532.png)

(6) RDD编程实践。

RDD (Resilient Distributed Dataset) 是弹性分布式数据集，它是Spark应用程序中数据的基本组织形式。具体地，它是一个容错的、并行的数据结构，可以让用户显式地将数据存储到磁盘和内存中，并能控制数据的分区。RDD还提供了诸如join、groupBy、reduceByKey等更为方便的操作，以支持常见的数据运算。

实际处理的数据量会非常巨大，完全基于一个节点上的存储与计算是不现实的。Spark基于分布式的思想，将RDD划分为若干子集，每个子集成为一个分区。分区是RDD的基本组成单位，Spark以分区为单位逐个计算分区中的元素。因此，分区的大小决定了RDD进行并行计算的粒度。

RDD上的数据能够被执行一系列操作算子。操作算子主要分为两部分：转换运算 (Transformation) 和执行运算 (Action)。

转换运算
RDD执行转换运算后，会产生另外一个RDD。但是转换运算是一种延迟计算，转换操作不会立刻执行，仅仅标记了数据集的逻辑操作。转换操作会等到执行到动作运算时，才会实际执行。

动作运算
RDD执行动作运算后，不会产生另外一个RDD。它会触发Spark作业的运行，产生数值、数组或写入文件系统的输出结果。

创建RDD

输入：

`val rdd = sc.makeRDD(1 to 5, 3)`

创建有3个分区的RDD，RDD的数据为1-5的整数。输入：

`rdd.collect`

可以查看RDD的数据。

![image.png](https://www.easyhpc.net/static/upload/md_images/20180603171603.png)

转换运算函数

map(func)：数据集中的每个元素经过用户自定义的函数转换形成一个新的RDD。
输入：

`rdd.map(_ * 2).collect`

让rdd每个整数乘以2，并查看结果。

![image.png](https://www.easyhpc.net/static/upload/md_images/20180603171714.png)

flatMap(func):与map类似，但每个元素输入项都可以被映射到0个或多个的输出项，最终将结果”扁平化“后输出。
输入：

`val rdd1 = rdd.flatMap(x => (1 to x))`

让rdd每个整数映射到一个从1开始到该整数的数组，最后想这些数组拼接在一起。
输入：

`rdd1.collect`

显示RDD的数据。

![image.png](https://www.easyhpc.net/static/upload/md_images/20180603213722.png)

union(ortherDataset)：将两个RDD中的数据集进行合并，最终返回两个RDD的并集，若RDD中存在相同的元素也不会去重。
输入：

`rdd.union(rdd1).collect`

合并rdd和rdd1的元素。

![image.png](https://www.easyhpc.net/static/upload/md_images/20180603214202.png)

我们可以看到union转换不会将元素去重。

intersection(otherDataset)：返回两个RDD的交集。输入：

`rdd1.intersection(rdd).collect`

求取两个RDD的交集。

![image,png](https://www.easyhpc.net/static/upload/md_images/20180603214528.png)

执行运算函数

first：返回RDD中第1个元素。输入：

`rdd.first`

返回第1个元素。

![image.png](https://www.easyhpc.net/static/upload/md_images/20180603215056.png)

count：统计RDD中元素个数。输入：

`rdd.count`

统计rdd的元素个数。

![image.png](https://www.easyhpc.net/static/upload/md_images/20180603215156.png)

reduce：会对RDD中的元素进行累积操作。输入：

`rdd.reduce( _ + _)`

对rdd中元素累加求和。输入：

`rdd.reduce(_ * _)`

对rdd中元素累加求积。

![image.png](https://www.easyhpc.net/static/upload/md_images/20180603215830.png)

top(n)：按排序后返回前n个元素。输入：

`rdd.top(3)`

返回rdd中3个最大的数。

