---
title:  "Peki Lombok'u Nasıl Kullanacağım?"
date:   2019-01-30 20:04:23
categories: [java, spring, spring boot, cloud, tools]
tags: [STS, Eclipse, IntelliJ, Lombok, Nasıl Yapılır, IDE, entegre, mehmet cem yücel, mehmet, cem, yücel, yucel, install, Data, Getter, Setter, Slf4j, Project lombok]
---


Projelerimde artık olmazsa olmaz haline gelen Lombok’u Spring Tool Suite veya Eclipse’e nasıl entegre edileceğinden bahsedeceğim. Çünkü Lombok kullanılarak yazılmış bir projeyi kendi Lombok entegre edilmemiş bir IDE ile açmaya çalıştığınızda her yer hata kaynıyor olacaktır. Lombok aslında şunu yapar: kodunuz compile edileceği aşamada annotationlar ile işaretlediğiniz yerlere(classlar, değişkenler, metodlar vs) spesifik kod parçaları ekler. Örneğin @Data annotationını gördüğü classın içerisine getter/setter’ları ekler; equals, hashcode metodlarını düzenler. Aslında sizin yazdığınız bir getter setter yoktur, ancak diğer sınıflar o getter setterları kullanabilmeye başlar. Eğer IDEnizin startupına Lombok’u eklemezseniz IDEniz doğal olarak şaşıracak ve hani nerede çağırmaya çalıştığın getter setterlar gibisinden bir endişe ile ortalığı kırmızı uyarılara boğacaktır.

Yazının devamı için [**tıklayınız**](https://medium.com/mehmetcemyucel/sts-eclipse-spring-boot-lombok-entegrasyonu-6cdf18a8ee2d)


![](https://cdn-images-1.medium.com/max/400/1*v_NiWtOaQEt5plnvrPLf_g.jpeg)
