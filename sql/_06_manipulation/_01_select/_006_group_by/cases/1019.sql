--Test group by
create class t(a char, b varchar(20), c int);
insert into t values('a', 'test1', 1);
insert into t values('a', 'test1', 2);
insert into t values('a', 'test2', 1);
insert into t values('a', 'test2', 2);

select a,b,c,sum(c) sc from t group by a,b,c order by 1;
select a,b,sum(c) sc from t group by a,b order by 1;
select a,b,c,sum(c) sc from t group by a,b,c order by 1;
select a,b,sum(c) sc from t group by a,b order by 1,2;


drop class t;
