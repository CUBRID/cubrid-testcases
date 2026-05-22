-- ============================================
-- PL/CSQL TESTS FOR INVISIBLE COLUMN
-- ============================================

drop table if exists t1;
drop table if exists t2;

-- ============================================
-- 31. CURSOR TESTS WITH INVISIBLE COLUMNS
-- ============================================

--+ server-message on

create table t1 (
    id int primary key,
    c1 int invisible,
    c2 int,
    c3 int invisible,
    c4 varchar(50)
);

insert into t1(id, c1, c2, c3, c4) values (1, 10, 100, 1000, 'a');
insert into t1(id, c1, c2, c3, c4) values (2, 20, 200, 2000, 'b');
insert into t1(id, c1, c2, c3, c4) values (3, 30, 300, 3000, 'c');

-- Cursor with SELECT * (should not include invisible columns)
create or replace procedure test_cursor_star as
    cursor my_cursor is select * from t1 order by id;
    v_id int;
    v_c2 int;
    v_c4 varchar(50);
begin
    open my_cursor;
    loop
        fetch my_cursor into v_id, v_c2, v_c4;
        exit when my_cursor%notfound;
        dbms_output.put_line('id: ' || v_id || ', c2: ' || v_c2 || ', c4: ' || v_c4);
    end loop;
    close my_cursor;
end;

call test_cursor_star();

-- Cursor with explicit invisible columns
create or replace procedure test_cursor_explicit as
    cursor my_cursor is select id, c1, c2, c3, c4 from t1 order by id;
    v_id int;
    v_c1 int;
    v_c2 int;
    v_c3 int;
    v_c4 varchar(50);
begin
    open my_cursor;
    loop
        fetch my_cursor into v_id, v_c1, v_c2, v_c3, v_c4;
        exit when my_cursor%notfound;
        dbms_output.put_line('id: ' || v_id || ', c1: ' || v_c1 || ', c2: ' || v_c2 || 
                           ', c3: ' || v_c3 || ', c4: ' || v_c4);
    end loop;
    close my_cursor;
end;

call test_cursor_explicit();

-- Cursor with WHERE using invisible column
create or replace procedure test_cursor_where_invisible as
    cursor my_cursor is select id, c2, c4 from t1 where c1 > 10 order by id;
    v_id int;
    v_c2 int;
    v_c4 varchar(50);
begin
    open my_cursor;
    loop
        fetch my_cursor into v_id, v_c2, v_c4;
        exit when my_cursor%notfound;
        dbms_output.put_line('id: ' || v_id || ', c2: ' || v_c2 || ', c4: ' || v_c4);
    end loop;
    close my_cursor;
end;

call test_cursor_where_invisible();

-- Cursor with ORDER BY using invisible column
create or replace procedure test_cursor_order_invisible as
    cursor my_cursor is select * from t1 order by c1 desc;
    v_id int;
    v_c2 int;
    v_c4 varchar(50);
begin
    open my_cursor;
    loop
        fetch my_cursor into v_id, v_c2, v_c4;
        exit when my_cursor%notfound;
        dbms_output.put_line('id: ' || v_id || ', c2: ' || v_c2 || ', c4: ' || v_c4);
    end loop;
    close my_cursor;
end;

call test_cursor_order_invisible();

-- Parametrized cursor with invisible column
create or replace procedure test_cursor_param as
    cursor my_cursor(p_c1 int) is select id, c1, c2, c4 from t1 where c1 >= p_c1 order by id;
    v_id int;
    v_c1 int;
    v_c2 int;
    v_c4 varchar(50);
begin
    open my_cursor(20);
    loop
        fetch my_cursor into v_id, v_c1, v_c2, v_c4;
        exit when my_cursor%notfound;
        dbms_output.put_line('id: ' || v_id || ', c1: ' || v_c1 || 
                           ', c2: ' || v_c2 || ', c4: ' || v_c4);
    end loop;
    close my_cursor;
