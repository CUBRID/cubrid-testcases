--add/change/drop enum column using alter table ¡¦ statement.


create table atr(a int);
insert into atr values(1), (2), (3);


--TEST: [er] add an enum column, without enumeration values.
alter table atr add column col1 enum;
alter table atr add column col1 enum();

--TEST: add an enum column
alter table atr add column col1 enum('a', 'b', 'c');
show columns in atr;
--TEST: [er] add an enum column, with default value
alter table atr add column col2 enum('a', 'b', 'c') default 'b';
--TEST: [er] add an enum column, with shared value
alter table atr add column col3 enum('a', 'b', 'c') shared 3;
--TEST: [er] add an enum column, with not null constraint
alter table atr add column col4 enum('aaa', 'bbb', 'ccc', 'ddd') not null;
--TEST: [er] add an enum column, with unique constraint
alter table atr add column col5 enum('a', 'b') unique after col4;
--TEST: [er] add an enum column, with pk constraint
alter table atr add column col6 enum('aaa', 'bbb', 'ccc') primary key;


--TEST: check the alter result
show columns in atr;

--TEST: insert data after alter table.
insert into atr values(4, 'b', 2, 1, 'bbb');
--TEST: [er] unique violation error
insert into atr values(4, 'b', 2, 1, 'bbb');

--TEST: check the insert result
select * from atr order by 1;


--TEST: add multiple columns
alter table atr add column (col7 enum('a', 'b', 'c') unique, col8 enum('aa', 'bb'), col9 enum('aaa', 'ccc') not null);
show columns in atr;

--TEST: insert after alter
insert into atr values(5, 'c', 2, 2, 'ccc', 3, 2, 1);
select * from atr order by 1;


drop table atr;

