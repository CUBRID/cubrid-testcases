create table foo(id varchar(15), parent_id varchar(10), rdate datetime);
insert into foo values('UMN_000223', 'UMN_000222',null);
insert into foo values('UMN_000224', 'UMN_000222',null);
insert into foo values('UMN_000225', 'UMN_000222',null);
insert into foo values('UMN_000221', 'UMN_000221',null); 

UPDATE foo
SET   rdate = '1999-12-12 12:12:12.123'
WHERE  id IN (SELECT id
                   FROM   foo
                   START WITH parent_id = 'UMN_000222'  
                   CONNECT BY PRIOR id = parent_id);

select * from foo order by 1;

drop table foo;
