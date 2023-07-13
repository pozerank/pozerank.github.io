---
title:  "Centralized-Decentralized-Distributed Networkler ve Bizans General Problemi"
date:   2018-01-21 12:04:23
categories: [blockchain]
tags: [cryptocurrency, centralized, decentralized, distributed, consensus, network, byzantine, bizans, general, distributed, legder, blockchain, bitcoin, block,  blockchainturk, blockchainturk.net]
image: https://cdn-images-1.medium.com/max/150/1*veQ2_LO2geVmGhwFGc7o9A.jpeg
---

Bugün değineceğimiz konu blockchain teknolojilerini incelemeye başlayan birçok kişinin kafasında ilk oluşan soruyu barındırıyor; nasıl oluyor da kötü niyetli insanlar böylesi bir sistemi manipüle edemiyor? Bu sorunun cevabını bulabilmek için bugün:

-   Merkezi-Merkezi Olmayan ve Dağıtık yapıları,
-   Merkezi yapılardan merkezsiz yapılara geçişi ve doğan problemleri
-   Bizans General Problemi tanımı ve örneği
-   Consensus algoritmalarının tanımı ve işlevi
-   Örnek consensus algoritmaları konularına değineceğiz.

![](https://miro.medium.com/max/704/1*veQ2_LO2geVmGhwFGc7o9A.jpeg)

İlk olarak belki de görmekten bıktığınız bir görsele tekrar değinmeden geçmemeliyiz. Tahmin ettiğiniz üzere bu görsel centralized (merkezi), decentralized (merkezi olmayan) ve distributed (dağıtık) network şemalarını barındırıyor.

![](https://miro.medium.com/max/800/1*EgT_oMcyVnmvqB8xmOZaVw.png)

Networkler

-   **Centralized**: merkezi yapıları temsil etmektedir. Bir bankanın müşterileri ile olan iletişimi tam olarak merkezi bir yapıyı temsil etmektedir.
-   **Decentralized**: blockchain teknolojilerinin konumlandığı yer burasıdır. Fikir birliğinin(consensus) tek bir merkezde yapılmadığı yapıdır.
-   **Distributed**: BitTorrent gibi yapılar bu sınıfa örnek gösterilebilir.

Banka örneğiyle başlayalım, centralized bir networkte yapılan işlemlerin tekilliğini, doğrulamasını yapan bankanız vardır. Sadece bunları değil hata toleransını da bankanın kendisi yönetir. Bir müşteri hayal edin, hesabında 100 TL mevcut. Banka bu kişinin bir manipulasyon veya bir problem sebebiyle 2 kez 100er TL’lik transfer yapmasını(double spend problem) engelleyecektir. Oldu ki sistemde bir problem-hata söz konusu oldu ve para transfer edilemedi, müşterinin hesabından para eksilmemesi ve karşı hesaba para gitmemesi garanti altına alınacaktır. Ayrıca bu paranın sadece ve sadece o müşterinin kendisi tarafından transfer edilebilmesini de garanti altına alacaktır.

Bu yapıda merkezi olan kuruluş tüm katılımcılar tarafından yetkilendirilmiş ve güvenilmiş olan yer olarak tanımlanabilir. Örneğin Facebook da centralized bir network örneğidir, siz bilgilerinizi merkezi bir otoriteye teslim edersiniz, o da kendisi üzerinden bütün networkü belirli kurallar dahilinde birbiriyle iletişime sokar. Peki merkezi bir otoritenin bu kontrolleri yapmadığı bir ortamda, herkesin birbiriyle açık açık iletişime geçtiği bir yapıda nasıl olur da birileri sahte mesajlarla sizin hesabınızdan kendi hesabına 100 TL’nizi çekemiyor. Veya olmayan bir coinin transferi nasıl engelleniyor?

Bütün bu soruların belki de ilk kaleme alınışı 1982 yılına dayanıyor. Bizans General Problemi; Leslie Lamport, Robert Shostak ve Marshall Pease’in birlikte ele aldıkları bir  [akademik makale](https://www.microsoft.com/en-us/research/publication/byzantine-generals-problem/?from=http%3A%2F%2Fresearch.microsoft.com%2Fen-us%2Fum%2Fpeople%2Flamport%2Fpubs%2Fbyz.pdf)  ile dile getirdikleri kavram. Özetleyecek olursak, bir Bizans ordusunun 4 generali ile birlikte bir şehri kuşattığını düşünelim. Yalnız şehir o kadar büyük ki bu 4 general birbirinden farklı noktalarda ordularını konuşlandırmış vaziyette ve ertesi sabah bir saldırıyla şehri ele geçirmek üzere bir planlama yapılacak. Tabii iletişim bir problem, bir general diğer generalle iletişimini ancak bir haberci göndererek yapabiliyor. Ancak haberci yolda ölebilir, ele geçirilebilir. Böyle bir durumun farkında olan generaller de gönderdikleri mesaja o mesajın alındığına dair bir mesaj daha geldiği suretçe ancak saldırıya katılacağını iletiyorlar. Yalnız kritik bir diğer konu da bu generallerin hepsinin sabah aynı saatte saldırdığı sürece şehri alabilecekleri konusu, o yüzden saldırı vaktinin mutabakatının sağlanması, tüm generallerin bu konuda hemfikir olması kritik bir konu.

![](https://miro.medium.com/max/425/1*N1GNB2BiellNrlFvowUfxQ.png)

Mutabakat Süreci

Problemin farklı versiyonlarında hain generaller de işin içine giriyor. Yani diğer generallere bilinçli olarak yanlış bilgi vererek saldırıyı sabote etmek için uğraşan generaller de işin içine katılıyor. Bu problemin farklı isimli versiyonları da mevcut. Hepsinde ortak olan konu ise merkezi bir otorite olmaksızın networkteki herkesin ortak bir uzlaşıya varma ihtiyacı, kötü niyetli katılımcılara karşı doğru uzlaşının sağlanabilmesi ve hata durumlarında sistemin kendi kendini tolere edebilmesi. Bizim blockchain örneklerinde de tam olarak aynı soruların cevabını aradığımızı söyleyebiliriz.

> Bir blockchain gerçekleştirimi güvenli bir iletişim ortamını sağlamak için Bizans General Problemini çözmesi gereklidir. Bunları da Consensus algoritmaları ile gerçekleştirirler.

Farklı altcoinlerin onlarca farklı consensus yaklaşımına internetten ulaşmanız mümkün. Bizans General Probleminin çözümü olan iki consensus yaklaşımının blogumuzda incelemesini yapmıştık.  [Proof of Work](https://medium.com/blockchainturk/3f32a068d10)(PoW) şu an için Bitcoin ve Ethereum gibi en popüler coinlerin de kullandığı Bizans General Problemi çözümü olarak düşünülebilir. PoW için onca işlem gücü, onca elektirik sarfiyatı tam olarak Bizans General Probleminin çözümü sağlanabilmesi için harcanmaktadır. 2018 senesi itibariyle Vitalik Buterin’in Ethereum hakkında geçiş yapabileceği başka bir algoritma olarak nitelendirilen Proof Of Stake(PoS) inceleme yazımıza da  [buradan](https://medium.com/blockchainturk/88e0315448a1)  erişebilirsiniz.

Toparlayacak olursak, merkezi olmayan yapılarda mutabakatın sağlanması çözülmesi güç problemlerdendir. Blockchain dünyasının parlayışı ile birlikte bu probleme üretilen çözüm çeşitliliği de gün geçtikçe artmaktadır.

Yazılarımızın devamlılığını sağlayabilmemiz için lütfen yorumlarınızı iletmeyi unutmayınız. Ve bizi  [**LinkedIn**](http://linkedin.com/groups/13568839)  ve  [**Facebook’ta**](https://www.facebook.com/blockchainturknet/) takip edin, topluluğumuzun bir parçası olun.