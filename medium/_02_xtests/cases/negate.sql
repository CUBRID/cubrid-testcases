autocommit off;
select f.name2, g.name2 from faculty2 f, faculty2 g
where f = g and not (f.dept = 'math' and f.name2='moe')
rollback;
