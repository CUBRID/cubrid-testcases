-- group_concat nchar,var nchar

create table tab1 (name nchar(10), adr nchar varying);
insert into tab1 values ( n'google',n'www.google.com');
insert into tab1 values ( n'google',n'www.google.com');
insert into tab1 values ( n'yahoo',n'www.yahoo.com');
insert into tab1 values ( NULL ,n'www.google.com');
insert into tab1 values ( n'google',NULL);
insert into tab1 values ( n'cnn',n'www.cnn.com');
insert into tab1 values ( n'google1',n'www.google.com');
insert into tab1 values ( n'yahoo1',n'www.yahoo.com');
insert into tab1 values ( n'google',n'www.google.us');
insert into tab1 values ( n'yahoo',n'www.yahoo.us');
insert into tab1 values ( n'yahoo','');
insert into tab1 values ( '',n'www.google.us');

select name,adr from tab1 order by 1, 2;

select group_concat(name order by 1) from tab1 order by 1;

select group_concat(all name  order by 1) from tab1 order by 1;

select group_concat(distinct name order by 1) from tab1 order by 1;

select group_concat(unique name order by 1) from tab1 order by 1;

select adr,group_concat(name  order by 1) from tab1 group by adr;

select adr,group_concat(all name  order by 1) from tab1 group by adr;

select adr,group_concat(distinct name order by 1) from tab1 group by adr;

select adr,group_concat(unique name order by 1) from tab1 group by adr;

select name,group_concat(name order by 1) from tab1 group by name;

select name,group_concat(all name order by 1) from tab1 group by name;

select name,group_concat(distinct name order by 1) from tab1 group by name;

select name,group_concat(unique name order by 1) from tab1 group by name;

select name,group_concat(adr order by 1) from tab1 group by name;

select name,group_concat(all adr order by 1) from tab1 group by name;

select name,group_concat(distinct adr order by 1 desc) from tab1 group by name;

select name,group_concat(unique adr order by 1) from tab1 group by name;


select group_concat(name  order by 1 separator n' + ') from tab1 order by 1;

select group_concat(all name  order by 1 separator n' + ') from tab1 order by 1;

select group_concat(distinct name  order by 1 separator n' + ') from tab1 order by 1;

select group_concat(unique name  order by 1 separator n' + ') from tab1 order by 1;

select adr,group_concat(name  order by 1 separator n' + ') from tab1 group by adr;

select adr,group_concat(all name  order by 1 separator n' + ') from tab1 group by adr;

select adr,group_concat(distinct name  order by 1 separator n' + ') from tab1 group by adr;

select adr,group_concat(unique name  order by 1 separator n' + ') from tab1 group by adr;

select name,group_concat(name order by 1 separator n' + ') from tab1 group by name;

select name,group_concat(all name order by 1 separator n' + ') from tab1 group by name;

select name,group_concat(distinct name order by 1 separator n' + ') from tab1 group by name;

select name,group_concat(unique name order by 1 separator n' + ') from tab1 group by name;

select name,group_concat(adr order by 1 separator n' + ') from tab1 group by name;

select name,group_concat(all adr order by 1 separator n' + ') from tab1 group by name;

select name,group_concat(distinct adr order by 1 separator n' + ') from tab1 group by name;

select name,group_concat(unique adr order by 1 desc separator n' + ') from tab1 group by name;

drop table tab1;

