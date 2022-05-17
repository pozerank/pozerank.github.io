---
title:  "Golang Configuration Management"
date:   2022-05-15 10:00:00
categories: [mimari, go, microservices]
tags: [go, golang, rest, api, design, best, practices, http, service, web service, design, tasarım, java, spring boot, mikroservis, microservice, kubernetes,  türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://miro.medium.com/max/150/0*mOD5OS5YTXwx-Vd-.png
---

“Golang ile Uçtan Uca Proje Yapımı Serisi” 4. yazısında Go’da db migrationı nasıl yapılır sorusunun cevabını arayacağız. Ayrıca  **RDBMS**([**Postgre**](https://www.postgresql.org/)) entegrasyonunu bir  **ORM** toolu([**Gorm**](https://gorm.io/index.html)) kullanarak nasıl yapabileceğimize değineceğiz.

![](https://miro.medium.com/max/1400/0*6pQrd5Dnhivf8Tp8.png)


## DB Migration

Bir uygulamanız olduğunu hayal edin, çalışmadan önce yaratılmış olmasına ihtiyaç duyduğu tablolar, bu tabloların içerisinde dolu olması beklenen kayıtlar, grantler, indexler vb barındırıyor.  _Everything as a code_  yaklaşımı genellikle CI/CD processlerinin kodlanması anlamını taşısa da uçtan uca her şeyin kodlanarak halledilmesini de ifade eder, buna veritabanı de dahil. Çünkü  **Twelve Factor**’de bahsedilen  **Dev/Prod Parity**  kavramını karşılayabilmek başka türlü pek de mümkün değildir.

Bu tarz ihtiyaçları karşılayabilmek için db migration toolları piyasada bulunmaktadır. Java için  [**Liquibase**](https://www.liquibase.org/),  [**Flyway**](https://flywaydb.org/)  gibi toollar olduğu gibi Golang dünyasında da benzer toollar bulunuyor. DB migration’ı için  [**Migrate**](https://github.com/golang-migrate/migrate)  toolunu kullanacağız.

<script src="https://gist.github.com/mehmetcemyucel/3785084c5a4eb3df27eb3d7f82b6dd48.js"></script>

Migrate toolunu yapılandırmak için bağlanacağımız dbnin bilgilerini ve hangi dbye bağlanacaksak o dbnin connector’ını eklememiz gerekiyor. Migrate edilecek dosyaları  `./db`  klasörünün altına koyulacak şekilde yapılandırmasını yaptım.

![](https://miro.medium.com/max/696/1*loy2lfoKZWZshQVHJ1_qRQ.png)

Burada dosya isimlendirme formatının bir anlamı bulunuyor.

	aaaa_bbbb.[up]/[down].sql

-   aaaa: sequential artan bir numara ile changeset id, sıralı tutabilmek için bir best practice
-   bbbb: changeset’i açıklayı bir bilgi
-   up: changeset i barındıran dosya
-   down: up dosyası herhangi bir noktasında fail olursa rollback için gereken scriptlerin bulunduğu dosya

Bir changesetin hem up hem de down dosyasının yazılması zorunludur. İlk defa  `migrate.Up()`  metodunun çalıştırılması ile birlikte dbde  `schema_migrations`  isimli bir tablo yaratılarak en son çalıştırılan changesetin bilgisi tutulmaya başlanır. Böylelikle yeni gelen changesetler ayırt edilerek sadece en son yapılan migrationdan itibaren yeni eklenen changesetlerin çalıştırılması mümkün olur.

{% include feed-ici-yazi-1.html %}


## RDBMS & ORM Integration

<script src="https://gist.github.com/mehmetcemyucel/df62cbfa63c4b0f4cbf6c335f70a0937.js"></script>

Db entegrasyonu da benzer yapılandırma parametreleri ile sağlanıyor. Farklı olarak ben projeye bir ORM toolu da ekleyerek projenin mappinginin daha kolay yönetilmesini tercih ettim.  [**Gorm**](https://gorm.io/index.html)  Golang için güçlü bir ORM toolu, DB schemasının yaratımı, object mapping, kendi query dili gibi özellikler barındırıyor. Aşağıda bir entity ve tablosunun örneğini ve bu entity yi oluşturmak için gereken repository için bir örneği bulabilirsiniz.

<script src="https://gist.github.com/mehmetcemyucel/11c1a7fa1681c55db90d8d96bf5f3c2e.js"></script>

![](https://miro.medium.com/max/1400/1*iSROcv-sOPToKJNZAARfYg.png)

<script src="https://gist.github.com/mehmetcemyucel/ddc98ffc4f331b87feb3d8fd5a3af202.js"></script>

{% include feed-ici-yazi-2.html %}

Serinin sonraki yazısı **API Yönetimi**  hakkında,  [buradan](https://mehmetcemyucel.com/2022/golang-api-management)  erişebilirsiniz.

Serinin tüm yazılarına aşağıdaki linkler aracılığıyla erişebilirsiniz.

1. [Golang ile Uçtan Uca Proje Yapımı Serisi](https://mehmetcemyucel.com/2022/go-ile-uctan-uca-proje-yapimi-serisi)
2. [Golang Configuration Management](https://mehmetcemyucel.com/2022/golang-configuration-management)
3. [Golang Central Logging Management](https://mehmetcemyucel.com/2022/golang-central-logging-management)
4. [Golang DB Migration - RDBMS & ORM Integration](https://mehmetcemyucel.com/2022/golang-db-migration-rdbms-orm-integration)
5. [Golang API Management](https://mehmetcemyucel.com/2022/golang-api-management)
6. [Golang Message Broker - Object Mapping - Testing](https://mehmetcemyucel.com/2022/golang-message-broker-object-mapper-testing)

Yukarıda değindiğimiz bütün kodlara https://github.com/mehmetcemyucel/blog/tree/master/demo adresinden erişebilirsiniz.