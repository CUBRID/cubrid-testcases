create table clients (clno int, fname varchar(15), lname varchar(15), job varchar(15), account_balance decimal(7,2));
insert into clients values (10, 'sam','smith','auditor',5525.75);
insert into clients values (20,'james','jones','manager',8960.25);
insert into clients values (30,'john','lukas','auditor',8860.25);
insert into clients values (40,'jerry','smith','auditor',6880.5);

create table firms (clno int, company varchar(15), city varchar(15));
insert into firms values (10,'abc_co','leduc');
insert into firms values (20,'def_ltd','nisku');
insert into firms values (20,'ghi_inc','nisku');
insert into firms values (40,'jkl_inc','leduc');
insert into firms values (30,'mno_inc','nisku');
create index idx_coverage_t5 on firms (city,clno);
create index idx_t5_ci on firms (city);
create index idx_t5_cl on firms (clno);
create index idx_t5_ci_cl_co on firms (city,clno,company);
create index idx_t5_ci_co on firms (city,company);

SELECT * FROM (SELECT clno,fname FROM clients WHERE clno IN (SELECT clno FROM firms WHERE city = 'leduc')) AS tbl ORDER BY tbl.clno;
SELECT * FROM (SELECT clno,fname FROM clients WHERE clno IN (SELECT clno FROM firms WHERE city = 'leduc' and clno > 30)) AS tbl ORDER BY tbl.clno;

drop table clients;
drop table firms;