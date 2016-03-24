
create table t1(a int, b int, c int, d int);
insert into t1 select rownum%5, rownum%10, rownum, rownum from db_class x1, db_class x2, db_class x3 limit 50000;

set @v=1;

select * from (select (@v:=@v+1)%10 col from t1 where a>-1 and b>-1 group by col) order by 1;

create index idx_t1_all on t1(a,b,c,d);
update statistics on t1;

set @v=1;
select * from (select (@v:=@v+1)%10 col from t1 where a>-1 and b>-1 group by col ) order by 1;

drop variable @v;

drop table t1;

