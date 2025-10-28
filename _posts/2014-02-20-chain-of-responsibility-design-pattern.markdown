---
title: "Chain Of Responsibility Design Pattern"
date: 2014-02-20 20:04:23
categories: [java, design-patterns]
tags: [java, design-patterns, chain-of-responsibility, mehmet-cem-yucel]
---

Bugün behavioral(davranışsal) bir design pattern(tasarım şablonu) olan Chain of Responsibility(Sorumluluk Zinciri) inceliyor ve örnek yapıyor olacağız.  
  
Şablonu kısaca özetlememiz gerekirse, belirli fonksiyonları ardı sıra gerçekleştirmesini beklediğimiz sınıflarımıza bu yetenekleri sağlamak istediğimizde Sorumluluk Zinciri tasarım şablonunu kullanırız. Kalıtım hiyerarşisinde farklı davranışlar sergileyen subtype(alt tip)'ler için gayet kullanışlı ve genişleyebilir bir altyapı sunmaktadır.  
  
Örnek üzerinden ilerlemek daha verimli olacaktır diye düşünüyorum. O zaman hadi başlayalım.  
  
Senaryomuz bir araç yıkamacılarında geçiyor. Müşteriler araçlarını getirip yıkanması üzere yıkamacıya bırakıyor. Gelen her aracın tipine göre bazı farklı yıkanma adımları olacaktır, örneğin bir motosikletin iç yıkaması olmayacağı gibi bir otobüsün bagaj temizliği de herhangi bir arabanın bagaj temizliğinden farklı olacaktır. Peki bu farklı tipleri nasıl ayırt edecek sonrasında nasıl davranışlarımızı gerçekleştireceğiz?  
  
Hemen modellerimizi yaratarak işe başlayalım. Abstract bir Arac sınıfı ve bu sınıfı kalıtan Otobus, Araba ve Motosiklet sınıfları yaratıyorum. İlk adımda görüntümüz aşağıdaki şekilde;  

[![](/images/2014-02-20-chain-of-responsibility-design-pattern/1.PNG)](/images/2014-02-20-chain-of-responsibility-design-pattern/1.PNG)

  
  
Madem modellerimiz hazır, artık davranışlarımızı yaratmaya geçebiliriz.  
  
İç temizlik ve dış temizlik gibi 2 tane temizlik davranışı gerçekleştiren, bu davranışları Arac sınıfından türetilmiş nesneler için gerçekleştirebilen bir yapı kuruyorum. Ve ileride herhangi yeni bir temizlik davranışı, örneğin motor temizliği de eklenecek olursa mevcut yapıya uyum sağlayacağını garanti altına almak için bir interface(arayüz) ile temizleme yapan sınıfları temizlik yapan metotların gerçekleştirimini yapmaya zorluyoruz. Ancak iç ve dış temizlik işlemlerini doğrudan bir interface'e bağlamak yerine önce bir sınıftan kalıtıyorum ve bu sınıf interface'i uyguluyor olacak. Koda dönüyoruz.  
  

[![](/images/2014-02-20-chain-of-responsibility-design-pattern/2.PNG)](/images/2014-02-20-chain-of-responsibility-design-pattern/2.PNG)

  
  
İç ve Dış temizlik sınıflarımız Temizlik sınıfından kalıtılıyorlar ve Temizlik sınıfımız da ITemizlik interface'i tarafından temizle metodunu gerçekleştirmeye zorunlu bırakılıyor. Temizle sınıfımızda zorunlu bırakılan metodu kodlamayarak dolaylı yoldan İç ve Dış Temizlik sınıflarının bu kodlamayı yapmaya zorlar duruma getiriyoruz.  
  
Buraya kadar her şey güzel, de Temizlik sınıfının içerisinde anlatmadığım bir şeyler duruyor. Nedir bu sıradakiIslem değişkeni, ve 2 tane metot? Şimdi bunlara gelmeden önce anlatmamız gereken başka şeyler var. Örnekle devam edelim.  
  
