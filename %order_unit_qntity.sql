WITH QuantityOne AS (
    SELECT COUNT(*) as count_one
    FROM (
        SELECT WORK_ORD_NBR, SKU_NBR, SUM(UNIT_QTY) as total_quantity
        FROM `analytics-df-thd.DELV_ANALYTICS.TAT_SOURCINGDATA_PULL_FACTSOTC`
        WHERE CLS="Flat"
        GROUP BY 1, 2
        HAVING SUM(UNIT_QTY) = 1
    )
),
TotalSKUs AS (
    SELECT COUNT(*) as total_count
    FROM (
        SELECT WORK_ORD_NBR, SKU_NBR, SUM(UNIT_QTY) as total_quantity
        FROM `analytics-df-thd.DELV_ANALYTICS.TAT_SOURCINGDATA_PULL_FACTSOTC`
        WHERE CLS="Flat"
        GROUP BY 1, 2
        HAVING SUM(UNIT_QTY) >= 1
    )
)
SELECT (QuantityOne.count_one / TotalSKUs.total_count) * 100 as percentage
FROM QuantityOne, TotalSKUs;