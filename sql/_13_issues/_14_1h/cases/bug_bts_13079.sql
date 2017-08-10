--+ holdcas on;

DROP TABLE IF EXISTS hash_test;

create table hash_test(id int,  parentid int, text varchar(32))  PARTITION BY hash(id)  PARTITIONS 4;
insert into hash_test values (369, 71, 'AAAD'),(1048, 369, 'AAADC'),(71,11,'AAA');
SELECT * from hash_test t1 inner join hash_test t2 on t1.id=t2.parentid inner join hash_test t3 on t2.id=t3.parentid where t3.id=1048;

DROP TABLE IF EXISTS hash_test;

--+ holdcas off;
commit;

