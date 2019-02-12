---
title:  "Spring Boot Devtools ile Docker Üzerindeki Kodu Debug Etme ve Değiştirme"
date:   2019-01-27 15:04:23
categories: [java, spring, spring boot, docker, maven, microservices]
tags: [Spring Boot, Spring, Devtools, Docker, Debug, Debugging, Mehmet, Cem, Yücel, Mehmet Cem Yücel, Yucel, Twelve Factor, Microservices, Mikroservis, Nasıl, yapılır, reload ]
---

Şu cümleyi mutlaka duymuşuzdur ya da bizzat söylemişizdir; “Ama benim makinemde çalışıyordu!”. Kodumuz kendi makinemizde çalışırken test ortamına gittiğinde çalışmamasının sebebi acaba neydi? Cevap: Kod aynıydı, ama ya gerisi?

Kodun aynı çalışabilmesi için aynı işletim sistemine, bunun doğru yapılandırılmasına (dil ve tarih ayarları, …), üzerinde gerekli kurulumların doğru versiyonlarla kurulmasına(JRE, DB, Queue, vb), bunların aynı patch’lerle upgrade edilmesine, uygulamasal parametrelerin aynı olmasına… Farkındaysanız listemiz uzayıp gidiyor. Ee peki bunca şeyi hem kendi makinemizde hem de test ortamlarında nasıl aynı yapabiliriz ki?

Cevap mikroservis mimarinin olmazsa olmazları olarak tanımlanan  [12 Factor](https://12factor.net/) başlıklarında yer alıyor. Backing Services ve Dev/Prod Parity başlıkları ortamların tekilleştirilmesi için nelere dikkat edilmesi gerektiğini anlatıyor,...

Yazının devamı için [tıklayınız](https://medium.com/mehmetcemyucel/spring-boot-devtools-ile-docker-uzerindeki-kodu-debug-etme-ve-degistirme-a5f1c52ad6b5)


![](https://cdn-images-1.medium.com/max/300/1*nf9ajj-L2uZ2ztybaLHMWA.jpeg)