create table tbl(d date);
insert into tbl values('2012-05-28');

prepare st from 'delete from tbl where d in (?)';
execute st using '2012-05-28';
select * from tbl;
drop tbl;
drop prepare st;
