USE OlistMart;

SELECT *
FROM Orders;

SELECT
	COUNT(order_id) AS 'Total Rows',
	COUNT(DISTINCT order_id) AS 'Distinict Orders',
	COUNT(order_id) - COUNT(DISTINCT order_id) AS 'Duplicate Orders'
FROM Orders;

SELECT
	COUNT(customer_id) AS 'customer_id',
	COUNT(order_status) AS 'order_status',
	COUNT(order_purchase_timestamp) AS 'order_purchase_timestamp',
	COUNT(order_approved_at) AS 'order_approved_at',
	COUNT(order_delivered_carrier_date) AS 'order_delivered_carrier_date',
	COUNT(order_delivered_customer_date) AS 'order_delivered_customer_date',
	COUNT(order_estimated_delivery_date) AS 'order_estimated_delivery_date'
FROM Orders;

SELECT
	SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS 'order_purchase_timestamp_nulls',
	SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS 'order_approved_at_nulls',
	SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS 'order_delivered_carrier_date_nulls',
	SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS 'order_delivered_customer_date_nulls'
FROM Orders;

SELECT
	order_status,
	COUNT(*) AS 'Order Count',
	COUNT(*) * 100.0 / SUM(COUNT(*))  OVER() AS '% of total'
FROM Orders
GROUP BY order_status
ORDER BY 'Order Count' DESC;

SELECT
	MIN(order_purchase_timestamp) AS 'oldest order',
	MAX(order_purchase_timestamp) AS 'latest order',
	DATEDIFF(YEAR, MIN(order_purchase_timestamp), MAX(order_purchase_timestamp)) AS 'date diff_ years',
	DATEDIFF(MONTH, MIN(order_purchase_timestamp), MAX(order_purchase_timestamp)) AS 'date diff_months',
	DATEDIFF(DAY, MIN(order_purchase_timestamp), MAX(order_purchase_timestamp)) AS 'date diff_ days'
FROM Orders;
------------------------------------------------------------------------------------------------------------
SELECT *
FROM Order_Items;

SELECT
	COUNT(*) AS 'total rows',
	COUNT(DISTINCT order_id) AS 'distinct_orders',
	COUNT(*) - COUNT(DISTINCT order_id) 'orders with multi items in the same order',
	COUNT(*) * 1.0 / COUNT(DISTINCT order_id), 2 AS 'avg item per odrer'
FROM Order_Items;

SELECT
	ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY shipping_limit_date),
	*
FROM Order_Items;

SELECT
	num_of_items,
	COUNT(*) AS 'orders',
	COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS '%'
FROM (
	SELECT
		order_id,
		COUNT(*) AS 'num_of_items'
	FROM Order_Items
	GROUP BY order_id
) AS t
GROUP BY num_of_items;

SELECT
	MAX(price) 'max price',
	MIN(price) 'min price',
	AVG(price) 'avg price'
FROM Order_Items;

SELECT
	MAX(freight_value ) 'max freight_value',
	MIN(freight_value ) 'min freight_value',
	AVG(freight_value ) 'avg freight_value',
	SUM(CASE WHEN freight_value = 0 THEN 1 ELSE 0 END) AS 'free shipping'
FROM Order_Items;

SELECT *
FROM Customers;

SELECT
	COUNT(*) AS 'total rows',
	COUNT(DISTINCT customer_id) AS 'distinct customers',
	COUNT(DISTINCT customer_unique_id) AS 'unique customers',
	COUNT(*) - COUNT(DISTINCT customer_unique_id) AS 'returning customers'
FROM Customers;

SELECT
	customer_state,
	COUNT(*) AS 'customer count',
	COUNT(DISTINCT customer_city) AS 'city count',
	COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() '%'
FROM Customers
GROUP BY customer_state
ORDER BY 2 DESC;

SELECT
	customer_state,
	customer_city,
	COUNT(*) AS 'customer_count'
FROM Customers
GROUP BY customer_state, customer_city
ORDER BY 3 DESC;

