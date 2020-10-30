--create range partition table with char data type,insert data to this table and select data in where clause with function lower,upper,lpad,rpad

create class range_char (id int, test_char char(2))
partition by range(test_char) (
partition p0 values less than ('00'),
partition p1 values less than ('11'),
partition p2 values less than ('22'),
partition p3 values less than maxvalue);

insert into range_char values (1,'11');
insert into range_char values (2,'22');
insert into range_char values (3,'33');
insert into range_char values(4,'AA');
insert into range_char values (5,'bb');
select * from range_char where test_char = lower('BB') order by 1;
select * from range_char where test_char = upper('aa') order by 1;
select * from range_char where test_char = lpad('bbbb', 2, '') order by 1;
select * from range_char where test_char = rpad('AAAA', 2, '') order by 1;
drop class range_char;
