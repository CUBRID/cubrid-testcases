--+ holdcas on;
--test max function with operators +,-,*,/,||
set system parameters 'compat_mode=cubrid';
create class tb(
		col1 varchar,
		col2 char(10),
		col3 string,
		col4 int,
		col5 date,
		col6 time,
		col7 timestamp
		);

insert into tb values('varchar01', 'char01', 'string01', 1, date'1/1/2001', time'1:1:1 am', timestamp'2/2/2002 2:2:2 am');
insert into tb values('varchar02', 'char02', 'string02', 2, date'1/2/2001', time'1:2:1 am', timestamp'2/3/2002 2:2:2 am');
insert into tb values('varchar03', 'char03', 'string03', 3, date'1/3/2001', time'1:3:1 am', timestamp'2/4/2002 2:2:2 am');

select max(col1)+'aa' from tb;
select max(col1)||'aa' from tb;

select max(col2)+'aa' from tb;
select max(col2)||'aa' from tb;

select max(col3)+'aa' from tb;
select max(col3)||'aa' from tb;

select max(col4)||'aa' from tb;
select max(col5)||'aa' from tb;
select max(col6)||'aa' from tb;
select max(col7)||'aa' from tb;

select max(col4)-3 from tb;
select max(col5)-3 from tb;
select max(col6)-3 from tb;
select max(col7)-3 from tb;

select max(col4)*3 from tb;

select max(col4)/3 from tb;

set system parameters 'compat_mode=mysql';
set system parameters 'pipes_as_concat=yes';

select max(col1)+'aa' from tb;
select max(col1)||'aa' from tb;

select max(col2)+'aa' from tb;
select max(col2)||'aa' from tb;

select max(col3)+'aa' from tb;
select max(col3)||'aa' from tb;

select max(col4)||'aa' from tb;
select max(col5)||'aa' from tb;
select max(col6)||'aa' from tb;
select max(col7)||'aa' from tb;

select max(col4)-3 from tb;
select max(col5)-3 from tb;
select max(col6)-3 from tb;
select max(col7)-3 from tb;

select max(col4)*3 from tb;

select max(col4)/3 from tb;

set system parameters 'pipes_as_concat=no';
set system parameters 'compat_mode=cubrid';

drop class tb;
commit;
--+ holdcas off;
