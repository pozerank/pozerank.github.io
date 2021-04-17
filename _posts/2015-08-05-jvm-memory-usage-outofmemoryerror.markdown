---
title:  "JVM Memory Usage OutOfMemoryError"
date:   2015-08-05 20:04:23
categories: [java, jvm, mimari]
tags: [ java, jvm, heap, memory, bellek, outofmemoryerror]
---


Önce bazı temel bilgiler :)  
  
Java programlarını çalıştırırken JVM kendisine belirli bir miktar bellek alokasyonu yapar. Bir java programını çalıştırırken JVM'e  

-  Xms argümanıyla initial heap size'ını

-  Xmx argümanıyla da maksimum heap size'ını verebileceğimizi  [burada](http://www.mehmetcemyucel.com/2010/11/javalangoutofmemoryerror.html) bahsetmiştik.

Biz uygulamamız için initial heap size'ını, yani uygulama açıldığında default olarak alınacak olan heap size'ını 16MB, ileride ihtiyaç duyulduğunda takdirde maksimum ulaşabileceği heap size'ını 256MB olarak atayacağız.

  

### 1. VM Arguments Düzenleyelim

[Buradan](http://www.mehmetcemyucel.com/2015/08/eclipse-vm-arguments.html)  Eclipse üzerinde VM argümanlarının nasıl verildiğini inceleyebilirsiniz.

Ayarlamalarımızı yaptıysak artık uygulamamıza doğru yol alabiliriz.  

### 2. Java Runtime Sınıfı

Çalışmakta olan her uygulama kendisine dair bazı bilgilere erişebileceğimiz  Runtime sınıfının single bir instance'ına sahiptir.  Runtime sınıfının static  getRuntime()  metodu aracılığıyla bu instance'a erişebiliriz.

Bu instance içerisinde 3 tane metodla ilgileneceğiz. Bu metodlar  byte cinsinden değer dönmektedir.

-  freeMemory()  : müsait olan bellek alanı

-  totalMemory()  : o andaki toplam bellek alanı

-  maxMemory() : maksimum bellek alanı bilgilerini dönmektedir.

3. Bellek İzleme Kodu

Aşağıda kodumuzun ilk parçasında uygulamamız açıldığındaki mevcut değerlerimizi göreceğiz. Sonra bellek üzerinde yer kaplayan değişkenler yaratıp sonra bellekte ne şekilde değişiklikler gerçekleştiğini gözlemleyeceğiz.

 package com.cem;
 
 import java.util.ArrayList;
 import java.util.List;
 
	public class FreeMemory {
	 
	  private static final int MEGABYTE_CONSTANT = 1024 * 1024;
	 
	  public static void main(String[] args) {
		 long freeMemory = Runtime.getRuntime().freeMemory() / MEGABYTE_CONSTANT;
		 long totalMemory = Runtime.getRuntime().totalMemory() / MEGABYTE_CONSTANT;
		 long maxMemory = Runtime.getRuntime().maxMemory() / MEGABYTE_CONSTANT;
		 
		 System.out.println("freeMemory=\t" + freeMemory);
		 System.out.println("totalMemory=\t" + totalMemory + " (initial heap miktari)");
		 System.out.println("maxMemory=\t" + maxMemory);
		 
		 List fillHeapList = new ArrayList();
		 
		 for (int i = 0; i < 1000000; i++) {
		  fillHeapList.add(String.valueOf(9999));
		 }
	 
		 System.out.println("\nKOD CALISTI\n");
	 
		 freeMemory = Runtime.getRuntime().freeMemory() / MEGABYTE_CONSTANT;
		 totalMemory = Runtime.getRuntime().totalMemory() / MEGABYTE_CONSTANT;
		 maxMemory = Runtime.getRuntime().maxMemory() / MEGABYTE_CONSTANT;
		 
		 System.out.println("freeMemory=\t" + freeMemory);
		 System.out.println("totalMemory=\t" + totalMemory + " (initial degerleri astiktan sonraki allocate edilen heap miktari)");
		 System.out.println("maxMemory=\t" + maxMemory);
	 
		 System.out.println("\nVM'in kullamakta oldugu miktar=\t" + (totalMemory - freeMemory));
	  }
	}

  
  
Çıktımız aşağıdaki gibi;  
  

	freeMemory= 14
	totalMemory= 15 (initial heap miktari)
	maxMemory= 247

KOD CALISTI

	freeMemory= 68
	totalMemory= 120 (initial degerleri astiktan sonraki allocate edilen heap miktari)
	maxMemory= 247

VM'in kullamakta oldugu miktar= 52

  

İlk kod parçamız çalıştığında uygulamanın default olarak aldığı heap genişliğini gördük.  
  
Sonrasındaki çalıştırdığımız kod parçası ile memory üzerinde initial değerlerinden fazla yer ihtiyacı duyurucak şekilde çok sayıda değişken tanımlayıp bunların referanslarının ölüp  Garbage Collector  tarafından toplanmasını engellemek için bir List içerisinde tuttuk.  
  
En son olarak da tekrardan mevcut görüntüye baktık ve gördük ki JVM daha fazla bellek allocate etmiş, ve bu sebeple değerlerimiz değişmiş.  
  
Eğer değişken yaratan döngümüzün iterasyonunu artırıp 10.000.000'a çıkartırsak bu kez daha fazla bellek alanına ihtiyaç duyacak ancak maksimum heap size da buna yeterli olmayacaktı. Bu durumda da JVM  OutOfMemoryError hatası fırlatacaktı. Bu konu ile ilgili yazıya da  [buradan](http://www.mehmetcemyucel.com/2010/11/javalangoutofmemoryerror.html) ulaşabilirsiniz.

  

Kodlarımıza da aşağıdaki linkte  
  
[https://github.com/mehmetcemyucel/blog/tree/master/FreeMemory](https://github.com/mehmetcemyucel/blog/tree/master/FreeMemory)

---

Referanslar

1.[FAQ How do I increase the heap size available to Eclipse?](https://wiki.eclipse.org/FAQ_How_do_I_increase_the_heap_size_available_to_Eclipse)

2.[Runtime Class](https://docs.oracle.com/javase/6/docs/api/java/lang/Runtime.html)  

3.[java.lang.OutOfMemoryError](http://www.mehmetcemyucel.com/2010/11/javalangoutofmemoryerror.html)  

4.[Eclipse VM Arguments](http://www.mehmetcemyucel.com/2015/08/eclipse-vm-arguments.html)
