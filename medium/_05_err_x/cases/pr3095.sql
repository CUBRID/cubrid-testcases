autocommit off;
alter v add query select beach from resort;
select * from v;
rollback work;
rollback;
