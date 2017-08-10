--improve_bts_10531.sql

--Come from the developer's test case.
DROP TABLE IF EXISTS T_FIRST_LAST_NTH;
CREATE TABLE T_FIRST_LAST_NTH(groupid int,itemno int);
insert into T_FIRST_LAST_NTH values(1,null);
insert into T_FIRST_LAST_NTH values(1,null);
insert into T_FIRST_LAST_NTH values(1,1);
insert into T_FIRST_LAST_NTH values(1,null);
insert into T_FIRST_LAST_NTH values(1,2);
insert into T_FIRST_LAST_NTH values(1,3);
insert into T_FIRST_LAST_NTH values(1,4);
insert into T_FIRST_LAST_NTH values(1,5);
insert into T_FIRST_LAST_NTH values(2,null);
insert into T_FIRST_LAST_NTH values(2,null);
insert into T_FIRST_LAST_NTH values(2,null);
insert into T_FIRST_LAST_NTH values(2,6);
insert into T_FIRST_LAST_NTH values(2,7);
insert into T_FIRST_LAST_NTH values(2,8);
insert into T_FIRST_LAST_NTH values(2,9);
insert into T_FIRST_LAST_NTH values(2,10);
insert into T_FIRST_LAST_NTH values(2,11);
insert into T_FIRST_LAST_NTH values(3,null);
insert into T_FIRST_LAST_NTH values(3,null);
insert into T_FIRST_LAST_NTH values(3,null);
insert into T_FIRST_LAST_NTH values(3,12);
insert into T_FIRST_LAST_NTH values(3,13);
insert into T_FIRST_LAST_NTH values(3,14);
insert into T_FIRST_LAST_NTH values(3,15);
insert into T_FIRST_LAST_NTH values(3,16);
insert into T_FIRST_LAST_NTH values(3,17);

--first_value
select groupid, itemno, first_value(itemno) over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, first_value(itemno) respect nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, first_value(itemno) ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, first_value(itemno) over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, first_value(itemno) over(partition by groupid order by itemno desc) as ret_val from T_FIRST_LAST_NTH;

--last_value
select groupid, itemno, last_value(itemno) over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, last_value(itemno) respect nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, last_value(itemno) ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, last_value(itemno) over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, last_value(itemno) over(partition by groupid order by itemno desc) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, last_value(itemno) ignore nulls over(partition by groupid order by itemno desc) as ret_val from T_FIRST_LAST_NTH;

--nth_value
select groupid, itemno, nth_value(itemno,1) over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, nth_value(itemno,1) respect nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, nth_value(itemno,1) ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, nth_value(itemno,1) from first ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, nth_value(itemno,1) from first ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno,1) from last ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, nth_value(itemno,1) from last ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;

select groupid, itemno, nth_value(itemno,4) over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, nth_value(itemno,4) respect nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, nth_value(itemno,4) ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, nth_value(itemno,4) from first ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, nth_value(itemno,4) from first ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno,4) from last ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, nth_value(itemno,4) from last ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;

select groupid, itemno, nth_value(itemno,1.732) over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno,'1.732') over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;

--Column Alias
select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS;
select FIRST_VALUE(FIRST_VALUE) over () from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS);
select FIRST_VALUE(FIRST_VALUE) over () from ( select FIRST_VALUE(FIRST_VALUE)  over () as FIRST_VALUE from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS));

select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS;
select LAST_VALUE(LAST_VALUE) over () from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS);
select LAST_VALUE(LAST_VALUE) over () from ( select LAST_VALUE(LAST_VALUE)  over () as LAST_VALUE from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS));


select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS;
select NTH_VALUE(NTH_VALUE,1) over () from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS);
select NTH_VALUE(NTH_VALUE,1) over () from ( select NTH_VALUE(NTH_VALUE,1)  over () as NTH_VALUE from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS));

select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS;
select FIRST_VALUE(FIRST_VALUE) RESPECT NULLS over () from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS);
select FIRST_VALUE(FIRST_VALUE) RESPECT NULLS over () from ( select FIRST_VALUE(FIRST_VALUE)  over () as FIRST_VALUE from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS));

select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS;
select LAST_VALUE(LAST_VALUE) RESPECT NULLS over () from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS);
select LAST_VALUE(LAST_VALUE) RESPECT NULLS over () from ( select LAST_VALUE(LAST_VALUE)  over () as LAST_VALUE from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS));


select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS;
select NTH_VALUE(NTH_VALUE,1) over () from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS);
select NTH_VALUE(NTH_VALUE,1) over () from ( select NTH_VALUE(NTH_VALUE,1) over () as NTH_VALUE from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS));
select NTH_VALUE(NTH_VALUE,1) RESPECT NULLS over () from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS);
select NTH_VALUE(NTH_VALUE,1) RESPECT NULLS over () from ( select NTH_VALUE(NTH_VALUE,1) RESPECT NULLS over () as NTH_VALUE from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS));
select NTH_VALUE(NTH_VALUE,1) IGNORE NULLS over () from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS);
select NTH_VALUE(NTH_VALUE,1) IGNORE NULLS over () from ( select NTH_VALUE(NTH_VALUE,1) IGNORE NULLS over () as NTH_VALUE from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS));
select NTH_VALUE(NTH_VALUE,1) FROM FIRST RESPECT NULLS over () from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS);
select NTH_VALUE(NTH_VALUE,1) FROM FIRST RESPECT NULLS over () from ( select NTH_VALUE(NTH_VALUE,1) FROM FIRST RESPECT NULLS over () as NTH_VALUE from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS));
select NTH_VALUE(NTH_VALUE,1) FROM FIRST IGNORE NULLS over () from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS);
select NTH_VALUE(NTH_VALUE,1) FROM FIRST IGNORE NULLS over () from ( select NTH_VALUE(NTH_VALUE,1) FROM FIRST IGNORE NULLS over () as NTH_VALUE from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS));
select NTH_VALUE(NTH_VALUE,1) FROM LAST RESPECT NULLS over () from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS);
select NTH_VALUE(NTH_VALUE,1) FROM LAST RESPECT NULLS over () from ( select NTH_VALUE(NTH_VALUE,1) FROM LAST RESPECT NULLS over () as NTH_VALUE from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS));
select NTH_VALUE(NTH_VALUE,1) FROM LAST IGNORE NULLS over () from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS);
select NTH_VALUE(NTH_VALUE,1) FROM LAST IGNORE NULLS over () from ( select NTH_VALUE(NTH_VALUE,1) FROM LAST IGNORE NULLS over () as NTH_VALUE from (select 1 as FIRST_VALUE, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS));


