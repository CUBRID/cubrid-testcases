--[er]create range partition table having boundary values and create trigger which update partition key when insert on table

CREATE TABLE emp ( 
store_id INT NOT NULL 
) 
PARTITION BY range (store_id) ( 
partition p1 values less than (10 ), 
partition p2 values less than (20 ) ); 

create trigger tr2 
after insert on EMP 
execute update emp set store_id = store_id + 10 where store_id = obj.store_id; 


insert into emp values(5); 
insert into emp values(-10); 

SELECT * FROM EMP__P__P1 order by 1;

SELECT * FROM EMP__P__P2 order by 1;

drop trigger tr2;

drop emp;
