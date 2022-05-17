---
title:  "Golang Message Broker Object Mapper Testing"
date:   2022-05-17 10:00:00
categories: [mimari, go, microservices]
tags: [go, golang, rest, api, design, best, practices, http, service, web service, design, tasarım, java, spring boot, mikroservis, microservice, kubernetes,  türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://miro.medium.com/max/150/0*d70VvJL7EhiARvgS.png
---

“Golang ile Uçtan Uca Proje Yapımı Serisi” 6. yazısında Go’da Kafka ile nasıl iletişim kurulabileceğinden, object mappingin nasıl yapılabileceğinden ve belki de en önemlisi test nasıl yazılabileceğinden bahsedeceğiz.

![](https://miro.medium.com/max/1104/0*d70VvJL7EhiARvgS.png)

## Message Broker

Önceki yazılardan hatırlarsanız  [**Kafka**](https://kafka.apache.org/)  üzerinden async bir logging yapısı kurmuştuk. Orada detaylarından bahsetmesem de  [**shopify/sarama**](https://github.com/Shopify/sarama)  kütüphanesini kullanarak kodumuzun Kafka brokerlarına bağlanmasını sağlayarak mesaj alışverişi yapmıştık. Kodu tekrar bir hatırlayalım,

<script src="https://gist.github.com/mehmetcemyucel/5419c986c3a5278adf043a8f2e98fb1c.js"></script>

Burada brokerın adresine gönderilen acknowledge’ın karşılığında alınan acknowledge ile config yapılandırılıyor. Yine URL içerisinde iletilmesi beklenen retry policy de sarama config ine işlendikten sonra Producer instanceı yaratılıyor. En son mesaj göndermek istediğimizde de bu Producer üzerinden topiclerimize encode edilmiş veriyi gönderiyoruz. Benzer şekilde consumer örneğini de  [Sarama’nın sayfasından](https://pkg.go.dev/github.com/Shopify/sarama)  projeye ekleyebilirsiniz.

{% include feed-ici-yazi-1.html %}

## Object Mapping

Projelerimizde veritabanından aldığımız verileri tutan entitylerimizi servislerimizde input/output olarak kullanmamamız hem güvenlik önlemleri açısından hem de servislerimizin ihtiyaç duyduğu schema ile entitynin bilgilerinin %100 örtüşmeyebileceği açısından bir best practice. Bu sebeple entityleri Data Transfer Object(DTO) olarak isimlendirdiğimiz farklı objelere çevirip kullanırız.

Bu çevirimi yapmak için  [**xconv**](https://github.com/howcrazy/xconv)  kütüphanesini kullandım. Objelerdeki field isimlerini reflection ile dolaşıp yeni tipe mappingini sağlayan basit ve etkili bir kütüphane. Dilerseniz objelerdeki field isimlerinde birebir örtüşme olmadığı durumda tagleri de kullanacak şekilde kütüphaneye contributionda da bulunabilirsiniz.

<script src="https://gist.github.com/mehmetcemyucel/706b3b377b49bd9e7f4612fc784f1db5.js"></script>

## Tests

Son olarak belki de en önemli konu testler. Kodumuzu her zaman test yapılabilecek şekilde yazmamız önemli bir konu. Bu sebeple TDD önem kazanıyor, çünkü önce testlerin sonra kodun yazıldığı bir senaryoda kodun teste uygun olmaması çok da mümkün değil. Ancak iyi bir TDD uygulayıcısı olmak bir anda gerçekleşen kolay bir şey değil. Çünkü dilin yeteneklerine hakimiyet zamanla gelişen bir şey. Hele de Golang gibi zengin bir dil ile çalışıyorsanız bir ihtiyacı görecek çok farklı şekillerde kodlar yazabileceğinizi zamanla göreceksiniz. Bu sebeple bu iş için önerilen best practiceleri öğrenerek bu işe atılmak iyi bir tercih olabilir.

Birim testlerimizi yazabilmek için  [Test Double](https://martinfowler.com/bliki/TestDouble.html)’lara ihtiyaç duyarız. En yoğun kullanılan da muhtemeler Mock’lardır. İnterneti araştırdığınızda Golang için mocklama yapabileceğiniz çok farklı yöntemleri göreceksiniz; High Order Functions, Interface Substitution, Monkey Patching, Embedding Interface, vb… Bunlar içerisinde ana koda minimal etki ile en az eforlu mocklama yöntemlerinden 2 si için örnek kod paylaşacağım.

### Embedding Interface

Kodlarda dikkatinizi çektiyse handler, service, repo gibi katmanlar arasındaki tüm iletişimler interfaceler üzerinden gerçekleştirildi. Bu testlerimizi yazarken mocklamayı kolaylıkla halledebilmek için yapılan bir tercih. Testini yazacağımız kodumuz şu şekilde;

<script src="https://gist.github.com/mehmetcemyucel/6aaec9ea53ee4382aeb73c0379954139.js"></script>

Mocklama ihtiyacı duyduğumuz repositorynin görüntüsü;

<script src="https://gist.github.com/mehmetcemyucel/8c73039645b9a0bbf2824adfa18f4e6a.js"></script>

Interfaceini taklit etmek istediğimiz sınıfın mocku olmak üzere bir struct tanımlıyoruz(14). Bu structa ait instance metodu olarak interfacete yer alan metodların implementasyonunu yapıyoruz(16). Bu mockun davranışının farklı test metotlarında değişiklik gösterebilmesi için test metotlarında editlenebilmesi ihtiyacı sözkonusu olduğundan instance metodunun dönüşünü(17) tanımladığımız bir First Class Function’a(12) devrediyoruz. Testin init fonksiyonunda(20) structımızı polymorphic olarak service(10) değişkenimize atayarak mock oluşturumumuzu tamamlıyoruz.

<script src="https://gist.github.com/mehmetcemyucel/5823cf6fbab660a9a1af81dd973bf7c0.js"></script>

Sonrasında mockumuzun davranışını test metodunda tanımlayabiliriz. Bir anonymous function yardımıyla mocklamak istediğimiz metodun davranışını tanımladıktan sonra direk test edeceğimiz metodu çağırabiliriz. Bu kadar basit!

{% include feed-ici-yazi-2.html %}

### Monkey Patching

Eğer kodumuz instance metotları ile çağırılmayacaksa, direk bir metot olarak düşünülecekse metotlarımızı  [First Class Functions](https://go.dev/doc/codewalk/functions/)  olarak tanımlayarak kolaylıkla mocklanmasını sağlayabiliriz. Örnek kod;

<script src="https://gist.github.com/mehmetcemyucel/9e5ba7a1a7324beaccb0015a42a5fd21.js"></script>

Örneğin burada normal bir fonksiyon yerine First Class fonksiyonu olarak tanımlanmış bir fonksiyon bulunuyor. Bunu test edebilmek için de aşağıdaki gibi bir kod yazmamız yeterli.

<script src="https://gist.github.com/mehmetcemyucel/0838913d1c3b06272a9329cd858699d4.js"></script>

Son olarak, eğer kontrolü bizim elimizde olmayan bir kütüphanenin bir metodu mocklanması gerekirse de o kütüphanenin kullanıldığı satırı ayrı bir struct içerisindeki kendi yazdığımız bir metoda izole edip bu structa embedding interface yönteminde yaptığımız gibi polymorphic erişimle mocklanabilir hale getirebilirsiniz.

Serinin tüm yazılarına aşağıdaki linkler aracılığıyla erişebilirsiniz.

1. [Golang ile Uçtan Uca Proje Yapımı Serisi](https://mehmetcemyucel.com/2022/go-ile-uctan-uca-proje-yapimi-serisi)
2. [Golang Configuration Management](https://mehmetcemyucel.com/2022/golang-configuration-management)
3. [Golang Central Logging Management](https://mehmetcemyucel.com/2022/golang-central-logging-management)
4. [Golang DB Migration - RDBMS & ORM Integration](https://mehmetcemyucel.com/2022/golang-db-migration-rdbms-orm-integration)
5. [Golang API Management](https://mehmetcemyucel.com/2022/golang-api-management)
6. [Golang Message Broker - Object Mapping - Testing](https://mehmetcemyucel.com/2022/golang-message-broker-object-mapper-testing)

Yukarıda değindiğimiz bütün kodlara https://github.com/mehmetcemyucel/blog/tree/master/demo adresinden erişebilirsiniz.