-- alter table, not delete file. The spec says this feature is not support.
--R30 rename table

create table rntree2(id int not null, parentid int, text clob);

insert into rntree2 values(1,null,char_to_clob('A'));
insert into rntree2 values(2,null,char_to_clob('B'));
insert into rntree2 values(3,1,char_to_clob('AA'));
insert into rntree2 values(4,1,char_to_clob('AB'));
insert into rntree2 values(5,2,char_to_clob('BA'));
insert into rntree2 values(6,2,char_to_clob('BB'));
insert into rntree2 values(7,3,char_to_clob('AAB'));

rename rntree2 to rntree3;
rename rntree3 to rntree2;

-- alter table 
alter table rntree2 add column idx blob first;
insert into rntree2 values (bit_to_blob(X'1'),8,3,char_to_clob('ABB'));
alter table rntree2 drop column idx, rename to rntree3;
alter table rntree3 add column idx clob first;
insert into rntree3 values (char_to_clob('1'),8,3,char_to_clob('ABA'));

select id, parentid, clob_to_char(text) from rntree3 order by id, 2, 3;

delete from rntree3;
drop rntree3;