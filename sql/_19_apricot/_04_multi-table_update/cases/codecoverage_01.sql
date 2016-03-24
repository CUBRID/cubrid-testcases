--SERVER
create table t4 (i1 int, i2 int, i3 int, i4 int, i5 int, i6 int, i7 int, i8 int, i9 int, i10 int, i11 int);

insert into t4 values (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
insert into t4 values (100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100);

update t4 set (i1, i2, i3, i4, i5, i6) = (select -i1, -i2, -i3, -i4, -i5, -i6 from t4 where i1=1), (i7, i8, i9, i10, i11) = (select -i7, -i8, -i9, -i10, -i11 from t4 where i7=7) where i1=1;
select * from t4 order by 1;

update t4 set (i1, i2, i3, i4, i5, i6, i7, i8, i9, i10)=(select -i1, -i2, -i3, -i4, -i5, -i6, -i7, -i8, -i9, -i10 from t4 where i1=100);
select * from t4 order by 11;

drop table t4;
