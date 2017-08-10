-- [er]create class and alter it to add -1 precision numeric/bit attribute


create class c_n (it int);
alter class c_n add attribute n numeric(-1); 
create class c_b (it int);
alter class c_b add attribute b bit(-1);

drop class c_n;
drop class c_b;
