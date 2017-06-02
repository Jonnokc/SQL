--REPLACE <CLIENT>
--REPLACE <POPULATION_ID>

SELECT DISTINCT E.POPULATION_ID AS "Population ID",
                E.SOURCE_DESCRIPTION AS "Source",
                A.REGISTRY_FRIENDLY_NAME AS "Registry",
                A.MEASURE_FRIENDLY_NAME AS "Measure",
                A.SECTION AS "Section",
                A.CONCEPT_ALIAS AS "Concept Alias",
                A.QUALIFIER AS "Qualifier",
                A.NEGATE_QUALIFIER AS "Negate Qualifier",
                E.RESULT_RAW_CODE AS "Raw Result Code",
                E.RESULT_DISPLAY AS "Raw Result Display",
                E.RESULT_RAW_CODING_SYSTEM_ID AS "Raw Result Coding System",
                E.RESULT_CODE AS "Standardized Result Code",
                E.RESULT_CODING_SYSTEM_ID AS "Standardized Result Coding System",
                E.RESULT_PRIMARY_DISPLAY AS "Standardized Result Display",
                E.RESULT_VALUE_TYPE AS "Result Type",
                CAST(CASE
                         WHEN E.RESULT_VALUE_TYPE = 'TEXT' THEN UPPER(E.NORM_TEXT_VALUE)
                         ELSE NULL
                     END AS VARCHAR(200)) AS "Text Result Value",
                CAST(CASE
                         WHEN E.RESULT_VALUE_TYPE = 'CODIFIED' THEN E.NORM_CODIFIED_VALUE_DISPLAY || ' | ' || E.NORM_CODIFIED_VALUE_RAW_CODE || ' | ' || E.NORM_CODIFIED_VALUE_RAW_CODING_SYSTEM_ID
                         ELSE NULL
                     END AS VARCHAR(200)) AS "Codified Result Raw Value",
                CAST(CASE
                         WHEN E.RESULT_VALUE_TYPE = 'CODIFIED' THEN E.NORM_CODIFIED_VALUE_PRIMARY_DISPLAY || ' | ' || E.NORM_CODIFIED_VALUE_CODE || ' | ' || E.NORM_CODIFIED_VALUE_CODING_SYSTEM_ID
                         ELSE NULL
                     END AS VARCHAR(200)) AS "Codified Result Standardized Value",
                B2.ALIAS AS "Codified Result Concept Alias" --	,e.status_display || ' | ' ||e.status_primary_display AS "STATUS DISPLAY: RAW | STANDARD"
 ,
                COUNT(*) AS "Count"
FROM REFERENCE.CUST_STANDARD_CONCEPTS_MEASURES A
JOIN <CLIENT>.PH_D_ONTOLOGY_CONCEPT_ALIAS B ON (A.CONTEXT_ID = B.CONTEXT_ID
                                                AND A.CONCEPT_ALIAS = B.ALIAS)
JOIN <CLIENT>.PH_D_ONTOLOGY C ON (B.CONTEXT_ID = C.CONTEXT_ID
                                  AND B.CONCEPT_ID = C.CONCEPT_ID
                                  AND B.POPULATION_ID = C.POPULATION_ID)--	JOIN <CLIENT>.ph_d_ontology_context_alias d ON (c.context_id = d.context_id AND c.population_id = d.population_id)

JOIN <CLIENT>.PH_F_RESULT E ON (E.RESULT_CODE = C.CODE_OID
                                AND E.RESULT_CODING_SYSTEM_ID = C.CODE_SYSTEM_ID
                                AND E.POPULATION_ID = C.POPULATION_ID)
LEFT JOIN <CLIENT>.PH_D_ONTOLOGY C2 ON (C2.CODE_OID = E.NORM_CODIFIED_VALUE_CODE
                                        AND C2.CODE_SYSTEM_ID = E.NORM_CODIFIED_VALUE_CODING_SYSTEM_ID
                                        AND C2.POPULATION_ID = E.POPULATION_ID)
LEFT JOIN <CLIENT>.PH_D_ONTOLOGY_CONCEPT_ALIAS B2 ON (B2.CONTEXT_ID = C2.CONTEXT_ID
                                                      AND B2.CONCEPT_ID = C2.CONCEPT_ID
                                                      AND B2.POPULATION_ID = C.POPULATION_ID)
