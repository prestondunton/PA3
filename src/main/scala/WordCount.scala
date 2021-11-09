import org.apache.spark.sql.SparkSession

object WordCount {

  def main(args: Array[String]): Unit = {

    // uncomment below line and change the placeholders accordingly
    //val sc = SparkSession.builder().master("spark://santa-fe:30256").getOrCreate().sparkContext

    // to run locally in IDE,
    // But comment out when creating the jar to run on cluster
    val sc = SparkSession.builder().master("local").getOrCreate().sparkContext

    // to run with yarn, but this will be quite slow, if you like try it too
    // when running on the cluster make sure to use "--master yarn" option
    //val sc = SparkSession.builder().master("yarn").getOrCreate().sparkContext


    val lines = sc.textFile(args(0))
    //val numLines = scala.io.Source.fromFile(args(0)).getLines.size
    val links = lines.map(s => (s.split(": ")(0), s.split(": ")(1)))
    val titles = sc.textFile(args(1)).zipWithIndex().mapValues(x => x + 1).map(_.swap)
    val count = lines.count()
    var ranks = links.mapValues(v => 1.0 / count)
    for (i <- 1 to 25) {
      val tempRank = links.join(ranks).values.flatMap {
        case (urls, rank) =>
          val outgoingLinks = urls.split(" ")
          outgoingLinks.map(url => (url, rank / outgoingLinks.length))
      }
      ranks = tempRank.reduceByKey(_ + _)
    }
    ranks.saveAsTextFile(args(2))
    titles.saveAsTextFile(args(3))
    val titleIndexRank = titles.map(x=>(x._1.toString,x._2))
    val titleRank = (titleIndexRank.join(ranks)).values
    titleRank.sortBy(_._2,false).saveAsTextFile(args(4))
  }
}
