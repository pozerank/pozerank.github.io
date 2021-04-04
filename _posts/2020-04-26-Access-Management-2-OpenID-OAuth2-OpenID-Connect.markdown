---
title:  "Access Management 2-OpenID OAuth2 OpenID Connect"
date:   2020-04-26 19:04:23
categories: [mimari, security]
tags: [sso, authentication, authorization, single sign on, keycloak, kerberos, oauth2, oauth, openid connect, protokol, federation, türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://miro.medium.com/max/150/0*ipuyew2--zak9w2i.png
---

[İlk yazımızda](https://www.mehmetcemyucel.com/2020/Access-Management-1-XACML-Authorization-Authentication/) Authorization ve Authetication kavramlarından bahsetmiştik. Bir uygulamaya gelen erişim isteğinin ne şekilde işlenerek sonuçlandığından bahsettik. Bu yazımızda geçmişte neler yaşandı, ihtiyaç duyuldu ve bugüne nasıl evrildik konusuna değineceğiz.


![](https://miro.medium.com/max/640/0*H5weENf3rnm2dhaz)

---


**--SERİNİN DİĞER YAZILARI--**

 - [1-XACML Authorization Authentication](https://www.mehmetcemyucel.com/2020/Access-Management-1-XACML-Authorization-Authentication/)
 - [2-OpenID OAuth2 OpenID Connect](https://www.mehmetcemyucel.com/2020/Access-Management-2-OpenID-OAuth2-OpenID-Connect/)
 - [3-SSO SAML Kerberos User Federation](https://www.mehmetcemyucel.com/2020/Access-Management-3-SSO-SAML-Kerberos-User-Federation/)
 - [4-Keycloak](https://www.mehmetcemyucel.com/2020/Access-Management-4-Keycloak/)
 - [5-Spring Boot ve Keycloak](https://www.mehmetcemyucel.com/2020/Access-Management-5-Spring-RestTemplate-Feign-Keycloak/)

---

## 1. OpenID Devrimi

Gündelik yaşamda duymaya aşina olduğumuz bu iki tanımı neredeyse her uygulamada bir arada kullanıyoruz. Sosyal medya hesaplarımızdan mail adreslerimize, forumlardan üye olduğumuz sitelere kadar her yerde bir üyeliğimiz, kullanıcı adımız ve şifremiz, var. Aklımızda tutmamız gereken o kadar kullanıcı adı ve şifremiz var ki bunları saklamak için password manager uygulamaları kullanmamız gerekiyor.

Bu karmaşayı gidermek için **2005** yılında **Brad Fitzpatrick** tarafından [**OpenID**](https://openid.net/) isimli bir kimlik doğrulama protokolü için çalışıyordu. Aynı şekilde **2006** yılında da [**Twitter**](https://twitter.com)  bu konuda çalışmalarını hızlandırmıştı. Yaklaşım şuydu, her üyelik sistemi gerektiren siteye yeni bir kullanıcı adı/şifresi yaratmak yerine OpenID’de yaratılan bir kimlikle tüm diğer sitelerde üyelik ve login gerçekleştirilebilecekti.

![](https://miro.medium.com/max/826/1*yjz-C1SBIzfrophVUIZ8Kw.png)

Kullanıcı bir foruma üye olmak istediğinde OpenID kimliğiyle üye olacaktı. Kullanıcı sonraki her login isteğinde siteye OpenID ile login olmak istediğini söyleyecek, site kullanıcıyı OpenID’ye yönlendirip oradan doğruladığı kimliğiyle geçerli bir sertifika aracılığıyla tekrar kendisine gelmesini isteyecekti. Böylelikle kullanıcı adı/şifresi kaosu artık yaşanmayacaktı. OpenID bir **Federated Authentication** örneğidir.

![](https://miro.medium.com/max/970/1*eyGITOaY4c1wj8fyCa-zSw.png)

## 2. Yelp Tehlikesi

Bu çalışmalar devam ederken 2007 yılında ilgili ilginç bir gelişme yaşanmıştı. Eski [**PayPal**](https://www.paypal.com)  çalışanları **Jeremy Stoppelman** ve **Russel Simmons**’un bir girişimi olan [**Yelp**](https://www.yelp.com/), yerel işletmeler hakkında kullanıcıların deneyimlerini paylaştıkları bir site geliştirdiler. Sitenin kullanımını artırabilmek için önemli bir nokta vardı, insanlar kendi çevresindeki arkadaşlarının yorumlarını daha çok önemsiyorlardı. Bir şekilde üye profillerin kendi arkadaş çevresindeki kişilerle etkileşiminin artırılması gerekiyordu ancak kimin kiminle arkadaş olduğu bilinmiyordu.

O zaman için büyük bir hamle yaparak üyelik sisteminde bir farklılık yarattılar. Yeni üye olacak kişileri halihazırda kullandıkları MSN, Yahoo, Gmail hesap bilgileri üzerinden sisteme üye yapacaklardı. Aldıkları bu bilgilerle gerçekten hedef sistemde, örneğin MSN(Hotmail), bu kullanıcının var olup olmadığını kontrol edecek, hem de kullanıcının arkadaş çevresi bilgilerini öğrenebileceklerdi. Bu şekilde sitedeki üye profilleri arasındaki etkileşim artırılacaktı.

![](https://miro.medium.com/max/885/1*9ni9R_kVXK0OAur-ZsKcqA.png)

Gerçekten de bütün bu uğraşlar sonuç buldu. Hatta o kadar çok insan sonuçlarını düşünmeden bu sistemi kullandı ki oluşan güvenlik açığı büyük şirketlerin tepkisini çekti. Tehlike şuydu; kullanıcılar authentication amacıyla verdikleri gerçek hesap kullanıcı ve şifreleri ile Yelp uygulamasına sınırsız erişim yetkisi veriyorlardı. Yelp bu bilgilerle kullanıcıların tüm maillerine, konuşma geçmişlerine, iletişim bilgilerine, güvenlik tercihlerine ve daha nicelerine erişim yetkisi elde ediyordu. Aslında ihtiyaç duyulan sadece arkadaş listesine erişebilmek iken kullanıcının tüm tercihlerini değiştirebilecek bir yetkiye sahip olmak doğru kurgulanmamış bir authorization kurgusundan başka bir şey değildi.

## 3. Oauth Hamlesi

Birkaç yıl önce çalışmaları başlatılan OpenID projesi açık bir standart olmadığı sebebiyle **2007** yılında kurulan **OAuth Discussion Group** açık protokol için taslak bir öneri yazma çalışmalarına başladı. Yelp senaryosuyla karşı karşıya kaldığı zamanlara denk gelen Google, bu çalışmalardan haberdar olduğunda destekleyerek süreci hızlandırdılar. Aynı senenin **Aralık** ayında [**OAuth Core 1.0 Protokol Şablonu**](https://oauth.net/core/1.0/) yayımlandı. İlerleyen süreçte kullanımın kolaylığı ve hedef teknolojilerin çeşitliliği gözetilerek yenilenen [**OAuth 2.0 Framework**](http://tools.ietf.org/html/rfc6749#section-4.4.2)’ü **2012 Ekim**’de yayımlandı.

![](https://miro.medium.com/max/225/0*Wl7CHlfKPE49XS1U.png)

OpenID’de boş kalan authorization boşluğunu OAuth Protokolü’nün Token’lı yapısı sayesinde uygulamalar doldurmaya başladı. Artık Yelp’e yeni kullanıcı yaratmak istediğinizde sertifika yerine belirli kapsamda sınırlandırılmış yetkiler için onay alınıyor.

![](https://miro.medium.com/max/531/1*p7OgUA_9pOpz8AeLn9wU2w.png)

Buradaki farklılık, artık belirli bilgilere erişime kullanıcının onay verdiği sınırlarda geçerli tokenlar ile authorization’ın sağlanması noktasında ortaya çıkıyor. OpenID ile farklılığını aşağıdaki görselden inceleyebilirsiniz.

![](https://miro.medium.com/max/950/1*thIslnlOrMO0FUCagfZMwA.png)

## 4. Oauth2

![](https://miro.medium.com/max/375/0*UV6qnowEJIvXlUI-.png)

Zaman içerisinde ihtiyaçlar dahilinde Oauth 2.0 bir framework olarak ortaya koyuldu. Teknolojik çeşitliliğe ve kullanımın kolaylaştırılması odaklı gelişen versiyonda halen amaç aynı. Erişimin ve yetkilendirmenin sitelere direkt olarak kullanıcı adı/şifresi vermeksizin, erişimin bilgilerini barındıran bir token yapısıyla süreçleri yönetebilmek. Bu süreçleri OAuth 2.0 dört adet tanımla ele alıyor.

### 4.1. Oauth2 Authorization Code Flow Örnek

![](https://miro.medium.com/max/1594/1*jTDazKqC_J4-sed62C69oA.png)

Senaryoya yine Yelp örneği üzerinden gidelim. Yelp’e Gmail hesabımızla login olmak istiyoruz. Hesap sahibi olan biziz, yani **Resource Owner**’ız. Yelp bizim Google Account’umuzdaki arkadaş bilgilerimizi almaya çalışan **Client Application**. Bu bilgiler Google’un **Resource Server**’larında tutulur. **Authorization Server** da yine Google’ın ilk yazıda bahsettiğimiz **XACML** standartlarında olduğunu varsaydığımız **Identity Provider**’ı olsun.

![](https://miro.medium.com/max/1594/1*dE4gW72PCxeuoNhVfpehUg.png)

Kullanıcı browser’ı aracılığıyla Yelp’e login olmak istediğinde Yelp kullanıcının browser’ını **Google’ın Authorization Server**’ına yönlendirir. Kullanıcı Gmail hesabının bilgilerini girerek doğrulamadan geçerse Authorization Server’ın kendisine verdiği **Authorization Code**’u browser Yelp’e iletir. Yelp de bu kod ile Authorization Serverdan aldığı Access Token aracılığıyla Gmail’deki arkadaş bilgilerinin bulunduğu Resource server’a giderek bu bilgileri edinir. Bu **Delegated Authorization**’a bir örnektir. Authorization işlemi Google Resource server tarafından Google Authorization Server’a delege edilmiştir.

Önemli olarak belirtmekte fayda var. Yukarıdaki akış en çok kullanılan OAuth2 akışlarından birisi olan **Authorization Code Flow** akışı. 3 Farklı flow daha bulunmaktadır. Bunlar, **Client Credentials Code Flow, Implicit Code Flow ve Resource Owner Password Credentials Code Flow**’dur.

## 5. OpenID Connect

![](https://miro.medium.com/max/375/0*ipuyew2--zak9w2i.png)

Bütün bu protokollerin, frameworklerin üzerine 2014'te [**OpenID Connect (OIDC)**](https://openid.net/connect/) isimli **OpenID Foundation** tarafından geliştirilen bir framework ortaya koyuldu. OAuth 2.0'deki akışlar örnek alınarak ve ek adımlar eklenerek **Delegated Authorization** yerine **Federated Authentication**’ın kullanıldığı bir framework olarak tanıtıldı. Özetle:

-   **OpenID** kullanıcının kimliğini doğrulayan(authentication)
-   **OAuth** kullanıcının kaynaklarına erişimi kontrol eden(authorization)
-   **OpenID Connect** de yukarıdaki iki maddenin toplamını gerçekleştiren frameworktür.

## 6. Sonuç

Sonraki yazımızda aynı OpenID Connect gibi **Federated Authentication** kullanan diğer bir **Access Management** standardı olan **SAML**’a ve çalışma prensiplerine**, User Federation, Kerberos, SSO** kavramlarına değineceğiz. Yazıya [buradan](https://www.mehmetcemyucel.com/2020/Access-Management-3-SSO-SAML-Kerberos-User-Federation/) erişebilirsiniz.


***En yalın haliyle***

[**Mehmet Cem Yücel**](https://www.mehmetcemyucel.com)

---

**_Bu yazılar ilgilinizi çekebilir:_**

 - [Bir Yazılımcının Bilmesi Gereken 15 Madde](https://www.mehmetcemyucel.com/2019/bir-yazilimcinin-bilmesi-gereken-15-madde/)
 - [Spring ve Java Hantal Mı — GraalVM ve Quarkus’a Giriş](https://www.mehmetcemyucel.com/2019/Spring-ve-Java-Hantal-Mi-GraalVM-ve-Quarkus-Inceleme/)
 - [Mikroservisler-Service Mesh Nedir](https://www.mehmetcemyucel.com/2019/mikroservisler-service-mesh-nedir/)
 - [12 Factor Nedir Türkçe ve Java Örnekleri](https://www.mehmetcemyucel.com/2019/twelve-factor-nedir-turkce-ornek/)

**_Blockchain teknolojisi ile ilgileniyor iseniz bunlar da hoşunuza gidebilir:_**

 - [BlockchainTurk.net yazıları](https://www.mehmetcemyucel.com/categories/#blockchain)

---