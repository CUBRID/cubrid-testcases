-- UPDATE ORDER BY ... simple cases

---  1 
create table tlong (i1 int, i2 int, i3 int, i4 int, i5 int, i6 int,i7 int, i8 int, i9 int, i10 int);
insert tlong values (1, 2, 3, 4, 5, 6,7,8,9,10);
insert tlong values (1, 2, 3, 4, 5, 6,7,8,9,10);

select * from tlong order by i1;

update tlong set i1 = 1, i2 = 1, i3 = i3 + 1, i4 = i4 + 1, i5 = i5 + 1, i6 = i6 + 1,i7=i7+1,i8=i8+1,i9=i9+1,i10=i10+1 order by i1;

select * from tlong order by i1;

drop table tlong;


-- multiple columns in ORDER BY..
---  2 
create table tab1 (i1 int, i2 int);
insert tab1 values (1, 2);
insert tab1 values (10, 20);
select * from tab1 order by i1;
update tab1 set i1 = i1+1, i2 = 3 order by i1,i2;

select * from tab1 order by i1;

drop table tab1;


---  3.  
create table tab1 (i1 int, i2 int);
insert tab1 values (1, 2);
insert tab1 values (10, 20);
select * from tab1 order by i1;
update tab1 set i1 = i1+1, i2 = 3 order by i2,i1;

select * from tab1 order by i1;

drop table tab1;

