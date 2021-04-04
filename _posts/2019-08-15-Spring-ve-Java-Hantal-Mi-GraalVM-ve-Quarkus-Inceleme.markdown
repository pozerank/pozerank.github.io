---
title:  "Spring ve Java Hantal Mı - GraalVM ve Quarkus’a Giriş"
date:   2019-08-15 15:04:23
categories: [java, docker, jvm, spring, spring boot, quarkus, microservices, cloud, graalvm, mimari]
tags: [quarkus, java, spring boot, graalvm, mikroservis, microservice, kubernetes, ahead of time, aot, just in time, jit, compiler, native, image, docker, türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://miro.medium.com/max/150/0*mf0v1GtnXoEpVUN9.jpg
---
Bu yazımızda Java'nın tarihi gelişimini, günümüzde bulunduğu yeri, mikroservis mimarilere uyumunu ve GraalVM, LLVM ve Quarkus'un nasıl alternatifler yarattığından bahsedeceğiz.

## 1. Neden Java

Java yaklaşık 20 yıl önce ilk defa ortaya çıktığında büyük bir probleme çözüm getirme vaadiyle yazılımcıların dikkatini çekmişti. Vaat şuydu, bir yazılımcı farklı mimarilere sahip donanımların nasıl çalıştığını bilmesine gerek kalmayacaktı. Ve bütün bu ortamlar için ayrı ayrı kod yazmayacak, tek kod tüm ortamlarda çalışabilecekti. Bunu _“Write once, run anywhere”_ mottosuyla ifade ettiler. Derlenen kod [JVM](https://en.wikipedia.org/wiki/Java_virtual_machine) ismi verilen bir sanal makine üzerinde çalıştırılacaktı. Bu sayede geliştiriciler işletim sistemi, donanım ve benzeri ortamsal farklılıklardan etkilenmeyecekti.


![https://www.shkuri.com/sales-tips](https://miro.medium.com/max/1081/0*UUBgFXRohHc9S-CS)

## 2. Günümüzde Java

Java’nın sağladığı bu esneklik dönemin de şartları göz önünde bulundurulduğunda yazılım geliştiricilerin en tercih ettiği yazılım dillerinden birisi olmayı başardı. Peki halen bu şekilde mi devam ediyor? Bunun için güncel dillerin popülaritesi ile ilgili bir araştırma yaptım. Bu araştırmayı yaparken araştırma şirketlerince yapılan anketlerin taraflı olabileceği düşüncesini de dikkate aldım. Karşıma çıkan ve en tarafsız olduğunu hissettiğim çalışma [Redmonk](https://redmonk.com/) tarafından 2019 Q1'de yapılmıştı. [Stack Overflow](https://stackoverflow.com/) ve [Github](https://github.com/)’daki popülerlikler üzerinden yapılan çalışmanın grafiği aşağıdaki gibi:


![https://redmonk.com/sogrady/2019/03/20/language-rankings-1-19](https://miro.medium.com/max/1313/0*oti73UQpHd93KL66.png)

Görünüşe göre Java halen en popüler dillerden birisi olarak hayatına devam ediyor. Peki Java bunu nasıl başarıyor?

İlk günden bu yana Java yazılım diline [Java Specification Request](https://jcp.org/en/jsr/overview) (JSR) ismi verilen yeni özellikler [Java Community Process](https://www.jcp.org/en/home/index) (JCP) tarafından belirli standartlar gözetilerek eklendi. [Functional Programming](https://en.wikipedia.org/wiki/Functional_programming), [Nonblocking I/O](https://en.wikipedia.org/wiki/Non-blocking_I/O_(Java)) gibi popüler yazılım geliştirme paradigmaları da benzer şekilde dile kazandırıldı. Peki dil evrimine devam ederken JVM’de neler yaşandı? En önemli JVM fonksiyonlarından birisi olan garbage collection işlemini sağlayan yapılarda optimizasyonlar, yenilikler yapıldı. Özellikle **Java11** ile birlikte gelen [**Z Garbage Collector**](https://wiki.openjdk.java.net/display/zgc/Main) **(ZGC)** ile büyük yenilikler hayatımıza dahil oldu. [Valhalla Project](https://openjdk.java.net/projects/valhalla/) gibi kuluçka projelerle alternatif sanal makine başarımları geliştirilmeye devam ediyor. Hayat çok güzel, her şey yolunda, sistem tıkır tıkır işliyor değil mi? Peki gerçkten öyle mi?

## 3. Java ve Mikroservisler

Mikroservisler hayatımıza girdiğinden bu yana [Docker](https://www.docker.com/) gibi [Mesos](http://mesos.apache.org/) gibi container teknolojilerini çok daha yoğun kullanmaya başladık. En basitinden [Dev/Prod Parity](https://www.mehmetcemyucel.com/2019/twelve-factor-nedir-turkce-ornek/)’yi sağlamayabilmek için bu tarz bir teknolojiyi kullanmak şart oldu. Şu anda güçlü bir uygulamada beklediğimiz özellikler; **her an erişilebilir, dirençli, düşük gecikmeye sahip, hızlı ve reaktif olmaları**.

[Kubernetes](https://kubernetes.io/) gibi bir orchestration aracıyla yönettiğimiz clusterlarımızda sanallaştırma teknolojilerini kullanarak bir çok esneklik kazanıyoruz. Geliştirdiğimiz kodlarımız, Kubernetes deploymentlarında bir base image’dan yarattığımız custom image’lar içerisinde çalışıyor. Bu image’ların içerisinde işletim sistemi kaynakları ve kütüphaneler bulunuyor ve kodumuz bunların yardımıyla ekstra bir kaynağa gerek kalmadan çalışabiliyor.

Son birkaç cümle aslında bugünkü yazımızın çıkış noktasını oluşturuyor. Bir kez daha irdeleyelim.

>"Uygulamamıza ait kodlar, ihtiyaç uyduğu işletim sistemi kaynakları ve harici kütüphaneler ile birlikte tek bir image’ın içerisinde paketlenebilir; bir container olarak **herhangi bir yerde** çalıştırılabilir."

Yukarıdaki cümleye bakılırsa **herhangi bir yerde çalıştırılabilmesi** cümlesi ile **eğer containerized bir ortamınız mevcut ise Java’nın senelerdir en güçlü yanı olarak tanıttığı özelliğe artık ihtiyacınız olmadığı** yorumunu doğuruyor. Bu noktada sorulması gereken soru şu; Java her yerde çalışabilmek uğruna nelerden vazgeçiyor? Her yerde çalışabilme gibi bir derdi olmasaydı neler daha farklı olabilirdi? Neler daha performanslı çalışırdı, paket boyutlarında ne gibi değişiklikler söz konusu olurdu?

![http://canacopegdl.com/file/images/cumbersome/cumbersome-13.html](https://miro.medium.com/max/633/0*mf0v1GtnXoEpVUN9.jpg)

Yazılan Java kodunun farklı işletim sistemlerinde, mimarilerde çalışabilmesi için aslında hatrı sayılır şeylerden feragat edilmesi gerekmektedir. Derlenmiş kodumuzun çalıştırılmasından sorumlu [Java Runtime Environment](https://www.java.com/en/download/faq/whatis_java.xml)’da(JRE) bu sebepten çok fazla kaynak ve kod bulunmaktadır. **Örneğin** [**OpenJDK**](https://wiki.openjdk.java.net/)**’nın base image’ı 250MB’dan daha büyüktür**. Şirketler genellikle mikroservis mimariye uygun kod geliştirebilmek için [**Spring**](https://spring.io/) **teknolojilerini kullanarak kod geliştirdiği varsayımı ile ilerlersek kodumuzun çalışabildiği containerın boyutu en azından yaklaşık 450–500MB’lar civarında olacaktır.** Bu boyutlar [disposability](https://www.mehmetcemyucel.com/2019/twelve-factor-nedir-turkce-ornek/) prensibinden dolayı tercih etmediğimiz bir durumdur. Çünkü büyük boyutlardaki containerların ayağa kalkması uzun sürmektedir. Peki ne yapabiliriz? Sırtımızdaki yükten nasıl kurtulabiliriz?

### 3.1. Just in Time (JIT) vs Ahead of Time (AOT) Compilers

Bu noktada derleyiciler hakkında daha detaylı bilgi paylaşmam gerekiyor. Derleyiciler yazılan kodun işlemcinin anbladığı makine koduna çevrilmesinden sorumlu yapılardır. Derleyicileri kabaca iki gruba ayırmak mümkün; `**Just in Time**`  `**(JIT)**` ve `**Ahead of Time (AOT)**` derleyiciler.

#### 3.1.1. Ahead of Time (AOT)

`**AOT Derleyiciler;**` yazılan kodun doğrudan spesifik olarak donanımın anladığı makine koduna çevrilmesinden sorumlu derleyicilerdir. C/C++ gibi diller bu derleyicileri kullanmaktadır.

#### 3.1.2. Just in Time (JIT)

`**JIT Derleyiciler;**` çalışma esnasında toplanan performans metrikleri aracılığıyla uygulanan derleme tekniğini kullanan derleyicilerdir. Uygulama ayağa kalkarken interpreted modda bytecode’u satır satır yorumlar. Bu esnada da kodun sık kullanılan kısımları hakkında istatistik toplar. Uygulamanın sık çalıştırılan kısımları belirlenir. Bu kısımlar bytecode’dan makine koduna çevrilir. Bu sayede kodun doğrudan CPU üzerinde çalıştırması mümkün olur. Bu işlemlere `**Native Direct Operations**` ismi verilir, JVM bu operasyonları çalıştırırken `**Native Register Machine**` olarak çalışmaktadır. Kodun sıcak alanları sürekli istatistiklerle izlenerek bu optimizasyon sürekli devam eder. Java bu derleyicileri kullanmaktadır.

AOT ve JIT derleyicileri kıyaslamaya gelince, JIT derleyiciler platform bağımsız çalışmaktadır. AOT derleyiciler bu açıdan derlendiği platforma bağımlıdır. Ancak AOT daha hızlıdır, çünkü doğrudan işlemcinin anlayacağı şekilde derlenmiştir.

## 4. GraalVM

[GraalVM](https://www.graalvm.org/) [Oracle](https://www.oracle.com/tr/index.html) tarafından geliştirilen bir sanal makine. Java, JVM tabanlı diğer diller, Javascript, Ruby, Python, R, C/C++ ve diğer `[**Low Level Virtual Machine(LLVM)**](https://llvm.org/)` desteği sağlayan dilleri farklı deployment senaryolarında çalıştırabiliyor. LLVM sayesinde adaptörünü yazdığını herhangi bir dili de GraalVM’de çalıştırmak mümkün. Bu yapısıyla [polygot mimariler](https://en.wikipedia.org/wiki/Polyglot_(computing))’e tam uyum sağlamaktadır. Ayrıca bellek ve [GC](https://en.wikipedia.org/wiki/Garbage_collection_(computer_science)) optimizasyonları noktasında daha verimli çalıştıklarını [iddia ediyorlar](https://www.youtube.com/watch?v=pR5NDkIZBOA), [Twitter](https://twitter.com/login?lang=tr)’ı GraalVM üzerinde çalıştırıyorlarmış.

GraalVM kullandığı JIT derleyicisinin daha performanslı olduğu iddiasına sahip. Ancak bu yazıda odaklandığımız yeteneği daha çok `**native image**` yaratabiliyor olması. Native image, özetle Java tabanlı dillerle AOT kullanabilmek anlamına geliyor. Yani JIT derleyici kullanmadan tamamen optimize bir native base image’a özel kodumuzun derlenmesi ve bu imaj üzerinde çalışması mümkün oluyor.

Sırtımızdaki yükten nasıl kurtulacağız dediğimiz sorumuzu hatırlarsınız. İşte GraalVM bizim için bu noktada kurtarıcı olarak ortaya çıkıyor. Doğrudan makine koduna derlenmiş kodlar sayesinde **uygulamanın açılışı hızlı gerçekleşecek**. Ve çalışması esnasında yapılan istatistik toplama, optimizasyon için runtimeda yapılan HotSpot derlemeler vb tüm süreçlerden bizi kurtaracak. Bunların yanında kodun tam performans çalışabilmesi için gereken **JVM’in ısınma süresi**(istatistik toplama vs hotspot derlemelerin aldığı zaman) tarih oluyor, **kod çok hızlı bir şekilde ayağa kalkarken yüksek performansla doğrudan çalışmaya başlıyor**. Hayat çok güzel değil mi :)

### 4.1. Gerçekten Sihirli Değnek Mi?

GraalVM bir önceki başlıkta sunulan her şeyi sunuyor. Ancak native image kullanacaksanız bir kısıtımız var. Zaten dikkatli gözler farketmiştir. **Native image runtime’da sürpriz sevmez!** Nasıl çalışacağı runtime’a çıkmadan önce net olarak tanımlanmış kodlar ancak optimize edilebilir ve makine koduna çevrilebilir. **Yani özetle,** [**native image**](https://www.graalvm.org/docs/reference-manual/aot-compilation/) **kullanacaksanız** [**reflection**](https://en.wikipedia.org/wiki/Reflection_(computer_programming)) **kullanamazsınız!**

### 4.2. Ya Spring Boot?

Bildiğiniz gibi Spring, [Inversion of Control](https://en.wikipedia.org/wiki/Inversion_of_control) (IoC) prensibi ile çalışmaktadır. Diğer adıyla [Dependency Injection](https://en.wikipedia.org/wiki/Dependency_injection) (DI) olarak bildiğimiz yapıda tanımladığımız singleton Spring Bean’leri `ApplicationContext`tarafından preload edilir ve runtime’da ne zaman `getBean()` metodu çağırılırsa `lazy loading` ile `BeanFactory` tarafından bean örneği yaratılır. Bütün bu süreçte de bildiğiniz gibi reflection kullanılmaktadır :) Yani eğer native image kullanma düşüncesindeyseniz çalışma mantığını düşündüğümüzde Spring bunun için uyumlu bir seçenek olmayacaktır. Spring ile native image kullanmayı sağlamak için farklı projelere rastlayabilirsiniz, şu an için verimli bir çözüm olmamakla birlikte belki de çözüm için farklı alternatifleri düşünmenin vakti gelmiştir, ne dersiniz?

## 5. Quarkus


![](https://miro.medium.com/max/1040/0*GIhOwWtCvkPXqmsB.jpg)

[Red Hat](https://www.redhat.com/en)’in sponsor olduğu [Quarkus Projesi](https://quarkus.io/)’nin mottosu **_“Supersonic Subatomic Java”_.** Kendisini Kubernetes Native Java geliştirimi için GraalVM ve OpenJDK [HotSpot](https://en.wikipedia.org/wiki/HotSpot) VM’lerini destekleyen ve en iyi Java kütüphanelerinden ve standartlarından oluşan bir birleşim olarak tanımlıyor. **Dilerseniz** [**imperative**](https://en.wikipedia.org/wiki/Imperative_programming) **dilerseniz** [**reactive**](https://en.wikipedia.org/wiki/Reactive_programming) **kod geliştirimi yapabilirsiniz**. Reactive kod geliştirimi büyük artılarından birisi.

AOT’nin çalışma yapısından bahsetmiştik, tam olarak da bu sebeplerden oluşan paket büyüklüğünün azalması ve hızlı şekilde ayağa kalkma öngörülerinin ölçümlerini kendi sitelerinde aşağıdaki görselle sunuyorlar.

![https://quarkus.io/](https://miro.medium.com/max/2500/0*V3gWNuEIW9BSiAn0.png)

Reflection kullanmayan bir kod yazacaksak bu teknolojilerden oluşan bir stack’e ihtiyacımız olacak. Quarkus’un belirli standartlar kapsamında birlikte yol ortağı olduğunu anasayfasında duyurduğu bazı teknolojiler [Vert.X](https://vertx.io/), [Hibernate](https://hibernate.org/), [RestEasy](https://resteasy.github.io/), [Apache Camel](https://camel.apache.org/), [Eclipse Microprofile](https://microprofile.io/), [Netty](https://netty.io/), [Kubernetes](https://kubernetes.io/), [OpenShift](https://www.openshift.com/), [Jaeger](https://www.jaegertracing.io/), [Prometheus](https://prometheus.io/), [Kafka](https://kafka.apache.org/), [Infinispan](https://infinispan.org/). Ayrıca [extensions sayfasında](https://quarkus.io/extensions/) ihtiyaç duyabileceğiniz geniş bir tool listesi mevcut.

## 6. Spring Boot vs Quarkus Testleri

Bazı rakamsal kıyasları yapmadan olmazdı. `**JDK8**` için **OpenJDK** ve **GraalVM** kullanarak testleri tamamladım. Quarkus için [Get Started](https://quarkus.io/get-started/) sayfasındaki yönendirmeleri izleyerek `0.20.0`ve `0.19.1`versiyonları için kodu geliştirdim. Spring Boot tarafında da `2.1.6`releasinden [Spring Initialzr](https://start.spring.io/) üzerinden projeyi aldım. İki proje de birer rest uç açtım ve “Hello World” return ettim.

### 6.1. Startup Testi

#### 6.1.1. Koşullar

İlk kıyasım minimum kaynak ile ayağa kalkma ve ayağa kalkış sürelerini ölçmek oldu. Oluşturduğum jar paketlerini çalıştırırken -Xmx parametresi ile memory kullanımını sıkıştırdım.

Spring projesi ayağa kalkabilmek için **minimum 13MB belleğe** ihtiyaç duydu. Bu minimum bellek ile ayağa kalkarken **ayağa kalkış süresi yaklaşık 4–4,5 sn** aralığında sürdü.

![](https://miro.medium.com/max/1664/1*K2DMyYUbp_JFhq3HlRdVww.png)

**Aynı kaynakla (13MB) Quarkus projesi**ni JIT derleyici ile HotSpot modda ayağa kaldırdığımda ortalama **ayağa kalkma süresi 600ms civarlarında** dolaştı.

![](https://miro.medium.com/max/1151/1*e-uspi-oPHqJ817_Q-unUw.png)

Yine **JIT derleyici ile Quarkus projesinin ayağa kalkabilmesi için ise minimum 7MB’lık bir memory** yeterli oldu. Bu kaynakla **ortalama ayağa kalkış süresi 1sn** civarlarındaydı.


![](https://miro.medium.com/max/1149/1*-6Ob17UwYBBOxh5MtOVl8w.png)

Açılış süresindeki asıl farkı gözlemlemek için **Quarkus projesini AOT derleyici ile native** derledim. Bu kez **ayağa kalkış süresi** şaşırtıcı şekilde çok daha hızlıydı. Ortalama **6–7ms**’de ayağa kalkabildi.

![](https://miro.medium.com/max/1185/1*paUFhi0ujuq71zK9Gir4fA.png)

#### 6.1.2. Startup Testi Sonuç

Quarkus projesi Spring Boot projesine kıyasla daha az kaynakla çok daha hızlı ayağa kalkabildiğini gözlemledim. Eğer native derlerseniz bu süre misli şekilde kısalıyor.

<script src="https://gist.github.com/mehmetcemyucel/e83b61520d699232090514c391d68485.js"></script>

### 6.2. Memory & CPU Testi

#### 6.2.1. Koşullar

İkinci test senaryomda yaptıklarım memory’de heap alanına yapılacak aşırı yüklemelerde response süresinin nasıl etkilendiği ve belleğin, CPU’nun ve aktif thread sayılarının [VisualVM](https://visualvm.github.io/) üzerindeki görüntülerini kıyaslamak oldu.

**Önce basit bir CPU yüklemesi, sonrasında da** [**Elasticsearch**](https://www.elastic.co/)**’te barındırdığım 200MB’lık bir datanın çekilmesi senaryosu** kurguladım. Bunun için iki projeye de aynı Elasticsearch low level rest client bağımlılığı ekledim. Rest uçlardan tetiklediğim iki uygulama yine http üzerinden Elasticsearch’ün rest uçlarından 200MB’lık datayı çektiği ve String’e çevirdiği anda ölçümümü sonlandırdım.

##### 6.2.1.1. Spring Boot Memory & CPU

![](https://miro.medium.com/max/1920/1*V82jjUN0yydgeQ7dEvHKvA.png)

Ortalama 50MB heap ile açılan uygulama isteği aldığı anda yaklaşık 250 MB’lara ulaştı. Elastic’in took süresi 1sn idi. Network üzerindeki trafik sonlandığı ve tüm datanın uygulama üzerine bindiği anda **maksimum kullanılan bellek 2,5GB**’ları gördü. Uygulama açılışından itibaren ortalama **52 live thread** ile tüm süreci yönetti ve **23 tane** [**daemon thread**](https://www.mehmetcemyucel.com/2015/java-daemon-thread/) vardı. Yaptığım 10 denemenin ortalaması tetikleme anından itibaren response’un String’e alınması **ortalama 36sn** sürdü.

Kod:

<script src="https://gist.github.com/mehmetcemyucel/efa11d97f0d3c1041b225c89acf8a568.js"></script>

##### 6.2.1.2. Quarkus Memory & CPU

![](https://miro.medium.com/max/60/1*6D5jJShqv8pY8nTUkv47KA.png?q=20)

![](https://miro.medium.com/max/1923/1*6D5jJShqv8pY8nTUkv47KA.png)

Ortalama 50MB heap ile açılan uygulama isteği aldığı anda yaklaşık 250 MB’lara ulaştı. Elastic’in took süresi 1sn idi. Network üzerindeki trafik sonlandığı ve tüm datanın uygulama üzerine bindiği anda **maksimum kullanılan bellek 700MB**’ları gördü ancak **çok hızlı şekilde bu bellek alanını iade etti**. 15 thread ile açılan uygulama istek anından itibaren **ortalama 29 live thread** ile tüm süreci yönetti ve **12 tane daemon thread** vardı. Yaptığım 10 denemenin ortalaması tetikleme anından itibaren response’un String’e alınması **ortalama 19sn** sürdü.

Kod:

<script src="https://gist.github.com/mehmetcemyucel/c5db92d956212a5342a817d1e9585ec8.js"></script>

#### 6.2.2. Memory & CPU Testi Sonuç

10ar denemenin sonucunda çıkan rakamlar tutarlılık gösteriyordu. Doğruyu söylemek gerekirse bu kadar bir farkı ben de beklemiyordum. Kafalardaki endişeleri yok etmek için kodları da yukarıya ekledim. Aşağıdaki tabloyu özetlemek gerekirse **native olarak çalışan Quarkus kodu Spring Boot koduna oranla hem zaman, hem memory hem de CPU açısından daha efektif sonuçlar doğuruyor**.

<script src="https://gist.github.com/mehmetcemyucel/3e8738e33ae8331704d06a146ba89a53.js"></script>

## 7. Sonuç

Mikroservis mimariler ile uğraşıyorsanız optimizasyon, daha iyileştirme, daha az maliyetle daha fazla performans gibi konular için alternatif teknolojileri takip etmek ve deneyimlemek gerekiyor. Quarkus ve GraalVM bu teknolojilerden deneyimlemenin de ötesinde gelecek günlerde hayatımızın büyük birer parçası olacak gibi gözüküyor. Deneyimlemenizi şiddetle tavsiye ederim.


***En yalın haliyle***

[**Mehmet Cem Yücel**](https://www.mehmetcemyucel.com)

---

**Bu yazılar ilgilinizi çekebilir:**

 - [Bir Yazılımcının Bilmesi Gereken 15 Madde](https://www.mehmetcemyucel.com/2019/bir-yazilimcinin-bilmesi-gereken-15-madde/)
 - [MapStruct ile SpringBoot Obje Dönüşümü](https://www.mehmetcemyucel.com/2019/MapStruct-ile-obje-donusumu/)
 - [Spring Boot Devtools ile Docker Üzerindeki Kodu Debug Etme ve Değiştirme](https://www.mehmetcemyucel.com/2019/spring-boot-devtools-ile-docker-uzerindeki-kodu-debug-etme-ve-degistirme/)

**Blockchain teknolojisi ile ilgileniyor iseniz bunlar da hoşunuza gidebilir:**

 - [BlockchainTurk.net yazıları](https://www.mehmetcemyucel.com/categories/#blockchain)

---