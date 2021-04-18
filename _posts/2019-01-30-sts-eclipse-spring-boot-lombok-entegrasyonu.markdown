---
title:  "Peki Lombok'u Nasıl Kullanacağım?"
date:   2019-01-30 20:04:23
categories: [java, spring, spring boot, tools]
tags: [lombok, eclipse, intellij, ide, entegre, data, getter, setter, slf4j, türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://cdn-images-1.medium.com/max/150/1*v_NiWtOaQEt5plnvrPLf_g.jpeg
---

Projelerimde artık olmazsa olmaz haline gelen Lombok’u Spring Tool Suite veya Eclipse’e nasıl entegre edileceğinden bahsedeceğim. Çünkü Lombok kullanılarak yazılmış bir projeyi kendi Lombok entegre edilmemiş bir IDE ile açmaya çalıştığınızda her yer hata kaynıyor olacaktır. Lombok aslında şunu yapar: kodunuz compile edileceği aşamada annotationlar ile işaretlediğiniz yerlere(classlar, değişkenler, metodlar vs) spesifik kod parçaları ekler. Örneğin @Data annotationını gördüğü classın içerisine getter/setter’ları ekler; equals, hashcode metodlarını düzenler. Aslında sizin yazdığınız bir getter setter yoktur, ancak diğer sınıflar o getter setterları kullanabilmeye başlar. Eğer IDEnizin startupına Lombok’u eklemezseniz IDEniz doğal olarak şaşıracak ve hani nerede çağırmaya çalıştığın getter setterlar gibisinden bir endişe ile ortalığı kırmızı uyarılara boğacaktır.

![](https://miro.medium.com/max/1500/1*v_NiWtOaQEt5plnvrPLf_g.jpeg)

{% include feed-ici-imaj-1.html %}

## 1. Lombok IDE Entegrasyonu

Gelelim Eclipse’imize Lombok’u entegre etmeye. [Project Lombok](https://projectlombok.org/download) sayfasına gidip son versiyonu indiriyoruz. Dosyamızı indirdiğimiz dizinde `java -jar lombok.jar` komutunu çalıştırarak Lombok arayüzünü açıyoruz. Açılan pencerede `Specify Location` butonunu tıklayarak Eclipse’imizin bulunduğu dizini(exe dosyasının bulunduğu yer) göstererek IDE’s alanında Eclipse’imizin görünmesini sağlıyoruz. Sonrasında `Install/Update` butonu ile işlemimizi tamamlıyoruz.

Bu işlemler sonrasında Eclipse’i baştan başlatmanız ve gerekirse projelerinizi rebuild etmeniz gerekli. Sonrasında ver elini coding!

## 2. Sonuç

[Buradan](https://projectlombok.org/) Lombok anasayfasına gidip neler yapabileceğinizi inceleyebilirsiniz. Yetenekleri stabil ve deneysel olarak ikiye ayrılıyor, deneysel olanları kullanmak sizin tercihinize kalmış. Sınıfların oluşan bytecode’larını decompile ederek Lombok’un aslında neler yaptığını da inceleyebilirsiniz. Nasıl decompile edeceğim diyorsanız başarılı bir decompiler da [burada](http://jd.benow.ca/).
