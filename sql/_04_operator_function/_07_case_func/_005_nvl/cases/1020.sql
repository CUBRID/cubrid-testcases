--[er]test nvl, nvl2 with date and other type
select nvl(n'sss', {81,91}) from db_root;
select nvl2(n'sss', {81,91}, {8,9}) from db_root;

select nvl('sss', {81,91}) from db_root;
select nvl2('sss', {81,91}, {8,9}) from db_root;

select nvl(date'2/2/2002', {81,91}) from db_root;
select nvl2(date'2/2/2002', {81,91}, {8,9}) from db_root;

select nvl(1, {81,91}) from db_root;
select nvl2(1, {81,91}, {8,9}) from db_root;

select nvl(1.11, {81,91}) from db_root;
select nvl2(1.11, {81,91}, {8,9}) from db_root;

select nvl(time'3:3:3 am', {81,91}) from db_root;
select nvl2(time'3:3:3 am', {81,91}, {8,9}) from db_root;

select nvl(timestamp'2/2/2001 2:2:2 am', {81,91}) from db_root;
select nvl2(timestamp'2/2/2001 2:2:2 am', {81,91}, {8,9}) from db_root;

select nvl(b'001010', {81,91}) from db_root;
select nvl2(b'001010', {81,91}, {8,9}) from db_root;
