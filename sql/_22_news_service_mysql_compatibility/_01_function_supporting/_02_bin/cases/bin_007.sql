--TEST: insert into a blob column with bin() function


create table b1(a blob, b int);

--TEST: insert data into blob column with bin() function
insert into b1 values(bit_to_blob(bin(100)), 1);
insert into b1 values(bit_to_blob(bin(23456)), 2), (bit_to_blob(bin(989342)), 3);

--TEST: check insert result
select blob_to_bit(a), b from b1 order by 1;

delete from b1;
drop table b1;



create table b2(a blob, b char(10));

--TEST: insert data into bit(n) column with bin() function
insert into b2 values(bit_to_blob(bin(-7384298749283)), 'aaa');
insert into b2 values(bit_to_blob(bin(-489392043234)), 'bbb'), (bit_to_blob(bin(989342.564345)), 'ccc');

--TEST: check insert result
select b, blob_to_bit(a) from b2 order by 1;

delete from b2;
drop table b2;
