<?php
class Layer extends MyObject {

  function Layer($database) {
    $this->MyObject($Database, 'layer');
  }

  function create($params) {
    $sql = "
      INSERT INTO
       `.`" . $this->tableName . "` (" .
        implode(', ', array_keys($params) . "
      VALUES (" .
        implode("', '", array_keys($values)) . "
      )
    ";
    $query = mysql_query($this->database->dbConn, $sql);
    $this->set('id', mysqli_insert_id());
    return $this;
  }
}
  
?>
