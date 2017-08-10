-- insert data  whith create hash partition class on a char field with size 8 and query data with function of trim and to_char and trunc and then drop class

create class hash_char (id int, test_char char(10))
partition by hash(test_char) partitions 8;

insert into hash_char values (1,'11');
insert into hash_char values (2,'22');
insert into hash_char values (3,'33');
select * from hash_char where test_char = replace('21', '1','2') ;
select * from hash_char where test_char = translate('21', '1' ,'2');
select * from hash_char where test_char = trim('     22     ');
select * from hash_char where test_char = to_char(11);
select * from hash_char where test_char = to_char(11+11);
select * from hash_char where test_char = to_char(11);
select * from hash_char where test_char = to_char(11+11);
drop class hash_char;
