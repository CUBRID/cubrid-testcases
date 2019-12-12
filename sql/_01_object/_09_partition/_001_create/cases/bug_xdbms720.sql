create table list_test(id int ,
			test_int int,
			test_char char(50),
			test_varchar varchar(2000),
			test_datetime timestamp, primary key(id,test_int))
PARTITION BY  LIST (test_int) (
PARTITION P0 VALUES IN (10),
PARTITION P1 VALUES IN (20),
PARTITION P2 VALUES IN (30),
PARTITION P3 VALUES IN (40),
PARTITION P4 VALUES IN (50),
PARTITION P5 VALUES IN (60),
PARTITION P6 VALUES IN (70),
PARTITION P7 VALUES IN (80),
PARTITION P8 VALUES IN (90),
PARTITION P9 VALUES IN (100)
);
select * from list_test;
drop class list_test;
