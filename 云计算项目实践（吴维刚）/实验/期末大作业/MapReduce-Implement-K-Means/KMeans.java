import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

import java.io.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.io.IOException;
import java.net.URI;

public class KMeans {
    /* 基于Hadoop平台实现K-Means的MapReduce程序 */

    public static class Utils {
        /* 
        这个类实现了各种辅助函数，包括从文件中读取类中心、从规定格式的字符串中读取类中心、
        将类中心及类下标转化为规定格式的字符串、将类中心和类下标写进文件、
        从数据集中随机选取k个样本作为类中心、计算两个样本点的欧氏距离、
        读取Reducer的输出，也即类中心和类下标。
        */

        public static ArrayList<Double[]> readCentroids(String filename) throws IOException {
            /* 从文件中读取类中心 */

            // 利用流和缓冲区这两种技术能够更快实现读取和写入
            FileInputStream fileInputStream = new FileInputStream(filename);
            BufferedReader reader = new BufferedReader(new InputStreamReader(fileInputStream));
            return  readData(reader);
        }

        public static ArrayList<Double[]> getCentroids(String content) throws IOException {
            /* 从规定格式的字符串中读取类中心 */
            BufferedReader reader = new BufferedReader(new StringReader(content));
            return  readData(reader);
        }

        private static ArrayList<Double[]> readData(BufferedReader reader) throws IOException {
            ArrayList<Double[]> centroids = new ArrayList<>();
            String line;
            try {
                while ((line = reader.readLine()) != null) {
                    String[] values = line.split("\t");         // 去除类下标
                    String[] temp = values[0].split(" ");       // 将每维的数字分隔开
                    Double[] centroid = new Double[temp.length];
                    for (int i=0; i<temp.length; ++i) centroid[i] = Double.parseDouble(temp[i]);
                    centroids.add(centroid);
                }
            }
            finally {
                reader.close();
            }
            return centroids;
        }

        public static String getFormattedCentroids(ArrayList<Double[]> centroids) {
            /* 将类中心及类下标转化为规定格式的字符串 */
            int counter = 0;
            StringBuilder centroidsBuilder = new StringBuilder();
            for (Double[] centroid : centroids) {
                for(int i=0; i<centroid.length-1; ++i) {
                    centroidsBuilder.append(centroid[i].toString());
                    centroidsBuilder.append(" ");                           // 每个维度之间用空格分隔开
                }
                centroidsBuilder.append(centroid[centroid.length-1].toString());    // 最后一个维度的后面不加空格
                centroidsBuilder.append("\t" + counter++);                  // 加tab和类下标
                centroidsBuilder.append("\n");
            }
            return centroidsBuilder.toString();
        }

