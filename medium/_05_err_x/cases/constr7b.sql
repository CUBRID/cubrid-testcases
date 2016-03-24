autocommit off;

create class snafu (a integer shared NULL not null, b integer);
create vclass snafu_v (a integer shared NULL not null, b integer)
as select NA, b from snafu;
insert into snafu_v (b) values (100);
rollback work;
rollback;
