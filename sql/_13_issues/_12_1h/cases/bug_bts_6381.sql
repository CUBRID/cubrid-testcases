select 1;   

select 1; --
select 1; select --
 2;

select 1; //
select 1; select //
 2;

select 1; /*  */   
select 1; select /* */
 2;

select 1; select /*
 */ 2;


 / - ;
 select 
2;
 select --
1;

 select //
2;

create table t2 (c char(20));
set system parameters 'no_backslash_escapes=no';
insert into t2 values ('asdf\'asdf');
set system parameters 'ansi_quotes=no';
insert into t2 values ("asdf\"asdf");
select * from t2;
drop table t2;


create table t2 (c char(20));
set system parameters 'no_backslash_escapes=yes';
insert into t2 values ('asdf\'asdf');
set system parameters 'ansi_quotes=no';
insert into t2 values ("asdf\"asdf");
select * from t2;
drop table t2;
set system parameters 'ansi_quotes=yes';

