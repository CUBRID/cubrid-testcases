autocommit off;
create table t (id integer, textlabel varchar(255), description varchar(4096));
create index i_t_id_text on t(id, textlabel);
commit;
savepoint sp4;
truncate t;
select * from t where id > -1 using index i_t_id_text(+);
rollback to savepoint sp4;
select * from t where id > -1 using index i_t_id_text(+);
drop table t;
autocommit on;

