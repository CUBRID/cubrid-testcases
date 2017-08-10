--TEST: [Merge Statement] Core file dumped when using a subquery of the target table as the merge source

drop table if exists target;

create table target(
        col1 smallint primary key auto_increment,
        col2 string,
        col3 timestamp default SYS_TIMESTAMP,
        col4 bit(20) unique,
        col5 clob
);

insert into target values(100, 'aaa', '2011-12-12 14:20:34', B'0001', 'AAA');
insert into target values(200, 'bbb', '2011-12-12 14:20:34', B'0010', 'BBB');
insert into target values(300, 'ccc', '2011-12-12 14:20:35', B'0100', 'CCC');
insert into target values(400, 'ddd', '2011-12-12 14:20:36', B'1000', 'DDD');
insert into target values(500, 'eee', '2011-12-12 14:20:36', B'0011', 'EEE');
insert into target values(600, 'fff', '2011-12-12 14:20:37', B'0101', 'FFF');


--Temporarily fail because of CUBRIDSUS-9155
merge into target t
using (select * from target where col2 < 'ddd') s
on (t.col1=s.col1 and clob_to_char(s.col5)=clob_to_char(t.col5))
when matched then
update
set t.col2=repeat('updated', 1)
when not matched then
insert
values(s.col1, 'inserted', default, default, default);

--####################### CUBRIDBUG: CUBRIDSUS-9155 ###############################
--Temporarily fail because of CUBRIDSUS-9155
select if(count(*)=3, 'ok', 'nok') from target where col2='updated';

delete from target;
drop table target;
