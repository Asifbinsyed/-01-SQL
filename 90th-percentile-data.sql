


--- This query pulls the data of 90th percentile from the sourcing data. 



WITH Percentile_CTE AS (
  SELECT
    SUB_DPT_NBR,
    APPROX_QUANTILES(UNIT_QTY, 100)[OFFSET(90)] AS PERCENTILE_90
  FROM
    `analytics-df-thd.DELV_ANALYTICS.TAT_SOURCINGDATA_PULL_FACTSOTC`
  GROUP BY
    SUB_DPT_NBR
),
Filtered_CTE AS (
  SELECT
    main_table.*,
    Percentile_CTE.PERCENTILE_90
  FROM
    `analytics-df-thd.DELV_ANALYTICS.TAT_SOURCINGDATA_PULL_FACTSOTC` AS main_table
  LEFT JOIN
    Percentile_CTE
  ON
    main_table.SUB_DPT_NBR = Percentile_CTE.SUB_DPT_NBR
  WHERE
    main_table.UNIT_QTY <= Percentile_CTE.PERCENTILE_90
)

SELECT
Filtered_CTE.WORK_ORD_NBR, Filtered_CTE.CLS_NM, Filtered_CTE.CLS, Filtered_CTE.UNIT_QTY, Filtered_CTE.DPT_NBR, Filtered_CTE.DLVY_MKT_DESC, Filtered_CTE.IS_COMPLETE_CUST_ONTIME, Filtered_CTE.OTC_REASON_CODE, Filtered_CTE.PERCENTILE_90

FROM
  Filtered_CTE

