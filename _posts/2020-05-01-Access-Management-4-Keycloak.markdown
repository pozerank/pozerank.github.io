---
title:  "Access Management 4-Keycloak"
date:   2020-05-01 21:04:23
categories: [mimari, security]
tags: [keycloak, sso, oauth2, saml, kerberos, ldap, oidc, oauth, openid connect, authentication, authorization, security, nedir, türkçe, nasıl yapılır, örnek, mehmet cem yücel]
image: https://miro.medium.com/max/150/0*n4KiIGqzdC2PX4QU.png
---
Önceki yazılarımızda öğrendiğimiz terminolojilerin somut örneklerini bu yazımızda Keycloak üzerinden inceleyeceğiz. Beşinci ve son yazımızda da Spring Boot ile Keycloak’u kullanarak Authentication/Authorization örnekleri yapacağız.

---

**--SERİNİN DİĞER YAZILARI--**

 - [1-XACML Authorization Authentication](https://www.mehmetcemyucel.com/2020/Access-Management-1-XACML-Authorization-Authentication/)
 - [2-OpenID OAuth2 OpenID Connect](https://www.mehmetcemyucel.com/2020/Access-Management-2-OpenID-OAuth2-OpenID-Connect/)
 - [3-SSO SAML Kerberos User Federation](https://www.mehmetcemyucel.com/2020/Access-Management-3-SSO-SAML-Kerberos-User-Federation/)
 - [4-Keycloak](https://www.mehmetcemyucel.com/2020/Access-Management-4-Keycloak/)
 - [5-Spring Boot ve Keycloak](https://www.mehmetcemyucel.com/2020/Access-Management-5-Spring-RestTemplate-Feign-Keycloak/)

---

## 1. Keycloak Nedir

![keycloak](https://miro.medium.com/max/1250/0*n4KiIGqzdC2PX4QU.png)


>"Keycloak is an open source Identity and Access Management solution aimed at modern applications and services. It makes it easy to secure applications and services with little to no code."

2018 Mart’ında [JBoss Community](https://developer.jboss.org/welcome) tarafından [Red Hat](https://www.redhat.com/en)’in katkılarıyla başlatılan [Keycloak](https://www.keycloak.org/), minimum kodla ya da hiç kod geliştirmeden uygulamalara erişim kontrolü için açık kaynak bir çözüm olarak kendisini tanımlıyor. Aşağıda yeteneklerinden bahsederken önceki 3 yazımızda bahsettiğimiz standartları da referans olarak ekleyeceğim.

## 2. Oauth2 ve SAML Desteği

Keycloak, en temel yeteneği olan [Single Sign On(SSO)](https://medium.com/mehmetcemyucel/dcc56682bdb2) için [XACML](https://medium.com/mehmetcemyucel/e4bdd7647b66) standartlarında erişim yönetimi sunar. Bunun için tercih edilen protokol olarak [OpenID Connect (OIDC)](https://medium.com/mehmetcemyucel/a36ee3f7779a) önerildiğini [belirtiyor](https://www.keycloak.org/docs/latest/securing_apps/index.html#openid-connect-vs-saml). Ancak detaylarından üçüncü yazımızda bahsettiğimiz [SAML](https://medium.com/mehmetcemyucel/dcc56682bdb2)’i de kullanılabilecek bir alternatif olarak desteklemektedir. [OAuth2](https://medium.com/mehmetcemyucel/a36ee3f7779a) desteği mevcuttur.

## 3. Uyumlu Teknolojiler

OIDC protokolü üzerinden çok sayıda dil için [adapter](https://www.keycloak.org/docs/latest/securing_apps/index.html#openid-connect-3)’ı barındırıyor. Java adapterları içerisinde JBoss, Tomcat, Jetty, Wildfly gibi sunucular için adapterların yanısıra Spring Boot, Spring Security, Java Servlet Filter, CLI/Desktop App, Pure Java App için de adapterlar bulunuyor.

## 4. Entegrasyonlar

[Kerberos](https://medium.com/mehmetcemyucel/dcc56682bdb2) bridge yeteneği sayesinde bir Kerberos sunucusuna login olmuş kullanıcıyı otomatik olarak authenticate edebilmektedir. Aynı zamanda [User Federation](https://medium.com/mehmetcemyucel/dcc56682bdb2) özelliği sayesinde LDAP ve Active Directory sunucularındaki kullanıcıları eşzamanlayarak kullanabilmek mümkün.

İkinci yazımızda değindiğimiz [Delegated Authorization](https://medium.com/mehmetcemyucel/a36ee3f7779a) örneği harici bir OIDC veya SAML Identity Provider’la da yapılabilir(Identity Brokering).

2 Factor Authentication ihtiyacını [Google Authenticatior](https://www.google.com/landing/2step/) veya [FreeOTP](https://freeotp.github.io/) ile gerçekleştirilebilirsiniz. Ayrıca Social Login ile Google, GitHub, Facebook, Twitter ve diğer sosya ağlardaki kimliklerinizle [OAuth2 doğrulaması](https://medium.com/mehmetcemyucel/a36ee3f7779a) yapılarak kimlik yönetimi yapılabilirsiniz.

## 5. Kullanım

Bütün bu işlemleri kendi arayüzü aracılığıyla gerçekleştirebilirsiniz. Sisteminizde kayıtlı kullanıcıların kendi şifrelerini resetlemeleri, sisteme dahil olmaları gibi konuları da yine ayrı arayüzler üzerinden gerçekleştirebilirsiniz.

![](https://miro.medium.com/max/1041/0*Xx4tAv-JfKtR9tVX.png)

## 6. Ortamlar ve Dökümanlar

Keycloak’ı kullanmak isterseniz bir [java runtime](https://www.keycloak.org/getting-started/getting-started-zip) aracılığıyla ilgili paketleri indirerek kullanmaya başlayabileceğiniz gibi, [Docker](https://www.keycloak.org/getting-started/getting-started-docker), [Kubernetes](https://www.keycloak.org/getting-started/getting-started-kube), [Openshift](https://www.keycloak.org/getting-started/getting-started-openshift) ve [Podman](https://www.keycloak.org/getting-started/getting-started-podman) için de hızlıca kullanabileceğiniz yönlendirmeler linklerde mevcut. Bu linklerdeki açıklamalar ve yönlendirmeler yeterli olacağından bu yazının içeriğinde bunlardan bahsetmeyeceğim.

## 7. Sonuç

Daha detaylı bilgiler için başarılı bir dokümantasyon sayfaları mevcut. [Buradan](https://www.keycloak.org/documentation) inceleyebilirsiniz. Beşinci ve son yazımızda Spring Boot ile Keycloak’u kullanarak Authentication/Authorization örnekleri yapacağız. Yazıya buradan erişebilirsiniz.


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

---