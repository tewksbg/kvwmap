<?php
###################################################################
# kvwmap - Kartenserver für Kreisverwaltungen                     #
###################################################################
# Lizenz                                                          #
#                                                                 #
# Copyright (C) 2004  Peter Korduan                               #
#                                                                 #
# This program is free software; you can redistribute it and/or   #
# modify it under the terms of the GNU General Public License as  #
# published by the Free Software Foundation; either version 2 of  #
# the License, or (at your option) any later version.             #
#                                                                 #
# This program is distributed in the hope that it will be useful, #
# but WITHOUT ANY WARRANTY; without even the implied warranty of  #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the    #
# GNU General Public License for more details.                    #
#                                                                 #
# You should have received a copy of the GNU General Public       #
# License along with this program; if not, write to the Free      #
# Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,  #
# MA 02111-1307, USA.                                             #
#                                                                 #
# Kontakt:                                                        #
# peter.korduan@gdi-service.de                                    #
# stefan.rahn@gdi-service.de                                      #
###################################################################
#############################
# Klasse PgObject #
#############################

class PgObject {
	/*
	* Durch die Übergabe von gui besitzt das Object beide Datenbankverbindungen
	*	$this->database Postgres Datenbank
	* $this->gui->pgdatabase PostgresDatenbank
	* $this->gui->database MySQL Datenbank
	*
	*/
  function PgObject($gui, $schema, $tableName) {
		#echo '<br>Create new Object PgObject with schema ' . $schema . ' table ' . $tableName;
    global $debug;
    $this->debug=$debug;
    $this->gui = $gui;
    $this->database = $gui->pgdatabase;
    $this->schema = $schema;
    $this->tableName = $tableName;
    $this->qualifiedTableName = $schema . '.' . $tableName;
    $this->data = array();
    $this->debug = false;
		$this->select = '*';
		$this->identifier = 'id';
		$this->identifier_type = 'integer';
  }

	function find_by($attribute, $value) {
		#echo '<br>find by attribute ' . $attribute . ' with value ' . $value;
		$sql = "
			SELECT
				{$this->select}
			FROM
				\"{$this->schema}\".\"{$this->tableName}\"
			WHERE
				\"{$attribute}\" = '{$value}'
		";
		#echo '<p>find_by: ' . $sql;
		$this->debug('<p>find_by sql: ' . $sql);
		$query = pg_query($this->database->dbConn, $sql);
		$this->data = pg_fetch_assoc($query);
		return $this;
	}

  /*
  * Search for an record in the database by the given where clause
  * @ return an array with all found object
  */
  function find_where($where) {
    $sql = "
      SELECT
        *
      FROM
        " . $this->schema . '.' . $this->tableName . "
      WHERE
        " . $where . "
    ";
    $this->debug('<p>sql: ' . $sql);
		#echo '<p>find_where: ' . $sql;
    $query = pg_query($this->database->dbConn, $sql);
		$result = array();
		while($this->data = pg_fetch_assoc($query)) {
			$result[] = clone $this;
		}
    return $result;
  }

	function delete_by($attribute, $value) {
		#echo '<br>delete by attribute ' . $attribute . ' with value ' . $value;
		$sql = "
			DELETE FROM
				\"{$this->schema}\".\"{$this->tableName}\"
			WHERE
				\"{$attribute}\" = '{$value}'
		";
		#echo 'delete query: ' . $sql;
		$this->debug('<p>delete_by sql: ' . $sql);
		$query = pg_query($this->database->dbConn, $sql);
		return $query;
	}

  function getAttributes() {
    return array_keys($this->data);
  }

  function getValues() {
    return array_values($this->data);
  }

  function getKVP() {
    $kvp = array();
    foreach($this->data AS $key => $value) {
      $kvp[] = "\"" . $key . "\" = " . ((''.$value) == '' ? "NULL" : "'$value'") . "";
    }
    return $kvp;
  }

  function get($attribute) {
    return $this->data[$attribute];
  }

  function set($attribute, $value) {
    $this->data[$attribute] = $value;
    return $value;
  }

  function create($data) {
    if (!empty($data))
      $this->data = $data;
    $sql = "
      INSERT INTO " . $this->qualifiedTableName . " (
        " . implode(', ', $this->getAttributes()) . "
      )
      VALUES (
        '" . implode("', '", $this->getValues()) . "'
      )
      RETURNING id
    ";
		#echo '<p>Create Postgres Datensatz: ' . $sql;
    $this->debug('<p>Insert into pg table sql: ' . $sql);
    $query = pg_query($this->database->dbConn, $sql);
    $row = pg_fetch_assoc($query);
    $this->set('id', $row['id']);
    return $this->get('id');
  }

  function update() {
    $sql = "
      UPDATE
        \"" . $this->schema . "\".\"" . $this->tableName . "\"
      SET
        " . implode(', ', $this->getKVP()) . "
      WHERE
        id = " . $this->get('id') . "
    ";
    $this->debug('<p>Update in pg table sql: ' . $sql);
    $query = pg_query($this->database->dbConn, $sql);
  }

  function delete() {
		$quote = ($this->identifier_type == 'text') ? "'" : "";
    $sql = "
      DELETE
      FROM
        " . $this->qualifiedTableName . "
      WHERE
        " . $this->identifier . " = {$quote}" . $this->get($this->identifier) . "{$quote}
    ";
		#echo $sql;
    $this->debug('<p>Delete in pg table sql: ' . $sql);
    $result = pg_query($this->database->dbConn, $sql);
    return $result;
  }

  function getSQLResults($sql) {
    $query = pg_query($this->database->dbConn, $sql);
    $results = array();
    while ($rs = pg_fetch_assoc($query)) {
      $results[] = $rs;
    }
    return $result;
  }

  function debug($msg) {
    if ($this->debug)
      echo $msg;
  }
}
?>
