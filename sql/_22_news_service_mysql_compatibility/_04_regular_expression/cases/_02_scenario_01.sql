create table part01(id int,d date,t time,f float,s varchar(10),m monetary,b bit) partition by hash(s) partitions 4;

insert into part01 values(1002,'2010-01-01','01:00:00',-0.8,'abc',$3.55,B'1');
insert into part01 values(1005,'2011-08-30','01:04:00',0.5,'xxg',$3.55,B'0');
insert into part01 values(1001,'2010-01-01','01:00:00',0.5,'112',$3.55,B'0');
insert into part01 values(1001,'2010-01-01','02:03:00',0.5,'got',$0.26,B'0');
insert into part01 values(1001,'2009-12-05','11:20:00',33.67,'top',$2.3,B'0');
insert into part01 values(1009,'2011-12-05','04:06:00',-0.0,'',$6.3,B'0');
insert into part01 values(2002,'2008-10-20','11:00:00',23.55,NULL,$0,B'0');
insert into part01 values(1004,'2008-10-20','01:00:00',10.999,'null',$0.0,B'1');
insert into part01 values(1004,'2007-03-12','01:07:00',5,'(txt)txttxt%',$2.3,B'0');
insert into part01 values(1005,'2011-05-23','01:00:00',0.0,'h\tlf',$2.3,B'1');
insert into part01 values(1003,'2010-01-01','21:00:05',-0.001,'-0',$0,B'0');
insert into part01 values(1005,'2009-12-05','11:22:00',0,'got',$3.55,B'1');
insert into part01 values(1002,'2006-12-05','11:11:11',2.6,'s.@1',$3.55,B'1');
insert into part01 values(1006,'2000-05-05','01:00:00',2.6,'hos\tp~ital',$6.5,B'1');
insert into part01 values(1007,'2009-12-05','01:23:34',0.5,'AAaaaaaaaa',$3.55,B'1');
insert into part01 values(1009,'2009-12-05','06:07:00',-0,'bbbbbbbbbb',$1120,B'1');

select id, d, t, f||'' f, s, m, b from part01 where s regexp binary '^[a-zA-Z0-9].@[0-3]$' order by 1 desc,2,3,4,5,6,7;
select id, d, t, f||'' f, s, m, b from part01 where s rlike '(txt)?%$' order by 2 desc,3,4,1,6,5,7; 
select id, d, t, f||'' f, s, m, b from part01 where d not rlike '2010$' order by 7,6,5,4,3 desc,2,1;
select id, d, t, f||'' f, s, m, b from part01 where cast(id as varchar(10)) rlike '^[^20].(02)$' order by 1,2,3,4,5,6,7;
select id, d, t, f||'' f, s, m, b from part01 where  s regexp '^[b]|[a]+$' order by 1,2,3,4,5,6;
select id, d, t, f||'' f, s, m, b from part01 where s regexp '[[.tab.]]' and s not rlike '[[.tilde.]]';
select id, d, t, f||'' f, s, m, b from part01 where cast(f as varchar(10)) regexp '^[0-9]+.[0-9]+$' or cast(f as varchar(10)) rlike '^[0-9]+$' order by 1,2,3,4,5,6,7;
select id, d, t, f||'' f, s, m, b from part01 where s rlike '^[[:alnum:]]+$' or s not rlike '[[:alpha:]]' order by 1,2,3,4,5,6,7;
select id, d, t, f||'' f, s, m, b from part01 where s regexp '[[:<:]][a-z]{5,6}[[:>:]]' order by 2,1,3,4,5,7,6;
select id, d, t, f||'' f, s, m, b from part01 where s regexp binary '^[A-Z]{2,6}' order by 1 desc,2 desc,3 desc,4 desc,5 desc,6 desc,7 desc; 
select id, d, t, f||'' f, s, m, b from part01 where s regexp '^[A-Z]{2,6}' order by 1,2,3,4,5,6,7; 

drop table part01;
