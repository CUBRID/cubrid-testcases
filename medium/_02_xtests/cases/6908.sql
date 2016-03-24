autocommit off;
create class tba (y set_of(string));
create class tbb (x tba);
insert into tba values ({'a', 'b', 'c'}) to :obj;
insert into tbb values (:obj);
select tbb from tbb where 'a' in x.y;
drop tba, tbb;
rollback;
