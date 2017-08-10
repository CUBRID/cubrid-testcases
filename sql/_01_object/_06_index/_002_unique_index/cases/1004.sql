-- create index on two fields at which create table using varchar and then query  values using index

create table t (n varchar(10) not null, c varchar(10)); 
insert into t select to_char(rownum), 'aaaaa' from db_class where rownum < 10; 
create unique index idx on t (n, c); 

select * from t order by n; 

select * from t using index none order by n; 

drop t;
rollback;
rollback;
