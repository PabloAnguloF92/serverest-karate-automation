Feature: Consulta de usuarios en ServeRest (GET /usuarios)

  Background:
    * url baseUrl
    * def userSchema = read('classpath:users/schemas/user-schema.json')
    * def DataGenerator = Java.type('helpers.DataGenerator')

  @positivo
  Scenario: Listar todos los usuarios y validar esquema
    Given path 'usuarios'
    When method GET
    Then status 200
    And match response.quantidade == '#number'
    And match each response.usuarios == userSchema

  @positivo
  Scenario: Buscar un usuario existente por su ID
    * def emailUnico = DataGenerator.getRandomEmail()
    Given path 'usuarios'
    And request { "nome": "Usuario Consulta", "email": "#(emailUnico)", "password": "123", "administrador": "true" }
    When method POST
    Then status 201
    * def userId = response._id

    Given path 'usuarios', userId
    When method GET
    Then status 200
    And match response == userSchema
    And match response._id == userId

  @negativo
  Scenario: Buscar un usuario con ID inexistente
    Given path 'usuarios', '0000000000000000'
    When method GET
    Then status 400
    And match response == { message: "Usuário não encontrado" }
