---
title: "C# ile DNS Degistirme Uygulaması"
date: 2010-11-10 20:04:23
categories: [microsoft, c-sharp]
tags: [c-sharp, dns, windows, registry, mehmet-cem-yucel]
---

Bildiğiniz gibi [Youtube](http://www.youtube.com/) video paylaşım sitesine erişim ülkemizde engellendikten sonra bu kervana [Google](http://www.google.com.tr/) servisleri de eklenmişti. Bu durum elbette site ve servislere erişebilmeyeceğimiz anlamına gelmiyor. Erişebilmek için yöntemler de zaten birçoğumuz tarafından biliniyor. Bunlardan birisi tünel kavramı. Bazı siteler bizim ilgili siteyle kendi üzerinden bağlanmamız konusunda yardımcı oluyor. Bu sitelerden en popüler olanlarından birisi [KTunnel](http://www.ktunnel.com/) mesela. Bir başka yol bilgisayarımızın [sunucu dosyasını](http://tr.wikipedia.org/wiki/Sunucu_dosyas%C4%B1) düzenlemekten geçiyor.  
  
Bizim bugün değineceğimiz yöntem ise DNS adresimizin değiştirilmesiyle alakalı. DNS'in ne olduğu ve bu sistemin nasıl çalıştığı hakkında bahsetmeyeceğim, isteyenler olursa [buradan](http://tr.wikipedia.org/wiki/DNS) detaylı bilgi sahibi olabilir. Biz bilgisayarımızda bu adreslerin programatik olarak nasıl değiştirilebileceği üzerisinde duracağız. Kullandığımız dil C# olacak ve bir WPF uygulaması yaratacağız.  
  
Yavaş yavaş uygulamamıza giriş yapalım. Öncelikle bir bilgisayarda programatik olarak DNS değiştirmek için neler yapmak gereklidir? Internette epeyce araştırdıktan sonra bunun için iki farklı yöntemin olduğunu öğrendim. [WMI (Windows Management Instrumentation)](http://msdn.microsoft.com/en-us/library/aa394582(VS.85).aspx) kullanarak yapılabildiği gibi bilgisayarımızda Registry ayarlarında oynamalar yaparak da bu işlemi gerçekleştirebiliyoruz. Biz 2. yöntemi tercih edeceğiz. Artık işin zevkli kısıma, kodlamaya, yavaştan giriş yapabiliriz.  
  
Programımızın arayüzü bu şekilde. Ağ bağdaştırıcısı seçildikten sonra var olan DNS IP'leri içerisinden istediğimizi seçerek DNS adresimizi değiştirebiliyoruz. İstersek bu adres listesine kendi istediğimiz sunucuların IP'lerini de aşağıdaki kısımdan ekleyebiliyoruz. Böylece kullanımı esnek bir yapıya taşımış oluyoruz.  
  

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/Capture.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/Capture.PNG)

﻿Resim 1: Program Arayüzü

  

  

Yapmamız gereken ilk şey bilgisayarımızdaki bağdaştırıcıların listesini kayıt defterinden almamız olacaktır. Çünkü bu bağdaştırıcıların her ağ kartının marka ve modeline özgü bir ID numarası bulunuyor. Ve bizim Registry'de bu ilgili anahtarı bulabilmemiz için önce bütün ağ bağdaştırıcılarının idlerini almamız gerekiyor. Bu idler Regedit altında

  

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/2.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/2.PNG)

  

anahtar düğümünün altında bulunuyor. Kendi makinemdeki görüntü şu şekilde:

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/3.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/3.PNG)

Resim 2: Regedit Altındaki Ağ Bağdaştırıcıları Listesi

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

﻿ Buradaki gördüğünüz değerler bahsi geçen id'lerimiz oluyorlar. Bu id'lerin hangi bağdaştırıcıya ait olduğu ise bu düğümlerin de altında bulunan "Connection" düğümünün altındaki "Name" anahtarında yazıyor.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/4.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/4.PNG)

Resim 3: ID'ler ve İsimleri

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

Bizim yapmamız gereken bu id'leri ve bu id'lere eşleşen bağdaştırıcı isimlerini almamız. Bu değerlerimizi tutabilmek için içerisinde id ve name değişkenleri bulunan bir adapter sınıfı yaratıyoruz.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/5.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/5.PNG)

Resim 4: Adapter.cs

﻿ ----------------------------------------------------------------------------------------------------------------------------------------------------------------  
  
