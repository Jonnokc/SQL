--Pulls back all the Ontology data for a client. Must filter by their Code System ID's we are using for this review.

--Replace <SCHEMA> with the clients SCHEMA
-- Add in all the Code System ID's which are validated for this client in the WHERE statement

SELECT DISTINCT
    O.CODE_OID as "Standard Code ID",
    O.CODE_SYSTEM_ID AS "Coding System ID - Ontology",
    SCM.CONCEPT_ALIAS AS "Concept Alias - Ontology"
FROM
    <SCHEMA>.PH_D_ONTOLOGY O
    INNER JOIN <SCHEMA>.PH_D_ONTOLOGY_CONCEPT_ALIAS OCA ON (O.CONCEPT_ID = OCA.CONCEPT_ID) AND (O.CONTEXT_ID = OCA.CONTEXT_ID) AND (O.POPULATION_ID = OCA.POPULATION_ID)
    INNER JOIN REFERENCE.CUST_STANDARD_CONCEPTS_MEASURES SCM ON (OCA.ALIAS = SCM.CONCEPT_ALIAS) AND (OCA.CONTEXT_ID = SCM.CONTEXT_ID)
WHERE CODE_SYSTEM_ID IN () -- List out all the Code System ID's we are using for this client.
