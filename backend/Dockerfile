# Use the official OpenJDK image with Java 17
FROM gradle:8-jdk17

# Set the working directory in the container
WORKDIR /app

# Copy the Gradle wrapper files
COPY build.gradle .
COPY settings.gradle .

# Copy the source code
COPY src ./src

# Build the project using Gradle
RUN gradle bootJar --scan --warning-mode all

# Expose the port your application listens on
EXPOSE 8080
RUN mv build/libs/backend-*.jar build/libs/app.jar

# Define the command to run your application
CMD ["java", "-Dspring.profiles.active=prod", "-jar", "build/libs/app.jar"]
