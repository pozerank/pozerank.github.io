---
title: "Java Virtual Threads vs Go Goroutines: Project Loom ve Concurrency Performans Kıyaslaması"
date: 2025-11-04 10:00:00
author: "Mehmet Cem Yücel"
categories: [java, go, architecture, jvm, spring, golang, software, blog]
tags: [java, go, project-loom, virtual-threads, goroutines, concurrency, performance, jvm, spring, microservices, mehmet-cem-yucel]
description: "Java 21 ile gelen Virtual Threads (Project Loom) sonunda Go'nun concurrency modeline meydan okuyor. Bu yazıda Java Platform Threads, Virtual Threads ve Go Goroutines performans testlerini detaylıca kıyaslıyoruz."
excerpt: "Java 21 ile gelen Virtual Threads (Project Loom) sonunda Go’nun concurrency modeline meydan okuyor. Gerçek testlerle farklarını görmek ister misiniz?"
image: /images/2025-11-04-java-virtual-threads-vs-go-goroutines-project-loom-ve-concurrency-performans-kiyaslamasi/govsjava.png
og_image: /images/2025-11-04-java-virtual-threads-vs-go-goroutines-project-loom-ve-concurrency-performans-kiyaslamasi/govsjava.png
canonical: https://www.mehmetcemyucel.com/2025/java-virtual-threads-vs-go-goroutines-project-loom-ve-concurrency-performans-kiyaslamasi/

---

