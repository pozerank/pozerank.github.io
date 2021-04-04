---
title:  "JUnit - @Rule ve @ClassRule Annotationları"
date:   2019-03-03 15:04:23
categories: [java, test]
tags: [junit, classrule, rule, rulechain, dry, yagni, kiss, mockito, türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://cdn-images-1.medium.com/max/150/0*PI13arzqtcC-oXBh.jpg
---
Bugün birim test(unit test) ve entegrasyon testleri(integration test) yazıyorsanız hayatınıza renk katacağını inandığım bir konuyu kaleme alacağım. Junit4'te var olan ancak az bilinen @Rule ve @ClassRule annotationlarının ne olduklarını ve bunlarla neler yapabileceğimizi örneklerle incelemeye başlayalım.

## 1. Giriş

>"Tüm yazılım geliştiricilerin bilmesi gereken temel prensipler vardır, bunlara KISS, DRY, YAGNI, vb örnek verilebilir. Ama gözden kaçan bir nokta, bunların sadece business taşıyan kodlar için geçerli olduğu düşünülür. Ya test kodları? **Örneğin _Don’t Repeat Yourself_(DRY) gerçekten de test kodları için de önemli bir konu değil midir?**"

![](https://cdn-images-1.medium.com/max/800/0*PI13arzqtcC-oXBh.jpg)

Rule kavramını ilk duyduğunuzda aklınıza ne geldi? Muhtemelen kelime anlamından **testlerin hangi şartlar altında çalışacağının tanımlandığı kuralları barındıran bir yapı** olduğunu aklınızdan geçirmişsinizdir. Eğer öyle ise bingo, yaklaşımınız doğru!

Ama aklınıza muhtemel gelen başka soru işaretleri de vardır. Örneğin;

>"Ben zaten bu tarz ihtiyaçlarımı zaten @Before ve @BeforeClass annotationlarını kullanarak da karşılayabiliyordum, niçin böyle bir yapı mevcut?"

sorusu aklınızdan geçiyor olabilir. Veya

>"Ben zaten kurallarımı bir test metodumun içerisinde kurgulayarak zaten testimi kodluyorum, niçin metod dışına çekme ihtiyacım olsun ki?"

gibi sorulara sahipseniz doğru yoldayız. Öncelikle JUnit içerisindeki halihazırda tanımlı kuralları inceleyerek başlayıp, sonrasında custom rule’lar ile neler yapabileceğimizi inceleyeceğiz. Tekrar eden birçok ihtiyacı merkezi şekilde çözmenin yollarını göreceğiz. Eğer rule’suz hali mümkün ise nasıl yapılabileceğini de örnek olarak verip kazanımı gözlemlemeye çalışalım.

**NOT: Rule’unuzu @Rule annotation’ı ile metodlara, @ClassRule annotation’ı ile sınıflara bağlayabilirsiniz.**

## 2. Kurallar (Rules)

### 2.1. Timeout

Bildiğiniz gibi yazdığımız testlere maksimum çalışacakları süre mutlaka vermemiz gereken bir bilgi. Çünkü sadece çalışan testin veya test double’ının uzun sürmesi halinde bir şeyler yolunda gitmiyor olabilir, bu da atlanılmaması gereken bir konudur.

Ufak bir parantezle  [**Test Double**](https://martinfowler.com/bliki/TestDouble.html) kavramını biraz açalım. Genel bir kavram olmakla beraber gerçek ortamda çalışacak objelerimizin yerine geçecek tüm yapılandırmalarımızı kapsamaktadır. Adından da anlaşıldığı üzere iki parçadan oluşur:

-   **SUT** (System Under Test, yani test edilen kod parçası)
-   **DOC** (Dependend On Component, yani test edilen kod parçasının bağımlı olduğu kaynaklar)

Bu bilgiden sonra timeout ihtiyacını rule kullanmadan karşılamak istediğimizde aşağıdaki gibi tüm metodların annotationlarına bu bilgiyi vermemiz gerekli.

<script src="https://gist.github.com/mehmetcemyucel/942f9bbe8835c5f97a247467434ae0bb.js"></script>

Eğer yukarıdaki gibi her metodun üzerinde tek tek vermek istemiyorsanız ve sadece milisaniye cinsinden süre yönetmemeyi tercih ediyorsanız aşağıdaki şekilde bir kullanımla elinizi hafifletebilirsiniz.

<script src="https://gist.github.com/mehmetcemyucel/6c9f9fa59f9961c6dbb365641e2ace60.js"></script>

### 2.2. TemporaryFolder

Eğer file i/o testleriniz varsa geçici dosyalar yaratmanız, bunları test sonrasında temizlemeniz sizin için hayattan bezdirici olabilir. Özellikle de iç içe folderlara ihtiyacınız varsa işler çığrından çıkabilir. Buradaki tüm süreci kendiniz yönetecekseniz en basit haliyle muhtemelen şu şekilde bir kod yazmanız gerekli.

<script src="https://gist.github.com/mehmetcemyucel/4696c95e3921de093efacbb471fe21f4.js"></script>

Eğer bu süreçlerle hiç uğraşmayayım, hızlıca asıl odaklanmam gereken kodumu yazayım, işim bittiğinde de kendisi temizlensin derseniz TemporaryFolder ruleunu kullanabilirsiniz. Windows için folder AppData altında yaratılıp testler bitince siliniyor. Dilerseniz bu konumu rule’un initiation’ı esnasında constructor’a vererek konfigure edebilirsiniz.

<script src="https://gist.github.com/mehmetcemyucel/4696c95e3921de093efacbb471fe21f4.js"></script>

### 2.3. RuleChain

Her bir testinizi çevreleyen rulelar dizisi oluşturmak isterseniz RuleChain tam size göre! Kullanımını aşağıda görebilirsiniz. (bağımlı olunan LoggingRule sınıfına custom rule örneğinden erişebilirsiniz.)

<script src="https://gist.github.com/mehmetcemyucel/a0187cffacaf3a2ec447580ea4f6cb63.js"></script>

### 2.4 Watchman (TestWatcher)

Çalışan testlerinizin lifecycle’ındaki her bir statü durumunda aksiyonlar almanızı sağlayabilecek yetenekli bir rule. Testlerinizin çalışma durumunu raporlayabilir, adımları custom kodlarınızla zenginleştirebilirsiniz.

<script src="https://gist.github.com/mehmetcemyucel/c4b692786826d019cce0718eddf5e322.js"></script>

### 2.5. ExpectedException

Bir test metodunda exception senaryosunu test etmek istediğinizde birçok farklı yol mevcut. İyi bir opsiyon olmasa da try-catch bloğu ile kontrollerinizi yapabileceğiniz gibi AssertJ gibi kütüphaneler ile daha komplike exception kontrollerini kolayca yapabilirsiniz. Ancak bir kütüphane kullanmadığımızı varsayarsak en optimum exception kontrolü aşağıdakine benzer bir yapıda olacaktır.

<script src="https://gist.github.com/mehmetcemyucel/425230ee4b13048a97cf09cb1107740c.js"></script>

Yukarıdakine alternatif olarak bunu ExpectedException kuralı ile aşağıdaki şekilde yapabiliriz. Bu örnekte herhangi bir utility kullanmadan exception mesajlarını da test edebildik. Dilerseniz Hamcrast Matchers sınıflarını da expect metoduyla kullanabilirsiniz. Burada bir detay, exception alındıktan sonra metodun çalıştırılmasına devam edilmeyecektir. Bu sebeple aşağıdaki örnek metodların sonlarındaki fail satırları çalışmayacak, testler başarılı sonlanacaktır.

<script src="https://gist.github.com/mehmetcemyucel/cd353046d55a9a41af1aa7ac8823e321.js"></script>

### 2.6 TestName

Bu rule @TestRule rule’unun biraz özelleşmiş hali. Çalışmakta olan testin metodunun adını test çalışırken almanızı sağlıyor. Farklı kullanım alanları sizin hayal gücünüze kalmış.

<script src="https://gist.github.com/mehmetcemyucel/2b822beab375677d342b0b9410f0c1ff.js"></script>

### 2.7. Custom Rule - LoggingRule

Aslında hazır kurallar yukarıdakilerden ibaret değil, diğer Rule’lara [JUnit takımının wikisinden](https://github.com/junit-team/junit4/wiki/Rules) erişebilirsiniz. Farkındaysanız Rule’lar tekrarlayan ihtiyaçları test metodu veya test sınıfı seviyesinde izole etmek için güzel bir yöntem. Buradan itibaren birkaç tane kompleks kullanım senaryolarına örnek vereceğim.

Custom bir rule yazmak için ihtiyacımız TestRule interface’ini ve onun apply metodunu implement etmek. İhtiyaç duyduğunuz argümanları da constructor’dan toplayabilirsiniz. Testin state’ine ve açıklamasına ilişkin detaylar apply metodunun argümanları olarak elimize gelecek. Örneğin RuleChain örneğindeki loglama yapan bir rule gerçekleştirimi şu şekilde yapabiliriz.

<script src="https://gist.github.com/mehmetcemyucel/4932ee2ee8e715ac4a7441d4f9df23bb.js"></script>

### 2.8. Custom Rule - MockInitRule

Başka bir örnek olarak mocklarınızın initiation işlemini ortaklaştıran bir rule yazabilirsiniz. Örneğin bir servisiniz ve bu servisinizin bağımlı olduğu başka bir servisiniz olsun.

<script src="https://gist.github.com/mehmetcemyucel/400889a3cda42f94cf0e0878ea9978df.js"></script>

Bu servisi mocklayarak testi yapan sınıfımız da aşağıdaki gibi olsun.

<script src="https://gist.github.com/mehmetcemyucel/3a43c7622b9c1def2da6a46a1e2fadbf.js"></script>

Burada @Mock annotationı ile işaretlenen servisin instance’ının bağlanması için Mockito’nun bu sınıfta initiation’ı başlatması gerekli. Ayrıca sonrasında mocklanan servislerin davranışlarının tanımlanması da gerekir. Doğruyu söylemek gerekirse bu işlem birçok test sınıfında tekrarlanan bir işlemdir. Bunun için bir rule yazabilir, bu rule aracılığı ile mockların bağlanmasını sağlayabiliriz.

<script src="https://gist.github.com/mehmetcemyucel/175f4f3eb47f10e1d7402f843deccc15.js"></script>

Ayrıca tekrar kullanılabilir bir davranış seti oluşturmak istiyorsak da yukarıdaki MockInitRule sınıfını extend eden bir sınıf yazabiliriz. Constructorda davranış setini verdiğimiz taktirde artık tekrar tekrar kullanabileceğimiz bir mock setini hazırlamış oluruz.

<script src="https://gist.github.com/mehmetcemyucel/6eca28313c990ace0f165b4aab404c33.js"></script>

### 2.9. ExternalResource

Son örnek olarak **ExternalResource** kavramından bahsedelim. Örneğin testlerinizin öncesinde ayağa kaldırmanız gereken bir sunucu var, bir resource var. Bu resource sizin testleriniz kapsamında otomatize edebildiğiniz bir şey değil. İşte bu noktada ExternalResource ile bir rule tanımlayıp ihtiyaçlarınızı bu yol ile halledebilirsiniz. Örnek kodumuz;

<script src="https://gist.github.com/mehmetcemyucel/cfcc68da0871ced27de9ac8c6aabf608.js"></script>

Bunu kullanan testimiz;

<script src="https://gist.github.com/mehmetcemyucel/fac4cc94b1255cc49c8c703a05c76653.js"></script>

Ve son olarak çıktımız;

<script src="https://gist.github.com/mehmetcemyucel/7c7293d69147ea1161b16cff95edb06e.js"></script>

## 3. SONUÇ

Yukarıdaki örneklerde de anlattığımız gibi, @Rule ve @ClassRule annotationlarının geniş kullanım alanları mevcut. Tekrar kullanılabilir test yazmak, test sınırlarını genişletmek, yazılmış testlerin statelerini yakından takip edebilmek ve mevcut testlerle yapamadığımız dış kaynakların başlatılması ve sonlandırılması gibi alanlarda kullanılabileceği gibi tamamen custom rule’lar yazarak yapabileceklerimizin sınırlarını ortadan da kaldırabiliriz.


***En yalın haliyle***

[**Mehmet Cem Yücel**](https://www.mehmetcemyucel.com)

----------

**_Bu yazılar ilgilinizi çekebilir:_**     

 - [Bir Yazılımcının Bilmesi Gereken 15 Madde](https://www.mehmetcemyucel.com/2019/bir-yazilimcinin-bilmesi-gereken-15-madde/)
 - [Spring Boot Devtools ile Docker Üzerindeki Kodu Debug Etme ve Değiştirme](https://www.mehmetcemyucel.com/2019/spring-boot-devtools-ile-docker-uzerindeki-kodu-debug-etme-ve-degistirme/)
 - [_Spring Boot Rest Servis Entegrasyon Testi_](https://medium.com/mehmetcemyucel/spring-boot-rest-birim-entegrasyon-testi-43a7f9354a33)

**_Blockchain teknolojisi ile ilgileniyor iseniz bunlar da hoşunuza gidebilir:_** 

 - [BlockchainTurk.net yazıları](https://www.mehmetcemyucel.com/categories/#blockchain)

---