SELECT TOP 15
	customer_state,
	customer_city,
	COUNT(*) AS 'customer_count'
FROM Customers
GROUP BY customer_state, customer_city
ORDER BY 3 DESC;
---------------------------------
SELECT *
FROM Order_Payments;

SELECT
	ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY payment_value) AS rn,
	*
FROM Order_Payments;

SELECT
	COUNT(*) AS total_rows,
	COUNT(DISTINCT order_id) AS distinct_orders,
	COUNT(*) - COUNT(DISTINCT order_id) AS orders_with_multi_payment_type
FROM Order_Payments;

SELECT
	SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
	SUM(CASE WHEN payment_sequential IS NULL THEN 1 ELSE 0 END) AS payment_sequential_nulls,
	SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS payment_type_nulls,
	SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END) AS payment_installments_nulls,
	SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS payment_value_nulls
FROM Order_Payments;

SELECT
	order_id,
	COUNT(DISTINCT payment_type) AS payment_methods_used,
	COUNT(*) AS payment_rows
FROM Order_Payments
GROUP BY order_id
HAVING COUNT(DISTINCT payment_type) > 1;

SELECT
	payment_type,
	SUM(payment_value) AS total_value
FROM Order_Payments
GROUP BY payment_type
ORDER BY 2 DESC;

SELECT
	payment_type,
	COUNT(*)
FROM Order_Payments
GROUP BY payment_type
ORDER BY 2 DESC;

SELECT *
FROM Order_Payments
WHERE payment_type = 'not_defined';

SELECT *
FROM Order_Payments
WHERE order_id IN ('4637ca194b6387e2d538dc89b124b0ee', '00b1cb0320190ca0daa2c88b35206009', 'c8c528189310eaa44a745b8d9d26908b');

SELECT
	payment_type,
	COUNT(*) AS total_rows,
	COUNT(DISTINCT order_id) AS orders,
	SUM(payment_value) AS total_value,
	AVG(payment_value) AS avg_value,
	COUNT(DISTINCT order_id) * 100.0 / SUM(COUNT(DISTINCT order_id)) OVER() AS '%'
FROM Order_Payments
GROUP BY payment_type
ORDER BY SUM(payment_value) DESC;

SELECT
	MIN(payment_value) AS min_value,
	MAX(payment_value) AS max_value,
	AVG(payment_value) AS avg_value,
	SUM(CASE WHEN payment_value = 0 THEN 1 ELSE 0 END) AS no_value
FROM Order_Payments;
-------------------------------------------------------------------------------------------------------
SELECT *
FROM Order_Reviews;

SELECT
	COUNT(*) AS total_rows,
	COUNT(DISTINCT review_id) AS distinct_reviews,
	COUNT(DISTINCT order_id) AS distinct_orders,
	COUNT(*) - COUNT(DISTINCT review_id) AS duplicate_review_rows
FROM Order_Reviews;

SELECT
	review_score,
	COUNT(*) AS review_count,
	COUNT(*) * 100.0/ SUM(COUNT(DISTINCT review_id)) OVER() AS '%'
FROM Order_Reviews
GROUP BY review_score
ORDER BY COUNT(*) DESC;

SELECT
	ROW_NUMBER() OVER(PARTITION BY review_id ORDER BY review_score) AS rn,
	*
FROM Order_Reviews;

SELECT
	COUNT(DISTINCT o.order_id) AS orders,
	COUNT(DISTINCT r.order_id) AS reviews,
	COUNT(DISTINCT o.order_id) - COUNT(DISTINCT r.order_id) AS orders_with_no_reviews,
	(COUNT(DISTINCT o.order_id) - COUNT(DISTINCT r.order_id)) * 100.0 / COUNT(DISTINCT o.order_id) AS '%_of_no_reviews'
FROM Orders AS o
	LEFT JOIN Order_Reviews AS r
	ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
------------------------------------------------------------------------
SELECT *
FROM Products;

