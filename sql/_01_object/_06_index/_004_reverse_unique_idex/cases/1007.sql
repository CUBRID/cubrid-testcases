-- create reverse unique index on two fields at which create table using varchar and then drop index and insert/update/select/delete after drop

create table t (n varchar(10) not null, c varchar(10)); 
insert into t select to_char(rownum), 'aaaaa' from db_class where rownum < 10; 
create Reverse unique index t_n_index on t (n, c); 

select * from t order by n; 


drop Reverse unique index "t_n_index" on t;


insert into t select to_char(rownum), 'aaaaa' from db_class where rownum < 10; 

UPDATE t SET c='bbbbb';

delete  from t;

select * from t order by n; 

drop t;

rollback;
rollback;
rollback;
