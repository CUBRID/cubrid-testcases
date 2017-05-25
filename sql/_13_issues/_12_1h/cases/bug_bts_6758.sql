--TEST: [Pseudocolumn in DEFAULT clause] CURRENT_TIMESTAMP default value cannot be set by 'ALTER COLUMN ... SET DEFAULT' statement.


create table foo(a timestamp, b date, c datetime, d varchar);

alter table foo alter column a set default CURRENT_TIMESTAMP;
desc foo;
alter table foo alter column b set default CURRENT_TIMESTAMP;
desc foo;

alter table foo alter column a set default SYSTIMESTAMP;
desc foo;
alter table foo alter column c set default SYSTIMESTAMP;
desc foo;

alter table foo alter column a set default UNIX_TIMESTAMP();
desc foo;
alter table foo alter column d set default to_char(UNIX_TIMESTAMP());
desc foo;

alter table foo alter column b set default SYSDATE;
desc foo;
alter table foo alter column a set default SYSDATE;
desc foo;
alter table foo alter column c set default SYSDATE;
desc foo;
alter table foo alter column d set default to_char(SYSDATE);
desc foo;

alter table foo alter column c set default SYSDATETIME;
desc foo;
alter table foo alter column a set default SYSDATETIME;
desc foo;
alter table foo alter column b set default SYSDATETIME;
desc foo;
alter table foo alter column d set default to_char(SYSDATETIME);
desc foo;

alter table foo alter column d set default USER;
desc foo;
alter table foo alter column a set default USER;
desc foo;
alter table foo alter column b set default USER;
desc foo;

alter table foo alter column d set default CURRENT_USER;
desc foo;
alter table foo alter column c set default CURRENT_USER;
desc foo;


insert into foo(a) values(default);

select if((SYSTIMESTAMP-a) < 2 and date(a)=b and (SYSTIMESTAMP-c) < 100 and d=USER, 'ok', 'nok') from foo;


drop table foo;
