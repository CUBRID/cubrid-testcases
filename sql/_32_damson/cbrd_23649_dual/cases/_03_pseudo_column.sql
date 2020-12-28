-- check for query plan 
set trace on;

select /*+ recompile */ current_user;
show trace;

select /*+ recompile */ rownum;
show trace;

set trace off;
