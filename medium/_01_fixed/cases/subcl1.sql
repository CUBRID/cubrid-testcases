autocommit off;
create class xxx (abc int);
create class yyy as subclass of xxx;
create class zzz (s9 string, x9 xxx);

insert into zzz values ('x',  insert into xxx values (10));
insert into zzz values ('y', insert into yyy values (20));

select zzz.x9{xxx}.abc from zzz,xxx order by 1;
select zzz.x9{yyy}.abc from zzz,yyy order by 1;

-- Following sql statement is commented temporarily due to CUBRIDSUS4098 issues	
-- select zzz.x9.abc from zzz order by 1;
-- select zzz.x9 from zzz order by 1;		
-- select * from zzz,yyy where 0 <> zzz.x9{yyy}.abc order by 1

select zzz.x9{xxx}.abc from zzz,xxx order by 1;
select zzz.x9{yyy}.abc from zzz,yyy order by 1;
select * from zzz,yyy where 0 <> zzz.x9{yyy}.abc;


drop xxx, yyy, zzz;
rollback;
