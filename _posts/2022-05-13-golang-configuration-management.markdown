---
title:  "Golang Configuration Management"
date:   2022-05-13 10:00:00
categories: [architecture, go, microservices]
tags: [go, golang, rest, api, design, best, practices, http, service, web service, design, tasarım, java, spring boot, mikroservis, microservice, kubernetes,  türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://miro.medium.com/max/150/0*mOD5OS5YTXwx-Vd-.png
---

“Golang ile Sıfırdan Proje Yapalım” serisinin 2. yazısında Go’da konfigürasyon yönetimi nasıl yapılır sorusunun cevabını arayacağız.  [Viper](https://github.com/spf13/viper)  konfigürasyon yönetim toolunu 3 farklı yöntemle besleyerek birer örnek çıkarmaya çalışacağız. Kullanacağımız yöntemler aşağıdaki gibi olacak.

-   Environment Variable
-   Central Configuration Server (Spring Cloud Config Server)
-   File (application.yml)

![](https://miro.medium.com/max/500/0*mOD5OS5YTXwx-Vd-.png)


Uygulamamız hangi ortamda çalıştığını bilmeksizin ihtiyaç duyduğu konfigürasyonu uygulama paketi dışından alarak çalışabilmesi gerekir. Projenin ve ortamın ihtiyaçlarına göre bu konfigürasyon farklı şekillerde alınabilir. 3 farklı örnek inceleyeceğiz, önerim bu yöntemlerden size uygun birisini tercih edip kodunuzda sadece onu bulundurmanız. Örnek olması için ben 3ünü de aynı kodun içerisine koyacağım.

## Environment Variable

Twelve Factor açısından minimal kompleksite için önerilen runtime argümanlarından bilgilerin alınması. Golang yapısında bulunan  [flag](https://gobyexample.com/command-line-flags)ler de benzer şekilde kullanılabilir.

<script src="https://gist.github.com/mehmetcemyucel/6fc66883e4be37ebdcff5383b2bd106c.js"></script>

İhtiyaç duyduğumuz konfigürasyon sınıf yapısını oluşturarak başlıyoruz. Bir bakışta görülebilmesi için aynı dosyada tuttum, siz bunları ayrı dosyalara ayırabilirsiniz.

<script src="https://gist.github.com/mehmetcemyucel/26331fd659dbb4534bfd4c160cde1d32.js"></script>

Kodun aşağılarına ilerlediğimizde reflection kullanarak oluşturduğumuz sınıf yapısında fieldlara verdiğimiz kullandığımız taglerin Viper’a key olarak geçildiğini görüyorsunuz. Sonrasında automaticEnv metodu sayesinde Viper iletilen keyleri toplayıp objelerimizin doldurulmasını sağlayacak.

<script src="https://gist.github.com/mehmetcemyucel/26331fd659dbb4534bfd4c160cde1d32.js"></script>

{% include feed-ici-yazi-1.html %}

## Central Configuration Server (Spring Cloud Config Server)

İkinci yöntem eğer bir Config Server’a sahipseniz bu sunucuya bağlantı için gereken temel bilgileri env variable’dan alarak uygulamanızın yapılandırmasını uzak sunucudan okuyabilirsiniz. Aşağıdaki örnek Spring Cloud Config Server ile direk çalışabilen bir örnektir.

<script src="https://gist.github.com/mehmetcemyucel/5ab865c487dc4ed5d5539619722b0c84.js"></script>

Burada  **FastHTTP** kullanarak Basic Authetication’a sahip config sunucusuna bir istek atarak yaml dosyasına erişilmeye çalışılıyor. Erişilen byte stream direk Viper içerisine aktarılarak structların instancelarına set ediliyorlar.

## File (application.yml)

3üncü  örneğimiz ise file system üzerinde bulunan bir yaml dosyasından konfigürasyonun okunması. Aşağıdaki kodlarda kompleksiteyi artırmamak için statik bir klasör ve dosya ismini aratıyor olsam da bu bilgi environment variabledan okunacak şekilde de düzenlemesi yapılabilir.

<script src="https://gist.github.com/mehmetcemyucel/aae90ec62ef214775599f0205cac6675.js"></script>

{% include feed-ici-yazi-2.html %}

Serinin sonraki yazısı  **Loglama** hakkında,  [buradan](https://mehmetcemyucel.com/2022/golang-central-logging-management)  erişebilirsiniz.

Serinin tüm yazılarına aşağıdaki linkler aracılığıyla erişebilirsiniz.

1. [Golang ile Uçtan Uca Proje Yapımı Serisi](https://mehmetcemyucel.com/2022/go-ile-uctan-uca-proje-yapimi-serisi)
2. [Golang Configuration Management](https://mehmetcemyucel.com/2022/golang-configuration-management)
3. [Golang Central Logging Management](https://mehmetcemyucel.com/2022/golang-central-logging-management)
4. [Golang DB Migration - RDBMS & ORM Integration](https://mehmetcemyucel.com/2022/golang-db-migration-rdbms-orm-integration)
5. [Golang API Management](https://mehmetcemyucel.com/2022/golang-api-management)
6. [Golang Message Broker - Object Mapping - Testing](https://mehmetcemyucel.com/2022/golang-message-broker-object-mapper-testing)

Yukarıda değindiğimiz bütün kodlara https://github.com/mehmetcemyucel/blog/tree/master/demo adresinden erişebilirsiniz.