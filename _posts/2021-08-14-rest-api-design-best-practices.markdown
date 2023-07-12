---
title:  "Rest Api Design Best Practices"
date:   2021-08-14 21:24:23
categories: [mimari, java, spring, jvm, spring boot]
tags: [rest, api, design, best, practices, http, service, web service, rest service, design, tasarım, java, spring boot, mikroservis, microservice, kubernetes,  türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://miro.medium.com/max/150/1*mdijc3xUzEbA2XuyBW5SWg.png
---
Hepimiz uygulamalarımızın birbirleri ile haberleşebilmesi için Rest Servisler sunuyoruz veya tüketiyoruz. Peki bu servisleri oluştururken best practiceleri gerçekten uyguluyor muyuz? Richardson Maturity Model’a, HTTP metotlarına, statü kodlarına, URI tasarım prensiplerine dikkat ediyor muyuz? Farklı başlıklarda bu pratikleri ele alalım.

![](https://cdn-images-1.medium.com/max/1000/1*mdijc3xUzEbA2XuyBW5SWg.png)
## Temel Kurallar

-   **1#** “/” karakteri sadece hiyerarşik ilişkileri belirtmek için kullanılır.

	    **örn:** https://mehmetcemyucel.com/customers/orders

-   **2#** “/” karakteri URI’lerin sonunda bulundurulmamalıdır.

	    **hatalı örnek:** https://mehmetcemyucel.com/customers/orders/
	    **doğru örnek:** https://mehmetcemyucel.com/customers/orders

-   **3#** “_” karakteri tarayıcılar tarafından hyperlink yorumlamasında kullanıldığı için URI’lerde kullanılmamalıdır. Yerine “-” karakteri kullanılabilir, okunurluğun artırılması için kelime aralarında kullanılması best practicedir.

	    **hatalı örnek**: https://mehmetcemyucel.com/blogs/blockchain_blog/entries/first_blog_post
	    **doğru örnek:** https://mehmetcemyucel.com/blogs/blockchain-blog/entries/first-blog-post

-   **4#** [RFC 3986](https://www.rfc-editor.org/info/rfc3986) standartlarına göre URI’ler büyük/küçük harf duyarlıdır. Herhangi bir noktada karışıklığa sebebiyet vermemek için tüm URI’de küçük harf kullanmak best practicedir.

	    **örn 1:** https://mehmetcemyucel.com/customers/orders
	    **örn 2:** https://mehmetcemyucel.com/Customers/Orders (bu yukarıdaki linkten başka bir linki ifade ediyor)
	    **örn 3:** HTTPS://MEHMETCEMYUCEL.COM/customers/orders (bu link yukarıdaki 2 linkten de başka bir adresi ifade ediyor. Karışıklığa sebebiyet vermemek için tüm karakterlerin küçük kullanılması önerilmektedir.

-   **5#** Dosya uzantıları URI’lerde bulunmamalıdır. Media Type bilgileri için “Content-Type” headerı kullanılmalı, “Accept” header’ı ile de izin verilen dosya uzantıları, tipler yönetilmelidir.

	    **hatalı örnek:** https://mehmetcemyucel.com/customers/orders/123/invoice.json
	    **doğru örnek:** https://mehmetcemyucel.com/customers/orders/123/invoice

-   **6#** API’lerin versiyonlu kullanılması best practice’dir. Bu bilgiyi URI’de geçirmek bir çözüm olabileceği gibi isteğin headerında geçirmek de alternatif bir yöntemdir.

	    **URI örneği:** [https://mehmetcemyucel.com/v1/customers/orders](https://mehmetcemyucel.com/customers/orders)
	    **header örneği:** x-api-version=1
		
{% include feed-ici-yazi-1.html %}

## Resource Modeling (Path)

### **Document**

Bir nesne veya veritabanı kaydına benzeyen tekil bir kavramdır. Bu kavram value barındıran fieldları ve diğer resourcelara erişimi tanımlayan linkleri içermektedir. Aşağıdaki her bir URI ayrı ayrı documentları ifade etmektedir.

    …/v1/departments/it
    …/v1/universities/ege-university

### **Collection**

Sunucu tarafından yönetilen resourceların bulunduğu dizin anlamına gelmektedir. Birbirleri ile anlamsal bütünlüğe sahip resourceların bir arada bulundukları grupları ifade eder.

    …/v1/customers
    …/v1/universities/ege-university/faculties

### **Store**

Client tarafından yönetilen resource repository anlamına gelir. Store ile ifade edilen kaynağı client yaratabilir, güncelleyebilir veya silebilir.

Örneğin kullanıcının favorilerine ekleme yapmak için aşağıdaki istek kullanılabilir.

    PUT …/v1/customers/1234/favorites/727721

### **Controller**

Sunucu tarafındaki MVC patternindeki Controller ile karıştırılmaması gerekir. Controller prosedürel bir konsepttir. Girdi ve çıktılardan oluşan çalıştırılabilen fonksiyonlardır. Ancak standart http metodlarının gerçekleştirebildiği işlemlerin(POST/GET/…) işlemler controller olarak tanımlanmaması gerekir.

    **örnek:** POST …/alerts/15231/resend

### Resource Modeling Kurallar

-   **7#** Document ve store isimleri tekil olmalıdır.

	    …/v1/departments/it
	    …/v1/universities/ege-university/students/05051232
-   **8#** Collection isimleri çoğul olmalıdır

	    …/v1/departments
	    …/v1/universities/ege-university/students

-   **9#** Controller isimleri fiil olmalıdır

	    …/alerts/15231/resend

-   **10#** Document ve Store’ları ifade ederken path variable’ın ID olarak kullanımı sunucuların üzerindeki yükü azaltacağından iyi bir pratiktir

	    …/v1/{university-id}/students/{student-id}
	    …/v1/universities/351/students/05051232

-   **11#** HTTP metot isimleri URI’de bulunmamalıdır

	    **doğru örnek:** DELETE …/users/1234
	    **hatalı örnekler:**
	    POST …/deleteUser?id=1234
	    POST …/deleteUser/1234
	    POST …/delete-user {“id”:1234} //body
	    DELETE …/deleteUser/1234
	    POST …/users/1234/delete
		
{% include feed-ici-yazi-2.html %}

## URI Query Design (Query)
Query komponenti URI’ye tanımlanan kanak objelerle(controller, document, collection, store) yakından bağlantılıdır. Filtreleme, arama, pagination ve sıralama yapmak için kullanılabilecekleri gibi controllera input geçmek için de kullanılabilirler. Örneğin;

https://mehmetcemyucel.com/users/123456/send-sms controllerı ile mesaj gönderilebilir.
https://mehmetcemyucel.com/users/123456/send-sms?text=welcome ile de içeriği welcome olan mesaj gönderilebilir.

### URI Query Design Kuralları
-   **12#** Collection veya Store’ların filtrelenmesi için kullanılabilir.

	    **örnek:** GET …/users?role=admin

-   **13#** Collection veya Store sonuçlarının Paging’i için kullanılmalıdır

	    **örnek:** GET …/users?pageSize=25&pageStartIndex=50

-   **14#** Collection veya Store sonuçlarının Sorting’i için kullanılmalıdır.

{% include feed-ici-yazi-3.html %}

## HTTP Metotları Etkileşimi

### GET
Get metodu belirtilen kaynağın bir temsilini ister. Get kullanılan istekler sadece veri almalı, resource server üzerinde bir değişiklik gerçekleştirmemelidir.

### HEAD
Head metodu Get metoduyla tamamen aynı olan sadece bodysi olmayan bir yanıt ister.

### POST
Post metodu resource servera bir entity(varlık) göndermek için kullanılır. Bu durum sunucuda bir state değişikliğine veya side effect’e neden olur(örneğin insert).

### PUT
Put metodu resource serverda bulunan tüm geçerli resourceların yerine istekte bulunan bilgileri koyar(Update).

### DELETE
Delete metodu belirtilen resourceu siler.

### CONNECT
CONNECT metodu hedefteki kaynak tarafından tanımlanan sunucuya bir tünel oluşturur.

### OPTIONS
OPTIONS metodu hedefteki kaynağın iletişim seçeneklerini tanımlamak için kullanılır.

### TRACE
TRACE metodu hedefteki kaynağa giden yol boyunca bir mesaj loop-back testi gerçekleştirir.

### PATCH
PATCH metodu bir kaynağa kısmi değişiklikler uygulamak için kullanılır.

   Örnek bir curl çağırımı
    
    $ curl -v http://api.organization.com/greeting  
    > GET /greeting HTTP/1.1 2  
    > User-Agent: curl/7.20.1 3  
    > Host: api.organization.com  
    > Accept: /  
    < HTTP/1.1 200 OK 4  
    < Date: Sat, 20 Aug 2011 16:02:40 GMT 5  
    < Server: Apache  
    < Expires: Sat, 20 Aug 2011 16:03:40 GMT  
    < Cache-Control: max-age=60, must-revalidate  
    < ETag: text/html:hello world  
    < Content-Length: 130  
    < Last-Modified: Sat, 20 Aug 2011 16:02:17 GMT  
    < Vary: Accept-Encoding  
    < Content-Type: text/html  
    <!doctype html><head><meta charset="utf-8"><title>Greeting</title></head>   
    <body><div id="greeting">Hello   World!</div></body></html>

### HTTP Metotları Etkileşimi Kuralları

-   **15#** GET ve POST metodları diğer http metodlarının ihtiyacını karşılamak üzere kullanılmamalıdır. Her metod kendi amacıyla kullanılmalıdır.
-   **16#** GET sadece bir resource’un representation’ında kullanılmalıdır.
-   **17#** GET, HEAD, OPTIONS, TRACE metodları obje üzerinde değişiklik yaratmamalıdır(Idempotency)
-   **18#** PUT mutable resourceların update i için kullanılmalıdır.
-   **19#** POST bir collection’ın içerisinde yeni bir resource yaratılması için(insert) kullanılmalıdır.
-   **20#** POST başarılı sonuçlandığında 201 kodu ile birlikte location headerında oluşan yeni resourceun representation url’i(GET) dönülmelidir.
-   **21#** PATCH resourceların parçalı update i için kullanılmalıdır.
-   **22#** PATCH, POST ve PUT işlemlerinin sonucunda resource dönülmelidir.
-   **23#** Controller’lar POST ile çağırılmalıdır, kullanılmalıdır.
-   **24#** DELETE bir resource’u parent’ından silmek için kullanılmalıdır.
-   **25#** OPTIONS ile resource’un metadatası üzerinden alınabilecek aksiyonlar sorgulanabilir. Bu şekilde ilgili 400 Bad Request ihtimali olmaksızın resource’a erişim mümkün olacaktır.  
      
    Allow: GET, PUT, DELETE

## HTTP Statu Kodları

**1xx**: Bilgilendirme

**2xx**: Başarılı  
  Client’ın isteklerinin başarılı olarak ele alındığını ifade eder.

**3xx**: Yönlendirme  
  Client’ın isteğinin sonuçlanabilmesi için ekstra aksiyon alması gerektiğini ifade eder.

**4xx**: Client Hataları  
  Client’ın yaptığı istekle ilgili hatalı durumların varlığını ifade eder.

**5xx**: Server Hataları  
  Sunucunun sorumluluk sınırlarında bir hata ile karşılaşıldığını ifade eder.

### HTTP Statu Kodları Kuralları

-   **26#** 200 OK kodu beklenen koddur, 204 kodu haricinde 2xx’lü kodların body dönmesi best practice’dir.
-   **27#** 200 OK kodu response body’de hata kodu, hata bilgisi dönmek için kullanılmamalıdır.
-   **28#** 201 Created kodu başarılı resource yaratımı sonrasında dönülmelidir.
-   **29#** 202 Accepted kodu asenkron bir aksiyon başlatılacağında dönülmelidir.
-   **30#** 204 No Content kodu PUT, POST, DELETE gibi isteklerin response’larında kayıt bulunamadığında dönülmelidir. Bunun yanı sıra bir GET isteğinde istenen kayıt mevcut ancak bunun serviste sunumu tercih edilmediği durumda da 204 kullanılabilir. Body’si boş olmalıdır.
-   **31#** 302 Moved Permanently kodu taşınan resource’u tariflemek için kullanılır. Response’un location headerında yeni URI tarif edilmelidir.
-   **32#** 304 Not Modified kodu 204 ile aynı olup body’nin dolu olması ihtiyacı duyulduğunda kullanılır.
-   **33#** 400 Bad Request kodu client side hatanın spesifik sebebi bilinmediğinde kullanılmalıdır. Sebebi bilindiği senaryolarda 4xx kodlarından uygun olanı tercih edilmelidir.
-   **34#** 401 Unauthorized kodu client’ın kimlik bilgilerinde hata olduğunda kullanılmalıdır. Sunucu seviyesi bir koddur.
-   **35#** 403 Forbidden kodu uygulama seviyesinde yetkilendirilmemiş resourcelara erişimde kullanılan hata kodudur.
-   **36#** 404 Not Found kodu client’ın istek yaptığı uriyi Rest Api’nin bir resource a eşleyemediğinde kullanması gerekmektedir.
-   **37#** 500 Internal Server Error Uygulama seviyesinde alınan hataların dönüldüğü en generic hata kodudur.

{% include feed-ici-yazi-1.html %}

## Metadata Tasarımı (Headers)

### text/plain
Spesifik bir yapısı bulunmayan düz metin biçimi.

### text/html
HyperText Markup Language (HTML) kullanılarak biçimlendirilmiş içerik

### image/jpeg
Joint Photographic Experts Group (JPEG) tarafından standartlaştırılmış bir görüntü sıkıştırma yöntemi

### application/xml
Extensible Markup Language (XML) kullanılarak biçimlendirilmiş içerik

### application/atom+xml
XML tabanlı Atom Syndication Format (Atom) kullanılarak biçimlendirilmiş içerik

### application/javascript
Kaynak kodu JavaScript programlama dilinde yazılmış içerik

### application/json
Text tabanlı yapılandırılmış veri alışverişi yapmak amacıyla kullanılan JavaScript Object Notation (JSON) formatında biçimlendirilmiş içerik

### Metadata Tasarımı Kuralları
-   **38#** Hem request hem de response için Content-Type yapılandırması mutlaka yapılmalıdır.
-   **39#** Static content yönetiminde client side cacheleme yapılabilmesini sağlayan bu tag last-modified headerı ile birlikte kullanıldığında büyük miktarlarda kaynak tasarrufu sağlamaktadır
-   **40#** Location headerı yeni yaratılmış bir resource’un bilgisini dönecek şekilde yapılandırılmalıdır.
-   **41#** Cacahe-Control, expires, date response headerları isteği yapan client’ın cache’leme yapabilmesi için dönülmelidir. Eğer cacheleme yapılmaması isteniyorsa Cache-Control, Expires ve Pragma headerları kullanılmalıdır.
-   **42#** Custom http header’ları http methodlarının default davranışlarını değiştirmek için kullanılmamalıdır.

## Representation Tasarımı(Body)

-   **43#** Json resource representation support edilmelidir. plain/text dönüşler yapılmamalıdır.












