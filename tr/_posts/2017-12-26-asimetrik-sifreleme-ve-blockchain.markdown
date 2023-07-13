---
title:  "Asimetrik Şifreleme ve Blockchain"
date:   2017-12-26 12:04:23
categories: [blockchain, security]
tags: [dlt, encryption, şifreleme, simetrik, asimetrik, anahtarlama, distributed, legder, blockchain, bitcoin, block, blockchainturk]
image: https://cdn-images-1.medium.com/max/150/1*pUyqVMAKs2GknumbLB9K7w.jpeg
---


Simetrik Şifremele (Symmetric Encryption) konusuna  [burada](https://medium.com/blockchainturk/simetrik-%C5%9Fifreleme-ve-blockchain-980c1cbd7a12)  değinmiştik. Bugün ise konunun devamı niteliğinde asimetrik şifreleme algoritmaları ve örnek bir blockchain kurgusu üzerindeki kullanım noktaları ve amaçlarını ortaya koymaya çalışacağız.


![](https://miro.medium.com/max/800/1*pUyqVMAKs2GknumbLB9K7w.jpeg)

Simetrik şifrelemenin aksine asimetrik şifrelemede 2 farklı anahtar vardır ki zaten adını da buradan almıştır. Bu anahtarlar public yani herkese açık ve private yani sadece kişiye özel olmak üzere isimlendirilirler. Public anahtarlar  **networkteki**(tüm katılımcıların oluşturduğu ağ)  herkese dağıtılırlar, ancak private anahtarlar sadece ve sadece kişinin kendisi tarafından bilinmelidir. Asimetrik şifreleme 2 farklı şekilde kullanılırlar:

-   **Public key ile encryption, private key ile decryption**

Bu şekildeki kullanımda örneğin siz bir lokantasınız ve tedarik ağınız var. Tedarik ağınızdaki herkes size ait public keye sahipler, size günlük meyve ve sebzelerin fiyatlarını göndermeleri üzere bir kurgumuz olsun. Herkes size ait public key ile kendilerindeki malzemelerin fiyatlarını şifreleyip size gönderebilirler. Bir şekilde birbirlerinin verilerini ele geçirseler bile içindeki fiyat bilgilerini göremezler çünkü public key ile şifrelenen veri sadece ve sadece private key tarafından açılabilir ve bu anahtar da sadece sizde bulunmaktadır.

-   **Private key ile signing, public key ile verification**

Hemen güncel bir blockchain örneğini Bitcoin üzerinden verirsek, bir blockchain networkünde  **peer**ların(katılımcıların) birbirlerine mesaj göndererek haberleştiklerini biliyoruz. Örneğin A katılımcısı networke bir mesaj broadcast ediyor, B katılımcısı bu mesajı alıyor. Ancak B bu mesajı gerçekten de A’nın gönderdiğinden nasıl emin olabilir? Az önceki cümlemizi tekrarlarsak, public key networkteki tüm katılımcılara dağıtılır, private key ise sadece kişinin kendisi tarafından bilinir. Yani A katılımcısına ait public key tüm networkte olduğundan B katılımcısında da bulunuyor. A katılımcısı kendi private keyi ile imzaladığı veriyi networke gönderdiğinde diğer tüm katılımcılar A’ya ait public key ile bu verinin gerçekten A tarafından imzalandığından emin olabilir.

Bunların haricinde encryption amacıyla kullanılmayan, sadece secret key paylaşımı amacıyla kullanılan bir yaklaşım daha mevcuttur, bütün bu yaklaşımlara örneklerimize başlayalım.

[**RSA:**](https://en.wikipedia.org/wiki/RSA_(cryptosystem))

Bir şifreleme standardıdır. RSA yaklaşımında Encryption-Decryption başarımı düşük olduğundan genellikle sign-verification amacıyla kullanılır. Private key mesajın imzalanması için kullanılır, oluşan özet veri mesajın açık halinin içerisine eklenerek bu şekilde gönderilir. Alıcı, kendisine gelen ana mesajı public key aracılığı ile imzalayarak kendi özetini oluşturur ve gelen mesajın içerisindeki özet veri ile karşılaştırır. Eğer iki özet veri birbirini tutuyorsa doğrulama gerçekleşmiş olur.

![](https://miro.medium.com/max/513/1*GH2Y8qZxGXEgbSFRe9vtPA.gif)

Görsel:  [https://technet.microsoft.com/en-us/library/cc962021.aspx](https://technet.microsoft.com/en-us/library/cc962021.aspx)

Kafalarda oluşabilecek bir soruyu giderebilmek için özellikle bir konuyu belirtmek istiyorum, burada mesajın açık gittiğinden, yanında oluşturulan özetin eklendiğini söyledik. Peki bu networkte dolaşan verinin güvenliğine zıt düşmüyor mu, çünkü herkes veriyi görebiliyor diye akıllarda canlanmış olabilir. Evet bu doğrudur, işte bu yüzden genellikle özet verisi oluşturulmuş mesajımız özet veriyle birlikte bir kez de simetrik şifrelemeyle şifrelenip bu şekilde networkte dolaşıma çıkartılırlar. Alıcı öncelikle simetrik şifrelemeyi ortadan kaldırır, sonrasında mesaja ve özete ulaşır. Sonrasında da yukarıda bahsettiğimiz verificationı tamamlayarak işlemlerini tamamlarlar.

RSA’de public ve private keyler iki çok büyük asal sayı tarafından oluşturulurlar. Bu şekilde kırılma olasılığı çok düşürülmektedir. Aşağıda Java ile örnek bir RSA gerçekleştirimi bulunmaktadır.

[**Digital Signature Algorithm (DSA):**](https://en.wikipedia.org/wiki/Digital_Signature_Algorithm)

Sadece sign-verification amacıyla kullanılır. DSA güvenlik prensiplerini  [Discrete Logarithm](https://en.wikipedia.org/wiki/Discrete_logarithm)  prensiplerine dayandırır. İmzalamada hızlı ancak doğrulamada yavaştır çünkü doğrulama aşamasında SHA hashi çözme adımına bağımlıdır. DSA RSA’den farklı olarak doğrudan private keyden oluşturulan iki sayı ve hash aracılığıyla veriyi imzalar. Karşılık gelen public key ise bu imzayı doğrulayabilir. DSA random sayılara ihtiyaç duyan bir algoritmadır, güçlü bir randomizera ihtiyaç duymaktadır. Aksi taktirde oluşan trafikle birlikte private key tahmin edilebilir hale gelmektedir.

> Burada değinilmesi gerekliliğini hissettiğim bir nokta, DSA imzalamada hızlı doğrulamada yavaştır. RSA ise doğrulamada hızlı imzalamada yavaştır. Bu algoritmaların tercihlerini yaparken hangi cihazlarda bu işlemlerin gerçekleşeceğini iyi düşünmek gerekir, örneğin mobil bir cihazda gerçekleştirilecek doğrulamanın daha hızlı olması gerekir.

[**Elliptic Curve DSA(ECDSA):**](https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm)

[Elliptic Curve Cryptography(ECC)](https://en.wikipedia.org/wiki/Elliptic-curve_cryptography)  kullanan bir DSA örneğidir. ECC, Elliptic Curve Discrete Logarithm Problem (ECDLP) olarak bilinen bir problemin çözümü olan Elliptic Curves Theory’e dayanmaktadır, bu da kırılmasını çok zor bir ihtimale sürüklemektedir. DSA gibi iyi randomize edilmiş sayılara ihtiyaç duymaktadır. RSA ve DSA’dan daha efektif anahtarlara sahiptir, 256 bitlik bir ECC 3248 bitlik bir RSA anahtarına eşdeğerdir. En güncel örneklerden Bitcoin bu algoritmayı kullanmaktadır.

[**Diffie-Hellman(DH):**](https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange)

Diffie-Hellman anahtar değişiminde kullanılan bir yaklaşımdır. Bu yaklaşımda amaç public bir şifre aracılığıyla sadece iki kişinin bildiği anahtarı iki tarafa da ulaştırabilmektir. Örnek bir anahtar değişimine  [buradan](http://bilgisayarkavramlari.sadievrenseker.com/2008/03/20/diffie-hellman-ahahtar-degisimi-key-exchange/) ulaşabilirsiniz.

Sonraki yazımızda Hash kavramından ve örneklerinden bahsedeceğiz.

Yazılarımızın devamlılığını sağlayabilmemiz için lütfen yorumlarınızı iletmeyi unutmayınız. Ve bizi  [**LinkedIn**](http://linkedin.com/groups/13568839)  ve  [**Facebook’ta**](https://www.facebook.com/blockchainturknet/) takip edin, topluluğumuzun bir parçası olun.