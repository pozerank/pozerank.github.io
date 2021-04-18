---
title:  "Türkçe Solidity Dersleri -2- Fee, Gas Kavramları"
date:   2018-03-05 12:04:23
categories: [blockchain, smart contracts]
tags: [solidity, fee, gas, contract, cryptocurrency, centralized, decentralized, distributed, sanal, para, dijital, kripto, byzantine, bizans, general, distributed, legder, blockchain, bitcoin, utxo, block, blockchainturk, blockchainturk.net]
image: https://cdn-images-1.medium.com/max/150/1*K9pkxGaDtjcJidMJBFl_Cg.jpeg
---

Geliştirme ortamını tanımaya başlamadan önce ilk derste bahsettiğimiz ama biraz daha derinlemesine bahsetme ihtiyacı duyduğum konu ile devam edeceğiz. Bu konu fee’ler ve hesaplanması.

[İlk derste](https://medium.com/blockchainturk/turkce-solidity-dersleri-1-c33ebcbaebe0)  iki çeşit account tipi olduğundan bahsetmiştik. Bu hesaplar Externally Owned Accounts(EOA) ve Contract Accounts(CA) olarak adlandırılırlar. Bu hesaplar arası transferler de doğal olarak 2² ihtimalle gerçekleşeceklerdir:

-   Account to account
-   Account to contract
-   Contract to contract
-   Contract to account

![](https://miro.medium.com/max/640/1*K9pkxGaDtjcJidMJBFl_Cg.jpeg)

Derlenmiş olan bytecode EVM’ler üzerinde çalıştırılır. Bu EVM’ler minerların bilgisayarlarıdır, dolayısıyla tüm minerları gözümüzde canlandırırsak Ethereum networkü aslında global çapta çok büyük bir bilgisayara benzetilebilir. Siz bir contractı deploy ettikten sonra networke bıraktığınız anda binlerce node sizin contractınızı çalıştırmaya başlayacaktır.

Tabii bu çalıştırmanın bir maliyeti mevcut. En basit anlamıyla kodunuz sistem kaynaklarını ne kadar çok tüketiyorsa o kadar çok ücret(**fee**) ödersiniz. Bu ücrete Ethereum’da  **Gas**  ismi verilmektedir. Bu ödemeyi o EVM’lerin tükettiği CPU ve bellek kaynakları için bir kiralama ücreti olarak da düşünebiliriz. Bu ücretin ne şekilde hesaplandığı Ethereum’un yellow paper’ında Appendix B bölümünde detaylıca anlatılmıştır. Dokümana  [buradan](http://gavwood.com/paper.pdf)  erişebilirsiniz. Eğer Assembly’e aşinaysanız oluşan bytekodun ne şekilde gas tüketeceğini hesaplamak çok zor olmayacaktır, ilerleyen derslerde bunun bir örneğini yapacağız.

Tam burada b[ig O notation](https://en.wikipedia.org/wiki/Big_O_notation)  konusu değinmemiz gereken bir kavram halini alıyor. Bildiğiniz gibi big O notation yazdığımız kodun kompleksitesini hesaplayabilmemiz için matematiksel bir gösterim yöntemidir. Kodumuzun basit olması çok kritiktir, çünkü otomatik olarak kompleksitesi üssel artan bir algoritmayla yazılan kod çok fazla gas tüketecektir. Bu sebeple contractların mümkün olduğunca basit ve döngülerden uzak şekilde yazılmaları gerekmektedir.

Yazdığımız kodun yapısına göre contractımızın içerisine belirli bir miktar gas eklememiz gereklidir. Adının gas olması aslında bir tesadüf değildir, gerçekten de bu tutar kodunuzun yakıtıdır. Kodunuzun çalışabilmesi için contractınıza yeterli miktarda gas koymanız gerekmektedir. Kodunuz nihayete varıncaya kadar bu gas’ı tüketmeye devam edecektir. Contract’ınıza kodunuzun maksimum tüketebileceği gas tutarlarını belirtebilirsiniz. Bu ve bunun gibi bazı bilgiler contractınızın metadatasını oluşturmaktadır. Kodunuzun çalışması sona ermeden gas tükenirse veya maksimum değere ulaşırsa değişiklikleriniz rollback edilir. Yani nodelardaki ledgerlara değişiklik yansıtılmaz, çalıştırılan kadar değişiklikler iptal edilir.

Değişiklik kelimesi ücret hesaplamadaki kritik kelimelerden bir diğeridir. Contract kodundaki yaptığınız her işlem bu ücret hesabına dahil değildir. Yapılan işlemler eğer blockchain üzerinde etki yaratıyorsa, ledger üzerinde bir değişiklik söz konusuysa, ki biz buna state değişikliği diyoruz, işte o zaman sizden minerlara iletilmek üzere bir gas kesintisi yapılacaktır. İlerleyen derslerde metot tanımlarından, değişken tanımlarından bahsederken gas’tan tasarruf etmemizi sağlayacak ipuçlarını, optimizasyon yöntemlerini de paylaşacağız.

Yazılarımızın devamlılığını sağlayabilmemiz için lütfen yorumlarınızı iletmeyi unutmayınız. Ve bizi  [**LinkedIn**](http://linkedin.com/groups/13568839)  ve  [**Facebook’ta**](https://www.facebook.com/blockchainturknet/) takip edin, topluluğumuzun bir parçası olun.