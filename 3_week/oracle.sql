----------------------------------------- 3.1 -----------------------------------------
select * from ORDERITEM where UNIT_PRICE < 300;

explain plan for select * from ORDERITEM
where UNIT_PRICE < 300;

select * from table(dbms_xplan.display);

SELECT sql_id, plan_hash_value, disk_reads, buffer_gets, rows_processed
FROM v$sql
WHERE sql_text LIKE '%ORDERITEM%'
ORDER BY last_active_time DESC;



-- Plan hash value: 4294024870
-- SQL_ID grmtz1yn9ggjz


begin
    PrintQueryStat('grmtz1yn9ggjz',4294024870);
end;

begin
    PrintPages('ORDERITEM','RUZ0096');
end;
----------------------------------------- 3.3 -----------------------------------------
select COUNT(*)
from ORDERITEM
where mod(IDPRODUCT, 2) = 0;

--delete from ORDERITEM where mod(IDPRODUCT, 2) = 0;

begin
    PRINTPAGES('ORDERITEM','RUZ0096');
end;




SELECT sql_id, plan_hash_value, disk_reads, buffer_gets, rows_processed
FROM v$sql
WHERE sql_text LIKE '%ORDERITEM%'
ORDER BY last_active_time DESC;
-- SQLID 5bvsz461y3hyv
-- HASH_VALUE 2836784050
select * from ORDERITEM where UNIT_PRICE < 300;

begin
    PrintQueryStat('5bvsz461y3hyv',2836784050);
end;

select * from ORDERITEM where UNIT_PRICE < 300;

select executions as executions,
  buffer_gets/executions as buffer_gets,
  (cpu_time/executions)/1000.0 as cpu_time_ms,
  (elapsed_time/executions)/1000.0 as elapsed_time_ms,
  rows_processed/executions as rows_processed,
  du.username, sql_text
from v$sql
inner join dba_users du on du.user_id=parsing_user_id
where sql_id='5bvsz461y3hyv' and plan_hash_value=2836784050;

alter table ORDERITEM enable row movement;
alter table orderitem shrink space;

begin
    PRINTPAGES('ORDERITEM','RUZ0096');
end;

select count(*) from ORDERITEM;
