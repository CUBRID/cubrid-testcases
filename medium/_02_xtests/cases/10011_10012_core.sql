autocommit off;
create table a ( c char(1));
insert into a values('e');
select set{'w',c} from a;
rollback;