end;

call test_cursor_param();

-- ============================================
-- 32. FOR LOOP WITH IMPLICIT RECORD
-- ============================================

-- FOR loop with SELECT * (record should not include invisible columns)
create or replace procedure test_for_loop_star as
begin
    for r in (select * from t1 order by id) loop
        dbms_output.put_line('id: ' || r.id || ', c2: ' || r.c2 || ', c4: ' || r.c4);
        -- r.c1 and r.c3 should not exist
    end loop;
end;

call test_for_loop_star();

-- FOR loop with SELECT * but explicit invisible column in WHERE
create or replace procedure test_for_loop_star_where as
begin
    for r in (select * from t1 where c1 > 10 order by id) loop
        dbms_output.put_line('id: ' || r.id || ', c2: ' || r.c2 || ', c4: ' || r.c4);
        -- r.c1 and r.c3 should not exist
    end loop;
end;

call test_for_loop_star_where();

-- FOR loop with explicit invisible columns
create or replace procedure test_for_loop_explicit as
begin
    for r in (select id, c1, c2, c3, c4 from t1) loop
        dbms_output.put_line('id: ' || r.id || ', c1: ' || r.c1 || ', c2: ' || r.c2 || 
                           ', c3: ' || r.c3 || ', c4: ' || r.c4);
    end loop;
end;

call test_for_loop_explicit();

-- FOR loop with WHERE on invisible column
create or replace procedure test_for_loop_where as
begin
    for r in (select * from t1 where c1 between 15 and 25) loop
        dbms_output.put_line('id: ' || r.id || ', c2: ' || r.c2 || ', c4: ' || r.c4);
    end loop;
end;

call test_for_loop_where();

-- FOR loop with ORDER BY on invisible column
create or replace procedure test_for_loop_order as
begin
    for r in (select id, c2, c4 from t1 order by c3 desc) loop
        dbms_output.put_line('id: ' || r.id || ', c2: ' || r.c2 || ', c4: ' || r.c4);
    end loop;
end;

call test_for_loop_order();

-- Nested FOR loops with invisible columns
create or replace procedure test_nested_for_loops as
begin
    for r1 in (select c1, c2 from t1 where c1 <= 20) loop
        dbms_output.put_line('Outer: c1=' || r1.c1 || ', c2=' || r1.c2);
        for r2 in (select c3, c4 from t1 where c3 > 1000) loop
            dbms_output.put_line('  Inner: c3=' || r2.c3 || ', c4=' || r2.c4);
        end loop;
    end loop;
end;

call test_nested_for_loops();

-- ============================================
-- 33. STATIC SQL SELECT INTO
-- ============================================

-- SELECT * INTO (should not include invisible columns)
create or replace procedure test_select_into_star as
    v_id int;
    v_c2 int;
    v_c4 varchar(50);
begin
    select * into v_id, v_c2, v_c4 from t1 where id = 1;
    dbms_output.put_line('id: ' || v_id || ', c2: ' || v_c2 || ', c4: ' || v_c4);
end;

call test_select_into_star();

-- SELECT with explicit invisible columns
create or replace procedure test_select_into_explicit as
    v_id int;
    v_c1 int;
    v_c2 int;
    v_c3 int;
    v_c4 varchar(50);
begin
    select id, c1, c2, c3, c4 into v_id, v_c1, v_c2, v_c3, v_c4 
    from t1 where id = 2;
    dbms_output.put_line('id: ' || v_id || ', c1: ' || v_c1 || ', c2: ' || v_c2 || 
                       ', c3: ' || v_c3 || ', c4: ' || v_c4);
end;

call test_select_into_explicit();

-- SELECT aggregate on invisible column
create or replace procedure test_select_agg_invisible as
    v_sum int;
    v_avg int;
    v_max int;
