---
title:  "12 Factor Nedir Türkçe ve Java Örnekleri"
date:   2019-02-06 20:04:23
categories: [java, microservices, cloud, architecture]
tags: [twelve factor, 12 faktör, cloud, microservice, mikroservis, java, codebase, maven, türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://cdn-images-1.medium.com/max/150/1*A0OnarMzmEUJWQeHTHCgig.png
---

12 Factor, ölçeklenebilir cloud uygulamaları geliştirebilmek için bir uygulamada olması önerilen 12 maddeyi tanımlayan bir manifestodur. [Heroku](https://www.heroku.com/)’nun kurucularından Adam Wiggins tarafından 2012 yılında ortaya atılmıştır. Orjinal metinlere [12factor.net](https://12factor.net/) ve [buradan(Türkçe)](https://12factor.net/tr/) adreslerinden erişilebilir. Bugün 12 Factor manifestosunu detaylı bir şekilde irdelemeye ve mümkün olduğunca Java dünyasından örneklerle açıklamaya çalışacağız.

## Giriş

Bilişimin dünyasının dilinin İngilizce olduğu su götürmez bir gerçek. Çünkü bu dil teknolojinin yoğun olarak üretildiği yerlerde oluşuyor. Biz de doğal olarak öğrendiğimiz, araştırdığımız bir çok konuyu İngilizce kaynaklardan ediniyoruz.

Ancak yeni bir konu hakkında öğrenmeye başladığımızda ana dilde girişi yapmanın, en azından temel fikirleri edinebilmenin vakit kaybını engellemek, yanlış sularda gezinme riskini azaltmak açısından kıymetli olduğunu düşünüyorum.

Aşağıdaki konu kendi sitesinde Türkçe olarak da yer almaktadır. Ancak çeviri akıcı bir dilde olmadığından ve anlaşılmasının nispeten güç olmasından dolayı daha yakın olduğumuz örneklerle farklı kaynaklardan da zenginleştirerek kaleme aldım. Aşağıdaki incelemelerde kavramların hem Türkçe hem İngilizce’sini açıklamalı olarak kullanmaya çalıştım. Temel terimlerin İngilizce karşılıklarının da bilinmesinin, en azından jargona hakim olunmasının faydası olacaktır.


![12 Factor App](https://miro.medium.com/max/873/1*A0OnarMzmEUJWQeHTHCgig.png)

12 Factor kendisini gündelik hayatta yaşanan problemlere karşı tecrübeler ve deneyimlerin oluşturduğu öneriler olarak tanımlamaktadır. Bu önerileri tanımladığı kavramlar üzerinden vermektedir. İnceleyeceğimiz 12 madde aşağıdaki gibidir;

1.  **Codebase** (Kod Tabanı)
2.  **Dependencies** (Bağımlılıklar)
3.  **Config** (Yapılandırma)
4.  **Backing Services** (Destek Servisleri)
5.  **Build, Release, Run** (Derleme, Sürüm, Çalıştırma)
6.  **Processes** (Süreçler)
7.  **Port Binding** (Port Bağlama)
8.  **Concurrency** (Eş Zamanlılık)
9.  **Disposability** (Kullanıma Hazır Olma Durumu)
10.  **Dev/Prod Parity** (Geliştirme/Üretim Ortamlarının Eşitliği)
11.  **Logs** (Günlükler)
12.  **Admin Processes** (Yönetici Süreçleri)

İleride detaylıca değinecek olsak da o noktaya gelinceye kadar birkaç anahtar kelimenin tanımını da yapmakta fayda var.

**12 factor uygulama:** manifestonun önerilerini sağlayan uygulama.

**Build(Derleme):** Kodların çalıştırılabilir bir pakete dönüştürüldüğü aşamadır.

**Release(Sürüm):** Derlenmiş kod ile o kodun çalışacağı ortamın yapılandırmasının(configuration) bir araya gelmiş halidir.

**Runtime(Çalışma Zamanı):** Sürmün bir ya da daha fazla parçasının çalıştırıldığı durumdur.

**Deploy(Dağıtım):** Uygulamanın çalışan bir örneğine verilen isimdir.

## 1. Codebase (Kod Tabanı)

12 factor uygulamanın kodları bir sürüm takip sistemi tarafından yönetilmelidir. Sürüm takip sistemine örnek olarak [Git](https://git-scm.com/), [Subversion](https://subversion.apache.org/) verilebilir. Sürüm takip sistemine kısaca **_repo_** denilmektedir. **Codebase** ise bir repoda saklanan uygulamamıza ait kodlar bütünüdür. Burada kritik konu, bir uygulama ile codebase arasında her zaman 1'e 1 (1:1) bir ilişki olmalıdır. Diğer senaryolarda:


![Codebase (12factor.net)](https://miro.medium.com/max/400/0*S0AmBMr45StqJSi-.png)

-   Eğer bir uygulamanın birden fazla codebase’i varsa aslında o bir uygulama değildir, farklı modüllere ve/veya process’lere sahip dağıtık bir sistemdir. Ve her bir process kendi içerisinde ayrı ayrı 12 factor’e uyumlu olmalıdır.
-   Eğer birden fazla uygulama tek bir codebase’i kullanıyorsa yine problem mevcuttur. Burada akla gelen ilk şey util tarzı kod yapılarının mevcudiyetidir. Bu tarz kodlar ayrı birer kütüphane haline getirilmesi ve bağımlılığın(bknz Dependencies) tanımlanması gerekir.

Bir java uygulamasından örnek verelim. 3 geliştirici 3 farklı **feature**’ı(yeni özellik) geliştirebilmek için Git reposundan 3 tane **branch**(kod çatalı) yarattı. Master ve Release branchlerimizin de var olduğunu düşünürsek bu branchlerin her birisi ayrı birer **deploy** konusu olarak tanımlanmaktadır. Ancak bu branchler için codebase’imiz tektir. Farklı sürümler için farklı versiyonlar, branchler oluşmuş olabilir. Bu versiyonlar proda çıkmak üzere farklı ortamlarda (dev/test/preprod/prod/…) commitlenmiş de olabilirler. Ancak büyük resime baktığımızda tüm bu farklı versiyonlar tek bir temel kodu, codebase’i paylaşmaktadırlar.

## 2. Dependencies (Bağımlılıklar)

12 Factor uygulamalar ihtiyaç duyduklarında harici kodları paketlenmiş olarak kendilerine dahil ederek kullanabilirler. Ancak buradaki kritik konu, bir uygulama herhangi bir harici kodu kendisinde kullanacaksa bunu açıkça tanımlanması ve kullandığını ifade etmesi gerekir. Aynı şekilde kullanılacak olan kod kendi içerisinde başka kodlara bağımlılık içeriyorsa bunların da tanımlanmış olması gerekir.

Bu süreci kontrol altında tutabilmek ve şeffaflaştırabilmek için bir **dependency isolation**(bağımlılık izolasyonu) araçlarına ihtiyaç duyulmaktadır. Örneğin bir [**Spring Boot**](https://projects.spring.io/spring-boot/) uygulaması paketleyeceğiz. Örnek pom.xml;

![](https://miro.medium.com/max/654/0*H27yPvItT4k-UnFz.png)

{% include feed-ici-yazi-1.html %}

Bu dependency hiyerarşisi için [**Maven**](https://maven.apache.org/)  aracı bu süreci paketleme aşamasında izolasyonu şu şekilde sağlamaktadır;

![](https://miro.medium.com/max/850/0*iuhWU9r0Z-noi91H.png)

Bu sayede dependency hiyerarşisinde hangi jar neye bağımlı bunun izolasyonu ve tanımı sağlanabilmektedir. Bu tanım **dependency decleration**(bağımlılık tanımlama) ile yapılmaktadır. Tanımlaması yapılmamış hiçbir bağımlılık uygulamanın içerisinde bulunmamalıdır.

Örnek olarak Eclipse üzerinde Maven kullanıyorsanız tanıdık gelecek **Dependency Hierarchy**(bağımlılık hiyerarşisi) örneğini verebiliriz. Dependency decleration’ın çıktısı olarak verilebilecek aşağıdaki ekran görüntüsü, uygulama üzerinde geliştirim yapmaya başlayacak yeni geliştiriciler için çok önemlidir. Codebase’in kolay ve hızlı bir şekilde derlenebilir hale gelmesi için değerli bir argümandır.

![Dependency Hierarchy
](https://miro.medium.com/max/800/0*W8gLDt38EwGMGzT6.jpg)


Bağımlılıklarla ilgili son konu, örneğin **curl** gibi sistem araçlarına ihtiyacımız varsa birçok sistemde zaten halihazırda bu aracın var olduğuna güvenerek ilerlenmemesi gerektiğidir. Var olan aracın versiyonunun uygulamamızla uyumlu olacağının garantisi olmadığı gibi bu araç o sistemde hiç var olmayadabilir. Bu sebeple uygulama eğer bir sistem aracına ihtiyaç duyuyorsa aynı diğer bağımlılıklar gibi bu araçların da uygulamaya sağlanması gerekmektedir.

## 3. Config (Yapılandırma)

Bir uygulamanın farklı ortamlara deploy edildiğinde codebase’i haricinde kalan her şey o uygulamaya ait **config**(yapılandırma) olarak tanımlanabilir. Buna;

-   Veritabanı, queue, ldap vs gibi servislerin tümü (Backing Services)
-   Tamamen dışarıdan sağlanan servisler(kimlik doğrulama servisi vb)
-   Hostname’ler, Credentials gibi geri kalan tüm yapılandırmalar örnek verilebilir.

Bu yapılandırmalar herhangi bir yerde bulunabilir. Bir YAML dosyasında, bir JNDI tanımında, System Properties altında veya Java’nın Environment Variables altında da tanımlanabilir. Önemli olan konu hiçbir yapılandırmanın codebase’in içerisinde yer almaması gerektiği konusudur. Burada kastedilen yapılandırma Spring Bean’lerinin tanımlandığı xml dosyaları değildir! Bu uygulama yapılandırmaları farklı ortamlara deploy esnasında değişmeyen yapılandırmalardır. Anahtar kavram, farklı ortamlarda farklılaşan hiçbir şeyin kodun içerisinde yer almaması gerektiğidir.

12 Factor, yapılandırmaların environment variables(ortam değişkenleri) üzerinde saklanmasını önermektedir. Sebebi, bu değişkenlerin kolay bir şekilde değiştirilebilmesi, yanlışlıkla yapılabilecek bir codebase müdahalesinden uzak olması ve herhangi bir programlama diline spesifik yapılandırmalardan etkilenmemesidir. Örneğin Java’da sistemin tanımlı olduğu Dil ve Bölge ayarlarına göre farklı sonuçlar oluşabilmektedir. Bu tarz bir etkiden uzak durulması gerekmektedir.

Son olarak dev-test-prod gibi farklı ortamlarda farklı isimlerle ele alınan yapılandırmalar kabul edilmemektedir. Örneğin dev-home-path, test-home-path,… şeklinde prefix-suffix’lerle yapılan parametre tanımları yapılmamalıdır, bu şekilde bir parametre gurubundan sanal bir environment(ortam) yapılandırma seti yaratılmamalıdır. Çünkü bu sistem yönetilebilir bir yöntem değildir.

# 4. Backing Services (Destek Servisleri)

Bir uygulamanın çalışabilmek için ihtiyaç duyguğu tüm servislere **backing**  **service**(destek servisi) olarak tanımlabilir. Bir uygulama dışarıdan servis alıyorsa bu servisler yerel servislerden ayrı tutulmaz. Tümü bir bütün olarak ele alınır. Aşağıdaki örnekte MySQL, eMail, Amazon S3, Twitter birer destek servisidir.


![Backing Services (12factor.net)](https://miro.medium.com/max/800/0*tqFQCbfKO01R5sN1.png)

{% include feed-ici-yazi-2.html %}

Bir uygulama eğer destek servisi kullanıyorsa bunu mutlaka config içerisinde belirtmesi/yapılandırması gerekir. Sebebi, uygulama runtimeda servis aldığı provider’ı değiştirmeyi tercih ederse bunu kod değiştirmeden yapabilmesi gerekmektedir, bunu da config üzerindeki yapılandırmayı değiştirerek sağlar. Hatta yapılan bu config değişikliği uygulama restart olmadan uygulanabilir durumda olmalıdır.

Örneğin veritabanı servisi alınan node’lardan birisi problem yaşadığı takdirde admin bu db’yi backup’tan dönme ihtiyacı duymuş olabilir. Bu sırada hiçbir kod değişikliği olmadan farklı bir node üzerinde yeni bir db node’u ayağa kaldırmış olabilir. Varolan runtime’lar yapılandırmada yapılacak değişiklikleri restart almadan uygulayabildiği takdirde tamamen **loosely coupled**(gevşek bağlı) olacaklardır. Bu esneklik **scalable**(ölçeklenebilir) sistemler için hayati değere sahip bir konudur.

## 5. Build / Release / Run (Derleme / Sürüm / Çalıştırma)

Bir codebase 3 aşamada **deploya**(dağıtıma) dönüşebilir;

![Build Release Run (12factor.net)](https://miro.medium.com/max/500/0*U3DHlTMRePCdDzvA.png)

-   **Build(derleme):** Kodların çalıştırılabilir bir pakete dönüştürüldüğü aşamadır. Bu aşama kodun versiyonlama aracındaki commitlenmiş versiyonu ve bağımlılıklarının bir araya getirilerek binarylerin compile edildiği aşamadır.
-   **Release(sürümleme):** derlemenin çıktısı ile mevcut ortamdaki yapılandırmaların bir araya getirildiği aşamadır. Bu aşamada kod, çalışma ortamında çalışmaya hazırdır.
-   **Runtime(çalışma):** ilgili sürümün bir ya da daha fazla parçasının başlatılarak çalıştırıldığı halidir.

12 Factor’e göre bu 3 aşamanın birbirinden net bir şekilde ayrılması gerekir. Bu süreci yönetebilmek için de deployment süreçlerinin pipeline’lar ile tanımlanabildiği sürüm yönetim araçlarıyla yönetilmesi gerekmektedir.

Sürümler tekil olarak tanımlanabilmelidir ve arşivlenebilmelidir. Bir problem anında kolay bir şekilde bir önceki sürüme dönülebilmelidir. Bir sürüm bir kere oluştuktan sonra üzerinde değişiklik yapılamaz, yani **immutable**’dır. Bir problem veya düzeltilmesi gereken şeyler yeni sürüm ile ele alınır.

Bir developer, değişikliğini yeni kodlarla birlikte paketleyerek süreci başlatır. **Continuous Integration (CI)** ve **Continuous Deployment (CD)** araçları ile sürümlenen kod runtime’a doğru yol almalıdır. Stabiliteyi sağlamak için runtime’a mümkün olduğunca az müdahale edilmeli, hareketlilik azaltılmalıdır. Bir developer kendi lokalinde çalışırken yarattığı heyecanlı ve enerjik geliştirme/deneme ortamının execution environment’ında devam etmemesi gerekmektedir.

## 6. Processes (Süreçler)

Uygulamalarımız runtime’da en az 1 süreç barındıracak şekilde çalışırlar. 12 Factor bir uygulamada en önemli konu bu processlerin **stateless**(durumsuz) ve **shared-nothing**(bir şey paylaşmayan) olmasıdır.

Stateless, birkaç adımdan oluşan bir işlemin adımları arasındaki oluşan geçici durumun(state) bellekte, session’da saklanmaması gerektiğini savunan yaklaşımdır.

Bir örnekle açıklayalım. Bir müşteri oluşturma adımlarını içeren akışımız olsun. Ekrandan bilgileri bir widget yardımıyla alırken arkada backing services yardımıyla kimlik doğrulama, müşteri bilgileri alma, vb bir çok adım gerçekleştirdiğimizi varsayalım. Ölçeklenebilir bir mimaride size bu hizmeti aynı anda verebilecek çok fazla aktif node olabilir. Sizin işleminizin gerçekleşeceği adımların her birinde requestleriniz bu node’lardan farklı birisine düşme olasılığı çok fazladır.

Aşağıdaki görselde browserdan yaptığınız ilk adım müşteri tanımlama 1 node’una düştü ve kimlik doğrulama 2 servisinden hizmet alarak müşteri tanımlama işleminin ilk adımını gerçekleştirdiniz. ikinci adımda ekrandan kimlik bilgilerinin toplandığını varsayalım. Bu hizmet için müşteri tanımlama nodelarından hangisine düşeceğinizin garantisi yoktur. Hatta siz birinci adımı gerçekleştirirken ekranda bilgileri girdiğiniz sürede ilk adımda hizmet aldığınız müşteri tanımlama 1 node’u kapanmış onun yerine 4 ve 5 numaralı nodelar açılmış bile olabilir. Mimarinin ölçeklenebilir olması ile ifade edilen budur; sıkışan, cevap veremez duruma gelmiş nodeların olduğu bir ortamda execution environment yeni 3 node daha eklemeyi tercih edebilir. Yatay ölçekte artan işlem gücü sistemin üzerindeki yükü dinamik olarak dengelenmeye yönlendirebilir, bu sebeple herhangi bir adımda işlem yükü olarak daha sakin bir node’a yönlendirilmeniz gayet mümkündür.


![Dağıtık, Ölçeklenebilir Sistem](https://miro.medium.com/max/500/0*D6ztgImCZq17uNe1.png)

Birçok klasik uygulama mimarisinde **sticky session**’lar kullanılmaktadır. Sticky sessionlar load balancer’ın IP’ler veya cookieler aracılığıyla kullanıcıları tanıyıp, bir kullanıcıdan gelen requestlerin düzenli olarak tek bir sunucuya yönlendirilmesini sağlamaya yararlar. Az önce session kullanımının 12 Factor bir uygulamada olmaması gerektiğini çünkü her bir requestin hangi node’a iletileceğini bilemeyeceğimizi söylemiştik. Sticky session gibi bir kavram varsa aslında bu problemimiz çözülmüş gibi duruyor, o zaman artık session kullanabilir miyiz? Cevabımız: Hayır. Çünkü 12 Factor bir uygulama sticky session da kullanmamalıdır. Çünkü bu kez de arada bulunan load balancerın bu session verilerini sürekli tutacağını garanti altına almamız gerekir ki bu mümkün değildir. Load balancerın yaşayacağı bir problemde sticky session bilgileri kaybedilebilir, 5 adımlık bir sürecin 3. adımına gelmiş bir uygulama akışı o noktada doğru çalışmaz duruma gelebilir. Bu durum **single point of contention** prensibine aykırıdır.

Peki stateless ve sharing nothing prensiplerine yönelik sistemimizi tasarladık. Ama hala bizim oturum bilgilerini, verileri, nesneleri saklama ihtiyacımız var. Bu verileri nasıl saklayacağız? Cevabımız, bu kalıcılığı DB veya cache çözümlerinde saklamak. Akla gelen ilk soru, bu çözümlerin bir **bottleneck**(dar boğaz) yaratıp yaratmayacağı sorusu. DB ve cache çözümleri ölçeklendirme noktasında çok daha başarılı çözümlerdir. İş sürecine dair gerçekleştirilen her adım db’ye işlenebilir. Veya **NFS**(ağ dosya sistemleri) üzerinden de bu **persistence**(kalıcılık) sağlanabilir. Daha performans gereken noktalarda uygulamanın doğasıyla örtüştüğü seviyede cache çözümleri ile de ilerlenebilir.

Process’lerle ilgili son bir dipnot, buffering kullanımı yukarıdaki hiçbir prensiple çakışmamaktadır. Yani uygulamanızda bir dosya download veya upload edecekseniz, bu dosyanın bufferlanarak transferinin gerçekleşmesi yukarıdaki prensiplerin hiçbirisine aykırı değildir, gerçekleştirilmesinde bir sakınca yoktur.

{% include feed-ici-yazi-3.html %}

# 7. Port Binding (Port Bağlama)

Web uygulamaları çoğu zaman çalışabilmek için bir **container**a(taşıyıcı) ihtiyaç duyarlar, Java dünyasından örnek verirsek Tomcat bir web container’dır. Yazdığımız bir uygulama Tomcat üzerinden publish edileceğinde hangi porttan yayın yapacağı gibi yapılandırmaların yapılması gerekecektir. 12 Factor bir uygulama tamamen bağımsız, kendi kendine servisi sunabilecek, belirli portları dinleyebilecek şekilde container üzerinde runtime injectionlara, yapılandırmalara ihtiyaç duymadan çalışabilmelidir. Özetle bir uygulamanın containerla çalışabilmesi üzere yapılandırmaların development aşamasında yapılması gerekmektedir.

Spring Boot gibi **uber jar** export eden yapılar bu ihtiyacın çözümünü kolaylaştırmaktadırlar. Ayağa kaldırdığı Tomcat üzerinde yazılan kodu publish ederek runtime yapılandırmalarının tamamını development zamanında yapılmasına olanak sağlamaktadırlar. Bir örnek vermek gerekirse, 389 portundan hizmet veren bir ldap backing service’imiz olsun. Uygulamamızın deploymentı gerçekleşirken routing hizmeti veren başka bir backing service uygulamasına(örn: **service discovery**) abone olacak, bundan sonra gelen her request routing servisleri tarafından ayağa kalkan uygulamamızın 389 portuna yönlendirilecektir.

12 Factor’ün kendi sitesinde geçen bir cümle şu şekildedir, “The web app exports HTTP as a service binding to a port, and listening to request coing in on that port”. Buradan **HTTP** ve **HTTPS** **tercihi** noktasında HTTP taraflı yorum yürütmek mümkündür. Ancak aynı başlığın altındaki başka bir cümle de şu şekildedir, “HTTP is not the only service that can be exported by port binding.” Bu noktada gri alan mevcuttur, net bir yorum yoktur. Ayrıca **XMPP**, **Redis protocol** gibi başka protokollerin de port binding başlığı altında kabul edilebileceği belirtilmiştir.

# 8. Concurrency (Eş Zamanlılık)


![Concurrency (12factor.net)](https://miro.medium.com/max/500/0*V-OJYDRfPYq78sIM.png)

Aslında concurrency’nin konularının bir kısmına önceki başlıklarda değindik. Bir uygulama en az 1 processten oluşmaktadır. Tabii ki ölçeklenebilir bir sistemde bu process sayısı 1 ile kalmayacaktır. Uygulama geliştirici uygulamasındaki farklı processleri tiplerine göre gruplandırarak farklı iş yüklerini ayrı ayrı yönetmeyi tercih edebilir. Örneğin ön yüz ile ilgili processleri web processleri olarak gruplandırıp ve ölçeklendirip, backend’de daha uzun süren işlemleri worker process grubu altında toplayarak ayrı şekilde ölçeklendirecek bir mimari kurgulayabilir.

Örneğin uygulamamızın [**slashdot-effect**](https://www.google.com.tr/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwidppHasOvZAhVMjCwKHXQfDnkQFggoMAA&url=https%3A%2F%2Ftr.wikipedia.org%2Fwiki%2FSlashdot_etkisi&usg=AOvVaw1C0-ZUS0-qxr_UP85O7bvg)’e maruz kaldığını varsayalım. Uygulamanın processlerini bu şekilde ele almak yoğun yük altında bu sistemin **bottleneck**(dar boğaz) yaşadığı process grubunda ölçekleri büyüterek eldeki işlem gücü kaynağının sıkışan noktada kullanılması konusunda esneklik sağlayacaktır. Ayrıca processler çökmüş veya cevap veremez hale gelmiş ise, ürettiği output streamlere(loglar) göre stabilitesi bozulmuş ise süreç yönetici araçlar veya kişilerce kapatılabilecek, tekrar başlatılabilecek yapıda kurgulanmalıdır. Son olarak 12 Factor bir uygulamada processler **daemon** olarak tanımlanmamalıdır. Daemon kavramı ile ilgili yazıma [buradan](http://www.mehmetcemyucel.com/2015/08/java-daemon-thread.html) göz atabilirsiniz.

# 9. Disposability (Kullanıma Hazır Olma Durumu)

12 Factor bir uygulamada processler anlık bir tetikleme ile başlatılabilir veya durdurulabilir yapıda olmalıdır. Kendisine gelen requestleri de kayıpsız şekilde işleyebilmelidir. Çok basit gibi gözüken bu cümle aslında bir o kadar komplekstir.

Processlerin kapanması **gracefully** gerçekleşebildiği gibi anlık bir kesinti ile de gerçekleşebilir. Anlık bir kesinti yaşandığını varsayalım, process’imize gelen requestin asla kaybedilmemesi gerekir. Bu tarz bir sistemi kurgulayabilmek için çoğu zaman arka planda bir kuyruklama mekanizmasına ihtiyaç duyulacaktır, örneğin uygulamanız crash oldu ve requesti sonuçlandıramadıysa belirli bir timeout süresi sonrasında bu requesti tekrar kuyruğa bırakabilecek yapılar kurgulanmalıdır. Bu sebeple processlerin arkasında güçlü bir back queueing mekanizması kurgulanması gerekir. Bu kayıpsız mimari [Crash-only design](https://lwn.net/Articles/191059/) konseptinin bir çıktısı olarak incelenebilir.

Processlerin kapanması kadar açılması süreci de önemli bir konudur. Processlerin mümkün olduğunca hızlı ayağa kalkabilmesi uygulamanın **robustness**(sağlamlık) görüntüsü üzerinde majör öneme sahiptir. Örneğin bir yük altında **scale up** edeceğiniz bir process 10 sn içerisinde açılabiliyorsa son kullanıcılar sistemde oluşan yükten dolayı yavaşlığı neredeyse hissetmeyecektir. Ancak 3 dk içerisinde anca scale up edilebilen bir process’de kullanıcılar yeni processler yetişinceye kadarki bu sürede mevcut processlerin yavaşlığını hissedecektir ve uygulamanın kullanıcı gözündeki robustness görüntüsü sarsılacaktır.

# 10. Dev/Prod Parity (Geliştirme/Üretim Ortamları Eşitliği)

12 Factor dev/test/prod gibi ortamlarda oluşan **gap**’leri(farklılıkları) 3 başlık altında inceliyor ve mevcuttaki geliştirim yaklaşımlarını şu şekilde tanımlıyor;

-   **Zaman Gap’i:** Bir geliştirici bir sürüm oluşturmak için kod üzerinde haftalarını, aylarını geçirmesi gerekebiliyor
-   **Personel Gap’i:** Geliştirilen sürüm developer tarafından geliştiriliyor ama devops mühendisi tarafından deploy ediliyor.
-   **Tool Gap’i:** Örneğin prod ortamda DB olarak Oracle kullanılırken geliştiriciler daha hızlı ve rahat geliştirim yapabilmek, kurulumlarıyla ve yönetimiyle uğraşmamak adına kendi lokalinde SQLite kullanmayı tercih edebiliyor.

Bu farklılıkların mevcut sistemde problemlere yol açtığından dolayı 12 Factor development ve production arasındaki bütün bu farklılıkların minimize edilmesi gerektiğini ifade eder. Yani:

-   Developer geliştirdiği kodu dakikalar içerisinde deploy edebileceği bir kurgu (test driven development ve test automation’ın önemi burada devreye giriyor)
-   Developer kodun deploymentı süreciyle de yakından ilgili olmalıdır (Continuous Integration-CI ve Continuous Deployment-CD pipeline’ları developer tarafından takip edilmeli/yürütülmelidir)
-   Development ve Production ortamları arasındaki araçlar mümkün olduğunca aynı tutulmalı, farklılık minimize edilmeldir.

<script src="https://gist.github.com/mehmetcemyucel/176564085f316fef2b5b6835a06aab91.js"></script>

{% include feed-ici-yazi-1.html %}

Özellikle development ortamının production ortamıyla aynı şekilde kurgulanması zor gibi gözükse de günümüzdeki container teknolojileri(Vagrant, Docker gibi) sayesinde bu büyük bir problem olmaktan çıkmıştır. Buraya yapılan yatırım continuous deployment’ın faydasıyla kıyaslandığında daha düşüktür.

# 11. Logs (Günlükler)

12 Factorde loglar bir **stream**(akış) olarak ele alınmaktadır ve yapısının nasıl olması gerektiği ile ilgili bir yorum barındırmamaktadır. Ancak processlere yük getirmeyecek ve darboğaz olmayacak şekilde tamponlama olmaksızın **stdout**’a basılmasını önermektedir.

Loglar historik inceleme, bir event logu bulma, processlerin eğilimlerinin tespiti, otomatik alarm mekanizmaları kurulması gibi amaçlarla dosyalara yazılabilir. Ancak 12 Factor bu logların depolanması, arşivlenmesi, analitik incelemesi, yönlendirilmesi gibi konuları processin tamamen kendisinin dışında tutmaktadır. Yazılan loglar execution environment tarafından yakalanıp Splunk gibi log indexleme toollarına alınabilir veya big data sistemlerine taşınarak bu data üzerinde çalışmalar yapılabilir. Ancak bu şekilde çalışmalar yapılacaksa bunlar processlerin içerisinde yapılmamalı, ayrı backing serviceler tarafından gerçekleştirilmelidir.

# 12. Admin Processes (Yönetici Süreçleri)

Concurrency başlığındaki bahsettiğimiz işlemler yönetimsel olarak zaten ihtiyaç duyulan processlerdir ve otonom kurgulanmış süreçlerle sistem toolları kullanılarak karşılanmalıdır. Bunların haricinde üzerinde durulması gereken kritik nokta, bir kereye mahsus çalıştırılması gereken işlerin ne şekilde yönetilmesi gerektiği konusudur.

Örneğin veritabanında bir kereye mahsus bir migration scripti çalıştırılacaksa bunun manuel çalıştırılması farklı ortamların(örneğin dev/test) birbirleri ile arasında bir gap oluşumuna sebebiyet vereceği için yapılmamalıdır. Codebase’in sağlığı gözetilmelidir.

Developer geliştirim esnasında bu işi elle çalıştırabilir. Ancak sonraki ortamlara deploy edilecek olan bu iş script haline getirilmeli ve standart dağıtım adımlarından geçirilmelidir. CI/CD adımlarında SSH gibi uzaktan bu scriptin çalıştırılabileceği otomatik adımlar aracılığıyla bu işlerin bir kereye mahsus da olsa farklı ortamlarda dağıtımı sağlanmış olur.

# 13. Beyond the 12 Factor

2012'de 12 Factor paylaşılmış olsa da o günden bu güne eklenmesi ihtiyaç duyulan başka maddeler de olmuştur. Sektörün önde gelen isimlerinden Pivotal firmasında Solution Architect olarak çalışan Kevin Hoffman’ın kitabında ek 3 başlık daha ele alınmaktadır. Bu 3 başlık;

- API First
- Telemetry
- Authentication &amp; Authorization başlıklarıdır

Daha detaylı bilgi için kitaba [buradan](https://content.pivotal.io/ebooks/beyond-the-12-factor-app) ulaşabilirsiniz.
