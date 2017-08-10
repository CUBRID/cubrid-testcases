-- need change answer file. has bug.
-- R30 replace

create table btree(id int primary key, parentid int default 4, text clob);

insert into btree values(1,null,char_to_clob('A'));
insert into btree values(2,null,char_to_clob('B'));
insert into btree values(3,1,char_to_clob('AA'));
insert into btree values(4,1,char_to_clob('AB'));
insert into btree values(5,2,char_to_clob('BA'));
insert into btree values(6,2,char_to_clob('BB'));
insert into btree values(7,3,char_to_clob('AAA'));
insert into btree values(8,3,char_to_clob('AAB'));

insert into btree
	values(3,default,char_to_clob('-AA'));

replace into btree
	values(3,default,char_to_clob('-AA'));

replace into btree
	select id,4,text
		from btree
		where id in (7,8);

select id,parentid, clob_to_char(text) from btree order by id;

delete from btree;
drop table btree;
