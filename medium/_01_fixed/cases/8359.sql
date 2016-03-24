autocommit off;

create class aa
  (key1 integer,
   key2 integer,
   l integer,
   u integer,
   unique(key1, key2));
   
create class bb
  (key1 integer,
   key2 integer,
   cond integer,
   unique(key1, key2));
insert into aa values(2, 1, 1, 1);
insert into bb values(1, 1, 1);

select count(*) from aa where aa.key1 = 2 and
 (select count(*) from bb where bb.key1 = 1 and aa.key2 = bb.key2 and cond = 1) 
     between l and u;
select count(*) from aa where aa.key1 = 2 and 1 between l and u;
select count(*) from aa
where aa.key1 = 2 and (select 1 from bb) between l and u;

drop aa, bb;
commit;
