# Actividad 1 – Comprender el problema

### 1. ¿Quién utilizará estos datos?

Los datos serán utilizados principalmente por el **ayuntamiento**, ya que ha probado la red de sensores para controlar la calidad del aire, generar alertas y planificar medidas de movilidad.



### 2. ¿Qué decisiones se pueden tomar con ellos?

Los datos pueden servir para:

- **Generar alertas** cuando se detecten niveles elevados de contaminantes.
- **Planificar medidas de movilidad**.
- Detectar problemas en la calidad del aire.
- Identificar problemas de **cobertura de los sensores**, como ocurre en D6 Parque Natural, que no tiene ningún sensor.
- Detectar problemas de **calidad de los datos**, como mediciones ausentes, valores extremos, duplicados o unidades incorrectas.



### 3. ¿Qué diferencia hay entre una alerta inmediata y un informe histórico?

Una **alerta inmediata** sirve para detectar un problema cuando ocurre y actuar rápidamente. Para este tipo de situación, el procesamiento **Streaming** es adecuado porque procesa los datos cuando llegan y permite generar alertas en **segundos o pocos minutos**.

Un **informe histórico** utiliza los datos acumulados durante un periodo de tiempo para analizarlos posteriormente. El procesamiento **Batch** es muy adecuado para este tipo de informes, ya que procesa los datos por lotes y permite realizar análisis históricos.

# Actividad 2 – Analizar cobertura y calidad

### 1. Identifica dos problemas de calidad y explica sus consecuencias.

- **Datos ausentes:** se han detectado 186 mediciones incompletas, como registros en los que falta el valor de `pm25`. Esto puede dificultar el análisis de la calidad del aire y hacer que los resultados sean incompletos.

- **Valores extremos:** hay 21 registros fuera de rango físico, como valores negativos de PM10. Estos datos no representan una medición válida y pueden alterar los análisis si se utilizan directamente.



### 2. Indica qué distrito necesita mayor atención y justifica tu respuesta.

El distrito que necesita mayor atención es **D6 Parque Natural**, ya que **no tiene ningún sensor**. Esto supone que no se pueden obtener datos de calidad del aire de ese distrito mediante esta red.

Por tanto, sería necesario prestar especial atención a la **cobertura** de esta zona y valorar la instalación de sensores.



### 3. Elige una anomalía y explica si la corregirías, la marcarías como dudosa o la excluirías.

Elegiría la anomalía de las **14 temperaturas registradas en Fahrenheit**.

Las **marcaría como dudosas** hasta comprobarlas, porque los valores pueden ser correctos si realmente fueron registrados en Fahrenheit, pero utilizan una unidad diferente a la esperada.

Después de comprobar la unidad, se podrían convertir a la unidad correcta y conservar los datos si las mediciones son válidas.

# Actividad 3 – Comparar arquitecturas
# 1. Comparar arquitecturas

| Criterio | Batch | Streaming |
|---|---|---|
| Rapidez para generar alertas | Minutos u horas | Segundos o pocos minutos |
| Coste y complejidad | Menores | Mayores |
| Informes históricos | Muy adecuado | Adecuado, con más complejidad |
| Picos de datos | Puede procesarlos por lotes | Procesa los eventos al llegar |

### Alternativa elegida

Para las **alertas** usaría **Streaming**, porque procesa los eventos al llegar y permite generar alertas en segundos o pocos minutos.

Para los **informes históricos** usaría **Batch**, porque es muy adecuado para trabajar con datos históricos y tiene menor coste y complejidad.

# Actividad 4 – Elaborar una recomendación

### 1. El riesgo más urgente

El riesgo más urgente es la **falta de cobertura en D6 Parque Natural**, ya que este distrito **no tiene ningún sensor** y, por tanto, no se reciben datos de calidad del aire de esa zona.

### 2. La actuación que propongo

Propongo **mejorar la cobertura de la red instalando sensores en D6 Parque Natural**.

O tambien poner **normativa** en las zonas donde hay mas trafico concurrido para bajar emisiones , como el caso real de las **"zonas de bajas emisiones"** con pegatinas medioambientales en Madrid.

### 3. Dos razones basadas en el dossier

- D6 tiene **0 sensores**, por lo que actualmente no dispone de mediciones de calidad del aire mediante esta red.
- La red se quiere utilizar para **generar alertas y planificar medidas de movilidad**, por lo que disponer de datos de las diferentes zonas es importante para poder realizar estas funciones.

### 4. Un problema que seguiría pendiente

Seguiría pendiente la **calidad de los datos**, ya que durante la prueba se detectaron problemas como datos ausentes, valores extremos, lecturas congeladas, unidades incorrectas y registros duplicados.

### 5. Una medida de privacidad

Una medida de privacidad sería **proteger las coordenadas precisas de las estaciones móviles**, ya que una secuencia de ubicaciones podría revelar rutas habituales, horarios de actividad o presencia continuada en una zona.

