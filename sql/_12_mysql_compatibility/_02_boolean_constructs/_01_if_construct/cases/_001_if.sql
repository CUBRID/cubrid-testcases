SELECT IF(1>2,2,3) from db_root;

SELECT IF(1>2,'2',3) from db_root;

SELECT IF(1>2,2,'3') from db_root;

SELECT IF('1'>2,2,3) from db_root;

SELECT IF(1>NULL,2,3) from db_root;

SELECT IF(1>NULL,2,3) from db_root;

SELECT IF(1>2,NULL,3) from db_root;

SELECT IF(1>2,2,NULL) from db_root;

SELECT IF(1<2,'yes','no') from db_root;

SELECT IF(STRCMP('test','test1')<>0,'no','yes') from db_root;

select if(123456789012345>12345678901234,1,0) from db_root;
