autocommit off;
create class table11
    ( jongcode integer,
      cprice   integer,
      per      numeric(7,2)
    );
 
insert into table11 values
    ( 10320, 1234567, 111);
 
update table11 set per = cprice / 197
    where jongcode = 10320;
select * from table11;
rollback work;
rollback;
