---
title:  "Bir Yazılımcının Bilmesi Gereken 15 Madde"
date:   2019-02-18 14:04:23
categories: [java, microservices, cloud, mimari, ide, jpa, hardware, c#, tools, design patterns, ]
tags: [yazılımcının, bilmesi, gerekenler, nelerdir, Cloud, Microservice, Mikroservis, Nedir, Türkçe, Örnek, example, Java, Nasıl, Codebase, 12 Faktör, Mehmet Cem Yücel, Mehmet, Cem, Yücel, Yucel, maven]
image: https://cdn-images-1.medium.com/max/150/1*8uAU58KQ17hL28KJhTA1dA.jpeg
---

[Twitter'daki paylaştığım bir flood'u](https://twitter.com/mehmetcemyucel/status/1096710637458214916) rica üzerine bloguma da ekliyorum. İyi okumalar...


-----
Bir yazılım geliştiricinin bilmesi gerekenlerle ilgili 15 maddelik flood geliyor.. Mümkün olduğunca fazla keywordü bir araya toplamaya çalıştım.  
Hadi Başlıyoruz!  

![](https://cdn-images-1.medium.com/max/800/1*8uAU58KQ17hL28KJhTA1dA.jpeg)
  
[#Developer](https://twitter.com/search?q=%23Developer "#Developer") [#Software](https://twitter.com/search?q=%23Software "#Software") [#Java](https://twitter.com/search?q=%23Java "#Java") [#code](https://twitter.com/search?q=%23code "#code") [#kod](https://twitter.com/search?q=%23kod "#kod") [#yazılım](https://twitter.com/search?q=%23yazılım "#yazılım") [#development](https://twitter.com/search?q=%23development "#development") [#computer](https://twitter.com/search?q=%23computer "#computer") [#bilgisayar](https://twitter.com/search?q=%23bilgisayar "#bilgisayar") [#tool](https://twitter.com/search?q=%23tool "#tool") [#PC](https://twitter.com/search?q=%23PC "#PC") [#IT](https://twitter.com/search?q=%23IT "#IT") [#web](https://twitter.com/search?q=%23web "#web") [#tech](https://twitter.com/search?q=%23tech "#tech") [#data](https://twitter.com/search?q=%23data "#data")

## 1-Temel veri yapıları (linkedList, map, tree vb) ve temel algoritmalar (sıralama, arama vb)  
  
Sıfırdan kodlama ihtiyacınız büyük ihtimalle hiç olmayacak. Ancak ihtiyaç anında doğru yerde doğrusunu seçebilmek için o veri yapısının veya algoritmanın nasıl çalıştığını bilmeniz şart

## 2- Network Temelleri  
  
OSI Modelini ve 7 katmanı; temel protokolleri([#TCP](https://twitter.com/search?q=%23TCP "#TCP")-IP, TCP-UDP, [#HTTP](https://twitter.com/search?q=%23HTTP "#HTTP"), [#FTP](https://twitter.com/search?q=%23FTP "#FTP")), güvenlik protokollerini([#HTTPS](https://twitter.com/search?q=%23HTTPS "#HTTPS"), [#SFTP](https://twitter.com/search?q=%23SFTP "#SFTP"), [#SSL](https://twitter.com/search?q=%23SSL "#SSL")), monitoring protokolleri([#SNMP](https://twitter.com/search?q=%23SNMP "#SNMP"), ICMP) bilmekte fayda var. Ayrıca ağ ekipmanlarının görevlerini tanımak ve 7Layer yerlerini bilmek lazım

## 3- Source Control Toolları  
  
Birçok farklı tool var; [#Clearcase](https://twitter.com/search?q=%23Clearcase "#Clearcase"), [#SVN](https://twitter.com/search?q=%23SVN "#SVN"), [#Git](https://twitter.com/search?q=%23Git "#Git"), [#CVS](https://twitter.com/search?q=%23CVS "#CVS")... En azından 1 tanesine hakimiyet yüksek olmalı. Yeteneklerine ve trendlere bakılırsa bu tartışmasız [#Git](https://twitter.com/search?q=%23Git "#Git") olmalı

## 4- SQL  ve RDBMS  
  
Veri saklamak için çok alternatif var. Ancak RDBMS'ler halen en yoğun kullanılanılanları. Bu nedenle [#OLAP](https://twitter.com/search?q=%23OLAP "#OLAP"), [#OLTP](https://twitter.com/search?q=%23OLTP "#OLTP"); tasarım prensiperi([#Normalization](https://twitter.com/search?q=%23Normalization "#Normalization"), [#BCNF](https://twitter.com/search?q=%23BCNF "#BCNF")); SQL ve bir [#ORM](https://twitter.com/search?q=%23ORM "#ORM") toolunu bilmekte fayda var. Sonrasında [#NoSQL](https://twitter.com/search?q=%23NoSQL "#NoSQL") dünyasına yelken açılmalı

## 5- Algorithm Complexity Analysis  
  
Big-o notation'ı bilmek lazım. Böylece kurguladığımız algoritmanın bize dönüşünü bilebiliriz. Hatta sadece [#CPU](https://twitter.com/search?q=%23CPU "#CPU") optimizasyonu da değil; [#memory](https://twitter.com/search?q=%23memory "#memory"), disk, CPU ihtiyaçlarına göre aynı problemin farklı çözümleri üzerine düşünmeye alışmak da önemli.

## 6- Gof Design Patterns  
  
Bu madde herkesten duymaya alıştığınız bir madde olduğundan yazıp yazmamak arasında gidip kaldım. Ancak eksik bırakmaya gönlüm el vermedi. [#OOP](https://twitter.com/search?q=%23OOP "#OOP")'yi zaten bildiğinizi varsayıp bunu Gang of Four Design Patterns ile taçlandırmanızı şiddetle öneriyorum.

## 7- Software Design Principles  
  
En az design patterns kadar önemli ama bir o kadar atlanılan kavramlar. [#SOLID](https://twitter.com/search?q=%23SOLID "#SOLID"), [#KISS](https://twitter.com/search?q=%23KISS "#KISS"), [#DRY](https://twitter.com/search?q=%23DRY "#DRY"), [#YAGNI](https://twitter.com/search?q=%23YAGNI "#YAGNI") ve [#TDD](https://twitter.com/search?q=%23TDD "#TDD")'yi hayat tarzı yapmak lazım.  
  
[#DesignPrinciples](https://twitter.com/search?q=%23DesignPrinciples "#DesignPrinciples")

## 8- Database Design Principles  
  
[#ACID](https://twitter.com/search?q=%23ACID "#ACID") ve [#BASE](https://twitter.com/search?q=%23BASE "#BASE") en temelleri. Bunları anlamlandırabilmek için [#CAP](https://twitter.com/search?q=%23CAP "#CAP") teoremini bilmek lazım. [#Mikroservis](https://twitter.com/search?q=%23Mikroservis "#Mikroservis") mimari için [#EventSourcing](https://twitter.com/search?q=%23EventSourcing "#EventSourcing") problemine çözüm [#CQRS](https://twitter.com/search?q=%23CQRS "#CQRS") de öğrenilebilir

## 9- Static Code Analysis Tools  
  
[#CodeReview](https://twitter.com/search?q=%23CodeReview "#CodeReview") başlığını da bu maddeye yedirelim. Yazdığınız kodun kalitesini, security risklerini bu toollarla ölçümleyip kodunuza review yapmanız önemli. Java için birkaç örnek; [#PMD](https://twitter.com/search?q=%23PMD "#PMD"), [#FindBugs](https://twitter.com/search?q=%23FindBugs "#FindBugs"), [#FindSecurityBugs](https://twitter.com/search?q=%23FindSecurityBugs "#FindSecurityBugs"), [#SonarQube](https://twitter.com/search?q=%23SonarQube "#SonarQube")...

## 10- Unit & Integration Testing  
  
Testin kodlanması şart, özellikle de mikroservis mimarilere adım atıyorsanız. [#TDD](https://twitter.com/search?q=%23TDD "#TDD") bu yüzden çok iyi bir seçim. Bunu uygulayamasanız bile en azından birim ve entegrasyon testlerini yazmalısınız. [#JUnit](https://twitter.com/search?q=%23JUnit "#JUnit") [#DBUnit](https://twitter.com/search?q=%23DBUnit "#DBUnit") [#Selenium](https://twitter.com/search?q=%23Selenium "#Selenium") [#Mockito](https://twitter.com/search?q=%23Mockito "#Mockito") [#AssertJ](https://twitter.com/search?q=%23AssertJ "#AssertJ") [#Jmeter](https://twitter.com/search?q=%23Jmeter "#Jmeter")

## 11- Unix - Linux  
  
[#SSH](https://twitter.com/search?q=%23SSH "#SSH") terminalini karşınıza aldığınızda şaşırıp kalmamalısınız. Bağlandığınız sunucuda [#fileSystem](https://twitter.com/search?q=%23fileSystem "#fileSystem") [#textEdit](https://twitter.com/search?q=%23textEdit "#textEdit") [#fileTransfer](https://twitter.com/search?q=%23fileTransfer "#fileTransfer") işlemlerinizi rahatça halledebilmelisiniz. Temel işlemlerinizi halledebilecek kadar [#shellScripting](https://twitter.com/search?q=%23shellScripting "#shellScripting") yapabilmelisiniz.

## 12- Scripting Language  
  
Ana bir [#HighLevelLanguage](https://twitter.com/search?q=%23HighLevelLanguage "#HighLevelLanguage") (java, c# gibi) yanında bir betik dilini bilmek birçok ihtiyacınızı çok daha hızlı çözebilmenizi sağlar. İkinci bir dil bilmenin ufkunuzu nasıl genişleteceğinden bahsetmiyorum bile. [#FunctionalPrograming](https://twitter.com/search?q=%23FunctionalPrograming "#FunctionalPrograming") öğrenmek de güzel olur

## 13- Tools  
  
Bütün bunları yaparken toollara ihtiyacımız olacak. Kendinizi en iyi hissettiğiniz toollardan bir toolkit yaratın ve uzmanlaşın. Örn: [#Postman](https://twitter.com/search?q=%23Postman "#Postman") [#Notepad](https://twitter.com/search?q=%23Notepad "#Notepad")++ [#Excel](https://twitter.com/search?q=%23Excel "#Excel") [#powerpoint](https://twitter.com/search?q=%23powerpoint "#powerpoint") [#ditto](https://twitter.com/search?q=%23ditto "#ditto") [#mtail](https://twitter.com/search?q=%23mtail "#mtail") [#sysinternals](https://twitter.com/search?q=%23sysinternals "#sysinternals") [#DumpAnalyzer](https://twitter.com/search?q=%23DumpAnalyzer "#DumpAnalyzer") vb...

## 14- Takip Listesi  
  
Gündemi sürekli takip edebilmek ve güncel kalmak için sizinle benzer kulvardaki profesyonelleri bulun, [#blog](https://twitter.com/search?q=%23blog "#blog")'larını, sosyal medyalarını takip edin. Siz de vefa borcunuzu ödemek ve kendinizden sonrakilere fayda yaratabilmek için yavaştan paylaşımlara başlayın

## 15- OpenSource Contribution  
  
Başkalarının kodlarını okumak sizi çok hızlı geliştirir. Bu sebeple open source community projelerine contributor olun. Ekmekte tuzunuz olsun.

