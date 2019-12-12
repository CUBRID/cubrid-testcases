-- UPDATE ... ORDER BY expressions

create table tab1 (i1 integer ,i2 integer, i3 integer );

insert into tab1 values (4,4,0), (1,1,0) , (2,2,0), (3,3,0), (6,6,0), (5,5,0), (7,7,0);

select * from tab1 order by i2;
select * from tab1 order by (i2-3)*(i2-3)-5,i2; 
update tab1 set i1=i1+1, i3=i2+2 order by (i2-3)*(i2-3)-5,i2 limit 2;

select * from tab1 order by i2;

drop tab1; 


-- ORDER BY expression with function
create table tab1 (i1 integer ,s2 varchar, i3 integer );

insert into tab1 values (4,'1234',0), (1,'1',0) , (2,'12',0), (3,'123',0), (6,'123456',0), (5,'12345',0), (7,'1234567',0);

select * from tab1 order by s2,i1;
select * from tab1 order by char_length(s2) desc ,i1 desc; 
update tab1 set i1=i1+1, s2='xx', i3=char_length(s2)-12 order by char_length(s2) desc ,i1 desc limit 2;

select * from tab1 order by s2,i1;

drop tab1; 
