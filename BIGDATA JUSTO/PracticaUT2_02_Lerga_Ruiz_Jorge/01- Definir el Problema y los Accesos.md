# 1. Definición del problema y los actores

## 1.1 Escenario elegido y usuarios (Red de Adopción de Mascotas)
Para este trabajo he montado una red de adopción de animales enfocada en conectar protectoras, casas de acogida temporales, animales rescatados y posibles adoptantes. La idea es optimizar la compatibilidad entre las características del animal (nivel de energía, sociabilidad con otros perros/gatos, necesidades especiales, tamaño) y el perfil de la casa de acogida o la familia adoptante (espacio en casa, si hay niños, tiempo libre, experiencia previa).

Los actores principales que interactúan en este grafo son:
- **El Animal rescatado:** El protagonista de la red, que tiene asociadas características como su nivel de energía, tamaño, especie, edad y si tolera bien a otros animales o niños.
- **La Protectora (o Refugio):** La organización que rescata al animal, gestiona las instalaciones y coordina tanto las casas de acogida como las adopciones definitivas.
- **La Casa de Acogida:** Una familia o persona voluntaria que acoge temporalmente al animal en su hogar mientras sale una adopción definitiva, aportando datos sobre el espacio disponible y animales actuales en casa.
- **El Adoptante:** El usuario final que busca un compañero compatible según su estilo de vida, tipo de vivienda y zona geográfica.
- **El Administrador / Gestor de Adopciones:** Revisa perfiles, comprueba que las casas de acogida cumplen los requisitos y supervisa las solicitudes de adopción.

## 1.2 Seis preguntas de negocio concretas que la base de datos debe resolver
1. ¿Qué animales acogidos actualmente en casas de acogida de una determinada zona cumplen con el perfil de energía bajo y buena convivencia con niños que busca un adoptante?
2. ¿Qué casas de acogida están libres o tienen espacio disponible y han albergado previamente animales con características similares al nuevo rescatado que acaba de entrar?
3. ¿Cuál es el camino de conexiones (`shortestPath`) o red de intermediarios entre una protectora y un adoptante a través de voluntarios o casas de acogida colaboradoras?
4. ¿Qué animales llevan más tiempo esperando en una protectora sin haber encontrado una casa de acogida temporal ni una adopción?
5. ¿Qué adoptantes tienen un perfil de vivienda (por ejemplo, piso pequeño sin jardín) incompatible con perros de tamaño grande y alta energía?
6. Al registrar una nueva solicitud de adopción, ¿cómo asociarla transaccionalmente al animal y actualizar el estado del proceso usando `MERGE` y `SET` sin duplicar registros?

## 1.3 Datos con mayor frecuencia de lectura frente a escritura
- **Lecturas masivas en tiempo real (aprox. 85-90% del tráfico):**
  - Consultar el catálogo de animales disponibles para adopción filtrando por compatibilidad y ubicación.
  - Ver el perfil detallado de un animal, incluyendo su historial de estancias en casas de acogida y su protectora de origen.
  - Buscar casas de acogida libres que se adapten a las necesidades de un rescate urgente.
- **Escrituras y actualizaciones puntuales (aprox. 10-15% del tráfico):**
  - Registrar la entrada de un nuevo animal rescatado y vincularlo a su protectora.
  - Actualizar el estado de una relación (por ejemplo, cambiar un animal de acogido temporal a adoptado definitivamente).
  - Dar de alta nuevas solicitudes de adopción o modificar la disponibilidad de una casa de acogida.

## 1.4 Requisitos de seguridad, disponibilidad, privacidad (RGPD) y crecimiento
- **Privacidad y RGPD:** Al tratar con datos de personas (adoptantes y familias de acogida con nombres, teléfonos y direcciones), la base de datos debe enmascarar la información personal sensible y permitir el borrado o anonimización completa (`DETACH DELETE`) si un usuario ejerce su derecho al olvido, sin romper el histórico estadístico anónimo de las protectoras.
- **Seguridad:** Conexiones cifradas mediante Bolt con autenticación por roles (separando los permisos de los voluntarios que solo consultan o actualizan estados de acogida frente al administrador general).
- **Disponibilidad:** Al ser una plataforma de emergencia y rescate, se requiere alta disponibilidad para que las protectoras puedan actualizar plazas libres al momento ante avisos urgentes.
- **Prevención de supernodos:** Protectoras muy grandes o ciudades con miles de animales podrían convertirse en supernodos si se relacionan directamente sin control. Para evitar cuellos de botella, las consultas de búsqueda siempre parten de filtros geográficos o de la propia solicitud del usuario, acotando la profundidad de los saltos en las relaciones (`*1..3`).
