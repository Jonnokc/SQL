SELECT DISTINCT CONSUMER_NAME,
                CODE_SYSTEM_ID,
                CODE_NAME,
                CODE_VALUE,
                MAPPING_STATUS,
                ACTIVITY_COUNT
FROM CONCEPTMAPSUPPORT.CODES_MAPPINGS
WHERE MAPPING_STATUS = 'Validated'
 AND CODE_SYSTEM_ID = 'urn:cerner:coding:codingsystem:codeset:72'
ORDER BY CONSUMER_NAME, (CASE
                             WHEN ACTIVITY_COUNT IS NULL THEN 0
                             ELSE 1
                         END) DESC, ACTIVITY_COUNT DESC
