---
title:  "Spring Boot Devtools ile Docker Üzerindeki Kodu Debug Etme ve Değiştirme"
date:   2019-01-27 15:04:23
categories: [java, spring, spring boot, docker, maven, microservices]
tags: [spring boot, spring, devtools, docker, remote, debug, debugging,  microservices, mikroservis, türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://cdn-images-1.medium.com/max/150/1*nf9ajj-L2uZ2ztybaLHMWA.jpeg
---

Şu cümleyi mutlaka duymuşuzdur ya da bizzat söylemişizdir; “Ama benim makinemde çalışıyordu!”. Kodumuz kendi makinemizde çalışırken test ortamına gittiğinde çalışmamasının sebebi acaba neydi? Cevap: Kod aynıydı, ama ya gerisi?

![](https://miro.medium.com/max/1175/1*nf9ajj-L2uZ2ztybaLHMWA.jpeg)

Kodun aynı çalışabilmesi için aynı işletim sistemine, bunun doğru yapılandırılmasına(dil ve tarih ayarları, …), üzerinde gerekli kurulumların doğru versiyonlarla kurulmasına(JRE, DB, Queue, vb), bunların aynı patch’lerle upgrade edilmesine, uygulamasal parametrelerin aynı olmasına… Farkındaysanız listemiz uzayıp gidiyor. Ee peki bunca şeyi hem kendi makinemizde hem de test ortamlarında nasıl aynı yapabiliriz ki?

Cevap mikroservis mimarinin olmazsa olmazları olarak tanımlanan [12 Factor](https://12factor.net/) başlıklarında yer alıyor. Backing Services ve Dev/Prod Parity başlıkları ortamların tekilleştirilmesi için nelere dikkat edilmesi gerektiğini anlatıyor, dileyenler için Türkçe örneklerle anlattığım yazıya [buradan](http://www.mehmetcemyucel.com/2018/03/12-faktor-turkce-ve-java.html) ulaşabilirsiniz.

> “Konfigürasyonun kodlanabilir olması ortamsal farklılıkları ortadan kaldırır. Komplikasyon riskini minimize eder ve kompleksiteyi düşürür.“

{% include feed-ici-yazi-1.html %}

## 1. Sanallaştırma Teknolojileri ve Ortam Yönetimi

Sanallaştırma ve container teknolojileri bu noktada imdadımıza yetişiyor. Container teknolojisi olarak Docker kullandığımız için yazının bu noktasından sonra için keyword tercihlerimi bu yönde kullanarak devam edeceğim.

Kodun container’larda geliştirilmesi ya da geliştirme tamamlandıktan sonra Dockerize edilmesi ve tüm ortamlarda bu koda ait imajın dağıtılması mikroservis bakış açısının temelini oluşturuyor. Ancak bir sıkıntı var, kodun geliştirimini nasıl container’da yapacağız? Birinci çözüm, IDE’miz de başka bir containerın içerisinde olacak. [Eclipse CHE](https://www.eclipse.org/che/) gibi çözümlerle bu yaklaşım mümkün. Ya da bir diğer alternatif, kendi makinemizden containerda çalışan kodu geliştirip düzenlememiz gerekli. Hata ayıklama, debugging işlemlerini de keza aynı yöntemlerle yapabilmeliyiz.

İşte bu yazımızda Spring Boot Devtools ile Docker container’ı içerisinde embedded Tomcat üzerinde çalışan uygulamamızda runtimeda kod değişikliği yapıp Live Reload işlemini gözlemleyecek ve Remote Debugging yapacağız.

## 2. Spring Boot Devtools

Teknik kısma geldik. İlk önce [Spring Boot Devtools](https://docs.spring.io/spring-boot/docs/current/reference/html/using-boot-devtools.html)’dan bahsetmemiz lazım. Developer tools, projemize ait disk üzerindeki spesifik dizinleri dinleyerek bu dizinlerde meydana gelen değişiklikleri runtime’a yansıtma görevini üstlenen bir modül. Yani projenizi restart etmek yerine sadece değişen ya da etkilenen source’lar için binary’leri belleğe çekme işlemi yapılıyor. Burada bir sayfa açarak JRebel gibi hot code replacement toolları ile aynı işi yapmadığına değinmekte fayda var. Eğer projeniz Jrebel enabled bir proje ise devtools’un kısıtlı çalıştığına şahit olacaksınız. Farkları ise en güzel replacement ve reload kelimeleri ile anlatılabilir.

> Jrebel => replacement, devtools => reload & automatic restart

Spring Boot Devtools’un yaptıkları sadece bunlar değil. [Live Reload](https://docs.spring.io/spring-boot/docs/current/reference/html/using-boot-devtools.html#using-boot-devtools-livereload) özelliği ile önyüz geliştirimi yapanlar için source’daki değişiklik durumunda sayfayı reload ederek güncel durumu alabilmek için bizim refreshment yapmamızı zorunluluk olmaktan çıkarıyor. Bunu React’taki Hot Reload’dan ayırmamız lazım, Live Reload statelerdeki değişimleri takip edip sayfanın belirli parçalarını yenilemek yerine sayfayı reload etmeyi tercih eder. Bu özelliği kullanabilmek için Chrome’da [RemoteLiveReload](https://chrome.google.com/webstore/detail/remotelivereload/jlppknnillhjgiengoigajegdpieppei) extensionını edinmeniz gerekli.

{% include feed-ici-yazi-2.html %}

## 3. Örnek Kod

### 3.1 Pom.xml 
Artık kod örneğimize geçebiliriz. Devtools’u etkinleştirmek için projemizin pom.xml dosyasına devtools dependency’sini eklemeliyiz. Kodumuzu test amacıyla bir rest uç açacağımızdan web-mvc dependency’sini de ekliyoruz. Son olarak plugin konfigürasyonuna projeden jar export alınırken Devtools’a ait bileşenlerin exclude edilmemesi için konfigürasyon ekliyoruz.

<script src="https://gist.github.com/mehmetcemyucel/2b0211048f581dc0d18ac49369a3d492.js"></script>

Projemize bir rest uç açıyoruz. Bu uçtan sorgulamalar yaparak kodumuzun son durumunu takip edeceğiz.

<script src="https://gist.github.com/mehmetcemyucel/3fe9b905a941b05017405f22e9eeb94d.js"></script>

{% include feed-ici-imaj-1.html %}

### 3.2 Code Reload & Restart

Uygulamamızı başlattıktan sonra çalışır durumda iken 11. satırdaki mesajımıza bir ekleme yapacağız. Kaydettiğimiz anda devtools bizim için projeyi otomatik olarak yeniden başlatacak.


![STS içerisinde otomatik reload](https://miro.medium.com/max/1395/1*IGqPoCiF4BMOaWWt2EFEqw.gif)

Kodumuz şu anda STS(eclipse) içerisinde. Şu anda sadece kodda yaptığımız her değişiklik için projemizi tekrar başlatmaktan kurtulduk. Peki kodumuz jar haline gelmiş olsaydı ve STS içerisinde çalışmıyor olsaydı da STS’de yaptığımız bir değişiklikle kodumuzu acaba reload edebilir miydik?

### 3.3 External Source

Kod değişikliklerini remote olarak yönetebilmek için yapmamız gereken birkaç adım var. İlk önce STS’den gelecek kod değişikliği bilgilerinin trusted bir kaynaktan geldiğinden emin olabilmek için bir secret paylaşımı yapılması lazım. Bu sebeple application.properties dosyamıza aşağıdaki şekilde secret’ımızı tanımlıyoruz.

	spring.devtools.remote.secret=MCYMCYMCY

Sonrasında STS dışında kodumuzu çalıştırmak istediğimizden jar paketimizi oluşturuyoruz. Bunu maven ayarlarınız yapılmış ise `mvn clean install -DskipTests` diyerek terminalden de yapabilirsiniz. Biz STS üzerindeki embedded gelen maven ile bu işimizi yapacağız.

![jar oluşturma](https://miro.medium.com/max/1395/1*ppwbn8BFwfnNGgYV4WroSg.gif)
Oluşan jar dosyamızı bir docker containerı içerisinde çalıştıracağız. Bunun için Dockerfile’ımızı aşağıdaki şekilde yapılandırıyoruz.

### 3.4 Java Debug Wire Protocol (JDWP)

Maven ile oluşturduğumuz jardan Dockerfile aracılığı ile kendi imajımızı yaratacağız. Dilerseniz [bu yazıda](https://medium.com/mehmetcemyucel/spring-boot-projesini-maven-ile-dockerize-etmek-e90a0d5dd002) değindiğim yöntemlerle maven pluginlerini kullanarak kısa yoldan da imajınızı yaratabilirsiniz. Burada dikkat çekmek istediğim nokta, oluşan jarımızı `java -jar` yordamına ek bazı parametreler ekleyerek çalıştırdığımız. bu parametrelerle **Java Debug Wire Protocol** (**JDWP**) kullanarak uygulamamızı remote debug’a açıyoruz. Ve bu işlem için uygulamamızın dinleyeceği port olarak 8001 portunu atıyoruz. Docker imajımızı oluşturmak için konsolda `docker build -t mcy-sb-devtools-docker .` komutunu çalıştırıyoruz. Sonrasında da `docker images` ile imajımızın oluşup oluşmadığını kontrol ediyoruz.


![](https://miro.medium.com/max/1214/1*qQH2T3cBnCbPuETMKb1ebA.gif)

İmajımız hazır, şimdi container ayağa kaldırıp kodumuzu çalıştıralım ve browserdan rest ucumuza istek gönderelim. Port bindinglerimizi 8080 ve 8001 portlarına yapıyoruz. 8080 hem kod reload hem de rest uç için, 8080 ise remote debugging için kullanılacak.


![](https://miro.medium.com/max/1214/1*54ZjXLKuAcYiKUBm_bZ30Q.gif)

### 3.5 Runtime Konfigürasyonu

Artık elimizde Docker’da çalışan, REST servis sunan bir Spring Boot uygulamamız var. O zaman STS ile bağımsız olarak çalışan bu uygulamamızı STS üzerinden nasıl runtime’da değiştirebileceğimizi gösterebiliriz. Bunun için STS’de Run menüsünün altında Run Configurations tabındaki Java Application başlığı altına geliyoruz. Sağ tıklayarak New Configuration yaratacağız. Yapmamız gereken Spring Boot uygulamamız için default olarak gösterilen Main Class tercihimizi remote uygulamamızı yönetmemizi sağlayacak başka bir startup classı ile değiştirmek. Main class kısmına `org.springframework.boot.devtools.RemoteSpringApplication` yazıyoruz. Sonrasında da Arguments tabında program argumanlarına standalone çalışan uygulamamızın Remote bağlantılar için dinlediği adresi yazıyoruz(default olarak 8080 remote reload için dinleme yapılan adrestir).

![remote reloading ayarlama](https://miro.medium.com/max/1395/1*eM7ghMUSviWrngVfwn0UnA.gif)

Artık kodu değiştirme kısmını deneyebiliriz. RestController sınıfımızdaki return edilen response mesajının içeriğini değiştirdiğimizde kodumuz remote şekilde standalone çalışan jar’a push edilecek ve browser’dan ucumuzu tekrar çağırdığımızda artık yeni kodlar çalışarak yeni response dönecek.


![](https://miro.medium.com/max/1389/1*pbuZgiYs7WzCVJlw3m5Bng.gif)

{% include feed-ici-imaj-1.html %}

### 3.6 Remote Debugging

Kodumuzun reload’ını başardık ancak remote debugging henüz ayarlanmadı. Bunun için hatırlarsanız yukarıda 8001 portunu remote debugging için yapılandırmıştık. Debugging’i açmak için ise aşağıdaki şekilde bir STS’de debug configurations altında Remote Java Application altına aşağıdaki şekilde bir yapılandırma yapmamız gerekiyor. Bu yaptığımız işlemi remote reload çalışmaktayken debugging stack’inin kodumuz ile bağlanması olarak özetleyebiliriz.

![remote debugging yapılandırması](https://miro.medium.com/max/1386/1*hgkRIzH4vroqBcoKNgDk2Q.gif)

Artık yeni rest çağırımlarımızda 11. satıra koyduğumuz breakpoint yardımıyla remote olarak çalışan uygulamamızda remote debugging de yapabilmeye başladık.


![remote debugging](https://miro.medium.com/max/1389/1*AedvSx-NV8xYcZ_KeV79WQ.gif)

![](https://miro.medium.com/max/400/1*eDcZaJFt_33o_e_OOaO6Nw.jpeg)

Projenin kodlarına [buradan](https://github.com/mehmetcemyucel/springboot-devtools-dockerized) ulaşabilirsiniz.
