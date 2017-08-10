--TEST: insert into a bit/varbit column with bin() function


create table b1(a bit(100), b int);

--TEST: insert data into bit(n) column with bin() function
insert into b1 values(bin(100), 1);
insert into b1 values(bin(23456), 2), (bin(989342), 3);

--TEST: check insert result
select * from b1 order by 1;

drop table b1;



create table b2(a bit varying, b char(10));

--TEST: insert data into bit(n) column with bin() function
insert into b2 values(bin(-7384298749283), 'aaa');
insert into b2 values(bin(-489392043234), 'bbb'), (bin(989342.564345), 'ccc');

--TEST: check insert result
select * from b2 order by 1;

drop table b2;