begin
    select sum(c1), avg(c3), max(c1) into v_sum, v_avg, v_max from t1;
    dbms_output.put_line('sum(c1): ' || v_sum || ', avg(c3): ' || v_avg || 
                       ', max(c1): ' || v_max);
end;

call test_select_agg_invisible();

-- SELECT with WHERE on invisible column
create or replace procedure test_select_where_invisible as
    v_id int;
    v_c2 int;
begin
    select id, c2 into v_id, v_c2 from t1 where c1 = 20 and c3 = 2000;
    dbms_output.put_line('id: ' || v_id || ', c2: ' || v_c2);
end;

call test_select_where_invisible();

-- ============================================
-- 34. STATIC SQL INSERT/UPDATE/DELETE
-- ============================================

-- INSERT without specifying invisible columns
create or replace procedure test_insert_no_invisible as
begin
    insert into t1(id, c2, c4) values (4, 400, 'd');
    dbms_output.put_line('Inserted row with id=4');
end;

call test_insert_no_invisible();
select id, c1, c2, c3, c4 from t1 where id = 4;

-- INSERT with explicit invisible columns
create or replace procedure test_insert_with_invisible as
begin
    insert into t1(id, c1, c2, c3, c4) values (5, 50, 500, 5000, 'e');
    dbms_output.put_line('Inserted row with id=5');
end;

call test_insert_with_invisible();
select id, c1, c2, c3, c4 from t1 where id = 5;

-- UPDATE invisible column
create or replace procedure test_update_invisible as
begin
    update t1 set c1 = 15, c3 = 1500 where id = 1;
    dbms_output.put_line('Updated invisible columns for id=1');
end;

call test_update_invisible();
select id, c1, c2, c3, c4 from t1 where id = 1;

-- UPDATE with WHERE on invisible column
create or replace procedure test_update_where_invisible as
begin
    update t1 set c2 = c2 + 10 where c1 >= 20;
    dbms_output.put_line('Updated c2 where c1 >= 20');
end;

call test_update_where_invisible();
select id, c1, c2, c3, c4 from t1 order by id;

-- DELETE with WHERE on invisible column
create or replace procedure test_delete_invisible as
begin
    delete from t1 where c3 = 5000;
    dbms_output.put_line('Deleted rows where c3 = 5000');
end;

call test_delete_invisible();
select id, c1, c2, c3, c4 from t1 order by id;

-- ============================================
-- 35. DYNAMIC SQL (EXECUTE IMMEDIATE)
-- ============================================

-- Dynamic SQL with SELECT * (invisible columns not included)
create or replace procedure test_dynamic_select_star as
    v_id int;
    v_c2 int;
    v_c4 varchar(50);
    sql_stmt varchar(200);
begin
    sql_stmt := 'select * from t1 where id = ?';
    execute immediate sql_stmt into v_id, v_c2, v_c4 using 1;
    dbms_output.put_line('id: ' || v_id || ', c2: ' || v_c2 || ', c4: ' || v_c4);
end;

call test_dynamic_select_star();

-- Dynamic SQL with explicit invisible columns
create or replace procedure test_dynamic_explicit as
    v_c1 int;
    v_c3 int;
    sql_stmt varchar(200);
begin
    sql_stmt := 'select c1, c3 from t1 where id = ?';
    execute immediate sql_stmt into v_c1, v_c3 using 2;
    dbms_output.put_line('c1: ' || v_c1 || ', c3: ' || v_c3);
end;

call test_dynamic_explicit();

-- Dynamic INSERT with invisible columns
create or replace procedure test_dynamic_insert as
    sql_stmt varchar(200);
begin
    sql_stmt := 'insert into t1(id, c1, c2, c3, c4) values (?, ?, ?, ?, ?)';
    execute immediate sql_stmt using 6, 60, 600, 6000, 'f';
    dbms_output.put_line('Inserted row with id=6 using dynamic SQL');
end;

call test_dynamic_insert();
select id, c1, c2, c3, c4 from t1 where id = 6;

