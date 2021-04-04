---
title:  "Statik Kod Analiz Araçları"
date:   2012-01-27 20:04:23
categories: [tools, ide]
tags: [java, static, statik, kod, code, analiz, analysis, tools, araçları, findbugs, sonarqube, sonarlint]
---

İyi kod yazmak için dikkat edilmesi gereken bir çok detay var. Bazı zamanlar gereksiz döngülerde zaman harcarız kimi zaman da normalde yapmayacağımız hatalı kodlar yazarız. Hatta zaman zaman o hatalı kodlarımız çalışır, ta ki o kodun çalışmayacağı case gerçekleşene kadar.  
  
Bu hataları ve best practise'leri yakalayabilmek için 2. hatta 3. bir göz tarafından code review yaparız. Bizim gözümüzden kaçanları başkaları yakalar, kodu optimize ederiz. Ama hepimiz insanız, kimi küçük ayrıntıları gözümüzden kaçırabiliriz.  
  
Bu durumlarda kod analiz araçları imdadımıza yetişiyor. Kimi dinamik, kimi statik kurallarla çalışıyor. Kimisi best practice'leri, kimisi hatalı kodları, kimisi ise performans ölçümleri için iyi sonuçlar veriyor. Java için best practice ve hatalı kodları uyarmak için bulduğum kullanışlı bir tool örneği vereyim, [FindBugs](http://findbugs.sourceforge.net/). Eclipse için plugini de bulunuyor, size uyarılar ve sebeplerini veriyor. Daha profesyonel bir çözüm için de [SonarQube](https://www.sonarqube.org/) inceleyebilirsiniz. 
  
Ayrıca aşağıdaki adreste birçok dil ve ide için toolların bir listesi de bulunuyor. Kodunuzun kalitesini bu toollarla artırabilirsiniz.  
  
[http://en.wikipedia.org/wiki/List_of_tools_for_static_code_analysis](http://en.wikipedia.org/wiki/List_of_tools_for_static_code_analysis)  
  
  
***En yalın haliyle***

[**Mehmet Cem Yücel**](https://www.mehmetcemyucel.com)

---

**_Bu yazılar ilgilinizi çekebilir:_**

 - [Bir Yazılımcının Bilmesi Gereken 15 Madde](https://www.mehmetcemyucel.com/2019/bir-yazilimcinin-bilmesi-gereken-15-madde/)
 - [Spring Boot Devtools ile Docker Üzerindeki Kodu Debug Etme ve Değiştirme](https://www.mehmetcemyucel.com/2019/spring-boot-devtools-ile-docker-uzerindeki-kodu-debug-etme-ve-degistirme/)
 - [Spring Boot Property’lerini Jasypt ile Şifrelemek](https://www.mehmetcemyucel.com/2019/spring-boot-propertylerini-jasypt-ile-sifrelemek/)

**_Blockchain teknolojisi ile ilgileniyor iseniz bunlar da hoşunuza gidebilir:_**

 - [BlockchainTurk.net yazıları](https://www.mehmetcemyucel.com/categories/#blockchain)

---