--+ holdcas on;

drop table if exists t1;
create class t1(col1 integer, col2 varchar(100020));

insert into t1 values(101, repeat('aaa',300));
insert into t1 values(102, repeat('bbb',300));
insert into t1 values(103, repeat('ccc',300));
insert into t1 values(104, repeat('ddd',300));
insert into t1 values(101, repeat('aaa',300));
insert into t1 values(102, repeat('bbb',300));
insert into t1 values(103, repeat('ccc',300));
insert into t1 values(104, repeat('ddd',300));
insert into t1 values(101, repeat('aaa',300));
insert into t1 values(102, repeat('bbb',300));
insert into t1 values(103, repeat('ccc',300));
insert into t1 values(104, repeat('ddd',300));
insert into t1 values(101, repeat('aaa',300));
insert into t1 values(102, repeat('bbb',300));
insert into t1 values(103, repeat('ccc',300));
insert into t1 values(104, repeat('ddd',300));

select col1, max(col2) from t1 where rownum < 10 group by col1 order by 1;

select count(col2) from t1 where col1 >100 group by col2 having col2>'b' order by col2 desc;

select col1,lead(col2,1) over(order by col2) prev_col2 from t1 group by col2 order by 1;    

select col1,row_number() over(partition by col1,col2 order by col2) as r_num from t1 group by col2 having col2>1 order by col1 desc limit 1;

select left(col2,col1) from t1 where col1>100 and col2>'aa' order by 1;

select col1,if(col2='aaaa','ok','nok') from t1;

create index idx_t1 on t1(col1,col2);

select col1, max(col2) from t1 where col1>100 and rownum < 10 group by col1 using index idx_t1 order by 1;

drop t1;



drop table if exists t2;

create class t2(col1 integer, col2 nchar varying(100020)) partition by hash(col2) partitions 3;

insert into t2 values(101, repeat(N'aaa',300));
insert into t2 values(102, repeat(N'bbb',300));
insert into t2 values(103, repeat(N'ccc',300));
insert into t2 values(104, repeat(N'ddd',300));
insert into t2 values(101, repeat(N'aaa',300));
insert into t2 values(102, repeat(N'bbb',300));
insert into t2 values(103, repeat(N'ccc',300));
insert into t2 values(104, repeat(N'ddd',300));
insert into t2 values(101, repeat(N'aaa',300));
insert into t2 values(102, repeat(N'bbb',300));
insert into t2 values(103, repeat(N'ccc',300));
insert into t2 values(104, repeat(N'ddd',300));
insert into t2 values(101, repeat(N'aaa',300));
insert into t2 values(102, repeat(N'bbb',300));
insert into t2 values(103, repeat(N'ccc',300));
insert into t2 values(104, repeat(N'ddd',300));

select col1, max(col2) from t2 where rownum < 20 group by col1 order by 1;

select count(col2) from t2__p__p1 where col1 >100 group by col2 having col2>n'b' order by col2 desc; 

select col1,lead(col2,1) over(order by col2) prev_col2 from t2 group by col2 order by 1 limit 1;

select distinct col1,row_number() over(partition by col1,col2 order by col2) as r_num from t2 group by col2 having col2>1 order by col1; 

create index idx_t2 on t2(col1,col2 desc);

select col1, max(col2) from t2 where col1>100 and col2>n'aaa' group by col1 using index idx_t2 order by 1 limit 1;

drop t2;



--+ holdcas off;