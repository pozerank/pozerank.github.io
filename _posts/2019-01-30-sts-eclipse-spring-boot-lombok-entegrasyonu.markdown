---
title:  "Peki Lombok'u Nasıl Kullanacağım?"
date:   2019-01-30 20:04:23
categories: [java, spring, spring boot, cloud, tools]
tags: [Lombok, nedir, örnek, Eclipse, IntelliJ, Nasıl Yapılır, IDE, entegre, mehmet cem yücel, mehmet, cem, yücel, yucel, Data, Getter, Setter, Slf4j, Project lombok]
---

Projelerimde artık olmazsa olmaz haline gelen <a style="font-weight:bold" href="https://projectlombok.org/?utm_source=mehmetcemyucel.com&utm_medium=refferal&utm_campaign=blog" target="_blank">Lombok</a>’u <a style="font-weight:bold" href="https://spring.io/tools?utm_source=mehmetcemyucel.com&utm_medium=refferal&utm_campaign=blog" target="_blank">Spring Tool Suite</a> veya <a style="font-weight:bold" href="https://www.eclipse.org/downloads/?utm_source=mehmetcemyucel.com&utm_medium=refferal&utm_campaign=blog" target="_blank">Eclipse</a>’e nasıl entegre edileceğinden bahsedeceğim. Çünkü Lombok kullanılarak yazılmış bir projeyi kendi Lombok entegre edilmemiş bir IDE ile açmaya çalıştığınızda her yer hata kaynıyor olacaktır. Lombok aslında şunu yapar: kodunuz compile edileceği aşamada annotationlar ile işaretlediğiniz yerlere(classlar, değişkenler, metodlar vs) spesifik kod parçaları ekler. Örneğin @Data annotationını gördüğü classın içerisine getter/setter’ları ekler; equals, hashcode metodlarını düzenler. Aslında sizin yazdığınız bir getter setter yoktur, ancak diğer sınıflar o getter setterları kullanabilmeye başlar. Eğer IDEnizin startupına Lombok’u eklemezseniz IDEniz doğal olarak şaşıracak ve...

Yazının devamı için 
<a style="font-weight:bold" href="https://medium.com/mehmetcemyucel/6cdf18a8ee2d?utm_source=mehmetcemyucel.com&utm_medium=refferal&utm_campaign=blog" target="_blank">tıklayın...</a>

![](https://cdn-images-1.medium.com/max/800/1*v_NiWtOaQEt5plnvrPLf_g.jpeg)
