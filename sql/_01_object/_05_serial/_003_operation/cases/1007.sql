-- [er] create ser1 and insert next serial value  into pk column of created class 


CREATE CLASS a(id int PRIMARY KEY);


create serial ser1
MINVALUE 1
MAXVALUE 3 
CYCLE;


insert INTO a VALUES (ser1.next_value);
insert INTO a VALUES (ser1.next_value);
insert INTO a VALUES (ser1.next_value);
insert INTO a VALUES (ser1.next_value);

select * FROM a;

select * from db_serial WHERE name='ser1';





drop serial ser1;

drop a;