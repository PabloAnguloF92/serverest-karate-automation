Feature: Eliminación de usuarios en ServeRest (DELETE /usuarios/{_id})

  Background:
    * url baseUrl
    * def DataGenerator = Java.type('helpers.DataGenerator')

  @positivo
  Scenario: Eliminar un usuario existente por su ID
    * def emailBorrar = DataGenerator.getRandomEmail()
    Given path 'usuarios'
    And request { "nome": "Usuario Borrar", "email": "#(emailBorrar)", "password": "123", "administrador": "true" }
    When method POST
    Then status 201
    * def userId = response._id

    Given path 'usuarios', userId
    When method DELETE
    Then status 200
    And match response == { message: "Registro excluído com sucesso" }

  @negativo
  Scenario: Intentar eliminar un usuario con ID inexistente
    Given path 'usuarios', 'idNoExiste99999'
    When method DELETE
    Then status 200
    And match response == { message: "Nenhum registro excluído" }
