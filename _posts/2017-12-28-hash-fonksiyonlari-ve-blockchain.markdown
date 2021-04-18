---
title:  "Hash Fonksiyonları ve Blockchain"
date:   2017-12-28 12:04:23
categories: [blockchain, security]
tags: [hash, fonksiyon, nedir, örnek, blockchain, bitcoin, distributed, legder, block, blockchainturk, blockchainturk.net]
image: https://cdn-images-1.medium.com/max/150/1*EPyEPIIU2NmpqufwBAPTBQ.jpeg
---


Kaptan, tek gidişlik bir bilet ver bana! Eğer kaptanınız Elon Musk ise ve 2022 yılında bu cümleyi yeterli miktarda para ile desteklerseniz varış noktanız Mars bile olabilir!

![](https://miro.medium.com/max/800/1*EPyEPIIU2NmpqufwBAPTBQ.jpeg)

Tek gidişlik bir bilet tabirine geri dönelim. Evet tek gidişlik bir bilet istiyorsunuz, yazıhane sizden bilgileri alıyor ve biletinizi kesiyor ama size verilen biletin üzerinde anlamsız harf ve sayılar var. Bir sürü anlamsız harf ve sayıdan oluşan bir kağıt elinize tutuşturuldu ve buyrun biletiniz,  **#hashiniz** dendi. Sonra yanınızdaki diğer yolcunun hashine baktınız, onda da bambaşka karmaşık sayı ve harfler var, sizinkinden farklı. Otogarda biraz daha geziniyorsunuz ama meraklısınız, herkesin biletine bakıyorsunuz, herkesin biletindeki yazılar hep ama hep farklı. Tek ortak noktaları, hepsinin uzunluğu aynı. Mesela hepsi 512 karakterden oluşuyor.

Emin olamıyorsunuz, acaba yeni bir bilet daha alsam yine aynı sayılardan mı oluşur diye, bu kez başka bir yere bilet istiyorsunuz. Size ne zaman gideceğiniz adınız soyadınız TCKN’niz vs vs bilgiler yine soruluyor, bir koltuk seçiyorsunuz ve yeni biletiniz oluşturuluyor. İlk biletinizle karşılaştırıyorsunuz, bundaki yazının bambaşka olduğunu görüyorsunuz. Yine otogardaki herkesin biletine bakıyorsunuz, hiçkimsenin biletiyle aynı değil ama yine 512 karakterden oluştuğunu farkediyorsunuz.

![](https://miro.medium.com/max/800/1*kYdSmY9sAYeZ7_Vak2YRJg.jpeg)

Sizin bu biletteki yazının mantığını anlamaya merakınız iyice arttı. Biliyorsunuz ki herkeste farklı bir yazı var, aynı yazıyı elde etmenin bir yolu yok mu diye kendinize soruyorsunuz ve aklınıza bir fikir geliyor. Yazıhanedeki personelle muhabbetiniz 2 bilet sonrası arttı, size çay kahve de ısmarladı sohbet ediyorsunuz. Ya bendeki ilk biletteki bütün bilgileri aynen tekrar sisteme girsen de bana bir bilet kessen diyorsunuz. Personel zaten o seferdeki o koltuğun sizin adınıza soyadınıza TCKN’nize satıldığını, niye böyle bir şey istediğinizi soruyor ama siz boşver onu hadi dediğimi yapalım diyorsunuz. Yapıyorsunuz da, herşeyiyle aynı girdilerden oluşan bir bilet daha oluşturulduğunda şaşkına dönüyorsunuz, elinizde ilk biletinizle birebir örtüşen aynı rakam ve karakterlerden oluşan 512 karakter olduğunu görüyorsunuz. Buradan anlıyorsunuz ki aynı inputları verdiğiniz taktirde aynı çıktıyı elde edebileceksiniz.

Artık şu biletlerin bütün olayını çözdüm diye keyifle otobüsünüzü beklemeye başlarken bir arkadaşınız aradı telefonla sohbet ettiniz. Eski günlere gittiniz, otobüsünüzün gelmesiyle sohbetiniz sona erdi. Erdi ama bir problem var, bu sürede koltuk numaranızı unuttunuz. Biletinize baktınız, anlamadığınız bir sürü yazı… Acaba biraz dikkatli baksam bir yerinde geçiyor mu dediniz ama anlamlı ne bir kelime ne de bir sayı yakalabildiniz. Koşarak yazıhaneye döndünüz, bana bu bileti vermiştiniz ama koltuk numaramı unuttum şu biletteki yazıları tersine çevirin de koltuk numaramı öğreneyim dediniz. Az önceki ahbap olduğunuz personel üzülerek bu yazıyı tersine çevirmenin bir yolu olmadığını söyledi. Bunu duyduğunuzda katlanan paniğinizle rüyanızdan terler içinde uyandınız :)

![](https://miro.medium.com/max/693/1*VJCXtv1gLzsSj_mkhZ8S8w.jpeg)

Evet üzerinde bilgileri açıkça yazmayan ve tersine çevrilemeyen bir bilet gerçekten de kaos olurdu. Ama yukarıda bahsedilen herşey tam olarak da anlatmak istediğimiz konunun kendisi oluyor. Verilen inputları belirli uzunlukta tekil bir outputa dönüştüren, aynı inputlarla giriş yapıldığında her zaman aynı outputu oluşturan ve oluşturulan outputtan inputlara erişimin mümkün olmadığı fonksiyonlara #Hash Fonksiyonu, oluşan outputa da #Hash ya da #Digest denmektedir. Hash Türkçe’ye genellikle özet olarak çevriliyor. Temel olarak benzemekle birlikte tam olarak doğru olmadığını söylemek gerekir, çünkü bir kitabın özetini yaptığınızda o özet kitap hakkında bilgi verir. Ama hashten, o hashi oluşturan inputlar hakkında bir bilgi sağlamak mümkün değildir.

Peki o zaman niçin hash fonksiyonlarına ihtiyaç duyuluyor diye sorduğunuzu duyar gibiyim. Madem geri döndürülemiyor, karmakarışık bir yazı bizim ne işimize yarayacak? Şöyle bir örnekle açıklayalım. Bilgisayarınızda diskinizdeki yeriniz azaldı, bir bahar temizliği yapmak istiyorsunuz. Bu temizliğe uzunca zamandır elinizi dokundurmaya korktuğunuz fotoğraf arşivinden başlamaya kararlısınız. Klasörlerin içinde gezinirken şunu farkettiniz, gittiğiniz bir düğünün fotoğrafları tekrar tekrar farklı klasörlerin içine dağılmış vaziyette, kötü haber ise hepsinde dosya isimleri farklılaşmış. Aynı fotoğraf bir yerde Foto1.jpg ismiyle varken başka bir yerde yeğenlerleBirlikte.jpg olarak geçiyor. Bir iki fotoğraf olsa tamam ama yüzlerce fotoğraf iç içe geçmiş ve tek tek bu fotoğrafları incelemekten başka çarenizin kalmadığını düşünüp bahar temizliğini yine erteliyorsunuz.

Aslında ertelemek zorunda değilsiniz, bütün fotoğrafların ayrı ayrı hash fonksiyonuna sokulduğunu hayal edin(dosya ismi hariç şekilde). Dolayısıyla her fotoğraf için o fotoğrafı tekil olarak tanımlayıcı bir hash üreyecektir. Dolayısıyla farklı isimlere sahip olsalar bile aynı hashe sahip dosyalar aslında içerik olarak da aynıdır yani tekrarlayan fotoğraflardır. Böylece tekrarlayan fotoğrafların tespiti çok kolay hale gelecektir.

# Blockchain ve Hash

![](https://miro.medium.com/max/800/1*EUA97GHTQyiAH9Pke7FZ9Q.jpeg)

Örneğimizi Bitcoin üzerinden verelim. Bitcoin proof of work konsepti ile çalışır, işin ispatı olarak Türkçe’leştirebiliriz. Başka bir yazıda Proof of Work konseptini detaylarıyla inceleyeceğiz. Şu an için ihtiyaç duyduğumuz kadarıyla anlatmak gerekirse, bir bitcoin transfer emri verdiğimizde bu işlemler sıraya girerler ve bir sonraki miningde işleme alınmayı beklerler. Mining işlemi başlarken belirli bir miktar işlemden bir block yaratılır. Bu block aynı yukarıdaki örnekteki gibi bir hash fonksiyonuna girer ve block’u tekil olarak nitelendiren bir hash oluşur. Proof of Work buradaki oluşan hashin spesifik bir özelliğe sahip olmasını gerektirmektedir, örneğin oluşan 35 karakterlik hashin ilk 15 karakterinin ‘0’ olması. Ama biliyoruz ki hash fonksiyonları aynı inputlarla farklı output oluşturabilen bir fonksiyon değildir. Bu sebeple inputlarına bir ardışık olarak artan bir rakam eklenir. Örneğin 1 rakamını input olarak verip de oluşturulan hashin ilk 15 karakteri ‘0’ değil ise 2 rakamı verilerek tekrar denenir. İstenen hash oluşuncaya kadar bu rakam artırıla artırıla devam edilir, zaten mining’in can noktası da budur. Daha detaylı olarak Proof of Work yazımızda bu süreci iyice anlatacağız.

Özetlemek gerekirse, hash fonksiyonları Proof of Work’ün tam kalbidir. Diğer Blockchain örneklerinde de kullanılan birer tekil tanımlama fonksiyonlarıdırlar. Hash fonksiyonlarının teknik detaylarına ileride bir yazıda değinmeyi düşünüyoruz, şu an için detaylı bilgi almak isteyenler  [buradaki](https://en.wikipedia.org/wiki/Hash_function) wiki sayfasından bilgi edinebilir.

Yazılarımızın devamlılığını sağlayabilmemiz için lütfen yorumlarınızı iletmeyi unutmayınız. Ve bizi  [**LinkedIn**](http://linkedin.com/groups/13568839)  ve  [**Facebook’ta**](https://www.facebook.com/blockchainturknet/) takip edin, topluluğumuzun bir parçası olun.


