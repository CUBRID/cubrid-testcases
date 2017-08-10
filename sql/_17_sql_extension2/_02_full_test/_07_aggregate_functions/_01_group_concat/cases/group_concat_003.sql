--pass unmatched value to SEPERATOR param


create table goo (name nchar(10), adr nchar varying);
insert into goo values ( n'google',n'www.google.com');
insert into goo values ( n'google',n'www.google.com');
insert into goo values ( n'yahoo',n'www.yahoo.com');
insert into goo values ( NULL ,n'www.google.com');
insert into goo values ( n'google',NULL);
insert into goo values ( n'cnn',n'www.cnn.com');
insert into goo values ( n'google1',n'www.google.com');
insert into goo values ( n'yahoo1',n'www.yahoo.com');
insert into goo values ( n'google',n'www.google.us');
insert into goo values ( n'yahoo',n'www.yahoo.us');
insert into goo values ( n'yahoo',n'');
insert into goo values ( n'',n'www.google.us');

select name,adr from goo order by 1, 2;

--error, unmatched type of separator
select group_concat(distinct name separator 111) from goo order by 1;
--error, unmatched type of separator
select group_concat(all name separator {1,2,3}) from goo order by 1;
--error, unmatched type of separator
select group_concat(distinct adr separator date'1909-10-12') from goo order by 1;
--error, unmatched type of separator
select group_concat(unique adr separator time'10:10:10') from goo order by 1;
--error, unmatched type of separator
select group_concat(distinct name separator char_to_clob('+')) from goo order by 1;
--error, unmatched type of separator
select group_concat(all name separator bit_to_blob(X'abc')) from goo order by 1;


drop table goo;

