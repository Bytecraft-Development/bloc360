plugins {
    id("java")
}

group = "org.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(platform("org.junit:junit-bom:5.10.0"))
    testImplementation("org.junit.jupiter:junit-jupiter")
    // https://mvnrepository.com/artifact/org.seleniumhq.selenium/selenium-java
    implementation("org.seleniumhq.selenium:selenium-java:4.19.1")
    // https://mvnrepository.com/artifact/org.springframework/spring-beans
    implementation("org.springframework:spring-beans:6.1.6")

}

tasks.test {
    useJUnitPlatform()
}