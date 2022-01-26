drop table if exists tbl1;

create table tbl1 (var_col varchar(20), char_col char(20));
create index var_idx on tbl1(var_col);
create index char_idx on tbl1(char_col);
create index midx_idx1 on tbl1(var_col,char_col);
create index midx_idx2 on tbl1(char_col,var_col);
create index var_idx_desc on tbl1(var_col desc);
create index char_idx_desc on tbl1(char_col desc);
create index midx_idx1_desc on tbl1(var_col desc,char_col desc);
create index midx_idx2_desc on tbl1(char_col desc,var_col desc);

insert into tbl1 values('a','a');
insert into tbl1 values('a ','a ');
insert into tbl1 values('a  ','a  ');
insert into tbl1 values('a a','a a');
insert into tbl1 values('ab','ab');
insert into tbl1 values('ab ','ab ');
insert into tbl1 values('a  b','a  b');
insert into tbl1 values(NULL,NULL);


-- char to char

--heap scan
select /*+ recompile */ char_col from tbl1 where char_col = 'a  ' using index none;

--char index scan
select /*+ recompile */ char_col from tbl1 where char_col = 'a  ' using index char_idx;
select /*+ recompile */ char_col from tbl1 where char_col = 'a  ' using index char_idx_desc;

--multi col index scan
select /*+ recompile */ char_col from tbl1 where char_col = 'a  ' using index midx_idx2;
select /*+ recompile */ char_col from tbl1 where char_col = 'a  ' using index midx_idx2_desc;
select /*+ recompile index_ss */ char_col from tbl1 where char_col = 'a  ' using index midx_idx1;
select /*+ recompile index_ss */ char_col from tbl1 where char_col = 'a  ' using index midx_idx1_desc;

--join
select /*+ recompile */ a.char_col from tbl1 a, tbl1 b where a.char_col = b.char_col;

--table scan
select /*+ recompile */ a.char_col from tbl1 a where a.char_col = a.char_col;

-- in operation
select /*+ recompile */ char_col from tbl1 where char_col in ('a  ','ab     ') using index none;
select /*+ recompile */ char_col from tbl1 where char_col in ('a  ','ab     ') using index char_idx;
select /*+ recompile */ char_col from tbl1 where char_col in ('a  ','ab     ')  using index midx_idx2;
select /*+ recompile index_ss */ char_col from tbl1 where char_col in ('a  ','ab     ') using index midx_idx1;

select /*+ recompile */ char_col from tbl1 where char_col in (char_col,char_col);
select /*+ recompile */ char_col from tbl1 where (char_col,char_col) in ((char_col,char_col),(char_col,char_col));

-- string function (decode)
select /*+ recompile */ char_col, decode(char_col,'a',1,'a  b',2,'ab',3,4) from tbl1;

-- prepare statement
prepare c_stmt from 'select char_col as "prepare_c" from tbl1 where char_col = ?';
execute c_stmt using 'a';
execute c_stmt using 'a     ';
drop prepare c_stmt;


-- varchar to char

--heap scan
select /*+ recompile */ var_col from tbl1 where var_col = 'a  ' using index none;

--char index scan
select /*+ recompile */ var_col from tbl1 where var_col = 'a  ' using index var_idx;
select /*+ recompile */ var_col from tbl1 where var_col = 'a  ' using index var_idx_desc;

--multi col index scan
select /*+ recompile index_ss */ var_col from tbl1 where var_col = 'a  ' using index midx_idx2;
select /*+ recompile index_ss */ var_col from tbl1 where var_col = 'a  ' using index midx_idx2_desc;
select /*+ recompile */ var_col from tbl1 where var_col = 'a  ' using index midx_idx1;
select /*+ recompile */ var_col from tbl1 where var_col = 'a  ' using index midx_idx1_desc;

--join
select /*+ recompile */ a.var_col  from tbl1 a, tbl1 b where a.var_col = b.char_col;

--table scan
select /*+ recompile */ a.var_col from tbl1 a where a.var_col = a.char_col;

-- in operation
select /*+ recompile */ var_col from tbl1 where var_col in ('a  ','a ','ab     ') using index none;
select /*+ recompile */ var_col from tbl1 where var_col in ('a  ','a ','ab     ') using index var_idx;
select /*+ recompile index_ss */ var_col from tbl1 where var_col in ('a  ','a ','ab     ')  using index midx_idx2;
select /*+ recompile */ var_col from tbl1 where var_col in ('a  ','a ','ab     ') using index midx_idx1;

