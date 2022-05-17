---
title:  "Go ile Uçtan Uca Proje Yapımı Serisi"
date:   2022-05-12 10:00:00
categories: [mimari, go, microservices]
tags: [go, golang, rest, api, design, best, practices, http, service, web service, design, tasarım, java, spring boot, mikroservis, microservice, kubernetes,  türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://miro.medium.com/max/150/0*rT1N2EmrbbBg8fJH.png
---
Go dilini öğrenmek hızlı ve zevkli. İlk denemelerinizi yaptınız, dile kabaca aşina oldunuz hatta basit kodlarınızı yazdınız. Ancak canlıya kodu alacak kadar hazır hissediyor musunuz? Fonksiyonel olmayan ihtiyaçlarınızı da karşılayacak, kod ortamlara deploy olurken/olduğunda eliniz ayağınız olacak araçları detaylıca düşünüp projenize dahil ettiniz mi?

![](https://miro.medium.com/max/1000/0*rT1N2EmrbbBg8fJH.png)

Bu yazımızda Go dilinin best practicelerini merkezimize koyarak ihtiyaç duyulan entegrasyonları basit bir projede gerçekleştirip kullanabileceğiniz şablon bir proje yapısı ortaya koymaya çalışacağız. Aşağıdaki tercihler yapılırken birçok POC ve testler yapılarak seçimler yapıldı. Ancak teknoloji sürekli gelişiyor, değişiyor. Tercihinize göre ekleme çıkarma yapabileceğiniz bir şablon oluşturmaya çalışacağız, sizin de katkılarınızla bu şablonu daha kullanışlı hale getirebiliriz. Birkaç yazıdan oluşan bu seride konuşacağımız başlıklar;

 1. Yazı: [Golang ile Uçtan Uca Proje Yapımı Serisi](https://mehmetcemyucel.com/2022/go-ile-uctan-uca-proje-yapimi-serisi)
 	 - Go projelerinin dinamiği 
 	 - Proje yapısı ve klasör ağacı ([best-practices](https://github.com/golang-standards/project-layout))
 2. Yazı: [Golang Configuration Management](https://mehmetcemyucel.com/2022/golang-configuration-management)
	- Konfigürasyon yönetimi ([Viper](https://github.com/spf13/viper))
		- Environment variables ile
		- Merkezi konfigürasyon sunucusu ile ([Spring Cloud Config Server](https://cloud.spring.io/spring-cloud-config/reference/html/))
		- File (yaml)
3. Yazı: [Golang Central Logging Management](https://mehmetcemyucel.com/2022/golang-central-logging-management)
	- Loglama ([Zap](https://github.com/uber-go/zap))
		- Merkezi loglama ([Filebeat](https://www.elastic.co/beats/filebeat) + [Logstash](https://www.elastic.co/logstash/))
		- Alternatif merkezi loglama ([Kafka](https://kafka.apache.org/))
		- Access logging ([Echo](https://echo.labstack.com/))
4. Yazı: [Golang DB Migration - RDBMS & ORM Integration](https://mehmetcemyucel.com/2022/golang-db-migration-rdbms-orm-integration)
	- Db migration ([Migrate](https://github.com/golang-migrate/migrate))
	- RDBMS entegrasyonu ([Postgre](https://www.postgresql.org/))
		- Orm ([Gorm](https://gorm.io/index.html))
5. Yazı: [Golang API Management](https://mehmetcemyucel.com/2022/golang-api-management)
	- Monitoring ([Prometheus](https://prometheus.io/) & [Go-kit](https://gokit.io/))
	- Http router ([Echo](https://echo.labstack.com/))
	- Http package ([Fasthttp](https://github.com/valyala/fasthttp))
	- Open-api/Swagger desteği ([Swaggo](https://github.com/swaggo/swag))
6. Yazı: [Golang Message Broker — Object Mapping — Testing](https://mehmetcemyucel.com/2022/golang-message-broker-object-mapper-testing)
	- Message broker ([Sarama](https://github.com/Shopify/sarama))
	- Object mapping ([Xconv](https://github.com/howcrazy/xconv))
	- Testing
	
{% include feed-ici-yazi-1.html %}

## Go Projelerinin Dinamiği

Yoğunlukla **Flat** veya **Layered** olarak 2 farklı pratik tercih edilmektedir. **Flat**, tüm dosyaların direk root dizine bırakıldığı yapı, daha ufak ve granüler projeleri ifade ederken **Layered** yapı ise router, handler, domain gibi katmanların net bir şekilde birbirinden ayrıldığı daha kompleks ve büyük projelerde tercih edilen yapıdır. İkisinin de kendilerine göre avantajları ve dezavantajları vardır. İnternette karşılaştırmaları ile ilgili çokça yazı bulunuyor, dilerseniz ufak bir Googling ile detaylı örneklerini inceleyebilirsiniz. Biz Robert C. Martin’in [Clean Architecture](https://www.oreilly.com/library/view/clean-architecture-a/9780134494272/)’da bahsettiği aşağıdaki görsele uygun bir yapı oluşturacağız. Jeffrey Palermo’nun [Onion Architecture](https://jeffreypalermo.com/2008/07/the-onion-architecture-part-1/) olarak da bilinen aşağıdaki görsele yakın bir paketleme yapısı kullanacağız.

![enter image description here](https://miro.medium.com/max/1400/0*O6ZSkhtDUMLmWflO.png)

## Paket Yapısı

IDE olarak ben Goland kullanıyorum ancak VSCode veya herhangi bir başka tool da kullanılabilir. Proje yaratarak işe başlıyoruz, ilk başlangıç noktamız klasör yapısı. Bunun Go geliştirim takımı tarafından tanımlanmış bir standardı olmasa da Go topluluğunun tercih ettiği bir yapı artık herkes tarafından benimsenmiş ve kullanılıyor. Detay için [burayı](https://github.com/golang-standards/project-layout) inceleyebilirsiniz.

![enter image description here](https://miro.medium.com/max/540/1*QUS_HdytZy0KskH-4LTXFQ.png)

{% include feed-ici-yazi-2.html %}

**Main.go** dosyasından başlayalım, cmd/demo/main.go altından incelenebilir. Main fonksiyonumuz main package’ında bulunması gerekiyor. Klasör olarak da Go’da farklı mainlerinizi cmd/[module]/main.go formatına uygun şekilde koyulmasına olanak sağlayan bir klasörleme yapısı mevcut ancak Twelve Factor Codebase maddesi açısından bir codebase tek bir deployable unitten oluşması bekleniyor. Burada aykırı görüntülere de izin verilse de 1 codebase 1 depoyable unit mantığından uzaklaşmamak Twelve Fact açısından en iyisi.

Aşağıdaki main fonksiyonundaki gibi uygulamamızı ve bağımlılıkları ilmek ilmek dokumamız gerekiyor.

<script src="https://gist.github.com/mehmetcemyucel/a04858dd04e326b0303fd613b3995699.js"></script>


Şimdilik comment-out’lu kısıma takılmayalım, onları Swagger başlığı altında inceleyeceğiz. Bağımlılıklarımızı, bunların nasıl yönetileceğini adım adım yaratarak başlıyoruz.

Serinin sonraki yazısı **Konfigürasyon Yönetimi** hakkında, [buradan](https://mehmetcemyucel.com/2022/golang-configuration-management) erişebilirsiniz.

Serinin tüm yazılarına aşağıdaki linkler aracılığıyla erişebilirsiniz.

1. [Golang ile Uçtan Uca Proje Yapımı Serisi](https://mehmetcemyucel.com/2022/go-ile-uctan-uca-proje-yapimi-serisi)
2. [Golang Configuration Management](https://mehmetcemyucel.com/2022/golang-configuration-management)
3. [Golang Central Logging Management](https://mehmetcemyucel.com/2022/golang-central-logging-management)
4. [Golang DB Migration - RDBMS & ORM Integration](https://mehmetcemyucel.com/2022/golang-db-migration-rdbms-orm-integration)
5. [Golang API Management](https://mehmetcemyucel.com/2022/golang-api-management)
6. [Golang Message Broker - Object Mapping - Testing](https://mehmetcemyucel.com/2022/golang-message-broker-object-mapper-testing)

Yukarıda değindiğimiz bütün kodlara https://github.com/mehmetcemyucel/blog/tree/master/demo adresinden erişebilirsiniz.