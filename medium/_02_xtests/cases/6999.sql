autocommit off;
create class c6999 ( attr char(11), b char(1) );
insert into c6999 values ('        ', 'b');
insert into c6999 values ('385906  ', 'b'); 
insert into c6999 values ('        ', 'b');
insert into c6999 values ('321440  ', 'b');
insert into c6999 values ('416230  ', 'b');
insert into c6999 values ('539935  ', 'b');
insert into c6999 values ('        ', 'b');
select attr, 'b' from c6999 order by 1, 2
rollback;
