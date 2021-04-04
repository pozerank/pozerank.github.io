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


***En yalın haliyle***

[**Mehmet Cem Yücel**](https://www.mehmetcemyucel.com)

---

**_Bu yazılar ilgilinizi çekebilir:_**

 - [Spring Boot Devtools ile Docker Üzerindeki Kodu Debug Etme ve Değiştirme](https://www.mehmetcemyucel.com/2019/spring-boot-devtools-ile-docker-uzerindeki-kodu-debug-etme-ve-degistirme/)
 - [Spring Boot ile SLF4J ve Log4J Loglama Altyapısı](https://www.mehmetcemyucel.com/2019/spring-boot-ile-loglama-altyapisi/)
 - [Twelve Factor Nedir Türkçe ve Java Örnekleri](https://www.mehmetcemyucel.com/2019/twelve-factor-nedir-turkce-ornek/)

**_Blockchain teknolojisi ile ilgileniyor iseniz bunlar da hoşunuza gidebilir:_**

 - [BlockchainTurk.net yazıları](https://www.mehmetcemyucel.com/categories/#blockchain)

---