--create range partition table with char data type,insert data to this table and select data in where clause with function replace,translate,trim and to_char

create class range_char (id int, test_char char(10))
partition by range(test_char) (
partition p0 values less than ('00'),
partition p1 values less than ('11'),
partition p2 values less than ('22'),
partition p3 values less than maxvalue);

insert into range_char values (1,'11');
insert into range_char values (2,'22');
insert into range_char values (3,'33');
select * from range_char where test_char = replace('21', '1','2')  order by 1;
select * from range_char where test_char = translate('21', '1' ,'2') order by 1;
select * from range_char where test_char = trim('     22     ') order by 1;
select * from range_char where test_char = to_char(11) order by 1;
select * from range_char where test_char = to_char(11+11) order by 1;
drop class range_char;
