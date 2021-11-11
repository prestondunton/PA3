# Check for the right number of arguments and that they are valid

if [ "$#" -ne 4 ]; then
	echo "Usage: bash recompile_and_run.sh <PageRank|PageRankTax|WikiBomb> <cluster|client> <linksInput> <titlesInput>"
	exit 1
fi

if [ "$1" != "PageRank" ] && [ "$1" != "PageRankTax" ] && [ "$1" != "WikiBomb" ]; then
	echo "Usage: bash recompile_and_run.sh <PageRank|PageRankTax|WikiBomb> <cluster|client> <linksInput> <titlesInput>"
	exit 1
fi

if [ "$2" != "cluster" ] && [ "$2" != "client" ]; then
	echo "Usage: bash recompile_and_run.sh <PageRank|PageRankTax|WikiBomb> <cluster|client> <linksInput> <titlesInput>"
	exit 1
fi


# ##########################################################################################################################################################

echo "Compiling code and making jar"

sbt package

if [ $? -ne 0 ]; then 
	exit 1 
fi

# ##########################################################################################################################################################

if [ "$1" = "PageRank" ]; then

	echo "Removing old output"

	$HADOOP_HOME/bin/hadoop fs -test -e /PA3/pageRank
	if [ $? = 0 ]; then 
		$HADOOP_HOME/bin/hadoop fs -rm -r /PA3/pageRank
	fi

	$HADOOP_HOME/bin/hadoop fs -test -e /PA3/titleRank
	if [ $? = 0 ]; then 
		$HADOOP_HOME/bin/hadoop fs -rm -r /PA3/titleRank
	fi
	$HADOOP_HOME/bin/hadoop fs -test -e /PA3/titleIndices
	if [ $? = 0 ]; then 
		$HADOOP_HOME/bin/hadoop fs -rm -r /PA3/titleIndices
	fi

	echo "Running job"

	$SPARK_HOME/bin/spark-submit --class $1 --deploy-mode $2 --master $SPARK_MASTER_ADDRESS --supervise target/scala-2.12/pagerankscala_2.12-0.1.jar $3 $4 /PA3/pageRank/ /PA3/titleIndices/ /PA3/titleRank/
	
	if [ $? -ne 0 ]; then 
		exit 1 
	fi

	sleep 5

	echo "Printing outputs"

	$HADOOP_HOME/bin/hadoop fs -cat /PA3/pageRank/*
	echo ""

	$HADOOP_HOME/bin/hadoop fs -cat /PA3/titleRank/*
	echo ""

	$HADOOP_HOME/bin/hadoop fs -cat /PA3/titleIndices/*
	echo ""

# ##########################################################################################################################################################

elif [ "$1" = "PageRankTax" ]; then

	echo "Removing old output"

	$HADOOP_HOME/bin/hadoop fs -test -e /PA3/pageRankTax
	if [ $? = 0 ]; then 
		$HADOOP_HOME/bin/hadoop fs -rm -r /PA3/pageRankTax
	fi

	$HADOOP_HOME/bin/hadoop fs -test -e /PA3/titleRankTax
	if [ $? = 0 ]; then 
		$HADOOP_HOME/bin/hadoop fs -rm -r /PA3/titleRankTax
	fi
	$HADOOP_HOME/bin/hadoop fs -test -e /PA3/titleIndices
	if [ $? = 0 ]; then 
		$HADOOP_HOME/bin/hadoop fs -rm -r /PA3/titleIndices
	fi

	echo "Running job"

	$SPARK_HOME/bin/spark-submit --class $1 --deploy-mode $2 --master $SPARK_MASTER_ADDRESS --supervise target/scala-2.12/pagerankscala_2.12-0.1.jar $3 $4 /PA3/pageRankTax/ /PA3/titleIndices/ /PA3/titleRankTax/

	if [ $? -ne 0 ]; then 
		exit 1 
	fi

	sleep 5

	echo "Printing outputs"

	$HADOOP_HOME/bin/hadoop fs -cat /PA3/pageRankTax/*
	echo ""

	$HADOOP_HOME/bin/hadoop fs -cat /PA3/titleRankTax/*
	echo ""

	$HADOOP_HOME/bin/hadoop fs -cat /PA3/titleIndices/*
	echo ""

# ##########################################################################################################################################################

elif [ "$1" = "WikiBomb" ]; then

	echo "Removing old output"

	$HADOOP_HOME/bin/hadoop fs -test -e /PA3/bombLinks
	if [ $? = 0 ]; then 
		$HADOOP_HOME/bin/hadoop fs -rm -r /PA3/bombLinks
	fi

	$SPARK_HOME/bin/spark-submit --class $1 --deploy-mode $2 --master $SPARK_MASTER_ADDRESS --supervise target/scala-2.12/pagerankscala_2.12-0.1.jar $3 $4 /PA3/bombLinks

	if [ $? -ne 0 ]; then 
		exit 1 
	fi

	sleep 5

	echo "Printing outputs"

	$HADOOP_HOME/bin/hadoop fs -cat /PA3/bombLinks/*
	echo ""

else
	echo "Invalid class name."
	exit 1

fi
