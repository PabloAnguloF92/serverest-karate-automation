# Informe de Estrategia de Automatización y Patrones Utilizados

## 1. Estrategia General de Automatización
La suite de pruebas automatizadas para la API de Usuarios de **ServeRest** (`/usuarios`) se diseñó bajo un enfoque de **pruebas funcionales de extremo a extremo (CRUD) y validación de contratos**, priorizando la estabilidad, la velocidad de ejecución y la repetibilidad en cualquier entorno.

La estrategia cubre tanto **flujos positivos** (verificación de códigos HTTP `200` y `201` y persistencia de datos) como **escenarios negativos** (manejo controlado de errores HTTP `400` ante correos duplicados o identificadores inexistentes).

## 2. Patrones de Diseño y Buenas Prácticas Aplicadas

* **Patrón de Aislamiento e Independencia de Datos (*Test Data Independence*):**
  Cada escenario crea sus propios datos de prueba antes de operar sobre ellos y evita depender de registros previos en la base de datos. Para ello se implementó la clase utilitaria `DataGenerator.java` apoyada en **Datafaker** y marcas de tiempo (`System.currentTimeMillis()`), garantizando correos electrónicos únicos y eliminando falsos positivos por colisión de datos.

* **Validación de Contratos (*JSON Schema Validation*):**
  Se separó la definición de la estructura esperada en un archivo de esquema externo (`user-schema.json`). Mediante las aserciones nativas de Karate (`match response == userSchema` y `match each`), se valida de forma estricta la presencia de campos obligatorios y sus tipos de datos (`#string`, `#number`).

* **Configuración Centralizada (*Environment Configuration Pattern*):**
  El archivo `karate-config.js` abstrae la URL base (`https://serverest.dev`) y los tiempos de espera (`connectTimeout` y `readTimeout`). Esto evita valores quemados (*hardcoding*) en los escenarios y facilita escalar la suite a otros ambientes (QA, Staging o Producción) sin modificar las pruebas.

* **Separación de Responsabilidades y Modularidad (*Separation of Concerns*):**
  Los escenarios están organizados por verbo y operación HTTP (`post-user.feature`, `get-users.feature`, `put-user.feature`, `delete-user.feature`), utilizando bloques `Background` para reutilizar precondiciones comunes y mantener archivos `.feature` limpios y legibles bajo sintaxis Gherkin.

* **Ejecución Selectiva mediante Etiquetas (*Test Tagging*):**
  Los escenarios incorporan etiquetas (`@positivo`, `@negativo`, `@smoke`) orquestadas por un ejecutor único en JUnit 5 (`UsersTest.java`), permitiendo ejecutar pruebas de humo rápidas o regresiones completas desde Maven (`mvn test`).
