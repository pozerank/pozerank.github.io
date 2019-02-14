---
title:  "Spring Boot Property’lerini Jasypt ile Şifrelemek"
date:   2019-02-03 20:04:23
categories: [java, spring, spring boot, security, tools]
tags: [Spring Boot, jasypt, acegi, encoding, decoding, Encryption, Decryption, Şifreleme, nedir, example, Mehmet Cem Yücel, Mehmet, Cem, Yücel, Yucel, Nasıl Yapılır, application.properties, application.yml, spring]
image: https://cdn-images-1.medium.com/max/150/1*9oEKN6s0vnoxVTmjuFgymw.png 
---
Bir Spring Boot projemiz var. Projemize ait application.properties dosyasının içerisinde veritabanına bağlanırken kullandığımız kullanıcı adı/şifre gibi hassas bir veri var. Bu verinin açık olarak dosyada durması bir problem, güvenlik açığı teşkil ediyor. Bugünkü yazımız böyle hassas bilgilerin encrypted bir şekilde saklanabilmesi için <a style="font-weight:bold" href="http://www.jasypt.org/?utm_source=mehmetcemyucel.com&utm_medium=refferal&utm_campaign=blog" target="_blank">Jasypt</a> kütüphanesi ile Spring Boot properties’i birlikte nasıl kullanabileceğimiz hakkında olacak.

Jasypt, “Java Simplified Encrpytion” projesi aslında başlangıcı çok çok eski tarihlere dayanan bir proje. Henüz Acegi dünyası Spring Security altında birleşmeden öncesinde Jasypt’in Acegi ile uyumlu çalışan versiyonları mevcuttu. 2014ten bu yana temel fonksiyon setinde bir değişikliği olmamasına rağmen farklı popüler teknolojilerle entegre çalışabilmesi için geliştirilen farklı projeler de mevcut. Biz bugün <a style="font-weight:bold" href="https://github.com/ulisesbocchio/jasypt-spring-boot?utm_source=mehmetcemyucel.com&utm_medium=refferal&utm_campaign=blog" target="_blank">Jasypt-Spring-Boot</a> projesini kullanarak örneklerimizi gerçekleştireceğiz.

Yazının devamı için 
<a style="font-weight:bold" href="https://medium.com/mehmetcemyucel/73715242d4cd?utm_source=mehmetcemyucel.com&utm_medium=refferal&utm_campaign=blog" target="_blank">tıklayın...</a>
![](https://cdn-images-1.medium.com/max/800/1*9oEKN6s0vnoxVTmjuFgymw.png)
