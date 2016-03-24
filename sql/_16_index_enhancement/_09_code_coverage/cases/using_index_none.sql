create class xoo ( a string, b string, c string);

create index idx1 on xoo (a);
create index idx2 on xoo (b);
create index idx3 on xoo (c);
insert into xoo values('UB090427000008', NULL, 'GENERAL');
insert into xoo values('UB090427000011', NULL, 'GENERAL');
insert into xoo values(null, NULL, 'GENERAL');

select * from xoo where a is null using index xoo.none;
update xoo set a = 'test' where a is null using index xoo.none;
delete from xoo where a = 'test' using index xoo.none;

select * from xoo where c > '' using index xoo.idx3 order by 1;
update xoo set c = 'test' where c > '' using index xoo.idx3;
delete from xoo where c = 'test' using index xoo.idx3;

update xoo set c = 'test2' where c > '' using index all except xoo.none;
select * from xoo where c > '' using index all except xoo.none;
delete from xoo where c = 'test2' using index all except xoo.none;

drop xoo;
