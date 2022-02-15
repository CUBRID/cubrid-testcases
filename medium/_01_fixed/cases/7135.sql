autocommit off;
create class c (cid int);
create class aa (Aid varchar(11), cinfo c);
create class b (Bid varchar(11), Ainfo a);
alter class aa add attribute Binfo set(b);
create trigger b_after_insert
after insert on b execute update a set Binfo = Binfo + {obj}
where Aid = obj.Ainfo.Aid and a.cinfo.cid = 1;
insert into c values (1) into :p0;
insert into aa values ('daveh', :p0, {}) into :p1;
insert into b values ('bill', :p1);
select * from b;
select * from aa;
insert into c values (1) into :p0;
insert into aa values ('smak', :p0, {}) into :p1;
insert into b values ('jeff', :p1);
select * from b;
select * from aa;
select b.Ainfo.Aid from b;
rollback;
