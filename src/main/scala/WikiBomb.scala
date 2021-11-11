import org.apache.spark.sql.SparkSession

object WikiBomb {

  def main(args: Array[String]): Unit = {
    val sc = SparkSession.builder().master("local").getOrCreate().sparkContext

    // Create links and titles from input files
    val lines = sc.textFile(args(0))
    val links = lines.map(s => (s.split(": ")(0), s.split(": ")(1)))
    val titles = sc.textFile(args(1)).zipWithIndex().mapValues(x => x + 1).map(_.swap)

    // Extract only 'surfing' and 'rocky mountain national park' titles
    val sRTemp = titles.filter(x=> (x._2.toLowerCase.contains("surfing") || (x._2.toLowerCase.equals("rocky_mountain_national_park"))))
    val surfRockyTitles = sRTemp.map(x=>(x._1.toString,x._2))
    val surfRockyIndex = sRTemp.map(x=>(x._2,x._1.toString))

    // Get index of 'rocky mountain national park'
    val rITemp = surfRockyTitles.filter(x=>(x._2.toLowerCase.equals("rocky_mountain_national_park"))).keys
    val rIArray = rITemp.take(1)
    val rockyIndexNum = rIArray(0)

    // Add 'rocky mountain national park' index to every page link
    val sRLTemp = surfRockyTitles.join(links).values
    val surfRockyLinks = sRLTemp.map(x=>(x._1,x._2 + " " + rockyIndexNum))

    // Final surfing links
    val fin = surfRockyIndex.join(surfRockyLinks).values
    fin.saveAsTextFile(args(2))
  }
}
