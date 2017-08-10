set system parameters 'alter_table_change_type_strict= yes';
CREATE TABLE 테이블(칼럼 int);
INSERT INTO 테이블 values (11),(NULL),(22); 
ALTER TABLE 테이블 change 칼럼 칼럼1 integer not null;
drop class  테이블;
set system parameters 'alter_table_change_type_strict= no';