SELECT
	COUNT(*) AS total_rows,
	COUNT(DISTINCT product_id) AS distinct_products,
	COUNT(*) - COUNT(DISTINCT product_id) AS duplicates,
	COUNT(DISTINCT product_category_name) AS distinct_names,
	SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS product_category_name_nulls
FROM Products;

SELECT *
FROM Products
WHERE product_category_name IS NULL;

SELECT TOP 20
	product_category_name,
	COUNT(*) AS num_of_products
FROM Products
WHERE product_category_name IS NOT NULL
GROUP BY product_category_name
ORDER BY 2 DESC;

SELECT *
FROM Sellers;

SELECT
	COUNT(*) AS rows,
	COUNT(DISTINCT seller_id) AS distinct_rows,
	COUNT(*) - COUNT(DISTINCT seller_id) AS duplicates,
	COUNT(DISTINCT seller_city) AS distinct_cities,
	COUNT(DISTINCT seller_state) AS distinct_state
FROM Sellers;

SELECT
	seller_state,
	COUNT(*) AS num_of_employees,
	COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS '%'
FROM Sellers
GROUP BY seller_state
ORDER BY 2 DESC;
------------------------------------------
SELECT *
FROM Orders;

CREATE VIEW DIM_Orders
AS
	SELECT
		order_id,
		customer_id,
		order_status,
		order_purchase_timestamp,
		order_approved_at,
		order_delivered_carrier_date,
		order_delivered_customer_date,
		order_estimated_delivery_date,
		DATEDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) AS actual_delivery_days,
		DATEDIFF(DAY, order_purchase_timestamp, order_estimated_delivery_date) AS estimated_delivery_days,
		DATEDIFF(DAY, order_estimated_delivery_date, order_delivered_customer_date) AS delivery_deviation_days,
		CASE WHEN order_delivered_customer_date IS NULL 
			THEN 'Not Yet Delivered'
		 WHEN order_delivered_customer_date <= order_estimated_delivery_date 
			THEN 'On Time' 
			ELSE 'Late'
	END AS delivery_flag
	FROM Orders;

CREATE VIEW DIM_Customers
AS
	SELECT
		*
	FROM Customers;

drop view if EXISTS DIM_Products;
CREATE VIEW DIM_Products
AS
    SELECT
        p.product_id,
        CASE
            WHEN p.product_category_name IS NULL
                THEN 'Uncategorized (Data Gap)'
            WHEN t.product_category_name_english IS NULL
                THEN 'Translation Missing'
            ELSE t.product_category_name_english
        END AS product_category
    FROM Products AS p
        LEFT JOIN Product_Category_Name_Translation AS t
            ON p.product_category_name = t.product_category_name  -- Portuguese to Portuguese

CREATE VIEW DIM_Sellers AS
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM Sellers;

DROP VIEW IF EXISTS DIM_Payments;
select * from Order_Payments

CREATE VIEW DIM_Payments
AS
	SELECT
		order_id,
		SUM(payment_value) AS total_payment_value,
		COUNT(DISTINCT payment_type) AS payment_methods_count,
		MAX(payment_installments) AS max_installments,
		(	
		SELECT TOP 1 payment_type
		FROM Order_Payments AS inner_q
		WHERE inner_q.order_id = main_q.order_id
		ORDER BY payment_value DESC
		) AS dominant_payment_type,
		SUM(CASE WHEN payment_type = 'credit_card' THEN payment_value ELSE 0 END) AS credit_card_value,
		SUM(CASE WHEN payment_type = 'boleto' THEN payment_value ELSE 0 END) AS boleto_value,
		SUM(CASE WHEN payment_type = 'voucher' THEN payment_value ELSE 0 END) AS voucher_value,
		SUM(CASE WHEN payment_type = 'debit_card' THEN payment_value ELSE 0 END) AS debit_card_value
	FROM Order_Payments AS main_q
	GROUP BY order_id;

select * from DIM_Payments

select *
from Order_Reviews

