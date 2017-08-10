-- test with blob/clob data


create table goo (name char(10), img blob, doc clob);
insert into goo values ( 'google', bit_to_blob(X'abc012'), char_to_clob('google.com'));
insert into goo values ( 'google', bit_to_blob(B'1010011'), char_to_clob('www.google.com'));
insert into goo values ( 'yahoo', bit_to_blob(X'ffff'), char_to_clob('www.yahoo.com'));
insert into goo values ( NULL , NULL, char_to_clob('www.google.com'));
insert into goo values ( 'google1', bit_to_blob(B'1011101'), NULL);
insert into goo values ( 'cnn', bit_to_blob(B'1010011'), char_to_clob('www.cnn.com'));
insert into goo values ( 'google2', bit_to_blob(X'ffff'), char_to_clob('www.google.com'));

select name, blob_to_bit(img), clob_to_char(doc) from goo order by 1, 2;

-- no separator
select group_concat(name order by name) from goo order by 1;
--[er]
select group_concat(img order by 1) from goo order by 1;
select group_concat(blob_to_bit(img) order by 1) from goo order by 1;
--[er]
select group_concat(doc order by 1) from goo order by 1;
select group_concat(clob_to_char(doc) order by 1) from goo order by 1;

select group_concat(all name order by 1) from goo order by 1;
select group_concat(all blob_to_bit(img) order by 1) from goo order by 1;
select group_concat(all clob_to_char(doc) order by 1) from goo order by 1;

select group_concat(distinct name order by name) from goo order by 1;
select group_concat(distinct blob_to_bit(img) order by 1) from goo order by 1;
select group_concat(distinct clob_to_char(doc) order by 1) from goo order by 1;

select group_concat(unique name order by 1) from goo order by 1;
--[er] without group by
select name, group_concat(unique blob_to_bit(img) order by 1) from goo order by 1;
select name, group_concat(unique blob_to_bit(img) order by 1) from goo group by name;
select blob_to_bit(img), group_concat(unique clob_to_char(doc) order by 1) from goo order by 1;
select name, blob_to_bit(img), group_concat(unique clob_to_char(doc) order by 1) from goo group by name;


-- SEPARATOR
select group_concat(name  order by name separator ' + ') from goo order by 1;
select group_concat(blob_to_bit(img) order by blob_to_bit(img) separator '---') from goo order by 1;
select group_concat(clob_to_char(doc) order by 1 separator '***') from goo order by 1;

select group_concat(all name  order by 1 separator ' + ') from goo order by 1;
--[er]
select name, group_concat(all blob_to_bit(img) separator '---') from goo group by name;
select name, group_concat(all blob_to_bit(img) separator X'ab') from goo group by name;
select name, group_concat(all clob_to_char(doc) order by 1 separator '***') from goo group by name;

select group_concat(distinct name  order by name separator ' + ') from goo order by 1;
select name, group_concat(distinct blob_to_bit(img) order by 1 separator B'0101') from (select * from goo order by 1, blob_to_bit(img),clob_to_char(doc)) group by blob_to_bit(img);
select name, group_concat(distinct clob_to_char(doc) order by 1 separator '***') from (select * from goo order by 1, blob_to_bit(img),clob_to_char(doc)) group by clob_to_char(doc);



-- ASC
select group_concat(name order by name asc) from goo order by 1;
select group_concat(distinct blob_to_bit(img) order by 1 asc) from goo order by 1;
select name,group_concat(clob_to_char(doc) order by 1 asc ) from goo group by name;
select group_concat(all blob_to_bit(img) order by 1 asc separator '/') from goo order by 1;
select name,group_concat(clob_to_char(doc) order by 1 asc separator '...') from goo group by name;


-- DESC
select group_concat(name order by name desc) from goo order by 1;
select group_concat(distinct blob_to_bit(img) order by 1 desc) from goo order by 1;
select name,group_concat(clob_to_char(doc) order by 1 desc ) from goo group by name;
select group_concat(all blob_to_bit(img) order by 1 desc separator X'cd') from goo order by 1;
select name,group_concat(clob_to_char(doc) order by 1 desc separator '...') from goo group by name;

delete from goo;

drop table goo;

