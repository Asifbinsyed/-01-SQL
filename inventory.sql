

--INVENTORY 
-- Highly recommend landing a subset from this table and running analytics off that to save runtime/etc (This is a BIG table)

select
a.SKU_NBR
,a.SKU_CRT_DT
,a.STR_NBR
,a.CAL_DT
,ROUND(sum(OH_QTY),0) OH_QTY
,GREATEST(ceiling(max(RW_MAX_ASW_UNT_AMT/7)),1) as ASWBUFFER
,GREATEST(ROUND(sum(OH_QTY),0) - GREATEST(ceiling(max(RW_MAX_ASW_UNT_AMT/7)),1),0) as ATS_QTY
from `pr-edw-views-thd.SCHN_INV.STR_SKU_INV_DLY` a
where 1 =1
and OH_QTY >= 0
and SKU_STAT_CD <= 400
and a.STR_NBR = '8119'
group by 1,2,3,4