Kurumsal tarafta, büyük ölçekli projelerde en uzun zaman geçirdiğim dil için Java diyebilirim. Sebebi aşikar, [bu yazıda](https://www.mehmetcemyucel.com/2019/Spring-ve-Java-Hantal-Mi-GraalVM-ve-Quarkus-Inceleme/) uzun uzun anlatmıştım. Ancak her gücün ağır bir bedeli oluyor, o da runtime… Örneğin 2GB bellek ayırmadan bir Spring Boot projesini kullanmak zordu. 1:1 modelde her thread bir kernel thread iken hafiflik kelimesi Java’ya uzun süre hiç uğramadı.

![Go vs Java Kıyaslaması](/images/2025-11-04-java-virtual-threads-vs-go-goroutines-project-loom-ve-concurrency-performans-kiyaslamasi/govsjava.png)



## Green Threads / Light Threads

Gerçi hiç uğramadı demek bazı eski toprakları rahatsız etmiştir. Java’nın Sun Microsystems zamanında JDK 1.1 versiyonu ile birlikte [Green Threads](https://en.wikipedia.org/wiki/Green_thread) kavramı karşımıza çıkmıştı. Light threads veya Fiber ismi de tanıdık gelmiş olabilir. Alametifarikası, direk kernel threadlere maplenen threadler değil JVM seviyesinde yönetilen user-threadler olmasıydı. Evet concurrency açısından avantaj sağlıyorlardı ancak tek bir Operating System(OS) Thread üzerinde çalıştığı için parallelism sağlayamıyorlardı. Çok çekirdekli bilgisayarların yaygınlaşmaya başlamasıyla birlikte 1.3 versiyonu ile birlikte o da tarihe karıştı. Yerine uzunca bir süre(2021e kadar) 1:1 thread modeli, yani platform threadleri ile çalışmak zorunda kalındı.

## Go’nun Performansı

Biraz da bunlardan sebepli 10 küsür yıl Java ile kodlamamın ardından son 5–6 yıldır birincil tercihim Go’ya doğru döndü. Bunun ardında yatan sebepler daha verimli, hızlı ve hafif olması idi özetle. Düşük kaynak tüketimi ve hızlı açılması ile özellikle mikroservis mimarilerde ciddi avantaj sağlıyordu ve özellikle yük altında eşzamanlılık ve paralelliği yönetebilmek için sunduğu özelliklerle hem yazılım geliştirme rahat yapılıyor hem de büyük yüklerin altında ezilmiyordu.

## Project Loom & Virtual Threads

Tabii Java 21 ile hayatımıza giren diğer bir gerçek de [Project Loom](https://wiki.openjdk.org/display/loom/Main). Java seneler sonra geliştiricileri ağır OS threadlerinden kurtarmak için butona bastı. OS threadleri neden ağır diyor olabilirsiniz, [şu videoya](https://youtu.be/yLh9hAuBPr8) göz atmanızı öneririm. Günün sonunda Java 21 ile birlikte Virtual Threads kavramı hayatımıza dahil oldu. Zaten bundan sebepli de her yerde Java 21 dönüşüm projelerini görüyor duyuyorsunuz muhtemelen :)

Project Loom’un Virtual Threadler ile yaptığı tıpkı Green Threadler gibi threadlerin kısmen JVM tarafından yönetilmesidir. Farkı ise birden fazla virtual thread, bir havuzdaki platform threadleri üzerine çoklanır(multiplexed) ve havuzdaki bu treadler kullanılarak çalıştırılır. Yani dünya sanal bir N:M modeline dönüşür. N adet sanal threade karşılık genellikle 2^x (2,4,8,..) yani M adet gerçek platform threadi yaratılması ve bu threadlerin efektif şekilde kullanılması için JVM’in schedular vb mekanizmalarının aracılık etmesini ifade eder.

Tabii mevzunun derinlerinde çok daha fazlası da var. Eski treadlerde bir threadin yaratılması için ~1MB kadar bir stack belleğe duyulan ihtiyaç sanal threadlerde default 1KB ile başlıyor. Bu majör değişim eskiye nazaran çalışmak üzere bekleyen virtual threadlerin ciddi azalmış bir footprintle çok daha fazlasının hazırda bekleyebilmesini ve JVM’in bunun da sayesinde daha fazla işi kendi sınırlarında optimize edebilmesini sağlıyor.

## Performans Ölçüm Testleri

Hadi gelin şimdi Java Platform Threadleri, Virtual Threadleri ve en son olarak Go Routineleri bir performans testine sokalım. Bakalım neler olacak?

Java zamanla ısınan bir motora sahip :) Just In Time(JIT) derleyicilerin nasıl çalıştığı ile ilgili [şuradaki podcaste](https://www.mehmetcemyucel.com/2019/Alternatif-JVMler-ve-Javanin-Gelecegi-Podcasti/) göz atabilirsiniz. Özetle, direk yükü vurmadan önce ufak bir warm-up seti ile çalıştırmak genel performans kıyası açısından daha doğru sonuç verecektir. Go ise Ahead Of Time(AOT) derleyici ile çalışır, teknik olarak Java gibi warm-up’ a ihtiyacı yoktur. Ancak ufak da olsa ilk sistem structlarının oluşmasında, P/M/G tablosunun kurulmasında minimal bir etkisi olabilir. Aynı şartlarda olması adına ikisinde de warm-up’ı tutacağım. Ayrıca direk yüksek rakamlarla denemek yerine tüm testlerde ramp-up stratejisi ile ilerleyeceğiz.

## Java Platform Thread

Java Platform Threadleri aslında kıyas yapmaktan ziyade Virtual Threadlerle nereden nereye geldik görebilmek için ekliyorum. Keza altındaki mimarinin farkında olmak Goroutine’ler ile kıyas yaparken farkı anlayabilmek için de önemli olacak.

Şöyle bir kod yazdım, bunun benzerini virtual threadler için de kullanacağız. Önce makinemin özelliklerini yazdırıyorum, sonra ufak bir ısınma sonrası 1000 threadlik bulk bir set ile çalışmayı başlatıp bir nefes arası veriyorum. Bu sırada bellekteki son durumu görüp bir sonraki bulk sete geçe geçe devam ediyorum. Kodu çalıştırır çalıştırmaz Visual VM ile ekran görüntüsü almaya çalışacağım, umarım ss alabilmek için yetişirim :)


```java
package com.mehmetcemyucel;  
  
import java.util.concurrent.ExecutorService;  
import java.util.concurrent.Executors;  
  
public class MainPlatformThread {  
  
    public static void main(String[] args) throws InterruptedException {  
        new MainPlatformThread().run();  
    }  
  
    private void run() throws InterruptedException {  
        printInfo();  
        warmup();  
  
        // Kademeli artış planı — Platform thread'lerde limit daha düşük tutulmalı  
        long[] steps = {1_000L, 5_000L, 10_000L, 25_000L, 50_000L};  
  
        for (long count : steps) {  
            System.out.println("\n=== RUNNING " + count + " TASKS ===");  
            runStep(count);  
            System.gc(); // her adım sonrası GC tetikle  
            Thread.sleep(2000); // JVM'e nefes arası ver  
        }  
  
        System.out.println("\nAll ramped-up steps completed.");  
    }  
  
    private void runStep(long count) {  
        long starttime = System.currentTimeMillis();  
        long memBefore = usedMemoryMB();  
  
        // Her task için 1 OS thread (ağır)  
        try (ExecutorService executor = Executors.newThreadPerTaskExecutor(Thread.ofPlatform().factory())) {  
            for (int i = 0; i < count; i++) {  
                if (i % 1_000 == 0 && i > 0)  
                    System.out.printf("Submitted %d tasks%n", i);  
                executor.submit(() -> {  
                    try {  
                        Thread.sleep(1000); // I/O-bound benzetimi  
                    } catch (InterruptedException e) {  
                        Thread.currentThread().interrupt();  
                    }  
                });  
            }  
        }  
  
        long memAfter = usedMemoryMB();  
        long endtime = System.currentTimeMillis();  
  
        System.out.printf("→ Completed %d tasks | Time: %d ms | Mem before: %d MB | Mem after: %d MB%n",  
                count, (endtime - starttime), memBefore, memAfter);  
    }  
  
    private void warmup() throws InterruptedException {  
        System.out.println("Warmup starting...");  
        try (ExecutorService executor = Executors.newThreadPerTaskExecutor(Thread.ofPlatform().factory())) {  
            for (int i = 0; i < 1_000; i++) { // platform threads ağır, warmup küçük tut  
                executor.submit(() -> {  
                    try {  
                        Thread.sleep(10);  
                    } catch (InterruptedException e) {  
                        Thread.currentThread().interrupt();  
                    }  
                });  
            }  
        }  
        System.out.println("Warmup done.");  
    }  
  
    private static void printInfo() {  
        System.out.println("JVM Details:");  
        System.out.println(System.getProperty("java.vm.name"));  
        System.out.println(System.getProperty("java.version"));  
        System.out.println(System.getProperty("java.vendor"));  
        System.out.println("Available processors: " + Runtime.getRuntime().availableProcessors());  
        System.out.println("Max Memory (MB): " + Runtime.getRuntime().maxMemory() / (1024 * 1024));  
        System.out.println("-----------------------------------");  
    }  
  
    private static long usedMemoryMB() {  
        Runtime rt = Runtime.getRuntime();  
        return (rt.totalMemory() - rt.freeMemory()) / (1024 * 1024);  
    }  
}
```

Kodumuz çalıştı çıktımız şu şekilde oldu:
```json
JJVM Details:  
OpenJDK 64-Bit Server VM  
24  
Oracle Corporation  
Available processors: 8  
Max Memory (MB): 4096  
-----------------------------------  
Warmup starting...  
Warmup done.  
  
=== RUNNING 1000 TASKS ===  
→ Completed 1,000 tasks | Time: 1063 ms | Mem before: 66 MB | Mem after: 4 MB  
  
=== RUNNING 5000 TASKS ===  
Submitted 1000 tasks  
Submitted 2000 tasks  
Submitted 3000 tasks  
Submitted 4000 tasks  
[3.558s][warning][os,thread] Failed to start thread "Unknown thread" - pthread_create failed (EAGAIN) for attributes: stacksize: 2048k, guardsize: 16k, detached.  
[3.558s][warning][os,thread] Failed to start the native thread for java.lang.Thread "Thread-6067"  
Exception in thread "main" java.lang.OutOfMemoryError: unable to create native thread: possibly out of memory or process/resource limits reached  
 at java.base/java.lang.Thread.start0(Native Method)  
 at java.base/java.lang.Thread.start(Thread.java:1417)  
 at java.base/java.lang.System$1.start(System.java:2221)  
 at java.base/java.util.concurrent.ThreadPerTaskExecutor.start(ThreadPerTaskExecutor.java:226)  
 at java.base/java.util.concurrent.ThreadPerTaskExecutor.submit(ThreadPerTaskExecutor.java:264)  
 at java.base/java.util.concurrent.ThreadPerTaskExecutor.submit(ThreadPerTaskExecutor.java:270)  
 at com.mehmetcemyucel.MainPlatformThread.runStep(MainPlatformThread.java:38)  
 at com.mehmetcemyucel.MainPlatformThread.run(MainPlatformThread.java:21)  
 at com.mehmetcemyucel.MainPlatformThread.main(MainPlatformThread.java:9)
```

![Java Thread Performansı](/images/2025-11-04-java-virtual-threads-vs-go-goroutines-project-loom-ve-concurrency-performans-kiyaslamasi/4kjava.png)

Gördüğünüz gibi platform threadlerinde her bir treadin yaratılma maliyeti bizi 4bin civarında thread yaratıldığı anda stack memory anlamında sıkıştırdı, 4GB’lık memory yetersiz kaldı ve daha fazla thread yaratımına çalışılmaya devam edildiği için uygulama crash oldu ve kapandı.

## Java Virtual Thread

Bu kez kodda sadece thread yaratımı yapılan yeri aşağıdaki gibi değiştirdik.
```java
Executors.newThreadPerTaskExecutor(Thread.ofPlatform().factory()) _>>  
Executors.newVirtualThreadPerTaskExecutor()
```
```java
package com.mehmetcemyucel;  
  
import java.util.concurrent.ExecutorService;  
import java.util.concurrent.Executors;  
  
public class MainVirtualThread {  
  
    public static void main(String[] args) throws InterruptedException {  
        new MainVirtualThread().run();  
    }  
  
    private void run() throws InterruptedException {  
        printInfo();  
        warmup();  
  
        // Kademeli artış planı (örnek)  
        long[] steps = {100_000L, 1_000_000L, 5_000_000L, 10_000_000L};  
  
        for (long count : steps) {  
            System.out.println("\n=== RUNNING " + count + " TASKS ===");  
            runStep(count);  
            System.gc(); // her adım sonrası GC tetikle  
            Thread.sleep(2000); // JVM'e nefes arası ver  
        }  
  
        System.out.println("\nAll ramped-up steps completed.");  
    }  
  
    private void runStep(long count) {  
        long starttime = System.currentTimeMillis();  
        long memBefore = usedMemoryMB();  
  
        try (ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor()) {  
            for (int i = 0; i < count; i++) {  
                if (i % 1_000_000 == 0 && i > 0)  
                    System.out.printf("Submitted %d tasks%n", i);  
                executor.submit(() -> {  
                    try {  
                        Thread.sleep(1000);  
                    } catch (InterruptedException e) {  
                        Thread.currentThread().interrupt();  
                    }  
                });  
            }  
        }  
  
        long memAfter = usedMemoryMB();  
        long endtime = System.currentTimeMillis();  
  
        System.out.printf("→ Completed %d tasks | Time: %d ms | Mem before: %d MB | Mem after: %d MB%n",  
                count, (endtime - starttime), memBefore, memAfter);  
    }  
  
    private void warmup() throws InterruptedException {  
        System.out.println("Warmup starting...");  
        try (ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor()) {  
            for (int i = 0; i < 10_000; i++) {  
                executor.submit(() -> {  
                    try {  
                        Thread.sleep(10);  
                    } catch (InterruptedException e) {  
                        Thread.currentThread().interrupt();  
                    }  
                });  
            }  
        }  
        System.out.println("Warmup done.");  
    }  
  
    private static void printInfo() {  
        System.out.println("JVM Details:");  
        System.out.println(System.getProperty("java.vm.name"));  
        System.out.println(System.getProperty("java.version"));  
        System.out.println(System.getProperty("java.vendor"));  
        System.out.println("Available processors: " + Runtime.getRuntime().availableProcessors());  
        System.out.println("Max Memory (MB): " + Runtime.getRuntime().maxMemory() / (1024 * 1024));  
        System.out.println("-----------------------------------");  
    }  
  
    private static long usedMemoryMB() {  
        Runtime rt = Runtime.getRuntime();  
        return (rt.totalMemory() - rt.freeMemory()) / (1024 * 1024);  
    }  
}
```
```json
JVM Details:  
OpenJDK 64-Bit Server VM  
24  
Oracle Corporation  
Available processors: 8  
Max Memory (MB): 4096  
-----------------------------------  
Warmup starting...  
Warmup done.  
  
=== RUNNING 100000 TASKS ===  
→ Completed 100,000 tasks | Time: 1211 ms | Mem before: 37 MB | Mem after: 164 MB  
  
=== RUNNING 1000000 TASKS ===  
→ Completed 1,000,000 tasks | Time: 2374 ms | Mem before: 13 MB | Mem after: 949 MB  
  
=== RUNNING 5000000 TASKS ===  
Submitted 1000000 tasks  
Submitted 2000000 tasks  
Submitted 3000000 tasks  
Submitted 4000000 tasks  
→ Completed 5,000,000 tasks | Time: 11722 ms | Mem before: 19 MB | Mem after: 2393 MB  
  
=== RUNNING 10000000 TASKS ===  
Submitted 1000000 tasks  
Submitted 2000000 tasks  
Submitted 3000000 tasks  
Submitted 4000000 tasks  
Submitted 5000000 tasks  
Submitted 6000000 tasks  
Submitted 7000000 tasks  
Submitted 8000000 tasks  
Submitted 9000000 tasks
```
![Java Virtual Threads Performansı](/images/2025-11-04-java-virtual-threads-vs-go-goroutines-project-loom-ve-concurrency-performans-kiyaslamasi/10mjava.png)

Bu kez farkettiğiniz üzere heap space daha aktif. Stack memory’deki ihtiyacın 1MB’dan 1KB civarına düşmesi daha fazla threadin çalışmaya hazır şekilde bekleyebilmesine olanak sağlıyor. Ama farkettiyseniz thread yaratımı için stack memory’nin düştüğünden bahsetmemize rağmen bizi deli gibi şişiren heap memory. Bunun sebebi virtual thread’in metadatasının, scheduling state’i gibi alanların halen heap’te tutuluyor olması. Ki zaten platform threadlerinde 4bin istekte uygulamamız crash olmuşken burada 9milyon threadi uygulamaya yükleyebildik. Ancak Visual VM görüntüsünün sağ alt tarafına baktığımızda 8.4 milyon Virtual Thread(VT) queue’da çalıştırılmak üzere beklemesine rağmen sadece 8 tanesi gerçek OS threadleri üzerinde çalıştırılabiliyor.

Bekleyen VTler memoryi o kadar doldurmuş durumda ki sürekli Garbage Collector(GC) tetikleniyor. Ancak bekleyen nesnelerin hepsi erişilebilir nesneler, bu sebeple GC memory alanı açamıyor, ya da daha doğrusu birkaç byte açabiliyor. Her bir thread 1sn uyuduğu için de saniyede ancak ~8 byte yer açılabiliyor(bu başlangıç alanları daha da yükselebilir, en iyi senaryoyu örnekliyorum). Yani her saniyede yeni thread çalıştırmak için GC’ye mahrum kalınıyor ama bu sırada yeni VT’ler de memory’e yazılmaya devam ediyor.

Bunun tek bir özeti var, hata alıp kapanmıyor çünkü çalışıyor. Ama öyle bir darboğaza girdi ki yaşayacak kadar nefesi ancak alıyor.

## Go Goroutines

Go’nun default davranışı bulabildiği memory’i kullanmak üzeredir. Bunu engellemek için Go19+’ta kullanabildiğimiz env değişkeni olarak GOMEMLIMIT=4GiB set ederek koşulları eşitliyoruz. Bu kez go kodumuz aynı mantıkla aşağıdaki gibi;

```go
package main  
  
import (  
 "fmt"  
 "github.com/go-echarts/statsview"  
 "runtime"  
 "runtime/debug"  
 "sync"  
 "time"  
)  
  
func main() {  
 mgr := statsview.New()  
 go mgr.Start()  
  
 printInfo()  
 warmup()  
  
 steps := []int{100_000, 1_000_000, 5_000_000, 10_000_000}  
 for _, count := range steps {  
  fmt.Printf("\n=== RUNNING %d TASKS ===\n", count)  
  runStep(count)  
  runtime.GC()  
  time.Sleep(2 * time.Second)  
 }  
  
 fmt.Println("\nAll ramped-up steps completed.")  
}  
  
func printInfo() {  
 fmt.Println("Go Runtime Details:")  
 fmt.Printf("Version: %s\n", runtime.Version())  
 fmt.Printf("NumCPU: %d\n", runtime.NumCPU())  
 fmt.Printf("GOMAXPROCS: %d\n", runtime.GOMAXPROCS(0))  
 var m runtime.MemStats  
 runtime.ReadMemStats(&m)  
 fmt.Printf("Initial Alloc = %v MB\n", m.Alloc/1024/1024)  
  
 memLimit := debug.SetMemoryLimit(-1) // sadece okur, değiştirmez  
 fmt.Printf("Memory Limit: %.2f MB\n", float64(memLimit)/(1024*1024))  
 fmt.Println("-----------------------------------")  
}  
  
func warmup() {  
 fmt.Println("Warmup starting...")  
 var wg sync.WaitGroup  
 for i := 0; i < 10_000; i++ {  
  wg.Add(1)  
  go func() {  
   defer wg.Done()  
   time.Sleep(10 * time.Millisecond)  
  }()  
 }  
 wg.Wait()  
 fmt.Println("Warmup done.")  
}  
  
func runStep(count int) {  
 var memBefore, memAfter runtime.MemStats  
 runtime.ReadMemStats(&memBefore)  
 start := time.Now()  
  
 var wg sync.WaitGroup  
 for i := 0; i < count; i++ {  
  if i%1_000_000 == 0 && i > 0 {  
   fmt.Printf("Started %d goroutines\n", i)  
  }  
  wg.Add(1)  
  go func() {  
   defer wg.Done()  
   time.Sleep(1 * time.Second)  
  }()  
 }  
 wg.Wait()  
  
 runtime.ReadMemStats(&memAfter)  
 duration := time.Since(start)  
  
 fmt.Printf("→ Completed %d tasks | Time: %v | Mem before: %d MB | Mem after: %d MB\n",  
  count,  
  duration,  
  memBefore.Alloc/1024/1024,  
  memAfter.Alloc/1024/1024,  
 )  
}
```
```json
Go Runtime Details:  
Version: go1.25.3  
NumCPU: 8  
GOMAXPROCS: 8  
Initial Alloc = 0 MB  
Memory Limit: 4096.00 MB  
-----------------------------------  
Warmup starting...  
Warmup done.  
  
=== RUNNING 100000 TASKS ===  
→ Completed %!,(int=100000)d tasks | Time: 1.298472791s | Mem before: 4 MB | Mem after: 56 MB  
  
=== RUNNING 1000000 TASKS ===  
→ Completed %!,(int=1000000)d tasks | Time: 2.588294292s | Mem before: 46 MB | Mem after: 475 MB  
  
=== RUNNING 5000000 TASKS ===  
Started 1000000 goroutines  
Started 2000000 goroutines  
Started 3000000 goroutines  
Started 4000000 goroutines  
→ Completed %!,(int=5000000)d tasks | Time: 9.01629775s | Mem before: 342 MB | Mem after: 789 MB  
  
=== RUNNING 10000000 TASKS ===  
Started 1000000 goroutines  
Started 2000000 goroutines  
Started 3000000 goroutines  
Started 4000000 goroutines  
Started 5000000 goroutines  
Started 6000000 goroutines  
Started 7000000 goroutines  
Started 8000000 goroutines  
Started 9000000 goroutines  
→ Completed 10000000 tasks | Time: 15.502655416s | Mem before: 671 MB | Mem after: 1166 MB  
  
All ramped-up steps completed.  
  
Process finished with the exit code 0  
 ```
  
![Goroutines Performansı](/images/2025-11-04-java-virtual-threads-vs-go-goroutines-project-loom-ve-concurrency-performans-kiyaslamasi/10mgo.png)

Biraz daha zorlamak istedim, acaba 10M isteği 100M yapsam görüntüde ne değişirdi acaba

```json
Go Runtime Details:  
Version: go1.25.3  
NumCPU: 8  
GOMAXPROCS: 8  
Initial Alloc = 0 MB  
Memory Limit: 4096.00 MB  
-----------------------------------  
Warmup starting...  
Warmup done.  
...  
...  
...  
Started 99000000 goroutines  
→ Completed 100000000 tasks | Time: 3m1.683121833s | Mem before: 645 MB | Mem after: 1296 MB  
  
All ramped-up steps completed.  
  
Process finished with the exit code 0
```
![Goroutines Performansı](/images/2025-11-04-java-virtual-threads-vs-go-goroutines-project-loom-ve-concurrency-performans-kiyaslamasi/100mgo.png)

Ne oldu da 100Milyon istek biterken yaklaşık 2GB bir memory kullanımı ile bu işi en ufak tekleme olmadan tamamladı? Aslında bu 2 runtime’ın concurrency modellerinin temel felsefelerinin tamamen farklı olmasından kaynaklı.

## Kıyaslama

Detaylarıyla bu kıyaslamayı yapmak gerçekten ayrı bir yazının konusu olabilir. Ama en özet haliyle;

**Java VT:**
- user space’te yönetilen ama os threadlerine 1:1 map edilen thread kullanıyor  
- Context Switchi JVM OS ile birlikte yapıyor  
- Bloklu Thread yönetimi OS seviyesinde yapılıyor  
- GC thread stack taraması heap tabanlı

**Go:** 
- user spacete yönetilen M:N mimarisini kullanıyor  
- Context Switch tamamen runtime’ın kontrolünde  
- Schedular tüm thread managementı kendisi yapıyor  
- GC thread stack taraması M tabanlı (P/M/G mimarisi)

En özetle fark Go’nun tamamen concurrency ve performans üzerine bir mimaride odaklanmış mekanizmalara(user-space concurrency engine) sahip iken Java halen eldekileri daha iyi kullanmaya çalışan(managed kernel-level carrier thread abstraction) bir mimaride çalışmaktadır.

Sonraki yazılarda görüşmek üzere.

Mehmet Cem Yücel

Kaynak:  
[https://wiki.openjdk.org/display/loom/Main](https://wiki.openjdk.org/display/loom/Main)