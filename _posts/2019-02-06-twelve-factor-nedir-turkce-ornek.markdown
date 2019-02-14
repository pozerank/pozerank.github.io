---
title:  "12 Factor Nedir Türkçe ve Java Örnekleri"
date:   2019-02-06 20:04:23
categories: [java, microservices, cloud, mimari]
tags: [Twelve, Factor, Cloud, Microservice, Mikroservis, Nedir, Türkçe, Örnek, example, Java, Nasıl, Codebase, 12 Faktör, Mehmet Cem Yücel, Mehmet, Cem, Yücel, Yucel, maven]
image: https://cdn-images-1.medium.com/max/150/1*A0OnarMzmEUJWQeHTHCgig.png
---

12 Factor, ölçeklenebilir cloud uygulamaları geliştirebilmek için bir uygulamada olması önerilen 12 maddeyi tanımlayan bir manifestodur. <a style="font-weight:bold" href="https://www.heroku.com?utm_source=mehmetcemyucel.com&utm_medium=refferal&utm_campaign=blog" target="_blank">Heroku</a>’nun kurucularından Adam Wiggins tarafından 2012 yılında ortaya atılmıştır. Orjinal metinlere <a style="font-weight:bold" href="https://12factor.net?utm_source=mehmetcemyucel.com&utm_medium=refferal&utm_campaign=blog" target="_blank">12factor.net</a> ve <a style="font-weight:bold" href="https://12factor.net/tr/?utm_source=mehmetcemyucel.com&utm_medium=refferal&utm_campaign=blog" target="_blank">buradan(Türkçe)</a> adreslerinden erişilebilir. Bugün aşağıdaki 12 Factor manifestosunu detaylı bir şekilde irdelemeye çalışacağız.


1.  **Codebase**  (Kod Tabanı)
2.  **Dependencies**  (Bağımlılıklar)
3.  **Config**  (Yapılandırma)
4.  **Backing Services**  (Destek Servisleri)
5.  **Build, Release, Run**  (Derleme, Sürüm, Çalıştırma)
6.  **Processes**  (Süreçler)
7.  **Port Binding**  (Port Bağlama)
8.  **Concurrency**  (Eş Zamanlılık)
9.  **Disposability**  (Kullanıma Hazır Olma Durumu)
10.  **Dev/Prod Parity** (Geliştirme/Üretim Ortamlarının Eşitliği)
11.  **Logs**  (Günlükler)
12.  **Admin Processes**  (Yönetici Süreçleri)

Yazının devamı için 
<a style="font-weight:bold" href="https://medium.com/mehmetcemyucel/a9a7648fffb?utm_source=mehmetcemyucel.com&utm_medium=twelve-factor&utm_campaign=blog" target="_blank">tıklayın...</a>
![](https://cdn-images-1.medium.com/max/800/1*A0OnarMzmEUJWQeHTHCgig.png)