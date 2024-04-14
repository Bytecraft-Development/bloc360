# Use the official OpenJDK image with Java 17
FROM gradle:8.7.0-jdk17

# Set the working directory in the container
WORKDIR /app

# Copy the Gradle wrapper files
COPY build.gradle .
COPY settings.gradle .

# Copy the source code
COPY src ./src

# Build the project using Gradle
RUN gradle bootJar

# Expose the port your application listens on
EXPOSE 8080

# Define the command to run your application
CMD ["java", "-jar", "build/libs/backend-0.0.1.jar"]
