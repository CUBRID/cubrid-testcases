-- group_concat numbers : short, int, float , double , monetary

create table tab1 (name char varying, sh smallint, i1 integer, b bigint, n numeric, f float, d double, m monetary );
insert into tab1 values('gigi',1,1023,123123,11123.01312,1.31,1311.31012,12);
insert into tab1 values('gigi',11123,2123456789,123123,11123.00000000001,1121.31,1e10,10512);
insert into tab1 values('gigi',11123,1023,-99123,-0.01010,1.31,1311.31012,12);
insert into tab1 values('gogu',1,1023,-123,-111312,1.31,1311.31012,12);
insert into tab1 values('gogu',11123,2123456789,123123,-111312,1121.31,1e10,10512);
insert into tab1 values('maria',1,1023,-99123,-0.01010,1.31,1311.31012,12);
insert into tab1 values('maria',11123,1023,0,0,1121.31,1e10,10512);
insert into tab1 values('maria',11123,2123456789,0,0,1121.31,1e10,10512);
insert into tab1 values('gogu',11123,2123456789,0,0,1121.31,1e10,10512);
insert into tab1 values('ion',-1,1023,9999999999,9999999,-1.31,-1311.31012,100);
insert into tab1 values('ion',11123,2123456789,9999999999,0,1121.31,1e10,10512);

select name,sh,i1,b,n,f,d,m from tab1 order by 1, 2, 3,4,5,6,7,8;

select group_concat(sh order by 1) from tab1 order by 1;

select group_concat(all sh order by 1) from tab1 order by 1;

select group_concat(distinct sh order by 1 desc) from tab1 order by 1;

select group_concat(unique sh order by 1) from tab1 order by 1;


select name,group_concat(sh order by 1 separator ' + ') from tab1 group by name;

select name,group_concat(distinct sh order by 1 separator ' + ') from tab1 group by name;


select name,group_concat(i1 order by 1 separator ' + ') from tab1 group by name;

select name,group_concat(distinct i1 order by 1 separator ' + ') from tab1 group by name;



select name,group_concat(f order by 1 separator ' + ') from tab1 group by name;

select name,group_concat(distinct f order by 1 separator ' + ') from tab1 group by name;



select name,group_concat(d order by 1 separator ' + ') from tab1 group by name;

select name,group_concat(distinct d order by 1 separator ' + ') from tab1 group by name;


select name,group_concat(m order by 1 separator ' + ') from tab1 group by name;

select name,group_concat(distinct m order by 1 separator ' + ') from tab1 group by name;


drop table tab1;

