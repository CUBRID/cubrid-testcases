autocommit off;
create class moof
(cntr int,
 attr set_of(int));
insert into moof(cntr,attr) values(1,{1,2,3});
insert into moof(cntr,attr) values(2,{4,5,6});
select a.cntr, b.cntr from moof a, moof b
where a.attr = b.attr;
rollback;
