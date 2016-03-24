SELECT CONCAT(_utf8'‘중국이’',2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT(1,2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT(true,2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT(false,2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT(~1,2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT(1|2,2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT(1&2,2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT(1^2,2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT('"''',2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT(1,'''','''','''','''','''','''','''') from db_root;
SELECT CONCAT('\/',2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT('!@#$%^&*~<>?',2,3,4,5,6,7,8,9) from db_root;

SELECT CONCAT('1','2','3','4','5','6','7','8','9') from db_root;
SELECT CONCAT(true,'2','3','4','5','6','7','8','9') from db_root;
SELECT CONCAT(false,'2','3','4','5','6','7','8','9') from db_root;
SELECT CONCAT(1>>2,'2','3','4','5','6','7','8','9') from db_root;
SELECT CONCAT(1<<2,'2','3','4','5','6','7','8','9') from db_root;

SELECT CONCAT(~1,~2,~3,~4,~5,~6,~7,~8,~9) from db_root;
SELECT concat_ws(CONCAT('a','b','c'),CONCAT(~1,~2,~3,~4,~5,~6,~7,~8,~9),CONCAT(~1,~2,~3,~4,~5,~6,~7,~8,~9)) from db_root;

SELECT CONCAT(if(2=1,'true','false'),~2,~3,~4,~5,~6,~7,~8,~9) from db_root;
SELECT CONCAT(if(2=1,true,false),~2,~3,~4,~5,~6,~7,~8,~9) from db_root;
SELECT char_length(CONCAT(~1,~2,~3,~4,~5,~6,~7,~8,~9)) from db_root;