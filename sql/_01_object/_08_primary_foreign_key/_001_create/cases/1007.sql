--[er]create unique index for column having unique constraints


create table p8 (a int unique not null,
                 b int not null
);
create unique index  u_idx_a on p8( a);
create unique index  u_idx_a_b on p8(a,b);





drop table p8;
