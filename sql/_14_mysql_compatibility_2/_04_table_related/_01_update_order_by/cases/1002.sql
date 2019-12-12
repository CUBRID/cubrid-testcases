-- UPDATE ORDER BY ...   checking syntax 

---  1   - ORDER ASC
create table tab1 (i1 int, i2 int);
insert tab1 values (1, 2);
insert tab1 values (10, 20);
insert tab1 values (100, 200);

select * from tab1 order by i1;

update tab1 set i1 = i1+1, i2 = 3 order by i1,i2 asc;

select * from tab1 order by i1;

drop table tab1;


---  2 - ORDER DESC
create table tab1 (i1 int, i2 int);
insert tab1 values (1, 2);
insert tab1 values (10, 20);
insert tab1 values (100, 200);
select * from tab1 order by i1;

update tab1 set i1 = i1+1, i2 = 3 order by i1,i2 desc;

select * from tab1 order by i1;

drop table tab1;


---  3.  WHERE + ORDER BY 
create table tab1 (i1 int, i2 int);
insert tab1 values (1, 2);
insert tab1 values (10, 20);
insert tab1 values (100, 200);
select * from tab1 order by i1;

update tab1 set i1 = i1+1, i2 = 3 where i1<10 order by i2,i1;

select * from tab1 order by i1;

drop table tab1;


---  3a.  ORDER BY + WHERE 
create table tab1 (i1 int, i2 int);
insert tab1 values (1, 2);
insert tab1 values (10, 20);
insert tab1 values (100, 200);
select * from tab1 order by i1;

-- should fail (syntax)
update tab1 set i1 = i1+1, i2 = 3 order by i2,i1  where i1<10;

select * from tab1 order by i1;

drop table tab1;

---  4.  WHERE ordnum_by() + ORDER BY 
create table tab1 (i1 int, i2 int);
insert tab1 values (1, 2);
insert tab1 values (10, 20);
insert tab1 values (100, 200);
select * from tab1 order by i1;

-- should fail ()
update tab1 set i1 = i1+1, i2 = 3 where orderby_num()<2 order by i2,i1;

select * from tab1 order by i1;

drop table tab1;



---  5.  ORDER + FOR ordnum_by()
create table tab1 (i1 int, i2 int);
insert tab1 values (1, 2);
insert tab1 values (10, 20);
insert tab1 values (100, 200);
select * from tab1 order by i1;

update tab1 set i1 = i1+1, i2 = 3 order by i2,i1 for orderby_num()<=2;

select * from tab1 order by i1;

drop table tab1;


---  6.  ORDER + FOR inst_num()
create table tab1 (i1 int, i2 int);
insert tab1 values (1, 2);
insert tab1 values (10, 20);
insert tab1 values (100, 200);
select * from tab1 order by i1;

-- should fail ()
update tab1 set i1 = i1+1, i2 = 3 order by i2,i1 for inst_num()<=2;

select * from tab1 order by i1;

drop table tab1;



---  7   - ORDER BY .. LIMIT
create table tab1 (i1 int, i2 int);
insert tab1 values (1, 2);
insert tab1 values (10, 20);
insert tab1 values (100, 200);

select * from tab1 order by i1;

update tab1 set i1 = i1+1, i2 = 3 order by i1,i2 LIMIT 2;

select * from tab1 order by i1;

drop table tab1;



---  8   - ORDER BY + FOR.. LIMIT
create table tab1 (i1 int, i2 int,i3 int);
insert tab1 values (1, 1,0), (4,4,0),(2,2,0),(5,5,0),(3,3,0),(6,6,0);

select * from tab1 order by i2;
----   WARN : the result is not correct 
-- FOR is not working as expected, remove test
--update tab1 set i1 = i1+1, i3 = -1 order by i2,i1 for i2<4 LIMIT 2;

select * from tab1 order by i2;

drop table tab1;


---  8.1   - ORDER BY + FOR.. LIMIT
create table tab1 (i1 int, i2 int,i3 int);
insert tab1 values (1, 1,0), (4,4,0),(2,2,0),(5,5,0),(3,3,0),(6,6,0);

select * from tab1 order by i2;
----   WARN : the result is not correct
-- FOR is not working as expected, remove test
--update tab1 set i1 = i1+1, i3 = -1 order by i2,i1 for i2<3 LIMIT 4;

select * from tab1 order by i2;

drop table tab1;


---  8.2   - ORDER BY + FOR..  
create table tab1 (i1 int, i2 int,i3 int);
insert tab1 values (1, 1,0), (4,4,0),(2,2,0),(5,5,0),(3,3,0),(6,6,0);

select * from tab1 order by i2;
----   WARN : the result is not correct 
-- FOR is not working as expected, remove test
--update tab1 set i1 = i1+1, i3 = -1 order by i2,i1 for i2<3 and orderby_num() <= 4;

select * from tab1 order by i2;

drop table tab1;



---  8.3   - ORDER BY + FOR..  
create table tab1 (i1 int, i2 int,i3 int);
insert tab1 values (1, 1,0), (4,4,0),(2,2,0),(5,5,0),(3,3,0),(6,6,0);

select * from tab1 order by i2;
----   WARN : the result is not correct 
-- FOR is not working as expected, remove test
--update tab1 set i1 = i1+1, i3 = -1 order by i2,i1 for orderby_num() <= 4 and i2 < 3;

select * from tab1 order by i2;

drop table tab1;


---  9   - ORDER BY + FOR.. LIMIT
create table tab1 (i1 int, i2 int);
insert tab1 values (1, 2);
insert tab1 values (10, 20);
insert tab1 values (100, 200);

select * from tab1 order by i1;
-- should fail ()
update tab1 set i1 = i1+1, i2 = 3 order by i1,i2 for inst_num()<=2 LIMIT 2;

select * from tab1 order by i1;

drop table tab1;

---  9   - ORDER BY + FOR.. LIMIT
create table tab1 (i1 int, i2 int);
insert tab1 values (1, 2);
insert tab1 values (10, 20);
insert tab1 values (100, 200);

select * from tab1 order by i1;
-- should fail ()
update tab1 set i1 = i1+1, i2 = 3 order by i1,i2 for orderby_num()<=2 LIMIT 2;

select * from tab1 order by i1;

drop table tab1;



