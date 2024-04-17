DROP SERIAL IF EXISTS demo_pl_serial;
CREATE SERIAL demo_pl_serial;

create or replace function demo_global_semantics_serial() return numeric as
i numeric;
begin
    i := demo_pl_serial.NEXT_VALUE;
    return i;
end;

CAll demo_global_semantics_serial ();
CAll demo_global_semantics_serial ();
CAll demo_global_semantics_serial ();
CAll demo_global_semantics_serial ();

DROP SERIAL IF EXISTS demo_pl_serial;

CAll demo_global_semantics_serial ();

DROP FUNCTION demo_global_semantics_serial;