Aynı şekilde programda kayıtlı olan DNS IP'lerini de bir yerde tutmamız lazım. Bu IP'ler programımızla aynı dizinde bulunan bir xml dosyasında saklanıyor. Bu xml dosyasında her DNS için bir tercih edilen, bir adet de alternatif IP adresleri bulunuyor. Bu DNS bilgilerinin saklanabilmesi için bir adet de Server sınıfı yaratıyoruz.  
  
----------------------------------------------------------------------------------------------------------------------------------------------------------------  

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/7.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/7.PNG)

Resim 5: Server.cs

----------------------------------------------------------------------------------------------------------------------------------------------------------------

Ekranımız ilk açıldığında yapılması gereken birkaç tane görev var. Birincisi bu az önce bahsettiğimiz Adapter listesini Regedit'ten okuyup ComboBox'ımıza doldurmak. Bir diğeri, programa dahil edilmiş DNS IP'lerinin listesini ilgili XML dosyasından okuyup onu da ComboBox'ımıza doldurmak. Bu işlemler ise şu şekilde çağırılacak,

----------------------------------------------------------------------------------------------------------------------------------------------------------------

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/6.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/6.PNG)

Resim 6: Programın Çalıştırılması

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

﻿ Görüldüğü üzere Service isimli bir sınıf yaratmışız. Bu sınıf bize gerekli servisleri sunan bir sınıf ve bizim için gereken bütün servisleri static olarak bu sınıf altında toplayacağız. Gerektiğinde de servislerimizi bu şekilde çağıracağız.

  

Yukarıda görülen ADAPTER_ADDRESSES ve DNS_SERVER_ADDRESS değişkenleri regeditte bizim için gerekli bazı anahtarların isimlerini işaret ediyorlar. XML_NAME değişkeni kayıtlı DNS IP'lerinin bulunduğu xml dosyamızın ismi. serverList ve adapterList listeleri ise okunan DNS IP'lerinin ve Adapter değişkenlerinin saklandığı listelerimiz olacaklar.

  

Service.getAdapterList(ADAPTER_ADDRESSES); methodunu inceleyelim. Aşağıdaki kodun içerisindeki kayıt defteri işlemlerini anlayabilmeniz için  [buradaki](http://www.csharpnedir.com/articles/read/?filter=&author=&cat=cs&id=24&title=C)  yazıya göz atmanızı tavsiye ederim.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/8.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/8.PNG)

  

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/9.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/9.PNG)

Resim 7: Ağ Bağdaştırıcı Listesinin Alınması

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

Öncelikle regeditteki ilgili anahtar için bir RegistryKey nesnemizi türetiyoruz. Bu türetme için bir başka static metodumuz olan getRegister metodumuzu kullanıyoruz. Yarattığımız bu anahtarın altındaki idleri alıp adapterList listemizin içerisine ekliyoruz. Böylece bütün idlerimizi bir liste içerisinde toplamış olduk.

Ardından bu anahtarların altındaki "Connection" adlı düğümünün "Name" anahtarından bağdaştırıcının isimini öğreniyoruz. Bu iki bilgiyi öğrendikten sonra adapter nesnelerimizi yaratıp temp isimli listemize ekliyor ve method sonucu olarak geri döndürüyoruz. Artık elimizde her bağdaştırıcının adlarının ve idlerinin bulunduğu bir bağdaştırıcı listesi var. Böylece ekranımız açılırken yapılan ilk işlemimiz tamamlandı.

  

Ekranımız açılırken yapılan ikinci işlem ise xml dosyasından DNS IP bilgilerinin okunması. Bu bilgileri okumadan önce XML dosyamızın yapısına bir göz atalım.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/10.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/10.PNG)

Resim 8: XML Şeması

--------------------﻿--------------------------------------------------------------------------------------------------------------------------------------------

  