CREATE VIEW DIM_Reviews
AS
	SELECT
		order_id,
		review_id,
		review_score,
		review_creation_date,
		CASE WHEN review_score = 1 THEN 'Very Bad'
		 WHEN review_score = 2 THEN 'Bad'
		 WHEN review_score = 3 THEN 'Neutral'
		 WHEN review_score = 4 THEN 'Good'
		 WHEN review_score = 5 THEN 'Excellent'
		 ELSE 'No Review'
	END AS score_label,
		CASE WHEN review_score >= 4 THEN 'Positive'
		 WHEN review_score = 3 THEN 'Neutral'
		 WHEN review_score <= 2 THEN 'Negative'
		 ELSE 'No Review'
	END AS sentiment
	FROM (
	SELECT
			ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY review_creation_date DESC) AS rn,
			*
		FROM Order_Reviews
	) AS t
	WHERE rn = 1;

SELECT *
FROM Order_Items;

CREATE VIEW FACT_Order_Items AS
SELECT 
	oi.order_id,
	oi.order_item_id,
	o.customer_id,
	oi.product_id,
	oi.seller_id,
	o.order_purchase_timestamp,
	CAST(o.order_purchase_timestamp AS DATE) AS order_date,
	o.order_approved_at,
	o.order_delivered_carrier_date,
	o.order_delivered_customer_date,
	o.order_estimated_delivery_date,
	oi.price,
	oi.freight_value,
	oi.price + oi.freight_value AS item_total,
	oi.shipping_limit_date
FROM Order_Items AS oi
INNER JOIN DIM_Orders AS o
	ON oi.order_id = o.order_id;
--------------------------
SELECT
	COUNT(DISTINCT order_id) AS total_orders,
	COUNT(DISTINCT product_id) AS unique_products_sold,
	COUNT(DISTINCT seller_id) AS active_sellers,
	ROUND(SUM(price), 2) AS total_product_revenue,
	ROUND(SUM(freight_value), 2) AS total_freight_revenue,
	ROUND(SUM(item_total), 2) AS total_revenue,
	ROUND(AVG(price), 2) AS AVG_item_price,
	ROUND(AVG(freight_value), 2) AS AVG_freight_value,
	ROUND(SUM(item_total) / NULLIF(COUNT(DISTINCT order_id), 0), 2) AS 'average_order_value (AOV)',
	ROUND((SUM(freight_value) / NULLIF(SUM(item_total), 0)) * 100.0, 2) AS freight_pct_of_revenue
FROM FACT_Order_Items 

SELECT COUNT(DISTINCT c.customer_unique_id) AS unique_real_customers
FROM DIM_Customers AS c
INNER JOIN FACT_Order_Items AS f
	ON f.customer_id = c.customer_id;

SELECT AVG(r.review_score) AS avg_review_score
FROM DIM_Reviews AS r
INNER JOIN FACT_Order_Items AS f
	ON r.order_id = f.order_id
INNER JOIN DIM_Orders
	ON f.order_id = DIM_Orders.order_id
WHERE DIM_Orders.order_status = 'delivered';

SELECT 
	YEAR(f.order_purchase_timestamp) AS 'year',
	MONTH(f.order_purchase_timestamp) AS 'month',
	COUNT(DISTINCT f.order_id) AS total_orders,
	COUNT(DISTINCT f.customer_id) AS unique_customers,
	ROUND(SUM(f.item_total), 2) AS total_revenue,
	ROUND(SUM(f.item_total) / NULLIF(COUNT(DISTINCT f.order_id), 0), 2) AS AOV
FROM FACT_Order_Items AS f
INNER JOIN DIM_Orders
	ON f.order_id = DIM_Orders.order_id
WHERE DIM_Orders.order_status = 'delivered'
GROUP BY YEAR(f.order_purchase_timestamp), MONTH(f.order_purchase_timestamp)
ORDER BY YEAR(f.order_purchase_timestamp) DESC;

