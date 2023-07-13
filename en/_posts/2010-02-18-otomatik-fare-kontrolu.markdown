---
title:  "Otomatik Fare Kontrolü"
date:   2010-02-18 20:04:23
categories: [microsoft, c#]
tags: [fare, kontrol, interop services, API]
---
Bugün interop servisleri aracılığıyla windows işletim sistemi üzerinde fare hareketlerini kontrol etme örneği yapacağız.

Konumuza giriş yapalım. Gün boyunca bilgisayarda tekrar tekrar yaptığınız şeyler oluyordur elbet. Farenizin belirli aralıklarla ekranın bir noktasını tıklaması gerektiği ve “keşke bunu benim yerime birisi yapsaydı” dediğiniz şeyler olmuştur. Kendimden örnek vermem gerekirse, Facebook’ta Fishville isimli bir oyun var belki duymuşsunuzdur. Bu tür oyunlarla pek aram olmamasına rağmen son 2 gündür bu oyun sardı ve tam manasıyla sürekli onunla uğraşıyorum. Oyunda belirli aralıklarla balıklarınızı beslemek zorundasınız, yoksa ölüyorlar. Ve her zaman bilgisayar başında olamıyorsunuz, dışarı çıkmanız gerektiğinde veya başka işlerle meşguliyetinizde bir de bakıyorsunuz balıklar mefta :))) Bu belirli aralıklarla balık besleme işi de tam bir angarya!! Angarya olduğu kadar sevimsiz gelen bu işlerimizi otomatikleştirmemiz de mümkün ise niçin yapmayalım :)  
  
