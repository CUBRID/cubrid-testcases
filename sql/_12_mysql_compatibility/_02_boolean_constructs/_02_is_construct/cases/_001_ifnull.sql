SELECT IFNULL(1,0) from db_root;

SELECT IFNULL('1',0) from db_root;

SELECT IFNULL('1','0') from db_root;

SELECT IFNULL(NULL,10) from db_root;

SELECT IFNULL(1/0,10) from db_root;

SELECT IFNULL(1/0,'yes') from db_root;

select ifnull(123456789012345/1234567890,1) from db_root;
