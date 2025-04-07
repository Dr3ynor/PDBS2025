


SELECT count(*)
FROM OrderItem oi
JOIN Product p ON oi.idProduct = p.idProduct
JOIN "Order" o ON oi.idOrder = o.idOrder
WHERE p.name LIKE 'Auto%'
AND YEAR(o.order_datetime) = 2022
AND oi.unit_price BETWEEN 1000000 AND 1010000 option (maxdop 1);


-- set statistics time on;
-- set statistics time off;
-- CPU time měříme pomocí sys.dm_exec_query_stats
-- abychom získali průměrný čas pro více dotazů.
set statistics io on;
set statistics io off;
set showplan_text on;
set showplan_text off;

SELECT
    last_elapsed_time / 1000.0 AS elapsed_time_ms,
    last_worker_time / 1000.0 AS cpu_time_ms,
    last_worker_time AS cpu_time_microseconds
FROM sys.dm_exec_query_stats
WHERE sql_handle = (SELECT sql_handle FROM sys.dm_exec_requests WHERE session_id = @@SPID)


CREATE INDEX idx_product_name ON Product(name);
CREATE INDEX idx_order_date ON "Order"(order_datetime);
CREATE INDEX idx_orderitem_price ON OrderItem(unit_price);



DECLARE @counter INT = 0;

WHILE @counter < 150
BEGIN
    SELECT
        oi.idOrder,
        oi.idProduct,
        oi.unit_price AS order_item_price,
        oi.quantity,
        p.name AS product_name,
        p.unit_price AS product_price,
        p.producer,
        p.description,
        o.order_datetime,
        o.order_status,
        o.idCustomer,
        o.idStore,
        o.idStaff
    FROM OrderItem oi
    JOIN Product p ON oi.idProduct = p.idProduct
    JOIN "Order" o ON oi.idOrder = o.idOrder
    WHERE p.name LIKE 'Auto%'
    AND YEAR(o.order_datetime) = 2022
    AND oi.unit_price BETWEEN 1000000 AND 1010000
    OPTION (MAXDOP 1);  -- Omezení paralelizace

    SET @counter = @counter + 1;
END;

    ----------------- 2 DOTAZ-----------------------------------------
DROP INDEX idx_product_name ON Product;
DROP INDEX idx_order_date ON "Order";
DROP INDEX idx_orderitem_price ON OrderItem;


set statistics io on;
set statistics io off;
set showplan_text on;
set showplan_text off;



DECLARE @counter INT = 0;
WHILE @counter < 150
BEGIN
SELECT
    COUNT(*) AS total_order_items,
    SUM(oi.quantity) AS total_sold_quantity
FROM OrderItem oi
JOIN Product p ON oi.idProduct = p.idProduct
JOIN "Order" o ON oi.idOrder = o.idOrder
WHERE p.name LIKE 'Auto%'
AND YEAR(o.order_datetime) = 2022
AND oi.unit_price BETWEEN 1000000 AND 1010000
OPTION (MAXDOP 1);
    SET @counter = @counter + 1;
END;





set statistics io on;
set statistics io off;
set showplan_text on;
set showplan_text off;

SELECT
COUNT(*) AS total_order_items,
SUM(oi.quantity) AS total_sold_quantity
FROM OrderItem oi
JOIN Product p ON oi.idProduct = p.idProduct
JOIN "Order" o ON oi.idOrder = o.idOrder
WHERE p.name LIKE 'Auto%'
AND YEAR(o.order_datetime) = 2022
AND oi.unit_price BETWEEN 1000000 AND 1010000
OPTION (MAXDOP 1);


--------- OPTIMALIZACE
-- Index pro rychlé vyhledávání produktů podle názvu
CREATE INDEX idx_product_name ON Product(name);

-- Index na datum objednávky pro rychlejší filtraci roku 2022
CREATE INDEX idx_order_date ON "Order"(order_datetime);

-- Index pro rychlé vyhledání položek objednávek v daném cenovém rozsahu
CREATE INDEX idx_orderitem_price ON OrderItem(unit_price);

-- Kompozitní index na sloupce používané ve spojení mezi tabulkami
CREATE INDEX idx_orderitem_product ON OrderItem(idProduct);
CREATE INDEX idx_orderitem_order ON OrderItem(idOrder);



UPDATE STATISTICS OrderItem;
UPDATE STATISTICS Product;
UPDATE STATISTICS "Order";
