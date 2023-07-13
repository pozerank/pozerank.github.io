---
title:  "Java ile Örnek Proof of Work Gerçekleştirimi ve Mining"
date:   2018-01-02 12:04:23
categories: [blockchain, java]
tags: [proof of work, örnek, nedir, distributed, legder, blockchain, bitcoin, block, blockchainturk, blockchainturk.net]
image: https://cdn-images-1.medium.com/max/150/1*16MNLKRn_jkLv8xBEA6oIw.png
---

Bugün Bitcoin’in temelinde yatan Proof of Work yaklaşımını inceleyip basit bir block sınıfı gerçekleştirimini Java’da inceleyeceğiz. Bu yazımızdaki amacımız herşeyiyle birebir aynı bir gerçekleştirim yapmaktan çok valid bir hashin nasıl oluşturulduğu, bu işlemin zorluğu ve bütün proof of mekanizmasının çözülmesi zor bir probleme dayandırıldığını gösterebilmektir.

![](https://miro.medium.com/max/1073/1*16MNLKRn_jkLv8xBEA6oIw.png)

Hash fonksiyonlarını  [buradaki](https://medium.com/blockchainturk/hash-fonksiyonlar%C4%B1-ve-blockchain-59da61356e9) yazımızda incelemiştik. Bu fonksiyonlar bizim için bugün önemli olacak. Çünkü bütün mesele defalarca hash code üretmekten geçiyor desek yalan olmaz. Bu sebeple öncelikle hash fonksiyonlarını anlattığımız yazıyı okumadıysanız okumanızı tavsiye ederim. Eğer okuduysanız hadi başlayalım.

En basit haliyle bir blockta aşağıdaki bilgiler bulunur. İlk haliyle şu şekilde bir sınıfımız olacaktır.

-   **Index**, blockun numarası
-   **Timestamp**,  block yaratıldığı an bilgisi
-   **Previous Hash,** önceki blockun hash bilgisi
-   **Transactions (Data),** blockun içerisinde taşınmak istenen veri
-   **Hash,** blockun kendi hash verisi
-   **Nonce,**  ardışık olarak artacak bir değişken

Bazı tipleri özellikle daha kolay anlaşılabilmesi için String olarak bırakmayı yeğledim. Burada önemli nokta, blockumuzun  **immutable** olmasının sağlanmasıdır. Immutable kavramı özetle bir kez oluşturulan objemizin bir daha değiştirilememesinin garanti altına alınmasıdır. Değişkenlerimizi biraz daha yakından tanıyacak olursak  **index** o blockun kaçıncı block olduğunun göstergesidir. İlk block diğer blocklardan biraz daha farklı bir özelliğe sahiptir, kendisinden önce bir block olmaduğı için previousHash bilgisi alabildiğine 0'dır ve kendisine  **genesis block** ismi verilmektedir.

Diğer bir önemli alan  **previousHash** değişkenidir. Hash değişkeni hariç bu değişkenlerin tamamı blockun kendi hashinin hesaplanmasında kullanılmaktadır. Bu durum beraberinde şu şekilde bir sonuç doğurmaktadır, eğer previousHash değeri değişirse yeni blockun hash değeri de değişecektir. Yani herhangi bir blockun içerisinde yapılacak bir değişiklik o blockun hashini değiştirecek, bir blockun hashi değişince de kendisinden hemen sonra gelen blockun hashine etki edecektir. Yani zincir o iki block için doğrulanamaz durumda olacaktır, özetle zincir kırılacaktır.

Bu anlattığımızı kodumuz üzerinde örnekleyerek daha iyi anlayalım. Örneğin Bitcoin’de  **double SHA-256**  hashlemesi yapılmaktadır, yani iki kere SHA-256 algoritmasıyla block hashlenmektedir. Biz olayı daha karışık hale getirmemek için tek SHA-256 ile örnekleyeceğiz. Bunun için de  [Apache Commons Codec](http://commons.apache.org/proper/commons-codec/)  kütüphanesinden faydalanacağız. Şu şekilde bir metod ile SHA-256 hashlememizi gerçekleştiriyoruz.

Bu metodumuz bize ihtiyaç duyduğumuz hash’i üretecek. Ancak herhangi bir hash üretmesi bizim için yeterli değil, hashimizin spesifik bir özelliğe sahip olması gerekiyor. Güvenlik değeri denilen bir değer burada devreye giriyor. Güvenlik değeri şunu ifade eder, oluşan hashin başında bu değer adedince 0 olması beklenmektedir. Bizim örneğimiz için 4 olduğunu varsayalım. Oluşan hash 0000Zafcb2.. gibisinden bir değer olduğu sürece bizim için valid bir hash olacaktır. Hatırlarsanız  [buradaki hash fonksiyonları ile ilgili yazımızda](https://medium.com/blockchainturk/hash-fonksiyonlar%C4%B1-ve-blockchain-59da61356e9)  bir hash fonksiyonuna girdilerimiz değişmediği suretçe hashimizin değişmeyeceğinden bahsetmiştik. Bu sebeple  **nonce** değerimizi her defasında 1 artırarak aradığımız özelliklerde bir hash üretilmesini sağlamaya çalışıyoruz. Son durumda kodumuz aşağıdaki gibi,

Bu kodumuzu bir jUnit testiyle test ettiğimizde aşağıdaki gibi bir görüntü oluşuyor.

![](https://miro.medium.com/max/800/1*Ok806xuJvLrFwq0gUaincQ.png)

block testi katsayı 4

Ekran görüntüsünde de görüldüğü gibi blockumuz için valid bir hash oluşturmak için tam  **223.009**  kez deneme yapmamız gerekmiş ve anca bu kadar deneme sonunda başında 0000 ile başlayan bir hash kod üretebilmişiz. Bu işleme gündelik hayatta sıkça duymaya alıştığımız  **mining** ismi veriliyor. Şimdi bu güvenilirlik katsayısını 5 yaparak tekrar deneyelim.

![](https://miro.medium.com/max/800/1*Tr_GtjIRR4AjpP9tI29oHg.png)

block testi katsayı 5

Bu kez  **2.042.861**  kez deneme yapması gerekti. Yaklaşık 9 katı sayılabilecek kez daha fazla deneme ile denk geldi. Son bir kez bu katsayıyı 6 yaparak denediğimizde de

![](https://miro.medium.com/max/800/1*RCYQR3LKCyF1naPG3FfUyA.png)

bu kez  **8.142.875**  denemede ancak valid bir hash oluşturmayı başardık. Buradaki varmaya çalıştığımız nokta, güvenilirlik katsayısı ne kadar büyürse bu hashi elde etmemizin kat ve kat daha da zorlaşacağı. Akıllara gelen bir diğer soru ise bu güvenilirlik katsayısının kaç olacağının nasıl belirlendiği. Örnek olarak Bitcoin’den devam etmek gerekirse, o ana kadar oluşturulmuş block sayısı ile orantılı artan bir algoritma bir sonraki block için güvenilirlik katsayısının kaç 0 ile başlayacağını belirliyor. Bu yazı yazılırken dağıtılan en son  [block](https://blockchain.info/tr/block/0000000000000000008fb0076e72a93d532c259956490a1bf493dc0abd265205) 18 adet 0 ile başlıyordu ve nonce değeri 1.547.561.758 idi.

İşte valid bir hashi oluşturmak bu kadar zor. Ve her geçen gün de daha da zorlaşıyor. Ancak oluşturulmuş bir hashi doğrulamak da herhangi bir başka peer için bir o kadar kolay, çünkü defalarca denemeyle bulunmuş nonce değerini blockun oluşturulmasında kullanılmış diğer tüm değerlerle hash fonksiyonuna soktuğunuzda başında n adet 0 olan bir hash elde edebiliyorsanız o blockun valid olduğu yorumunu yapabilir durumda oluyorsunuz. Özetle kafanızdan salladığınız bir değerle valid bir block üretemiyorsunuz. Üretilmiş son block sizin bir parçanız oluyor ve sizin hashiniz de sizden sonraki blockun hashinin bir parçası olmak zorunda. İşte blockchain yani blok zinciri de adını tam olarak buradan alıyor.

İlgili kodlara  [github](https://github.com/mehmetcemyucel/blog.git)  üzerinden erişebilirsiniz.

Yazılarımızın devamlılığını sağlayabilmemiz için lütfen yorumlarınızı iletmeyi unutmayınız. Ve bizi  [**LinkedIn**](http://linkedin.com/groups/13568839)  ve  [**Facebook’ta**](https://www.facebook.com/blockchainturknet/) takip edin, topluluğumuzun bir parçası olun.