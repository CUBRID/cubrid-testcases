autocommit off;
create class k(f float(32));
create vclass vk(vf float(32)) as select f from k;
insert into k values(12.345);
select * from k;
select * from vk;
rollback;
