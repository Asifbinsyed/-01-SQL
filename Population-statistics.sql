
-- find total distinct work order number  

SELECT COUNT(DISTINCT(WORK_ORD_NBR))
FROM
    `analytics-df-thd.DELV_ANALYTICS.TAT_SOURCINGDATA_PULL_FACTSOTC`


-- find the total distinct SKU number 

SELECT COUNT(DISTINCT(SKU_NBR))
FROM
    `analytics-df-thd.DELV_ANALYTICS.TAT_SOURCINGDATA_PULL_FACTSOTC`


-- find the average unit quantity per order 
SELECT SUM(UNIT_QTY)/COUNT(DISTINCT(WORK_ORD_NBR))
FROM
    `analytics-df-thd.DELV_ANALYTICS.TAT_SOURCINGDATA_PULL_FACTSOTC`





-- % of order that has Unit qty of 1 (SKU level)


SELECT 
    COUNT(WORK_ORD_NBR) AS Count_Unit_Qty_1,
    (SELECT COUNT(WORK_ORD_NBR) FROM `analytics-df-thd.DELV_ANALYTICS.TAT_SOURCINGDATA_PULL_FACTSOTC`) AS Total_Count,
    (COUNT(WORK_ORD_NBR) / (SELECT COUNT(WORK_ORD_NBR) FROM `analytics-df-thd.DELV_ANALYTICS.TAT_SOURCINGDATA_PULL_FACTSOTC`)) * 100 AS Percentage
FROM
    `analytics-df-thd.DELV_ANALYTICS.TAT_SOURCINGDATA_PULL_FACTSOTC`
WHERE 
    UNIT_QTY = 1;



-- Classes with highest average qty and lowest average quantity
WITH Dept_Avg AS (
    SELECT 
        DPT_NBR,
        CLS_NM,
        AVG(UNIT_QTY) AS Avg_Qty
    FROM 
        `analytics-df-thd.DELV_ANALYTICS.TAT_SOURCINGDATA_PULL_FACTSOTC`
    GROUP BY 
        DPT_NBR, CLS_NM
),
Ranking AS (
    SELECT 
        DPT_NBR,
        CLS_NM,
        Avg_Qty,
        RANK() OVER (PARTITION BY DPT_NBR ORDER BY Avg_Qty DESC) AS HighRank,
        RANK() OVER (PARTITION BY DPT_NBR ORDER BY Avg_Qty ASC) AS LowRank
    FROM 
        Dept_Avg
)
SELECT 
    a.DPT_NBR,
    MAX(a.Avg_Qty) AS Average_Quantity,
    MAX(CASE WHEN b.HighRank = 1 THEN b.CLS_NM ELSE NULL END) AS Class_Highest_Avg,
    MAX(CASE WHEN b.HighRank = 1 THEN b.Avg_Qty ELSE NULL END) AS Avg_Qty_Highest_Class,
    MAX(CASE WHEN b.LowRank = 1 THEN b.CLS_NM ELSE NULL END) AS Class_Lowest_Avg,
    MAX(CASE WHEN b.LowRank = 1 THEN b.Avg_Qty ELSE NULL END) AS Avg_Qty_Lowest_Class
FROM 
    Dept_Avg a
JOIN 
    Ranking b ON a.DPT_NBR = b.DPT_NBR AND a.CLS_NM = b.CLS_NM
GROUP BY 
    a.DPT_NBR;



