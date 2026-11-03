// TEST DE PERFILADO DE ÍNDICE
PROFILE
MATCH (a:Animal {nombre: "Thor"})
RETURN a.especie, a.raza, a.nivel_energia;

// 1. ACTUALIZACIÓN TRANSACCIONAL IDEMPOTENTE
MATCH (u:Adoptante {id: "USR-02"})
MATCH (a:Animal {id: "ANI-06"})
MERGE (u)-[s:SOLICITA]->(a)
ON CREATE SET s.fecha_solicitud = date(), s.estado_proceso = "pendiente"
ON MATCH SET s.estado_proceso = "actualizado", s.ultima_revision = date()
RETURN u.nombre AS adoptante, a.nombre AS animal_solicitado, s.estado_proceso AS estado_solicitud;

// 2. CONSULTA DE 1 SALTO (CATÁLOGO PROTECTORA)
MATCH (p:Protectora {id: "REF-01"})-[r:RESCATA]->(a:Animal)
RETURN a.nombre AS animal, a.especie AS especie, a.edad_meses AS meses, a.nivel_energia AS energia, r.fecha_ingreso AS fecha_rescate
ORDER BY r.fecha_ingreso DESC;

// 3. CONSULTA MULTI-SALTO (SEGUIMIENTO ACOGIDAS Y ADOPCIONES)
MATCH (u:Adoptante)-[s:SOLICITA]->(a:Animal)<-[aco:ACOGE]-(c:CasaAcogida)
WHERE s.estado_proceso = "en revisión" AND aco.estado = "activo"
RETURN u.nombre AS adoptante_interesado, a.nombre AS animal, c.nombre AS casa_acogida, c.zona AS zona_acogida
ORDER BY s.fecha_solicitud ASC;

// 4. RECOMENDACIÓN POR AFINIDAD
MATCH (yo:Adoptante {id: "USR-02"})-[:SOLICITA]->(a:Animal)<-[:SOLICITA]-(otro:Adoptante)-[:SOLICITA]->(recomendado:Animal)
WHERE yo <> otro AND NOT (yo)-[:SOLICITA]->(recomendado)
RETURN recomendado.nombre AS animal_recomendado, recomendado.especie AS especie, count(otro) AS coincidencias_adoptantes
ORDER BY coincidencias_adoptantes DESC;

// 5. CAMINO MÁS CORTO (SHORTESTPATH)
MATCH (p:Protectora {nombre: "Protectora Huellas Felices"}), (u:Adoptante {nombre: "Javier Alonso"})
MATCH camino = shortestPath((p)-[:RESCATA|ACOGE|SOLICITA|COORDINA*..6]-(u))
RETURN [n IN nodes(camino) | coalesce(n.nombre, n.id)] AS cadena_contactos, length(camino) AS grados_de_separacion;