--Test rownum
create class t1 (c1 char(4), c2 varchar(20));

insert into t1 values('1111','1111');
insert into t1 values('1112','1111');
insert into t1 values('1113','1111');
insert into t1 values('1114','1111');

insert into t1 values('1111','1111');
insert into t1 values('1112','1111');
insert into t1 values('1113','1111');
insert into t1 values('1114','1111');


select max(rownum) from t1 order by 1;

drop class t1;