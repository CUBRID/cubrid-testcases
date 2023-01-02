drop table if exists mmdb, uudb;

create table mmdb(act_no varchar(10));
create table uudb(in_act_no varchar(10));

insert into mmdb(act_no)
select act_no
from (select in_act_no as act_no from uudb where in_act_no=NULL)
where act_no = '1';

drop table if exists mmdb, uudb;
