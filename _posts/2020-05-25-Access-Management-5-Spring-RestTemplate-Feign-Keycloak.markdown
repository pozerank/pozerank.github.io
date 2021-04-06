---
title:  "Access Management 5-Spring RestTemplate Feign Keycloak"
date:   2020-05-25 21:04:23
categories: [mimari, security]
tags: [keycloak,authentication, authorization, feign, client, spring, boot, resttemplate, oauth2, ldap, oidc, oauth, openid, connect, spring, security, türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://cdn-images-1.medium.com/max/150/0*knMgRQMoNMWQciZs.jpg
---

Access Management serimizin son yazısında Spring Boot RestTemplate ve OpenFeign Client kullanarak Keycloak üzerinde kolaylıkla OpenIdConnect ve OAuth2 ile nasıl kimlik doğrulama yapılır bunu inceleyeceğiz.

![](https://miro.medium.com/max/1825/0*knMgRQMoNMWQciZs.jpg)

---

**--SERİNİN DİĞER YAZILARI--**

 - [1-XACML Authorization Authentication](https://www.mehmetcemyucel.com/2020/Access-Management-1-XACML-Authorization-Authentication/)
 - [2-OpenID OAuth2 OpenID Connect](https://www.mehmetcemyucel.com/2020/Access-Management-2-OpenID-OAuth2-OpenID-Connect/)
 - [3-SSO SAML Kerberos User Federation](https://www.mehmetcemyucel.com/2020/Access-Management-3-SSO-SAML-Kerberos-User-Federation/)
 - [4-Keycloak](https://www.mehmetcemyucel.com/2020/Access-Management-4-Keycloak/)
 - [5-Spring Boot ve Keycloak](https://www.mehmetcemyucel.com/2020/Access-Management-5-Spring-RestTemplate-Feign-Keycloak/)

---

## 1. Senaryo

Uygulamamız ve test senaryomuz şu şekilde olacak. İki rest servis ayağa kaldıracağız. İki servisi de ayrı roller çağırabilir durumda olacak. Uygulamamızın client’ına sadece 1 role yetki vereceğiz. Bu yetkiyle 1. servisi çağırabildiğini, 2. servise ise unauthorized aldığını gözlemleyeceğiz. Bu çağırımları hem restTemplate ile hem de feign client ile yapacağız. Bütün bu süreci kolaylaştırmak için bir tane de bu servislerin çağırımının yapıldığı bir ayrı bir servis ayağa kaldıracağız.

## 2. Ortam Kurulumu

### 2.1. Keycloak on Docker

Ben pratik olması açısından Keycloak’u Docker üzerinde ayağa kaldıracağım. Dilerseniz sitesindeki [diğer yöntemlerle](https://www.keycloak.org/getting-started) de ayağa kaldırabilirsiniz. Komut satırından çalıştıracağımız script;

    docker run -p 8080:8080 -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin jboss/keycloak

Bu scriptte iki environment parametresi geçiyoruz. Bunlar admin arayüzüne giriş yapabilmemiz için gereken kullanıcı adı ve şifre parametreleri. Son olarak admin konsoluna erişebilmek için da 8080 portunu expose ettik. Kısa bir süre sonra Keycloak aşağıdakine benzer bir satır ile ayağa kalktı.

	[org.jboss.as] (Controller Boot Thread) WFLYSRV0025: Keycloak 9.0.3 (WildFly Core 10.0.3.Final) **started in 19710ms** — Started 683 of 988 services (701 services are lazy, passive or on-demand)

Bu noktadan sonra [http://localhost:8080](http://localhost:8080) 'e gittiğimizde aşağıdaki gibi bir görüntü ile karşılaşıyoruz.

![](https://miro.medium.com/max/1604/1*HfcW4RZX-vMzq_sDJGSFcw.png)

**“Administration Console”** yazısını tıklayarak login ekranına gidiyoruz.

![](https://miro.medium.com/max/1601/1*9FMWNVIplbwouR5JW9w9wQ.png)

Docker komutuna verdiğimiz **kullanıcı adı** ve **şifre** ile giriş yapıyoruz.

### 2.2. Realm

![](https://miro.medium.com/max/1599/1*s5CNmgh4VPZUGwT_smyxBg.png)

Realm’imizi yaratıyoruz. Kabaca birbirleriyle etkileşim içerisinde olacak uygulamaların bir arada olacağı bir environment gibi düşünülebilir. **Add realm** butonuna tıklayıp isim veriyoruz ve bu aşamayı sonlandırıyoruz.

![](https://miro.medium.com/max/1603/1*AIxIp1js0VkCAduCDrCKag.png)

### 2.3. Roles

Sırada rollerimizi yaratma adımımız var. İki role, user-role ve user2-role yaratacağız. Bunun için menüden **Roles** başlığına gidiyoruz.

![](https://miro.medium.com/max/1604/1*iuw1-4OLuR2qEtRvDRILPA.png)

**Add Role** butonuna basarak rolü yaratıyoruz.

![](https://miro.medium.com/max/1603/1*b7zL2z1MYVmISpLm80Tuow.png)

İki rolü de aynı şekilde yarattıktan sonra son görüntümüz aşağıdaki gibi olmalı.

![](https://miro.medium.com/max/1600/1*Pn1M0g7Xne6Gz0P9RfVWxA.png)

### 2.4. Client

Artık uygulamamızın bağlanacağı bilgileri vereceğimiz Client’ımızı yaratmaya geçebiliriz. **Client** başlığını tıkladığımızda aşağıdaki gibi bir ekran geliyor.

![](https://miro.medium.com/max/1599/1*q-NI_6J0DgB1zhTiqS-YJQ.png)

Burada **Create** butonunu tıklayarak uygulamamıza client yaratacağız. Spring Boot uygulamaları default olarak 8080 portu ile ayağa kalkar. Keycloak da aynı portta ayağa kalktığı için bir çakışma olmaması için ilerleyen adımlarda uygulamamızın portunu 8088 olarak değiştireceğiz. Aşağıdaki bilgilerle uygulamamız için client’ımızı yaratıyoruz.

![](https://miro.medium.com/max/1600/1*kX1nqa-jFDvdaJ7leIbLXQ.png)

Sonraki adımımızda clientımızı yapılandırmamız gerekli. Bizim senaryomuz bir frontend uygulaması tarafından **Users** login edip onların ekran üzerindeki credentiallarıyla ilgili bir deneme yapmak değil. Servislerimizin sadece uygulamamıza verilen yetkiler kapsamında çağırılabildiğini test etmek istiyoruz. Bu sebeple **Access Type** alanımızı **confidential**, **Service Accounts Enabled** ve **Authorization Enabled** alanlarını **On** yapıyoruz. Aşağıya kaydırıp **Save** butonuna tıkladıktan sonra ekranda yeni tablarımız belirecek.

![](https://miro.medium.com/max/1599/1*110ZLxjsHUM_k_1-97utGg.png)

Kaydettikten sonra çıkan **Service Account Roles** tabına geçerek uygulamamıza yarattığımız rollerden **sadece user-role** rolünü veriyoruz.

![](https://miro.medium.com/max/1601/1*qpkaCXzZ6oYXW-H9MPhy6g.png)

Son olarak **Credentials** tabına giderek uygulamamız için yaratılan **Secret**’ı kopyalıyoruz. Bu secret’ı uygulamamıza vermemiz gerekecek.

![](https://miro.medium.com/max/1599/1*IyaUMl3klJMNCkb98BI6UA.png)

## 3. Spring Boot Uygulaması

Şimdi geçelim Spring Boot uygulamamıza. Spring Initializr’dan yeni bir uygulama alıyoruz. **Pom.xml**’imizin son durumu aşağıdaki gibi olmalı.

<script src="https://gist.github.com/mehmetcemyucel/d6a751385b90563df3cbbff4b3f96680.js"></script>

## 3.1. Consumable Rest Services

Sonrasında bir Controller yaratalım. İki farklı rol tarafından tüketilebilen iki servisimiz olsun.

<script src="https://gist.github.com/mehmetcemyucel/e85bc84c7e0c7317d90aed6beab0b377.js"></script>

**userRoleService** metodu Keycloak’ta yarattığımız rollerden **user-role**’e sahip olan client’lar tarafından çağırabilir. **userRole2Service** metodu ise sadece **user2-role**’e sahip clientlar tarafından çağırılabilir. Hatırlarsanız uygulamamız için yarattığımız client’a sadece ilk rolü tanımlamıştık. Madem öyle artık uygulamamızın **application.properties** dosyasının içerisinde Keycloak’u yapılandırmaya geçebiliriz.

### 3.2. Application.properties

<script src="https://gist.github.com/mehmetcemyucel/4124f1335a090f432a14ecbea73a3db8.js"></script>

Hatırlarsanız Keycloak ile uygulamamızın portlarını değiştireceğimizden bahsetmiştik. Bunun yanısıra Keycloak tarafından ihtiyaç duyulacak özellikler **keycloak** ile başlıyor. Uygulamamıza yaratılan client’ın adı, realmi gibi bilgiler burada bulunuyor. **auth-config** ile başlayan yapılandırmaları ise biz birazdan hem restTemplate’ımızı hem de FeignClient’ımızı konfigüre ederken kullanacağız.

### 3.3. Keycloak Configuration

Uygulamamızın Keycloak’u ve uygulamamıza erişim yöntemlerini yapılandırmak için aşağıdaki sınıfa ihtiyacımız var.

<script src="https://gist.github.com/mehmetcemyucel/ea3715d26d16d87479b9bbbef772aa80.js"></script>

Burada **PreAuthorize** annotation’ı kullanılan servislerin haricinde tüm servislere erişim hakkı vermemizin sebebi birazdan controller’ımıza ekleyeceğimiz yeni metodların direk erişilebilir olmasını istememizden kaynaklanıyor.

### 3.4. Test Rest Services

Controller’ımıza birkaç yapılandırma ekleyerek ilk eklediğimiz servisleri hızlıca deneyebileceğimiz servisler yaratıyoruz.

<script src="https://gist.github.com/mehmetcemyucel/297b54c01c06b2a95d5f91a8d88a33e1.js"></script>

test-rest-template servisine geçeceğimiz servis ismiyle ilk iki servisi direk çağırabiliriz. **FeignServiceClient** interface’inde de yine ilk yarattığımız servislerin imzaları bulunuyor. Bunları çağırabilmek için de test-feign-1 ve test-feign-2 servislerini yarattık. Ancak bunları çağırmadan önce restTemplate’ımızı ve FeignClient’ımızı OAuth2 kullanmak üzere yapılandırmamız gerekiyor.

{% include adshorizontal.html %}

### 3.5. RestTemplate Configuration

Application.yml’dan okuduğumuz değerlerle yapılandırmamızı yapıyoruz.

<script src="https://gist.github.com/mehmetcemyucel/e2bbe04188fe24c982db5aebc84deb01.js"></script>

### 3.6. Feign Client Configuration

Application.yml’dan okuduğumuz değerlerle yapılandırmamızı yapıyoruz.

<script src="https://gist.github.com/mehmetcemyucel/3d4c9e544ca12577a91baad328d7e825.js"></script>

## 4. Testler

Sonuçları gözlemlemek için [bu yazımda bahsettiğim](https://medium.com/mehmetcemyucel/spring-boot-rest-birim-entegrasyon-testi-43a7f9354a33) rest servis entegrasyon testi yöntemlerini de kullanabilirsiniz. Farkettiğiniz üzere ben bu yazımda doğrudan browserdan deneyerek gözlemlemeyi tercih ettim. Sonuç olarak 2si **restTemplate**, 2si **feingClient** olmak üzere deneyeceğimiz 4 farklı servis çağırımımız var. Aşağıya sonuçlarını ekliyorum.

### 4.1. RestTemplate Authorized

![](https://miro.medium.com/max/696/1*FEY06jm12WgP7IhoW9vNxw.png)

### 4.2. RestTemplate Unauthorized

![](https://miro.medium.com/max/741/1*qwhViagic8PQEd6sRJTXkw.png)

### 4.3. Feign Client Authorized

![](https://miro.medium.com/max/554/1*nas7-fEnQjP9hMX3EjHudA.png)

### 4.4. Feign Client Unauthorized

![](https://miro.medium.com/max/715/1*9DKU9ZfQIeD1bX5f_L4QHA.png)

<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- Yatay -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-3264551064582672"
     data-ad-slot="6687749939"
     data-ad-format="auto"
     data-full-width-responsive="true"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>

## 5. Sonuç

Yukarıdaki gibi bir entegrasyon ile Keycloak olsun olmasın tüm OAuth2 entegrasyonlarınızı kolay bir şekilde halledebilirsiniz. Refresh token, access token, veya expire konularını düşünmenize gerek kalmadan size hızlı entegrasyon sağlayacaktır. Keycloak ile bunun authorization kısmını da hazır ekranları aracılığıyla zahmetsizce yönetme imkanınız olacaktır. Uygulamanın kodlarına [buradan](https://github.com/mehmetcemyucel/springboot-keycloak) erişebilirsiniz.


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