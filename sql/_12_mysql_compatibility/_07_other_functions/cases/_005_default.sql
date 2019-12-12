create table tree(id int,parentid int, text varchar(32));

SELECT DEFAULT(id) FROM tree;

SELECT DEFAULT(text) FROM tree;

SELECT DEFAULT(null) FROM tree;

drop table tree;