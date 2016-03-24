drop view test;
create view test(score int,score1 timestamp) as
(
    select NULL,timestamp'01/31/1994 8:15:00 pm'
    UNION ALL
    select NULL,timestamp'01/31/1994 8:15:00 pm'
);
--good
select score,score1 from test order by score1 desc,score1 asc;

--bug
select score,score1 from test order by score1 nulls last,score1 nulls first;

drop view test;
