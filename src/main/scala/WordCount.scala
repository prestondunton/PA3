import org.apache.spark.sql.SparkSession


object WordCount {

  def main(args: Array[String]): Unit = {

    //val sc = SparkSession.builder().master(args(0)).getOrCreate().sparkContext

    // to run locally in IDE,
    // But comment out when creating the jar to run on cluster
    // val sc = SparkSession.builder().master("local").getOrCreate().sparkContext

    // to run with yarn, but this will be quite slow, if you like try it too
    // when running on the cluster make sure to use "--master yarn" option
    val sc = SparkSession.builder().master("yarn").getOrCreate().sparkContext

    val text = sc.textFile(args(1))
    val counts = text.flatMap(line => line.split(" ")
    ).map(word => (word,1)).reduceByKey(_+_)
    counts.saveAsTextFile(args(2))
  }
}
