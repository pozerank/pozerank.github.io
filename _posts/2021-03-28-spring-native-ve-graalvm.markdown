---
title:  "Spring Native ve GraalVM"
date:   2021-03-28 13:04:23
categories: [mimari, java, spring, jvm, spring boot, maven, graalvm]
tags: [native, spring native, java, spring boot, graalvm, mikroservis, microservice, kubernetes, ahead of time, just in time, compiler, native, image, docker, türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://miro.medium.com/max/150/0*rSA-gwY01_KDq7Nk
---

[“Spring ve Java Hantal Mı - GraalVM ve Quarkus’a Giriş”](https://www.mehmetcemyucel.com/2019/Spring-ve-Java-Hantal-Mi-GraalVM-ve-Quarkus-Inceleme/) yazımızda Java’nın tüm platformlarda çalışabilmesi için göz yumduğu şeylerden ve buna bir çözüm olarak ortaya atılan [GraalVM](https://www.graalvm.org/)’den ve nasıl çalıştığından bahsetmiştik. GraalVM’in [Spring dünyası](https://spring.io/) ile birlikte çalışabilmesinin güç olduğuna değinmiş ve [Quarkus](https://quarkus.io/) ile neler yapılabileceğini incelemiştik.

Aradan geçen yaklaşık 1,5 senelik süre zarfında Spring cephesinde bu konu hakkında gelişmeler oldu. Bugünkü yazımızın konusunu oluşturan bu gelişmeleri, birlikte çalışmasının neden güç olduğunu ve buna çözüm olarak nelerin yapıldığını birlikte inceleyelim.

## 1. Spring Native Beta Release

![Spring Native](https://miro.medium.com/max/1500/0*rSA-gwY01_KDq7Nk)

Spring.io blog’unda yayınlanan [yazıyla](https://spring.io/blog/2021/03/11/announcing-spring-native-beta) önceleri **Spring GraalVM Native** isminde duyduğumuz yaklaşık 1,5 senedir devam eden projeyi [**Spring Native**](https://github.com/spring-projects-experimental/spring-native)  ismiyle **Beta Release** olarak **11 Mart 2021** tarihinde duyurdu. Duyuruda en başından beri Java Sanal Makinesi’ne(JVM) verilen desteğin artık native image derlemeye olanak sağlayan GraalVM için Java ve Kotlin dilleri ile verileceği haberi yer alıyor.  
  
Bu haber şu anlama geliyor, Spring projenize dair hazırladığınız **native image ile artık JVM olmadan da çalışabilir, 100ms gibi bir sürenin altında uygulamanız ayağa kalkabilir ve daha düşük memory tüketimi ile daha yüksek performansı elde edebilirsiniz**! Bütün bunların nasıl gerçekleştiği bilgisini tazelemek için [önceki yazıya](https://www.mehmetcemyucel.com/2019/Spring-ve-Java-Hantal-Mi-GraalVM-ve-Quarkus-Inceleme/) göz atabilirsiniz.  
  
Peki neydi bugüne kadar bunların kullanılmasının önündeki engel ve bütün bu özellikleri kullanabilmek için neler yapılması gerekiyor?

## 2. Dynamic Proxying

**Spring AOP** (aspect oriented programming), **Code Generation Library** (cglib) isminde kütüphane yardımıyla projelerin compile aşamasından sonra dahi classların yaratılabilmesi ve manipule edilebilmesini sağlamaktaydı. Bu işleme **Dynamic Proxying** ismi verilmektedir. JDK’nın içerisinde de dinamik proxyler mevcuttur, tercihe göre bunlar da kullanılabilmektedi. Özetle çalışmakta olan programınız runtimeda yeni sınıfları belleğe yükleyebilir yetenekte oluyordu. Bu da Spring’in modüler ve dinamik yapısının altında yatan gizli baş kahramandı. **Hibernate**, **Mockito** gibi popüler bir çok framework de benzer yöntemleri kullanmaktadır.

Dynamic proxying’i daha iyi anlamak için bir örnek üzerinde inceleyelim.

<script src="https://gist.github.com/mehmetcemyucel/66fcefdfae3e4253575d2a807f688399.js"></script>

Örneğin yukarıdaki gibi bir sınıfın proxying yapılmadan, en düz hali ile çağırımı aşağıdaki gibi olacaktır.

<script src="https://gist.github.com/mehmetcemyucel/9321ed43d64861f78fba18d69053ea7b.js"></script>

![https://docs.spring.io/spring-framework/docs/3.0.0.M3/reference/html/images/aop-proxy-plain-pojo-call.png](https://miro.medium.com/max/585/0*OykR-WXKzbxfHFYK.png)

Bunun yerine tüm kontrolün bir dynamic proxy aracılığıyla Spring’e devredildiği senaryo için aşağıdaki örnek incelenebilir.

![https://docs.spring.io/spring-framework/docs/3.0.0.M3/reference/html/images/aop-proxy-call.png](https://miro.medium.com/max/635/0*Tnc7upVkLUrnai_S.png)
<script src="https://gist.github.com/mehmetcemyucel/bf5e02c78570d6d1a3baa670f62be33d.js"></script>

Farkettiyseniz SimplePojo sınıfındaki metodumuzda değişiklikler gerçekleşti. Ancak bizim yazdığımız kodlarda bu şekilde bir implementasyon yapmıyoruz, proxy sınıflarından haberdar olmadan geliştirimlerimizi yapıyoruz. İşte bu noktada Spring AOP devreye girerek az önce bahsettiğimiz dinamik sınıf değişikliklerini gerçekleştiriyor ve belleğe bu şekilde yüklenmesi gibi fonksiyonları yerine getiriyor.

## 3. Projenin Yapısı

[https://start.spring.io/](https://start.spring.io/) sitesinden inceleme amacıyla **Spring Native Beta** projesi yaratalım. Dependencies’i tıkladığımızda aşağıdaki gibi en başta geldiğini görebiliriz.

![Spring Native proje oluşturma](https://miro.medium.com/max/1503/1*uPfmqByjfzpW8Y6iBFrpTg.png)

[Önceki yazıda](https://www.mehmetcemyucel.com/2019/Spring-ve-Java-Hantal-Mi-GraalVM-ve-Quarkus-Inceleme/) **Just in Time** (JIT) derleyici ile **Ahead of Time** (AOT) derleyicilerin farklarından bahsetmiştik. JIT derleyicilerde dynamic proxying yapmak mümkün iken AOT derleyiciler çalışacağı platforma bağımlı kod ürettiklerinden dolayı runtime’da sürpriz(lazy loading) sevmezler. Her şeyin **build zamanında** netleştirilmesi ve native image’ın buna göre oluşturulması gerekmektedir. Spring Native projesinin ilk majör farkı burada başlamaktadır.

Bu durumda Spring Bean’leri arası bindinglerinin tamamlanabilmesi için bir çok adım build zamanına kaydırılmış oldu. Bu dönüşümlerin yapılabilmesi için de Maven, Gradle gibi popüler inşa araçlarında da düzenlemeler, yeni pluginlerin oluşturulması gerekliydi. Bu değişiklikleri incelemek için oluşturduğumuz projenin pom.xml dosyasını inceleyelim.

<script src="https://gist.github.com/mehmetcemyucel/65162a93194da9763d4f744216000750.js"></script>

Burada dikkat çeken 3 nokta bulunuyor. İlki Spring Boot Maven Plugin’deki image builder eki. Bu configuration sayesinde GraalVM tarafından çalıştırılacak native image çıktısı oluşturulabilecek. Bu plugin’in ekstra yapılandırmaları ve kullanımı için [burayı](https://docs.spring.io/spring-native/docs/current/reference/htmlsingle/#native-image-options) inceleyebilirsiniz.

{% include feed-ici-yazi-1.html %}

<script src="https://gist.github.com/mehmetcemyucel/6a3cbc883a4113f238216fa2e29527ff.js"></script>

İkinci nokta, Ahead of Time(AOT) derlemesi için yeni bir Maven Plugin’i. Bu plugin build anında Spring stereotype annotation’larını ve aslına bakılırsa tüm bean yapılandırmalarını [GraalVM’in manuel reflection yapılandırmasının](https://www.graalvm.org/reference-manual/native-image/Reflection/#manual-configuration) içerisine eklemeyi sağlayan plugin olarak düşünebiliriz. Bu plugin’in tetiklenmesi için kullanabileceğiniz maven goal’ü aşağıda da görebileceğiniz gibi `mvn spring-aot:generate` dir. Diğer konfigürasyonları için [burayı](https://docs.spring.io/spring-native/docs/current/reference/htmlsingle/#spring-aot-configuration) inceleyebilirsiniz.

<script src="https://gist.github.com/mehmetcemyucel/edb67b69ee7e1c19616f38e82feaacea.js"></script>

Pom.xml dosyasındaki son dikkat edilmesi gereken nokta ise versiyonlar. Şu anda Spring Native projesinin son versiyonu 0.9.1 versiyonu, Spring Boot 2.4.4'ü destekliyor. Java 8 ve 11 versiyonları ve GraalVM’in 21.0.0 versiyonu destekli. GraalVM’in Spring desteği verdiği versiyonlar [bu adresten](https://github.com/oracle/graal/labels/spring) Spring tag’ine sahip versiyonlar üzerinden takip edilebilir.

{% include feed-ici-yazi-2.html %}

## 4. Sonuç

Sonraki yazımızda bir Spring Native projesinin nasıl ayağa kaldırılabileceğini, IDE yapılandırmalarını, derlemeyi, Native Hint’lerini, proje performans karşılaştırmalarını ve son olarak hangi Spring Starter’ları ve çevresel Cloud Starter’ları ile birlikte kullanılabileceğini inceleyeceğiz.

<div class="PageNavigation">
    <p style="text-align:left;">
        {% if page.previous.url %}
            &laquo; <a href="{{page.previous.url}}">SSO SAML Kerberos User Federation</a>
        {% endif %}
        {% if page.next.url %}
            <span style="float:right;">
                Sonraki Yazı ><a href="{{page.next.url}}">Spring Boot ve Keycloak &raquo;</a>
        </span>
        {% endif %}
    </p>
</div>

**_En yalın haliyle_**

[**Mehmet Cem Yücel**](https://www.mehmetcemyucel.com)

---

**_Bu yazılar ilgilinizi çekebilir:_**

- [Spring Boot ve Keycloak](https://www.mehmetcemyucel.com/2020/Access-Management-5-Spring-RestTemplate-Feign-Keycloak/)

- [Alternatif JVM’ler ve Java’nın Geleceği Podcast’i](https://medium.com/mehmetcemyucel/alternatif-jvmler-ve-java-nin-gelecegi-podcast-i-6c1aa175e45b)
- [Bir Yazılımcının Bilmesi Gereken 15 Madde](https://www.mehmetcemyucel.com/2019/bir-yazilimcinin-bilmesi-gereken-15-madde/)

***Blockchain teknolojisi ile ilgileniyor iseniz bunlar da hoşunuza gidebilir:***

- [BlockchainTurk.net yazıları](https://www.mehmetcemyucel.com/categories/#blockchain)

***Ayrıca diğer kaynaklar(referans)***

- [spring framework docs](https://docs.spring.io/spring-framework/docs/3.0.0.M3/reference/html/ch08s06.html)
- [spring native docs](https://docs.spring.io/spring-native/docs/current/reference/htmlsingle)

---
