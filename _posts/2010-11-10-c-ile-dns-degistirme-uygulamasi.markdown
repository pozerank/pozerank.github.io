---
title:  "C# ile DNS Degistirme Uygulaması"
date:   2010-11-10 20:04:23
categories: [microsoft, c#]
tags: [c#, c, dns, değiştirme, regedit]
---

Bildiğiniz gibi [Youtube](http://www.youtube.com/) video paylaşım sitesine erişim ülkemizde engellendikten sonra bu kervana [Google](http://www.google.com.tr/) servisleri de eklenmişti. Bu durum elbette site ve servislere erişebilmeyeceğimiz anlamına gelmiyor. Erişebilmek için yöntemler de zaten birçoğumuz tarafından biliniyor. Bunlardan birisi tünel kavramı. Bazı siteler bizim ilgili siteyle kendi üzerinden bağlanmamız konusunda yardımcı oluyor. Bu sitelerden en popüler olanlarından birisi [KTunnel](http://www.ktunnel.com/) mesela. Bir başka yol bilgisayarımızın [sunucu dosyasını](http://tr.wikipedia.org/wiki/Sunucu_dosyas%C4%B1) düzenlemekten geçiyor.  
  
Bizim bugün değineceğimiz yöntem ise DNS adresimizin değiştirilmesiyle alakalı. DNS'in ne olduğu ve bu sistemin nasıl çalıştığı hakkında bahsetmeyeceğim, isteyenler olursa [buradan](http://tr.wikipedia.org/wiki/DNS) detaylı bilgi sahibi olabilir. Biz bilgisayarımızda bu adreslerin programatik olarak nasıl değiştirilebileceği üzerisinde duracağız. Kullandığımız dil C# olacak ve bir WPF uygulaması yaratacağız.  
  
Yavaş yavaş uygulamamıza giriş yapalım. Öncelikle bir bilgisayarda programatik olarak DNS değiştirmek için neler yapmak gereklidir? Internette epeyce araştırdıktan sonra bunun için iki farklı yöntemin olduğunu öğrendim. [WMI (Windows Management Instrumentation)](http://msdn.microsoft.com/en-us/library/aa394582(VS.85).aspx) kullanarak yapılabildiği gibi bilgisayarımızda Registry ayarlarında oynamalar yaparak da bu işlemi gerçekleştirebiliyoruz. Biz 2. yöntemi tercih edeceğiz. Artık işin zevkli kısıma, kodlamaya, yavaştan giriş yapabiliriz.  
  
Programımızın arayüzü bu şekilde. Ağ bağdaştırıcısı seçildikten sonra var olan DNS IP'leri içerisinden istediğimizi seçerek DNS adresimizi değiştirebiliyoruz. İstersek bu adres listesine kendi istediğimiz sunucuların IP'lerini de aşağıdaki kısımdan ekleyebiliyoruz. Böylece kullanımı esnek bir yapıya taşımış oluyoruz.  
  

[![](http://3.bp.blogspot.com/_-PvBeE2cwcg/TLLmHYE35XI/AAAAAAAAAQg/blzCdyM0QqU/s1600/Capture.PNG)](http://3.bp.blogspot.com/_-PvBeE2cwcg/TLLmHYE35XI/AAAAAAAAAQg/blzCdyM0QqU/s1600/Capture.PNG)

﻿Resim 1: Program Arayüzü

  

  

Yapmamız gereken ilk şey bilgisayarımızdaki bağdaştırıcıların listesini kayıt defterinden almamız olacaktır. Çünkü bu bağdaştırıcıların her ağ kartının marka ve modeline özgü bir ID numarası bulunuyor. Ve bizim Registry'de bu ilgili anahtarı bulabilmemiz için önce bütün ağ bağdaştırıcılarının idlerini almamız gerekiyor. Bu idler Regedit altında

  

[![](http://1.bp.blogspot.com/_-PvBeE2cwcg/TLLom5M9CsI/AAAAAAAAAQk/AtEM7BWFZVM/s1600/2.PNG)](http://1.bp.blogspot.com/_-PvBeE2cwcg/TLLom5M9CsI/AAAAAAAAAQk/AtEM7BWFZVM/s1600/2.PNG)

  

anahtar düğümünün altında bulunuyor. Kendi makinemdeki görüntü şu şekilde:

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

[![](http://1.bp.blogspot.com/_-PvBeE2cwcg/TLLpOnMD_cI/AAAAAAAAAQo/XdNhYZlTmG0/s1600/3.PNG)](http://1.bp.blogspot.com/_-PvBeE2cwcg/TLLpOnMD_cI/AAAAAAAAAQo/XdNhYZlTmG0/s1600/3.PNG)

Resim 2: Regedit Altındaki Ağ Bağdaştırıcıları Listesi

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

﻿ Buradaki gördüğünüz değerler bahsi geçen id'lerimiz oluyorlar. Bu id'lerin hangi bağdaştırıcıya ait olduğu ise bu düğümlerin de altında bulunan "Connection" düğümünün altındaki "Name" anahtarında yazıyor.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

[![](http://1.bp.blogspot.com/_-PvBeE2cwcg/TLLqzQ0-OyI/AAAAAAAAAQs/TBq9VtL_W6k/s1600/4.PNG)](http://1.bp.blogspot.com/_-PvBeE2cwcg/TLLqzQ0-OyI/AAAAAAAAAQs/TBq9VtL_W6k/s1600/4.PNG)

Resim 3: ID'ler ve İsimleri

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

Bizim yapmamız gereken bu id'leri ve bu id'lere eşleşen bağdaştırıcı isimlerini almamız. Bu değerlerimizi tutabilmek için içerisinde id ve name değişkenleri bulunan bir adapter sınıfı yaratıyoruz.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

[![](http://3.bp.blogspot.com/_-PvBeE2cwcg/TLLrkOl-GSI/AAAAAAAAAQw/dz_yaLbTJQY/s1600/5.PNG)](http://3.bp.blogspot.com/_-PvBeE2cwcg/TLLrkOl-GSI/AAAAAAAAAQw/dz_yaLbTJQY/s1600/5.PNG)

Resim 4: Adapter.cs

﻿ ----------------------------------------------------------------------------------------------------------------------------------------------------------------  
  
Aynı şekilde programda kayıtlı olan DNS IP'lerini de bir yerde tutmamız lazım. Bu IP'ler programımızla aynı dizinde bulunan bir xml dosyasında saklanıyor. Bu xml dosyasında her DNS için bir tercih edilen, bir adet de alternatif IP adresleri bulunuyor. Bu DNS bilgilerinin saklanabilmesi için bir adet de Server sınıfı yaratıyoruz.  
  
----------------------------------------------------------------------------------------------------------------------------------------------------------------  

[![](http://1.bp.blogspot.com/_-PvBeE2cwcg/TLLv19WTrdI/AAAAAAAAAQ4/X1iIhN1aS1o/s1600/7.PNG)](http://1.bp.blogspot.com/_-PvBeE2cwcg/TLLv19WTrdI/AAAAAAAAAQ4/X1iIhN1aS1o/s1600/7.PNG)

Resim 5: Server.cs

----------------------------------------------------------------------------------------------------------------------------------------------------------------

Ekranımız ilk açıldığında yapılması gereken birkaç tane görev var. Birincisi bu az önce bahsettiğimiz Adapter listesini Regedit'ten okuyup ComboBox'ımıza doldurmak. Bir diğeri, programa dahil edilmiş DNS IP'lerinin listesini ilgili XML dosyasından okuyup onu da ComboBox'ımıza doldurmak. Bu işlemler ise şu şekilde çağırılacak,

----------------------------------------------------------------------------------------------------------------------------------------------------------------

[![](http://1.bp.blogspot.com/_-PvBeE2cwcg/TLLt_bPx0fI/AAAAAAAAAQ0/eOBp80bEfIE/s1600/6.PNG)](http://1.bp.blogspot.com/_-PvBeE2cwcg/TLLt_bPx0fI/AAAAAAAAAQ0/eOBp80bEfIE/s1600/6.PNG)

Resim 6: Programın Çalıştırılması

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

﻿ Görüldüğü üzere Service isimli bir sınıf yaratmışız. Bu sınıf bize gerekli servisleri sunan bir sınıf ve bizim için gereken bütün servisleri static olarak bu sınıf altında toplayacağız. Gerektiğinde de servislerimizi bu şekilde çağıracağız.

  

Yukarıda görülen ADAPTER_ADDRESSES ve DNS_SERVER_ADDRESS değişkenleri regeditte bizim için gerekli bazı anahtarların isimlerini işaret ediyorlar. XML_NAME değişkeni kayıtlı DNS IP'lerinin bulunduğu xml dosyamızın ismi. serverList ve adapterList listeleri ise okunan DNS IP'lerinin ve Adapter değişkenlerinin saklandığı listelerimiz olacaklar.

  

Service.getAdapterList(ADAPTER_ADDRESSES); methodunu inceleyelim. Aşağıdaki kodun içerisindeki kayıt defteri işlemlerini anlayabilmeniz için  [buradaki](http://www.csharpnedir.com/articles/read/?filter=&author=&cat=cs&id=24&title=C)  yazıya göz atmanızı tavsiye ederim.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

[![](http://1.bp.blogspot.com/_-PvBeE2cwcg/TLLwq3MD45I/AAAAAAAAAQ8/gY0A8YiJcDc/s1600/8.PNG)](http://1.bp.blogspot.com/_-PvBeE2cwcg/TLLwq3MD45I/AAAAAAAAAQ8/gY0A8YiJcDc/s1600/8.PNG)

  

[![](http://1.bp.blogspot.com/_-PvBeE2cwcg/TLLw-paKE5I/AAAAAAAAARA/XWd8v7iTmPg/s1600/9.PNG)](http://1.bp.blogspot.com/_-PvBeE2cwcg/TLLw-paKE5I/AAAAAAAAARA/XWd8v7iTmPg/s1600/9.PNG)

Resim 7: Ağ Bağdaştırıcı Listesinin Alınması

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

Öncelikle regeditteki ilgili anahtar için bir RegistryKey nesnemizi türetiyoruz. Bu türetme için bir başka static metodumuz olan getRegister metodumuzu kullanıyoruz. Yarattığımız bu anahtarın altındaki idleri alıp adapterList listemizin içerisine ekliyoruz. Böylece bütün idlerimizi bir liste içerisinde toplamış olduk.

Ardından bu anahtarların altındaki "Connection" adlı düğümünün "Name" anahtarından bağdaştırıcının isimini öğreniyoruz. Bu iki bilgiyi öğrendikten sonra adapter nesnelerimizi yaratıp temp isimli listemize ekliyor ve method sonucu olarak geri döndürüyoruz. Artık elimizde her bağdaştırıcının adlarının ve idlerinin bulunduğu bir bağdaştırıcı listesi var. Böylece ekranımız açılırken yapılan ilk işlemimiz tamamlandı.

  

Ekranımız açılırken yapılan ikinci işlem ise xml dosyasından DNS IP bilgilerinin okunması. Bu bilgileri okumadan önce XML dosyamızın yapısına bir göz atalım.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

[![](http://2.bp.blogspot.com/_-PvBeE2cwcg/TLL0Hynk3OI/AAAAAAAAARE/Yh8AO50ZJRc/s1600/10.PNG)](http://2.bp.blogspot.com/_-PvBeE2cwcg/TLL0Hynk3OI/AAAAAAAAARE/Yh8AO50ZJRc/s1600/10.PNG)

Resim 8: XML Şeması

--------------------﻿--------------------------------------------------------------------------------------------------------------------------------------------

  

XML şeması dnsServers altındaki Server düğümlerinden oluşuyor. Her sunucunun bir tercih edilen bir adet de alternatif ip adresi bulunuyor. Bu şemayı okumak için Service sınıfımızın altında xmlReader(xmlName) isimli bir metodumuz bulunuyor. Aldığı parametre ilgili xml dosyasının ismini ifade etmekte. Kodlarımızı incelemeden önce aşağıdaki kodları anlayabilmeniz için XML işlemleri ile ilgili  [buradaki siteye](http://www.c-sharpcorner.com/uploadfile/mahesh/readwritexmltutmellli2111282005041517am/readwritexmltutmellli21.aspx)  göz atmanızı tavsiye ederim.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

[![](http://2.bp.blogspot.com/_-PvBeE2cwcg/TLL00AhNMGI/AAAAAAAAARI/MEjP_33uJjM/s1600/11.PNG)](http://2.bp.blogspot.com/_-PvBeE2cwcg/TLL00AhNMGI/AAAAAAAAARI/MEjP_33uJjM/s1600/11.PNG)

Resim 9: DNS Bilgilerinin Alınması

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

Dosyamızı açıp içerisindeki bütün düğümleri bir kez geziyoruz. Karşımıza çıkan preferred ve alternate düğümlerini birer listede topluyor ve en son bu düğümlerden server nesnelerimizi yaratıp bir liste halinde geri döndürüyoruz. Böylece programımız başlatıldığında yapılan 2. işlemimiz de bitmiş oluyor.

  

Programımız açıldığında yapılan 3. ve son işlem bu elde edilen Adapter ve Server sınıflarından türeyen nesnelerin ekrana basılmasından ibaret. Bunun için fillInAdapters ve fillInServers metodlarını kullanacağız. Metodlar listelerin içindeki nesnelerin değişkenlerini comboBox'lara dolduracaklar.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

[![](http://4.bp.blogspot.com/_-PvBeE2cwcg/TLL2wygXqiI/AAAAAAAAARM/sFEK5pa2mxA/s1600/12.PNG)](http://4.bp.blogspot.com/_-PvBeE2cwcg/TLL2wygXqiI/AAAAAAAAARM/sFEK5pa2mxA/s1600/12.PNG)

Resim 10: ComboBox'ların Doldurulması

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

Artık buton eventlarımızı yazmanın vakti. Elimizde açıldığında regeditten ilgili kayıtları okuyup bilgisayarımızdaki ağ bağdaştırıcılarının isimlerini ve programda daha önceden kayıtlanmış dns adreslerinin listesini xml dosyasından okuyup ekrana basan bir kodumuz var. Şimdi DNS ayarlarımı değiştir butonuna basıldığında neler olduğuna göz atalım.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

[![](http://3.bp.blogspot.com/_-PvBeE2cwcg/TLL6IAi9s2I/AAAAAAAAARQ/0X7Q4qyUJa8/s1600/13.PNG)](http://3.bp.blogspot.com/_-PvBeE2cwcg/TLL6IAi9s2I/AAAAAAAAARQ/0X7Q4qyUJa8/s1600/13.PNG)

Resim 11: DNS Değiştirme Event'ı

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

ComboBox'ların seçili olup olmadığı kontrol edildikten sonra yine Service sınıfımızın changeDnsServer metodunu çağırıyoruz. Bu metod tercih edilen ip adresini, alternatif ip adresini, dns sunucu ipsini ve ilgili bağdaştırıcının idsini alıp değişiklik işlemini gerçekleştiriyor. Acaba bunu nasıl yapıyoruz, inceleyelim.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

[![](http://3.bp.blogspot.com/_-PvBeE2cwcg/TLMDvMv160I/AAAAAAAAARU/EKqZ7o5d8Cw/s1600/14.PNG)](http://3.bp.blogspot.com/_-PvBeE2cwcg/TLMDvMv160I/AAAAAAAAARU/EKqZ7o5d8Cw/s1600/14.PNG)

Resim 12: DNS Değişikliğinin Yapılması ve FlushDns

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

Burada yeni bir registry key instance ı alıp bu instance ımızın değerini değiştiriyoruz. Windows işletim sistemlerinde DNS adreslerinin regeditte saklandığını söylemiştik. Bu saklandığı anahtar

  

[![](http://2.bp.blogspot.com/_-PvBeE2cwcg/TLMEsq27E4I/AAAAAAAAARY/tPaP3ZVg1hQ/s1600/15.PNG)](http://2.bp.blogspot.com/_-PvBeE2cwcg/TLMEsq27E4I/AAAAAAAAARY/tPaP3ZVg1hQ/s1600/15.PNG)

altında ilgili ağ bağdaştırıcısının id'si ile devam etmekte. Sonuna \"adapterId" verildiğinde bu düğümün altındaki NameServer anahtarının değeri değiştirildiğinde DNS adresimiz değişmiş olacak. Bu dediklerimizi changeDnsServer adlı metodumuz gerçekleştiriyor. Metodumuzun sonunda flushDns metodunu çağırıyoruz.  

Burada command satırına bir process gönderiliyor. Ipconfig yordamını -flushdns argümanıyla çağırarak regeditte yaptığımız değşikliklerin uygulanmasını sağlıyor oluyoruz. Böylece yaptığımız değişiklikler uygulanmış oluyor.

  

Aynı şekilde DNS ayarının sıfırlanması da aynı anahtarın değerinin null olarak kaydedilmesi ile gerçekleşiyor. İlgili çağırım ve kodlar aşağıda.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

[![](http://4.bp.blogspot.com/_-PvBeE2cwcg/TLMMhCSFb7I/AAAAAAAAARc/jANQ6gQvJtc/s1600/16.PNG)](http://4.bp.blogspot.com/_-PvBeE2cwcg/TLMMhCSFb7I/AAAAAAAAARc/jANQ6gQvJtc/s1600/16.PNG)

  

[![](http://2.bp.blogspot.com/_-PvBeE2cwcg/TLMMzd5oiHI/AAAAAAAAARg/l3f-iiTCtzs/s1600/17.PNG)](http://2.bp.blogspot.com/_-PvBeE2cwcg/TLMMzd5oiHI/AAAAAAAAARg/l3f-iiTCtzs/s1600/17.PNG)

Resim 13: DNS Ayarlarını Sıfırlama

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

Bu adımlardan sonra son bir adım yeni bir DNS adresinin kaydedilmesi adımı. Bunun için var olan DNS adres listesine yeni adresi ekledikten sonra aşağıdaki xml yazma metodunu çağırmamız gerekiyor.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

[![](http://4.bp.blogspot.com/_-PvBeE2cwcg/TLMOGZHgDRI/AAAAAAAAARk/-dCKU3IRYdk/s1600/18.PNG)](http://4.bp.blogspot.com/_-PvBeE2cwcg/TLMOGZHgDRI/AAAAAAAAARk/-dCKU3IRYdk/s1600/18.PNG)

Resim 14: DNS Adresi Ekleme

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

Bütün bu işlemlerden sonra programımız bitti :) Şu anda regeditten ağ bağdaştırıcılarının listesini çekip ekrana basabilen, DNS adreslerini saklayabilen, istediğimiz bağdaştırıcının DNS adresini değiştirebildiğimiz, eski ayarlarına tekrar dönebildiğimiz bir programımız var. Proje Visual Studio 2010 ile yapıldı. Framework olarak .NET 4.0 Client Profile çalıştırabilmek için yeterli olacaktır. Projeyi kısa bir boşluğumda gerçekleştirdim, daha da geliştirilebilir bir durumda. Projenin source kodunu da yakın zaman içerisinde paylaşıyor olacağım.

***En yalın haliyle***

[**Mehmet Cem Yücel**](https://www.mehmetcemyucel.com)

---

**_Bu yazılar ilgilinizi çekebilir:_**

 - [Bir Yazılımcının Bilmesi Gereken 15 Madde](https://www.mehmetcemyucel.com/2019/bir-yazilimcinin-bilmesi-gereken-15-madde/)
 - [Spring Boot Devtools ile Docker Üzerindeki Kodu Debug Etme ve Değiştirme](https://www.mehmetcemyucel.com/2019/spring-boot-devtools-ile-docker-uzerindeki-kodu-debug-etme-ve-degistirme/)
 - [Spring Boot Property’lerini Jasypt ile Şifrelemek](https://www.mehmetcemyucel.com/2019/spring-boot-propertylerini-jasypt-ile-sifrelemek/)

**_Blockchain teknolojisi ile ilgileniyor iseniz bunlar da hoşunuza gidebilir:_**

 - [BlockchainTurk.net yazıları](https://www.mehmetcemyucel.com/categories/#blockchain)

---