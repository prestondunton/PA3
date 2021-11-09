set -e

if [ "$#" -ne 1 ]; then
	echo "Usage: bash recompile_and_run.sh <className>"
	exit 1
fi

echo "Compiling code and making jar"

sbt package

echo "Removing old output"

$HADOOP_HOME/bin/hadoop fs -rm -r /PA3/pageRank /PA3/titleIndices /PA3/titleRank

echo "Running jobs"

$SPARK_HOME/bin/spark-submit --class $1 --deploy-mode client --supervise target/scala-2.12/pagerankscala_2.12-0.1.jar /PA3/input/links.txt /PA3/input/titles.txt /PA3/pageRank/ /PA3/titleIndices/ /PA3/titleRank/

echo "Cating outputs"

$HADOOP_HOME/bin/hadoop fs -cat /PA3/pageRank/*
echo ""

$HADOOP_HOME/bin/hadoop fs -cat /PA3/titleRank/*
echo ""

$HADOOP_HOME/bin/hadoop fs -cat /PA3/titleIndices/*
echo ""
