---
title:  "Merkle Root Merkle Kök Ağacı"
date:   2017-12-28 12:04:23
categories: [blockchain]
tags: [dlt, merkle, root, kök, ağacı, distributed, legder, blockchain, bitcoin, utxo, block, blockchainturk, blockchainturk.net]
image: https://cdn-images-1.medium.com/max/150/0*JKeTzfaJAjzXq_Lq.PNG
---


Blockchain teknolojileri ile birlikte Decentrealize Web (merkezi bir yapıya bağlı olmayan web) konseptlerini çok daha sık duymaya başladığımız bu günlerde akıllarda soru işareti haline gelen bir diğer konu bunun güvenliğinin nasıl sağlandığı konusu.. Nasıl oluyor da onlarca bilgisayarın olduğu bir networkte çalışmakta olan sistem manipule edilemiyor, nasıl oluyor da bütün bilgisayarda bir şekilde ortak fikir birliğinde sanki tek bir vücut gibi çalışıyor? Bugün bu soruların bir kısmının cevabını arayacağız.

![](https://miro.medium.com/max/704/0*JKeTzfaJAjzXq_Lq.PNG)

Yukarıda  [blockchain.info](http://blockchain.info/)  sitesinden ben bu yazıyı yazarken son dağıtılan block’un ekran görüntüsünü görüyorsunuz. Sağ alt köşede yer alan Merkle Root, Merkle Kök Ağacı olarak Türkçe’leştirebileceğimiz konumuz ile bir veri bloğuna konu olan transactionlarin değişmezliğinin nasıl garanti altına alındığını açıklamaya çalışacağız.

# Merkezi Veri Paylaşım Modeli

Klasik web yaklaşımında kişiler verilerini, dosyalarını paylaşmak için merkezi sunucular kullanırlar. Ama problem şudur, bu verileri paylaşacakları sunucuları yoktur. Çözüm olarak sunucuları genellikle hosting firmalarından kiralarlar. Bu sunuculara yüklenen veriler artık kullanıma hazırdır.

![](https://miro.medium.com/max/352/0*oYEdX5EKknN7U1ES.PNG)

Örnek olarak fotoğraflarınızı internete yüklemek istediğinizi varsayalım. Fotoğraflarınızı Microsoft’un One Drive servisine yüklediğinizi düşünün, örneğin  [**www.onedrive.com/userY/foto1.jpg**](http://www.onedrive.com/userY/foto1.jpg)  gibi bir adrese sahip oldunuz. Yarın bunun yerine fotoğraflarınızı yüklemek için Google’ın Drive servislerini kullanmaya karar verirseniz yaşanacak olan eski adresiniz yerine  [**www.googledrive.com/userX/foto1.jpg**](http://www.googledrive.com/userX/foto1.jpg)  gibi bir adresiniz olacak.

![](https://miro.medium.com/max/704/0*f6QUCMUjz3tzVV4N.PNG)

Buradaki problemimiz adreslemenin sadece içeriğin kendisinden yaratılmamasından kaynaklanıyor. Merkezi bir yapı kullanıldığında merkez için seçilen yapıda yaşanan değişikliğin o merkezi kullanan herkeste yarattığı efekt olarak karşımıza çıkıyor.

# Hash Kavramı

İçeriğin kendisinden adreslemenin yaratılması kavramını biraz açalım. Ama önce #Hash kavramını açıklamamız lazım. Hash fonksiyonları kabaca, farklı büyüklüklerdeki veri kümelerinin sabit uzunlukta bir veri kümelerine adresleyen algoritmalara verilen addır. Yani elinizde bir fotoğrafınız var ve siz hash fonksiyonundan geçirdiğinizde o fotoğrafı tanımlayan ve her defasında aynı uzunlukta oluşan bir text(hash) ile o fotoğrafı tekil olarak tanımlarsınız. Aynı veriyi ne zaman hash fonksiyonundan geçirirseniz geçirin her defasında aynı hash üreyecektir.

![](https://miro.medium.com/max/704/0*5_9P5ee4oEFV8VCt.PNG)

Peki bu hash konusunun bizim farklı sunuculara yüklediğimiz veri problemiyle ne alakası var? Bir hash bir veriyi tekil olarak nitelendirebiliyorsa benzer şekilde dağıtık mimaride bir adres de bir veriyi tekil olarak nitelendirebilir. Böyle bir mimaride verimin OneDrive’da veya GoogleDrive’da olmasının o dosyayı tanımlamada bir önemi kalmayacaktır çünkü dosya için tekil bir id generate edilecektir.

# P2P Networkler

Bu şekilde bir mimariyi kurmak için P2P (Peer to Peer) networklerle örneğimize devam edelim. Kullanıcıların veriyi merkezi bir otorite olmaksızın paylaşabildiği bir ortamda paylaşılacak verinin aynı hash kavramında olduğu gibi herkese tekil bir şekilde ifade edilebilmesi ve adreslenebilmesi gerekir. Bu hashler aracılığıyla ancak peerlar birbirlerinden istedikleri veriyi ifade edebilir, bu veriye sahip olan peerlar birbirlerine bu veriyi paylaşabilir olacaktır.

![](https://miro.medium.com/max/452/0*D-YurxgsD2OlT3Ry.PNG)

Artık birbirleri ile veri paylaşabilen merkezi olmayan bir veri paylaşım ağımız mevcut ancak bir problemimiz daha var. Bu ağ public erişime açık bir ağ ve  **foto1.jpg** ağdaki başka birisi tarafından aynı tekil tanımlayıcıyla başka bir fotoğraf içeriği ile ağa dağıtılmaya çalışılırsa ne olur? Veya başka bir örnek, bu ağda mp3 paylaşıldığını varsayın, çok sevdiğiniz bir şarkıyı almaya çalışıyorsunuz ama aynı tekil tanımlayıcı ve dosya adı kullanılmasına rağmen bir peerdan bu veriyi aldığınızda başka bir şarkı, başka bir peerdan bu dosyayı aldığınızda bambaşka bir şarkı size gelebilir. Bu tutarsızlık ve manipulasyon açısından büyük bir problemdir, burada tekil olarak tanımlanan adreslerin bir başkası tarafından değiştirilmediğinin ve herkes tarafından aynı tekil adresin kullanılacağından yine herkesin emin olabilmesi gerekir. Ve bir veriyi alan kişi bu veride bir değişiklik yapılmadığından emin olmak için bunun validasyonunu yapabilmesi gerekir.

# Merkle Tree, Merkle Root

Merkle Root tam bu noktada karşımıza çıkıyor. Merkle Tree binary bir ağaç yapısıdır, Merkle Root da bu ağaç yapısının kök düğümüdür. Bu ağaç yapısı sizin ufak parçalar halindeki verinizin sıralı olarak hashlerini tutar. Örneğin bir mp3ünüz 4 farklı parçaya ayrılıp, her bir parçanın ayrı ayrı hashlendiğini düşünün.

![](https://miro.medium.com/max/704/0*i4k8IdPKnNt5VQCu.PNG)

Burada oluşan her bir parça veri hash fonksiyonundan geçerek kendi hashlerini oluşturur. Artık ağaç veri yapısında Merkle Tree yaprakları(leaf) buradaki her bir iki parçanın hashlerinin birleştirilmesinden oluşan text’i tekrardan hash fonksiyonuna sokarak kendi hashlerini elde ederler. Bu her iki leaf’i de yeni bir node aynı şekilde birleştirerek bu döngü root node’a erişinceye kadar devam eder. Aşağıdaki görselde örneğini görebilirsiniz.

![](https://miro.medium.com/max/704/0*OsV6p9CZM5Tr1v2Y.PNG)

Bu ağaç yapısı şu işe yarar, eğer siz mp3ün 2. parçasını değiştirmeye çalışırsanız buradaki parçanın hash değeri başka bir değer olacaktır. A leaf’i de 1. ve 2. parçaların hashlerinden oluşan bir hashe sahip olduğundan dolayı bambaşka bir hash oluşacaktır, bu döngü en tepedeki R düğümüne kadar ulaşacaktır. Özetle mp3ün herhangi bir parçasında değişiklik gerçekleştiği takdirde R düğümü bambaşka bir hash koduna sahip olacaktır ve bu sebeple orjinal dosyanın Merkle Root hashinden farklı bir hash üreyecektir. Orjinal dosyanın Merkle Treesi ile rootdan leaflere doğru karşılaştırma yapılarak değişiklik yapılan veri adreslenebilir olur.

İşte bu şekilde verinin değiştirilmemesi garanti altına alınır ve popüler olan Blockchain uygulamalarında da bu yapı kullanılmaktadır.

Yazılarımızın devamlılığını sağlayabilmemiz için lütfen yorumlarınızı iletmeyi unutmayınız. Ve bizi  [**LinkedIn**](http://linkedin.com/groups/13568839)  ve  [**Facebook’ta**](https://www.facebook.com/blockchainturknet/) takip edin, topluluğumuzun bir parçası olun.