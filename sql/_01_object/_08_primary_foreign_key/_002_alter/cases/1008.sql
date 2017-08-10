-- create a table with a primary key,create a table with a foreign key, drop the foreign key,drop the primary key

create class a (i int primary key, j int); 
create class b (i int primary key, j int foreign key references a); 

alter class a add constraint a_fk foreign key(j) references b; 

alter class b drop constraint fk_b_j;
alter class a drop constraint a_fk;

drop class b,a;