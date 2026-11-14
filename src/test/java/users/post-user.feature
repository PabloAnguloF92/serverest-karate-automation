Feature: Registro de usuarios en ServeRest (POST /usuarios)

  Background:
    * url baseUrl
    * path 'usuarios'
    * def DataGenerator = Java.type('helpers.DataGenerator')

  @positivo @smoke
  Scenario: Registrar un nuevo usuario exitosamente
    * def randomEmail = DataGenerator.getRandomEmail()
    * def randomName = DataGenerator.getRandomName()
    And request
      """
      {
        "nome": "#(randomName)",
        "email": "#(randomEmail)",
        "password": "password123",
        "administrador": "true"
      }
      """
    When method POST
    Then status 201
    And match response == { message: "Cadastro realizado com sucesso", _id: "#string" }

  @negativo
  Scenario: No permitir registrar un usuario con correo duplicado
    * def emailDuplicado = DataGenerator.getRandomEmail()
    Given request
      """
      {
        "nome": "Usuario Original",
        "email": "#(emailDuplicado)",
        "password": "password123",
        "administrador": "true"
      }
      """
    When method POST
    Then status 201

    Given path 'usuarios'
    And request
      """
      {
        "nome": "Usuario Duplicado",
        "email": "#(emailDuplicado)",
        "password": "password123",
        "administrador": "true"
      }
      """
    When method POST
    Then status 400
    And match response == { message: "Este email já está sendo usado" }