XML şeması dnsServers altındaki Server düğümlerinden oluşuyor. Her sunucunun bir tercih edilen bir adet de alternatif ip adresi bulunuyor. Bu şemayı okumak için Service sınıfımızın altında xmlReader(xmlName) isimli bir metodumuz bulunuyor. Aldığı parametre ilgili xml dosyasının ismini ifade etmekte. Kodlarımızı incelemeden önce aşağıdaki kodları anlayabilmeniz için XML işlemleri ile ilgili  [buradaki siteye](http://www.c-sharpcorner.com/uploadfile/mahesh/readwritexmltutmellli2111282005041517am/readwritexmltutmellli21.aspx)  göz atmanızı tavsiye ederim.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/11.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/11.PNG)

Resim 9: DNS Bilgilerinin Alınması

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

Dosyamızı açıp içerisindeki bütün düğümleri bir kez geziyoruz. Karşımıza çıkan preferred ve alternate düğümlerini birer listede topluyor ve en son bu düğümlerden server nesnelerimizi yaratıp bir liste halinde geri döndürüyoruz. Böylece programımız başlatıldığında yapılan 2. işlemimiz de bitmiş oluyor.

  

Programımız açıldığında yapılan 3. ve son işlem bu elde edilen Adapter ve Server sınıflarından türeyen nesnelerin ekrana basılmasından ibaret. Bunun için fillInAdapters ve fillInServers metodlarını kullanacağız. Metodlar listelerin içindeki nesnelerin değişkenlerini comboBox'lara dolduracaklar.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/12.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/12.PNG)

Resim 10: ComboBox'ların Doldurulması

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

Artık buton eventlarımızı yazmanın vakti. Elimizde açıldığında regeditten ilgili kayıtları okuyup bilgisayarımızdaki ağ bağdaştırıcılarının isimlerini ve programda daha önceden kayıtlanmış dns adreslerinin listesini xml dosyasından okuyup ekrana basan bir kodumuz var. Şimdi DNS ayarlarımı değiştir butonuna basıldığında neler olduğuna göz atalım.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/13.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/13.PNG)

Resim 11: DNS Değiştirme Event'ı

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

ComboBox'ların seçili olup olmadığı kontrol edildikten sonra yine Service sınıfımızın changeDnsServer metodunu çağırıyoruz. Bu metod tercih edilen ip adresini, alternatif ip adresini, dns sunucu ipsini ve ilgili bağdaştırıcının idsini alıp değişiklik işlemini gerçekleştiriyor. Acaba bunu nasıl yapıyoruz, inceleyelim.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/14.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/14.PNG)

Resim 12: DNS Değişikliğinin Yapılması ve FlushDns

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

Burada yeni bir registry key instance ı alıp bu instance ımızın değerini değiştiriyoruz. Windows işletim sistemlerinde DNS adreslerinin regeditte saklandığını söylemiştik. Bu saklandığı anahtar

  

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/15.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/15.PNG)

altında ilgili ağ bağdaştırıcısının id'si ile devam etmekte. Sonuna \"adapterId" verildiğinde bu düğümün altındaki NameServer anahtarının değeri değiştirildiğinde DNS adresimiz değişmiş olacak. Bu dediklerimizi changeDnsServer adlı metodumuz gerçekleştiriyor. Metodumuzun sonunda flushDns metodunu çağırıyoruz.  

Burada command satırına bir process gönderiliyor. Ipconfig yordamını -flushdns argümanıyla çağırarak regeditte yaptığımız değşikliklerin uygulanmasını sağlıyor oluyoruz. Böylece yaptığımız değişiklikler uygulanmış oluyor.

  

Aynı şekilde DNS ayarının sıfırlanması da aynı anahtarın değerinin null olarak kaydedilmesi ile gerçekleşiyor. İlgili çağırım ve kodlar aşağıda.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/16.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/16.PNG)

  

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/17.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/17.PNG)

Resim 13: DNS Ayarlarını Sıfırlama

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

Bu adımlardan sonra son bir adım yeni bir DNS adresinin kaydedilmesi adımı. Bunun için var olan DNS adres listesine yeni adresi ekledikten sonra aşağıdaki xml yazma metodunu çağırmamız gerekiyor.

  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

[![](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/18.PNG)](/images/2010-11-10-c-ile-dns-degistirme-uygulamasi/18.PNG)

Resim 14: DNS Adresi Ekleme

----------------------------------------------------------------------------------------------------------------------------------------------------------------

  

Bütün bu işlemlerden sonra programımız bitti :) Şu anda regeditten ağ bağdaştırıcılarının listesini çekip ekrana basabilen, DNS adreslerini saklayabilen, istediğimiz bağdaştırıcının DNS adresini değiştirebildiğimiz, eski ayarlarına tekrar dönebildiğimiz bir programımız var. Proje Visual Studio 2010 ile yapıldı. Framework olarak .NET 4.0 Client Profile çalıştırabilmek için yeterli olacaktır. Projeyi kısa bir boşluğumda gerçekleştirdim, daha da geliştirilebilir bir durumda. Projenin source kodunu da yakın zaman içerisinde paylaşıyor olacağım.