[![](http://1.bp.blogspot.com/_-PvBeE2cwcg/S3ysfLw-XuI/AAAAAAAAAI8/99Kg4w1vgec/s200/mighty-mouse.jpg)](http://1.bp.blogspot.com/_-PvBeE2cwcg/S3ysfLw-XuI/AAAAAAAAAI8/99Kg4w1vgec/s1600-h/mighty-mouse.jpg)

Artık biraz teknik konulara girelim. Bugün fare olaylarının tetiklenmesi için ne türlü işlemler yapmamız gerektiği ve nasıl bir yöntem izleyeceğimizden bahsedeceğim. İşletim sistemleri kendi fonksiyonlarının kullanılabilmesi için programcılara bazı kütüphaneler sunar. Bu kütüphaneleri API (_Application Programing Interface_) olarak adlandırıyoruz. Programcılar bu kütüphaneler içerisindeki fonksiyonları kullanarak kendi programlarına işlevsellikler katabilmektedirler. Biz de projemizde bu API’lerden faydalanacağız.  

  
Kütüphaneler konusunda daha sonra detaylıca bir yazı paylaşmayı düşünüyorum ama şimdilik kısaca değinmek istiyorum. Kütüphaneler, temelde aynı işlemleri yapan farklı uygulamaların her defasında tekerleği baştan icat etmesini engellemek için kullanılırlar. Birden fazla process ilgili koda tek bir kütüphane ile bu sayede ulaşabilir. Diğer bir faydası da bu kodların defalarca belleğe alınması yerine bir kez alınarak processlerin o bellek alanını ortak kullanmalarını sağlayarak performans çözümü üretmektir. Windows ortamında iki tür kütüphane vardır. Statik kütüphaneler (_.lib_) ve dinamik kütüphaneler (_.dll_).  
  
Windows programcıların kullanabilmesi için temelde 3 tür API sunmaktadır. Bunlar  

1.  _Kernel_: sistemin kaynak ve bellek yönetimi için
2.  _User_: temel kullanıcı IO ları için
3.  _GDI_: sistemin temel arayüz işlemleri içindir.

Programcılar bu API’leri kullanarak projelerinde Windows’a ait bazı işletimleri kullanabilmektedirler. Bugün biz de Windows’un “_User32.dll_” kütüphanesi yardımı ile mouse ve keyboard olaylarının nasıl yaratılabileceği üzerisinde duracağız.  
  
C# ile API’lerin kullanılabilmesi için ilgili kütüphanenin projemize tanıtılması gerekmektedir. _DllImport_ işlemi için de  
[![1](http://lh4.ggpht.com/_-PvBeE2cwcg/S3ync0Dg9AI/AAAAAAAAAHo/6hRRrX5D6O0/1_thumb.png?imgmax=800 "1")](http://lh3.ggpht.com/_-PvBeE2cwcg/S3yncQORPgI/AAAAAAAAAHk/fLpl6oLWT9A/s1600-h/12.png)namespace’ini projemize eklememiz gerekiyor. Bu namespace ile CLR’ın (_Common Language Runtime_) unmanaged kodu managed koda çevirirken kullanılan servisleri kullanabiliyor ve parametre geçebiliyor olacağız.  
  
[![2](http://lh3.ggpht.com/_-PvBeE2cwcg/S3yneEue1DI/AAAAAAAAAHw/s_rxNghZBzs/2_thumb%5B6%5D.png?imgmax=800 "2")](http://lh6.ggpht.com/_-PvBeE2cwcg/S3yndfcMtXI/AAAAAAAAAHs/-dIZPwW5JOo/s1600-h/2%5B6%5D.png)  
Sıra geldi projemizde kullanacağımız kütüphanenin projemize tanıtılmasına. Kütüphanenin ismini verdikten sonra hangi charseti kullanacağını ve hangi çağırma biçimini kullanacağını parametre olarak veriyoruz. Çağırma biçimleri sistemin işleyişi ile ilgili olup çağırılan kodun nasıl arayüzünü temsil etmektedir. Yani hangi parametrelerin belleğe alınacağı, fonksiyonda hangilerinin kullanılacağı gibi ve bunların hangi şekillerde yapılacağı gibi standartlardan birisini seçmemizi sağlar. Kütüphanemizi projemize tanıttıktan sonra bu kütüphaneden hangi fonksiyonu hangi parametrelerle çağıracağımızı belirliyoruz.  
  
[![3](http://lh5.ggpht.com/_-PvBeE2cwcg/S3ynfipSehI/AAAAAAAAAH4/6xoT5ZZ7PIM/3_thumb%5B3%5D.png?imgmax=800 "3")](http://lh3.ggpht.com/_-PvBeE2cwcg/S3ynerCMhTI/AAAAAAAAAH0/bgkS_dpSa-U/s1600-h/3%5B4%5D.png)  
Projemizde fare olayını tetikleyeceğiz. Fare ile ilgili bir olay tetiklendiğinde, örneğin tıklandığında aygıt bir _interrupt_ üretir. Bu interrupt _aygıtın controller ı_ aracılığıyla _CPU_ a iletilir. CPU gelen interrupt ın içerisinde hangi aygıttan geldiği ve ne yapmak istediği ile ilgili bilgiler mevcuttur. CPU da bu işlem ile ilgili kodların nerede olduğunu öğrenmek için _interrupt vector_ e bakar. Bu kodlar aslında donanımlara ait kodlardır ve interruptın nasıl işletileceğini belirlerler. Interrupt vectorden ilgili kodun başlangıç adresini öğrenen CPU, ardından o adresteki kodları işletmeye başlar. Bu kadar uzun ve anlatması dahi sıkıcı aşamalar bizlerin farkında olmadığımız bilgisayarın arkada çalışırken gerçekleştirdiği işlemler. Bizim yapmak istediğimiz ise fare tıklanmadan yani interrupt oluşmadan ilgili kodun işlenmesini sağlamak. Kesintiyi bir donanımdan almayacağımıza göre CPU’ya hangi bellek adresindeki kodları işleteceği bilgisini kendimiz vermek zorundayız. Fare olaylarına ait bellek adreslerini tanımlayan flag hexadecimallerini aşağıda bulabilirsiniz.  
[![4](http://lh6.ggpht.com/_-PvBeE2cwcg/S3yngvq_B6I/AAAAAAAAAIA/93BHoec_K0w/4_thumb%5B2%5D.png?imgmax=800 "4")](http://lh5.ggpht.com/_-PvBeE2cwcg/S3yngB38aWI/AAAAAAAAAH8/M-6bTM9_zow/s1600-h/4%5B6%5D.png)  
Aslında bu adımdan sonra yapmamız gereken şey olarak sadece bu metodumuzu çağırmak oluyor. Kısaca yazdığım bir uygulamayı paylaşırsam sanırım daha anlaşılır olabilir. Parça parça kodlarımızı inceleyelim.  
[![11](http://lh3.ggpht.com/_-PvBeE2cwcg/S3ynjWKN8-I/AAAAAAAAAII/27ouEGI8pqA/11_thumb%5B14%5D.png?imgmax=800 "11")](http://lh6.ggpht.com/_-PvBeE2cwcg/S3ynh1KaY3I/AAAAAAAAAIE/LCH5Of0hC5w/s1600-h/11%5B20%5D.png)    
Buraya kadar yukarıda bahsettiğimiz işlemleri yapıyoruz. Dll imizi tanıtıyor ve flaglerimizi tanımlıyoruz.  
  
  
[![12](http://lh4.ggpht.com/_-PvBeE2cwcg/S3ynlSKOxgI/AAAAAAAAAIQ/PovDEoj4h4o/12_thumb%5B7%5D.png?imgmax=800 "12")](http://lh4.ggpht.com/_-PvBeE2cwcg/S3ynkU7KpEI/AAAAAAAAAIM/6YC6uHoY33k/s1600-h/12%5B10%5D.png)  
Programımızın içerisinde kullanacağımız global değişkenlerimizi tanımlıyoruz.  
  
  
[![13](http://lh4.ggpht.com/_-PvBeE2cwcg/S3ynm9vIcnI/AAAAAAAAAIY/ij74tRgXNSs/13_thumb%5B1%5D.png?imgmax=800 "13")](http://lh5.ggpht.com/_-PvBeE2cwcg/S3ynmELgExI/AAAAAAAAAIU/3vy0BA9gp7k/s1600-h/13%5B3%5D.png)  
Formumuz açılır açılmaz bilgisayarımızın ekran çözünürlüğüne göre trackBar ımızın her bir tick’inde faremizin kaç piksel hareket edeceği değerlerimizi set ediyoruz.  
  
  
[![14](http://lh4.ggpht.com/_-PvBeE2cwcg/S3ynozBcurI/AAAAAAAAAIg/DqhPWgZ1kjQ/14_thumb%5B1%5D.png?imgmax=800 "14")](http://lh6.ggpht.com/_-PvBeE2cwcg/S3ynn6g-mpI/AAAAAAAAAIc/wPDUgjd895w/s1600-h/14%5B3%5D.png)  
Faremizin pozisyonunu ayarlamak için faremizle ilgili trackBar’ı tıkladıktan sonra klavyemizin sağ ve sol ol tuşları ile faremizin konumlanacağı noktayı ayarlıyoruz. Bunu ekranda gösterebilmek için mouseMove methodunu kullanacağız. Ve dikey-yatay ayrımının yapılabilmesi için enum ekledim.  
  
  
[![15](http://lh6.ggpht.com/_-PvBeE2cwcg/S3ynqa8g6ZI/AAAAAAAAAIo/xmjsaaFwF5I/15_thumb%5B1%5D.png?imgmax=800 "15")](http://lh5.ggpht.com/_-PvBeE2cwcg/S3ynpRWDAII/AAAAAAAAAIk/hU89nbcaCjc/s1600-h/15%5B3%5D.png)  
Faremizin görüntüsünü ekranda görerek noktamıza karar verdik. Noktamızın koordinatları X ve Y isimli 2 integer değişkende tutuluyor. Zaman bilgimizi de set ettikten sonra programımızı çalıştırabiliriz.  
  
  
[![16](http://lh4.ggpht.com/_-PvBeE2cwcg/S3ynsAfnkwI/AAAAAAAAAIw/T-OUpPyvQtM/16_thumb%5B1%5D.png?imgmax=800 "16")](http://lh6.ggpht.com/_-PvBeE2cwcg/S3ynrER1DII/AAAAAAAAAIs/s8xB1I3J2nA/s1600-h/16%5B3%5D.png)  
TextBox ımızdaki verinin doğruluğunu kontrol ettikten sonra timer ımızı aktifleştirebiliriz. Tıklama durumu aktif iken fare koordinatlarının ve tıklama sıklığının değiştirilmemesi için kontrollerimizi kapatıyoruz.  
  
  
[![17](http://lh5.ggpht.com/_-PvBeE2cwcg/S3ynu361JsI/AAAAAAAAAI4/9Jl9ZGh_b14/17_thumb%5B1%5D.png?imgmax=800 "17")](http://lh3.ggpht.com/_-PvBeE2cwcg/S3yntZ8xLOI/AAAAAAAAAI0/r2RsAKfTetw/s1600-h/17%5B3%5D.png)  
Geri kalan ıvır zıvır methotlar da burada :P Burada dikkat çekmek istediğim nokta programın başında DllImport ile tanımladığımız mouse_event methodunu doğrudan kullanabiliyoruz. Bu da bizim COM objelerine ulaşabildiğimizi ve projemizde kullanabildiğimizi gösteriyor.  
  
Umarım faydalı olmuştur. Başka makalelerde görüşmek üzere. Aşağıda projeye ait dosyalar bulunmaktadır.  

 - Programın çalıştırılabilir haline ulaşmak için    [burayı](http://pozerank.uuuq.com/MouseClickEvent(exe).rar)    tıklayabilirsiniz.

- Programın proje dosyasına ulaşmak için  [burayı](http://pozerank.uuuq.com/MouseClickEvent.rar)  tıklayabilirsiniz.

- Fishville oyunu oynayanlar için balık besleme programı için de [burayı](http://pozerank.uuuq.com/FishVille%20Programi.rar) tıklayabilirsiniz :))
