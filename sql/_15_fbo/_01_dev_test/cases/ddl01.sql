--+ holdcas on;
-- -e -S --no-auto-commit
-- drop trigger y_trig;
-- drop y;

-- constraints, primary key
create class y1 (a int, b clob primary key, c string);

-- constraints, default value
--select char_to_clob('ddd') into :b from db_root;
create class y2 (a int, b clob default char_to_clob('ddd')); 

-- constraints, not null
create class y3 (c blob not null); 

-- normal definition
create class y (a int, b blob, c clob);
alter class y add attribute b2 blob, c2 clob;

-- single and multi column index
create index idx1 on y(b);
create index idx2 on y(a,c); 

-- trigger
-- create trigger y_insert_trig before insert on y(b) execute insert into y(a) values (0);
-- create trigger y_update_trig before update on y(c) execute insert into y(a) values (1);

-- object oriented feature, super
-- object oriented feature, shared
-- object oriented feaure, class attribute
drop y;
commit;
--+ holdcas off;