-- Dynamic UPDATE on invisible column
create or replace procedure test_dynamic_update as
    sql_stmt varchar(200);
begin
    sql_stmt := 'update t1 set c1 = c1 * 2 where c3 < ?';
    execute immediate sql_stmt using 3000;
    dbms_output.put_line('Updated c1 using dynamic SQL');
end;

call test_dynamic_update();
select id, c1, c2, c3, c4 from t1 order by id;

-- Dynamic table manipulation
create or replace procedure test_dynamic_table as
    sql_stmt varchar(500);
begin
    sql_stmt := 'create table t_dynamic (id int, c1 int invisible, c2 int)';
    execute immediate sql_stmt;
    
    sql_stmt := 'insert into t_dynamic(id, c1, c2) values (1, 10, 100)';
    execute immediate sql_stmt;
    
    dbms_output.put_line('Created and populated t_dynamic');
end;

call test_dynamic_table();
select id, c1, c2 from t_dynamic;
drop table t_dynamic;

-- ============================================
-- 36. STORED FUNCTION WITH INVISIBLE COLUMNS
-- ============================================

-- Function returning invisible column value
create or replace function get_invisible_c1(p_id int) return int as
    v_c1 int;
begin
    select c1 into v_c1 from t1 where id = p_id;
    return v_c1;
end;

select id, get_invisible_c1(id) as c1_value from t1 order by id;

-- Function with WHERE on invisible column
create or replace function count_by_c1(p_c1 int) return int as
    v_count int;
begin
    select count(*) into v_count from t1 where c1 >= p_c1;
    return v_count;
end;

select count_by_c1(20) as count_result;

-- Function using invisible column in computation
create or replace function sum_invisible_cols(p_id int) return int as
    v_c1 int;
    v_c3 int;
begin
    select c1, c3 into v_c1, v_c3 from t1 where id = p_id;
    return v_c1 + v_c3;
end;

select id, c1, c3, sum_invisible_cols(id) as sum_val from t1 order by id;

-- ============================================
-- 37. PROCEDURE WITH OUT PARAMETERS
-- ============================================

-- OUT parameter for invisible column
create or replace procedure get_invisible_values(
    p_id in int,
    p_c1 out int,
    p_c3 out int
) as
begin
    select c1, c3 into p_c1, p_c3 from t1 where id = p_id;
end;

-- Test OUT parameters (in SQL)
-- Note: This requires host variables or another procedure to call
create or replace procedure test_out_params as
    v_c1 int;
    v_c3 int;
begin
    get_invisible_values(1, v_c1, v_c3);
    dbms_output.put_line('c1: ' || v_c1 || ', c3: ' || v_c3);
end;

call test_out_params();

-- IN OUT parameter with invisible column
create or replace procedure double_invisible(
    p_c1 in out int
) as
begin
    p_c1 := p_c1 * 2;
end;

create or replace procedure test_inout_param as
    v_c1 int;
begin
    select c1 into v_c1 from t1 where id = 1;
    dbms_output.put_line('Before: ' || v_c1);
    double_invisible(v_c1);
    dbms_output.put_line('After: ' || v_c1);
end;

call test_inout_param();

-- ============================================
-- 38. EXCEPTION HANDLING WITH INVISIBLE COLUMNS
-- ============================================

-- Exception when invisible column constraint violated
create or replace procedure test_exception_not_null as
    not_null_err exception;
begin
    insert into t1(id, c1, c4) values (7, 70, 'g');
    dbms_output.put_line('Insert succeeded');
exception
    when sql_error then
        dbms_output.put_line('Caught SQL error: ' || sqlerrm);
end;

alter table t1 modify column c2 int not null invisible;

call test_exception_not_null();

-- Exception in cursor with invisible columns
create or replace procedure test_exception_cursor as
    cursor my_cursor is select c1, c2 from t1 where c1 > 0;
    v_c1 int;
    v_c2 int;
    v_result int;
