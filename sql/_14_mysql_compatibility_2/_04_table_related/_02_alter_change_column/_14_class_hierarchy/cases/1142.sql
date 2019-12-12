---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints :
-- ordering : no order defined
-- name : same of different
-- other : change resolution 

-- not allowed to access inherited attributes -> using alias name
create class b1 (i integer);
create class b2 (i integer);

create class c1 under b1,  b2 (x1 integer) inherit i of b1 as i_c1;

alter table c1 change i_c1 i_1 integer;


drop c1;
drop b1;
drop b2;


-- not allowed to access inherited attributes - using real name
create class b1 (i integer);
create class b2 (i integer);

create class c1 under b1,  b2 (x1 integer) inherit i of b1 as i_c1;

alter table c1 change i i_1 integer;


drop c1;
drop b1;
drop b2;



-- grammar doesn't support INHERIT in ALTER CHANGE 
create class b1 (i integer);
create class b2 (i integer);

create class c1 under b1,  b2 (x1 integer) inherit i of b1 as i_c1;

alter table c1 change i_c1 i_1 integer inherit i of b2 as i_c;


drop c1;
drop b1;
drop b2;

-- grammar doesn't support INHERIT in ALTER MODIFY 
create class b1 (i integer);
create class b2 (i integer);

create class c1 under b1,  b2 (x1 integer) inherit i of b1 as i_c1;

alter table c1 MODIFY i_c1 integer inherit i of b2 as i_c;


drop c1;
drop b1;
drop b2;
