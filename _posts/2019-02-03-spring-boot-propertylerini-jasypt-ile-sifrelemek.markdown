---
title:  "Spring Boot Property’lerini Jasypt ile Şifrelemek"
date:   2019-02-03 20:04:23
categories: [java, spring, spring boot, security, tools]
tags: [Spring Boot, Encryption, Decryption, Şifreleme, Mehmet Cem Yücel, Mehmet, Cem, Yücel, Yucel, Jasypt, Nasıl Yapılır, application.properties, application.yml]
---
Bir Spring Boot projemiz var. Projemize ait application.properties dosyasının içerisinde veritabanına bağlanırken kullandığımız kullanıcı adı/şifre gibi hassas bir veri var. Bu verinin açık olarak dosyada durması bir problem, güvenlik açığı teşkil ediyor. Bugünkü yazımız böyle hassas bilgilerin encrypted bir şekilde saklanabilmesi için  [Jasypt](http://www.jasypt.org/) kütüphanesi ile Spring Boot properties’i birlikte nasıl kullanabileceğimiz hakkında olacak.

Jasypt, “Java Simplified Encrpytion” projesi aslında başlangıcı çok çok eski tarihlere dayanan bir proje. Henüz Acegi dünyası Spring Security altında birleşmeden öncesinde Jasypt’in Acegi ile uyumlu çalışan versiyonları mevcuttu. 2014ten bu yana temel fonksiyon setinde bir değişikliği olmamasına rağmen farklı popüler teknolojilerle entegre çalışabilmesi için geliştirilen farklı projeler de mevcut. Biz bugün  [Jasypt-Spring-Boot](https://github.com/ulisesbocchio/jasypt-spring-boot)  projesini kullanarak örneklerimizi gerçekleştireceğiz.

Yazının devamı için [**tıklayınız**](https://medium.com/mehmetcemyucel/spring-boot-propertylerini-jasypt-ile-sifrelemek-73715242d4cd)

![](https://cdn-images-1.medium.com/max/800/1*9oEKN6s0vnoxVTmjuFgymw.png)
