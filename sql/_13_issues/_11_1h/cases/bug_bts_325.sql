create class xoo(a int);

insert into xoo values(10*10);

prepare st from 'insert into xoo values(?*?)' execute st using 10,20 drop prepare st;

select * from xoo order by 1;

drop table xoo;

