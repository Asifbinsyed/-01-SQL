WITH Dept_Avg AS (
    SELECT 
        DPT_NBR,
        AVG(UNIT_QTY) AS Dept_Avg_Qty
    FROM 
        `analytics-df-thd.DELV_ANALYTICS.TAT_SOURCINGDATA_PULL_FACTSOTC`
    GROUP BY 
        DPT_NBR
),
Class_Avg AS (
    SELECT 
        DPT_NBR,
        CLS_NM,
        AVG(UNIT_QTY) AS Class_Avg_Qty
    FROM 
        `analytics-df-thd.DELV_ANALYTICS.TAT_SOURCINGDATA_PULL_FACTSOTC`
    GROUP BY 
        DPT_NBR, CLS_NM
),
Ranking AS (
    SELECT 
        DPT_NBR,
        CLS_NM,
        Class_Avg_Qty,
        RANK() OVER (PARTITION BY DPT_NBR ORDER BY Class_Avg_Qty DESC) AS HighRank,
        RANK() OVER (PARTITION BY DPT_NBR ORDER BY Class_Avg_Qty ASC) AS LowRank
    FROM 
        Class_Avg
)
SELECT 
    da.DPT_NBR,
    da.Dept_Avg_Qty AS Department_Average_Quantity,
    MAX(CASE WHEN r.HighRank = 1 THEN r.CLS_NM ELSE NULL END) AS Class_Highest_Avg,
    MAX(CASE WHEN r.HighRank = 1 THEN r.Class_Avg_Qty ELSE NULL END) AS Avg_Qty_Highest_Class,
    MAX(CASE WHEN r.LowRank = 1 THEN r.CLS_NM ELSE NULL END) AS Class_Lowest_Avg,
    MAX(CASE WHEN r.LowRank = 1 THEN r.Class_Avg_Qty ELSE NULL END) AS Avg_Qty_Lowest_Class
FROM 
    Dept_Avg da
JOIN 
    Ranking r ON da.DPT_NBR = r.DPT_NBR
GROUP BY 
    da.DPT_NBR,
    da.Dept_Avg_Qty;
