---
title:  "Simetrik Şifreleme ve Blockchain"
date:   2017-12-27 12:04:23
categories: [blockchain, security]
tags: [dlt, encryption, şifreleme, simetrik, asimetrik, anahtarlama, distributed, legder, blockchain, bitcoin, block, blockchainturk, blockchainturk.net]
image: https://cdn-images-1.medium.com/max/150/1*kQJWhkNIuQ-kWnV1LGUm6w.jpeg
---

Bir şifreleme algoritması ortaya konduğunda whitepaperlarında matematiksel olarak ne kadar hızlı şekilde anahtar aracılığıyla şifrelenebilip şifresinin geri açılabildiğinin yanı sıra şifrenin kırılabilmesinin zorluğu da matematiksel fonksiyonlarla ifade edilir. Çünkü şifrelemede temel amaç hashlemenin tersine verinin eski haline döndürülebilmesidir. Simetrik ve asimetrik anahtarlama konuları oldukça matematiksel konular olmakla beraber biz bu derinliğe inmeyeceğiz. Konunun daha çok blockchain yaklaşımlarında nerelerde hangi amaçlarla kullanıldığı konularına değinmeye çalışacağız. Farklı blockchain örneklerinde farklı algoritmalar tercih edilse de tüm örneklerde temel amacın ağın güvenliğinin sağlanması olduğunu söyleyebiliriz.
![](https://miro.medium.com/max/800/1*kQJWhkNIuQ-kWnV1LGUm6w.jpeg)

Simetrik Şifreleme

# Simetrik Şifreleme

En basit haliyle bir verinin şifrelendiği anahtar tarafından çözülebildiği şifreleme yöntemi olarak tanımlayabiliriz. Örnek olması için okul yıllarımıza dönüp kırtasiyelerde satılan hatıra defterlerini kafamızda canlandırabiliriz. Bu hatıra defterleri iki anahtarla satılırdı, birbirinin aynısı olan bu iki anahtarın(public keys) birisinin sizde, diğerinin arkadaşınızda olduğunu düşünün. Defteri yazdıktan sonra bu anahtarla kilitlediğinizi(gerçekte anahtar olmadan kitleniyordu, burada gerçekle biraz örtüşmüyor), defteri alan arkadaşınızın da birebir aynı anahtar tarafından bu şifreyi açtığını düşünebilirsiniz. Bu şifreleme daha çok server-client trafiklerinde veya disk içeriğinin güvenliğe alınması gibi amaçlarla kullanılmaktadır. Birkaç farklı simetrik şifreleme algoritmasını özellikleriyle birlikte inceleyelim:

[**Data Encryption Standart (DES):**](https://en.wikipedia.org/wiki/Data_Encryption_Standard)

DES standartlaşmış bir encryption algoritmasıdır, zaman zaman Digital Encryption Algorithm (DEA) olarak da adlandırılmaktadır. IBM tarafından ortaya koyulmuştur ancak 56 bitlik anahtarlama yapısı sebebiyle artık güvenli olarak görülmemektedir. Bu sebeplerden  [Triple DES(3DES)](https://tr.wikipedia.org/wiki/%C3%9C%C3%A7l%C3%BC_DES) ismi verilen ard arda 3 kez 56 bitlik anahtarlama yapılmak suretiyle bu algoritma güvenlik açısından daha kabul edilebilir bir seviyede kullanılabilmektedir. DES bir blok anahtarlama ([block chiper](https://en.wikipedia.org/wiki/Block_cipher)) algoritmasıdır. Aşağıda örnek Java kodu bulunmaktadır repoya  [buradan](https://github.com/mehmetcemyucel/blog.git) erişilebilir.

[**International Data Encryption Algorithm (IDEA):**](https://en.wikipedia.org/wiki/International_Data_Encryption_Algorithm)

Patentli bir algoritmadır ancak ticari amaç harici ücretsiz olarak kullanılabilmektedir. Güvenli bir algoritma olarak tanımlanmaktadır, IDEA bir block chiper algoritmasıdır.

[**Advenced Encryption Standart (AES):**](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)

DES algoritmasının iyileştirilmiş versiyonu olarak tanımlanabilir, bir şifreleme standartıdır. NIST tarafından duyurulan ve Amerikan hükümeti tarafından kabul edilen bu defakto standart dikey olarak ölçeklenebilen bir şifreleme algoritmasıdır. Yani CPU artışı şifrelemenin hızını artırmaktadır. TrueCrypt ve SSH tarafından desteklenen bu algoritma farklı modlarda(GMC, CBC, ..) kullanılabilmektedir. Son olarak AES de bir block chiper algoritmasıdır. Aşağıda örnek Java kodu bulunmaktadır repoya  [buradan](https://github.com/mehmetcemyucel/blog.git) erişilebilir.

AES Encryption Decryption Example

[**Twofish:**](https://en.wikipedia.org/wiki/Twofish)

AES yarışmasının finalistlerinden birisi olan bu algoritma bir block chiper algoritmasıdır. 128, 192 veya 256 bitlik anahtarlarla şifrelemeye olanak tanıyan bu algoritma TrueCrypt ve SSH tarafından da desteklenmektedir. CPU artışıyla daha verimli çalışabilmektedir.

[**Serpent:**](https://en.wikipedia.org/wiki/Serpent_(cipher))

AES yarışmasının diğer bir finalisti olan bu algoritma ücretsiz patentle kullanılabilmektedir. TrueCrypt tarafından desteklenmektedir ve bir block chiper örneğidir.

[**Rivest Cipher 4(RC4):**](https://en.wikipedia.org/wiki/RC4)

RSADSI firmasının patentlemediği, kendisi için kullandığı bir şifreleme yöntemi olan RC4 bir süre sonra kaynak kodlarının piyasaya ifşa edilmesi ile birlikte duyuldu. Az biliniyor olmasına rağmen çok hızlı çalışan bir algoritmadır. Ancak pratikte kullanılması farklı standartlar ve kurumlar tarafından önerilmemektedir.(örn: TLS 1.1 üzeri,  [Cloudfare](http://blog.cloudflare.com/killing-rc4-the-long-goodbye/) ve  [Microsoft](http://blogs.technet.com/b/srd/archive/2013/11/12/security-advisory-2868725-recommendation-to-disable-rc4.aspx)) AncakSon zamanlarda block chiper algoritmalarda bulunan bazı sorunlar RC4 gibi  [stream chiper](https://en.wikipedia.org/wiki/Stream_cipher)  kullanan algoritmalara olan dikkati artırmaktadır.

[**Rivest Chiper 6(RC6):**](https://en.wikipedia.org/wiki/RC6)

RC4'ün aksine bir block chiper algoritmasıdır. Ancak yapısında RC2 ve RC4 ü de barındırmaktadır. RSA Security tarafından patentlidir. AES yarışmasının bir diğer finalistidir.

Sonraki yazımızda asimetrik şifreleme örneklerini inceleyeceğiz. Ayrıca hem simetrik hem asimetrik şifreleme algoritmalarının blockchain uygulamalarındaki aktif rolüne değineceğiz.

Yazılarımızın devamlılığını sağlayabilmemiz için lütfen yorumlarınızı iletmeyi unutmayınız. Ve bizi  [**LinkedIn**](http://linkedin.com/groups/13568839)  ve  [**Facebook’ta**](https://www.facebook.com/blockchainturknet/) takip edin, topluluğumuzun bir parçası olun.