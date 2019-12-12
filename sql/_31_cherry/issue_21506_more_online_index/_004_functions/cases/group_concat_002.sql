-- exceptional cases

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

create index aa on goo(name,adr) with online;
select name,adr from goo order by 1, 2;

select name, group_concat(adr order by 1) from goo group by name;
select name, group_concat(adr order by 1 separator '&&&') from goo group by name;
select name, group_concat(adr order by 1 separator n'^^^') from goo group by name;
select name, group_concat(distinct adr order by 1 separator n'~~~') from goo group by name;
select name, group_concat(adr + 'sss' order by 1) from goo group by name;
select name, group_concat(adr + n'sss' order by 1) from goo group by name;
select name, group_concat(adr + n'sss' order by 1 separator n'888') from goo group by name;
select name, group_concat(distinct adr + n'sss' order by 1 separator n'888') from goo group by name;




--null
select group_concat(null) from goo order by 1;

--empty
select group_concat() from goo order by 1;

--2 params
select group_concat(name, adr) from goo order by 1;

--without prentheses
select group_concat from goo order by 1;

--pass constant values
select adr,group_concat(1) from goo group by adr;
select adr,group_concat('aaa') from goo order by 1 group by name;
select group_concat(date'2000-10-10') from goo group by adr;
select group_concat(date'2000-10-10' separator '^^^^^^') from goo group by adr;
select group_concat('aaa' separator '~~~~~~~~') from goo group by adr;
select group_concat(distinct 'aaa' separator '~~~~~~~~') from goo group by adr;


drop table goo;

