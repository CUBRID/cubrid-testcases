create table c (id  int ,col int);
insert into c values(1,2);
MERGE INTO c 
USING  c cd 
ON (c.id<cd.col) 
WHEN MATCHED THEN 
UPDATE  
SET c.id =cd.col+100 delete where c.id>0
WHEN NOT MATCHED THEN 
INSERT (c.id,c.col) VALUES (cd.id,cd.col);
drop c;