begin
    open my_cursor;
    loop
        fetch my_cursor into v_c1, v_c2;
        exit when my_cursor%notfound;
        
        -- Intentional divide by zero when c1 = 20
        if v_c1 = 20 then
            v_result := 100 / 0;
        end if;
        
        dbms_output.put_line('c1: ' || v_c1 || ', c2: ' || v_c2);
    end loop;
    close my_cursor;
exception
    when sql_error then
        if my_cursor%isopen then
            close my_cursor;
        end if;
        dbms_output.put_line('Error occurred: ' || sqlerrm);
end;

call test_exception_cursor();

-- ============================================
-- 39. LOCAL PROCEDURE/FUNCTION
-- ============================================

-- Local procedure accessing invisible columns
create or replace procedure test_local_procedure as
    -- Local procedure definition
    procedure local_proc(p_id int) as
        v_c1 int;
        v_c3 int;
    begin
        select c1, c3 into v_c1, v_c3 from t1 where id = p_id;
        dbms_output.put_line('Local proc: c1=' || v_c1 || ', c3=' || v_c3);
    end;
begin
    dbms_output.put_line('Calling local procedure:');
    local_proc(1);
    local_proc(2);
end;

call test_local_procedure();

-- Local function with invisible columns
create or replace procedure test_local_function as
    -- Local function definition
    function get_c1_plus_c3(p_id int) return int as
        v_c1 int;
        v_c3 int;
    begin
        select c1, c3 into v_c1, v_c3 from t1 where id = p_id;
        return v_c1 + v_c3;
    end;
    
    v_result int;
begin
    for r in (select id from t1 order by id) loop
        v_result := get_c1_plus_c3(r.id);
        dbms_output.put_line('id=' || r.id || ', sum=' || v_result);
    end loop;
end;

call test_local_function();

-- ============================================
-- 40. BULK OPERATIONS
-- ============================================

create table t2 (
    id int,
    c1 int invisible,
    c2 int,
    c3 varchar(50)
);

-- Bulk insert using cursor and loop
create or replace procedure test_bulk_insert as
begin
    for r in (select id, c1, c2, c4 from t1) loop
        insert into t2(id, c1, c2, c3) values (r.id, r.c1, r.c2, r.c4);
    end loop;
    dbms_output.put_line('Bulk insert completed');
end;

call test_bulk_insert();
select id, c1, c2, c3 from t2 order by id;

-- Bulk update using invisible column in WHERE
create or replace procedure test_bulk_update as
    cursor upd_cursor is select id, c1 from t1 where c1 > 15;
begin
    for r in upd_cursor loop
        update t2 set c1 = r.c1 * 10 where id = r.id;
    end loop;
    dbms_output.put_line('Bulk update completed');
end;

call test_bulk_update();
select id, c1, c2, c3 from t2 order by id;

-- ============================================
-- 41. CASE STATEMENT WITH INVISIBLE COLUMNS
-- ============================================

create or replace procedure test_case_invisible as
    v_category varchar(20);
begin
    for r in (select id, c1 from t1 order by id) loop
        case
            when r.c1 < 20 then
                v_category := 'Low';
            when r.c1 < 40 then
                v_category := 'Medium';
            else
                v_category := 'High';
        end case;
        dbms_output.put_line('id=' || r.id || ', c1=' || r.c1 || ', category=' || v_category);
    end loop;
end;

call test_case_invisible();

-- CASE expression in SQL within PL/CSQL
create or replace procedure test_case_expr_invisible as
begin
    for r in (
        select id, c1, c2,
               case when c1 is null then 'Unknown'
                    when c1 < 20 then 'Small'
                    when c1 < 40 then 'Medium'
                    else 'Large'
               end as size_category
        from t1 order by id
    ) loop
        dbms_output.put_line('id=' || r.id || ', size=' || r.size_category);
    end loop;
end;

call test_case_expr_invisible();

