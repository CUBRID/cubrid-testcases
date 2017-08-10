--[er]add zero precision bit/numeric attribute on a calss which new created
 
create class c_n (it int);

alter class c_n add attribute n numeric(0); 
create class c_b (it int);
alter class c_b add attribute b bit(0);

drop class c_n;
drop class c_b;
