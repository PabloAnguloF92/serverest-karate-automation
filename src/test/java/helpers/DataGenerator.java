package helpers;

import net.datafaker.Faker;

public class DataGenerator {

    public static String getRandomEmail() {
        Faker faker = new Faker();
        return faker.name().firstName().toLowerCase() + System.currentTimeMillis() + "@qa.com";
    }

    public static String getRandomName() {
        return new Faker().name().fullName();
    }
}

