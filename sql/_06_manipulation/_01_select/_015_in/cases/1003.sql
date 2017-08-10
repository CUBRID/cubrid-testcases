--Test numeric data type using where,in,range multi-method

create class DKLjwed (DKJlqhntID NUMERIC(38));
insert into DKLjwed values (113445921551100009);
select * from DKLjwed Where 113445921551100009 IN ( DKJlqhntID) order by 1;
Select * from DKLjwed Where DKJlqhntID IN ( 113445921551100009 ) order by 1;
select DKLjwed.dkjlqhntid from DKLjwed DKLjwed where (DKLjwed.DKJlqhntID=113445921551100009) order by 1;
Select * from DKLjwed Where DKJlqhntID = 113445921551100009 order by 1;
select * from DKLjwed Where DKJlqhntID range (113445921551100009 = ) order by 1;
Select * from DKLjwed Where TO_CHAR(DKJlqhntID) IN ( '113445921551100009' ) order by 1;


drop table DKLjwed;
