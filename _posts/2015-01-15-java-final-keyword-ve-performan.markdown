---
title:  "Java Final Keyword ve Performans Etkileri"
date:   2015-01-15 20:04:23
categories: [java, jvm, mimari]
tags: [ java, jvm, final, keyword, heap, memory bellek, mehmetcemyucel, mehmet, cem, yücel, yucel, outofmemoryerror, yönetimi]
---

Bugün zaten bildiğimiz final anahtar kelimesine biraz farklı açılardan bakacağız.  
  
Hatırlamak için; final anahtar kelimesi kullanıldığı  

1.  değişkenin bir daha değiştirilmeyeceğini
2.  metodun override edilmeyeceğini
3.  sınıfın kalıtılamayacağını ifade eder.

Peki, çoğu zaman es geçilen bu anahtar kelimenin JVM üzerinde ne gibi etkileri var? 2 açıdan JVM üzerindeki etkilerini inceleyelim.

  

**1. FİNAL SINIFLAR ve METOTLAR (FINAL CLASSES and METHODs)**

  

Final anahtar kelimesinin sınıflar ve metotlar üzerindeki etkisini inceleyebilmek için ilk önce VTable(Virtual Method Table) hakkında bilgi sahibi olmalıyız. VTable'ın konumuzla ilgili kısmını kısaca özetlemek gerekirse, sınıflar içerisinde tanımlanan metotlar için sınıflar kendi içlerinde hidden birer pointer tutarlar. Pointerların tuttukları referans tam da VTable'daki metotların start pointlerini gösterir. Siz bir metodu çağırmak istediğinizde bu metodun execution için başlangıç noktası bilgisine VTable'dan erişilir. VTable hakkında detaylı bilgiye  [buradan](http://en.wikipedia.org/wiki/Virtual_method_table) ulaşabilirsiniz.

  

Peki metotların başında final anahtar kelimesinin bulunmasının VTable'da nasıl bir etkisi bulunuyor?

Final olmayan metotlar runtimeda kalıtım hiyerarşisinden sebeple başka sınıflar tarafından override edilebilir. Dolayısıcla kalıtan sınıfta yazılı olan kodun mu yoksa kalıtan sınıfta override'ı varsa onun mu çalıştırılması gerektiğine runtime'da karar verilmesi gerekecektir. Örnekle açıklayalım;  
  

package com.cem;

public class Araba {

 protected int hiz=0;

 public void hizlan() {
  hiz++;
 }

 public int getHiz() {
  return hiz;
 }

 public void setHiz(int hiz) {
  this.hiz = hiz;
 }
}

  
  

Araba sınıfımız var ve hız değerini artıran bir metot olarak hizlan() metodu yazdık. Ve bu sınıfı kalıtan bir Ferrari sınıfı yazalım.  
  

package com.cem;

public class Ferrari extends Araba {
}

  
Ferrari sınıfının hızlan metodunu bir test class'ıyla aşağıdaki gibi çağırabiliriz.  
  
  

package com.cem;

public class Test {
 public static void main(String[] args) {
  Ferrari fr = new Ferrari();
  fr.hizlan();
  System.out.println(fr.getHiz());
 }
}

  
  
Çıktısı "1" oldu çünkü 1 kereye mahsus hız değeri 1 artırıldı. Peki, Ferrari sınıfı kalıtımla miras aldığı hızlan metodu yerine kendi hızlanmasını yazsaydı ne olacaktı;  
  
  

package com.cem;

public class Ferrari extends Araba {
 public void hizlan() {
  this.hiz += 2;
 }
}

  
Ferrari, Araba sınıfından miras aldığı hizlan metodunu override ederek kendi metodunu gerçekleştirdi. artık Test sınıfını çalıştıracak olursak çıktımız "2" olarak görülecek.  
  
Yani artık Ferrari sınıfı için hizlan metodu vtable'da başka bir programcığı gösteriyor olacak.  
  
Final tanımlanan metotlar yukarıdaki gibi override edilemeyeceği için VM'ler (örneğin HotSpot Sanal Makinası) compile zamanında final metotlar için optimizasyon yaptığı için ilgili metot çağırılacağı anda gidip VTable'dan bulunan start point'e ulaşmak için yapılan memory jump sayısında azalma olur. Bu da performansta artış anlamına gelmektedir.  
Hotspot'un bu optimizasyonu ne şekilde yaptığı ile ilgili bilgiye [buradan](https://wikis.oracle.com/display/HotSpotInternals/VirtualCalls) erişebilirsiniz.  
  
Aynı şekilde final tanımlanan sınıflar kalıtılamayacağı için otomatikman metotları yine aynı performans artışını yakalayacaktır.  
  
**2. FİNAL DEĞİŞKENLER (FINAL VARIABLEs)**  
  
Değişkenler final tanımlandığı taktirde bir daha değişmeyecekleri garanti edilir. Bu göz önünde bulundurulunca compile esnasında kod optimize edilerek performans geliştirimi otomatik olarak yapılmaktadır.  
  
Örnekte görelim;  
  
  

package com.cem;

public class Test {
 private static  boolean VAR = true;
 public static void main(String[] args) {
  if (VAR) {
   System.out.println("Hello World");
  }
 }
}

  
bu sınıfı derlediğimiz zaman oluşturulan binary kod şu şekilde:  
  

package com.cem;

import java.io.PrintStream;
public class Test
{
  private static boolean VAR = true;
  public static void main(String[] args) {
    if (VAR)
      System.out.println("Hello World");
  }
}

  

  

Peki değişkenimizi final yaparsak?  
  

package com.cem;

public class Test {
 private static final boolean VAR = true;
 public static void main(String[] args) {
  if (VAR) {
   System.out.println("Hello World");
  }
 }
}

  
  
Yeni oluşan binary şu şekilde;  
  
  

package com.cem;

import java.io.PrintStream;
public class Test
{
  private static final boolean VAR = true;
  public static void main(String[] args)
  {
    System.out.println("Hello World");
  }
}

  
Yani derleyici if condition'ın her halukarda true olacağını ve oraya girileceğini görebildiğinden bu durum derlenen kodun içerisine hiç yansıtılmıyacak.  
  
**TOPLAMDA SONUÇ**  
  
Değişkenlerde final keyword'ünün kullanımının somut olması açısından bu şekilde bir örnekle anlattım. Niçin zaten değerini bileceğim birşey için if komutu yazacağım ki diye düşünmemek lazım  
olay sadece if'te değil :) Somut çıktı amacıyla bu örnek seçtim.  
  
Metot ve sınıflardaki final kullanımına gelecek olursak, evet etkisi vardır. Ancak o kadar düşük bir etkidir ki aslında dikkate alınmaya değer bir durum değildir. Ki IBM'in "[Şehir Efsaneleri](http://www.ibm.com/developerworks/java/library/j-jtp04223/index.html)" yazısında da bununla ilgili bir paragraf bulunmaktadır.  
  
Performans kaygıları bir kenara, kodumuzun temiz bir kod olması açısından final kelimesini kullanmakta fayda var. Sınıflarımızın kalıtılamayacağından emin olmak istediğimizde, metotlarımızın tekrar gerçekleştiriminin engellenmesi gerektiğinde değerinin değişmeyeceğini bildiğimiz değişkenlerimiz, ki çoğu zaman bu değişkenler aslında sabittir, mutlaka final kelimesini kullanmalıyız.  
  
Görüşmek üzere !