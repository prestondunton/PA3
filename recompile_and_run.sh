set -e

echo "Compiling code and making jar"

sbt package

echo "Removing old output"

$HADOOP_HOME/bin/hadoop fs -rm -r /pageRank /titleIndeces /titleRank

echo "Running jobs"

$SPARK_HOME/bin/spark-submit --class PageRank --deploy-mode client --supervise target/scala-2.12/pagerankscala_2.12-0.1.jar /input/links.txt /input/titles.txt /pageRank/ /titleIndeces/ /titleRank/
