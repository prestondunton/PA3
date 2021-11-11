import org.apache.spark.sql.SparkSession

object WikiBomb {

  def main(args: Array[String]): Unit = {
    val sc = SparkSession.builder().master("local").getOrCreate().sparkContext

    // Create links exactly like pageRank
    val lines = sc.textFile(args(0))
    val links = lines.map(s => (s.split(": ")(0), s.split(": ")(1)))

    // Replaces index in links with title for filtering
    val titles = sc.textFile(args(1)).zipWithIndex().mapValues(x => x + 1).map(_.swap)   
    val titleIndexRank = titles.map(x=>(x._1.toString,x._2))
    var titleRank = (titleIndexRank.join(links)).values

    // Filters based on title, use lower for full dataset
    // Format: (string, string)
    val titlesFil = titleRank.filter(_._1.contains("Y"))
    //val titlesFil = titleRank.filter(_._1 == "surfing")

    // Run pageRank on titlesFil
    val count = lines.count()
    var ranks = titlesFil.mapValues(v => 1.0 / count)
    /**
    for (i <- 1 to 25) {
      val tempRank = titlesFil.join(ranks).values.flatMap {
        case (urls, rank) =>
          val outgoingLinks = urls.split(" ")
          outgoingLinks.map(url => (url, rank / outgoingLinks.length))
      }
      ranks = tempRank.reduceByKey(_ + _)
    }
    **/

    ranks = ranks.sortBy(_._2, false)

    titles.saveAsTextFile(args(2))
    ranks.saveAsTextFile(args(3))
    titlesFil.saveAsTextFile(args(4))
  }
}