autocommit off;
create table test_to_number_table(
    c1 varchar(500),
    c2 varchar(500),
    c3 varchar(500),
    c4 varchar(500)
);
insert into test_to_number_table (c1,c2,c3) values('dummy +$1.234e+02','"dummy" sc9.999eeee','1.234');
SELECT c3, to_number( c3, '9.999') FROM test_to_number_table;
SELECT c1,'"dummy" sc9.999eeee', to_number( c1,'"dummy" sc9.999eeee') FROM test_to_number_table;
SELECT c4, to_number( c4) FROM test_to_number_table;
drop table test_to_number_table;
rollback;
rollback;
