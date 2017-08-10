--add/change/drop enum column using alter table ... statement.


create table atr(
	col1 enum('a', 'b', 'c'),
	col2 enum('aa', 'bb', 'cc'),
	col3 enum('aaa', 'bbb', 'ccc'),
	col4 enum('a', 'ab', 'abc') unique not null
);


insert into atr values(1, 2, 3, 3);
insert into atr values(2, 1, 2, 1);
insert into atr values(3, 3, 2, 2);


select * from atr order by 1;


--TEST: add index
alter table atr add index i1(col1 desc);
show columns in atr;

--TEST: alter column ... set default
alter table atr alter col1 set default 'b';
show columns in atr;

--TEST: [er] add constraint, unique constriant violation
alter table atr add constraint primary key(col3);

--TEST: [er] alter ... change, change value set
alter table atr change col2 col2 enum('ee', 'ff', 'gg') unique;

--TEST: [er] alter ... modify, change value set and add constraint
alter table atr modify col3 enum('bbb', 'ccc', 'eee') not null;

--TEST: alter ... modify, drop constraint
alter table atr modify col4 enum('a', 'ab', 'abc');
show columns in atr;

--TEST: add primary key and drop pk
alter table atr add constraint primary key(col4);
show columns in atr;
alter table atr drop primary key;
show columns in atr;

--TEST: drop column
alter table atr drop column col1, col2, col3, col4;
show columns in atr;


drop table atr;


