# PA3
PA3  for CS_435

## Links

[Assigment Description](https://cs.colostate.edu/~cs435/PAs/PA3/PA3.pdf)

[Apache Spark Installation Guide](https://cs.colostate.edu/~cs435/PAs/PA3/Apache-Spark.pdf)

[Sample Word Count Project](https://www.cs.colostate.edu/~cs435/PAs/PA3/WordCountScala.zip)

[Links File](https://www.cs.colostate.edu/~cs435/PAs/PA3/links-simple-sorted.zip)

[Titles File](https://www.cs.colostate.edu/~cs435/PAs/PA3/titles-sorted.zip)

[Useful InfoSpace Videos of Spark](https://infospaces.cs.colostate.edu/search.php?term=spark)

[Scala Introduction](https://docs.scala-lang.org/tour/tour-of-scala.html)

[Spark Docs](http://spark.apache.org/docs/latest/api/scala/org/apache/spark/index.html)

## Setup

Make sure you add ```export PATH=$PATH:/usr/local/sbt/latest/bin``` to your ```~/.bashrc``` file.

```sbt``` is the command we use to compile our scala

Also add a new variable ```export SPARK_MASTER_ADDRESS=spark://<master>:<port>``` where the master node and port are from the ```SPARK_MASTER_IP``` and ```SPARK_MASTER_PORT``` properties in your ```spark-env.sh``` file

This variable allows us to use the ```recompile_and_run.sh``` file I've create without editing it for our different master nodes.

## Recompile and Run Script	

Usage: ```bash recompile_and_run.sh <PageRank|PageRankTax|WikiBomb> <cluster|client> <linksInput> <titleInput>```

Example: ```bash recompile_and_run.sh WikiBomb client /PA3/input/links.txt /PA3/input/titles.txt```
