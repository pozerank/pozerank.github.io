---
title:  "Eclipse Formatter On Off"
date:   2015-11-09 20:04:23
categories: [ide, tools]
tags: [ java, jvm, formatter, on, off, sql, style, eclipse, ide]
---

Eclipse'in formatter özelliği developerlar için tartışmasız bir nimet. O kadar ki kodlama yaparken iki satır kod yazdıktan sonraki ilk refleksim  
  
	CTRL+A  
	CTRL+Shift+F  
	CTRL+S .  
  
Yani tüm kodu seç, formatla ve kaydet. Window > Preferences > Java > Code Style > Formatter altında yer alan menüden farklı formatlama profilleri yaratabilirsiniz, güncelleyebilirsiniz.  
  
Formatter her ne kadar kullanışlı bir araç olsa da kimi zaman kodumuzun bazı parçalarının formatlanMAmasını isteriz. Özellikle de DAO'lar içerisinde yer alan SQL stringleri formatlandığında SQL'in kendi formatına değil, Eclipse'in diğer kodlarımız için oluşturduğu her satır için atanan karakter adedine göre formatladığı için SQL'i okumak söz konusu olduğunda çileden çıkaran bir durumla karşılaşabiliyoruz. En basitinden bir örnek verelim;    

[![](http://2.bp.blogspot.com/-PSupSxj9ua4/VkBYCfI1yEI/AAAAAAAAAkk/ZShg-uWRhoM/s1600/1.JPG)](http://2.bp.blogspot.com/-PSupSxj9ua4/VkBYCfI1yEI/AAAAAAAAAkk/ZShg-uWRhoM/s1600/1.JPG)

  
şeklinde gözükmesini istediğimiz bir sql'imiz olsun. Bu sql'i formatladığımızda Eclipse aşağıdaki şekle çeviriyor.  
  

[![](http://3.bp.blogspot.com/-qivmp24uKBQ/VkBYkJbE74I/AAAAAAAAAk0/4lMgYqyv1Yo/s640/2.JPG)](http://3.bp.blogspot.com/-qivmp24uKBQ/VkBYkJbE74I/AAAAAAAAAk0/4lMgYqyv1Yo/s1600/2.JPG)

  
Okunabilirliği açısından güzel bir görüntüsü olmadığı aşikar. Peki ne yapalım?  
  
Yani tüm kodu seç, formatla ve kaydet. Window > Preferences > Java > Code Style > Formatter menüsünde kendi profilinizi editleyin ve tabların en sonunda Off/On Tags tabında Enable Off/On tags'ı seçin. Default olarak @formatter:off ve @formatter:on taglerini kendi istediğiniz kelimelerle de değiştirebilirsiniz.  
  

[![](http://4.bp.blogspot.com/-PD43nbZbi8g/VkBZM8OxIqI/AAAAAAAAAk8/L2wj-9Sh55w/s640/3.JPG)](http://4.bp.blogspot.com/-PD43nbZbi8g/VkBZM8OxIqI/AAAAAAAAAk8/L2wj-9Sh55w/s1600/3.JPG)

  
Artık comment olarak bu keywordleri kullandığımız aralık formatter tarafından es geçilecek. Yani aşağıdaki kodumuz bundan sonra sürekli bu şekilde gözükecek.  
  

[![](http://1.bp.blogspot.com/-DHintpZuZQA/VkBZmiBG84I/AAAAAAAAAlE/EBHhoRCqF4A/s1600/4.JPG)](http://1.bp.blogspot.com/-DHintpZuZQA/VkBZmiBG84I/AAAAAAAAAlE/EBHhoRCqF4A/s1600/4.JPG)
