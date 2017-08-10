--[er]create reverse index on two fields at which create table using varchar and then drop index and select with indexname after drop

create table t (n varchar(10) not null, c varchar(10)); 
insert into t select to_char(rownum), 'aaaaa' from db_class where rownum < 10; 
create Reverse index t_n_index on t (n, c); 

select * from t order by n; 


drop index "t_n_index" on t;


select * from t using index t_n_index order by n; 

drop t;
rollback;
rollback;
rollback;
