---
title:  "Kullanıcı Şifrelerini Bu Şekilde Saklamayın"
date:   2023-07-10 12:00:00
categories: [mimari, security, tools]
tags: [encryption, hashing, digest, SHA-256, SHA512, MD5, güvenilir mi, rainbow tables, salt, salting, tuzlama, peppering, schema, vault, türkçe, mehmet cem yücel]
image: https://miro.medium.com/v2/resize:fit:150/1*51yiQNFp5KyP3ncI5-zVJA.jpeg
---


Son kullanıcı şifrelerinin güvenli bir şekilde saklanması önemli konulardan birisi. Bu noktada oluşacak bir sızıntı hem kullanıcılarımıza hem de regülasyonlara karşı kurumlarımızı zor duruma düşürebilir. Bu sebeple bugün hem mimari hem de yazılımsal açılardan yapılan bazı hataları ve best practice’lerini inceleyeceğiz.

-   Encryption / Hashing
-   Rainbow Tables / Salting & Peppering
-   Auth Schema Seperation
-   Work Factors
-   Vaults

![](https://miro.medium.com/v2/resize:fit:1400/1*51yiQNFp5KyP3ncI5-zVJA.jpeg)

## Encrypting Yerine Hash Fonksiyonu Kullanın

Hep duyduğunuz bir başlık ve yazımızı kalabalıklaştıracak olsa da halen örneklerini gördüğüm için değinmeden geçmeyeceğim.

Yöntemi ne olursa olsun bir değer ilk haline döndürülebilecek şekilde işleniyor ve saklanıyorsa o değer tekrar ilk haline çevrilebilir. Yani encrypt edilen bir değer decrypt edilebilir. Bunun farklı örneklerine ve yöntemlerine  [buradan](https://www.mehmetcemyucel.com/2017/simetrik-sifreleme-ve-blockchain/)  ve  [buradan](https://www.mehmetcemyucel.com/2017/asimetrik-sifreleme-ve-blockchain/)  detaylı şekilde ulaşabilirsiniz. Dolayısıyla plain haline dönüştürülebilen bir şifre her zaman güvenlik riskini barındırır.

Encryption yerine  [Hash Fonksiyonları](https://www.mehmetcemyucel.com/2017/hash-fonksiyonlari-ve-blockchain/)nı kullandığımızda şifre tekrar ilk haline döndürülemeyecek bir değere dönüştürülür(digest) ve bu haliyle saklanır. Kullanıcının şifresi sistemde doğrulanma ihtiyacı duyulduğunda kullanıcı şifresini girer, aynı yöntemle hashleme yapılarak sistemde kayıtlı hash ile karşılaştırılarak kontrol edilir. Eğer iki değer birbiriyle örtüşüyorsa doğrulama başarılı olur.

Buradan şöyle bir sonuç da otomatik olarak ortaya çıkıyor. Şifremi Unuttum gibi akışlarda artık kullanıcıya şifre hatırlatmak mümkün olmayacaktır. Bunun yerine yeni şifre girebilmesi için güvenli bir akış oluşturulmalıdır. Demek ki size gerçekten unuttuğunuz şifrenizi açık olarak geri dönen veya hatırlatabilen bir sistem kullanmak zorunda kalıyorsanız o sistem güvenli değildir ve kullanacağınız şifrenizi de buna göre belirleyin!

Secure Hash Algorithm 1 (SHA-1) ve MD5 collision problemi bulunduğu için güvensiz olarak tanımlanan hash algoritmaları. Bu algoritmalar yerine SHA-256, SHA-512 gibi algoritmaların kullanılması önerilebilir.

{% include feed-ici-yazi-2.html %}

## Hashleyerek Sakladık, Güvende Miyiz?

Peki şifrelerimizi hashleyerek sakladık, kendimizi artık güvende hissedebilir miyiz? Sorumuzun cevabı, evet daha iyi bir noktadayız ancak henüz güvenli hissetmemeliyiz.

Örneğin bir sızıntı yaşandı ve kullanıcı tablomuz attackerların eline geçti. Tablomuzda kullanıcıların sadece hashli digestleri bulunduğundan ve bu değerler geri çevrilemediğinden dolayı kendimizi güvende hissedebiliriz. Ancak üzerinde düşünmemiz gereken başka noktalar var.

Farkındaysanız hashing her input için tekil bir digest oluşturma mantığına dayanıyor. Buradan şu sonuç çıkabilir, en sık kullanılan şifre kombinasyonlarını(dictionary) bir hashing algoritmasından geçirerek bir tablo(Rainbow Tables) üretebilirim. Bu tablonun ilk kolonunda sık kullanılan bir şifrenin açık halini, diğer kolonunda da digesti saklarsam ve sızdığım sistemdeki hashleri bu tablodaki digestlar içerisinde bulabilirsem şifrenin açık halini de bilebilirim.

Örnek olması için aşağıdaki siteden “password” içerikli şifremi md5 ile hashletiyorum.

![](https://miro.medium.com/v2/resize:fit:1400/1*dTTRSPjzB4hVhjEMHo3ySw.png)

İnternet üzerinde her gün büyümeye devam eden çok büyük rainbow tablelar mevcut. Farklı algoritmalar, farklı input karakter setleri için TB’larca veriyi arayıp verilen hashin ilk halini bulmak çok zor değil. Yukarıdaki oluşan MD5 hashi kopyalayıp bu tür bir sitede arattığımda oluşan sonuca bakalım.

![](https://miro.medium.com/v2/resize:fit:1400/1*T5hcNMteeBx1OHrenojhjg.png)

Bu sebeple bu hashlerin üzerinde biraz daha fazla düşünmeye ihtiyacımız var.

## Salting & Peppering

Salting mantığı, kullanıcının şifresini hashlemeden önce başına random bir karakter setinin eklenmesi mantığından geliyor. Hemen yine örnekten bakalım.

![](https://miro.medium.com/v2/resize:fit:1400/1*KOXt01QtM8MnrV-BSsQ7Zw.png)

Bu kez passwordü hashlemeden önce random bir seti passwordün başına ekleyerek hash değerini oluşturdum. Oluşan hashi rainbow tableda aratalım.

![](https://miro.medium.com/v2/resize:fit:1400/1*u3hgN_eMuDbGUv0HxYl56Q.png)

Farkındaysanız bu kez hashimiz bulunamadı. Çünkü salt+password kombinasyonu çok da karşılaşılan bir kombinasyon değil ve benim denediğim sitedeki table’da bir karşılığı olmadığından açık hali bulunamadı. Ancak bu daha geniş rainbow tablelarda bulunmayacağı anlamına gelmeyecektir. Genellikle bu tarz devasa tablolar ücretli ve/veya daha az kişinin kullanımına açık olacaktır. Ayrıca password ile salt iç içe olduğundan sadece padding yapılmadan bir algoritma ile salt ile passwordün iç içe girdiği bir kombinasyon da yaratabiliriz. Örneğin passwordün her karakterinden sonra random bir karakter ekleyerek saltu karakter seviyesinde iç içe geçirebiliriz.

Kafanızda şu soru oluşmuş olabilir, peki salt nerede saklanacak? User tablosundaki hash’inizin yanında bir kolon açarak açık olarak saklamanızda bir sakınca yok. Çünkü bir attacker ın saltu ve hashi bilmesi şifrenin açık haline erişebilmek için yeterli değil.

Yine de eşeği daha da sağlam kazığa bağlayalım derseniz, passwordün sonuna aynı saltlamada olduğu gibi bir değer daha ekler ve bu değeri de db yerine farklı bir persistency unitte saklamayı tercih ederseniz(file system, object storage vb) bu da peppering olarak isimlendiriliyor.

{% include feed-ici-yazi-1.html %}

## Auth Schema Ayırma

Güvenlik konusu her zaman katman katman ele alınır. Bir sistemdeki kullanıcıların salting/peppering’den geçmiş güvenli bir algoritma tarafından yaratılmış hashli credentiallarının açığa çıkması kurum açısından bir prestij kaybı yaratsa da attackerların sisteme o kullanıcılar gibi giriş yapıp onların hesaplarından işlem gerçekleştirmeleri gibi kaotik problemlerle kıyaslandığında çok daha hafif sayılabilecek bir durumdur. Bir katman ele geçirilse de sonraki daha kritik katmanlar bir şekilde güvende kalacaktır.

Benzer şekilde bir sistemin dışarıdan en saldırıya açık endpointleri auth kontrolünün yapıldığı ilk doğrulama servisleridir. Çünkü tokenization ile korunduğunu varsaydığımız bir sistemde fonksiyonel servislere erişim kimlik doğrulamasından geçirilerek kazanılan bir token sayesinde güvenlik altına alınabilir. Ancak token veren servisin güvenliği nasıl sağlanacak? Örneğin sql injectiona açık bir login servisinde attacker injection ile credential kontrolünü bypass edip doğrudan db seviyesinde tablolara erişim sağlayabilir. Böyle bir durumda attackerın yapacağı ilk hamle erişebildiği kadar functional veriye erişip, bunlardan kendisine çıkar sağlamak olabilir. Sonrasında da insafına bağlı olarak sessizce izini sistemden silerek ortadan kaybolabilir veya daha da kötüsü erişimi dahilindeki tüm verileri silerek sistemi cevapsız hale düşürebilir. Disk dumplarının ne kadar sağlıklı alındığına, dumptan dönme süresine, consistencynin tekrar sağlanması, oluşan veri kaybının tolerasyonuna bağlı olarak bu sistem kesintisi günleri bulabilir.

İşte bu gibi senaryoların riskini minimize etmek için kritik sistemlerdeki Auth tablolarını sistemin fonksiyonel gereksinimlerini karşılayan db schemasından izole etmek ve ayrı bir schemada konumlandırmak iyi bir tercihtir. Güvenlik sebeplerinin yanı sıra operasyonel yönetim ihtiyaçlarında da erişimi kısıtlı ve izole tutmak faydalı olacaktır.

## Work Factors

Farkettiyseniz güvenlik kavramı attackerın gözüyle bakıldığında sürekli bir şeyleri daha da zorlaştırmak ve ihtimalleri düşürmek üzerine kurulu. Hiçbir sistem %100 güvenli değildir ancak yapacağınız basit bir hamle ile attackera günler, haftalar kaybettirebilirsiniz. Bu gibi durumlarda da genellikle attackerlar başka sistemlere gözünü kaydırmaya başlayacaktır.

Work Factors de benzer bir amaca hizmet ediyor. Bir passwordü hashlediğinizde ortaya çıkan sonucu kullanmak yerine bu çıktıyı tekrar input yapıp n kez bu döngüyü tekrarlamanız faktörü artıran bir unsur olacaktır. Hatta bu yöntemi algoritmasının temel parçası haline getiren hashing algoritmaları da hali hazırda bulunuyor(PBKDF2 vb).

Buradaki temel mantık, hashlemenin daha uzun sürmesi bu tarz bir algoritmanın kullanıldığı rainbow table ların hızlı ve kolayca büyüyememesini sağlayacaktır. Dolayısıyla oluşan hashlerin açık halinin bulunması zorlaşacaktır.

Dikkat edilmesi gereken bir nokta, hashlemenin bir zaman & cpu maliyeti var ve operasyonu aksatmayacak şekilde konfigürasyon tercihlerinin yapılması önemli. Örneğin Django default iterasyon sayısı olarak 30.000 kullanıyor. Attackerların işini zorlaştırmak için katlanılan maliyetler operasyonel çalışmamızı sekteye uğratmamalıdır.

{% include feed-ici-yazi-1.html %}

## Vaultlar

Son olarak, vaultlar apayrı bir yazının konusu olabilecek kadar geniş bir konu olsa da kısaca bahsetmekte yarar bulunuyor. Vaultlar identity ve access management için uçtan uca düşünülmüş bağımsız çözümlerdir. İşinizin doğası bu tarz bir ürünle çalışmaya uygun ise kullanıcı yönetimini uygulamanızdan bağımsız ayrı bir noktada yönetmek birçok açıdan avantaj sağlayabilir. Vaultlar sadece password için değil sertifikalar, güvenliği kritik dosyalar, API anahtarları, db şifreleri gibi daha geniş kullanım alanlarına sahiptir. Farklı senaryolar kurgulayabilirsiniz, örneğin bir vault u unseal edebilmek için 3 farklı kişinin passwordü sırayla girilirse vault açılır vb gibi.

Güvenlik sadece yazılımda değil mimaride de dikkatli değerlendirilmesi gereklidir. Örneğin networkte açık olarak taşınan bir credential risk teşkil edebilir. Veya uygulamanın memorysinde açık olarak bulunan bir password anlık alınan bir dump ile attacker tarafından elde edilebilir. Bu sebeplerle hassas bilgilerin uçtan uca gizli olarak kullanılması/tüketilmesi gerekir. Vaultlar sorumluluğu tam olarak bu gibi konular olan uygulamalar olduklarından bu detaylar noktaları da kapsayacak şekilde geliştirilmişlerdir. Daha detaylı incelemek için birkaç vault örneği;

-   [https://www.vaultproject.io/](https://www.vaultproject.io/)
-   [https://www.cyberark.com/](https://www.cyberark.com/)
-   [https://www.beyondtrust.com/](https://www.beyondtrust.com/)

## Sonuç

Yazıda bahsettiğimiz başlıklara dikkat etmek birçok açıdan uygulamalarımızı daha güvenilir hale getirecektir. Ancak her gün yeni güvenlik açıkları ortaya çıktığı için  [OWASP](https://owasp.org/)  web sitesini takip etmeyi unutmayın.
