--+ holdcas on;

create table foo(a char(30));
insert into foo values('1.7976931348623157E+500');
select * from foo;

set system parameters 'alter_table_change_type_strict=yes';
alter table foo change a a double;

set system parameters 'alter_table_change_type_strict=no';
alter table foo change a a double;
select * from foo;


drop table foo;



select cast ('1e400' as double);

select cast ('-1e400' as double);

select cast ('1e400 ' as double);

select cast ('-1e400 ' as double);



create table t1 (col char(50));
insert into t1 values (' -1e500');
insert into t1 values (' 1e500');

select * from t1 order by 1;

alter table t1 change col col double;

select * from t1 order by 1;

drop table t1;

commit;

--+ holdcas off;

