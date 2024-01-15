<?php

namespace Wattanar;

class Sqlsrv
{
	public static function connect($server, $uid, $pwd, $dbname)
	{
		$settings = [
			"Database" => "$dbname", 
			"UID" => "$uid", 
			"PWD" => "$pwd" ,
			"CharacterSet" => "UTF-8",
			"ReturnDatesAsStrings" => true,
			"MultipleActiveResultSets" => true
		];

		try {
			$connect = sqlsrv_connect($server, $settings);
		} catch (Exception $e) {
			return false;
		}

		return $connect;
	}

	public static function array($connection, $query, array $params = null)
	{
		if ($params === null) {

			try {
				$query = sqlsrv_query($connection, $query);
			} catch (Exception $e) {
				return sqlsrv_errors();
			}
			
		} else {

			try {
				$query = sqlsrv_query($connection, $query, $params);
			} catch (Exception $e) {
				return sqlsrv_errors();
			}

		}

		$array = [];
		$object = [];

		while ($fetch = sqlsrv_fetch_object($query)) {
			$array[] = $fetch;
		}

		foreach ($array as $value) {
			$object[] = $value;
		}

		return $object;
	}

	public static function queryArray($connection, $query, $params = NULL)
	{
		if (!$params) {
			$query = sqlsrv_query($connection, $query);
		} else {
			$query = sqlsrv_query($connection, $query, $params);
		}

		if ($query) {
			$array = [];
			while ($fetch = sqlsrv_fetch_array($query)) {
				$array[] = $fetch;
			}
			return $array;
		} else {
			return;
		}
	}
	
	public static function hasRows($connection, $query, array $params = null)
	{
		if ($params === null) {

			try {
				$query = sqlsrv_has_rows(sqlsrv_query(
					$connection,
					$query
				));
			} catch (Exception $e) {
				return sqlsrv_errors();
			}

		} else {

			try {
				$query = sqlsrv_has_rows(sqlsrv_query(
					$connection,
					$query,
					$params
				));
			} catch (Exception $e) {
				return sqlsrv_errors();
			}

		}

		return $query;
	}

	public static function query($connection, $query, array $params = null)
	{
		if ($params === null) {
			
			try {
				$query = sqlsrv_query($connection, $query);
			} catch (Exception $e) {
				return sqlsrv_errors();
			}

		} else {
			
			try {
				$query = sqlsrv_query($connection, $query, $params);
			} catch (Exception $e) {
				return sqlsrv_errors();
			}

		}

		return $query;
	}

	public static function begin($connection)
	{
		if (sqlsrv_begin_transaction($connection) === false) {
			return false;
		} else {
			return true;
		}
	}

	public static function commit($connection)
	{
		return sqlsrv_commit($connection);
	}

	public static function rollback($connection)
	{
		return sqlsrv_rollback($connection);
	}
}