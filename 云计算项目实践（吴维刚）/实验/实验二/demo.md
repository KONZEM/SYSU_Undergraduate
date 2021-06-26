# 一、实验简介

## 1.1 实验目标

MapReduce采用的是一种分而治之的编程思想，即将一个大的任务拆分为多个小任务，主要分为“Map（映射）”和“Reduce（归约）”。

*   “Map”接受一个键值对（key-value），产生一组中间键值对。
*   “Reduce”接受一个键，以及相关的一组值，将这组值合并产生一组规模更小的值。

在本小节中，我们主要完成基于Hadoop的MapReduce实例之WordCount统计新闻文本词频，即通过MapReduce的编程框架，统计新闻文本的词频。MapReduce重点是实现Mapper和Reducer两个函数.

## 1.2 实验环境要求

实验环境主要为Hadoop、Java以及基本的Linux环境。本次MapReduce实验主要是理解MapReduce框架，会写一些简单的MapReduce程序，实验环境已配置好Hadoop 2.7.7，java 10等，环境变量也已配置好。以下是实验环境主要版本参数和环境变量设置（请切换到hadoop用户，见实验步骤）：

1.  Java 版本
![](https://easyhpc.net/static/upload/md_images/20180530160445.png)
2.  Hadoop 版本
![](https://easyhpc.net/static/upload/md_images/20180530160451.png)
3.  环境变量设置（~/.bashrc）
```bash
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
export PATH=$PATH:/usr/lib/jvm/java-11-openjdk-amd64/bin
export HADOOP_HOME=/usr/local/hadoop
export CLASSPATH=$($HADOOP_HOME/bin/hadoop classpath):$CLASSPATH
```

以上Java、Hadoop、环境变量已经配置好，用户可专注于完成基于MapReduce的新闻文本词频统计实例。即从以下实验步骤开始完成任务。

## 1.3 涉及知识点和基本知识

*   Linux命令行相关操作
*   Java语言相关知识
*   MapReduce基本概念

# 二、实验步骤

## 2.1 切换用户为hadoop

本小节所有任务将在hadoop用户环境下完成，用户名：hadoop，用户密码：hadoop。并打开VirtualLab文件夹。

```bash
su hadoop
cd ~/VirtualLab
pwd
```

此时环境已经切换到hadoop用户，用户可自行查看Java和Hadoop版本等。操作实例如下：
![](https://easyhpc.net/static/upload/md_images/20180530161103.png)

其中dataset文件夹，包含了Mapreduce实例涉及到的数据集，后面实验步骤将会涉及到。

## 2.2 基于MapReduce的新闻文本词频统计程序

创建workcount文件夹，用以存放本次实验的所有文件代码，并进入文件夹：
![](https://easyhpc.net/static/upload/md_images/20180530162315.png)

使用vim编写java程序

```bash
vim WordCount.java
```

java总代码如下：(WordCount.java)

```java
import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class WordCount {
        public static class WordCountMapper extends Mapper<LongWritable, Text, Text, IntWritable> {
                // 统计词频时，需要去掉标点符号等符号，此处定义表达式
                private String pattern = "[^a-zA-Z0-9-]";

                @Override
                protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
                        // 将每一行转化为一个String
                        String line = value.toString();
                        // 将标点符号等字符用空格替换，这样仅剩单词
                        line = line.replaceAll(pattern, " ");
                        // 将String划分为一个个的单词
                        String[] words = line.split("\\s+");
                        // 将每一个单词初始化为词频为1，如果word相同，会传递给Reducer做进一步的操作
                        for (String word : words) {
                                if (word.length() > 0) {
                                        context.write(new Text(word), new IntWritable(1));
                                }
                        }
                }
        }

        public static class WordCountReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
                @Override
                protected void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
                        // 初始化词频总数为0
                        Integer count = 0;
                        // 对key是一样的单词，执行词频汇总操作，也就是同样的单词，若是再出现则词频累加
                        for (IntWritable value : values) {
                                count += value.get();
                        }
                        // 最后输出汇总后的结果，注意输出时，每个单词只会输出一次，紧跟着该单词的词频
                        context.write(key, new IntWritable(count));
                }
        }


        public static void main(String[] args) throws Exception {
                // 以下部分为HadoopMapreduce主程序的写法，对照即可
                // 创建配置对象
                Configuration conf = new Configuration();
                // 创建Job对象
                Job job = Job.getInstance(conf, "wordcount");
                // 设置运行Job的类
                job.setJarByClass(WordCount.class);
                // 设置Mapper类
                job.setMapperClass(WordCountMapper.class);
                // 设置Reducer类
                job.setReducerClass(WordCountReducer.class);
                // 设置Map输出的Key value
                job.setMapOutputKeyClass(Text.class);
                job.setOutputValueClass(IntWritable.class);
                // 设置Reduce输出的Key value
                job.setOutputKeyClass(Text.class);
                job.setOutputValueClass(IntWritable.class);
                // 设置输入输出的路径
                FileInputFormat.setInputPaths(job, new Path(args[0]));
                FileOutputFormat.setOutputPath(job, new Path(args[1]));
                // 提交job
                boolean b = job.waitForCompletion(true);

                if(!b) {
                        System.out.println("Wordcount task fail!");
                }

        }
}
```

在MapReduce的编程之中，重点在于写好主要的Mapper函数，Reducer函数，main函数。后续将详解每个函数的功能。

## 2.3 Mapper函数

Mapper函数主要是提取每一个单词，并将该单词的词频设置为1，即key-value的格式，key即单词，value则为词频。这样可能出现很多的key-value，并且有些key-value的key可能是一样的，下面的reducer函数就是为了合并key一样的情况。

```java
        public static class WordCountMapper extends Mapper<LongWritable, Text, Text, IntWritable> {
                // 统计词频时，需要去掉标点符号等符号，此处定义表达式
                private String pattern = "[^a-zA-Z0-9-]";

                @Override
                protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
                        // 将每一行转化为一个String
                        String line = value.toString();
                        // 将标点符号等字符用空格替换，这样仅剩单词
                        line = line.replaceAll(pattern, " ");
                        // 将String划分为一个个的单词
                        String[] words = line.split("\\s+");
                        // 将每一个单词初始化为词频为1，如果word相同，会传递给Reducer做进一步的操作
                        for (String word : words) {
                                if (word.length() > 0) {
                                        context.write(new Text(word), new IntWritable(1));
                                }
                        }
                }
        }
```

## 2.4 Reducer函数

Reducer函数会接收来自Mapper函数传来的值，并且对key一样的key-value做合并操作，比如在单词一样的情况下，就会 value进行词频累加。

```java
        public static class WordCountReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
                @Override
                protected void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
                        // 初始化词频总数为0
                        Integer count = 0;
                        // 对key是一样的单词，执行词频汇总操作，也就是同样的单词，若是再出现则词频累加
                        for (IntWritable value : values) {
                                count += value.get();
                        }
                        // 最后输出汇总后的结果，注意输出时，每个单词只会输出一次，紧跟着该单词的词频
                        context.write(key, new IntWritable(count));
                }
        }
```

## 2.5 Main函数

Main函数是整个函数的入口，并且也将会定义Mapper函数、Reducer函数和对应的输出参数类型，并将任务（job）提交。

```java
        public static void main(String[] args) throws Exception {
                // 以下部分为HadoopMapreduce主程序的写法，对照即可
                // 创建配置对象
                Configuration conf = new Configuration();
                // 创建Job对象
                Job job = Job.getInstance(conf, "wordcount");
                // 设置运行Job的类
                job.setJarByClass(WordCount.class);
                // 设置Mapper类
                job.setMapperClass(WordCountMapper.class);
                // 设置Reducer类
                job.setReducerClass(WordCountReducer.class);
                // 设置Map输出的Key value
                job.setMapOutputKeyClass(Text.class);
                job.setOutputValueClass(IntWritable.class);
                // 设置Reduce输出的Key value
                job.setOutputKeyClass(Text.class);
                job.setOutputValueClass(IntWritable.class);
                // 设置输入输出的路径
                FileInputFormat.setInputPaths(job, new Path(args[0]));
                FileOutputFormat.setOutputPath(job, new Path(args[1]));
                // 提交job
                boolean b = job.waitForCompletion(true);

                if(!b) {
                        System.out.println("Wordcount task fail!");
                }

        }
```

## 2.6 程序编译与运行

按照以上步骤写好WordCount.java程序，显示如下：
![](https://easyhpc.net/static/upload/md_images/20180530165752.png)

采用javac编译代码：

```bash
javac WordCount.java
```

编译成功则显示如下：
![](https://easyhpc.net/static/upload/md_images/20180530163838.png)
使用jar命令打包程序为jar包：

 ```bash
 jar cvf WordCount.jar ./WordCount*.class
 ```

打包成功则显示如下：(多了一个jar包)
![](https://easyhpc.net/static/upload/md_images/20180530163838.png)

创建数据输入文件夹，复制数据集到该本文件夹

```bash
mkdir input
cp ../dataset/wordcount_BBCNews_input/* ./input/
```

即：
![](https://easyhpc.net/static/upload/md_images/20180530164210.png)

其中input文件夹包含来自BBC news的两个新闻文本

使用hadoop命令运行任务：（如果已经运行过，先删除output文件夹）

```bash
# if output directory exists
rm -r ./output
```

```bash
/usr/local/hadoop/bin/hadoop jar WordCount.jar WordCount input output
```


![](https://easyhpc.net/static/upload/md_images/20180530164625.png)
![](https://easyhpc.net/static/upload/md_images/20180530164630.png)

成功运行后，将会产生一个output文件夹，output文件夹内即为输出结果（注意：每次重新运行，都需要删除output文件夹，否则会运行报错。）
![](https://easyhpc.net/static/upload/md_images/20180530164746.png)

## 2.7 实验结果

output文件夹的part-r-00000即为输入数据的词频统计结果，如输出最后十行：
![](https://easyhpc.net/static/upload/md_images/20180530164923.png)

到此，本小节任务已经完成。

# 三、实验要求

1. 根据上述实验步骤完成实验，理解MapReduce程序的运行原理。
2. 在上述实验的基础上，使用上述实验中使用的数据完成InvertedIndex程序，并介绍你的实现过程，提交一个报告（PDF格式）和相关代码。
   
   **什么是InvertedIndex?**

   比如： a.txt
   > Hello world  
   > Bye hadoop

   b.txt
   > Bye world  
   > Hello hadoop
   
   那么最终输出为：
   > Bye:<a.txt,1>,<b.txt,1>  
   > hadoop: <a.txt,1>,<b.txt,1>  
   > Hello:<a.txt,1>,<b.txt,1>  
   > world: <a.txt,1>,<b.txt,1>  

   实验提示：
   * 编写map 函数，在map 函数里面统计每一个单次的出现次数的同时要记录单次的文件名。提示：用FileSplit 获取文件所暑的切片信息及文件名。
   * 编写reduce 函数，对统计的values 进行累加。

```java
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;

public class WordCount {
        public static class WordCountMapper extends Mapper<LongWritable, Text, Text, Text> {
                // 统计词频时，需要去掉标点符号等符号，此处定义表达式
                private String pattern = "[^a-zA-Z0-9-]";

                @Override
                protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
                    	// 获取文件名
                    	FileSplit info = (FileSplit) context.getInputSplit();
                    	String filename = info.getPath().getName();
                        // 将每一行转化为一个String
                        String line = value.toString();
                        // 将标点符号等字符用空格替换，这样仅剩单词
                        line = line.replaceAll(pattern, " ");
                        // 将String划分为一个个的单词
                        String[] words = line.split("\\s+");
                        for (String word : words)
                                if (word.length() > 0)
                                        context.write(new Text(word), new Text(filename));
                }
        }

        public static class WordCountReducer extends Reducer<Text, Text, Text, Text> {
                @Override
                protected void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
                    	String final_value = "";
                    	Map<String, Integer> map = new HashMap<String, Integer>();
                        for (Text value : values) {
                        		String filename = value.toString();
                            	int cnt = map.containsKey(filename)?map.get(filename):0;
                            	map.put(filename, cnt+1);
                        }
                       	for (Map.Entry<String, Integer> entry: map.entrySet()) 
                            	final_value += "<" + entry.getKey() + ", " + entry.getValue() + ">, ";   
                    	final_value = final_value.substring(0, final_value.length()-2);
                        context.write(key, new Text(final_value));
                }
        }


        public static void main(String[] args) throws Exception {
                // 以下部分为HadoopMapreduce主程序的写法，对照即可
                // 创建配置对象
                Configuration conf = new Configuration();
                // 创建Job对象
                Job job = Job.getInstance(conf, "wordcount");
                // 设置运行Job的类
                job.setJarByClass(WordCount.class);
                // 设置Mapper类
                job.setMapperClass(WordCountMapper.class);
                // 设置Reducer类
                job.setReducerClass(WordCountReducer.class);
                // 设置Map输出的Key value
                job.setMapOutputKeyClass(Text.class);
                job.setOutputValueClass(Text.class);
                // 设置Reduce输出的Key value
                job.setOutputKeyClass(Text.class);
                job.setOutputValueClass(Text.class);
                // 设置输入输出的路径
                FileInputFormat.setInputPaths(job, new Path(args[0]));
                FileOutputFormat.setOutputPath(job, new Path(args[1]));
                // 提交job
                boolean b = job.waitForCompletion(true);

                if(!b) {
                        System.out.println("Wordcount task fail!");
                }

        }
}
```





