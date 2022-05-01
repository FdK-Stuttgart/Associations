FROM openjdk:8-alpine

COPY target/uberjar/cmap.jar /cmap/app.jar

EXPOSE 3000

CMD ["java", "-jar", "/cmap/app.jar"]
