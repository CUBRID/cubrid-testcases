--Get top n with rownum

create class t1(name varchar(20), score integer);
insert into t1 values('Jerry', 99);
insert into t1 values('Nancy', 100);
insert into t1 values('Tom', 89);
insert into t1 values('Jay', 69);
insert into t1 values('Lay', 79);
insert into t1 values('Cat', 59);

select * from (select name from t1 order by score desc) n 
where rownum < 4;

drop class t1;