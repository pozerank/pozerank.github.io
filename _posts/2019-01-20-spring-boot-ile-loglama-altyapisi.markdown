---
title:  "Spring Boot ile SLF4j ve Log4j Loglama Altyapısı"
date:   2019-01-20 15:04:23
categories: [java, spring, spring boot, tools]
tags: [Spring Boot, Slf4j, Log4j, Log4j2, loglama, logback, nedir, nasıl yapılır, örnek, mehmet, cem, yücel, yucel, Slf4j, logback, exclude, log4j2, logger, lombok]
image: https://cdn-images-1.medium.com/max/150/1*wZTB6apo5T0lV0GljiJRBg.jpeg
---

Sıfırdan bir proje yazmaya başladığımızda ele almamız gereken bir düzine konu mevcut. Güvenliği, loglaması, mesajlaşması, servis altyapısı bir çırpıda aklımıza gelenler. Bugün bu kalemlerden birisi olan hata loglama altyapısını kurgulama hakkında karalayacağım. Konumuz bir loglama frameworkünü tanıtmak olmayacak, bu tarz yazıları çokça yerde bulmak mümkün. Biz daha çok bir Spring Boot projesinde loglama yapısı oturtmaya çalıştığımızda nelere dikkat etmeliyiz sorusunun cevaplarını adım adım birlikte bulacağız.


