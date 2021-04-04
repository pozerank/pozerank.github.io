---
title:  "Java Daemon Thread"
date:   2015-08-03 20:04:23
categories: [jvm, java, mimari]
tags: [ java, jvm, daemon, thread, heap, memory bellek]
---

Bir java uygulamanın sonlanması için main thread'in sonlanması ve başka hiçbir aktif user thread'in olmaması gerekir. Bu sonlanmayı main thread sonlandırıldığında aktifleşen DestroyJavaVM isimli thread yönetir.  
  
DestroyJavaVM uygulamayı sonlandırmak için user threadlerinin sonlanmasını bekler. Threadler sonlanır sonlanmaz uygulama JVM'de sonlandırılır. Ancak uygulamanın başlattığı aktif threadler bulunuyorsa uygulama sonlanamayacaktır.  
  
DestroyJavaVM thread'inin göz ardı ettiği bazı threadler vardır ki bu threadler uygulamanın sağlıklı bir şekilde çalışmasından sorumlu sistem threadleridir. Örneğin Finalizer isimli thread finalize metodu çalıştırılacak objeleri alır ve bu çağırımları gerçekleştirir. Başka bir örnek, Signal Dispatcher thread'i JVM ile OS arasındaki native çağırımlardan sorumlu sistem threadidir.  
  
Bir thread'i daemon olarak tanımladığımız zaman uygulamanın sonlanması için engel oluşturmayan bir thread oluşturduğumuzu ifade ederiz. Bu thread'imiz çalışan başka hiçbir thread kalmadığında işini henüz tamamlamamış olsa dahi uygulamamız sonlanacaktır. Bu tarz threadleri genellikle yarattığımız diğer threadleri kontrol eden kod parçalarını çalıştırmak için kullanırız. Örneğin sistemdeki aktif olan threadleri dinleyen bir izleme thread'i gibi.  
  
**KOD;**  
  
İki adet thread sınıfından extend olmuş sınıfımız var.  
  
Birisi(DaemonThread sınıfı) while ile sonsuz döngüde 3er saniyelik aralıklarla ekrana çıktı veriyor. Bu thread dışarıdan bir müdahale olmadığı sürece sonsuza kadar çalışacak bir thread.  

	public class DaemonThread extends Thread {
	 @Override
	 public void run() {
	  while (true) {
	   System.out.println("Daemon thread is running");
	   try {
		Thread.sleep(3000);
	   } catch (InterruptedException e) {
		e.printStackTrace();
	   }
	  }
	 }
	}

  
Diğeri(NormalThread sınıfı) 1er saniyelik aralıkla 2 kez çalışıp sonlanacak bir thread.  
  

	public class NormalThread extends Thread {
	 @Override
	 public void run() {
	  for (int i = 0; i < 2; i++) {
	   System.out.println("Normal thread is running");
	   try {
		Thread.sleep(1000);
	   } catch (InterruptedException e) {
		e.printStackTrace();
	   }
	  }
	 }
	}

  
**1. User Thread Olarak Çalışan Threadler**  
  

	public class ThreadExample {
	 public static void main(String[] args) {
	  Thread daemon = new DaemonThread();
	  Thread normal = new NormalThread();

	  daemon.start();
	  normal.start();
	 }
	}

  
Yukarıdaki gibi bir test kodumuz var. İki thread'in de instanceları alınıp start() komutuyla çalıştırdığımızda çıktımız aşağıdaki gibi oluyor.  
  

	Daemon thread is running
	Normal thread is running
	Normal thread is running
	Daemon thread is running
	Daemon thread is running
	Daemon thread is running
	...
	...

  
Sonsuza kadar devam eden bir daemon thread mesajı görüyoruz. Sebebi sonsuz döngüde devam eden bir User thread'i olan DaemonThread isimli sınıftan yaratılmış bir threadin çalışıyor olması.  
  
**2. Daemon Thread Olarak Değiştirilen Threadler**    

	public class ThreadExample {
	 public static void main(String[] args) {
	  Thread daemon = new DaemonThread();
	  daemon.setDaemon(true);
	  Thread normal = new NormalThread();

	  daemon.start();
	  normal.start();
	 }
	}

  
Bu kez kodumuzun 5. satırında ilk threadimizi daemon thread olarak set ediyoruz. Bu kez çıktımız;  
  
  

	Daemon thread is running
	Normal thread is running
	Normal thread is running

  
Bu kez ilk thread'imiz daemon thread olarak tanımlı ve main thread ve ikinci thread sonlandığı taktirde uygulamamızın sonlanması için bir problem kalmıyor. Çıktıda da görüldüğü gibi normal threadimiz sonlandığı andan sonra daemon thread bir daha çalışmıyor.  
  
  
Kodlara aşağıdaki linkten erişebilirsiniz.  
  
[https://github.com/mehmetcemyucel/blog/tree/master/DaemonThread](https://github.com/mehmetcemyucel/blog/tree/master/DaemonThread)

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