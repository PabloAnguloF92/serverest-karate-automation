Feature: Actualización de usuarios en ServeRest (PUT /usuarios/{_id})

  Background:
    * url baseUrl
    * def DataGenerator = Java.type('helpers.DataGenerator')

  @positivo
  Scenario: Actualizar los datos de un usuario existente
    * def emailInicial = DataGenerator.getRandomEmail()
    Given path 'usuarios'
    And request { "nome": "Nombre Viejo", "email": "#(emailInicial)", "password": "123", "administrador": "true" }
    When method POST
    Then status 201
    * def userId = response._id

    * def emailNuevo = DataGenerator.getRandomEmail()
    Given path 'usuarios', userId
    And request { "nome": "Nombre Actualizado", "email": "#(emailNuevo)", "password": "456", "administrador": "false" }
    When method PUT
    Then status 200
    And match response == { message: "Registro alterado com sucesso" }

  @negativo
  Scenario: Intentar actualizar usando el correo de otro usuario existente
    * def emailOcupado = DataGenerator.getRandomEmail()
    Given path 'usuarios'
    And request { "nome": "Usuario Uno", "email": "#(emailOcupado)", "password": "123", "administrador": "true" }
    When method POST
    Then status 201

    * def emailDos = DataGenerator.getRandomEmail()
    Given path 'usuarios'
    And request { "nome": "Usuario Dos", "email": "#(emailDos)", "password": "123", "administrador": "true" }
    When method POST
    Then status 201
    * def idUsuarioDos = response._id

    Given path 'usuarios', idUsuarioDos
    And request { "nome": "Usuario Dos", "email": "#(emailOcupado)", "password": "123", "administrador": "true" }
    When method PUT
    Then status 400
    And match response == { message: "Este email já está sendo usado" }