![Spring Boot ile Birlikte SLF4J ve LOG4J2](https://miro.medium.com/max/1500/1*wZTB6apo5T0lV0GljiJRBg.jpeg)

Örneğin, bir Spring Boot projemiz var ve varsayılan loglama ayarlarıyla kullanmak istemiyoruz. Mevcut yerine farklı bir loglama frameworkü kullanmayı istiyoruz, ancak ileride bundan da başka bir frameworke geçmek istersek kod seviyesinde etkilenmemeyi tercih ediyoruz. Hatta loglama ayarlarımızı, patternlerimizi projenin export edildiği jar dosyasının dışından yönetebilmek istiyoruz. Peki ne yapmalıyız?

Spring Boot varsayılan loglama çözümü olarak Logback ile entegre gelir. `spring-boot-starter`artifact’ini projemize eklediğimizde compile scope’unda `spring-boot-starter-logging` isimli bir artifact de eklenmiş olur. Bu artifact’in içerisinde aşağıdaki bağımlılıklar mevcut:
	
	 <dependency>  
	      <groupId>ch.qos.logback</groupId>  
	      <artifactId>logback-classic</artifactId>  
	      <version>...</version>  
	      <scope>compile</scope>  
	    </dependency>  
	    <dependency>  
	      <groupId>org.apache.logging.log4j</groupId>  
	      <artifactId>log4j-to-slf4j</artifactId>  
	      <version>...</version>  
	      <scope>compile</scope>  
	    </dependency>  
	    <dependency>  
	      <groupId>org.slf4j</groupId>  
	      <artifactId>jul-to-slf4j</artifactId>  
	      <version>...</version>  
	      <scope>compile</scope>  
	    </dependency>

Buradan 2 yorum çıkıyor. Birincisi Spring Boot projemiz şu anda varsayılan olarak logback ile çalışır durumda hazır geliyor. İkincisi, sfl4j ve log4j kullanmak istiyorsak da dependencyler mevcut. Log4j’nin ne olduğunu aşağı yukarı biliyoruz ancak Slf4j ne acaba?

> Slf4j, bizleri loglama frameworklerinden yalıtan, bağımsız olarak çalışmamızı sağlayan bir arayüzdür. Örneğin Logback kullanırken bir paketin altındaki LoggerFactory’e bağımlılığınız olur. Sonraki bir zaman Log4j’ye geçilmek istenirse tüm sınıflarınızdaki factory’lerinizi tek tek Log4j’ye ait factory ile değiştirilmesi gerekir (her sınıfın üzerinde constant olarak tanımlanan Logger instance’ı). Slf4j’nin görevi burada başlar. Spesifik frameworklere ait sınıflara bağımlı olmak yerine kendi sınıflarına bağımlı kılarak bizleri arka tarafta hangi loglama frameworkü olduğundan bihaber tutarak loglama yapılabilmesini sağlar.

Slf4j’ye dair ihtiyaç duyduğumuz dependencylerimiz de elimizde mevcut olduğuna göre şu anda yapmamız gereken logbacki varsayılan olmaktan çıkarıp yerine Log4j2 dependencylerini bağlamak. Önce Logback’i aradan çıkaralım:

<script src="https://gist.github.com/mehmetcemyucel/38de78dfd481d7ca57889e37f154676d.js"></script>

Sıradaki adımımız projemize Log4j2'yi bağlamak. Spring boot bunun için de hazır bir dependency sunuyor. `spring-boot-starter-log4j2` dependency’sini projemize eklediğimizde artık Log4j2'ye dair özellikler kullanılabilir durumda olacak. Bu dependency’nin içerisinde de aşağıdaki bileşenler bulunuyor:

<script src="https://gist.github.com/mehmetcemyucel/061e9a9271137255fa5e7ea9b64fc116.js"></script>

Aşağıdaki tarzda bir yapılandırma dosyasını ister yml, ister properties, resource’larımız arasına ekleyebiliriz. Bu adımız Log4j2'yi kullanabilmemiz için son gerekli adımımızdı.

<script src="https://gist.github.com/mehmetcemyucel/b02ec6977fd40c93d2cb0d38cb2de6ca.js"></script>

Projemiz şu anda Log4j2 ile çalışmaya hazır durumda. Slf4j’yi kullanarak Factory’sinden aldığımız Logger’lar aracılığıyla artık tanımladığımız appenderlarımıza loglarımızı basabiliriz. Ancak tam da burada bir katman daha kullanacağım. Bu katman işimizi kolaylaştıracak ve static logger tanımlama adımını annotation seviyesine taşıyacak. Bunun için Spring Boot communitysi tarafından yoğunca kullanılan ve `start-spring-io` da sunduğu [Project Lombok](https://projectlombok.org/) ’a ait bir özelliğini kullanacağım. Lombok’u IDE’niz ile nasıl entegre edebileceğinize [bu yazıdan](https://medium.com/mehmetcemyucel/sts-eclipse-spring-boot-lombok-entegrasyonu-6cdf18a8ee2d) bakabilirsiniz.

Eğer aşağıdaki özelliği kullanmasaydım aşağıdaki kodu tüm sınıflarıma yazmam gerekecekti(hayır zorunda değilim dediğinizi duyar gibiyim ancak stacktrace’lerin loglama frameworkünde düzgün oluşabilmesi için önerilen best practice budur).

<script src="https://gist.github.com/mehmetcemyucel/5ad13e9fe9f5a00b235c4b623bf44ed1.js"></script>

[@Slf4j](https://projectlombok.org/features/log) annotation’ı aracılığıyla yukarıdaki kod yerine sadece annotation ile loglamamı yapabiliyorum.

<script src="https://gist.github.com/mehmetcemyucel/5690c9b7443d1475fdcb75f87f6e7054.js"></script>

Adım adım ilerlemeye devam ediyoruz, şu anda boot projemiz Logback yerine Log4j2 ile loglama yapabiliyor, yapılandırması tamamlandı, slf4j arayüz olarak kullanılabiliyor ve bunu lombok aracılığı ile zahmetsizce yapıyoruz. Son bir problemimiz kaldı. Projenin resource’ları içerisinde bulunan yapılandırma dosyamız jar export ettiğimiz anda jar’ın içerisinde kalıyor ve jarımızın dışarıdan yapılandırılabilmesi güçleşiyor. Dilerseniz tüm yapılandırmayı runtime’da yapmanız, appenderlarınızı dinamik bir şekilde root loggera bağlamanız da mümkün. Ya da [Spring Boot Admin](https://github.com/codecentric/spring-boot-admin)’i aktifleştirerek loglama frameworkünden bağımsız olarak admin arayüzü üzerinden sadece birkaç tıklamayla paket seviyesindeki loglama levelları ile de oynayabilirsiniz. Ancak bu yazımızda sadece Log4j2'nin yapılandırma dosyasını standalone jar olarak export edilmiş Spring Boot executable’ından çıkarmayı ve dışarıdan yapılandırmasını sağlayacağız.

Öncelikle resources dizini altındaki bu dosyanın jar içine girmesini engellemek için aşağıdaki satırları ekliyoruz.

<script src="https://gist.github.com/mehmetcemyucel/df04f259a0f1f1c6974592aa85c9663b.js"></script>

Sonrasında pom.xml dosyamızın olduğu yerde `mvn clean install -DskipTests` komutunu çalıştırıyorum. Bu komutun çalışması için geçerli bir maven kurulumunuzun olması gerekir, eğer yoksa da kullandığınız IDE’nin içerisinde entegre bir maven genellikle mevcuttur, IDE’niz aracılığı ile de kodlarınızın maven tarafından build edilmesini de sağlayabilirsiniz. Komutun çıktıları aşağıdaki gibi oldu.

	[INFO] Scanning for projects...  
	[INFO]  
	[INFO] --------------------< com.mcy:mcy-sb-slf4j-log4j2 >---------------------  
	[INFO] Building mcy-sb-slf4j-log4j2 0.0.1-SNAPSHOT  
	[INFO] --------------------------------[ jar ]---------------------------------  
	[INFO]  
	[INFO] --- maven-clean-plugin:3.1.0:clean (default-clean) @ mcy-sb-slf4j-log4j2 ---  
	[INFO] Deleting C:\dvlp\workspaces\basicWorkspace\mcy-sb-slf4j-log4j2\target  
	[INFO]  
	[INFO] --- maven-resources-plugin:3.1.0:resources (default-resources) @ mcy-sb-slf4j-log4j2 ---  
	[INFO] Using 'UTF-8' encoding to copy filtered resources.  
	[INFO] Copying 1 resource  
	[INFO]  
	[INFO] --- maven-compiler-plugin:3.8.0:compile (default-compile) @ mcy-sb-slf4j-log4j2 ---  
	[INFO] Changes detected - recompiling the module!  
	[INFO] Compiling 2 source files to C:\dvlp\workspaces\basicWorkspace\mcy-sb-slf4j-log4j2\target\classes  
	[INFO]  
	[INFO] --- maven-resources-plugin:3.1.0:testResources (default-testResources) @ mcy-sb-slf4j-log4j2 ---  
	[INFO] Using 'UTF-8' encoding to copy filtered resources.  
	[INFO] skip non existing resourceDirectory C:\dvlp\workspaces\basicWorkspace\mcy-sb-slf4j-log4j2\src\test\resources  
	[INFO]  
	[INFO] --- maven-compiler-plugin:3.8.0:testCompile (default-testCompile) @ mcy-sb-slf4j-log4j2 ---  
	[INFO] Changes detected - recompiling the module!  
	[INFO] Compiling 1 source file to C:\dvlp\workspaces\basicWorkspace\mcy-sb-slf4j-log4j2\target\test-classes  
	[INFO]  
	[INFO] --- maven-surefire-plugin:2.22.1:test (default-test) @ mcy-sb-slf4j-log4j2 ---  
	[INFO] Tests are skipped.  
	[INFO]  
	[INFO] --- maven-jar-plugin:3.1.1:jar (default-jar) @ mcy-sb-slf4j-log4j2 ---  
	[INFO] Building jar: C:\dvlp\workspaces\basicWorkspace\mcy-sb-slf4j-log4j2\target\mcy-sb-slf4j-log4j2-0.0.1-SNAPSHOT.jar  
	[INFO]  
	[INFO] --- spring-boot-maven-plugin:2.1.2.RELEASE:repackage (repackage) @ mcy-sb-slf4j-log4j2 ---  
	[INFO] Replacing main artifact with repackaged archive  
	[INFO]  
	[INFO] --- maven-install-plugin:2.5.2:install (default-install) @ mcy-sb-slf4j-log4j2 ---  
	[INFO] Installing C:\dvlp\workspaces\basicWorkspace\mcy-sb-slf4j-log4j2\target\mcy-sb-slf4j-log4j2-0.0.1-SNAPSHOT.jar to C:\Users\PC\.m2\repository\com\mcy\mcy-sb-slf4j-log4j2\0.0.1-SNAPSHOT\mcy-sb-slf4j-log4j2-0.0.1-SNAPSHOT.jar  
	[INFO] Installing C:\dvlp\workspaces\basicWorkspace\mcy-sb-slf4j-log4j2\pom.xml to C:\Users\PC\.m2\repository\com\mcy\mcy-sb-slf4j-log4j2\0.0.1-SNAPSHOT\mcy-sb-slf4j-log4j2-0.0.1-SNAPSHOT.pom  
	[INFO] ------------------------------------------------------------------------  
	[INFO] BUILD SUCCESS  
	[INFO] ------------------------------------------------------------------------  
	[INFO] Total time:  3.720 s  
	[INFO] Finished at: 2019-01-20T12:26:14+03:00  
	[INFO] ------------------------------------------------------------------------  
	PS C:\dvlp\workspaces\basicWorkspace\mcy-sb-slf4j-log4j2>

/target altında oluşan jarımızın içeriğine bakalım. ‘…’ folder’ının altında resources altında bulundurduğumuz dosyaların olduğunu görüyoruz, log4j2-spring.xml dosyası da pom.xml’de belirttiğimiz gibi paketten exclude edilmiş.

![](https://miro.medium.com/max/1020/1*_60BDrlYohZgyxWj55HfiQ.png)

Dosyamız pakette olmadığından dolayı jarımız ile aynı pathte veya jarın classpath’inde bulunduğu taktirde boot projemiz ayağa kalkarken bu dosyayı bulup sağlıklı bir şekilde yapılandırmasını tamamlayacaktır. Farklı path’te konumlandıracaksanız jar execute ederken classpath nasıl set edilir şeklinde bir arama ile ilgili yöntemlere ulaşabilirsiniz.

En son olarak `mvn clean test` komutu ile yazdığımız testin çalışıp çalışmadığnı kontrol edebiliriz. Çıktısı aşağıdaki gibi,

	PS C:\dvlp\workspaces\basicWorkspace\mcy-sb-slf4j-log4j2> mvn clean test  
	[INFO] Scanning for projects...  
	[INFO]  
	[INFO] --------------------< com.mcy:mcy-sb-slf4j-log4j2 >---------------------  
	[INFO] Building mcy-sb-slf4j-log4j2 0.0.1-SNAPSHOT  
	[INFO] --------------------------------[ jar ]---------------------------------  
	[INFO]  
	[INFO] --- maven-clean-plugin:3.1.0:clean (default-clean) @ mcy-sb-slf4j-log4j2 ---  
	[INFO] Deleting C:\dvlp\workspaces\basicWorkspace\mcy-sb-slf4j-log4j2\target  
	[INFO]  
	[INFO] --- maven-resources-plugin:3.1.0:resources (default-resources) @ mcy-sb-slf4j-log4j2 ---  
	[INFO] Using 'UTF-8' encoding to copy filtered resources.  
	[INFO] Copying 1 resource  
	[INFO]  
	[INFO] --- maven-compiler-plugin:3.8.0:compile (default-compile) @ mcy-sb-slf4j-log4j2 ---  
	[INFO] Changes detected - recompiling the module!  
	[INFO] Compiling 2 source files to C:\dvlp\workspaces\basicWorkspace\mcy-sb-slf4j-log4j2\target\classes  
	[INFO]  
	[INFO] --- maven-resources-plugin:3.1.0:testResources (default-testResources) @ mcy-sb-slf4j-log4j2 ---  
	[INFO] Using 'UTF-8' encoding to copy filtered resources.  
	[INFO] skip non existing resourceDirectory C:\dvlp\workspaces\basicWorkspace\mcy-sb-slf4j-log4j2\src\test\resources  
	[INFO]  
	[INFO] --- maven-compiler-plugin:3.8.0:testCompile (default-testCompile) @ mcy-sb-slf4j-log4j2 ---  
	[INFO] Changes detected - recompiling the module!  
	[INFO] Compiling 1 source file to C:\dvlp\workspaces\basicWorkspace\mcy-sb-slf4j-log4j2\target\test-classes  
	[INFO]  
	[INFO] --- maven-surefire-plugin:2.22.1:test (default-test) @ mcy-sb-slf4j-log4j2 ---  
	[INFO]  
	[INFO] -------------------------------------------------------  
	[INFO]  T E S T S  
	[INFO] -------------------------------------------------------  
	[INFO] Running com.mcy.StartupApplicationTests.   ____          _            __ _ _  
	 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \  
	( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \  
	 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )  
	  '  |____| .__|_| |_|_| |_\__, | / / / /  
	 =========|_|==============|___/=/_/_/_/  
	 :: Spring Boot ::        (v2.1.2.RELEASE)2019-01-20 12:28:14.765  INFO 12788 --- [           main] c.m.StartupApplicationTests              : Starting StartupApplicationTests on DESKTOP-GDILEJ9 with PID 12788 (started by PC in C:\dvlp\workspaces\basicWorkspace\mcy-sb-slf4j-log4j2)  
	2019-01-20 12:28:14.767  INFO 12788 --- [           main] c.m.StartupApplicationTests              : No active profile set, falling back to default profiles: default  
	2019-01-20 12:28:15.048  INFO 12788 --- [           main] c.m.SpringBean                           : info  
	2019-01-20 12:28:15.048 ERROR 12788 --- [           main] c.m.SpringBean                           : error  
	2019-01-20 12:28:15.105  INFO 12788 --- [           main] c.m.StartupApplicationTests              : Started StartupApplicationTests in 0.575 seconds (JVM running for 1.277)  
	2019-01-20 12:28:15.230  INFO 12788 --- [           main] c.m.SpringBean                           : info  
	2019-01-20 12:28:15.231 ERROR 12788 --- [           main] c.m.SpringBean                           : error  
	[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 1.218 s - in com.mcy.StartupApplicationTests  
	[INFO]  
	[INFO] Results:  
	[INFO]  
	[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0  
	[INFO]  
	[INFO] ------------------------------------------------------------------------  
	[INFO] BUILD SUCCESS  
	[INFO] ------------------------------------------------------------------------  
	[INFO] Total time:  5.166 s  
	[INFO] Finished at: 2019-01-20T12:28:15+03:00  
	[INFO] ------------------------------------------------------------------------  
	PS C:\dvlp\workspaces\basicWorkspace\mcy-sb-slf4j-log4j2>

Yukarıda örnekleri verilmiş koda [https://github.com/mehmetcemyucel/springboot-slf4j-log4j2](https://github.com/mehmetcemyucel/springboot-slf4j-log4j2) adresinden ulaşabilirsiniz.


***En yalın haliyle***

[**Mehmet Cem Yücel**](https://www.mehmetcemyucel.com)

---

 - [Spring Boot Devtools ile Docker Üzerindeki Kodu Debug Etme ve Değiştirme](https://www.mehmetcemyucel.com/2019/spring-boot-devtools-ile-docker-uzerindeki-kodu-debug-etme-ve-degistirme/)
 - [Twelve Factor Nedir Türkçe ve Java Örnekleri](https://www.mehmetcemyucel.com/2019/twelve-factor-nedir-turkce-ornek/)

**_Blockchain teknolojisi ile ilgileniyor iseniz bunlar da hoşunuza gidebilir:_**

 - [BlockchainTurk.net yazıları](https://www.mehmetcemyucel.com/categories/#blockchain)
---
