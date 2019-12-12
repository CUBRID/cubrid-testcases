--+ holdcas on;
--cases from dev

--INSERT and UPDATE operations 
create table t(i int);
insert into t values('123');
select * from t;
drop table t;


--Functions 
select mod('123','2');


--Comparison
select (date'2010-01-01' < datetime'2010-02-02 12:00:00 am');
select (datetime'2010-01-01' < '2010-02-02');
select ( 5.2 = '5.2') ;


--Arithmetic operations 
select date'2002-01-01' - datetime'2001-02-02 12:00:00 am';
select date'2002-01-01' + '10';
select date'2002-01-01'-'2001-01-01';
select date'2002-01-01'-'10';
select 4 + '5.2';
select '2002-01-01'+1;
select '3'*'2';

set system parameters 'plus_as_concat=yes';
select '1'+'1';
set system parameters 'plus_as_concat=no';
select '1'+'1';
set system parameters 'plus_as_concat=yes';

commit;
--+ holdcas off;
