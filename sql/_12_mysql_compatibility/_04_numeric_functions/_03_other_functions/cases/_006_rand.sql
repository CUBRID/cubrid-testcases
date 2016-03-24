SELECT 'CUBRID OK', case when RAND()<1 then 1 else 0 end FROM db_root;

SELECT case when RAND(3)<3 then 3 else 0 end FROM db_root;

SELECT RAND('3') FROM db_root;

SELECT RAND('a') FROM db_root;

SELECT RAND(NULL) FROM db_root;

select case when rand(12345678901234512345)<1 then 1 else 0 end from db_root;

