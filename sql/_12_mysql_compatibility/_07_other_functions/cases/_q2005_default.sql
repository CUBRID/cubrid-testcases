create table tree(id int,parentid int, text varchar(32), vname VARCHAR(16) default 'haha');

SELECT DEFAULT(id) FROM tree;
SELECT DEFAULT(text) FROM tree;
SELECT DEFAULT(vname) FROM tree;
SELECT DEFAULT(null) FROM tree;

insert into tree(id,text) values(1,'gga');
delete from tree where id = 1;
SELECT DEFAULT(vname) FROM tree;

insert into tree(id,text,vname) values(1,'gga','hoho');
SELECT DEFAULT(vname) FROM tree;

drop table tree;