        public static void writeCentroids(Configuration configuration, String formattedCentroids) throws IOException {
            /* 将类中心和类下标写进文件 */
            FileSystem fs = FileSystem.get(configuration);      // 获取文件系统
            FSDataOutputStream fin = fs.create(new Path(Parameters.CENTROIDS_FILE));    // 创建文件夹、文件以及相应的输出流
            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fin));
            bw.append(formattedCentroids);
            bw.close();
        }

        public static ArrayList<Double[]> createRandomCentroids(Configuration configuration, int centroidsNumber)throws IOException {
            /* 从数据集中随机选取k个样本作为类中心 */
            ArrayList<Double[]> points = new ArrayList<>();         // 记录样本点
            HashSet<Integer> set = new HashSet<>();                 // 随机选择的下标
            ArrayList<Double[]> centroids = new ArrayList<>();      // 随机选取的类中心

            // 读取出所有的样本点
            FileSystem fs = FileSystem.get(configuration);
            FSDataInputStream dataInputStream = new FSDataInputStream(fs.open(new Path(configuration.get(Parameters.INPUT_FILE_ARG) + "/test.txt")));
            BufferedReader reader = new BufferedReader(new InputStreamReader(dataInputStream));
            String line;
            try {
                while ((line = reader.readLine()) != null) {
                    String[] values = line.split(" ");
                    Double[] point = new Double[values.length];
                    for (int i=0; i<values.length; ++i) point[i] = Double.parseDouble(values[i]);
                    points.add(point);
                }
            }
            finally {
                reader.close();
            }
            
            // 通过随机数确定要选择作为类中心的样本点的下标
            while (set.size() < centroidsNumber) {
                int index = (int)(Math.random() * points.size());
                set.add(index);
            }

            // 通过随机数确定类中心
            for (Integer i: set)    centroids.add(points.get(i));

            return centroids;
        }


        public static double euclideanDistance(Double[] point1, Double[] point2) {
            /* 计算两个样本点的欧氏距离 */
            double sum = 0;
            for (int i=0; i<point1.length; ++i) sum += Math.pow(point1[i] - point2[i], 2);
            return Math.sqrt(sum);
        }

        public static String readReducerOutput(Configuration configuration) throws IOException {
            /* 读取Reducer的输出，也即类中心和类下标 */
            FileSystem fs = FileSystem.get(configuration);
            FSDataInputStream dataInputStream = new FSDataInputStream(fs.open(new Path(configuration.get(Parameters.OUTPUT_FILE_ARG) + "/part-r-00000")));
            BufferedReader reader = new BufferedReader(new InputStreamReader(dataInputStream));
            StringBuilder content = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null)
                content.append(line).append("\n");

            return content.toString();
        }
    }

    public static class KMeansMapper extends Mapper<Object, Text, IntWritable, Text> {
        /* Map阶段的工作：计算每个样本点与类中心的距离，选择距离最小的类并加入，输出的键值对为（类下标，样本点） */

        public static ArrayList<Double[]> centroids;    // 从缓存中读取的类中心
    
        @Override
        protected void setup(Context context) throws IOException, InterruptedException {
            /* 在启动阶段完成从缓存中读取类中心 */
            URI[] cacheFiles = context.getCacheFiles();
            centroids = Utils.readCentroids(cacheFiles[0].toString());
        }
    
        @Override
        public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
    
            String[] temp = value.toString().split(" ");
            Double[] point = new Double[temp.length];
            for (int i=0; i<temp.length; ++i)   point[i] = Double.parseDouble(temp[i]);     // 读取出样本点
            int index = 0;
            double minDistance = Double.MAX_VALUE;
            // 计算距离
            for (int i = 0; i < centroids.size(); ++i) {
                double distance = Utils.euclideanDistance(centroids.get(i), point);
                // 更新距离更短的类下标以及距离
                if (distance < minDistance) {   
                    index = i;      
                    minDistance = distance;
                }
            }
            
            // 输出的键值对为（类下标，样本点）
            context.write(new IntWritable(index), value);
        }
    }

    public static class KMeansReducer extends Reducer<IntWritable, Text, Text, IntWritable> {
        /* Reduce阶段的工作：计算类中心，输出键值对为（类中心，类下标） */

        @Override
        protected void reduce(IntWritable key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
            StringBuilder centroidsBuilder = new StringBuilder();
            Double[] cluster_sum = new Double[1000];
            for (int i=0; i<1000; ++i)  cluster_sum[i] = 0.0;           // 初始化
            int counter = 0;                                            // 计算类内样本数
            int length = 0;                                             // 样本的维度
            
            // 每个维度求和
            for (Text value: values) {
                String[] temp = value.toString().split(" ");
                length = temp.length;
                for(int i=0; i<length; ++i)    cluster_sum[i] += Double.parseDouble(temp[i]);
                counter ++;
            }

            // 最后每个维度取平均得到类中心
            for (int i=0; i<length-1; ++i) 
                centroidsBuilder.append((cluster_sum[i] / counter) + " ");
            centroidsBuilder.append(cluster_sum[length-1] / counter);
    
            context.write(new Text(centroidsBuilder.toString()), key);
        }
    }

    public static class Parameters {
        /* Configure的参数 */

        public static final String INPUT_FILE_ARG = "input_file";                   // 作为输入的文件夹
        public static final String OUTPUT_FILE_ARG = "output_file";                 // 作为输出的文件夹
        public static String CENTROIDS_FILE = "centroids/centroids.txt";            // 存放类中心的文件夹
        public static String CENTROID_NUMBER_ARG = "centroids/centroids_number";    // 分为几类
    }
    public static void main(String[] args) throws Exception {
        /* main函数：判断是否停止循环以及提交Job来执行K-Means算法 */

        Configuration configuration = new Configuration();
        String[] otherArgs = new GenericOptionsParser(configuration, args).getRemainingArgs();
        // 参数不足
        if (otherArgs.length != 3) {
            System.err.println("Usage: KMeans <input_folder> <output_folder> <clusters_number>");
            System.exit(2);
        }

        int centroidsNumber = Integer.parseInt(otherArgs[2]);
        configuration.setInt(Parameters.CENTROID_NUMBER_ARG, centroidsNumber);
        configuration.set(Parameters.INPUT_FILE_ARG, otherArgs[0]);

        // 随机选择样本点作为类中心并写进分布式缓存中，方便mapper读取
        ArrayList<Double[]> centroids = Utils.createRandomCentroids(configuration, centroidsNumber);
        String centroidsFile = Utils.getFormattedCentroids(centroids);
        Utils.writeCentroids(configuration, centroidsFile);

        boolean hasConverged = false;           // 是否收敛，也即类中心是否不变化了
        int iteration = 0;                      // 循环了几次
        do {
            configuration.set(Parameters.OUTPUT_FILE_ARG, otherArgs[1] + "-" + iteration);

            // 提交Job
            if (!launchJob(configuration))  System.exit(1);         // 提交失败

            String newCentroids = Utils.readReducerOutput(configuration);   // 读取Reducer输出

            // 类中心书否变化
            if (centroidsFile.equals(newCentroids)) hasConverged = true;    // 不变化，已收敛
            else Utils.writeCentroids(configuration, newCentroids);         // 变化，需要继续迭代，将类中心更新到缓存中

            centroidsFile = newCentroids;                           // 更新类中心
            iteration ++;                                           // 循环次数加一

        } while (!hasConverged);

        // 类中心收敛了，根据类中心实现分类
        writeFinalData(configuration, Utils.getCentroids(centroidsFile));
    }

    private static boolean launchJob(Configuration configuration) throws Exception {
        /* 设置Job的参数并提交Job，返回值为是否成功提交Job */

        Job job = Job.getInstance(configuration);
        job.setJobName("KMeans");
        job.setJarByClass(KMeans.class);

        job.setMapperClass(KMeansMapper.class);
        job.setReducerClass(KMeansReducer.class);

        job.setMapOutputKeyClass(IntWritable.class);
        job.setMapOutputValueClass(Text.class);

        job.setNumReduceTasks(1);

        job.addCacheFile(new Path(Parameters.CENTROIDS_FILE).toUri());      // 设置分布式缓存

        FileInputFormat.addInputPath(job, new Path(configuration.get(Parameters.INPUT_FILE_ARG)));
        FileOutputFormat.setOutputPath(job, new Path(configuration.get(Parameters.OUTPUT_FILE_ARG)));

        return job.waitForCompletion(true);
    }

    public static void writeFinalData(Configuration configuration, ArrayList<Double[]> centroids) throws IOException {
        /* 根据类中心将分类结果写进文件 */

        FileSystem fs = FileSystem.get(configuration);
        FSDataOutputStream dataOutputStream = fs.create(new Path(configuration.get(Parameters.OUTPUT_FILE_ARG) + "/final-data"));
        FSDataInputStream dataInputStream = new FSDataInputStream(fs.open(new Path(configuration.get(Parameters.INPUT_FILE_ARG) + "/test.txt")));
        BufferedReader reader = new BufferedReader(new InputStreamReader(dataInputStream));
        BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(dataOutputStream));

        try {
            String line;
            while ((line = reader.readLine()) != null) {

                String[] values = line.split(" ");
                Double[] point = new Double[values.length];
                for (int i=0; i<values.length; ++i) point[i] = Double.parseDouble(values[i]);
                int index = 0;
                double minDistance = Double.MAX_VALUE;
                // 找到具有最短的类中心
                for (int i = 0; i<centroids.size(); ++i) {
                    double distance = Utils.euclideanDistance(centroids.get(i), point);
                    if (distance < minDistance) {
                        index = i;
                        minDistance = distance;
                    }
                }
                // 输出格式为：样本点 \t 所属类下标
                StringBuilder result = new StringBuilder();
                for (int i=0; i<point.length-1; ++i)    result.append(point[i] + " ");      // 每个维度之间空格
                result.append(point[point.length-1] + "\t" + index + "\n");  
                writer.write(result.toString());
            }
        }
        finally {
            if (reader != null) {
                reader.close();
            }
            if (writer != null) {
                writer.close();
            }
        }
    }

}