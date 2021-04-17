---
title:  "Spring Boot Projesini Maven ile Dockerize Etmek"
date:   2019-01-27 20:04:23
categories: [java, spring, spring boot, docker, microservices, maven]
tags: [Spring Boot, Maven, Docker, Plugin,Dockerize, Container, Image, CD, CI, Spotify, türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://cdn-images-1.medium.com/max/150/1*nxoL5MIJYyvW60mkAPZpLw.jpeg
---

Bu yazımızda [**Spotify Maven Plugin**](https://github.com/spotify/docker-maven-plugin)’ini kullanarak Spring Boot projemizden Docker imajımızı yaratacağız.

![Dockerize with Maven](https://miro.medium.com/max/2066/1*nxoL5MIJYyvW60mkAPZpLw.jpeg)

## 1. Yapılandırma

Projemizin pom.xml dosyasındaki build konfigürasyonuna pluginimizi ekliyoruz.

<script src="https://gist.github.com/mehmetcemyucel/4129b2e50bdd8dc7620a0abf5c193935.js"></script>

Yapılandırma sonrası proje dizinimizde maven’a `mvn clean package docker:build` komutları vererek bizim için imajımızı oluşturmasını sağlıyoruz. Eğer Windows 10 kullanıyorsanız  aşağıdakine benzer bir hata ile karşılaşabilirsiniz.

	[ERROR] Failed to execute goal com.spotify:docker-maven-plugin:0.4.5:build (default-cli) on project mcy-sb-dockerize-with-maven: Exception caught: java.util.concurrent.ExecutionException: com.spotify.docker.client.shaded.javax.ws.rs.ProcessingException: org.apache.http.conn.HttpHostConnectException: **Connect to localhost:2375** [localhost/127.0.0.1, localhost/0:0:0:0:0:0:0:1] failed: **Connection refused**: connect -> [Help 1]

Bunun sebebi Docker Deamon’ın default ayarlarında güvenlik sebebiyle 2375 nolu portuna erişimi TLS enabled olarak sağlamasıdır. Bunu aşmak için Docker’ın yapılandırmalarına girip `General>>Expose daemon on tcp://localhost:2375 without TLS` kutucuğunu seçili hale getirebilirsiniz.

Bu işlemleri tamamladıktan sonra base imaj olarak seçtiğimiz `java` imajının layerları bilgisayarımızda yoksa indirecek ve imajımız oluşacaktır. Dilerseniz `pom.xml` deki plugin’in configuration kısmında daha fazla detaylar ile özelleştirme yapabilirsiniz veya projenizin root dizininde konumlandıracağınız Dockerfile aracılığıyla build’in alınmasını sağlayabilirsiniz.

## 2. Sonuç

Bu işlem sonrasında `docker images` komutu ile imajınızın yaratıldığını görebilirsiniz.

	REPOSITORY                  TAG    IMAGE ID     CREATED        SIZE  
	mcy-sb-dockerize-with-maven latest 10c6c96315ff 2 seconds ago 143MB
