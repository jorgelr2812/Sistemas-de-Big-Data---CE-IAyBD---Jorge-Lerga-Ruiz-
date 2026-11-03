# Práctica 02: Red de Adopción de Mascotas con Neo4j
**Autor:** Jorge Lerga Ruiz

## 1. Definición del problema y los actores

### 1.1 Escenario elegido
Para este trabajo he montado una red de adopción de animales enfocada en conectar protectoras, casas de acogida temporales, animales rescatados y posibles adoptantes. La idea es optimizar la compatibilidad entre las características del animal y el perfil de la familia adoptante.
Los actores principales son: `:Animal` (protagonista), `:Protectora` (rescate y gestión), `:CasaAcogida` (hogar temporal) y `:Adoptante` (usuario final).

### 1.2 Seis preguntas de negocio a resolver
1. ¿Qué animales acogidos en una zona cumplen con la energía y sociabilidad que busca un adoptante?
2. ¿Qué casas de acogida están libres y han albergado previamente animales similares al nuevo rescatado?
3. ¿Cuál es el camino más corto (`shortestPath`) entre una protectora y un adoptante a través de intermediarios?
4. ¿Qué animales llevan más tiempo esperando sin haber encontrado una casa de acogida temporal ni adopción?
5. ¿Qué adoptantes tienen un perfil de vivienda incompatible con perros grandes de alta energía?
6. ¿Cómo registrar transaccionalmente una adopción sin duplicar solicitudes usando `MERGE`?

### 1.3 Frecuencia de lectura frente a escritura
- **Lecturas masivas (85-90%):** Consultar catálogo de animales, ver compatibilidad, buscar casas de acogida libres de emergencia.
- **Escrituras puntuales (10-15%):** Registrar entrada de un animal, actualizar el estado de una adopción, o dar de alta solicitudes.

### 1.4 Requisitos de seguridad, disponibilidad y RGPD
- **RGPD:** Se debe poder enmascarar o borrar la información personal sensible de adoptantes (`DETACH DELETE`) sin romper estadísticas anónimas.
- **Seguridad:** Conexiones cifradas mediante Bolt con autenticación por roles (RBAC).
- **Disponibilidad:** Alta disponibilidad para actualizar plazas urgentes al momento.

---

## 6. Revisar y entregar (Instrucciones de ejecución)

### 6.1 Instrucciones de despliegue en Neo4j
1. Abre una base de datos limpia en Neo4j Desktop.
2. Abre y ejecuta el script `scripts/01-restricciones-indices.cypher`.
3. Ejecuta de un solo golpe el script `scripts/02-carga-datos.cypher` para poblar el grafo completo.
4. Ejecuta las consultas sueltas de `scripts/03-consultas-recorridos.cypher` para analizar los datos.

### 6.2 Estructura del proyecto
- **`README.md`**: Definición del proyecto e instrucciones.
- **`docs/modelo.md`**: Diseño del modelo en Mermaid, justificación y comparativa técnica.
- **`docs/evidencias/`**: Capturas de ejecución y plan `PROFILE`.
- **`datos/README.md`**: Explicación de la carga de datos programática.
- **`scripts/`**: Archivos Cypher de ejecución secuencial.