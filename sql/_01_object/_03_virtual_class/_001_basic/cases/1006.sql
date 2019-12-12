-- [er]create vclass using same name with class

create class lineitem ( 
c1 int
);
create view lineitem as select * from lineitem; 

drop class lineitem;
drop vclass lineitem;
