
--+ holdcas on;

DROP TABLE IF EXISTS T_FIRST_LAST_NTH;
CREATE TABLE T_FIRST_LAST_NTH(groupid int,itemno int);
insert into T_FIRST_LAST_NTH values(1,null);
insert into T_FIRST_LAST_NTH values(1,null);
insert into T_FIRST_LAST_NTH values(1,1);
insert into T_FIRST_LAST_NTH values(1,null);
select groupid, itemno, first_value(itemno) ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;

DROP TABLE IF EXISTS T_FIRST_LAST_NTH;

--+ holdcas off;
commit;