SELECT
	o.order_status,
	COUNT(DISTINCT f.order_id) AS total_orders,
	ROUND(SUM(f.item_total), 2) AS total_revenue,
	ROUND(SUM(f.item_total) / NULLIF(COUNT(DISTINCT f.order_id), 0), 2) AS AOV
FROM FACT_Order_Items AS f
INNER JOIN DIM_Orders AS o
	ON f.order_id = o.order_id
GROUP BY o.order_status
ORDER BY 3 DESC;

SELECT TOP 20
	p.product_category,
	COUNT(DISTINCT f.order_id) AS total_orders,
	COUNT(f.order_item_id) AS total_items_sold,
	ROUND(SUM(f.price), 2) AS product_revenue,
	ROUND(SUM(f.freight_value), 2) AS freight_revenue,
	ROUND(SUM(f.item_total), 2) AS total_revenue,
	ROUND(AVG(f.price), 2) AS avg_item_price,
	SUM(f.item_total) * 100.0 / SUM(SUM(f.item_total)) OVER() AS '% revenue_share_pct'
FROM FACT_Order_Items AS f
INNER JOIN DIM_Products AS p
	ON f.product_id = p.product_id
GROUP BY p.product_category
ORDER BY ROUND(SUM(f.item_total), 2) DESC;
	




select * from [dbo].[Order_Payments]


DROP VIEW IF EXISTS FACT_Order_Items;
CREATE VIEW FACT_Order_Items AS
SELECT 
	oi.order_id,
	oi.order_item_id,
	o.customer_id,
	oi.product_id,
	oi.seller_id,
	o.order_purchase_timestamp,
	CAST(o.order_purchase_timestamp AS DATE) AS order_date,
	o.order_approved_at,
	o.order_delivered_carrier_date,
	o.order_delivered_customer_date,
	o.order_estimated_delivery_date,
	oi.price,
	oi.freight_value,
	oi.price + oi.freight_value AS item_total,
	oi.shipping_limit_date,
	p.payment_value
FROM Order_Items AS oi
INNER JOIN DIM_Orders AS o
	ON oi.order_id = o.order_id
INNER JOIN Order_Payments AS p
	ON o.order_id = p.order_id;

select SUM(payment_value)
from FACT_Order_Items;

select order_id, COUNT(order_id)
from Order_Payments
GROUP BY order_id 
HAVING COUNT(order_id) >1

select *
from Order_Payments

SELECT SUM(payment_value)
from Order_Payments

-- See how many products have null category and their revenue impact
SELECT
    COUNT(DISTINCT p.product_id)          AS products_with_null_category,
    ROUND(SUM(oi.price), 2)               AS revenue_at_risk
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE p.product_category_name IS NULL;

select count(*) from Products
where product_category_name is null


-- Document this as an assumption in your report
-- "Unknown category products with price < 150 assigned to health_beauty
--  based on price range overlap. 610 products affected."

UPDATE Products
SET product_category_name = 'beleza_saude'  -- or whichever fits
WHERE product_category_name IS NULL
  AND product_id IN (
      SELECT DISTINCT product_id
      FROM Order_Items
      WHERE price < 150
  );

  -- Step 1: Get the price profile of the 610 unknown products
SELECT
    ROUND(AVG(oi.price), 2)  AS avg_price_unknown,
    ROUND(MIN(oi.price), 2)  AS min_price_unknown,
    ROUND(MAX(oi.price), 2)  AS max_price_unknown,
    ROUND(STDEV(oi.price), 2) AS stdev_unknown
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE p.product_category_name IS NULL;

-- Step 2: Compare against all known categories
SELECT
    t.product_category_name_english,
    ROUND(AVG(oi.price), 2)  AS avg_price,
    ROUND(MIN(oi.price), 2)  AS min_price,
    ROUND(MAX(oi.price), 2)  AS max_price
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
JOIN Product_Category_Name_Translation t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
GROUP BY t.product_category_name_english
ORDER BY avg_price;