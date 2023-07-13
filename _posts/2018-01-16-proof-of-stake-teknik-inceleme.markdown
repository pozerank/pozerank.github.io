---
title:  "Proof of Stake Teknik İnceleme"
date:   2018-01-16 12:04:23
categories: [blockchain]
tags: [cryptocurrency, proof, of, stake, pok, pow, work, java, nedir, distributed, legder, blockchain, bitcoin, utxo, block, blockchainturk, blockchainturk.net]
image: https://cdn-images-1.medium.com/max/150/1*_b-FnHy6qE0o7mvD3szw_w.jpeg
---

Ethereum’un kurucusu Vitalik Buterin’in “2018'de Ethereum Proof of Stake(PoS) ile yoluna devam edebilir” olarak yorumladığı bir Proof of konseptiyle daha karşınızdayız. Ethereum ve Bitcoin’in şu anda çalıştığı  [Proof of Work (PoW)](https://medium.com/blockchainturk/java-ile-%C3%B6rnek-proof-of-work-ger%C3%A7ekle%C5%9Ftirimi-ve-mining-3f32a068d10)  yazımızdan sonra bu ikinci ele aldığımız Proof of konsepti Proof of Stake olacak. PoS’u bir miktar PoW ile kıyaslayarak anlatacağız, eğer PoW ile ilgili bilgimiz az ise  [buradaki](https://medium.com/blockchainturk/java-ile-%C3%B6rnek-proof-of-work-ger%C3%A7ekle%C5%9Ftirimi-ve-mining-3f32a068d10)  yazımıza önce bir göz atmanızda fayda olabilir.

![](https://miro.medium.com/max/800/1*_b-FnHy6qE0o7mvD3szw_w.jpeg)

Proof of Stake, Proof of Work’ten farklı bir çalışma mantığına sahiptir. PoW’da daha yüksek işlem gücüne sahipseniz miningi sizin başarma ihtimaliniz daha yüksektir. Çünkü nonce değerini bulma şansınız artacaktır. PoS’te ise işlem gücünüzün değil ne kadar coininizin olduğu daha değerlidir. Hep verilen örnek, para parayı çeker örneği PoS için tam olarak geçerlidir. Aralarındaki en büyük fark özetle budur.  **Mining** kelimesini PoS için halen geçerli olsa da bunun yerine  **Staking** kavramını kullanarak devam etmek daha doğru olacaktır. Peki mevcut coinimiz stakingi yapabilmek adına nasıl fayda sağlıyor, bu sistem nasıl çalışıyor hadi gelin bu konuya daha fazla eğilelim.

![](https://miro.medium.com/max/800/1*K0hwUOv8zU9azncdxLcZBw.jpeg)

Öncelikle  **Age of Coin**  kavramını ele alalım. Coin yaşı olarak Türkçe’leştirebiliriz. Cüzdanınıza coininiz girdiği andan itibaren o coin miktarı için artmaya başlayan süresel bir değerdir. Cüzdanınızda ne kadar uzun süredir o coin duruyorsa bu coinin yaşı o kadar artacaktır. 10 gündür hareketsiz olarak bekliyorsa 10 gün yaşında coinleriniz olacaktır. Burada önemli nokta, sizin o coini transfer ettiğiniz anda yaşının sıfırlanacağıdır. Dolayısıyla cüzdanınıza giren coininizi transfer ettiğiniz anda yaşını kaybedecektir.

Makbul olanı yaşı artmış olan coinlerdir. Yani uzunca süredir sizde bulunan ve işlem görmeyen coinler değerlidir. Çünkü aged coinler sizin stakingden alabileceğiniz payı artıracaktır. Ayrıca diğer önemli bir konu  **Minimum Age’**i tamamlamamış olan coinler staking işleminden pay alabilmeye başlayacaktır. Bu süre farklı PoS gerçekleştirimlerinde farklı süreler olabilmektedir. Coin miktarınız ile bu coinin yaşı çarpılarak ağ üzerindeki pay ağırlığınız belirlenir. Bu bilgileri de paylaştığımıza göre bir işlem nasıl gerçekleştiriliyor, bir örnek ile devam edelim.

![](https://miro.medium.com/max/800/1*xNQnBUwt5oEEg6nV0RTIRw.jpeg)

Transfer emirleri kullanıcılar tarafından oluşturulduktan sonra  **mempool**’da tutulur. Burası emirlerin tutulduğu ve sonraki block dağıtımını bekledikleri yer olarak düşünebiliriz. Block oluşturma başladığı anda mempool’dan bir miktar işlem alınır ve alınan işlemlerin yanında bir tane de staking işlemi eklenir. Bu işlem staking ödüllerini içerir, yani bu işten dağıtılacak coinler burada bulunacaktır. Ve bu transaction listesi üzerinden blockchainin kendisi tarafından daha önce öngörülemeyecek şekilde bir  [hash](https://medium.com/blockchainturk/59da61356e9)  değeri oluşturulur. Bu yapı networkteki peerlara bir kod olarak dağıtılmaz, memoryde tutulacak şekilde yapılandırılmıştır, blockchainin kendisinin içerisinde bulunmaktadır. Bu yapı chainin içerisinde bulunduğu için değiştirilmesi mümkün değildir.

Networkteki diğer stakerlar bir önceki blockun da bilgilerini kullanarak sistem tarafından oluşturulan hashe en yakın hashi oluşturmaya çalışırlar. Ne kadar çok coininiz varsa bu çekilişte kazanma ihtimaliniz de bir o kadar yüksektir. Burada yine randomize seçim, coin yaşına göre seçim benzeri farklı örnekler mevcuttur. Block seçimi tamamlandıktan sonra block headerı oluşturumu tamamlanır ve block networke dağıtılır. Sonrasında da yine farklı örnekleri bulunan ödül paylaşımı süreci başlatılır.

Farklı PoS örnekleri mevcuttur,  [DASH](https://www.dash.org/),  [NEO](https://github.com/neo-project/neo),  [NovaCoin](http://novacoin.org/)  Proof of Stake konseptini kullanan kriptoparalara örnek verilebilir. Bazı örneklerde toplam coin miktarı sabit, bazılarında ise değişkendir. Bu durumlarda bütün bu yazıda anlatılanlardan farklı senaryolar da gerçekleşebilmektedir.

Özetlememiz gerekirse, Proof of Stake konseptinde elinizdeki coin miktarı ve ne kadar uzun süredir sizde bulunduğu önemlidir. Bu bilgilere göre stakingden alınacak pay belirlenmiş olacaktır.

Yazılarımızın devamlılığını sağlayabilmemiz için lütfen yorumlarınızı iletmeyi unutmayınız. Ve bizi  [**LinkedIn**](http://linkedin.com/groups/13568839)  ve  [**Facebook’ta**](https://www.facebook.com/blockchainturknet/) takip edin, topluluğumuzun bir parçası olun.