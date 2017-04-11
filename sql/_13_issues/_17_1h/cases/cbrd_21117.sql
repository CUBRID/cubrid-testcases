drop table if exists target;
drop table if exists source_tbl;

create table target(a int, b char(10));
create table source_tbl(
        noneed1 datetime default SYS_DATETIME,
        name char(20),
        id string,
        noneed2 bigint not null,
        edate date,
        email varchar,
        noneed3 sequence(char(10))
);

merge into (select name, id, edate, email from target) t using (select name, id, edate, email from source_tbl where id like 'db%') s on t.email = s.email when not matched then insert values(s.id, s.edate);

drop table target;
drop table source_tbl;
