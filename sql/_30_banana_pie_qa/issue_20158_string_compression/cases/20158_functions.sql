--+ holdcas on;

drop table if exists t1;

create table t1(s1 string);

insert into t1 values('abc');

insert into t1 values(repeat('abcdef',200));

insert into t1 values(repeat('mnf',200)||space(100));


select reverse(s1) from t1 order by 1;

select position('fab' in s1) from t1 order by 1;

select octet_length(s1) from t1 order by 1; 

select rtrim(s1) from t1 order by 1;

select upper(s1) from t1 order by 1;

select insert(repeat('test',100),1,200,s1) from t1 order by 1;

select translate(s1,'cde','12345') from t1 order by 1;

select SUBSTRING_INDEX(s1,80,100) from t1 where s1 like '%ab%'; 

select SUBSTRING_INDEX(s1,'nf','50') from t1 where s1 like '%nf%'; 

insert into t1 values(repeat('a',300));

select strcmp(s1,repeat('a',300)) order by 1;

select right(s1,2) from t1 order by 1;

drop t1;

--+ holdcas off;