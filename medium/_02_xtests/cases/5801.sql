autocommit off;
create class numeric_class
(
  testNumber integer,
  intval integer,
  flotval float
);
insert into numeric_class values
(
  1,                        -- testNumber
  50,                       -- sintval
  NULL                      -- flotval  
);
select * from numeric_class;
update numeric_class -- update 1
set flotval =
(select intval / 8 from numeric_class where testNumber = 1)
where testNumber = 1;
select intval / 8, flotval from numeric_class where testNumber = 1;
update numeric_class -- update 2
set flotval =
intval / 8 
where testNumber = 1;
select intval / 8, flotval from numeric_class where testNumber = 1;
update numeric_class -- update 3
set flotval =
cast (intval as float) / 8 
where testNumber = 1;
select intval / 8, flotval from numeric_class where testNumber = 1
rollback;
