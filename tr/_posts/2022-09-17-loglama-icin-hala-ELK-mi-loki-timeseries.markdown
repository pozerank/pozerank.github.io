---
title:  "Loglama İçin Hala ELK Mı Kullanıyorsunuz 1- Loki ve Time Series Databaseler"
date:   2022-09-17 10:00:00
categories: [architecture, microservices]
tags: [loki, elk, timeseries, api, design, best, practices, http, service, web service, design, tasarım, database, loglama, mikroservis, microservice, kubernetes,  türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://miro.medium.com/max/150/1*D_Yu51tJZBK70suixBWPlQ.jpeg
---

**Graylog**,  **ELK**,  **Splunk**… Piyasada çokça kullanılan ücretli/ücretsiz merkezi loglama çözümleri. İşin ilginci log miktarınız arttıkça bakım ve operasyonel maliyetiniz daha da artıyor. Neden diyorsanız, yazılan her satır, her kelime logun indekslenerek aranabilir olarak tutulmasının yarattığı maliyeti hatırlamamız lazım. Onlarca, yüzlerce ve hatta binlerce mikroservisinizin olduğu bir dünyada bu loglar inanılmaz boyutlara gelerek kullandığınız ürünün dikeyde değil yatayda daha farklı şekillerde ölçeklenmesi ihtiyacını yavaş yavaş kapınıza getirecek.

![](https://miro.medium.com/max/700/1*D_Yu51tJZBK70suixBWPlQ.jpeg)

ELK kullandığımızı varsayalım. İlk refleks kullanılmayan featureları kapatmak, sıkıştırmayı artırmak, shardları ve indexleri elden geçirmek oluyor. Baktık yeterli olmuyor daha eski loglara aging uygulayarak warm ve cold indexlere kaydırmak, belki bir noktadan sonrasını tamamen arşivlemek bizi bir nebze de olsa rahatlatıyor. Ama aslında çoğu zaman yaptığımız X uygulamasının instancelarında belirli zaman aralıklarındaki logu incelemek ve spesfik kelimeler aramak. İndeksler için katlandığımız maliyetleri düşündüğümüzde acaba gerçekten de over-engineering yapıyor olabilir miyiz?

Prometheus’u çoğunuz duymuş veya kullanmıştır. Genellikle sistemlerimizde olan biteni takip etmek, anomaly detection gibi amaçlarla kullandığımız bir  **time series database**. Merkezi log izleme ile Prometheus’un ne alakası var diyorsanız biraz time series databaseler hakkında bilgi verip yazımızın konusu olan  **Loki’ye**  bağlayacağım. Loki’nin bir şeyleri daha efektif nasıl yapabildiğini anlayabilmemiz için işin derinine inmemiz gerekiyor.

{% include feed-ici-yazi-1.html %}


## Time Series Databases

Time series databaseler belirli periyotlarda veri hakkında özet bir bilgi alarak bu bilgiyi bir zaman damgası ile birlikte saklarlar. Bu zaman damgaları time series database’lerin time series kısmını oluşturur. Örneğin her 10 sn’de bir borsadan Dolar/TL kuru anlık bilgisi alınabilir. Veya bir rest servise o periyotta gelen istek adedi toplamı bu veriyi oluşturabilir. Time series databaseler de bu  **verileri seri şeklinde kaydederek zamanla bu değerlerdeki değişimleri, korelasyonları veya anomalileri görebilmemiz için sunarlar.**

Yine kur örneğinden devam edelim. Zaman damgası time series’i ifade ederken Dolar kur bilgisi ise bu serinin bir field ını ifade eder. Benzer şekilde Euro/TL kuru da başka bir field olarak serimizde yer alabilirdi. Bu isimlendirmeler farklı timeseries dblerde farklı isimleri alabilirler, konuyu ele alış biçimleri açısından terimlerde başka farklılıklar da olabilir. Bizim örneğimiz ve jargonumuz piyasada en çok kullanılan Prometheus, InfluxDB gibi örneklerin isimlendirmeleri üzerinden olacak.

<script src="https://gist.github.com/mehmetcemyucel/d6cf1fd069f34166d89b64ebd9de7b0b.js"></script>

Time series ve fieldlarımızın yukarıdaki gibi olduğu durumda time series database bu verileri key/value ikilileri olarak tutar. Yani değerlerimiz aslında zaman ve field ikilileri şeklinde aşağıdaki gibi saklanır.

<script src="https://gist.github.com/mehmetcemyucel/cf706b1e694fe52761406e73406542c0.js"></script>

<script src="https://gist.github.com/mehmetcemyucel/571b85645d832d00472ed8ac5af85de3.js"></script>

{% include feed-ici-yazi-2.html %}


## Tag Kavramı

Tag kavramı fieldların aksine bir değerden ziyade o değeri etiketleyen bir bilgiyi içerir. Örneğin biz her 5 dkda bir Borsa İstanbul’dan veri aldığımız gibi New York borsasından da aynı verileri alıp saklamayı tercih edebilirdik. İşte hangi borsanın verisi olduğunu işaretlemeyi tagler aracılığı ile yapıyoruz.

<script src="https://gist.github.com/mehmetcemyucel/d38114ecc2c422cf768156459da04303.js"></script>

Peki örnek olarak ele aldığımız veritabanları verilerimizi key/value ikilileri olarak saklayabiliyorlardı. Tagler işin içine girince acaba ne oldu ve veri nasıl saklanmaya başladı? Aslında cevap basit, 2 field ve 2 çeşitlilikteki tag için 2^2 adet key/value ikilisinde veriler tutulmaya başlandı.

<script src="https://gist.github.com/mehmetcemyucel/a9ae4248ac900e2fb1c1713976b079f9.js"></script>

<script src="https://gist.github.com/mehmetcemyucel/c7b3fb18d5c5894f8f769dd69441649b.js"></script>

<script src="https://gist.github.com/mehmetcemyucel/0792f61d978a486bbb70654202f45386.js"></script>

<script src="https://gist.github.com/mehmetcemyucel/5eba0a8f52c375a3c5221c65a19cc238.js"></script>

Farkındaysanız datayı kümül olarak bir/birkaç noktada toplamak yerine veriye erişme şeklimi başta tanımlayabildiğim ve verinin de buna göre konsolide edilerek  **chunkl**ar halinde saklandığı bir yapıya ulaştım.

## Prometheus-Loki İlişkisi

Prometheus gibi Loki de  **Grafana**’nın bir ürünü. Aslında aralarındaki teorik olarak 2 fark var, ilki fieldlarda özet bir veri yerine loglarımız duruyor. İkincisi de, normalde Prometheus bir veriye erişip onu kendisi collect ederken Loki tam tersi şeklinde çalışıyor, kendisine gelen logları kabul ediyor. Tabii ki logu ele alış şeklinde de bazı farklılıklar bulunuyor.

{% include feed-ici-yazi-1.html %}

## Loki’nin Avantajları

Loki’nin güzel yanlarından birisi indexing maliyetlerinin  **full text search**  yapan diğer alternatiflerine göre çok daha düşük olması. Ayrıca kaba verinin de maliyetini yönetebiliyor oluşumuz çok önemli diğer bir faktör. Chunklarımızı  **Cassandra**,  **GCS**,  **File System**,  **S3**,  **MinIO**  gibi alternatiflerden tercih ettiğimiz birisinde saklayabiliyoruz.

Loki’nin çalışma şeklinin oluşturduğu bir diğer güzel sonuç, loglar taglere göre chunklara bölünerek kayıt edildiği için farklı müşterilerinizin loglarının, verilerinin birbirlerinden izole şekilde saklanması garanti altına alınmış olur.

Kafalarda oluşan muhtemel sorulardan birisi, ben taglemediğim bir bilgi üzerinden text search yapamayacak mıyım? Cevap, evet yapabilirsiniz. Farkı şu, yüzlerce mikroservisinizin logunun olduğu geniş bir kapsamda aramak yerine uygulamanızın adı(tag) ve zaman aralığını da belirttiğiniz daha dar bir scopeda yine logunuz(field) üzerinde arama yapabileceksiniz.

Loki okuma veya yazma yoğun bir sisteminizin ihtiyaçlarına göre ölçekleyebileceğiniz bir mimari ile geliyor. Sonraki yazıda bu mimariye daha derinlemesine gireceğiz ancak verinin tutulduğu adresler için  **Consistent Hash Ring**  kullandığı için veriye erişimimiz de bir hayli hızlı. Hatta sonraki yazıya spoiler olsun, ortalama 100GB lık bir log yığınının içerisinde 100mb lık text search barındıran bir logun collectionı 70-80 ms civarında toparlanabiliyor, ki bunun içerisinde verinin decompress edilmesi de mevcut.

Bu yazının içerisinde vereceğim son bilgi de tabii ki şaşırtmayacağı üzere Grafana ile birlikte kullanılabildiği ve aynı PromQL gibi kendisine ait bir sorgulama dili  **LogQL**  ile birlikte sorgulamaların yapılabildiği bilgisi.

Bir sonraki yazıda Loki’nin derinlemesine mimarisi ve Kubernetes üzerinde container loglarının  **FluentBit**  veya  **Fluentd**  ile collect edilip Loki’ye beslenmesi ve Grafana ile bu loglara erişimi ve en son olarak da performans testi metriklerinin incelemesini yapacağız.