select /*+ recompile */ var_col from tbl1 where var_col in (char_col,char_col);
select /*+ recompile */ var_col from tbl1 where (var_col,var_col) in ((char_col,char_col),(char_col,char_col));

-- string function (decode)
select /*+ recompile */ var_col, decode(var_col,'a',1,'a  b',2,'ab',3,4) from tbl1;

-- prepare statement
prepare vc_stmt from 'select var_col as "prepare_vc" from tbl1 where var_col = ?';
execute vc_stmt using 'a';
execute vc_stmt using 'a     ';
drop prepare vc_stmt;


-- char to varchar

--heap scan
select /*+ recompile */ char_col from tbl1 where char_col = cast('a  ' as varchar(20)) using index none;

--char index scan
select /*+ recompile */ char_col from tbl1 where char_col = cast('a  ' as varchar(20)) using index char_idx;
select /*+ recompile */ char_col from tbl1 where char_col = cast('a  ' as varchar(20)) using index char_idx_desc;

--multi col index scan
select /*+ recompile */ char_col from tbl1 where char_col = cast('a  ' as varchar(20)) using index midx_idx2;
select /*+ recompile */ char_col from tbl1 where char_col = cast('a  ' as varchar(20)) using index midx_idx2_desc;
select /*+ recompile index_ss */ char_col from tbl1 where char_col = cast('a  ' as varchar(20)) using index midx_idx1;
select /*+ recompile index_ss */ char_col from tbl1 where char_col = cast('a  ' as varchar(20)) using index midx_idx1_desc;

--join
select /*+ recompile */ a.char_col from tbl1 a, tbl1 b where a.char_col = b.var_col;

--table scan
select /*+ recompile */ a.char_col from tbl1 a where a.char_col = a.var_col;

-- in operation
select /*+ recompile */ char_col from tbl1 where char_col in (cast('a  ' as varchar),cast('ab     ' as varchar)) using index none;
select /*+ recompile */ char_col from tbl1 where char_col in (cast('a  ' as varchar),cast('ab     ' as varchar)) using index char_idx;
select /*+ recompile */ char_col from tbl1 where char_col in (cast('a  ' as varchar),cast('ab     ' as varchar))  using index midx_idx2;
select /*+ recompile index_ss */ char_col from tbl1 where char_col in (cast('a  ' as varchar),cast('ab     ' as varchar)) using index midx_idx1;
select /*+ recompile */ char_col from tbl1 where char_col in (var_col,var_col);
select /*+ recompile */ char_col from tbl1 where (char_col,char_col) in ((var_col,var_col),(var_col,var_col));

-- string function (decode)
select /*+ recompile */ char_col, decode(char_col,cast('a' as varchar),1,cast('a  b' as varchar(20)),2,cast('ab' as varchar(20)),3,4) from tbl1;

-- prepare statement
prepare cv_stmt from 'select char_col as "prepare_cv" from tbl1 where char_col = cast(? as varchar(20))';
execute cv_stmt using 'a';
execute cv_stmt using 'a     ';
drop prepare cv_stmt;



-- varchar to varchar

--heap scan
select /*+ recompile */ var_col from tbl1 where var_col = cast('a  ' as varchar(20)) using index none;

--char index scan
select /*+ recompile */ var_col from tbl1 where var_col = cast('a  ' as varchar(20)) using index var_idx;
select /*+ recompile */ var_col from tbl1 where var_col = cast('a  ' as varchar(20)) using index var_idx_desc;

--multi col index scan
select /*+ recompile index_ss */ var_col from tbl1 where var_col = cast('a  ' as varchar(20)) using index midx_idx2;
select /*+ recompile index_ss */ var_col from tbl1 where var_col = cast('a  ' as varchar(20)) using index midx_idx2_desc;
select /*+ recompile */ var_col from tbl1 where var_col = cast('a  ' as varchar(20)) using index midx_idx1;
select /*+ recompile */ var_col from tbl1 where var_col = cast('a  ' as varchar(20)) using index midx_idx1_desc;

--join
select /*+ recompile */ a.var_col from tbl1 a, tbl1 b where a.var_col = b.var_col;

--table scan
select /*+ recompile */ a.var_col from tbl1 a where a.var_col = a.var_col;