select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls;
select first_value(first_value) over () from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls);
select first_value(first_value) over () from ( select first_value(first_value)  over () as first_value from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls));

select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls;
select last_value(last_value) over () from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls);
select last_value(last_value) over () from ( select last_value(last_value)  over () as last_value from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls));


select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls;
select nth_value(nth_value,1) over () from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls);
select nth_value(nth_value,1) over () from ( select nth_value(nth_value,1)  over () as nth_value from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls));

select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls;
select first_value(first_value) respect nulls over () from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls);
select first_value(first_value) respect nulls over () from ( select first_value(first_value)  over () as first_value from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls));

select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls;
select last_value(last_value) respect nulls over () from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls);
select last_value(last_value) respect nulls over () from ( select last_value(last_value)  over () as last_value from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls));


select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls;
select nth_value(nth_value,1) over () from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls);
select nth_value(nth_value,1) over () from ( select nth_value(nth_value,1) over () as nth_value from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls));
select nth_value(nth_value,1) respect nulls over () from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls);
select nth_value(nth_value,1) respect nulls over () from ( select nth_value(nth_value,1) respect nulls over () as nth_value from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls));
select nth_value(nth_value,1) ignore nulls over () from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls);
select nth_value(nth_value,1) ignore nulls over () from ( select nth_value(nth_value,1) ignore nulls over () as nth_value from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls));
select nth_value(nth_value,1) from first respect nulls over () from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls);
select nth_value(nth_value,1) from first respect nulls over () from ( select nth_value(nth_value,1) from first respect nulls over () as nth_value from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls));
select nth_value(nth_value,1) from first ignore nulls over () from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls);
select nth_value(nth_value,1) from first ignore nulls over () from ( select nth_value(nth_value,1) from first ignore nulls over () as nth_value from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls));
select nth_value(nth_value,1) from last respect nulls over () from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls);
select nth_value(nth_value,1) from last respect nulls over () from ( select nth_value(nth_value,1) from last respect nulls over () as nth_value from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls));
select nth_value(nth_value,1) from last ignore nulls over () from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls);
select nth_value(nth_value,1) from last ignore nulls over () from ( select nth_value(nth_value,1) from last ignore nulls over () as nth_value from (select 1 as first_value, 2 as last_value, 3 as nth_value, 4 as respect, 5 as nulls));


select 1 as first_value, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS;
select first_value(first_value) over () from (select 1 as first_value, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS);
select first_value(first_value) over () from ( select first_value(first_value)  over () as first_value from (select 1 as first_value, 2 as LAST_VALUE, 3 as NTH_VALUE, 4 as RESPECT, 5 as NULLS));


--User-defined Variable
set @v1=1, @v2=4, @v3=100, @v4=1.842;
select groupid, itemno, nth_value(itemno, @v1) from first ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno, @v2) from first ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno, @v3) from first ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno, @v4) from first ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;

--Prepared Statement
PREPARE st_1 FROM 'select groupid, itemno, nth_value(itemno, ?) from first ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;';
EXECUTE st_1 USING @v1;
EXECUTE st_1 USING @v2;
EXECUTE st_1 USING @v3;
EXECUTE st_1 USING @v4;
DEALLOCATE PREPARE st_1;

--Abnormal Cases
select groupid, itemno, first_value(itemno) respect over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, first_value(itemno) nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, nth_value(itemno,1) from over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, nth_value(itemno,1) last over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH;
select groupid, itemno, nth_value(itemno,'charValue') over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno,null) over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno,-1) over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno,0) over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno,0.651) over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno,1234567890) over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno,12345678901234567890) over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno,123456789012345678901111111111111111111) over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;

set @v5=0, @v6=0.712, @v7=-1, @v8=12345678901234567890, @v9='12345678901234567890111111111111111111111111111', @v10='char_value';
select groupid, itemno, nth_value(itemno, @v5) from first ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno, @v6) from first ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno, @v7) from first ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno, @v8) from first ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno, @v9) from first ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;
select groupid, itemno, nth_value(itemno, @v10) from first ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;

PREPARE st_1 FROM 'select groupid, itemno, nth_value(itemno, ?) from first ignore nulls over(partition by groupid order by itemno) as ret_val from T_FIRST_LAST_NTH where itemno is not null;';
EXECUTE st_1 USING @v5;
EXECUTE st_1 USING @v6;
EXECUTE st_1 USING @v7;
EXECUTE st_1 USING @v8;
EXECUTE st_1 USING @v9;
EXECUTE st_1 USING @v10;
DEALLOCATE PREPARE st_1;

drop variable @v1,@v2,@v3,@v4,@v5,@v6,@v7,@v8,@v9,@v10;
DROP TABLE IF EXISTS T_FIRST_LAST_NTH;
