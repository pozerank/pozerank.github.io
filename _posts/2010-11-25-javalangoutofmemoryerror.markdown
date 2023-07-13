---
title:  "java.lang.OutOfMemoryError"
date:   2010-11-25 20:04:23
categories: [java, jvm]
tags: [java, outofmemoryerror, hata, exception, error]
---

Programlar bilgisayarlarımıza ilk kurulduklarında hangi argümanlara göre çalışacaklarına kendileri karar verirler. **Default** olarak gelen bu değerler her zaman uygulamamızın doğasına uygun olmayabilir. Örneğin enterprise uygulamalar üzerinde çalışıyorsak bu bu başlangıç değerleri projemizin isteğini karşılamıyor olabilir. Daha **fazla bellek alanı** tahsis etmemiz, işlemciyi isteklerimize uygun olarak kullanmak isteyebiliriz. Hatta belirlediğimiz uygulamaların bu kaynakları ne şekillerde paylaşacaklarını ayarlamamız da gerekebilir.  
  
Böyle durumlarda programların default olan değerlerini ihtiyacımıza göre değiştirmemiz gerekecektir. Bu gerek veritabanı, gerek uygulama çatısı olsun platformlar üzerindeki yönetimizi kolaylaştıran unsurlardır.  
  
Uygulamanızı uygulama sunucusunda deploy ederken, veya uygulamamız runtime'da iken bellek yetersizliği ile ilgili hatalar almış olabilirsiniz. Böyle durumlarda sunucuda kullanıma açılan bellek alanının yetersizliğinden dolayı uygulamamız kendisine gerekli olan alanı yaratamaz. Heap alanındaki aşırı doluluk durumu **[Garbage Collection](http://en.wikipedia.org/wiki/Garbage_collection_(computer_science))** ın temizliği sonrasında hafifletilebilmektedir. Ancak PermGen alanının statik olması uygulamaların ihtiyacı olan bellek alanının tahsis edilemediği durumlarda " **_java.lang.OutOfMemoryError_** " hatasına sebep olmaktadır. **[Java Sanal Makinası-JVM](http://en.wikipedia.org/wiki/Java_Virtual_Machine)** e dair bu bilgileri anlık kullanım verilerini elde etmek için JDK nızın içerisinde bulunan Java Virtual VM uygulamasını kullanabilirsiniz. C:/Program Files/Java/[ilgili jdk klasörü]/bin/jvisualvm altıdna uygulamaya erişebilirsiniz. Bilgisayarımdaki heap ve permgen kullanımınlarına dair görüntü aşağıdaki gibi.  
  
  

[![](http://1.bp.blogspot.com/_-PvBeE2cwcg/TO5Bx_69ikI/AAAAAAAAAWg/C13IQFwDdLU/s1600/Capture.PNG)](http://1.bp.blogspot.com/_-PvBeE2cwcg/TO5Bx_69ikI/AAAAAAAAAWg/C13IQFwDdLU/s1600/Capture.PNG)

_Heap Alanı_

[![](http://4.bp.blogspot.com/_-PvBeE2cwcg/TO5B_VS9jnI/AAAAAAAAAWk/E7SW0BuEaIA/s1600/2.PNG)](http://4.bp.blogspot.com/_-PvBeE2cwcg/TO5B_VS9jnI/AAAAAAAAAWk/E7SW0BuEaIA/s1600/2.PNG)

_PermGen Alanı_

  

Görüldüğü gibi hep alanı Garbage Collection çalıştığında kullanımı düşmekte ama PermGen alanı ise sürekli aynı kalmaktadır. Bu sebeple uygulamamıza PermGen alanını daha fazla vermek isteyebiliriz. Böyle zamanlarda uygulamamızın çalıştırılma konfigürasyonunu değiştirmemiz gerekir. Eclipse için konuşursak, projemizi (Run veya Debug) ayağa kaldırdığımız seçimimizin configuration ayarlarına girmemiz gerekiyor. Bu ayarlar da Eclipse araç çubuğunun Run sekmesi altında bulunmakta.

  

Run >> Debug Configurations a girdiğimizi varsayalım. Uygulamamızı varolan menüde seçtikten(veya yarattıktan) sonra uygulamanın Arguments sekmesi altındki VM arguments kısmına

  

 -Xms512m -Xmx1024m -XX:CompileThreshold=8000 -XX:PermSize=96m -XX:MaxPermSize=256m

parametreleri yapıştırılmalıdır. Buradaki "-Xms512m -Xmx1024m" argümanları uygulama sunucusu için ayrılan Heap miktarlarını ifade ederken "-XX:PermSize=96m -XX:MaxPermSize=256m" argümanları da PermGen alanının düzenlenmesi için kullanılmaktadır. Kendi RAM miktarınıza göre ayarlamanızı yapabilirsiniz. Ben 2 GB lık RAM in bulunduğu bilgisayarımda heap için 512m ve 1024m kullanırken PermGen için 256m ve 512m kullanıyorum.  
  