-- in operation
select /*+ recompile */ var_col from tbl1 where var_col in (cast('a  ' as varchar),cast('ab     ' as varchar)) using index none;
select /*+ recompile */ var_col from tbl1 where var_col in (cast('a  ' as varchar),cast('ab     ' as varchar)) using index char_idx;
select /*+ recompile */ var_col from tbl1 where var_col in (cast('a  ' as varchar),cast('ab     ' as varchar))  using index midx_idx2;
select /*+ recompile index_ss */ var_col from tbl1 where var_col in (cast('a  ' as varchar),cast('ab     ' as varchar)) using index midx_idx1;

select /*+ recompile */ var_col from tbl1 where var_col in (var_col,var_col);
select /*+ recompile */ var_col from tbl1 where (var_col,var_col) in ((var_col,var_col),(var_col,var_col));

-- string function (decode)
select /*+ recompile */ var_col, decode(var_col,cast('a' as varchar),1,cast('a  b' as varchar(20)),2,cast('ab' as varchar(20)),3,4) from tbl1;

-- prepare statement
prepare v_stmt from 'select var_col as "prepare_v" from tbl1 where var_col = cast(? as varchar(20))';
execute v_stmt using 'a';
execute v_stmt using 'a     ';
drop prepare v_stmt;



-- reduce duplicate

--eliminate_duplicated_keys
select /*+ recompile */ var_col from tbl1 where var_col in ('a  ','a ','ab     ') using index none;
select /*+ recompile */ var_col from tbl1 where var_col in ('a  ','a ','ab     ') using index midx_idx1;
select /*+ recompile */ var_col from tbl1 where var_col in ('a  ','a ','ab     ') using index var_idx;

select /*+ recompile */ var_col from tbl1 where char_col in ('a  ','a ','ab     ') using index none;
select /*+ recompile */ var_col from tbl1 where char_col in ('a  ','a ','ab     ') using index midx_idx2;
select /*+ recompile */ var_col from tbl1 where char_col in ('a  ','a ','ab     ') using index char_idx;

--merge_key_ranges, qo_reduce_comp_pair_terms
select /*+ recompile */ var_col from tbl1 where var_col > 'a' and var_col > 'a ' and var_col <= 'a     ' using index none;
select /*+ recompile */ var_col from tbl1 where var_col > 'a' and var_col > 'a ' and var_col <= 'a     ' using index midx_idx1;
select /*+ recompile */ var_col from tbl1 where var_col > 'a' and var_col > 'a ' and var_col <= 'a     ' using index var_idx;

select /*+ recompile */ char_col from tbl1 where char_col> 'a' and char_col> 'a ' and char_col<= 'a     ' using index none;
select /*+ recompile */ char_col from tbl1 where char_col> 'a' and char_col> 'a ' and char_col<= 'a     ' using index midx_idx1;
select /*+ recompile */ char_col from tbl1 where char_col> 'a' and char_col> 'a ' and char_col<= 'a     ' using index var_idx;

select /*+ recompile */ var_col from tbl1 where var_col > 'a' and var_col > 'a ' using index none;
select /*+ recompile */ var_col from tbl1 where var_col > 'a' and var_col > 'a ' using index midx_idx1;
select /*+ recompile */ var_col from tbl1 where var_col > 'a' and var_col > 'a ' using index var_idx;




-- create index desc
drop table if exists t1;

create table t1 (code char(90));
create index idx on t1(code desc);

insert into t1 (
    select lpad(rownum,5,'0') from _db_class a, _db_class b, _db_class c limit 300
);
insert into t1 (
    select lpad(rownum+2000,5,'0') from _db_class a, _db_class b, _db_class c limit 300
);
insert into t1 (
    select lpad(rownum+1000,5,'0') from _db_class a, _db_class b, _db_class c limit 300
);


-- data is not searched
drop table if exists t2;
create table t2 (code char(10));
create index idx on t2(code desc);

insert into t2 (
    select lpad(rownum,5,'0') from _db_class a, _db_class b, _db_class c limit 300
);
insert into t2 (
    select lpad(rownum+2000,5,'0') from _db_class a, _db_class b, _db_class c limit 300
);

select /*+ USE_DESC_IDX */ * from t2 where code = '00297 ' using index idx;
select /*+ USE_DESC_IDX */ * from t2 where code = '00297 ' using index none;

-- index_prfix
select INDEX_PREFIX (cast('10369111' as varchar(20) charset utf8) , cast('103691' as varCHAR(20) charset utf8), 'd');

select INDEX_PREFIX (cast('10369   ' as varchar(20) charset utf8) , cast('10369 ' as varCHAR(20) charset utf8), 'd');


drop tbl1, t1, t2;
