---
title:  "Spring Native Örnek Uygulama"
date:   2021-04-18 13:04:23
categories: [mimari, java, spring, jvm, spring boot, maven, graalvm]
tags: [native, spring native, java, spring boot, graalvm, mikroservis, microservice, kubernetes, ahead of time, just in time, compiler, native, image, docker, türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://cdn-images-1.medium.com/max/150/1*uPfmqByjfzpW8Y6iBFrpTg.png
---
[Önceki yazımızda](https://www.mehmetcemyucel.com/2021/spring-native-ve-graalvm/) girişini yaptığımız [**Spring Native**](https://docs.spring.io/spring-native/docs/current/reference/htmlsingle/)  nedir, nasıl çalışır gibi konuların uygulaması niteliğinde bir yazıyla devam ediyoruz. Bu yazımızda bahsettiğimiz konular hakkında örnek bir uygulama yaparken karşınıza çıkabilecek problemler ve çözüm yollarını birlikte inceleyeceğiz. [GraalVM](https://www.graalvm.org/) nedir, [LLVM](https://llvm.org/) nedir, nasıl çalışır gibi bilgiler bu çalışmamızda karşılaşacağımız problemlerin çözümlerini anlayabilmek için gerekebilecek temel bilgiler, bunun için de takıldığınız yerde ilk yazımıza göz atmanızı öneririm.

## Giriş

Kodlamaya başlamadan önce dikkat etmemiz gereken bir konu, bu çalışma henüz **beta** aşamasında olduğunun farkında olarak çalışmamız gerektiği :) Öngörülmemiş hatalar, problemlerle karşılaşmanız çok olası. Henüz beta da olsa değerli ve kritik bir konu olduğu için bu konunun üzerine eğilmek anlamlı olabilir. Bu yazımızın da destekleyici olmaya çalışacağı noktalar yaşayabileceğiniz problemleri hafifletmek üzerine olacak, size en basit haliyle çalışan bir uygulama ortaya çıkarıp kıyaslama yapmaya çalışacağız.

O zaman versiyonlarımızla başlayalım. Bu yazıyı yazarken Spring Native projesinin son versiyonu `0.9.1` idi. Bu versiyon üzerinden bir Spring Boot projesi ayağa kaldırarak demomuzu gerçekleştirelim. `0.9.1` Spring Native’in desteklediği Spring Boot versiyonumuz `2.4.4`'tür. Bu bilgileri aklımızdan bilmemize gerek yok çünkü [https://start.spring.io/](https://start.spring.io/) sitesi üzerinden Spring Native projesi ayağa kaldırmaya çalıştığınızda otomatik olarak bu versiyonlar uyumlu versiyonlar olarak yaratılacak.

![](https://cdn-images-1.medium.com/max/800/1*uPfmqByjfzpW8Y6iBFrpTg.png)

{% include feed-ici-yazi-1.html %}

## Desteklenen Spring Starterlar

Native bir projede birlikte kullanabileceğiniz starterlar önem taşıyor. Şu anda 1,5 senelik çalışma sonrası bir çok starter desteklenir duruma gelmiş vaziyette. Aşağıda desteği gelen core starterların listesi bulunuyor.

`spring-boot-starter-actuator` `spring-boot-starter-data-elasticsearch` `spring-boot-starter-data-jdbc` `spring-boot-starter-data-jpa*` `spring-boot-starter-data-mongodb` `spring-boot-starter-data-neo4j` `spring-boot-starter-data-r2dbc` `spring-boot-starter-data-redis` `spring-boot-starter-jdbc` `spring-boot-starter-logging*` `spring-boot-starter-mail` `spring-boot-starter-thymeleaf` `spring-boot-starter-rsocket` `spring-boot-starter-validation` `spring-boot-starter-security` `spring-boot-starter-oauth2-resource-server` `spring-boot-starter-oauth2-client` `spring-boot-starter-webflux*` `spring-boot-starter-web*` `spring-boot-starter-websocket` `com.wavefront:wavefront-spring-boot-starter`

Spring Cloud starterlarında da aşağıdaki liste mevcut.

`spring-cloud-starter-bootstrap` `spring-cloud-starter-config` `spring-cloud-config-client` `spring-cloud-config-server` `spring-cloud-starter-netflix-eureka-client*` `spring-cloud-function-web*` `spring-cloud-function-adapter-aws` `spring-cloud-starter-function-webflux*` `spring-cloud-starter-sleuth`

Bunların dışında `lombok` `Spring Kafka` `GRPC` `H2 Database` `Mysql JDBC Driver` `PostreSQL JDBC Driver` destekleri de açıklanmış durumda. Yukarıdaki listedeki yanlarında * olan modüllerdeki kısıtlar için [bu sayfaya](https://docs.spring.io/spring-native/docs/current/reference/htmlsingle/#support-spring-boot) göz atmanızı öneririm.

## Örnek Uygulama

Uygulamamıza geri dönelim. Yukarıda bahsettiğimiz birkaç starter’ı kullanarak demo bir proje yapalım.

-   Db olarak in-memory `H2 Database`
-   ORM ihtiyacı için `spring-boot-starter-data-jpa`
-   web servisle crud işlemleri yapabilmek için `spring-boot-starter-web`
-   bu servislere basit bir authentication kurgusu için `spring-boot-starter-security`
-   toolkit olarak da `lombok` kullanacak şekilde projemi yarattım. Java 1.8i tercih ettim. Pom’umuzun son durumu aşağıdaki gibi oldu.

<script src="https://gist.github.com/mehmetcemyucel/69b1aea6c2a4fac44ee467e7680a8a57.js"></script>

### Projenin Çalıştırılması

Projenizi bu haliyle “**Run”** butonuna basıp çalıştırırsak aşağıdaki gibi bir hata alırız. Örneğin çalıştırdığımda aşağıdaki hatayı aldım.

	Connected to the target VM, address: ‘127.0.0.1:56650’, transport: ‘socket’  
	2021–13–32 00:00:00.00 ERROR 16764 — — [ main] o.s.b.d.LoggingFailureAnalysisReporter :

	***************************  
	APPLICATION FAILED TO START  
	***************************

	Description:

	The ApplicationContext could not start as ‘org.springframework.aot.StaticSpringFactories’ that is generated by the Spring AOT plugin could not be found.

	Action:

	Review your local configuration and make sure that the Spring AOT plugin is configured properly.  
	If you’re trying to run your application with ‘mvn spring-boot:run’, please use ‘mvn package spring-boot:run’ instead.  
	See [https://docs.spring.io/spring-native/docs/current/reference/htmlsingle/#spring-aot](https://docs.spring.io/spring-native/docs/current/reference/htmlsingle/#spring-aot) for more details.

	Disconnected from the target VM, address: ‘127.0.0.1:56650’, transport: ‘socket’

	Process finished with exit code 1

Burada projenin Spring AOT tarafından derlenmeye çalışıldığını ancak hata aldığını iletiyor. `mvn spring-aot:generate` komutuyla paketleme yapılarak çalıştırılabilir. Ancak her build öncesi manuel işlemden kurtulmak bir işlem yapmamız gerekiyor. Örneğin ben IntelliJ kullanıyorum, IntelliJ’nin maven tabında Plugins>>spring-aot>>spring-aot:generate goal’ünün üzerine sağ tıklayıp “Execute Before Build” seçerek her buildin öncesinde pom’umuzda ekli aot maven plugini ile build’in alınmasını sağlıyoruz.

![](https://cdn-images-1.medium.com/max/800/1*mj3FdOe2RvDPDNssaTJuxA.png)

Şu anda IntelliJ’nin Run butonuna bastığımızda ilk önce yukarıda yapılandırmasını yaptığımız build çalışıyor.

	-Dmaven.multiModuleProjectDirectory=C:\Users\PC\Desktop\mcy\spring-native-example -Dmaven.home=C:\dvlp\intellij\plugins\maven\lib\maven3 -Dclassworlds.conf=C:\dvlp\intellij\plugins\maven\lib\maven3\bin\m2.conf -Dmaven.ext.class.path=C:\dvlp\intellij\plugins\maven\lib\maven-event-listener.jar -Dfile.encoding=UTF-8 -classpath C:\dvlp\intellij\plugins\maven\lib\maven3\boot\plexus-classworlds-2.6.0.jar org.codehaus.classworlds.Launcher -Didea.version2019.2.3 org.springframework.experimental:spring-aot-maven-plugin:0.9.1:generate  
	[INFO] Scanning for projects…  
	[INFO]   
	[INFO] — — — — — — — — — -< com.cem:spring-native-example > — — — — — — — — — —   
	[INFO] Building spring-native-example 0.0.1-SNAPSHOT  
	[INFO] — — — — — — — — — — — — — — — — [ jar ] — — — — — — — — — — — — — — — — -  
	[INFO]   
	[INFO] — — spring-aot-maven-plugin:0.9.1:generate (default-cli) @ spring-native-example — -  
	[INFO] Spring Native operating mode: native  
	[WARNING] Failed verification check: Invalid attempt to add bundle to configuration, no bundles found for this pattern: org.hibernate.validator.ValidationMessages  
	[WARNING] Failed verification check: this type was requested to be added to configuration but is not resolvable: io.netty.channel.socket.nio.NioSocketChannel it will be skipped  
	[WARNING] Failed verification check: this type was requested to be added to configuration but is not resolvable: org.springframework.messaging.handler.annotation.MessageMapping it will be skipped  
	[WARNING] Failed verification check: this type was requested to be added to configuration but is not resolvable: org.springframework.web.reactive.socket.server.upgrade.UndertowRequestUpgradeStrategy it will be skipped  
	[WARNING] Failed verification check: this type was requested to be added to configuration but is not resolvable: org.springframework.web.reactive.socket.server.upgrade.JettyRequestUpgradeStrategy it will be skipped  
	[WARNING] Failed verification check: this type was requested to be added to configuration but is not resolvable: org.springframework.web.reactive.socket.server.upgrade.TomcatRequestUpgradeStrategy it will be skipped  
	[INFO] Changes detected — recompiling the module!  
	[INFO] Compiling 15 source files to C:\Users\PC\Desktop\mcy\spring-native-example\target\classes  
	[INFO] /C:/Users/PC/Desktop/mcy/spring-native-example/target/generated-sources/spring-aot/src/main/java/org/springframework/aot/StaticSpringFactories.java: C:\Users\PC\Desktop\mcy\spring-native-example\target\generated-sources\spring-aot\src\main\java\org\springframework\aot\StaticSpringFactories.java uses or overrides a deprecated API.  
	[INFO] /C:/Users/PC/Desktop/mcy/spring-native-example/target/generated-sources/spring-aot/src/main/java/org/springframework/aot/StaticSpringFactories.java: Recompile with -Xlint:deprecation for details.  
	[INFO] /C:/Users/PC/Desktop/mcy/spring-native-example/target/generated-sources/spring-aot/src/main/java/org/springframework/aot/StaticSpringFactories.java: Some input files use unchecked or unsafe operations.  
	[INFO] /C:/Users/PC/Desktop/mcy/spring-native-example/target/generated-sources/spring-aot/src/main/java/org/springframework/aot/StaticSpringFactories.java: Recompile with -Xlint:unchecked for details.  
	[INFO] Using ‘UTF-8’ encoding to copy filtered resources.  
	[INFO] Using ‘UTF-8’ encoding to copy filtered properties files.  
	[INFO] Copying 5 resources  
	[INFO] — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — —   
	[INFO] BUILD SUCCESS  
	[INFO] — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — —   
	[INFO] Total time: 8.046 s  
	[INFO] Finished at: 2021–03–28T18:48:37+03:00  
	[INFO] — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — 

Sonrasında da uygulamamız ayağa kalkıyor.

	“C:\Program Files\Java\jdk1.8.0_191\bin\java.exe” -agentlib:jdwp=transport=dt_socket,address=127.0.0.1:59359,suspend=y,server=n -XX:TieredStopAtLevel=1 -noverify -Dspring.output.ansi.enabled=always ...” com.cem.springnativeexample.SpringNativeExampleApplication  
	Connected to the target VM, address: ‘127.0.0.1:59359’, transport: ‘socket’  
	2021–03–28 18:48:42.151 INFO 15564 — — [ main] o.s.nativex.NativeListener : This application is bootstrapped with code generated with Spring AOT

	. ____ _ __ _ _  
	 /\\ / ___’_ __ _ _(_)_ __ __ _ \ \ \ \  
	( ( )\___ | ‘_ | ‘_| | ‘_ \/ _` | \ \ \ \  
	 \\/ ___)| |_)| | | | | || (_| | ) ) ) )  
	 ‘ |____| .__|_| |_|_| |_\__, | / / / /  
	 =========|_|==============|___/=/_/_/_/  
	 :: Spring Boot :: (v2.4.4)

	2021–03–28 18:48:42.217 INFO 15564 — — [ main] c.c.s.SpringNativeExampleApplication : Starting SpringNativeExampleApplication using Java 1.8.0_191 on DESKTOP-GDILEJ9 with PID 15564 (C:\Users\PC\Desktop\mcy\spring-native-example\target\classes started by PC in C:\Users\PC\Desktop\mcy\spring-native-example)  
	2021–03–28 18:48:42.218 INFO 15564 — — [ main] c.c.s.SpringNativeExampleApplication : No active profile set, falling back to default profiles: default  
	2021–03–28 18:48:42.667 INFO 15564 — — [ main] .s.d.r.c.RepositoryConfigurationDelegate : Bootstrapping Spring Data JPA repositories in DEFAULT mode.  
	2021–03–28 18:48:42.733 INFO 15564 — — [ main] .s.d.r.c.RepositoryConfigurationDelegate : Finished Spring Data repository scanning in 55 ms. Found 1 JPA repository interfaces.  
	2021–03–28 18:48:43.433 INFO 15564 — — [ main] o.s.b.w.embedded.tomcat.TomcatWebServer : Tomcat initialized with port(s): 8081 (http)  
	2021–03–28 18:48:43.441 INFO 15564 — — [ main] o.apache.catalina.core.StandardService : Starting service [Tomcat]  
	2021–03–28 18:48:43.442 INFO 15564 — — [ main] org.apache.catalina.core.StandardEngine : Starting Servlet engine: [Apache Tomcat/9.0.44]  
	2021–03–28 18:48:43.551 INFO 15564 — — [ main] o.a.c.c.C.[Tomcat].[localhost].[/] : Initializing Spring embedded WebApplicationContext  
	2021–03–28 18:48:43.551 INFO 15564 — — [ main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 1301 ms  
	2021–03–28 18:48:43.810 INFO 15564 — — [ main] com.zaxxer.hikari.HikariDataSource : HikariPool-1 — Starting…  
	2021–03–28 18:48:43.905 INFO 15564 — — [ main] com.zaxxer.hikari.HikariDataSource : HikariPool-1 — Start completed.  
	2021–03–28 18:48:43.942 INFO 15564 — — [ main] o.hibernate.jpa.internal.util.LogHelper : HHH000204: Processing PersistenceUnitInfo [name: default]  
	2021–03–28 18:48:43.986 INFO 15564 — — [ main] org.hibernate.Version : HHH000412: Hibernate ORM core version 5.4.29.Final  
	2021–03–28 18:48:44.091 INFO 15564 — — [ main] o.hibernate.annotations.common.Version : HCANN000001: Hibernate Commons Annotations {5.1.2.Final}  
	2021–03–28 18:48:44.198 INFO 15564 — — [ main] org.hibernate.dialect.Dialect : HHH000400: Using dialect: org.hibernate.dialect.H2Dialect  
	2021–03–28 18:48:44.557 INFO 15564 — — [ main] o.h.e.t.j.p.i.JtaPlatformInitiator : HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]  
	2021–03–28 18:48:44.567 INFO 15564 — — [ main] j.LocalContainerEntityManagerFactoryBean : Initialized JPA EntityManagerFactory for persistence unit ‘default’  
	2021–03–28 18:48:44.614 WARN 15564 — — [ main] JpaBaseConfiguration$JpaWebConfiguration : spring.jpa.open-in-view is enabled by default. Therefore, database queries may be performed during view rendering. Explicitly configure spring.jpa.open-in-view to disable this warning  
	2021–03–28 18:48:44.956 INFO 15564 — — [ main] o.s.s.web.DefaultSecurityFilterChain : Will secure any request with [org.springframework.security.web.context.request.async.WebAsyncManagerIntegrationFilter@65015a49, org.springframework.security.web.context.SecurityContextPersistenceFilter@22604c7e, org.springframework.security.web.header.HeaderWriterFilter@352c3d70, org.springframework.security.web.csrf.CsrfFilter@369a95a5, org.springframework.security.web.authentication.logout.LogoutFilter@6bdedbbd, org.springframework.security.web.savedrequest.RequestCacheAwareFilter@6d4502ca, org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestFilter@6b6fd0, org.springframework.security.web.authentication.AnonymousAuthenticationFilter@44e08a7a, org.springframework.security.web.session.SessionManagementFilter@44485db, org.springframework.security.web.access.ExceptionTranslationFilter@25dcf1b6, org.springframework.security.web.access.intercept.FilterSecurityInterceptor@615ef20]  
	2021–03–28 18:48:45.062 INFO 15564 — — [ main] o.s.s.concurrent.ThreadPoolTaskExecutor : Initializing ExecutorService ‘applicationTaskExecutor’  
	2021–03–28 18:48:45.244 INFO 15564 — — [ main] o.s.b.w.embedded.tomcat.TomcatWebServer : Tomcat started on port(s): 8081 (http) with context path ‘’  
	2021–03–28 18:48:45.249 INFO 15564 — — [ main] c.c.s.SpringNativeExampleApplication : Started SpringNativeExampleApplication in 3.509 seconds (JVM running for 4.265)

### Uygulama Detayları

Basit bir in-memory authentication kurgusu yapalım.

<script src="https://gist.github.com/mehmetcemyucel/5401b47b3dce0b935c34ad2b638b0e6e.js"></script>

Yine basit bir Controller ile CRUD işlemlerini Spring Data JPA ile in-memory H2 DB’sine indirelim.

<script src="https://gist.github.com/mehmetcemyucel/22a97277456b1ecacbb72242ea1c6d17.js"></script>

<script src="https://gist.github.com/mehmetcemyucel/b86acf6dc5baf875f8a72b54bd81be31.js"></script>

<script src="https://gist.github.com/mehmetcemyucel/699c9b40f41c818cf52aba49d5a173d2.js"></script>

Dikkat edilmesi gereken bir nokta, cglib proxy’leri artık desteği verilemediği için @SpringBootApplication annotationı içerisinde default true olarak set edilmiş durumda bulunan `proxyBeanMethods` değerinin false olarak değiştirilmesi gereklidir.

<script src="https://gist.github.com/mehmetcemyucel/b73e590a6e3893718738a879cfc3a35c.js"></script>

Kodumuz kaba haliyle bu şekilde. Şimdi uygulamamızın build işlemi sonrasında ne kadar sürede açıldığına bakalım. Uygulamamızı paketleyip java -jar ile çalıştırıyoruz

	2021–03–28 19:33:09.452 INFO 10260 — — [ main] o.s.nativex.NativeListener : This application is bootstrapped with code generated with Spring AOT

	. ____ _ __ _ _  
	 /\\ / ___’_ __ _ _(_)_ __ __ _ \ \ \ \  
	( ( )\___ | ‘_ | ‘_| | ‘_ \/ _` | \ \ \ \  
	 \\/ ___)| |_)| | | | | || (_| | ) ) ) )  
	 ‘ |____| .__|_| |_|_| |_\__, | / / / /  
	 =========|_|==============|___/=/_/_/_/  
	 :: Spring Boot :: (v2.4.4)

	2021–03–28 19:33:09.521 INFO 10260 — — [ main] c.c.s.SpringNativeExampleApplication : Starting SpringNativeExampleApplication using Java 1.8.0_191 on DESKTOP-GDILEJ9 with PID 10260 (C:\Users\PC\Desktop\mcy\spring-native-example\target\classes started by PC in C:\Users\PC\Desktop\mcy\spring-native-example)  
	2021–03–28 19:33:09.521 INFO 10260 — — [ main] c.c.s.SpringNativeExampleApplication : No active profile set, falling back to default profiles: default  
	2021–03–28 19:33:09.912 INFO 10260 — — [ main] .s.d.r.c.RepositoryConfigurationDelegate : Bootstrapping Spring Data JPA repositories in DEFAULT mode.  
	2021–03–28 19:33:09.960 INFO 10260 — — [ main] .s.d.r.c.RepositoryConfigurationDelegate : Finished Spring Data repository scanning in 40 ms. Found 1 JPA repository interfaces.  
	2021–03–28 19:33:10.400 INFO 10260 — — [ main] trationDelegate$BeanPostProcessorChecker : Bean ‘org.springframework.security.access.expression.method.DefaultMethodSecurityExpressionHandler@e5cbff2’ of type [org.springframework.security.access.expression.method.DefaultMethodSecurityExpressionHandler] is not eligible for getting processed by all BeanPostProcessors (for example: not eligible for auto-proxying)  
	2021–03–28 19:33:10.404 INFO 10260 — — [ main] trationDelegate$BeanPostProcessorChecker : Bean ‘methodSecurityMetadataSource’ of type [org.springframework.security.access.method.DelegatingMethodSecurityMetadataSource] is not eligible for getting processed by all BeanPostProcessors (for example: not eligible for auto-proxying)  
	2021–03–28 19:33:10.624 INFO 10260 — — [ main] o.s.b.w.embedded.tomcat.TomcatWebServer : Tomcat initialized with port(s): 8081 (http)  
	2021–03–28 19:33:10.633 INFO 10260 — — [ main] o.apache.catalina.core.StandardService : Starting service [Tomcat]  
	2021–03–28 19:33:10.633 INFO 10260 — — [ main] org.apache.catalina.core.StandardEngine : Starting Servlet engine: [Apache Tomcat/9.0.44]  
	2021–03–28 19:33:10.736 INFO 10260 — — [ main] o.a.c.c.C.[Tomcat].[localhost].[/] : Initializing Spring embedded WebApplicationContext  
	2021–03–28 19:33:10.736 INFO 10260 — — [ main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 1182 ms  
	2021–03–28 19:33:10.977 INFO 10260 — — [ main] com.zaxxer.hikari.HikariDataSource : HikariPool-1 — Starting…  
	2021–03–28 19:33:11.072 INFO 10260 — — [ main] com.zaxxer.hikari.HikariDataSource : HikariPool-1 — Start completed.  
	2021–03–28 19:33:11.108 INFO 10260 — — [ main] o.hibernate.jpa.internal.util.LogHelper : HHH000204: Processing PersistenceUnitInfo [name: default]  
	2021–03–28 19:33:11.149 INFO 10260 — — [ main] org.hibernate.Version : HHH000412: Hibernate ORM core version 5.4.29.Final  
	2021–03–28 19:33:11.270 INFO 10260 — — [ main] o.hibernate.annotations.common.Version : HCANN000001: Hibernate Commons Annotations {5.1.2.Final}  
	2021–03–28 19:33:11.375 INFO 10260 — — [ main] org.hibernate.dialect.Dialect : HHH000400: Using dialect: org.hibernate.dialect.H2Dialect  
	2021–03–28 19:33:11.728 INFO 10260 — — [ main] o.h.e.t.j.p.i.JtaPlatformInitiator : HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]  
	2021–03–28 19:33:11.738 INFO 10260 — — [ main] j.LocalContainerEntityManagerFactoryBean : Initialized JPA EntityManagerFactory for persistence unit ‘default’  
	2021–03–28 19:33:11.786 WARN 10260 — — [ main] JpaBaseConfiguration$JpaWebConfiguration : spring.jpa.open-in-view is enabled by default. Therefore, database queries may be performed during view rendering. Explicitly configure spring.jpa.open-in-view to disable this warning  
	2021–03–28 19:33:12.352 INFO 10260 — — [ main] o.s.s.web.DefaultSecurityFilterChain : Will secure any request with [org.springframework.security.web.context.request.async.WebAsyncManagerIntegrationFilter@41026e5c, org.springframework.security.web.context.SecurityContextPersistenceFilter@1c135f63, org.springframework.security.web.header.HeaderWriterFilter@252d8df6, org.springframework.security.web.authentication.logout.LogoutFilter@28b2e4d8, org.springframework.security.web.authentication.[www.BasicAuthenticationFilter@6c9151c1](http://www.BasicAuthenticationFilter@6c9151c1), org.springframework.security.web.savedrequest.RequestCacheAwareFilter@29bd2796, org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestFilter@1f3361e9, org.springframework.security.web.authentication.AnonymousAuthenticationFilter@12421766, org.springframework.security.web.session.SessionManagementFilter@5dce5c03, org.springframework.security.web.access.ExceptionTranslationFilter@37fca349, org.springframework.security.web.access.intercept.FilterSecurityInterceptor@73b8ab2c]  
	2021–03–28 19:33:12.474 INFO 10260 — — [ main] o.s.s.concurrent.ThreadPoolTaskExecutor : Initializing ExecutorService ‘applicationTaskExecutor’  
	2021–03–28 19:33:12.697 INFO 10260 — — [ main] o.s.b.w.embedded.tomcat.TomcatWebServer : Tomcat started on port(s): 8081 (http) with context path ‘’  
	2021–03–28 19:33:12.703 INFO 10260 — — [ main] **c.c.s.SpringNativeExampleApplication : Started SpringNativeExampleApplication in 3.786 seconds (JVM running for 4.579)**

Uygulamamız OpenJDK ile standart VM üzerinde 3.786 saniyede açıldı. Tamamen in-memory(auth, db) çalışan, dış bağımlılığı olmayan ve ortalama gereksinimleri karşılayan bir web Spring Boot projesinin ayağa kalkması ortalama 3,5–4 sn civarında sürüyor.

### Native Image Oluşturma

Artık can alıcı kısımlara geldik. Şimdi kodumuzu native image olarak derleyelim. Derleme için `mvn spring-boot:build-image` goal’ünü çalıştırmamız gerekiyor. Bunun çalışması için makinenizde Docker Deamon’ın ayakta ve çalışıyor olması gerekiyor.

Uzun bir çalışmadan(5–6 dk) sonra aşağıdaki gibi bir hata alıp derleme yarıda kesiliyor. Aşağıdaki logdaki koyu yazılmış kısımlara bakalım

	...  
	[INFO] [creator] WARNING: Could not register reflection metadata for org.springframework.boot.autoconfigure.cache.HazelcastCacheConfiguration. Reason: java.lang.NoClassDefFoundError: com/hazelcast/core/HazelcastInstance.  
	**[INFO] [creator] Error: Image build request failed with exit status 137  
	[INFO] [creator] unable to invoke layer creator  
	[INFO] [creator] unable to contribute native-image layer  
	[INFO] [creator] error running build  
	[INFO] [creator] exit status 137  
	[INFO] [creator] ERROR: failed to build: exit status 1**  
	[INFO] — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — —   
	[INFO] BUILD FAILURE  
	[INFO] — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — —   
	[INFO] Total time: 05:44 min  
	[INFO] Finished at: 2021–03–28T19:44:10+03:00  
	[INFO] — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — —   
	[ERROR] Failed to execute goal org.springframework.boot:spring-boot-maven-plugin:2.4.4:build-image (default-cli) on project spring-native-example: **Execution default-cli of goal org.springframework.boot:spring-boot-maven-plugin:2.4.4:build-image failed: Builder lifecycle ‘creator’ failed with status code 145 ->** [Help 1]  
	[ERROR]  
	[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.  
	[ERROR] Re-run Maven using the -X switch to enable full debug logging.  
	[ERROR]  
	[ERROR] For more information about the errors and possible solutions, please read the following articles:  
	[ERROR] [Help 1] [http://cwiki.apache.org/confluence/display/MAVEN/PluginExecutionException](http://cwiki.apache.org/confluence/display/MAVEN/PluginExecutionException)

Bunun sebebi Docker’da image yaratılırken yetersiz bellekten dolayı **Out of Memory(OoM)** vererek derleme yarıda kesildi. Kodun native olarak derlenmesi maliyetli bir süreç. Spring Native ekibinin [önerisi](https://docs.spring.io/spring-native/docs/current/reference/htmlsingle/#_system_requirements) **en az 8GB’lık memory**’nin Docker’a tahsis edilmesi yönünde :) Derlemenin süresi makinenin CPU gücüne de bağlı olsa da memory burada kritik nokta.

Bu problemi aşabilmek için yapmamız gereken Docker uygulamasının ayarlarına gidip kullanabileceği memory miktarını yükseltmek olacak.

![](https://cdn-images-1.medium.com/max/800/1*Tw05hSjA6-azCwLgr-p-hQ.png)

{% include feed-ici-yazi-2.html %}

Kendi makinemde 10GB kadar bir memory verdikten sonra tekrar native image’ın oluşturulması için maven’ı tetikliyorum. 16 dk sonra :) aşağıdaki loglarla imaj oluşturuluyor. Burada dikkat çekmek istediği kısım mavenda tanımladığımız aot plugin’inin yaptıkları. Bu sebeple geri kalan logu kırpıyorum. Plugin loglarında da bold yaptığım yerler değerli kısımlar, birlikte inceleyelim.

	>mvn spring-boot:build-image  
	[INFO] Scanning for projects…  
	[INFO]  
	[INFO] — — — — — — — — — -< com.cem:spring-native-example > — — — — — — — — — —   
	.......

	.......  
	[INFO]  
	[INFO] — — spring-aot-maven-plugin:0.9.1:generate (generate) @ spring-native-example — -  
	[INFO] Spring Native operating mode: native  
	[WARNING] Failed verification check: Invalid attempt to add bundle to configuration, no bundles found for this pattern: org.hibernate.validator.ValidationMessages  
	**....**

	**....**_Bir miktar benzer warning_

	[INFO] Changes detected — recompiling the module!  
	[INFO] Compiling 15 source files to C:\Users\PC\Desktop\mcy\spring-native-example\target\classes  
	[INFO] /C:/Users/PC/Desktop/mcy/spring-native-example/target/generated-sources/spring-aot/src/main/java/org/springframework/aot/StaticSpringFactories.java: C:\Users\PC\Desktop\mcy\spring-native-example\target\generated-sources\spring-aot\src\main\java\org\springframework\aot\StaticSpringFactories.java uses or overrides a deprecated API.  
	[INFO] /C:/Users/PC/Desktop/mcy/spring-native-example/target/generated-sources/spring-aot/src/main/java/org/springframework/aot/StaticSpringFactories.java: Recompile with -Xlint:deprecation for details.  
	[INFO] /C:/Users/PC/Desktop/mcy/spring-native-example/target/generated-sources/spring-aot/src/main/java/org/springframework/aot/StaticSpringFactories.java: Some input files use unchecked or unsafe operations.  
	[INFO] /C:/Users/PC/Desktop/mcy/spring-native-example/target/generated-sources/spring-aot/src/main/java/org/springframework/aot/StaticSpringFactories.java: Recompile with -Xlint:unchecked for details.  
	[INFO] Using ‘UTF-8’ encoding to copy filtered resources.  
	[INFO] Using ‘UTF-8’ encoding to copy filtered properties files.  
	[INFO] Copying 5 resources  
	[INFO]  
	[INFO] — — maven-jar-plugin:3.2.0:jar (default-jar) @ spring-native-example — -  
	[INFO] Building jar: C:\Users\PC\Desktop\mcy\spring-native-example\target\spring-native-example-0.0.1-SNAPSHOT.jar  
	[INFO]  
	[INFO] — — spring-boot-maven-plugin:2.4.4:repackage (repackage) @ spring-native-example — -  
	[INFO] Replacing main artifact with repackaged archive  
	[INFO]  
	[INFO] <<< spring-boot-maven-plugin:2.4.4:build-image (default-cli) < package @ spring-native-example <<<  
	[INFO]  
	[INFO]  
	[INFO] — — spring-boot-maven-plugin:2.4.4:build-image (default-cli) @ spring-native-example — -  
	[INFO] Building image ‘docker.io/library/spring-native-example:0.0.1-SNAPSHOT’  
	[INFO]  
	**[INFO] >** **Pulling builder image ‘docker.io/paketobuildpacks/builder:tiny’ 100%**  
	[INFO] > Pulled builder image ‘paketobuildpacks/builder@sha256:09f5a515f9cf692ef1a23fcf6f2951e3f33c819deb38991fd3fd99a075d0c352’  
	[INFO] > Pulling run image ‘docker.io/paketobuildpacks/run:tiny-cnb’ 100%  
	[INFO] > Pulled run image ‘paketobuildpacks/run@sha256:f35345771f18118a5632def411d3c3e688384e603c35e899d7b7f78b516f3539’  
	[INFO] > Executing lifecycle version v0.10.2  
	[INFO] > Using build cache volume ‘pack-cache-84569b7302ee.build’  
	[INFO]  
	**[INFO] > Running creator**  
	[INFO] [creator] ===> DETECTING  
	[INFO] [creator] 4 of 11 buildpacks participating  
	[INFO] [creator] paketo-buildpacks/graalvm 6.0.0  
	[INFO] [creator] paketo-buildpacks/executable-jar 5.0.0  
	[INFO] [creator] paketo-buildpacks/spring-boot 4.1.0  
	[INFO] [creator] paketo-buildpacks/native-image 4.0.0  
	[INFO] [creator] ===> ANALYZING  
	[INFO] [creator] Previous image with name “docker.io/library/spring-native-example:0.0.1-SNAPSHOT” not found  
	[INFO] [creator] ===> RESTORING  
	[INFO] [creator] ===> BUILDING  
	[INFO] [creator]  
	**[INFO] [creator] Paketo GraalVM Buildpack 6.0.0**  
	[INFO] [creator] [https://github.com/paketo-buildpacks/graalvm](https://github.com/paketo-buildpacks/graalvm)  
	[INFO] [creator] Build Configuration:  
	[INFO] [creator] $BP_JVM_VERSION 8.* the Java version  
	[INFO] [creator] Launch Configuration:  
	[INFO] [creator] $BPL_JVM_HEAD_ROOM 0 the headroom in memory calculation  
	[INFO] [creator] $BPL_JVM_LOADED_CLASS_COUNT 35% of classes the number of loaded classes in memory calculation  
	[INFO] [creator] $BPL_JVM_THREAD_COUNT 250 the number of threads in memory calculation  
	[INFO] [creator] $JAVA_TOOL_OPTIONS the JVM launch flags  
	[INFO] [creator] GraalVM JDK 8.0.282: Contributing to layer  
	**[INFO] [creator] Downloading from** [**https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-21.0.0.2/graalvm-ce-java8-linux-amd64–21.0.0.2.tar.gz**](https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-21.0.0.2/graalvm-ce-java8-linux-amd64-21.0.0.2.tar.gz)  
	[INFO] [creator] Verifying checksum  
	[INFO] [creator] Expanding to /layers/paketo-buildpacks_graalvm/jdk  
	[INFO] [creator] Adding 129 container CA certificates to JVM truststore  
	[INFO] [creator] GraalVM Native Image Substrate VM 8.0.282  
	[INFO] [creator] Downloading from [https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-21.0.0.2/native-image-installable-svm-java8-linux-amd64-21.0.0.2.jar](https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-21.0.0.2/native-image-installable-svm-java8-linux-amd64-21.0.0.2.jar)  
	[INFO] [creator] Verifying checksum  
	[INFO] [creator] Installing substrate VM  
	[INFO] [creator] Processing Component archive: /tmp/e2a182c1f79d8a97b537b843eb65e15ef5ebdd088ad01acd606bf26b1846612e/native-image-installable-svm-java8-linux-amd64–21.0.0.2.jar  
	[INFO] [creator] Installing new component: Native Image (org.graalvm.native-image, version 21.0.0.2)  
	[INFO] [creator] Writing env.build/JAVA_HOME.override  
	[INFO] [creator] Writing env.build/JDK_HOME.override  
	[INFO] [creator]  
	[INFO] [creator] Paketo Executable JAR Buildpack 5.0.0  
	[INFO] [creator] [https://github.com/paketo-buildpacks/executable-jar](https://github.com/paketo-buildpacks/executable-jar)  
	[INFO] [creator] Class Path: Contributing to layer  
	[INFO] [creator] Writing env.build/CLASSPATH.delim  
	[INFO] [creator] Writing env.build/CLASSPATH.prepend  
	[INFO] [creator]  
	[INFO] [creator] Paketo Spring Boot Buildpack 4.1.0  
	[INFO] [creator] [https://github.com/paketo-buildpacks/spring-boot](https://github.com/paketo-buildpacks/spring-boot)  
	[INFO] [creator] Class Path: Contributing to layer  
	[INFO] [creator] Writing env.build/CLASSPATH.append  
	[INFO] [creator] Writing env.build/CLASSPATH.delim  
	[INFO] [creator] Image labels:  
	[INFO] [creator] org.opencontainers.image.title  
	[INFO] [creator] org.opencontainers.image.version  
	[INFO] [creator] org.springframework.boot.spring-configuration-metadata.json  
	[INFO] [creator] org.springframework.boot.version  
	[INFO] [creator]  
	[INFO] [creator] Paketo Native Image Buildpack 4.0.0  
	[INFO] [creator] [https://github.com/paketo-buildpacks/native-image](https://github.com/paketo-buildpacks/native-image)  
	[INFO] [creator] Build Configuration:  
	[INFO] [creator] $BP_NATIVE_IMAGE true enable native image build  
	[INFO] [creator] $BP_NATIVE_IMAGE_BUILD_ARGUMENTS arguments to pass to the native-image command  
	[INFO] [creator] Native Image: Contributing to layer  
	[INFO] [creator] GraalVM Version 21.0.0.2 (Java Version 1.8.0_282-b07)  
	[INFO] [creator] Executing native-image **-H:+StaticExecutableWithDynamicLibC -H:Name=/layers/paketo-buildpacks_native-image/native-image/com.cem.springnativeexample.SpringNativeExampleApplication -cp /workspace:/workspace/BOOT-INF/classes:/workspace/BOOT-INF/lib/aspectjweaver-1.9.6.jar:/workspace/BOOT-INF/lib/HikariCP-3.4.5.jar:/workspace/BOOT-  
	INF/lib/spring-jdbc-5.3.5.jar:/workspace/BOOT-INF/lib/jakarta.transaction-api-1.3.3.jar**:....  
	**....  
	.... _BU JARLAR BU ŞEKİLDE DEVAM EDİYOR_**  
	 **com.cem.springnativeexample.SpringNativeExampleApplication**

	[INFO] [creator] [/layers/paketo-buildpacks_native-image/native-image/com.cem.springnativeexample.SpringNativeExampleApplication:134] classlist: 11,521.79 ms, 2.18 GB  
	[INFO] [creator] Warning: class initialization of class org.springframework.boot.validation.MessageInterpolatorFactory failed with exception java.lang.NoClassDefFoundError: javax/validation/ValidationException. This class will be initialized at run time because option — allow-incomplete-classpath is used for image building. Use the option — initia  
	lize-at-run-time=org.springframework.boot.validation.MessageInterpolatorFactory to explicitly request delayed initialization of this class.  
	[INFO] [creator] [/layers/paketo-buildpacks_native-image/native-image/com.cem.springnativeexample.SpringNativeExampleApplication:134] (cap): 714.52 ms, 2.60 GB  
	**[INFO] [creator] .......  
	[INFO] [creator] [/layers/paketo-buildpacks_native-image/native-image/com.cem.springnativeexample.SpringNativeExampleApplication:134] (clinit): 2,480.84 ms, 5.53 GB  
	[INFO] [creator] [/layers/paketo-buildpacks_native-image/native-image/com.cem.springnativeexample.SpringNativeExampleApplication:134] (typeflow): 137,401.38 ms, 5.53 GB  
	[INFO] [creator] [/layers/paketo-buildpacks_native-image/native-image/com.cem.springnativeexample.SpringNativeExampleApplication:134] (objects): 88,175.32 ms, 5.53 GB  
	[INFO] [creator] [/layers/paketo-buildpacks_native-image/native-image/com.cem.springnativeexample.SpringNativeExampleApplication:134] (features): 12,543.15 ms, 5.53 GB  
	[INFO] [creator] [/layers/paketo-buildpacks_native-image/native-image/com.cem.springnativeexample.SpringNativeExampleApplication:134] analysis: 247,358.56 ms, 5.53 GB  
	[INFO] [creator] [/layers/paketo-buildpacks_native-image/native-image/com.cem.springnativeexample.SpringNativeExampleApplication:134] universe: 6,035.96 ms, 5.56 GB  
	[INFO] [creator] [/layers/paketo-buildpacks_native-image/native-image/com.cem.springnativeexample.SpringNativeExampleApplication:134] (parse): 29,388.27 ms, 4.83 GB  
	[INFO] [creator] [/layers/paketo-buildpacks_native-image/native-image/com.cem.springnativeexample.SpringNativeExampleApplication:134] (inline): 34,640.18 ms, 6.93 GB  
	[INFO] [creator] [/layers/paketo-buildpacks_native-image/native-image/com.cem.springnativeexample.SpringNativeExampleApplication:134] (compile): 112,634.27 ms, 7.40 GB  
	[INFO] [creator] [/layers/paketo-buildpacks_native-image/native-image/com.cem.springnativeexample.SpringNativeExampleApplication:134] compile: 182,218.51 ms, 7.40 GB  
	[INFO] [creator] [/layers/paketo-buildpacks_native-image/native-image/com.cem.springnativeexample.SpringNativeExampleApplication:134] image: 10,719.39 ms, 7.41 GB  
	[INFO] [creator] [/layers/paketo-buildpacks_native-image/native-image/com.cem.springnativeexample.SpringNativeExampleApplication:134] write: 1,875.78 ms, 7.16 GB  
	[INFO] [creator] [/layers/paketo-buildpacks_native-image/native-image/com.cem.springnativeexample.SpringNativeExampleApplication:134] [total]: 463,150.37 ms, 7.16 GB  
	[INFO] [creator] Removing bytecode**  
	[INFO] [creator] Process types:  
	[INFO] [creator] native-image: /workspace/com.cem.springnativeexample.SpringNativeExampleApplication (direct)  
	[INFO] [creator] task: /workspace/com.cem.springnativeexample.SpringNativeExampleApplication (direct)  
	[INFO] [creator] web: /workspace/com.cem.springnativeexample.SpringNativeExampleApplication (direct)  
	[INFO] [creator] ===> EXPORTING  
	[INFO] [creator] Adding 1/1 app layer(s)  
	[INFO] [creator] Adding layer ‘launcher’  
	[INFO] [creator] Adding layer ‘config’  
	[INFO] [creator] Adding layer ‘process-types’  
	[INFO] [creator] Adding label ‘io.buildpacks.lifecycle.metadata’  
	[INFO] [creator] Adding label ‘io.buildpacks.build.metadata’  
	[INFO] [creator] Adding label ‘io.buildpacks.project.metadata’  
	[INFO] [creator] Adding label ‘org.opencontainers.image.title’  
	[INFO] [creator] Adding label ‘org.opencontainers.image.version’  
	[INFO] [creator] Adding label ‘org.springframework.boot.spring-configuration-metadata.json’**  
	[INFO] [creator] Adding label ‘org.springframework.boot.version’  
	[INFO] [creator] Setting default process type ‘web’**  
	[INFO] [creator] *** Images (7ea3765b59b8):  
	[INFO] [creator] **docker.io/library/spring-native-example:0.0.1-SNAPSHOT**  
	[INFO] [creator] Adding cache layer ‘paketo-buildpacks/graalvm:jdk’  
	[INFO] [creator] Adding cache layer ‘paketo-buildpacks/native-image:native-image’  
	[INFO]  
	[INFO] Successfully built image ‘docker.io/library/spring-native-example:0.0.1-SNAPSHOT’  
	[INFO]  
	[INFO] — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — —   
	[INFO] BUILD SUCCESS  
	[INFO] — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — —   
	[INFO] Total time: 16:00 min  
	[INFO] Finished at: 2021–03–28T23:56:38+03:00  
	[INFO] — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — 

Burada yapılan işlemlere değinmekte fayda var. Öncelikle paketleme yapabilmek için **buildpack** kullanımı yapılmış. Konunun çok fazla dallanmaması için detaya girmemekle birlikte Cloud Native Buildpack’lerin ne olduğunu [buradaki link](https://buildpacks.io/)ten inceleyebilirsiniz. Paketo’nun [Java Native Image Buildpack](https://paketo.io/docs/buildpacks/language-family-buildpacks/java-native-image/)’i GraalVM’in içerisindeki [Native Image Builder](https://www.graalvm.org/reference-manual/native-image/)’ı kullanarak bu paketlemenin yapılmasını sağlıyor.

Bu işlem esnasında ortam değişkenleri, sertifikalar için trustedstore yapılandırmaları gibi birçok işlemle birlikte **-H:+StaticExecutableWithDynamicLibC** ile statik olarak çalışması istenen dinamik kütüphane listesi de GraalVM’e geçiliyor. Yani bizim starterlarımızın içerisinde gelen onlarca kütüphanenin direk makine koduna çevrileceği anlamını taşıyor.

Logdaki sonraki bold kısımlar GraalVM’in native kodu oluşturduğu kısımlar. Burada yapılan işlemler başka bir yazımızın konusu olabilir. Sonrasında da image layerları hazırlanıp imajımızın son hali oluşturuluyor. Oluşan imajımızı docker images komutu ile görebiliriz.

![](https://cdn-images-1.medium.com/max/800/1*68K2L6In4rGELacTZTCJEQ.png)

Yeni imajımızı çalıştıralım. Komutumuz:

`docker run -p 8081:8081 spring-native-example:0.0.1-SNAPSHOT`

	Error starting ApplicationContext. To display the conditions report re-run your application with ‘debug’ enabled.  
	2021–03–28 21:05:18.658 ERROR 1 — — [ main] o.s.boot.SpringApplication : Application run failed

	org.springframework.beans.factory.**BeanCreationException**: Error creating bean with name ‘userController’ defined in class path resource [com/cem/springnativeexample/controller/UserController.class]: Initialization of bean failed; nested exception is **com.oracle.svm.core.jdk.UnsupportedFeatureError**: Proxy class defined by interfaces [interface **org.springframework.aop.SpringProxy**, interface **org.springframework.aop.framework.Advised**, interface **org.springframework.core.DecoratingProxy**] not found. Generating proxy classes at runtime is not supported. Proxy classes need to be defined at image build time by specifying the list of interfaces that they implement. **To define proxy classes use -H:DynamicProxyConfigurationFiles=<comma-separated-config-files> and -H:DynamicProxyConfigurationResources=<comma-separated-config-resources> options.**  
	 at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:610) ~[na:na]  
	 at   
	 … 16 common frames omitted

Hatırlarsanız **native kodun runtime’da sürpriz sevmediği**nden bahsetmiştik. WebSecurity sınıfında **EnableGlobalMethodSecurity** annotationı ile açtığımız ve Controller sınıfında endpointlerin başlarında kullandığını **PrePost Security Role Controllerları** ile kullandığımız **Spring Expression Language**(SpEL) tam olarak native kodun sevmediği bir sürpriz :) Çünkü bu senaryoda SpEL çalışırken Dynamic Proxyler kullanarak runtimeda gelen isteğin sahibi olan clientın belirtilen authoritye sahip olup olmadığını controllerdaki method execute edilmeden kontrol ederek işlemin devam etmesini veya clientın 403 Forbidden hatası dönülmesini sağlıyor. Bütün bu paragrafta yazdıklarım SpEL desteklenmiyor gibi algılanmaması konusunda bir not düşmekte fayda var, lakin uygulamanın footprint’ini düşürmek için AOT plugin’ine verilebilecek optimizasyonlardan birisi de SpEL’in devre dışı bırakılması. Detaylar için [buradaki](https://docs.spring.io/spring-native/docs/current/reference/htmlsingle/#spring-aot-configuration) konfigürasyonlara göz atabilirsiniz. Bu kod parçasından kurtulmak için kodumuzda aşağıdaki değişiklikleri yapıyoruz.

<script src="https://gist.github.com/mehmetcemyucel/e173101affb6642f879dd9c7b7b0369a.js"></script>

<script src="https://gist.github.com/mehmetcemyucel/7fb60ed2f99cb6ff87a8483871056318.js"></script>

{% include feed-ici-yazi-3.html %}

Bu değişikliklerden pom.xml’de versiyonumuzu 0.0.2-SNAPSHOT olarak güncelledikten sonra mvn clean spring-boot:build-image komutuyla tekrar native imajımızı derletiyoruz. Image’ımız aşağıdaki gibi oluşuyor. Yeni imajımızı çalıştırıyoruz.

![](https://cdn-images-1.medium.com/max/800/1*KjK-IT8-J2JTlWdHVN9Tdg.png)

	C:\Users\PC\Desktop\mcy\spring-native-example>docker run -p 8081:8081 spring-native-example:0.0.2-SNAPSHOT  
	2021–03–29 05:21:53.059 INFO 1 — — [ main] o.s.nativex.NativeListener : This application is bootstrapped with code generated with Spring AOT

	. ____ _ __ _ _  
	 /\\ / ___’_ __ _ _(_)_ __ __ _ \ \ \ \  
	( ( )\___ | ‘_ | ‘_| | ‘_ \/ _` | \ \ \ \  
	 \\/ ___)| |_)| | | | | || (_| | ) ) ) )  
	 ‘ |____| .__|_| |_|_| |_\__, | / / / /  
	 =========|_|==============|___/=/_/_/_/  
	 :: Spring Boot :: (v2.4.4)

	2021–03–29 05:21:53.061 INFO 1 — — [ main] c.c.s.SpringNativeExampleApplication : Starting SpringNativeExampleApplication using Java 1.8.0_282 on 04f07a0ee2a8 with PID 1 (/workspace/com.cem.springnativeexample.SpringNativeExampleApplication started by cnb in /workspace)  
	2021–03–29 05:21:53.061 INFO 1 — — [ main] c.c.s.SpringNativeExampleApplication : No active profile set, falling back to default profiles: default  
	2021–03–29 05:21:53.084 INFO 1 — — [ main] .s.d.r.c.RepositoryConfigurationDelegate : Bootstrapping Spring Data JPA repositories in DEFAULT mode.  
	2021–03–29 05:21:53.085 INFO 1 — — [ main] .s.d.r.c.RepositoryConfigurationDelegate : Finished Spring Data repository scanning in 1 ms. Found 1 JPA repository interfaces.  
	2021–03–29 05:21:53.114 INFO 1 — — [ main] o.s.b.w.embedded.tomcat.TomcatWebServer : Tomcat initialized with port(s): 8081 (http)  
	Mar 29, 2021 5:21:53 AM org.apache.coyote.AbstractProtocol init  
	INFO: Initializing ProtocolHandler [“http-nio-8081”]  
	Mar 29, 2021 5:21:53 AM org.apache.catalina.core.StandardService startInternal  
	INFO: Starting service [Tomcat]  
	Mar 29, 2021 5:21:53 AM org.apache.catalina.core.StandardEngine startInternal  
	INFO: Starting Servlet engine: [Apache Tomcat/9.0.44]  
	2021–03–29 05:21:53.116 INFO 1 — — [ main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 55 ms  
	Mar 29, 2021 5:21:53 AM org.apache.catalina.core.ApplicationContext log  
	INFO: Initializing Spring embedded WebApplicationContext  
	2021–03–29 05:21:53.126 INFO 1 — — [ main] com.zaxxer.hikari.HikariDataSource : HikariPool-1 — Starting…  
	2021–03–29 05:21:53.128 INFO 1 — — [ main] com.zaxxer.hikari.HikariDataSource : HikariPool-1 — Start completed.  
	2021–03–29 05:21:53.128 INFO 1 — — [ main] o.hibernate.jpa.internal.util.LogHelper : HHH000204: Processing PersistenceUnitInfo [name: default]  
	2021–03–29 05:21:53.129 INFO 1 — — [ main] org.hibernate.Version : HHH000412: Hibernate ORM core version [WORKING]  
	2021–03–29 05:21:53.129 INFO 1 — — [ main] o.hibernate.annotations.common.Version : HCANN000001: Hibernate Commons Annotations {5.1.2.Final}  
	2021–03–29 05:21:53.130 INFO 1 — — [ main] org.hibernate.dialect.Dialect : HHH000400: Using dialect: org.hibernate.dialect.H2Dialect  
	2021–03–29 05:21:53.131 WARN 1 — — [ main] org.hibernate.dialect.H2Dialect : HHH000431: Unable to determine H2 database version, certain features may not work  
	2021–03–29 05:21:53.133 WARN 1 — — [ main] o.h.id.enhanced.OptimizerFactory : HHH000322: Unable to instantiate specified optimizer [none], falling back to noop  
	2021–03–29 05:21:53.136 INFO 1 — — [ main] o.h.e.t.j.p.i.JtaPlatformInitiator : HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]  
	2021–03–29 05:21:53.136 INFO 1 — — [ main] j.LocalContainerEntityManagerFactoryBean : Initialized JPA EntityManagerFactory for persistence unit ‘default’  
	2021–03–29 05:21:53.142 WARN 1 — — [ main] JpaBaseConfiguration$JpaWebConfiguration : spring.jpa.open-in-view is enabled by default. Therefore, database queries may be performed during view rendering. Explicitly configure spring.jpa.open-in-view to disable this warning  
	2021–03–29 05:21:53.302 INFO 1 — — [ main] o.s.s.web.DefaultSecurityFilterChain : Will secure any request with [org.springframework.security.web.context.request.async.WebAsyncManagerIntegrationFilter@14e20173, org.springframework.security.web.context.SecurityContextPersistenceFilter@64f76005, org.springframework.security.web.header.HeaderWriterFilter@75439655, org.springframework.security.web.authentication.logout.LogoutFilter@2dfc998f, org.springframework.security.web.authentication.[www.BasicAuthenticationFilter@7a38d18f](http://www.BasicAuthenticationFilter@7a38d18f), org.springframework.security.web.savedrequest.RequestCacheAwareFilter@5a8e5e4, org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestFilter@6ec28cd5, org.springframework.security.web.authentication.AnonymousAuthenticationFilter@57af117b, org.springframework.security.web.session.SessionManagementFilter@5af517ac, org.springframework.security.web.access.ExceptionTranslationFilter@370d878d, org.springframework.security.web.access.intercept.FilterSecurityInterceptor@662623f8]  
	2021–03–29 05:21:53.310 INFO 1 — — [ main] o.s.s.concurrent.ThreadPoolTaskExecutor : Initializing ExecutorService ‘applicationTaskExecutor’  
	Mar 29, 2021 5:21:53 AM org.apache.coyote.AbstractProtocol start  
	INFO: Starting ProtocolHandler [“http-nio-8081”]  
	2021–03–29 05:21:53.326 INFO 1 — — [ main] o.s.b.w.embedded.tomcat.TomcatWebServer : Tomcat started on port(s): 8081 (http) with context path ‘’  
	2021–03–29 05:21:53.326 INFO 1 — — [ main] **c.c.s.SpringNativeExampleApplication : Started SpringNativeExampleApplication in 0.275 seconds (JVM running for 0.277)**

## Metrikler ve Sonuç

Bu kez uygulamamız sıkıntısız şekilde ayağa kalktı. **10 denemenin sonucunda yaklaşık 3,5–4 sn’ler civarında** ayağa kalkan standart uygulamamız native olarak derlendiğinde **0.275sn’de** ayağa kalktı. Yine buradaki **10 denemenin ortalamasının 0.3 sn’ler civarında** ölçümledim. Özetle yaklaşık **10–12 kat** daha hızlı uygulama açılışı gözlemledik.

Yukarıda değindiğimiz bütün kodlara https://github.com/mehmetcemyucel/spring-native adresinden erişebilirsiniz.
