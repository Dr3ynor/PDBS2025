-- BEZ OPTIMALIZACE
explain plan for
SELECT
    oi.idOrder,
    oi.idProduct,
    oi.unit_price AS order_item_price,
    oi.quantity,
    p.name AS product_name,
    p.unit_price AS product_price,
    p.producer,
    p.description
FROM OrderItem oi
JOIN Product p ON oi.idProduct = p.idProduct
WHERE p.unit_price BETWEEN 500000 AND 500400;
-- 57 zaznamu 500000 AND 500400;

select * from table(dbms_xplan.display);
-- HASH Plan hash value: 1007604437

SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE parsing_schema_name = 'RUZ0096'
ORDER BY last_active_time DESC;
-- SQL_ID: 9291ggbx8xsxu

begin
    PrintQueryStat('9291ggbx8xsxu', 1007604437);
end;


-- OPTIMALIZACE
CREATE INDEX idx_orderitem_product ON OrderItem(idProduct);
CREATE INDEX idx_product_price ON Product(unit_price);

-- PO OPTIMALIZACI
explain plan for
SELECT
    oi.idOrder,
    oi.idProduct,
    oi.unit_price AS order_item_price,
    oi.quantity,
    p.name AS product_name,
    p.unit_price AS product_price,
    p.producer,
    p.description
FROM OrderItem oi
JOIN Product p ON oi.idProduct = p.idProduct
WHERE p.unit_price BETWEEN 500000 AND 500400;

select * from table(dbms_xplan.display);
-- Plan hash value: 919054654

SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE parsing_schema_name = 'RUZ0096'
ORDER BY last_active_time DESC;
-- 9291ggbx8xsxu

begin
    PrintQueryStat('9291ggbx8xsxu', 919054654);
end;


------------------------------ 2. dotaz --------------------------------------------------
explain plan for
SELECT
    COUNT(*) AS total_order_items,   -- Počet položek objednávek
    SUM(oi.quantity) AS total_sold_quantity  -- Celkový počet prodaných kusů
FROM OrderItem oi
JOIN Product p ON oi.idProduct = p.idProduct
WHERE p.unit_price BETWEEN 500000 AND 500400;

select * from table(dbms_xplan.display);
-- Plan hash value: 779758652
SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE parsing_schema_name = 'RUZ0096'
ORDER BY last_active_time DESC;
-- fuwdmnj9n3cc0

begin
    PrintQueryStat('fuwdmnj9n3cc0', 779758652);
end;


-- BEZ OPTIMALIZACÍ DROPNUTÍ INDEXŮ
DROP INDEX idx_orderitem_product;
DROP INDEX idx_product_price;

explain plan for
SELECT
    COUNT(*) AS total_order_items,   -- Počet položek objednávek
    SUM(oi.quantity) AS total_sold_quantity  -- Celkový počet prodaných kusů
FROM OrderItem oi
JOIN Product p ON oi.idProduct = p.idProduct
WHERE p.unit_price BETWEEN 500000 AND 500400;

select * from table(dbms_xplan.display);
-- Plan hash value: 2262826423

SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE parsing_schema_name = 'RUZ0096'
ORDER BY last_active_time DESC;
-- fuwdmnj9n3cc0

begin
    PrintQueryStat('fuwdmnj9n3cc0', 2262826423);
end;
