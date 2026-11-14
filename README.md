# Automatización de Pruebas API - ServeRest (Karate DSL)

Proyecto de automatización de pruebas funcionales y de contrato sobre los endpoints de gestión de usuarios (`/usuarios`) de la API **ServeRest**, desarrollado con **Karate DSL**, **JUnit 5** y **Maven**.

## Tecnologías utilizadas
* **Java 17**
* **Maven 3.8+**
* **Karate DSL 1.5.1**
* **Datafaker 2.1.0** (generación dinámica de datos de prueba)

## Estructura del proyecto
```text
src/test/java/
├── karate-config.js               # Configuración global de entorno y URL base
├── helpers/
│   └── DataGenerator.java         # Utilidad para generar nombres y correos únicos
└── users/
    ├── UsersTest.java             # Ejecutor principal de la suite (JUnit 5)
    ├── schemas/
    │   └── user-schema.json       # Esquema JSON para validación de contratos
    ├── post-user.feature          # Pruebas POST /usuarios (positivo y negativo)
    ├── get-users.feature          # Pruebas GET /usuarios y GET /usuarios/{_id}
    ├── put-user.feature           # Pruebas PUT /usuarios/{_id}
    └── delete-user.feature        # Pruebas DELETE /usuarios/{_id}
```

## Estrategia y buenas prácticas aplicadas
* **Independencia y aislamiento de datos:** Cada escenario genera sus propios datos dinámicos mediante `DataGenerator` para evitar colisiones por correos duplicados y garantizar ejecuciones repetibles sin depender del estado previo de la base de datos.
* **Validación de contratos (JSON Schema):** Se valida la estructura, claves obligatorias y tipos de datos de las respuestas usando `user-schema.json` y el operador `match`.
* **Cobertura positiva y negativa:** Se validan tanto los flujos exitosos (`200`, `201`) como los manejos de error esperados (`400` por correo duplicado o ID inexistente de 16 caracteres).
* **Organización modular:** Separación de responsabilidades por verbo HTTP (`GET`, `POST`, `PUT`, `DELETE`) y uso de etiquetas (`@positivo`, `@negativo`, `@smoke`) para ejecuciones selectivas.

## Instrucciones de ejecución
1. Clonar el repositorio:
   ```bash
   git clone <URL_DE_TU_REPOSITORIO>
   ```
2. Ejecutar toda la suite de pruebas desde la raíz del proyecto:
   ```bash
   mvn test
   ```
3. Ejecutar pruebas filtrando por etiqueta:
   ```bash
   mvn test -Dkarate.options="--tags @positivo"
   ```

## Reportes
Tras finalizar la ejecución, Karate genera automáticamente el reporte HTML detallado en:
`target/karate-reports/karate-summary.html`
