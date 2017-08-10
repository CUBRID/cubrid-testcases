DROP TABLE IF EXISTS ORDBY_NULLS;
CREATE TABLE ORDBY_NULLS(groupid int,itemno varchar(10));

insert into ORDBY_NULLS values(1,null);
insert into ORDBY_NULLS values(1,null);
insert into ORDBY_NULLS values(1,null);
insert into ORDBY_NULLS values(1,1);
insert into ORDBY_NULLS values(1,2);
insert into ORDBY_NULLS values(1,3);
insert into ORDBY_NULLS values(1,4);
insert into ORDBY_NULLS values(1,5);
insert into ORDBY_NULLS values(2,null);
insert into ORDBY_NULLS values(2,null);
insert into ORDBY_NULLS values(2,null);
insert into ORDBY_NULLS values(2,6);
insert into ORDBY_NULLS values(2,7);
insert into ORDBY_NULLS values(2,8);
insert into ORDBY_NULLS values(2,9);
insert into ORDBY_NULLS values(2,10);
insert into ORDBY_NULLS values(2,11);
insert into ORDBY_NULLS values(null,null);
insert into ORDBY_NULLS values(null,null);
insert into ORDBY_NULLS values(null,null);
insert into ORDBY_NULLS values(null,12);
insert into ORDBY_NULLS values(null,13);
insert into ORDBY_NULLS values(null,14);
insert into ORDBY_NULLS values(null,15);
insert into ORDBY_NULLS values(null,16);
insert into ORDBY_NULLS values(null,17);


select itemno from ORDBY_NULLS order by itemno;
select itemno from ORDBY_NULLS order by itemno nulls first;
select itemno from ORDBY_NULLS order by itemno nulls last;

select itemno from ORDBY_NULLS order by itemno asc;
select itemno from ORDBY_NULLS order by itemno asc nulls first;
select itemno from ORDBY_NULLS order by itemno asc nulls last;

select itemno from ORDBY_NULLS order by itemno desc;
select itemno from ORDBY_NULLS order by itemno desc nulls first;
select itemno from ORDBY_NULLS order by itemno desc nulls last;

select groupid,itemno from ORDBY_NULLS order by groupid,itemno;
select groupid,itemno from ORDBY_NULLS order by groupid asc,itemno asc;
select groupid,itemno from ORDBY_NULLS order by groupid asc,itemno desc;
select groupid,itemno from ORDBY_NULLS order by groupid desc,itemno asc;
select groupid,itemno from ORDBY_NULLS order by groupid desc,itemno desc;

select groupid,itemno from ORDBY_NULLS order by groupid asc nulls last,itemno desc;
select groupid,itemno from ORDBY_NULLS order by groupid asc nulls last,itemno desc nulls first;

--partial sorting
select groupid,itemno from ORDBY_NULLS where groupid=1 order by itemno;
select groupid,itemno from ORDBY_NULLS where groupid=1 order by itemno nulls first;
select groupid,itemno from ORDBY_NULLS where groupid=1 order by itemno nulls last;
select groupid,itemno from ORDBY_NULLS where groupid=1 order by itemno desc nulls first;
select groupid,itemno from ORDBY_NULLS where groupid=1 order by itemno desc nulls last;



drop table ORDBY_NULLS;
