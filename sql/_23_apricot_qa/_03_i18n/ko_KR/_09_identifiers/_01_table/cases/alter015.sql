set system parameters 'alter_table_change_type_strict= no';
CREATE TABLE 테이블(칼럼 int);
INSERT INTO 테이블 values (11),(NULL),(22); 
SELECT * FROM 테이블  order by 1;
ALTER TABLE 테이블 change 칼럼 칼럼1 integer not null;
SELECT * FROM 테이블  order by 1;
drop class  테이블;