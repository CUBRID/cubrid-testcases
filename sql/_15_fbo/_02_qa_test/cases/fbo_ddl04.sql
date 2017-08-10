-- need change answer file. has bug.
-- R30 create like
create table cltree(id int not null, parentid int, text clob);

insert into cltree values(1,null,char_to_clob('A'));
insert into cltree values(2,null,char_to_clob('B'));
insert into cltree values(3,1,char_to_clob('AA'));
insert into cltree values(4,1,char_to_clob('AB'));
insert into cltree values(5,2,char_to_clob('BA'));
insert into cltree values(6,2,char_to_clob('BB'));
insert into cltree values(7,3,char_to_clob('AAB'));

create table cltree2 like cltree;
insert into cltree2 select * from cltree order by id;
select id,parentid,clob_to_char(text) from cltree2 order by id;

delete from cltree;
delete from cltree2;
drop cltree;
drop cltree2;