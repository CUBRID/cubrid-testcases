set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
--get oid with select  sql

create class t1(x char(1), y char(2));
create class t2(a char(1), b t1);

insert into t2 values('x',(insert into t1 values('a','b')));
insert into t2 values('y',(insert into t1 values('c','d')));
insert into t2 values('z',(insert into t1 values('e','f')));

select b into :h from t2 where  a = 'x';

select x, y into :g, :h from t1 where x = 'a';

drop class t1;
drop class t2;



--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
