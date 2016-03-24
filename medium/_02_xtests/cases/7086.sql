autocommit off;
        create class foo ( a int , b int );
        insert into foo values ( 1 , 10 );
        insert into foo values ( 1 , 20 );
        insert into foo values ( 2 , 10 );
        insert into foo values ( 2 , 10 );
        insert into foo values ( 2 , 10 );
        insert into foo values ( 2 , 10 );
        create view vfoo ( a int, b int ) as select distinct a, b from foo;
        create view vfo ( a string ) as select distinct cast( a as string )
        || cast ( b as string ) from foo;
select count(*) from vfoo
select count(*) from vfo
select avg(a), avg(b) from vfoo
rollback;

set system parameters 'compat_mode=mysql';

        create class foo ( a int , b int );
        insert into foo values ( 1 , 10 );
        insert into foo values ( 1 , 20 );
        insert into foo values ( 2 , 10 );
        insert into foo values ( 2 , 10 );
        insert into foo values ( 2 , 10 );
        insert into foo values ( 2 , 10 );
        create view vfoo ( a int, b int ) as select distinct a, b from foo;
        create view vfo ( a string ) as select distinct concat(a, b) from foo;
select count(*) from vfoo
select count(*) from vfo
select avg(a), avg(b) from vfoo
rollback;

set system parameters 'compat_mode=cubrid';

