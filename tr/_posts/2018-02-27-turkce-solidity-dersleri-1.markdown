---
title:  "Türkçe Solidity Dersleri - 1"
date:   2018-02-27 12:04:23
categories: [blockchain, smart contracts]
tags: [solidity, cryptocurrency, centralized, decentralized, distributed, sanal, para, dijital, kripto, distributed, legder, blockchain, bitcoin, block,  blockchainturk, blockchainturk.net]
image: https://cdn-images-1.medium.com/max/150/1*bkQ65Bgo5_4Fi0BnsDYO1A.jpeg
---

Smart contractlara değindiğimiz yazılarımızdan sonra Solidity ile smart contractlara eğilmeye başlayacağız. Tamamen Türkçe olarak devam ettirmeyi planladığımız bu dersleri zaman ilerledikçe videolarını çekip ücretsiz olarak Udemy üzerinde yayınlama planlarımızın olduğunu söyledikten sonra giriş yapabiliriz.

![](https://miro.medium.com/max/1280/1*bkQ65Bgo5_4Fi0BnsDYO1A.jpeg)

Girişimiz hızlı olacak. Blockchain konsepti hakkında bilgi seviyemiz iyi ise hızlıca ilerleyeceğiz, eksik olduğunu düşündüğünüz konular varsa blogdaki Blockchain’e Giriş ve Teknik Yazılar başlıklarındaki yazıları öncelikle okumanızı tavsiye ediyorum.

Genellikle ilk ders geliştirme ortamlarının kurulumu şeklinde olur biz bunun yerine temel kavramlara değinerek başlayacağız. Öncelikle üç kavrama değinelim, bunlar Ethereum, nasıl çalıştığı ve Ether kavramları.

Ethereum, decentralized uygulamaların üzerinde çalışabileceği herkese açık bir blockchain geliştirme platformudur. Tamamen açık kaynak kodlu olan bir projedir. 2013'te Vitalik Buterin tarafından duyurulduğunda kendisini Bitcoin’den farklı olarak tekrar tekrar programlanabilen ve kompleks iş kurallarını işletebilen bir proje olarak tanımladı. Bitcoin’i bir rakip olarak tanımlamaktan çok Blockchain 2.0'ın tanımını ortaya koymuş oldu.

Ethereum programlanabilir bir blockchain örneğidir. Bitcoin’de değer transferi olarak önceden tanımlanmış kurallar işletilirken Ethereum her geliştiriciye kendi kurallarını kodlayabilmesini sağlayan bir altyapı sunmaktadır. Bu altyapının temelinde yatan konu Ethereum Sanal Makinesi(Ethereum Virtual Machine-EVM)’dir. EVM, Ethereum’daki smart contractların çalışabilmesi için bir runtime environmenttır. Erişilmesi, değiştirilmesi mümkün olmayacak şekilde izole edilmiştir. EVM üzerinde çalıştırılan kodlar aynı Java’da, C#’ta olduğu gibi EVM’in anlayacağı bir bytecode formatına çevirilir. Bu bytecode’lar bizim smart contractlarımızdır, derlenen bytecode’lar çalıştırılması üzere Ethereum clientlarına dağıtılır. Contractlarımız yine EVM’in izin verdiği ölçüde sınırlandırılmış kurallar dahilinde diğer smart contractlar ile iletişime geçerek çalışmalarını sağlarlar. Ethereum peer to peer çalışma prensibiyle çalışmaktadır. Dağıtılan contract dağıtıldığı tüm clientlar tarafından aynı girdilerle çalıştırılır ve aynı sonucu oluştururlar. Consensus algoritmaları sonrasında varılan ortak karar peerların her birinin kendi ledgerı üzerinde nihai güncellemeyi yapmasıyla birlikte sona erer.

Peki Ethereum nasıl çalışıyor? Bitcoin ile kıyaslayarak giriş yapalım, Bitcoin’in temelinde en temel şey işlemin kendisidir(transaction). Ethereum Bitcoin’den farklı olarak merkezine account(hesap) koyar ve her bir hesabın durumunu takip etmeye, yapılan işlemlerden sonraki son durumlarını güncel tutmaya odaklıdır. Accountlar 2 çeşittir, Externally Owned Accountlar(EOA) ve Contract Acccounts. Contract account’ları contract kodları tarafından kontrol edilen ve kullanılan hesaplardır. Bu hesapların aktivasyonunu sağlayan hesaplar ise EOA’lardır, adından da anlaşıldığı üzere dışarıdan sahipliği yönetmek ve kontrolü için private keyler ile kullanılır. Contract hesaplarına dışarıdan bir erişim mümkün değildir, sadece EOA’lardan gelen bir komut sonucunda güncelleme gerçekleşir, rastlantısal ve kontrolsüz bir erişimin/işlemin yapılmasını engellemek için bu şekilde bir hiyerarşi kurulmuştur.

Yapılan her bir işlem diğer birçok blockchain örneğinde olduğu gibi ufak işlem ücretleri(fee) karşılığında yapılmaktadır. Sistemin devamlılığının sağlanması, zararlı işlemlerin yapılabileceği bir ortamın sınırlandırılması gibi birçok sebep bu işlem ücretlerinin sebebi olarak gösterilebilir. Bir işlem eğer bir account’da durum değişikliği yaratıyorsa bu o işlemden ücret kesileceği anlamına gelmektedir. Örneğin Bitcoin’den konuşuyor olsaydık hesaptaki durum değişikliği accounttaki bakiye değişikliği olarak tanımlayabilirdik, burada da farklı bir durum söz konusu değil.

Değişikliğe uğrayan değer account’larda farklı state’ler yarattı. Hatırlarsanız  [UTXO yazımızda](https://medium.com/blockchainturk/unspent-transaction-output-utxo-eb426c950ad5)  her yapılan bir ödeme yeni bir durum yaratıyordu, bu şekilde kafalarımızda canlandırabiliriz. Hesaplarda oluşan durumların(bu şekilde Türkçe’leştirince anlamda kaymalar ve problemler olabiliyor bu sebeple orjinal isimleriyle devam etmeye çalışacağım..) tüm network’e dağılması için bir proof of sürecinin tamamlanması gerekiyor ki şu anda ethereum Proof of Work(PoW) kullanıyor. [Buradaki yazımızdan](https://medium.com/blockchainturk/java-ile-%C3%B6rnek-proof-of-work-ger%C3%A7ekle%C5%9Ftirimi-ve-mining-3f32a068d10)  da bu consensus mekanizması hakkında daha detaylı bilgi alabilirsiniz. Bu state’ler block ismi verilen yapılarda paketlenerek toplu olarak fikir birliğine varılır. Bu sürece adını sıkça duymaya alıştığımız mining ismi verilmektedir ve sonrasında yine toplu olarak her bir peer kendi ledgerı üzerinde değişikliği yapar.

Son olarak Ether ise bu blockchain sistemindeki para birimine verilen addır. EVM üzerinde ödemelerin yapılabilmesi için kullanılır, yine gas ismi verilen işlem ücretlerinin tahsilatında da ether kullanılmaktadır. Aşağıdaki şekilde alt kırılıma sahiptir.

**Unit                Wei Value    Wei **     
**wei**                 1 wei        1    
**Kwei (babbage)**      1e3 wei      1,000    
**Mwei (lovelace)**     1e6 wei      1,000,000    
**Gwei (shannon)**      1e9 wei      1,000,000,000    
**microether (szabo)**  1e12 wei     1,000,000,000,000    
**milliether (finney)** 1e15 wei     1,000,000,000,000,000    
**ether**               1e18 wei     1,000,000,000,000,000,000  
                      
[_http://ethdocs.org/en/latest/ether.html_](http://ethdocs.org/en/latest/ether.html)

Bir sonraki yazımızda kurulumlarla devam edeceğiz. Görüşmek üzere..

Yazılarımızın devamlılığını sağlayabilmemiz için lütfen yorumlarınızı iletmeyi unutmayınız. Ve bizi  [**LinkedIn**](http://linkedin.com/groups/13568839)  ve  [**Facebook’ta**](https://www.facebook.com/blockchainturknet/) takip edin, topluluğumuzun bir parçası olun.