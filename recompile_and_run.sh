set -e

echo "Compiling code and making jar"

sbt package

if $(hadoop fs -test -d "/PA3/output/") ; then 
	echo "Removing previous output"

	$HADOOP_HOME/bin/hadoop fs -rm -r /PA3/output/

fi


echo "Running jobs"

$SPARK_HOME/bin/spark-submit --class PageRank --master $SPARK_MASTER_ADDRESS --deploy-mode cluster --supervise target/scala-2.12/pagerankscala_2.12-0.1.jar $SPARK_MASTER_ADDRESS /PA3/input/sample-input.txt /PA3/output/
