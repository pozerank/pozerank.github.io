---
title:  "Golang Api Management"
date:   2022-05-16 10:00:00
categories: [mimari, go, microservices]
tags: [go, golang, rest, api, design, best, practices, http, service, web service, design, tasarım, java, spring boot, mikroservis, microservice, kubernetes,  türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://miro.medium.com/max/150/1*hV308VnNWS1xlrSaztOHkw.png
---

“Golang ile Uçtan Uca Proje Yapımı Serisi” 5. yazısında Go’da Api Yönetimi nasıl yapılır sorusunun cevabını arayacağız. Değineceğimiz başlıklar aşağıdaki gibi olacak;

-   Http router (echo)
-   Http package (fasthttp)
-   Monitoring (prometheus & go-kit)
-   Open-api/Swagger desteği (swaggo)

![Building RESTful APIs in Golang. Let's see how to setup project for… | by  Martin Heinz | Towards Data Science](https://miro.medium.com/proxy/1*hV308VnNWS1xlrSaztOHkw.png)

## HTTP Router

Http router olarak  [**_gorilla/mux_**](https://github.com/gorilla/mux),  [**_gin-gonic/gin_**](https://github.com/gin-gonic/gin)  ve  [**_Echo_**](https://echo.labstack.com/)  web frameworklerini POC’lediğimde hızı, kullanım kolaylığı ve communitydeki popülaritesi açısından  [**Echo**](https://echo.labstack.com/)  yu tercih ettim.

<script src="https://gist.github.com/mehmetcemyucel/0ec4ed880a491f470c7b3895536215f9.js"></script>

Yukarıdaki kod örneğinde Echo’nun kendi handler metot imza yapısı ile kodlanmış Check apisinin bindinginin nasıl yapıldığına bir örnek olarak alınabilir. Standart bir handlerla yazılmış handlera binding yapılabilmesi örneği de  `/metrics`  endpointi için geçerli. Keza birazdan değineceğimiz Swagger’ın endpointini de burada açtık.

Bunların haricinde Echo frameworkü bize predefined middleware çözümleri ile birlikte de geliyor. Peki bu ne demek? Ekstra bir kodlamaya gerek kalmadan gelen tüm istekleri loglayan(access logs) Logger, servisten kontrolsüz fırlatılan bir panic yüzünden uygulamamızın down olmasını kontrol altına alan Recover veya Cross Origin Yönetimi yeteneklerini ekstra kod yazmamıza gerek kalmadan kolay bir şekilde konfigüre edebilmemizi sağlayan  `CORSWithConfig`  gibi middlewareleri direk sunucunuzda yapılandırıp yukarıdaki örnekteki gibi kullanabilirsiniz anlamına geliyor.

Serverı sadece ayağa kaldırıp bırakmak yerine  **graceful shutdown**  özelliği eklemek iyi bir fikir. Bu sunucumuza OS’tan bir  **SIGINT** sinyali geldiğinde o anda işletilen işlerin yarım bırakılmadan tamamlanarak uygulamanın tutarsız durumda sonlanmasını engellemek anlamına geliyor. Bu sebeple operating system sinyallerini dinlemek için açılan bir kanal aracılığıyla maksimum 10 sn olacak şekilde uygulamanın kapanması için de bir kod ekledim.

{% include feed-ici-yazi-1.html %}


## HTTP Package

Belki önceki yazılarda dikkatinizi çekmiştir. Konfigürasyonun remote bir config sunucusundan çekilmesi örneğinde  [net/http](https://pkg.go.dev/net/http)  paketi yerine  [**FastHTTP**](https://github.com/valyala/fasthttp)  paketlerini kullanarak implementasyon yapmıştım. Kullanım kolaylığı ve net/http paketinin yaşadığı performans darboğazlarına karşı daha sağlam duruşu ile FastHTTP http paketi olarak projemizde aşağıdaki örnekle yerini aldı.

<script src="https://gist.github.com/mehmetcemyucel/5ab865c487dc4ed5d5539619722b0c84.js"></script>

## Monitoring

Uygulamanın prodda ayağa kalktıktan sonra memory istatistikleri, gc süreleri, thread ve cpu istatistikleri gibi bir çok bilgiye ihtiyaç duyarız. Bu bilgiler sayesinde uygulama için her şey yolunda mı, olası problemler gibi konularda önceden bilgi ediniriz. Ayrıca sunduğumuz servislerin tüketilme istatistikleri, response sürelerimiz gibi custom istatistiklerle de daha detaylı bilgileri takip edebiliriz. Bu amaçla projemizde  [**go-kit**](https://gokit.io/)  toolkitinin bu yeteneklerinden faydalanacağız. Go-kit projelerimize genel bir form katan çokça tooldan oluşsa da biz sadece monitoring özelliğine sağladığı kullanım kolaylığından dolayı kullanacağız.

<script src="https://gist.github.com/mehmetcemyucel/6aaec9ea53ee4382aeb73c0379954139.js"></script>

Yukarıdaki kod örneğinde prometheus kit içerisine 2 farklı toplamda 3 metrik tipi tanımladım. 1i count bilgisi verirken 2si summary sunuyor. Sonrasında  [**Chain of Responsibility**](https://refactoring.guru/design-patterns/chain-of-responsibility)  patterni kullanılarak farklı middleware implementasyonları birbirlerinin next actionları olarak tanımlanıyor ve servis çalıştırılırken verilen önceliğe göre chain işletiliyor. Kendi filterlarınızı da custom middlewareler olarak kodlayıp chaine dahil edebilirsiniz. Eğer echo frameworkte access logları açtıysanız yukarıdaki örnekteki gibi logging middlewarei comment-outlamak iyi bir tercih olabilir.

<script src="https://gist.github.com/mehmetcemyucel/42685e8b6b931afb5d754e6f1a2994ca.js"></script>

Yukarıda requestCount’u, latency’yi ve countResult gibi custom parametreleri prom.metrics’e işledik. Hatırlarsanız Echo frameworkun route’larını bind ederken  `/metrics`  path i tanımlamıştık. İşte bu endpoint toplanan uygulamanın metriklerinin ve custom metriklerin prometheus’un anlayabileceği dilde bir uçtan paylaşılabilmesi için açılmış bir endpointtir. Bu adrese gittiğimizde aşağıdaki formatta uygulamamıza ait tüm metrikleri edinebiliriz.

![](https://miro.medium.com/max/1400/1*mOKPTHZ3nyUf2UU7lEsoMg.png)

Örneğin üst satırlarda uygulamamızın Check endpointine 3 istek geldiğini, bunların toplamda ~5sn sürdüğünü(breakpoint vardı :)) custom metriclerimiz aracılığı ile görebiliyoruz. Aynı şekilde memory istatistiklerini ve daha fazlası da yine buradan erişilebilir durumda olacaktır. Bu metrikleri prometheus aracılığıyla collect edip Grafana’da monitoring dashboardları hazırlayabilir, anomali durumlarında haberdar olabilmek için alarmlar tanımlayabilirsiniz.

{% include feed-ici-yazi-2.html %}

## OpenAPI - Swagger

Son olarak da uygulamamıza eklediğimiz  [**Swagger**](https://swagger.io/)  desteğinden bahsedelim. Bunun için  [swaggo/swag](https://github.com/swaggo/swag)  toolunu kullandım. İlk önce toolun kurulması için aşağıdaki komutun çalıştırılması gerekiyor.

	$ go get -u github.com/swaggo/swag/cmd/swag
	
	# 1.16 or newer  
	$ go install github.com/swaggo/swag/cmd/swag@latest

Sonrasında toolun sitesindeki yönlendirmeler takip edilerek metotların ve uygulamanın başına eklenen yorum satırları aracılığı ile Swagger’ın yapılandırılması mümkün oluyor. Detaylı bilgiye  [buradan](https://github.com/swaggo/swag)  göz atabilirsiniz.

Swagger için router’da handlerının binding ini yapmıştık. Handler için gerekli dökümantasyonu build veya runtime’da değil öncesinde çalıştıracağımız bir komut ile hazırlıyor.

	swag init -g cmd/demo/main.go — output docs/mcy

Bu komutla uygulamamın başlangıcı burası ve oluşturacağın dökümantasyonu bu dosyanın altına bırak demiş oluyoruz. Çalıştırdığımızda aşağıdaki dosyalar oluşuyor. Buradaki bilgiler ışığında birazdan swagger ekranımız render olacak.

![](https://miro.medium.com/max/688/1*Gfe_jMayVH78OvPBiyh11A.png)

Uygulamanın  `http://localhost:8080/swagger/index.html`  adresine gittiğimizde swaggerımıza artık erişebiliriz.

![](https://miro.medium.com/max/1400/1*TvREd2RT4xaKjXaVJW9pXA.png)

Buradaki önemli nokta, Echo serverınızı yarattığınız noktada Swagger’ın ve dökümanların yaratıldığı klasörün static importlarını eklemeyi unutmayın ki uygulamanın contextine dahil olabilsin.

Serinin sonraki yazısı  **Message Broker, Object Mapping ve Testing**  hakkında,  [buradan](https://mehmetcemyucel.com/2022/golang-message-broker-object-mapper-testing)  erişebilirsiniz.

Serinin tüm yazılarına aşağıdaki linkler aracılığıyla erişebilirsiniz.

1. [Golang ile Uçtan Uca Proje Yapımı Serisi](https://mehmetcemyucel.com/2022/go-ile-uctan-uca-proje-yapimi-serisi)
2. [Golang Configuration Management](https://mehmetcemyucel.com/2022/golang-configuration-management)
3. [Golang Central Logging Management](https://mehmetcemyucel.com/2022/golang-central-logging-management)
4. [Golang DB Migration - RDBMS & ORM Integration](https://mehmetcemyucel.com/2022/golang-db-migration-rdbms-orm-integration)
5. [Golang API Management](https://mehmetcemyucel.com/2022/golang-api-management)
6. [Golang Message Broker - Object Mapping - Testing](https://mehmetcemyucel.com/2022/golang-message-broker-object-mapper-testing)

Yukarıda değindiğimiz bütün kodlara https://github.com/mehmetcemyucel/blog/tree/master/demo adresinden erişebilirsiniz.