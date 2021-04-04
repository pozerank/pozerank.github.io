---
title:  "Spring Boot Property’lerini Jasypt ile Şifrelemek"
date:   2019-02-03 20:04:23
categories: [java, spring, spring boot, security, tools]
tags: [Spring Boot, jasypt, acegi, encoding, decoding, Encryption, Decryption, Şifreleme, nedir, example, Mehmet Cem Yücel, Mehmet, Cem, Yücel, Yucel, Nasıl Yapılır, application.properties, application.yml, spring]
image: https://cdn-images-1.medium.com/max/150/1*9oEKN6s0vnoxVTmjuFgymw.png 
---
Bir Spring Boot projemiz var. Projemize ait application.properties dosyasının içerisinde veritabanına bağlanırken kullandığımız kullanıcı adı/şifre gibi hassas bir veri var. Bu verinin açık olarak dosyada durması bir problem, güvenlik açığı teşkil ediyor. Bugünkü yazımız böyle hassas bilgilerin encrypted bir şekilde saklanabilmesi için [Jasypt](http://www.jasypt.org/) kütüphanesi ile Spring Boot properties’i birlikte nasıl kullanabileceğimiz hakkında olacak.


![](https://miro.medium.com/max/2400/1*9oEKN6s0vnoxVTmjuFgymw.png)

## 1. Jasypt Nedir

Jasypt, “Java Simplified Encrpytion” projesi aslında başlangıcı çok çok eski tarihlere dayanan bir proje. Henüz Acegi dünyası Spring Security altında birleşmeden öncesinde Jasypt’in Acegi ile uyumlu çalışan versiyonları mevcuttu. 2014ten bu yana temel fonksiyon setinde bir değişikliği olmamasına rağmen farklı popüler teknolojilerle entegre çalışabilmesi için geliştirilen farklı projeler de mevcut. Biz bugün [Jasypt-Spring-Boot](https://github.com/ulisesbocchio/jasypt-spring-boot) projesini kullanarak örneklerimizi gerçekleştireceğiz.

## 2. Spring Boot ile Örnek Kod

İlk olarak boş bir Spring Boot projesi yaratıyorum. İçerisine loglamada yardımcı olması için Lombok haricinde hiçbir ek bağımlılık eklemeyeceğim. Application.yml dosyasından aldığım bir değeri console’a basan basit bir kod yazıyorum.

<script src="https://gist.github.com/mehmetcemyucel/036e3fa123dd14a5444f9444cbb739c1.js"></script>

`application.yml` içeriği de aşağıdaki şekilde;

<script src="https://gist.github.com/mehmetcemyucel/01026cc500668573434f0d2ae41539ce.js"></script>

Bu şekilde kodumu çalıştırdığımda console’da aşağıdaki çıktıyı görüyorum.

	...  
	INFO 6532 — — [ main] com.mcy.SimpleController : welcome cem 
	... 

Bu durumda iken `mcy.person` property’sini dosyada açık olarak tutmamayı tercih edersem ne yapmalıyım? [http://www.jasypt.org/download.html](http://www.jasypt.org/download.html) adresinden en yeni versiyonu indirip sıkıştırılmış paketi extract ediyoruz. `../bin/encrypt.bat` çalıştırılabilir dosyası aracılığıyla encrypt etmek istediğimiz değeri kendi belirlediğimiz ve hiçbir yere yazmayacağımız bir key ile şifreleyeceğiz. Dosyayı çalıştırmaya çalışalım.

### 2.1. Jasypt ile Şifreleme

![](https://miro.medium.com/max/423/1*nWyb91sUqINvkWgXofspDA.png)

	λ C:\dvlp\tools\jasypt-1.9.2\bin\encrypt.batUSAGE: encrypt.bat [ARGUMENTS]* Arguments must apply to format:“arg1=value1 arg2=value2 arg3=value3 …”* Required arguments:input  
	 password* Optional arguments:verbose  
	 algorithm  
	 keyObtentionIterations  
	 saltGeneratorClassName  
	 providerName  
	 providerClassName  
	 stringOutputType

İki argüman geçilmesini istedi. Input’ta şifrelemek istediğimiz değerimizi, password’de de bu şifrelemenin yapılacağı anahtarı istiyor. Aşağıdaki şekilde tekrar çalıştırdığımızda bize bir output verecek.

	λ C:\dvlp\tools\jasypt-1.9.2\bin\encrypt.bat input=cem password=anyPrivateKey   
	   
	 — — ENVIRONMENT — — — — — — — — —   
	   
	Runtime: Oracle Corporation Java HotSpot(TM) 64-Bit Server VM 25.191-b12   
	   
	 — — ARGUMENTS — — — — — — — — — —   
	   
	input: cem   
	password: anyPrivateKey  
	   
	 — — OUTPUT — — — — — — — — — — —   
	   
	**9w7d1xtySqiqozS/MmHw5g==**

Bu output bizim kullanacağımız değer. `cem` içeriğine sahip değişkenimizi `anyPrivateKey` şifresiyle şifreleyerek `9w7d1xtySqiqozS/MmHw5g==` şifreli değerimizi oluşturmuş olduk. Artık application.yml’daki açık değerimizi bu değerle değiştirebiliriz. Ancak Spring Boot’un bunun encrypted bir değer olduğunu anlayabilmesi için başına ve sonuna eklememiz gereken ufak ayrıntılar var. Application.yml’ımızın son durumu:

<script src="https://gist.github.com/mehmetcemyucel/77244e9148fc75ff0c7cc03aa6ae27ca.js"></script>

### 2.2. Şifrelenmiş Değerin Spring'e Paylaşımı
Kodumuzu bu haliyle tekrar çalıştırdığımızda karşımıza bir hata geliyor.

	… 16 common frames omitted  
	Caused by: java.lang.IllegalStateException: **Required Encryption configuration property missing: jasypt.encryptor.password**….

Spring’in demeye çalıştığı şu; sen properties dosyasında encrpyted bir değer kullanmışsın ve ben bunu decrypt ederek kullanmanı sağlamaya çalışıyorum. Ancak anahtarlama yaptığın key’i bana da vermezsen ben bu şifreyi açamam!

Biliyorsunuz ki encoding/decoding’in bir hash algoritması. Bcrpyt gibi Spring Boot kütüphanelerinin aksine encryption yapacaksanız güvenilir simetrik/asimetrik algoritmalardan birisini seçmeniz gereklidir. Ve bu şifreleme algoritmalarında şifrelenmiş değerin geri döndürülebilmesi için şifrelerken kullanılan anahtarın veya o anahtarla eşleşmiş başka bir anahtarın(public/private keys) decrpytion işlemine dahil olması gerekir. İşte bu sebeple uygulamamıza bir VM argümanı geçmemiz gerekiyor. Uygulamamızın Run Configurations>>Arguments sekmesi altında VM argümanları kısmına aşağıdaki argümanımızı geçiyoruz.

	-Djasypt.encryptor.password=anyPrivateKey

Bu şekilde kodumuzu tekrar çalıştırdığımızda konsol çıktımız aşağıdaki gibi oluyor.

	...  
	INFO 6532 — — [ main] com.mcy.SimpleController : welcome cem  
	...

Dilerseniz kullanılan şifreleme algoritmasını, argüman alma şeklini aşağıdaki gibi custom encryptor tanımlayarak tamamen kontrolünüze de alabilirsiniz.

<script src="https://gist.github.com/mehmetcemyucel/ea932a25248b6a8cc72e16034c02d939.js"></script>

Bu noktada belirtmemde fayda olan bir konu var. Bu property’ler sadece Spring Boot startup sonrasındaki argümanlarda kullanılmak zorunda değil. Örneğin startup esnasında AutoConfigurable bean’leriniz ayağa kalkacak ve burada gerekli parametreleriniz var ise bunlar da decrpyted olarak bean yaratılma anında kodunuza dahil oluyorlar. Yani daha somut örneğiyle Spring Data JPA kullanıyorsunuz ve DB connection bilgileri size Configuration sınıfınız içerisinde decrpyted olarak lazım ize EncryptablePropertySourceConverter bu configuration sınıfınız çalışmadan gerekli argümanların decryption işlemlerini tamamlayıp size değerlerinizin kullanılabilir hallerini sunuyor.

## 3. Sonuç ve Kaynaklar

Eğer daha detaylı kullanım örneklerine,customization’lara ihtiyacınız olursa projeyi [Github](https://github.com/ulisesbocchio/jasypt-spring-boot) adresinde inceleyebilirsiniz. Şu an itibariyle Spring Boot’un `1.4.x`, `1.5.x`, `2.0.x` versiyonları ile uyumlu çalışabiliyor.

Projenin kodlarına [buradan](https://github.com/mehmetcemyucel/springboot-jasypt) ulaşabilirsiniz.


***En yalın haliyle***

[**Mehmet Cem Yücel**](https://www.mehmetcemyucel.com)

---

**_Bu yazılar ilgilinizi çekebilir:_**

 - [Spring Boot Devtools ile Docker Üzerindeki Kodu Debug Etme ve Değiştirme](https://www.mehmetcemyucel.com/2019/spring-boot-devtools-ile-docker-uzerindeki-kodu-debug-etme-ve-degistirme/)
 - [Spring Boot ile SLF4J ve Log4J Loglama Altyapısı](https://www.mehmetcemyucel.com/2019/spring-boot-ile-loglama-altyapisi/)
 - [Twelve Factor Nedir Türkçe ve Java Örnekleri](https://www.mehmetcemyucel.com/2019/twelve-factor-nedir-turkce-ornek/)

**_Blockchain teknolojisi ile ilgileniyor iseniz bunlar da hoşunuza gidebilir:_**

 - [BlockchainTurk.net yazıları](https://www.mehmetcemyucel.com/categories/#blockchain)
---