---
title: "Eclipse Formatter On Off"
date: 2015-11-09 20:04:23
categories: [ide, tools, blog]
tags: [eclipse, java, formatter, productivity, mehmet-cem-yucel]
---

Eclipse'in formatter özelliği developerlar için tartışmasız bir nimet. O kadar ki kodlama yaparken iki satır kod yazdıktan sonraki ilk refleksim  
  
	CTRL+A  
	CTRL+Shift+F  
	CTRL+S .  
  
Yani tüm kodu seç, formatla ve kaydet. Window > Preferences > Java > Code Style > Formatter altında yer alan menüden farklı formatlama profilleri yaratabilirsiniz, güncelleyebilirsiniz.  
  
Formatter her ne kadar kullanışlı bir araç olsa da kimi zaman kodumuzun bazı parçalarının formatlanMAmasını isteriz. Özellikle de DAO'lar içerisinde yer alan SQL stringleri formatlandığında SQL'in kendi formatına değil, Eclipse'in diğer kodlarımız için oluşturduğu her satır için atanan karakter adedine göre formatladığı için SQL'i okumak söz konusu olduğunda çileden çıkaran bir durumla karşılaşabiliyoruz. En basitinden bir örnek verelim;    

[![](/images/2015-11-09-eclipse-formatter-on-off/1.JPG)](/images/2015-11-09-eclipse-formatter-on-off/1.JPG)

  
şeklinde gözükmesini istediğimiz bir sql'imiz olsun. Bu sql'i formatladığımızda Eclipse aşağıdaki şekle çeviriyor.  
  

[![](/images/2015-11-09-eclipse-formatter-on-off/2.JPG)](http://3.bp.blogspot.com/-qivmp24uKBQ/VkBYkJbE74I/AAAAAAAAAk0/4lMgYqyv1Yo/s1600/2.JPG)

  
Okunabilirliği açısından güzel bir görüntüsü olmadığı aşikar. Peki ne yapalım?  
  
Yani tüm kodu seç, formatla ve kaydet. Window > Preferences > Java > Code Style > Formatter menüsünde kendi profilinizi editleyin ve tabların en sonunda Off/On Tags tabında Enable Off/On tags'ı seçin. Default olarak @formatter:off ve @formatter:on taglerini kendi istediğiniz kelimelerle de değiştirebilirsiniz.  
  

[![](/images/2015-11-09-eclipse-formatter-on-off/3.JPG)](http://4.bp.blogspot.com/-PD43nbZbi8g/VkBZM8OxIqI/AAAAAAAAAk8/L2wj-9Sh55w/s1600/3.JPG)

  
Artık comment olarak bu keywordleri kullandığımız aralık formatter tarafından es geçilecek. Yani aşağıdaki kodumuz bundan sonra sürekli bu şekilde gözükecek.  
  

[![](/images/2015-11-09-eclipse-formatter-on-off/4.JPG)](/images/2015-11-09-eclipse-formatter-on-off/4.JPG)
