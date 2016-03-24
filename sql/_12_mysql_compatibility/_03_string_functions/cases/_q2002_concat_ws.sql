SELECT CONCAT_WS(_utf8'중국이',2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT_WS(1,2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT_WS(true,2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT_WS(false,2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT_WS(~1,2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT_WS(1|2,2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT_WS(1&2,2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT_WS(1^2,2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT_WS('"''',2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT_WS(1,'''','''','''','''','''','''','''') from db_root;
SELECT CONCAT_WS('\/',2,3,4,5,6,7,8,9) from db_root;
SELECT CONCAT_WS('!@#$%^&*~<>?',2,3,4,5,6,7,8,9) from db_root;

SELECT CONCAT_WS('1','2','3','4','5','6','7','8','9') from db_root;
SELECT CONCAT_WS(true,'2','3','4','5','6','7','8','9') from db_root;
SELECT CONCAT_WS(false,'2','3','4','5','6','7','8','9') from db_root;
SELECT CONCAT_WS(1>>2,'2','3','4','5','6','7','8','9') from db_root;
SELECT CONCAT_WS(1<<2,'2','3','4','5','6','7','8','9') from db_root;

SELECT CONCAT_WS(~1,~2,~3,~4,~5,~6,~7,~8,~9) from db_root;

SELECT CONCAT_WS(if(2=1,'true','false'),~2,~3,~4,~5,~6,~7,~8,~9) from db_root;
SELECT CONCAT_WS(if(2=1,true,false),~2,~3,~4,~5,~6,~7,~8,~9) from db_root;
SELECT char_length(CONCAT_WS(~1,~2,~3,~4,~5,~6,~7,~8,~9)) from db_root;
SELECT CONCAT_WS(CONCAT_WS('A','B','C'),CONCAT_WS('D','E','F'),CONCAT_WS('G','H','I')) FROM DB_ROOT;

SELECT CONCAT_WS(
CONCAT_WS(CONCAT_WS('A','B','C'),CONCAT_WS('D','E','F'),CONCAT_WS('G','H','I')),
CONCAT_WS(CONCAT_WS('A','B','C'),CONCAT_WS('D','E','F'),CONCAT_WS('G','H','I')),
CONCAT_WS(CONCAT_WS('A','B','C'),CONCAT_WS('D','E','F'),CONCAT_WS('G','H','I')),
CONCAT_WS(CONCAT_WS('A','B','C'),CONCAT_WS('D','E','F'),CONCAT_WS('G','H','I')),
CONCAT_WS(CONCAT_WS('A','B','C'),CONCAT_WS('D','E','F'),CONCAT_WS('G','H','I')),
CONCAT_WS(CONCAT_WS('A','B','C'),CONCAT_WS('D','E','F'),CONCAT_WS('G','H','I'))
					) FROM DB_ROOT;