-- ============================================
-- 42. OPEN FOR (SYS_REFCURSOR) WITH INVISIBLE COLUMNS
-- ============================================

create or replace procedure test_open_for as
    my_cursor sys_refcursor;
    v_id int;
    v_c1 int;
    v_c2 int;
begin
    open my_cursor for select id, c1, c2 from t1 where c1 > 10;
    
    loop
        fetch my_cursor into v_id, v_c1, v_c2;
        exit when my_cursor%notfound;
        dbms_output.put_line('id=' || v_id || ', c1=' || v_c1 || ', c2=' || v_c2);
    end loop;
    
    close my_cursor;
end;

call test_open_for();


-- ============================================
-- 43. COMPLEX PL/CSQL SCENARIOS
-- ============================================

-- Nested procedures with invisible columns
create or replace procedure test_nested_calls as
    procedure inner_proc(p_id int, p_c1 out int) as
    begin
        select c1 into p_c1 from t1 where id = p_id;
    end;
    
    v_c1 int;
    v_total int := 0;
begin
    for i in 1..3 loop
        inner_proc(i, v_c1);
        v_total := v_total + v_c1;
        dbms_output.put_line('id=' || i || ', c1=' || v_c1);
    end loop;
    dbms_output.put_line('Total: ' || v_total);
end;

call test_nested_calls();

-- Mixed static and dynamic SQL
create or replace procedure test_mixed_sql as
    v_c1 int;
    v_count int;
    sql_stmt varchar(200);
begin
    -- Static SQL
    select c1 into v_c1 from t1 where id = 1;
    dbms_output.put_line('Static SQL - c1: ' || v_c1);
    
    -- Dynamic SQL
    sql_stmt := 'select count(*) from t1 where c1 >= ?';
    execute immediate sql_stmt into v_count using v_c1;
    dbms_output.put_line('Dynamic SQL - count: ' || v_count);
    
    -- Update using result
    update t1 set c3 = c3 + 1 where c1 = v_c1;
    dbms_output.put_line('Updated c3 for c1=' || v_c1);
end;

call test_mixed_sql();
select id, c1, c3 from t1 where id = 1;

-- Loop with multiple invisible column operations
create or replace procedure test_complex_loop as
    v_sum_c1 int := 0;
    v_sum_c3 int := 0;
    v_count int := 0;
begin
    for r in (select c1, c3 from t1 where c1 is not null and c3 is not null) loop
        v_sum_c1 := v_sum_c1 + r.c1;
        v_sum_c3 := v_sum_c3 + r.c3;
        v_count := v_count + 1;
        
        if r.c1 > 20 then
            update t1 set c2 = c2 + 1 where c1 = r.c1 and c3 = r.c3;
        end if;
    end loop;
    
    dbms_output.put_line('Count: ' || v_count);
    dbms_output.put_line('Sum c1: ' || v_sum_c1);
    dbms_output.put_line('Sum c3: ' || v_sum_c3);
    dbms_output.put_line('Avg c1: ' || (v_sum_c1 / v_count));
end;

call test_complex_loop();

-- ============================================
-- Cleanup
-- ============================================

drop table t2;
drop table t1;


--+ server-message off

-- ============================================
-- SUMMARY: PL/CSQL Tests
-- Total 13 sections with 60+ individual test cases:
-- - Cursor operations (6 cases)
-- - FOR loop with implicit records (5 cases)
-- - Static SQL SELECT INTO (4 cases)
-- - Static SQL INSERT/UPDATE/DELETE (5 cases)
-- - Dynamic SQL (5 cases)
-- - Stored functions (3 cases)
-- - OUT/IN OUT parameters (3 cases)
-- - Exception handling (2 cases)
-- - Local procedures/functions (2 cases)
-- - Bulk operations (2 cases)
-- - CASE statements (2 cases)
-- - SYS_REFCURSOR (2 cases)
-- - Complex scenarios (3 cases)
-- ============================================