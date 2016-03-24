
drop table if exists foo ;
drop table if exists foo1;

create table foo ( a varchar(10) );
create table foo1 ( a varchar(10) );
insert into foo values ( 'a' );

prepare stm from 'select ? from foo union select ? from foo1 '
execute stm using 'TEST1','TEST2';


drop table if exists foo ;
drop table if exists foo1;
