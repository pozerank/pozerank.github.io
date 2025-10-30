---
title: "Eclipse Conditional Breakpoint"
date: 2015-01-19 20:04:23
categories: [ide, tools, blog]
tags: [eclipse, debugging, conditional-breakpoint, java, mehmet-cem-yucel]
---

Genelde kodda değişiklik yaparak çözme yoluna gittiğimiz ama aslında hazır bir özellikle işin içinden kolayca çıkabileceğimiz bir özelliği paylaşmak istiyorum.  
  
Örneğin bir kodunuz var. Kodun içerisindeki bir değişken, istediğiniz spesifik bir değere eşit olduğunda [debug](http://en.wikipedia.org/wiki/Debugging) etmek istiyorsunuz. Aşağıda 13. satırdaki System.out.println metoduna bir [breakpoint](http://en.wikipedia.org/wiki/Breakpoint) koymak istiyorum ama sadece i değeri 59 olduğu zaman işlemlerimi gözlemlemek istiyorum. Kodumuzu  
  


	import java.util.Random;

	public class Test {

	 public static void main(String[] args) {

	  int i = 0;
	  Random random = new Random();
	  while (true) {
	   i = random.nextInt(100);
	   if (i == 59) {
		...
	   }
	  }
	 }

	}

genelde bu şekilde değiştirip if'in içerisine girince neler olduğunu görerek devam ederiz dediğinizi duyar gibiyim :)  
  
O zaman if'siz, yalın haliyle kodumuzun görüntüsü aslında şöyle bir şey olduğunu varsayalım.  


	public class Test {

	 public static void main(String[] args) {

	  int i = 0;
	  Random random = new Random();
	  while (true) {
	   i = random.nextInt(100);
	   System.out.println("Hello world");
	   ...
	  }
	 }
	}

i değişkeni 59 değerini aldığında 13 nolu satıra koyacağım breakpoint'e takılmasını ve ilerleyen kodları adım adım ilerlemek istediğimizi varsayalım. yapacağımız işlem şu şekilde:  
  
- Eclipse'de "debug" perspektifine geçiyoruz. (Window>Open Perspective>Debug)  
- [Breakpoints](http://en.wikipedia.org/wiki/Breakpoint) sekmesinde koyduğumuz breakpointi bulup sağ tıklıyoruz.  
- Breakpoint Properties'i açıyoruz.  
[![](/images/2015-01-19-eclipse-conditional-breakpoint/breakpoint.png)](/images/2015-01-19-eclipse-conditional-breakpoint/breakpoint.png)- Conditional checkbox'ını seçiyoruz ve aşağıda aktifleşen alana condition'umuzu yazıyoruz.  
  

[![](/images/2015-01-19-eclipse-conditional-breakpoint/breakpoint2.png)](/images/2015-01-19-eclipse-conditional-breakpoint/breakpoint2.png)

  
Bunları yaptıktan sonra koşul sağlandığı zaman çalışan thread kesilip [breakpointte](http://en.wikipedia.org/wiki/Breakpoint) emrinize amade bekler durumda oluyor.  
  
