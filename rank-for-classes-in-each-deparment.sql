-- This is the rank for classes for each departent based on unit order quntity


SELECT
    CLS_NM,
    AVG(UNIT_QTY) AS AvgUnitOrder,
    RANK() OVER (ORDER BY AVG(UNIT_QTY) DESC) AS ClassRank
FROM `analytics-df-thd.DELV_ANALYTICS.TAT_SOURCINGDATA_PULL_FACTSOTC`
   
WHERE
    DPT_NBR = 25
GROUP BY
    CLS_NM
ORDER BY
    AvgUnitOrder DESC;