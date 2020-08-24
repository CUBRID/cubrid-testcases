set system parameters 'create_table_reuseoid=no';
--TEST: [Multi-table Delete] No error returns when table name is not unique in multi-table delete statement.


create table t (id int);
create table u (id int);

create view v as select * from t;
create view w as select * from u;

-- should work
select 'should work';

delete t, u from t, u;
delete u, t from t, u;
delete x, y from t x, u y;
delete v, w from v, w;
delete x, y from v x, w y;

delete from t, u using t, u;
delete from u, t using t, u;
delete from x, y using t x, u y;
delete from v, w using v, w;
delete from x, y using v x, w y;

-- should not work
select 'should not work';

delete t, t from t;
delete t, u, t from t, u;
delete u, t, u from t, u;
delete t, t, t from t, u;
delete x, y, x from t x, u y;
delete t.*, t from t;
delete x.*, x from t x;
delete v, w, v from v, w;
delete v.*, v from v;
delete x, y, x from v x, w y;
delete x.*, y, x from v x, w y;

delete from t, t using t;
delete from t, u, t using t, u;
delete from u, t, u using t, u;
delete from t, t, t using t, u;
delete from x, y, x using t x, u y;
delete from v, w, v using v, w;
delete from x, y, x using v x, w y;

-- cleanup
drop view v, w;
drop table t, u;

set system parameters 'create_table_reuseoid=yes';
