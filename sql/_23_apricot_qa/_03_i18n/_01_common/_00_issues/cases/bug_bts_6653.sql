CREATE TABLE blogtopic (topicId INTEGER, postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
insert into blogtopic value(1,DATE '2010-01-01',null);
CREATE INDEX my_filter_index ON blogtopic (topicId,postDate,closedDate) WHERE topicId<>0;
--test it should use the index
select /*+ recompile */* from blogtopic WHERE topicId<>0 using index my_filter_index(+);
prepare s from 'select /*+ recompile */* from blogtopic WHERE topicId<>? using index my_filter_index(+)';
execute s using 0;
deallocate prepare s;
drop table blogtopic;

