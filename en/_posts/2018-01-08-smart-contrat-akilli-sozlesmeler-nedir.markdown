---
title:  "Smart Contract Akıllı Sözleşmeler Nedir?"
date:   2018-01-08 12:04:23
categories: [blockchain, smart contracts]
tags: [smart, contract, akıllı, sözleşme, nedir, distributed, legder, blockchain, bitcoin, utxo, block, blockchainturk, blockchainturk.net]
image: https://cdn-images-1.medium.com/max/150/1*mn7YQ-djF1q_lFiQTx4V0Q.jpeg
---

Üniversiteyi kazandınız, hayırlı olsun. Uzun sınav hazırlıkları bitti ve artık sosyalleşeceğiniz bir ortama yelken açtınız. İlk sene, yeni arkadaşlarla tanıştınız. Bir sene geçti, çömezliği üzerinizden attınız, belki hazırlık okudunuz. Bir çevre edindiniz, çok iyi arkadaşlarınız var. Artık 2 senenin sonrasında aranız o kadar iyi ki birlikte eve çıkmaya karar verdiniz. Tabii öğrenci adamsınız, mali durumlar sıkışık. Başladınız emlakçı emlakçı gezmeye, en uygunundan bir kiralık ev bulmak için...

![](https://miro.medium.com/max/515/1*mn7YQ-djF1q_lFiQTx4V0Q.jpeg)

Neyse bir yerde karar kıldınız ve artık her şey anlaşıldı önünüze imzalamak üzere bir kağıt koyuldu. Kağıtta şunlar yazıyor:

-   12 ayda bir ÜFE oranları doğrultusunda kira zammı yapılacaktır.
-   Kira her ayın 1i ile 5i arasında ödenecektir.
-   Depozito bedeli 1 kira ücreti olarak elden alınacaktır.
-   2018 yılı için başlangıç kira bedeli XXXX TL’dır.

Hayırlı olsun, ilk sözleşmenize imza attınız!

Hayatımızda onlarca farklı kontrat örneği mevcut, kira kontratı bunlardan sadece birisi. Yaşanmış güzel bir örnek verelim, ev alacaksınız tapuda devri yapılacak. Tapuda size bütün alacak verecek işlerinizi hallettiniz mi diye sorarlar. Eğer verilecek bir borcunuz varsa orada halledersiniz işinizi ve evet bütün alacak verecek işini hallettik dersiniz. Benim örneğimde paranın bir kısmı kredi, bir kısmı da nakit verilecekti. Yalnız problem şu ki, ev sahibi banka hesabı kullanmıyordu. Ee bu durumda borcun nakit kısmı mecburen gerçekten de elden ele para ile gerçekleşmesi gerekiyor. Ama bu da hırsızlığa davetiye çıkaran bir yöntem, çünkü o kadar para ile tapuya gidiyorsunuz. Hadi giderken kimse bilmiyor da devir esnasında o kadar paranın el değiştiği görülünce çıkışta apayrı bir risk sizi bekliyor… Özetle gerginlik, risk sizi bekliyor.

[Buradaki](https://medium.com/blockchainturk/blockchain-evrimi-ve-blockchain-3-0-4f1af18ef619)  yazımızda blockchainin evriminden bahsetmiştik, ethereumla birlikte kazandığımız en büyük değer tam da üstüne konuştuğumuz konu olan Smart Contract’lar. Smart Contract’lar gerçek hayattaki problemlere çözüm bulmanın yanı sıra daha fazlasını vadediyor. Ev kiralama örneğinden devam edelim. Örneğin kiranın ödenmesi, siz ev sahibinize bir dijital anahtar verdiniz. Ve bu anahtarın açabileceği bir contract tanımladınız ve içerisine kira tutarını koydunuz. Eğer ev sahibiniz o tarih geldiğinde o anahtarla gidip contractın içerisindeki meblağı kendisine alabilir. Eğer vaktinde alınmazsa da contract iptal olur.

Başka bir contractta da yıllık artış miktarını tanımladığınızı varsayalım. Smart Contract’ların güzel yanı dış dünya servislerinden bilgi alarak koşullarını kontrol edebilmesidir. Yıllık artış miktarı belirlenirken devletin sunduğu bir servise bağlanıp zam miktarı otomatik olarak belirlenebilir. Bu tarz bilgiler Kahin(Oracle) servisleri tarafından sağlanmaktadır.

Özetle iç içe if-then-else’ler yığını olarak adlandırabileceğimiz contractlar hangi durumda ne şekilde davranılacağının detaylı tanımlarından oluşmaktadırlar. Burada kritik olan nokta, Smart Contrat’lar hazırlanırken çok dikkatli hazırlanması gerektiği konusudur. Hatalı hazırlanmış contractlar uygun ihtimal seti yaratıldığı taktirde manipülasyona açık hale gelmektedir. Vitalik Buterin  [buradaki](https://blog.ethereum.org/2016/06/19/thinking-smart-contract-security/)  yazısında Smart Contract’lara yapılan atakların sonuçlarının can yakıcı olabileceği ile ilgili değinmiştir.

Özetle Distributed Applications(Dapps)’ın etkileşimde olacağı katman olan Smart Contracts, ledgerda değişikliği yaratan, blockchain teknolojilerini destekleyici önemli bir yapıtaşıdır.

Yazılarımızın devamlılığını sağlayabilmemiz için lütfen yorumlarınızı iletmeyi unutmayınız. Ve bizi  [**LinkedIn**](http://linkedin.com/groups/13568839)  ve  [**Facebook’ta**](https://www.facebook.com/blockchainturknet/) takip edin, topluluğumuzun bir parçası olun.