Aracımızı yıkamacıya götürdük. Eğer aracımız motosiklet ise sadece dışı yıkanacak. Ama araba ise önce dışı sonra içerisi yıkanacak. Yani aslında farklı araç türleri için apayrı yıkama stratejilerimiz var. Eğer gelen araç bir arabaysa önce dışının sonra da içerisinin yıkanması gerektiği gibi bir strateji ortaya çıkıyor. O zaman bu stratejilerimizi yaratarak yola devam edelim. İç yıkama, Dış Yıkama ve İç Dış birlikte yıkama yapabilmek için 3 tane strateji yaratıyorum. İç dış yıkamada da önce dış sonra iç yıkama olacak şekilde sıralamamı yapıyorum.  
  

[![](/images/2014-02-20-chain-of-responsibility-design-pattern/3.PNG)](/images/2014-02-20-chain-of-responsibility-design-pattern/3.PNG)

  
  
Peki burada ne yaptık. İlk önce şunu belirteyim, bu stratejileri 1 kez yaratılmasını istiyorum, lakin her araba geldiğinde tekrar tekrar strateji yaratmakla uğraşmamamız lazım. Bu sebeple stratejilerimiz singleton(tekillik) tasarım şablonuna uygun olacak şekilde yaratıldı. İç dış örneğinden devam edecek olursak, o zaman bir tane iç bir tane de dış temizliği yapan işlemlere ihtiyacım var ki bu işlemleri temizle metotları aracılığıyla yapan sınıflarımızı az önce yaratmıştık. O zaman bu sınıflarımızdan birer örnek alalım ve stratejimize yerleştirelim. Ve her Temizlik sınıfının da kendisinden sonra yapılacak işlemin ne olduğunu bilmesini sağlayalım. Yani sıradaki işlemi ata metoduyla dış temizlik sınıfı kendisinden sonra iç temizlik yapılacağını biliyor olsun.  
  
Az önce nedir bu siradakiIslem degiskeni ve 2 metot demiştik. Artık biliyoruz ki bu arkadaşlar bir temizlik işleminin kendisinden sonra hangi temizlik işleminin yapılacağını tutabilmesi için kullanılıyorlar.  
  
Baya bir kod yazdık, artık sona yaklaşıyoruz. Şu anda elimizde araçlarımız ve bu araçların kalıttığı abstract bir Arac sınıfımız, Temizlik abstract sınıfından türetilmiş ve temizle metotlarına sahip temizlik türlerimiz ve araçlar için kullanılabilir durumda temizlik stratejilerimiz var.  
  
Örneğimize her araç tipi için bir stratejiyi sabitleyerek devam etmek istiyorum. Böyle bir şey zorunlu değil elbette, bir araba sadece dış temizlik isteyebilir de. Ancak ben örneğimde motorların sadece dışı, otobüslerin sadece içi, arabaların da içi ve dışı yıkanacak şekilde bir yapı kuracağım. Bunun için abstract Arac sınıfına abstract bir metot ekliyorum ve diyorum ki, Arac sınıfını kalıtan bütün sınıflar bana kendisine ait yıkama stratejisinin ilk işleminin bilgisini verebilsin. Yani;  
  

[![](/images/2014-02-20-chain-of-responsibility-design-pattern/4.PNG)](/images/2014-02-20-chain-of-responsibility-design-pattern/4.PNG)

  
Gördüğünüz gibi bir herhangi bir araca ilk temizlik işlemini ver dediğimizde artık otomatikman hangi stratejiye sahipse ilk temizlik işlemini bize söyleyebiliyor. İlk işlemi alınca da stratejinin içerisindeki sıradaki işlemler de birbirlerine bağlı olduğundan dolayı temizliği başlattığımız anda peşi sıra bütün işlemler gerçekleşiyor olacak.  
  
Artık test etme vakti;  
  

[![](/images/2014-02-20-chain-of-responsibility-design-pattern/5.PNG)](/images/2014-02-20-chain-of-responsibility-design-pattern/5.PNG)

  

Uygulamanın kodlarına aşağıdaki adresten erişebilirsiniz.

[https://github.com/mehmetcemyucel/blog/tree/master/ChainOfResponsibility](https://github.com/mehmetcemyucel/blog/tree/master/ChainOfResponsibility)
