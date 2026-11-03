# 5. Comparación técnica, seguridad y copias

## 5.1 Comparativa técnica frente a SQL y Documentos
Tomando como referencia la consulta de recomendación colaborativa (apartado 4.4: "Adoptantes con tu perfil también miraron..."), así es como se comporta Neo4j frente a otras tecnologías de bases de datos:

| Criterio | Solución en Neo4j (Grafos) | Solución en PostgreSQL (SQL Relacional) | Solución en MongoDB (Documental) |
| :--- | :--- | :--- | :--- |
| **Sintaxis** | Patrón visual declarativo de 5 líneas con `MATCH (yo)-[:SOLICITA]->(a)<-[:SOLICITA]-(otro)`. | Consulta compleja con 3 o 4 sentencias `JOIN` cruzando tablas intermedias (`adoptantes`, `solicitudes`, `animales`) y cláusula `WHERE NOT IN`. | Múltiples etapas de agregación `$lookup` con `$unwind` cruzando arrays de solicitudes anidadas. |
| **Mecánica interna** | **Adyacencia libre de índices:** el cursor salta por los punteros físicos de memoria directamente del adoptante a sus animales afines, sin buscar en índices intermedios. | Realiza búsquedas en índices B-Tree sobre la tabla global de solicitudes y calcula intersecciones temporales con productos cartesianos en memoria RAM. | Carga en memoria documentos completos de adoptantes con sus arrays desnormalizados, consumiendo gran ancho de banda y CPU. |
| **Complejidad temporal** | $O(k)$ proporcional únicamente a la cantidad de adoptantes afines directos y sus solicitudes. | $O(N \cdot \log M)$ donde el coste se dispara según crecen los miles de registros de adopción de toda la plataforma. | Elevada, especialmente si los documentos de usuario contienen historiales de adopción largos sin paginar. |
| **Tiempo de respuesta (a gran escala)** | 2 a 5 milisegundos. | 200 a 800 milisegundos (riesgo de colapsar la app móvil si hay muchas búsquedas simultáneas). | 150 a 600 milisegundos. |

## 5.2 Procedimiento de copia de seguridad y restauración
Para mantener a salvo los datos de los animales, protectoras y familias, las copias físicas del grafo se realizan desde la terminal del sistema operativo (fuera de Cypher):

```bash
# 1. Realizar un dump físico completo de la base de datos (copia de seguridad)
neo4j-admin database dump neo4j --to-path=/var/backups/neo4j/red_adopciones_$(date +%F).dump

# 2. Restaurar la base de datos a partir de un archivo dump específico
neo4j-admin database load neo4j --from-path=/var/backups/neo4j/red_adopciones_2026-10-26.dump --overwrite-destination=true
```
*Nota:* Si el entorno estuviera desplegado en Neo4j AuraDB (la nube gestionada), estos backups se realizarían de forma automatizada cada 24 horas y se podrían restaurar con un solo clic desde el panel de control.

## 5.3 Usuarios y Principio de Mínimo Privilegio (RBAC)
No todos los usuarios del sistema deben tener el mismo nivel de acceso. En Neo4j, definimos roles nativos para garantizar la seguridad:

```cypher
// 1. Usuario para la app móvil de los adoptantes (rol exclusivo de lectura para consultar el catálogo)
CREATE USER app_adoptantes SET PASSWORD 'AppAdoptantes_2026!' CHANGE NOT REQUIRED;
GRANT ROLE reader TO app_adoptantes;

// 2. Usuario para los coordinadores de las protectoras (permiso para crear animales, actualizar estados y gestionar casas de acogida)
CREATE USER gestor_protectora SET PASSWORD 'GestorProtectora_2026!' CHANGE NOT REQUIRED;
GRANT ROLE publisher TO gestor_protectora;
```
![alt text](image-11.png)
## 5.4 Dos situaciones donde Neo4j NO es la mejor opción
Aunque Neo4j es insuperable para buscar conexiones, hay escenarios dentro de una protectora donde un grafo sería una mala decisión técnica:

1. **Analítica agregada de facturación y donaciones:** Si el departamento contable necesita calcular la suma total de las cuotas de miles de socios o donaciones puntuales agrupadas por trimestre para generar modelos fiscales, una base de datos columnar (como Snowflake, ClickHouse) o relacional pura (PostgreSQL) es muchísimo más rápida y eficiente.
2. **Telemetría IoT en collares GPS o sensores de jaulas:** Si las protectoras instalan collares GPS en los perros que envían un "ping" de ubicación cada 5 segundos, almacenar ese volumen masivo de datos secuenciales hundiría el grafo. Para series temporales puras sin relaciones complejas, un motor Time-Series o clave-valor (como InfluxDB o Amazon DynamoDB) es la herramienta adecuada.