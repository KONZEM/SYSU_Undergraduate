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
    // 输入类型是(LongWritable: Text)，输出类型是(Text: Text)
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
            // 输出
            for (String word : words)
                if (word.length() > 0)
                    context.write(new Text(word), new Text(filename));
        }
    }

    // 输入类型是(Text: Iterable<Text>)，输出类型是(Text, Text)    
    public static class WordCountReducer extends Reducer<Text, Text, Text, Text> {
        @Override
        protected void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
            String final_value = "";
            Map<String, Integer> map = new HashMap<String, Integer>();
            // 统计
            for (Text value : values) {
                String filename = value.toString();
                int cnt = map.containsKey(filename)?map.get(filename):0;
                // 添加或加一
                map.put(filename, cnt+1);
            }
            // 将Map中的数据转为一定格式的String
            for (Map.Entry<String, Integer> entry: map.entrySet()) 
                final_value += "<" + entry.getKey() + ", " + entry.getValue() + ">, ";   
            // 去掉末尾多余的", "
            final_value = final_value.substring(0, final_value.length()-2);
            // 输出
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