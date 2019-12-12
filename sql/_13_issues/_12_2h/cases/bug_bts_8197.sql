--+ holdcas on;
--set no_backslash_escapes=no
set system parameters 'no_backslash_escapes=no';
create table t8197(id int,col char(10));
insert into t8197 values(1,'abc\'efg');
insert into t8197 values(2,'efg\\abc');
insert into t8197 values(3,'aaa%bbb');
insert into t8197 values(4,'ccc_ddd');
select * from t8197 order by 1;
set system parameters 'require_like_escape_character=no';
select * from t8197 where col like '%c\'e%';
select * from t8197 where col like '%\\%';
select * from t8197 where col like '%\%%';
select * from t8197 where col like '%\_%';
select * from t8197 where col='abc\'efg';

set system parameters 'require_like_escape_character=yes';
select * from t8197 where col like '%c\'e%';
select * from t8197 where col like '%\\%';
select * from t8197 where col like '%\%%';
select * from t8197 where col like '%\_%';
select * from t8197 where col='abc\'efg';

--set no_backslash_escapes=yes
set system parameters 'require_like_escape_character=no';
set system parameters 'no_backslash_escapes=yes';
select * from t8197 where col like '%c\'e%';
select * from t8197 where col like '%\\%';
select * from t8197 where col like '%\%%';
select * from t8197 where col like '%\_%';
select * from t8197 where col='abc\'efg';

set system parameters 'require_like_escape_character=yes';
select * from t8197 where col like '%c\'e%';
select * from t8197 where col like '%\\%';
select * from t8197 where col like '%\%%';
select * from t8197 where col like '%\_%';
select * from t8197 where col='abc\'efg';

drop table t8197;
set system parameters 'no_backslash_escapes=yes';
set system parameters 'require_like_escape_character=no';
commit;
--+ holdcas off;


