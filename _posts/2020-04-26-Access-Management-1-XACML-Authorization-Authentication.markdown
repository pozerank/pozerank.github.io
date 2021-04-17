---
title:  "Access Management 1-XACML Authorization Authentication"
date:   2020-04-26 17:04:23
categories: [mimari, security]
tags: [authentication, authorization, keycloak, xacml, sso, oauth2, oauth, openid connect, protokol, spring, security, türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://miro.medium.com/max/150/1*AevTigjmr7CmH-RV_OtzNA.png
---

Uygulama erişim kontrolü başlıklarına değineceğimiz birkaç yazıdan oluşacak serimizin ilkinde mimari olarak erişim kontrolünün [**XACML**](http://docs.oasis-open.org/xacml/3.0/xacml-3.0-core-spec-os-en.html)  ile nasıl ele alındığını inceleyeceğiz.

---

**--SERİNİN DİĞER YAZILARI--**

 - [1-XACML Authorization Authentication](https://www.mehmetcemyucel.com/2020/Access-Management-1-XACML-Authorization-Authentication/)
 - [2-OpenID OAuth2 OpenID Connect](https://www.mehmetcemyucel.com/2020/Access-Management-2-OpenID-OAuth2-OpenID-Connect/)
 - [3-SSO SAML Kerberos User Federation](https://www.mehmetcemyucel.com/2020/Access-Management-3-SSO-SAML-Kerberos-User-Federation/)
 - [4-Keycloak](https://www.mehmetcemyucel.com/2020/Access-Management-4-Keycloak/)
 - [5-Spring Boot ve Keycloak](https://www.mehmetcemyucel.com/2020/Access-Management-5-Spring-RestTemplate-Feign-Keycloak/)

---

## 1. Access Management Serisi

İkinci yazımızda [**OAuth Protokolü**](https://oauth.net/), [**OpenID**](https://openid.net/) ve [**OpenID Connect**](https://openid.net/connect/) yaklaşımlarını inceleyeceğiz. Nedenleri ve sonuçlarıyla dünden bugüne nasıl evrimleştiğini, hangi teknolojilerin hayatımıza dahil olduğunu göreceğiz.

Üçüncü yazımızda **SSO, SAML, Kerberos, User Federation** gibi kavramları inceleyeceğiz.

Dördüncü yazımızda [**Keycloak**](https://www.keycloak.org/)  uygulamasından bahsedecek, örnekler yapacağız.

Beşinci ve son yazımızda da [**Keycloak**](https://www.keycloak.org/) ile [**Spring Boot**](https://spring.io/projects/spring-boot) uygulamamızı [**Spring Security**](https://spring.io/projects/spring-security)**,** [**Feign Client**](https://spring.io/projects/spring-cloud-openfeign) **ve RestTemplate**’lar ile konuşturarak somut örnek gerçekleştirimi yapacağız.

{% include feed-ici-yazi-1.html %}

![XACML Authentication Authorization Policy Politika Erişim](https://miro.medium.com/max/696/1*AevTigjmr7CmH-RV_OtzNA.png)

Güvenli erişim problemini en başından incelemeye başlayalım. Bir uygulamanın sunduğu kaynaklara(servisler, ekranlar vb) erişirken herkesin sistem üzerinde her işi gerçekleştirebilmesini tercih etmeyiz. Bu tercihlerimizi **Erişim Politikaları (Access Policy)** ile yönetmeye çalışırız. Örneğin bir insan kaynakları uygulamamız olduğunu düşünelim. Kullanıcıların birbirlerinin maaş bilgilerini görebildiği, değiştirebildiği bir uygulamayı sanırım hiçbir şirket kullanmayı tercih etmezdi. Uygulamaya girişlerin ve girdikten sonra da farklı kaynaklara erişimlerin kontrol altında tutulmasını isteriz.

## 2. Authentication - Authorization

Öncelikle herkesin bu insan kaynakları uygulamasına giriş yapamaması bekleriz. Örneğin dış kaynak olarak çalışan, bordrosu başka bir şirkette olan, performans yönetimi kendi şirketi tarafından yapılan çalışma arkadaşlarımızın bu uygulamaya giriş yapmayacak şekilde uyarlanması gerekir. Bu işlemi **Kimlik Doğrulama (Authentication)** adımı ile gerçekleştirebiliriz. Yetkisi olmayan kullanıcılar uygulamaya giriş yapamayacaktır.

Sonrasında uygulamamıza giriş yapabilecek iki farklı ekibimiz olduğunu varsayalım. Birisi giriş ve güncellemeleri yapabilen İnsan Kaynakları ekibindeki arkadaşlarımız, diğeri de buradaki bilgileri takip eden, readonly olarak kullanan diğer bir Yazılım Ekibindeki arkadaşlarımız olsun. İki ekip de authentication adımını başarıyla tamamladıktan sonra uygulamanın farklı özelliklerini kullanabilir durumda olmalıdır. İşte bu noktada da **Yetkilendirme (Authorization)** adımı devreye girmektedir. Farklı kullanıcıların veya kullanıcı gruplarının uygulamanın hangi kaynaklarını ne ölçüde tüketebileceğinin tanımları bu adımda kontrol edilerek yetkisiz erişimlerin önüne geçilmeye çalışılmaktadır. Peki bu tanımlar ve kontroller nasıl gerçekleştirilmektedir?

{% include feed-ici-yazi-2.html %}

## 3. XACML

2003 yılında OASIS tarafından **Genişletilebilir Erişim Kontrolü Biçimlendirme Dili (XACML)** isimli bir standart yayımlandı. Bu standart, bir sisteme iletilen farklı niteliklerdeki erişim isteklerinin kural tabanlı politikalar tarafından nasıl esnek bir şekilde kontrol edileceğini tanımlayan mimari yaklaşımı içeriyordu. Tanım karışık geldiyse, özetle her türlü erişim isteğini kontrollü bir şekilde nasıl yönetilebileceğini tanımlayan mimari bir yaklaşımdı.

Bu yaklaşıma göre uygulamaya gelen erişim istekleri daha önceden tanımlanmış kurallar dahilinde kontrollü olarak uygulamanın kaynaklarına (bu bir görsel olabilir, bir servis olabilir veya bir kullanıcı ekranının tamamı olabilir) erişebilecektir.

Tanımlanmış sınırlar ile kastettiğimiz kavramı biraz daha açalım. Bir erişim isteğinin onaylanıp onaylanmayağına karar verebilmek için daha önceden tanımlanması gereken temel olarak 2 eleman vardır. Bunlar;

-   **Rules** (Kurallar)
-   **Policy** (Politika) veya birden fazla politikadan oluşan **Policy Set** (Politika Seti)

### 3.1. Kurallar (Rules)

**Kurallar**, erişimin sağlanabilmesi için gerekli şartları tanımlar. Bunun için

-   **Targets** (Hedefler),
-   **Conditions** (Koşullar),
-   **Obligations & Advices** (Yükümlülükler ve Öneriler) kullanır.

Örneğin uygulama üzerindeki /img/* altındaki kaynaklara **(targets)** readonly erişmek için **(conditions)** user rolüne sahip olunması **(conditions)** gerekir. Koşullar **(Obligations)** sağlanırsa erişim verilir **(advices)**, sağlanamazda istek reddedilir **(advices)**.

### 3.2. Politikalar (Policies)

**Politika**, bir ya da birden fazla kuralın birleşiminden oluşur. **Politika Setleri** ise birden fazla politikanın veya politika setinin oluşturduğu gruba verilen addır.

İşte yukarıdaki şekillerde uygulamamızın kaynaklarına hangi koşullarda erişilebileceğini tanımlamış olduk. Artık uygulamamıza gelen erişim isteklerini bu koşullara göre kontrol altına alabiliriz. XACML’ye göre oluşturulan bu erişim isteklerini işleyebilmek için 5 temel uygulayıcı nokta bulunuyor. Bunlar;

 - **PEP**: Policy Enforcement Point
 - **PDP**: Policy Decision Point
 - **PAP**: Policy Administration Point
 - **PIP**: Policy Information Point
 - **PRP:** Policy Retrieval Point

![](https://miro.medium.com/max/1155/1*7uQjo-WaAeJ-pyVYBupHdQ.png)

{% include feed-ici-yazi-3.html %}

#### 3.2.1. Policy Administration Point (PAP)

**PAP**; uygulamanızın kaynaklarına erişim için gelen isteklerin nasıl işlenebileceğini, politikaları tanımladığınız nokta.

#### 3.2.2. Policy Retrieval Point (PRP)

**PRP** (Policy Retrieval Point); tanımladığınız erişim yetkisi ilkelerinin, politikaların saklandığı nokta. Bir dosya sistemi veya genellikle bir veritabanı olabilir.

#### 3.2.3. Policy Enforcement Point (PEP)

**PEP**; uygulamamızın kaynaklarına erişim için gelen istekleri karşılayan nokta. Bu nokta gelen isteğin niteliklerini PDP’ye iletir ve ondan gelen cevaba göre isteğe izin verir veya reddeder.

#### 3.2.4. Policy Decision Point (PDP)

**PDP**; PEP’ten gelen erişim isteklerini PRP’deki politikalarla ve PIP’teki ekstra niteliklerle çarpıştırıp erişimin sağlanıp sağlanmayacağının kararını veren nokta.

#### 3.2.5. Policy Information Point (PIP)

**PIP**; sistemin geneline dair ekstra niteliklerin bulunduğu policy bazında tutulmayan bilgilerin bulunduğu nokta.

### 3.3. Örnek Akış

![](https://miro.medium.com/max/1690/0*I7Y-E74GSBmPQXMS.png)

Örnek bir istek akışını yukarıdaki görsel üzerinden inceleyelim.

1. adımda #123 kaydına ulaşmak için PEP’e istek gelir. PEP, uygulamalarımızın önündeki bir gateway olabilir, uygulamamızın kendisi olabilir veya dataya erişim önünde bağımsız bir kutu olabilir.

![](https://miro.medium.com/max/664/1*OMsLkndb7h-Ts6q8ZvfpYw.png)

2. adımda PEP PDP’ye #123 mesajının gönderilip gönderilemeyeceğini danışır.

3. adımda PDP PRP’den politikaları çeker

4. adımda PDP PIP’ten ekstra nitelikleri çeker.

5. adımda onay ya da red kararını alan PDP bu sonucu PEP’e iletir.

6. adımda PEP oluşan sonucu uygulamaya koyar ve kaynağa erişime izin verilir.

Örnek bir XACML istek ve cevabının görüntüsü de aşağıdaki gibidir.

<script src="https://gist.github.com/mehmetcemyucel/500ff775d5cc835e01a8979e0eea2923.js"></script>

<script src="https://gist.github.com/mehmetcemyucel/9c3a2ce90c5e111ec4f383514aef5fb5.js"></script>

## 4. Sonuç

Sonraki yazımızda **OAuth Protokolü, OpenID ve OpenID Connect** kavramlarını inceleyeceğiz. Yazıya [buradan](https://www.mehmetcemyucel.com/2020/Access-Management-2-OpenID-OAuth2-OpenID-Connect/) erişebilirsiniz.

<div class="PageNavigation">
    <p style="text-align:left; text-decoration: underline;">
        {% if page.previous.url %}
             <a href="{{page.previous.url}}">&laquo; Java’nın Geleceği Podcast’i</a>
        {% endif %}
        {% if page.next.url %}
            <span style="float:right; text-decoration: underline;">
                Sonraki Yazı ><a href="{{page.next.url}}">OpenID OAuth2 OpenID Connect &raquo;</a>
        </span>
        {% endif %}
    </p>
</div>

**_En yalın haliyle_**

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
