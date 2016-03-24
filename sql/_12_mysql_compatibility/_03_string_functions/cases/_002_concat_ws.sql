SELECT CONCAT_WS(',','First name','Second name','Last Name') from db_root;

SELECT CONCAT_WS(',',NULL,'Second name','Last Name') from db_root;

SELECT CONCAT_WS(NULL,NULL,NULL) from db_root;

SELECT CONCAT_WS(',','First name',NULL,'Last Name') from db_root;

SELECT CONCAT_WS(1,'First name',2,3) from db_root;
