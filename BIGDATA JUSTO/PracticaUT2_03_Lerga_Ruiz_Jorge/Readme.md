# Informe Pericial de Investigación Forense · Caso 07-OMEGA

- **Estudiante / Analista:** Jorge Lerga Ruiz
- **Fecha de emisión:** 2026-11-10
- **Caso:** Sustracción de la Espada Omega en ÁgoraCraft
- **Fuente de auditoría:** Tabla `EscapeRoomMinecraft` (Amazon DynamoDB, región `us-east-1`)

---

## 1. Dictamen pericial

> Tras realizar un análisis exhaustivo de los registros almacenados en la base de datos de Amazon DynamoDB, se puede decir que el robo de la Espada Omega no fue un accidente ni una casualidad, sino un golpe planeado. El autor material del robo fue **CreeperKing** (`P007`) exactamente a las **22:15:18**, aprovechando la ventana de desconexión (*timeout*) que sufrió el administrador del servidor. Inmediatamente después, el objeto fue transportado hasta el **Bosque Oscuro**, donde se produjo el encuentro clave a las **22:17:40** para realizar la transferencia del botín a su cómplice, **ShadowPixel** (`P009`). Finalmente la espada fue llevada a la **Mina** a las **22:18:15** para ser ocultada de forma definitiva. Todo esto demuestra una colaboración activa, premeditada y perfectamente sincronizada entre ambas cuentas.

---

## 2. Cronología forense probada

A continuación se detalla la secuencia cronológica exacta obtenida mediante las consultas directas a las tablas de auditoría de DynamoDB, registrando los eventos clave segundo a segundo:

| Hora exacta (ISO) | ID Cuenta | Alias | Acción / Evento | Zona | Objeto y detalles clave |
|---|---|---|---|---|---|
| `2026-11-02T22:09:00` | `P011` | AdminSol | `DEPOSITAR_OBJETO` | `CamaraTesoro` | `ESPADA_OMEGA` (Depósito inicial y custodia de seguridad) |
| `2026-11-02T22:12:02` | `P007` | CreeperKing | `INICIAR_SESION` | `Spawn` | Conexión inicial a la sesión utilizando la IP `198.51.100.77` |
| `2026-11-02T22:14:10` | `P007` | CreeperKing | `ENTRAR_ZONA` | `CamaraTesoro` | Infiltración a la zona restringida aprovechando el fallo de red del admin |
| `2026-11-02T22:15:18` | `P007` | CreeperKing | `RETIRAR_OBJETO` | `CamaraTesoro` | Sustracción material de la `ESPADA_OMEGA` del cofre principal |
| `2026-11-02T22:17:40` | `P007` | CreeperKing | `TRANSFERIR_OBJETO` | `BosqueOscuro` | Entrega y traspaso físico de la `ESPADA_OMEGA` al jugador `P009` |
| `2026-11-02T22:18:15` | `P009` | ShadowPixel | `OCULTAR_OBJETO` | `Mina` | Depósito y ocultación definitiva de la espada en la mina |

---

## 3. Identificación de responsabilidades

- **Autor material del robo:** CreeperKing (`P007`) — Responsable de acceder a la cámara acorazada y forzar la extracción.
- **Cómplice y receptador:** ShadowPixel (`P009`) — Encargado de recibirlo y esconderlo.
- **Momento exacto del robo físico:** 22:15:18 (Segundo exacto de la retirada del objeto del cofre).
- **Momento oficial de denuncia y alarma:** 22:25:00 (Diez minutos después de consumarse el robo y el ocultamiento).
- **Última ubicación conocida del objeto:** La Mina (Zona subterránea de almacenamiento secundario).

---

## 4. Distinción forense: Hechos observados vs. Inferencias

- **Hecho probado (con evidencia en registros):**
  La trazabilidad técnica es inapelable: los logs muestran de forma explícita que CreeperKing (`P007`) retiró la Espada Omega a las 22:15:18, que viajó hasta el Bosque Oscuro para entregársela a ShadowPixel (`P009`) a las 22:17:40, y que este último la guardó en la Mina a las 22:18:15. No hay suposiciones, son registros.

- **Inferencia lógica razonable:**
  Dada la cercanía temporal entre la desconexión del administrador y la entrada de CreeperKing a la cámara, resulta evidente que la caída de la red no fue casualidad o se aprovechó de inmediato mediante comunicación externa entre los implicados. Asimismo, el reparto de papeles —uno roba y otro oculta— confirma una estrategia para ocultar al staff el robo.

- **Limitación técnica del dato:**
  Hay que tener cuidado con las apariencias: aunque compartan la dirección IP pública (`198.51.100.77`), esto por sí solo no demuestra al 100% que estén sentados en el mismo ordenador o sean la misma persona en la vida real pudieron usar wifi compartida o algo asi. Sin embargo, lo que sí les delata y cierra el caso sin margen de duda son los eventos de intercambio dentro del juego (*TRANSFERIR_OBJETO* y *RECIBIR_OBJETO*).

---

## 5. Análisis de eficiencia y Big Data en DynamoDB

1. **Operación de tipo Scan:**
   - **¿Qué consulta de tu investigación fue un `Scan`?**
     Aquellas consultas generales donde filtramos por campos que no forman parte de la clave de partición principal de la tabla, como por ejemplo buscar eventos por la zona o ubicación.
   - **Consulta PartiQL de ejemplo:**
     `SELECT * FROM "EscapeRoomMinecraft"WHERE zona = 'Castillo' OR zona = 'CamaraTesoro'`
   - **¿Por qué el motor ejecutó un Scan y qué impacto tendría este patrón en una tabla con 500 millones de registros?**
     DynamoDB se vio obligado a ejecutar un *Scan* (búsqueda secuencial completa) porque el atributo `zona` no está indexado en la clave primaria. Si estuviéramos en un entorno de producción real con una tabla masiva de 500 millones de registros, esta operación obligaría al motor a leer uno por uno la totalidad de los elementos de la tabla. Esto consumiría una cantidad desorbitada de Unidades de Capacidad de Lectura, disparando los costes de AWS y provocando una latencia insostenible que podría saturar la base de datos.

2. **Operación sobre Global Secondary Index (GSI):**
   - **¿Qué consulta utilizó el índice `PorObjeto`?**
     El rastreo selectivo y continuado para seguirle la pista al ciclo de vida completo de la Espada Omega desde su creación hasta su ocultación.
   - **Consulta PartiQL de ejemplo:**
     `SELECT * FROM "EscapeRoomMinecraft"."PorObjeto" WHERE objeto = 'ESPADA_OMEGA'`
   - **¿Qué ventaja técnica aportó la proyección `ALL` frente a consultar la tabla base?**
     Configurar el índice secundario global con una proyección de tipo `ALL` significa que el GSI almacena de forma redundante una copia exacta de todos los atributos de la tabla base en sus propias particiones. Gracias a esto, cuando lanzamos la consulta filtrando por objeto, el motor resuelve la petición directamente consultando el índice, **evitando por completo la necesidad de hacer mas lecturas** contra la tabla principal. Esto reduce el consumo de recursos y acelera los tiempos de respuesta.