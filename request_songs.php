<?php
include ("connection.php");
include ("DateFilter.php");
include ("GenreFilter.php");

//song to be made smashed into JSON and sent through the interwebs
class Song
{
  public $title;
  public $artist;
  public $ytcode;
}

$songsPerPage = 30;

$topOf = $_POST['timefilter'];
$genre = $_POST['genrefilter'];

$timeFilter = new DateFilter($topOf);
$genreFilter = new GenreFilter($genre);

$where = $timeFilter->genSQL() . ' AND ' . $genreFilter->genSQL();


if($topOf == 'new') //newest was selected, order by upload date
{
  $qry = mysql_query("SELECT title,artist,youtubecode FROM  `songs` 
                      WHERE $where
                      ORDER BY uploaded_on DESC
                      LIMIT 0 , $songsPerPage
                      ");
}
else //order by score
{
  $qry = mysql_query("SELECT title,artist,youtubecode FROM  `songs` 
                      WHERE $where
                      ORDER BY score DESC
                      LIMIT 0 , $songsPerPage
                      ");
}					
if (!$qry)
  die("FAIL: " . mysql_error());

while($row = mysql_fetch_array($qry))
{
  //Do something
}
?>
