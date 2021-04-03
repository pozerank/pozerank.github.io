---
title:  "MapStruct ile SpringBoot Obje Dönüşümü"
date:   2019-07-16 15:04:23
categories: [java, test, spring, spring boot, maven]
tags: [Spring, MapStruct, Mapper, ObjectMapper, Boot, Nasıl yapılır, nedir, Örnek, Nasıl, Mehmet Cem Yücel, Mehmet, Cem, Yücel, Yucel]
image: https://miro.medium.com/max/150/1*9DhTKcVmIApp1AXoGZ4A4A.png
---




![](https://miro.medium.com/max/6250/1*9DhTKcVmIApp1AXoGZ4A4A.png)
[](http://luman.io/meaning-not-mechanics%E2%80%8A-%E2%80%8Aa-human-approach-organizational-transformation/)

# 1. Giriş

Bu yazımızda [**MapStruct**](http://mapstruct.org/)  isimli `Java Bean Mapper` kütüphanesini ve [**Spring**](https://spring.io/)  ile kullanımını inceleyeceğiz.

Kodlama yaparken ihtiyaç duyduğumuz bilgileri nesnelerimizin içerisindeki alanlarda tutarız. Nesneye dayalı programlama paradigmasına göre yaptığımız tüm tasarımlar dış dünya ile iletişim noktasına geldiğimizde birebir örtüşmeyebilir. Devraldığınız bir projede tasarladığınız bir [**POJO**](https://en.wikipedia.org/wiki/Plain_old_Java_object)(Plain Old Java Object), veritabanındaki varlık modeliyle(`**ER**``: Entity Relationship Model`) örtüşmeyebileceği gibi dış servislerden aldığınız DTO (Data Transfer Object) nesneler de sizin iç tasarımınızla birebir örtüşmeyecektir. Bu gibi durumlarda birden fazla obje katmanları (`entity`, `DTO`, `vb`..) yaratarak kendi kodumuzu dış dünyanın etkilerinden korumaya çalışırız. Ancak her ihtiyaç duyduğumuzda bu nesneleri birbirlerine dönüştürmek geliştirme maliyeti açısından zaman çalan bir işlemdir.

**MapStruct** bu ihtiyacımızı derleme zamanında kolayca karşılayan ve bizim için mapper sınıfları yaratan bir kütüphane. Arayüzler aracılığıyla  kaynak ve hedef `**POJO**`  sınıflarının nasıl eşitleneceğini tasarlayabilirsiniz. Başka bir yöntem olarak sadece annotationlar kullanarak `**Spring**`  ile bu işi nasıl inceleyeceğimizi aşağıda inceleyeceğiz.

# 2. Bağımlılıklar

Maven için `pom.xml` dosyasına aşağıdaki bağımlılığı ve yapılandırmayı ekliyoruz.

<script src="https://gist.github.com/mehmetcemyucel/fd06abdfce325c53f8f67b42d5d091ad.js"></script>

Bağımlılıkların yanı sıra eklememiz gereken bir yapılandırma daha var. MapStruct derleme zamanında çalışan bir araç. Biz bu yazımızda `Spring Boot` ile `annotation`’lar aracılığı ile bu toolu nasıl kullanabileceğimizi inceliyoruz. Bu sebeple Spring Boot Maven Plugin’inin annotation processor’lerine MapStruct’ın processor’unu eklememiz lazım. Bu sayede Spring Boot Maven Plugin’i derleme esnasında MapStruct Interface’leri tarayıp birazdan yapacağımız yapılandırmaların yönlendirmesinde yeni sınıflar oluşturulmasını sağlayacak.

<script src="https://gist.github.com/mehmetcemyucel/f0e3debe8fd7758e2261b3707ce9f68a.js"></script>

# 3. Klonlayıcı

## 3.1 POJO Sınıfı

İçerisinde primitive ve complex tiplerin olduğu basit bir sınıf oluşturalım.

<script src="https://gist.github.com/mehmetcemyucel/325df415b195db7201e99dcd70d480ab.js"></script>

## 3.2 Cloner Arayüzü

<script src="https://gist.github.com/mehmetcemyucel/d48c9aec663df163b2fc0ca5c1eadeb0.js"></script>

`clone` isimli metod ile girdisi ve çıktısı aynı olan bir interface ile bir nesnenin yeni hash ile klonunu yaratmanız MapStruct ile oldukça kolay.

"***ÖNEMLİ NOT:** MapStruct arayüzlerinde tanımladığınız mapperların sınıflarının bytecode’larının oluşması için `maven clean install` komutunu çalıştırabilirsiniz. Aksi taktirde Spring byte kodu runtime da bulamayacak `ClassNotFoundException: Cannot find implementation for …..Mapper` gibi bir hata verecektir.*"

## 3.3 Test Senaryosu

Bir nesne örneği yaratıp mapper’a klonlattığımızda aynı değerlere sahip yeni bir nesne dönecektir.

<script src="https://gist.github.com/mehmetcemyucel/9bc8c5cf9c5565769bed3c16ca06661b.js"></script>

# 4. Kalıtıcı

Herhangi bir kalıtım hiyerarşisinde olmasa dahi aynı isimli alanlara ve getter/setterlara sahip iki sınıf arasında kolay bir dönüşüm yapılabilir.

## 4.1 POJO Sınıfları

Kaynak sınıf olarak `InheritDTO` , hedef sınıf olarak `InheritObject` sınıflarını ele alalım.

<script src="https://gist.github.com/mehmetcemyucel/190391ea35c0ce091b6c56c8ea06de79.js"></script>

<script src="https://gist.github.com/mehmetcemyucel/f444985b48c6add585c1791f220bfbd3.js"></script>

## 4.2 Inherit Arayüzü

<script src="https://gist.github.com/mehmetcemyucel/56ba92b030a1bec9de65201d650328b1.js"></script>

Farkındaysanız hedef sınıfımızda kaynak sınıfımızda bulunmayan alanlar mevcut. Bu durumda `@InheritInverseConfiguration` annotationı ile işaretlediğimiz metod imzasına ait kodlar aynı getter setter’lar ile eşleyebildiği kadar veriyi eşitleyip geri kalanları için default değerlerinde bırakacaklardır. Veya dilerseniz alanlar için default değerleri siz de verebilirsiniz.

## 4.3 Test Senaryosu

Aşağıdaki testleri çalıştırarak senaryomuzun çalıştığını gözlemleyebiliriz.

<script src="https://gist.github.com/mehmetcemyucel/afe34f23c9e7b2a921315438e5979ec6.js"></script>

# 5. Alan Alan Eşitleyici

Aynı veri tipindeki farklı field isimlerine sahip sınıfları eşitlemek de mümkündür. Bunun için aşağıdaki sınıfları oluşturalım.

## 5.1 POJO Sınıfları

<script src="https://gist.github.com/mehmetcemyucel/641e69793359e731a62662599ba421ee.js"></script>

<script src="https://gist.github.com/mehmetcemyucel/ec127f2b062e51ebfc0576e49b7828e2.js"></script>

Değişken isimlerimiz farklı ancak alan tiplerimiz aynı ise aşağıdaki gibi bir mapper düzenlememiz gereklidir.

## 5.2 TypeSafe Arayüzü

<script src="https://gist.github.com/mehmetcemyucel/2534c4ec908a3445bbc3d0ae9a6111a7.js"></script>

@Mappings annotation’ı ile tek tek hangi alanın hedef sınıftaki hangi alana eşitlenmesini istediğimizi belirtiyoruz.

## 5.3 Test Senaryosu

<script src="https://gist.github.com/mehmetcemyucel/0e50cd8367fb5fe2a2881686ccdc58c7.js"></script>

# 6. Tip Dönüştürücü

Sadece aynı tipte olması gerekmeksizin farklı değerlere ve isimlere sahip sınıfları da birbirlerine dönüştürmemiz mümkündür.

## 6.1 POJO Sınıfları

<script src="https://gist.github.com/mehmetcemyucel/cd14bf48628bf990c07dfe1859ef9b56.js"></script>

<script src="https://gist.github.com/mehmetcemyucel/c9a20b0db9137fa3deca41dcc8e845ed.js"></script>

## 6.2 Mapper Arayüzü

<script src="https://gist.github.com/mehmetcemyucel/3087141799768a797370a7106d72d1d8.js"></script>

Yukarıdaki mapperdaki gibi formatını verdiğimiz bir Instant, Date gibi tarih tiplerinin dönüşümünü sağlamamız mümkün.

## 6.3 Test Senaryosu

<script src="https://gist.github.com/mehmetcemyucel/4dc6c8c3f63995d6d305981de8abf99f.js"></script>

# 7. Sonuç

Giriş niteliğindeki bu yazının haricinde MapStruct’ın farklı birçok mappingi yapabildiğini hatırlatmakta fayda var. `Expression`_’_lar ile mappingler yapabileceğiniz gibi `has a` ilişkisine sahip sınıflarda da mappinler yapabilirsiniz. Veya `Abstract` sınıflar ile tamamen `manuel mapping`ler de yapabilirsiniz.

MapStruct bütün bu özelliklerin dışında `Lombok` ,`Kotlin`, `Gradle`, `JPA` gibi farklı teknolojiler ve araçlara da destek sağlıyor. Ayrıca `Eclipse` ve `IntelliJ` gibi popüler `IDE` ‘lere de uyumlu şekilde çalışabiliyor. [Github](https://github.com/mapstruct/mapstruct) sayfasında farklı örnekleri de inceleyebilirsiniz.

Java diğer mapper toollarıyla kıyaslandığında MapStruct performansıyla denemeye başlamak için çok şey vaadediyor. Bu kıyaslamalarla ilgili örnek bir yazıya [buradan](https://www.baeldung.com/java-performance-mapping-frameworks) ulaşabilirsiniz.

Projenin kodlarına [buradan](https://github.com/mehmetcemyucel/mapstruct) erişebilirsiniz. Sonraki yazılarda görüşmek üzere.

*En yalın haliyle*

**Mehmet Cem Yücel**

---

**_Bu yazılar ilgilinizi çekebilir:_**

 - [_Bir Yazılımcının Bilmesi Gereken 15  Madde_](https://www.mehmetcemyucel.com/2019/bir-yazilimcinin-bilmesi-gereken-15-madde/)
 - [_Spring Boot Devtools ile Docker Üzerindeki Kodu Debug Etme ve  Değiştirme_](https://www.mehmetcemyucel.com/2019/spring-boot-devtools-ile-docker-uzerindeki-kodu-debug-etme-ve-degistirme/)
 - [_Spring Boot Property’lerini Jasypt ile
   Şifrelemek_](https://www.mehmetcemyucel.com/2019/spring-boot-propertylerini-jasypt-ile-sifrelemek/)

**_Blockchain teknolojisi ile ilgileniyor iseniz bunlar da hoşunuza gidebilir:_**

 - [_BlockchainTurk.net  yazıları_](https://www.mehmetcemyucel.com/categories/#blockchain)


