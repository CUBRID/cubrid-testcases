autocommit off;
create class a(i int, s1 char(10), s2 char(10), s3 char(3));
create class b(i int, s1 char(10), s2 char(10), s3 char(3));
create vclass vb(i int, s1 char(10), s2 char(10), s3 char(3)) 
as select i,s1,s2, s3 from b;
create trigger insrt_a
after insert on a execute insert into vb(i, s1, s2, s3) values(obj.i, obj.s1, obj.s2, obj.s3);

create trigger update_a after update on a(i) execute update vb set i=obj.i, s1=obj.s1, s2=obj.s2, s3=obj.s3;
create trigger delete_dt_emp before  delete on a execute delete from vb where i = obj.i;
insert into a values(1,'1','2','2');
select * from a;
select * from vb;
update a set i = 2;
select * from a;
select * from vb;
delete from a;
select * from a;
select * from vb;
rollback;
