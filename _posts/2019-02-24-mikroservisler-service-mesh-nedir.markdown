---
title:  "Mikroservisler-Service Mesh Nedir"
date:   2019-02-24 15:04:23
categories: [microservices, cloud, mimari]
tags: [Service, Mesh Microservice, Mikroservis, circuit breaker, load balancer, kubernetes, istio,sidevar proxy, Nedir, Türkçe, Örnek, example, Nasıl, Mehmet Cem Yücel, Mehmet, Cem, Yücel, Yucel,]
image: https://cdn-images-1.medium.com/max/150/0*FhgA8Ersxk6Tr40r.jpg
---

Service Mesh tanımı; cevabında sidecar proxy, service discovery, orchestration framework, load balancing, circiut breaker pattern gibi konuları barındıran kavram. İlk cümle her ne kadar kompleks gelse de en yalın haliyle anlatmaya çalışacağım.


![](https://miro.medium.com/max/813/0*FhgA8Ersxk6Tr40r.jpg)

Mikroservis mimariye uygun kodladığınız bir projeniz olsun. Örneğin çok geniş ürün gruplarının satışını yaptığınız bir sitemiz var. Sitemizde hediyelik eşyadan bebek malzemelerine, elektronik aletlerden basılı yayıncılığa kadar ürün grupları var. Böyle bir sitenin tahminen ihtiyaç duyacağı servisler aşağıdaki gibi olacaktır.

-   Arama & Listeleme
-   Stok Yönetimi
-   Sepet yönetimi
-   Sipariş oluşturma
-   Ödeme

# Mikroservislerde Darboğaz

Bir uygulama mikroservislere parçalanırken dikkat edilmesi gereken 7-8 madde vardır. Yukarıdaki servisleri oluştururken hiçbir aggregate’ı dikkate almadım çünkü bu yazıda değinmek istediğim konu bunlar değil. Burada şu an için dikkat etmemiz gereken, bir işlem için birbirlerine bağımlı servislerin varlığı. Ve bir serviste yaşanacak bir darboğazın o servise bağımlı diğer servislerde yaşatacağı handikap.

Sitenizde bir dönem kampanyası oluşturdunuz, örneğin anneler gününe özel %20 indirim bilgisini tüm müşterilerinize duyurdunuz. Sitenizdeki tekil ziyaretçi sayısındaki artışa bağlı olarak normalde herhangi bir sıkışma yaşamayan uygulamanızın Arama & Listeleme ve Stok Yönetimi servislerinde sıkışmalar, gecikmeler söz konusu olmaya başladı. Hatta stok yönetim servisleri o kadar gecikmeye başladılar ki bu servisi tüketen listeleme servislerinde timeouta bağlı hatalar gözlenmeye başladı. Peki, listeleme servisimiz stok sorgulama servisinden timeoutlar almaya başlarsa ne yapmalı?

# Proxy Nedir

Bu noktada bir mola verip proxy kavramından söz etmem gerekiyor. Kişisel bilgisayarımız ile bir haber sitesine doğrudan erişip o siteden güncel haberleri okumamız mümkün. Ancak pek çok şirkette internete çıkış proxy sunucular üzerinden gerçekleştirilmektedir. Proxy(vekil) sunucular örneğin bir siteye erişmek istediğimizde **request&response trafiğinde araya girip** bizim adımıza siteye erişip bilgileri temin eden ve bu bilgileri tarafımıza aktaran sunuculardır. Güvenlik, caching gibi amaçlarla kullanılabilirler. Caching açısından faydaya bakacak olursak, sabahları X haber sitesine giren 20 çalışan için her defasında gerçekten siteye trafik yaratılmak zorunda kalmamış olduk. İlk trafikten sonraki 19 istek doğrudan proxy’nin cacheinden kullanıcıların bilgisayarlarına dönüşü sağlanmış oldu.


![](https://miro.medium.com/max/625/0*FZkc32z64ZVwh228.png)

# Bottleneck Problem

Tekrar konumuza dönelim. Listeleme servisi stok servisinden timeoutlar almaya başladı. Bu noktada yeni containerlar ayağa kaldırmak akla gelen ilk çözüm olsa da duruma kaynakları artırmadan yaklaşalım. Neler yapabiliriz?

-   Listeleme servislerinin stok servislerini çağrımını durdurabilir doğrudan fallback senaryolarını işletebiliriz.

-   Belirli periyotlarla stok servislerine 1-2 deneme isteği gönderip son durumda kendini toparlayıp toparlamadığını kontrol edebiliriz.
-   Eğer toparlamışsa stok servislerine trafiği tekrar açabiliriz. Problem devam ediyorsa da kapalı durumda tutup sonraki denemeyi bekleyebiliriz.
-   Başarısız denemelerin adedi artmışsa başka aksiyonları tetikleyebiliriz.

Aslında yukarıda bahsettiğim çözüm Circuit Breaker Pattern’ine ait durum diyagramı. Bu diyagramı teoride bir developerın kodlaması mümkün. Ancak her bir servis için bu kadar kodlamanın yapılması maliyet. Ayrıca servis sayısı arttıkça bunu yönetmek bir kaosa dönüşecek. Ve bu high level dil seviyesinde yapıldığı için servisler arası iletişimde yavaşlamalar söz konusu olmaya başlayacak.

# Service Mesh Nedir Nasıl Çalışır

Service Mesh aslında bir servisin düşünmesi gereken birçok non-functional problemlerin çözümünü sunan bir mimari katman. Yani yukarıdaki bottleneck problem başlığındaki örnekte sıralanan çözümleri developerın kodlama yapmasına gerek kalmadan çözüm olarak sunan bir yapı. Peki, mevcut kodda bir değişiklik yapmadan bunca çözüm nasıl çalışıyor?

![](https://miro.medium.com/max/60/0*Pn9Kt0TG-V6n9_Rw.png?q=20)

![](https://miro.medium.com/max/1750/0*Pn9Kt0TG-V6n9_Rw.png)

Service Mesh katmanını sağlamanın 3 farklı yolu mevcut.

-   Mikroservis uygulamasına non functional kod yazarak veya dependency olarak kütüphaneler ekleyerek (Hystrix, Ribbon, Feign client gibi)
-   Node agentlar aracılığıyla nodelar üzerinde denetimler sağlayarak
-   Ya da Sidecar Proxy’ler aracılığı ile.

Biz yazımıza en yeni yaklaşım olan `Sidecar Proxy` ‘leri açıklayarak devam edeceğiz. Sidecar Proxy’ler adından da anlaşılacağı üzere aslında birer proxy. Servislerin yanına konumlanırlar. Servisler hedef servislere erişimlerini o servise ait sidecar proxy üzerinden sağlarlar. Sidecar’ları sadece servis intercommunication’ı değil; load balancing, service discovery, authorization, authentication gibi konuları da çözen bir kutu olarak düşünebiliriz. Örneğin balancing üzerinden konuşursak, 3er instance çalışan listeleme ve stok servislerinden 2 stok servisi bottleneck içerisinde ise sidecarlar gelen istekleri daha stabil olan 3. containera yönlendirme aksiyonunu gerçekleştirebilirler. Sidecarlarınız Kubernates gibi bir orchestration frameworkünde yönetiliyorsa OSI 4. katmanda load balancing işlemleri gerçekleştirilir. Bu da bir yazılımcının bunu kodlamasından daha hızlı sonuçlar ortaya çıkaracaktır. Ayrıca servis sayısının artması durumunda servisler arası iletişimin daha güvenilir olmasını sağlayacaktır.

Yazının sonuna gelirken, service mesh ürünlerine birkaç örnek verelim. [Envoy](https://www.envoyproxy.io/) ve [Istio](https://istio.io/) sidecar proxyi ilk kullanan ürünler. Bunların haricinde [Conduit](https://conduit.io/) yakın zamanda [Linkerd](https://linkerd.io/) ile yollarını birleştirdiler. [Kong](https://konghq.com/solutions/service-mesh/) da yine başarılı bir service mesh ürünü.

Sonraki yazılarda görüşmek üzere

*En yalın haliyle*

**Mehmet Cem Yücel**

---

**_Bu yazılar ilgilinizi çekebilir:_**

 - [Bir Yazılımcının Bilmesi Gereken 15 Madde](https://www.mehmetcemyucel.com/2019/bir-yazilimcinin-bilmesi-gereken-15-madde/)
 - [Spring Boot Devtools ile Docker Üzerindeki Kodu Debug Etme ve Değiştirme](https://www.mehmetcemyucel.com/2019/spring-boot-devtools-ile-docker-uzerindeki-kodu-debug-etme-ve-degistirme/)
 - [Spring Boot Property’lerini Jasypt ile Şifrelemek](https://www.mehmetcemyucel.com/2019/spring-boot-propertylerini-jasypt-ile-sifrelemek/)

**_Blockchain teknolojisi ile ilgileniyor iseniz bunlar da hoşunuza gidebilir:_**

 - [BlockchainTurk.net yazıları](https://www.mehmetcemyucel.com/categories/#blockchain)