WHERE E.POPULATION_ID = '<POPULATION_ID>'
 AND (A.NEGATE_QUALIFIER IS NULL
      OR A.NEGATE_QUALIFIER = 'Y')
 AND ((E.RESULT_VALUE_TYPE = 'TEXT'
       AND LENGTH(E.NORM_TEXT_VALUE) < 75
       AND (UPPER(E.NORM_TEXT_VALUE) IN ('CANCEL',
                                         'DEFERRED',
                                         'DISREGARD',
                                         'DISREGRD',
                                         'ERR',
                                         'ERROR',
                                         'IN ERROR',
                                         'INFORMATION NOT PROVIDED',
                                         'INVALID',
                                         'LAB ENTRY ERROR',
                                         'N/A',
                                         'NA',
                                         'NO REPORT',
                                         'NOT APPL',
                                         'NOT APPLICABLE',
                                         'NOT CALC',
                                         'NOT CALCULATED',
                                         'NOT DONE',
                                         'NOT ENTERED',
                                         'NOT GIVEN',
                                         'NOT MEASURED',
                                         'NOT PERF',
                                         'NOT PERFORMED',
                                         'NOT PROVIDED',
                                         'NOT REPORTED',
                                         'NOT STATED',
                                         'ORDER ERROR',
                                         'REFUSED',
                                         'REJECT',
                                         'REJECTED',
                                         'REQUISITION ERROR',
                                         'RESULT NOT APPLICABLE',
                                         'TEST NOT PERFORMED',
                                         'UNABLE TO ASSESS',
                                         'UNABLE TO CALC',
                                         'UNABLE TO CALCULATE',
                                         'UNABLE TO OBTAIN',
                                         'UNCOLLECTED, CANCELED BY PROTOCOL',
                                         'UNINTERPRETABLE RESULT',
                                         'WRONG PATIENT')
            OR UPPER(E.NORM_TEXT_VALUE) LIKE '%CANCELLED%'))
      OR (E.RESULT_VALUE_TYPE = 'CODIFIED'
          AND (UPPER(E.NORM_CODIFIED_VALUE_DISPLAY) IN ('CANCEL',
                                                        'DEFERRED',
                                                        'DISREGARD',
                                                        'DISREGRD',
                                                        'ERR',
                                                        'ERROR',
                                                        'IN ERROR',
                                                        'INFORMATION NOT PROVIDED',
                                                        'INVALID',
                                                        'LAB ENTRY ERROR',
                                                        'N/A',
                                                        'NA',
                                                        'NO REPORT',
                                                        'NOT APPL',
                                                        'NOT APPLICABLE',
                                                        'NOT CALC',
                                                        'NOT CALCULATED',
                                                        'NOT DONE',
                                                        'NOT ENTERED',
                                                        'NOT GIVEN',
                                                        'NOT MEASURED',
                                                        'NOT PERF',
                                                        'NOT PERFORMED',
                                                        'NOT PROVIDED',
                                                        'NOT REPORTED',
                                                        'NOT STATED',
                                                        'ORDER ERROR',
                                                        'REFUSED',
                                                        'REJECT',
                                                        'REJECTED',
                                                        'REQUISITION ERROR',
                                                        'RESULT NOT APPLICABLE',
                                                        'TEST NOT PERFORMED',
                                                        'UNABLE TO ASSESS',
                                                        'UNABLE TO CALC',
                                                        'UNABLE TO CALCULATE',
                                                        'UNABLE TO OBTAIN',
                                                        'UNCOLLECTED, CANCELED BY PROTOCOL',
                                                        'UNINTERPRETABLE RESULT',
                                                        'WRONG PATIENT')
               OR UPPER(E.NORM_CODIFIED_VALUE_DISPLAY) LIKE '%CANCELLED%')))
GROUP BY E.POPULATION_ID,
         E.SOURCE_DESCRIPTION,
         A.REGISTRY_FRIENDLY_NAME,
         A.MEASURE_FRIENDLY_NAME,
         A.SECTION,
         A.CONCEPT_ALIAS,
         A.QUALIFIER,
         A.NEGATE_QUALIFIER,
         E.RESULT_RAW_CODE,
         E.RESULT_DISPLAY,
         E.RESULT_RAW_CODING_SYSTEM_ID,
         E.RESULT_CODE,
         E.RESULT_CODING_SYSTEM_ID,
         E.RESULT_PRIMARY_DISPLAY,
         E.RESULT_VALUE_TYPE,
         CASE
             WHEN E.RESULT_VALUE_TYPE = 'TEXT' THEN UPPER(E.NORM_TEXT_VALUE)
             ELSE NULL
         END,
         CASE
             WHEN E.RESULT_VALUE_TYPE = 'CODIFIED' THEN E.NORM_CODIFIED_VALUE_DISPLAY || ' | ' || E.NORM_CODIFIED_VALUE_RAW_CODE || ' | ' || E.NORM_CODIFIED_VALUE_RAW_CODING_SYSTEM_ID
             ELSE NULL
         END,
         CASE
             WHEN E.RESULT_VALUE_TYPE = 'CODIFIED' THEN E.NORM_CODIFIED_VALUE_PRIMARY_DISPLAY || ' | ' || E.NORM_CODIFIED_VALUE_CODE || ' | ' || E.NORM_CODIFIED_VALUE_CODING_SYSTEM_ID
             ELSE NULL
         END,
         B2.ALIAS --	,e.status_display || ' | ' ||e.status_primary_display
ORDER BY E.POPULATION_ID,
         E.SOURCE_DESCRIPTION,
         A.REGISTRY_FRIENDLY_NAME,
         A.MEASURE_FRIENDLY_NAME,
         A.SECTION,
         A.CONCEPT_ALIAS,
         A.QUALIFIER,
         A.NEGATE_QUALIFIER,
         COUNT(*)
