---
title:  "Mutable - Immutable Types"
date:   2012-01-25 20:04:23
categories: [java, jvm]
tags: [java, mutable, immutable, type, nedir]
---

Bugün bir çoğumuzun bildiği ama çoğu zaman dikkat etmediğimiz bir konuya dikkat çekmek istiyorum. [Mutable](http://en.wikipedia.org/wiki/Mutable#Java)(değişebilir) ve [immutable](http://en.wikipedia.org/wiki/Mutable#Java)(değişemez) tipler. Hangi veri tiplerimiz niçin bu özellikte, performansa etkileri ne şekilde bunlar üzerinde yorumlar yapacağız.  
  
Örneklerim java üzerinden olacak. Ufak bir örnekle başlamadan önce String tipinin aslında bir karakterler dizisi olduğunu, bu veri tipinin [primitive](http://en.wikipedia.org/wiki/Primitive_data_type)(ilkel) bir tipi olmadığını hatırlatma gereksinimi duyuyorum.  
  
Bu örneğimizde string bir değişkenimize defalarca [concatenating](http://en.wikipedia.org/wiki/Concatenation)(bağlama) işlemi yapacağız. [Iterasyon](http://en.wikipedia.org/wiki/Iteration)(tekrarlama) sayısını yüksek tuttum ki fark daha net anlaşılsın. Örnekte 100.000 kez, varolan bir stringin sonuna bir değer ekleme işlemi yapıyoruz. Bu işlem arasında geçen süreyi hesaplıyoruz.  
  

> > **public class Test {**
> 
> > **public static void main(String[] args) {**
> 
> > **String deneme=null;**
> 
> > **long time=System.currentTimeMillis();**
> 
> > **for (int i = 0; i < 100000; i++) {**
> 
> > **deneme +=i;**
> 
> > **}**
> 
> > **System.out.println(System.currentTimeMillis() - time); // 52860ms**
> 
> > **}**
> 
> > **}**

Bu iterasyon için geçen süre yaklaşık 52.000ms. Bu işleme A işlemi ismini verelim.  
  
Aynı işlemi bir de [StringBuffer](http://docs.oracle.com/javase/1.4.2/docs/api/java/lang/StringBuffer.html) sınıfını kullanarak yapalım ve süreyi ölçelim.(İsmi B işlemi olsun)  
  
	public class Test {
	   public static void main(String[] args) {
	      StringBuffer sb = new StringBuffer();
	      long time=System.currentTimeMillis();
	      for (int i = 0; i < 100000; i++) {
	         sb.append(i);
	      }
	      System.out.println(System.currentTimeMillis() - time); // 7ms
	   }
	}

Arada nasıl oluyor da bu kadar büyük bir süre farkı oluyor? Birçoğunuzun String'in immutable bir tip olduğunu söylediğinizi duyar gibiyim. Peki nedir bu kavram, nasıl oluyor da StringBuffer çok daha hızlı bir şekilde bu işi gerçekleştiriyor?  
  
Durumun aslını özetlemek gerekirse, concatenating(A) işleminde değişkenimiz üzerinde yapılan her işlem aslında yeni bir String değişken [instance](http://en.wikipedia.org/wiki/Instance_(programming))(örneği) almak anlamına geliyor. Yani klasik örnekle göstermek gerekirse  
  
	deneme +="cem"; 
	new String(deneme+"cem");
  
işlemleri birebir aynı işlemler. Ben 100.000 kez bu işlemi tekrarladığımda her defasında büyüyen karakter dizim için dizinin sığabileceği boyutta bellekte alan aramaya çalışıyorum. Aynı zamanda tek kullanım yaratılıp sonrasında işi biten nesneyi de [garbage collector](http://en.wikipedia.org/wiki/Garbage_collection_(computer_science))'ın temizlemesine bırakıyorum. Yani ekstra iş yükü ekstra iş yükü. 100.000 kere yeni string yaratıp sonunda 1 tane string kazanıyorum.  
  
Peki B işleminde ne yapıyoruz? StringBuffer sınıfı [JDK](http://en.wikipedia.org/wiki/Java_Development_Kit)1.0 ile gelen bir sınıf. Her append işleminde  
  
`sb.insert(sb.length(), [eklenecek string])
`şeklinde işlem gerçekleştirilir. Özetle burada yapılan yeni bir string alıp değerleri orada tutmak değil, varolan stringin kapasitesi artırılıp sonuna insert edilmesidir. Kapasitenin artırılması  [JVM](http://en.wikipedia.org/wiki/Java_virtual_machine)  tarafından otomatik olarak gerçekleştirilmektedir. Bu işlem asenkron olarak işlemektedir.`  
`Aynı işlemi  [thread safe](http://en.wikipedia.org/wiki/Thread_safety) olmayarak gerçekleştiren bir sınıf JDK 1.5 ile gelmiştir. Adı  [StringBuilder](http://docs.oracle.com/javase/1.5.0/docs/api/java/lang/StringBuilder.html)'dır. Kısacası StringBuilder sınıfı StringBufferdan çok ufak bir miktar daha hızlıdır, aradaki hız farkı senkronizasyon için harcanan vakittir. Concatenation'dan çok çok daha hızlı olduğunu yine hatırlatmakta fayda var.`  

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
