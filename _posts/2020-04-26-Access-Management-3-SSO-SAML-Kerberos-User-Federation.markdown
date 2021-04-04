---
title:  "Access Management 3-SSO SAML Kerberos User Federation"
date:   2020-04-26 21:04:23
categories: [mimari, security]
tags: [sso, single sign on, keycloak, kerberos, oauth2, oauth, openid, connect, authentication, ldap, federation, nedir, örnek, türkçe, nasıl yapılır, mehmet cem yücel]
image: https://miro.medium.com/max/150/0*tA4cZb1i9Mxds-Uz
---

[İlk yazımızda](https://www.mehmetcemyucel.com/2020/Access-Management-1-XACML-Authorization-Authentication/) bir uygulamaya erişim isteğinde bulunulduğunda gerçekleşen adımlardan bahsettik. [Sonraki yazımızda](https://www.mehmetcemyucel.com/2020/Access-Management-2-OpenID-OAuth2-OpenID-Connect/) farklı erişim senaryoları için kullandığımız teknolojilerin nasıl evrimleştiğinden bahsettik. Bugün Federated Authentication kullanan diğer bir sektör standardı olan **Security Assertion Markup Language (SAML)** ve **Single Sign On (SSO)** ile yazımıza başlayalım.

![single sign on sso](https://miro.medium.com/max/1020/0*tA4cZb1i9Mxds-Uz)

---

**--SERİNİN DİĞER YAZILARI--**

 - [1-XACML Authorization Authentication](https://www.mehmetcemyucel.com/2020/Access-Management-1-XACML-Authorization-Authentication/)
 - [2-OpenID OAuth2 OpenID Connect](https://www.mehmetcemyucel.com/2020/Access-Management-2-OpenID-OAuth2-OpenID-Connect/)
 - [3-SSO SAML Kerberos User Federation](https://www.mehmetcemyucel.com/2020/Access-Management-3-SSO-SAML-Kerberos-User-Federation/)
 - [4-Keycloak](https://www.mehmetcemyucel.com/2020/Access-Management-4-Keycloak/)
 - [5-Spring Boot ve Keycloak](https://www.mehmetcemyucel.com/2020/Access-Management-5-Spring-RestTemplate-Feign-Keycloak/)

---

# 1 Single Sign On (SSO) Nedir

**SAML**, kullanıcıların uygulama bazında login sessionlarının ayrı bir contextte tutulmasıyla oluşturulmuş bir **Single Sign On(SSO)** standardıdır. Burada SSO yu açmak gerekirse, bir uygulamaya login olduğunuzda aynı contextte çalışan diğer uygulamalara tekrardan login olmanıza gerek kalmayacağıdır. Örneğin bir şirkette çalışıyorsunuz ve bilgisayarınıza giriş yapabilmek için Domain’e veya Active Directory’e şifrenizle login oldunuz. O andan itibaren artık intranet uygulamalarında portal uygulamasına veya insan kaynakları uygulamasına tekrardan şifre girmenize gerek kalmadan uygulamaların sizi tanımasına verilen isimdir. Basit anlamda bir SSO aşağıdaki gibi çalışabilir

## 1.1 SSO Akışı

![sso process](https://miro.medium.com/max/1235/1*bOtq30aQI2_tComa_dMezg.png)

Tekrar SAML’a dönecek olursak, XML bazlı çalışan bu güvenlik protokolü açık kaynak kodludur. Authentication akışı aşağıdaki gibi çalışmaktadır.

![SAML Authentication Process](https://miro.medium.com/max/1345/1*7zleRist5o_p8NJtbZf5oA.png)

Farkettiyseniz bir önceki yazımızdaki bahsettiğimiz OAuth2'deki authorization akışına çok benzemekle birlikte burada farklı olarak login credential veya secret doğrulama işlemi sadece delege edilen bir identity provider tarafından değil bir Active Directory gibi kullanıcı veritabanıyla birlikte identity provider ile federe şekilde, birlikte gerçekleştirilmesidir. Bu **Federated Authentication’**a bir örnektir. Burada kullanıcının bilgilerinin **LDAP, Active Directory veya DBMS** gibi sistemlerden edinilerek kullanılmasına da **User Federation** ismi verilir.

## 1.2 Kerberos Akışı

SAML’ı kullanan sistemlerden birisi de **Kerberos**’tur. Kerberos, tamamen güvensiz bir networkte güvenli iletişim başlatmak için ortaya koyulan **Ticket(bilet)** temelli çalışan bir yaklaşımdır. Aşağıdaki gibi çalışmaktadır.

![Kerberos Authentication Process](https://miro.medium.com/max/971/1*VsOhg01a3Gr1qma4Mcv3hQ.png)

Burada ek adım olarak kullanıcının servise erişebilmesi için ihtiyaç duyduğu bileti alabilmek için bilet sağlayan bir bilet alması gerekir. Bu bilet sağlayan bilet de Identity Provider tarafından kullanıcının kendi şifresi tarafından anahtarlanmıştır ve kullanıcı gerçekten doğru kullanıcı ise sadece çözülebilecek ve bilet sağlayan bilet ortaya çıkacaktır. Bu bileti çözen kullanıcı servise erişebilmek için ihtiyaç duyacağı bileti Identity Provider’dan edinebilecektir.

# 2 Sonuç

İlk 3 yazımız boyunca öğrendiğimiz kavramsal konuları somut örnekler eşliğinde Keycloak uygulama aracılığıyla deneyimleyeceğiz. İlgili yazıya [buradan](https://www.mehmetcemyucel.com/2020/Access-Management-4-Keycloak/) erişebilirsiniz.


***En yalın haliyle***

[**Mehmet Cem Yücel**](https://www.mehmetcemyucel.com)

---

**_Bu yazılar ilgilinizi çekebilir:_**

 - [_Bir Yazılımcının Bilmesi Gereken 15 Madde_](https://www.mehmetcemyucel.com/2019/bir-yazilimcinin-bilmesi-gereken-15-madde/)
 - [_Spring ve Java Hantal Mı — GraalVM ve Quarkus’a Giriş_](https://www.mehmetcemyucel.com/2019/Spring-ve-Java-Hantal-Mi-GraalVM-ve-Quarkus-Inceleme/)
 - [_Mikroservisler-Service Mesh Nedir_](https://www.mehmetcemyucel.com/2019/mikroservisler-service-mesh-nedir/)
 - [_12 Factor Nedir Türkçe ve Java Örnekleri_](https://www.mehmetcemyucel.com/2019/twelve-factor-nedir-turkce-ornek/)

**_Blockchain teknolojisi ile ilgileniyor iseniz bunlar da hoşunuza gidebilir:_**

 - [_BlockchainTurk.net yazıları_](https://www.mehmetcemyucel.com/categories/#blockchain)

