---
title: "Java'da Aspect Oriented Programming (AOP) ve Decorator Pattern: Adım Adım Örneklerle"
date: 2025-10-23 12:00:00
categories: [java, spring, jvm, design-patterns, spring-boot, microservices, blog]
tags: [aop, spring-boot, decorator-pattern, blog, nasil-yapilir, mehmet-cem-yucel]
image: https://cdn-images-1.medium.com/max/150/0*FkLBCYZHIKTm97it.gif
---

Java ve Spring dünyasında **Aspect Oriented Programming (AOP)** meslekteki ilk yıllarımda bana hep ilginç gelen başlıklardan olmuştu. **AOP** sayesinde metoda bir annotation ekliyorsun, hop metodun çalışmasından önce ve/veya sonra başka özel bir kod çalışıyor. Bu sıradan bir GOTO gibi değil; o metodun tüm giriş ve çıkış noktalarını kontrol edip gerektiğinde düzenleyebileceğiniz tam tabiri caizse o metodu elinde tutan sihir gibi mekanizma sunuyor. Vay be! Bişiy yaparım ben bunla ki!..

![](https://cdn-images-1.medium.com/max/800/0*FkLBCYZHIKTm97it.gif)

Aspect Oriented Programming

Tabi çalıştığınız şirketteki büyükleriniz eğer izin verirse hemen kolları sıvıyorsunuz. İlk iş loglama! Gelen parametreleri ve dönen response’u debug seviyesinde loglara yansıtacak ilk **ASPECT**’inizi yazıyorsunuz.

```java
package com.mehmetcemyucel.aspect;  
  
import org.aspectj.lang.ProceedingJoinPoint;  
import org.aspectj.lang.annotation.*;  
import org.springframework.stereotype.Component;  
  
@Aspect  
@Component  
public class LoggingAspect {  
  
    // Pointcut   
    // com.mehmetcemyucel.service paketi altındaki tüm metodlar  
    @Pointcut("execution(* com.mehmetcemyucel.service.*.*(..))")  
    public void serviceMethods() {}  
  
    // Before Advice   
    @Before("serviceMethods()")  
    public void beforeAdvice() {  
        System.out.println("[Before] Metod çağrılmadan önce çalıştı");  
    }  
  
    // After Advice   
    @After("serviceMethods()")  
    public void afterAdvice() {  
        System.out.println("[After] Metod çağrıldıktan sonra çalıştı");  
    }  
  
    // Around Advice   
    @Around("serviceMethods() && args(username)")  
    public Object aroundAdvice(ProceedingJoinPoint pjp, String username) throws Throwable {  
        System.out.println("[Around] Metoddan önce: username = " + username);  
  
        // Parametreyi değiştirebilirsin  
        String modifiedUsername = username.toUpperCase();  
  
        Object result = pjp.proceed(new Object[]{modifiedUsername});  
  
        System.out.println("[Around] Metoddan sonra: username değiştiyse yeni değer = " + modifiedUsername);  
        return result;  
    }  
}
```
```java
package com.mehmetcemyucel.service;  
  
import org.springframework.stereotype.Service;  
  
@Service  
public class UserService {  
  
    public void createUser(String username) {  
        System.out.println("User created: " + username);  
    }  
  
    public void deleteUser(String username) {  
        System.out.println("User deleted: " + username);  
    }  
}
```

**POINTCUT**’larda hangi metotlara uygulayacağınızı söylüyorsunuz (serviceMethods() ile tüm servislere örneğin). **JOIN POINT**’lerde yani createUser, deleteUser gibi metotlar çağırıldığı noktalarda da **ADVICE**’larınız yani sihiriniz uygulanmaya başlıyor.

![](https://cdn-images-1.medium.com/max/800/0*c9E1grQzinZMi2ly)

Bugün Fırat’tan gidiyoruz :) Neyse loglama tamam, hadi bir de performans takibi yapalım, metotlar ne kadar sürüyor önemli değil mi? Ya yetkilendirmeye ne demeli? Exception handling? Transaction yönetimi de güzel olurdu değil mi, başladık her yeri yatayda değil dikeyde kesen kodlar ile doldurmaya. He olur mu, olur tabi bir engel yok. Tekrar eden süreçleriniz varsa, tabi buyrun. Ancak kodu yönetebilmeye de devam edebilmelisiniz; izleyebilmeli, müdahale edebilmelisiniz. Show must go on! Ee güzel de bu aletin bu sihri nasıl yaptığını bilmeden yaptığınız bunca şeyin size, kodunuza ve performansa etkisini nasıl öngöreceksiniz? Hadi alın çayınızı kahvenizi, magmaya doğru yola çıkıyoruz!

### İhtiyaç

Bir işleve sahip sınıfımız olsun. Bugün kahveler benden:
```java
public class Coffee {  
    public int cost() {  
        return 10;  
    }  
}
``` 

Güzel de ben kahvemi sütlü içiyorum diyenleri duyar gibiyim. Tabi bunun maliyete bir yansıması var. 3 lira fazla alacağım ama bunu mevcut bir sınıfın davranışını genişleterek yapmam lazım, bunun için de genelde inheritance yani kalıtım kullanırız:

```java
public class MilkCoffee extends Coffee {  
    public int cost() {  
        return super.cost() + 3;  
    }  
}
```

İşte halloldu, üst sınıfın costuna gerekli eklemeyi yaptık. Ama bir saniye, karamelsiz içemem diyenleri üzdük! Sanırım Çarşı yavaş yavaş karışıyor çünkü sütlü, karamelli, sütlü karamelli, sade gibi 2^n ihtimal seti kodu şu hale getiriyor:
```java
public class Coffee {  
    public int cost() {  
        return 10;  
    }  
}  
public class MilkCoffee extends Coffee {  
    public int cost() {  
        return super.cost() + 3;  
    }  
}  
public class CaramelCoffee extends Coffee {  
    public int cost() {  
        return super.cost() + 2;  
    }  
}  
public class MilkAndCaramelCoffee extends Coffee {  
    public int cost() {  
        return super.cost() + 5;  
    }  
}
```
Amacım temel davranışa ufak bir şey eklemekti. Aynı yukarıdaki aspect örneğindeki `createUser(..)` servisine bir loglama eklemek gibi. Geldiğimiz yer ise kazanımdan uzaklaştı, hele bir de bir farklı bir şurup vs de eklersek kod üstsel olarak büyümeye devam edecek. Peki bunu nasıl ele alacağız?

### Decorator Pattern

Normalde inheritance kullandığımızda kombinasyonların nasıl hızlıca sonsuza gittiğini gördük. Kalıtım kullanmadan bir nesnenin davranışını dinamik olarak değiştirmek istiyorsak Decorator güzel bir pattern. Bu dinamikliği de yeni sınıf türetmek yerine mevcut nesneyi başka bir nesne ile sararak gerçekleştiriyor. Temel bileşenleri:

-   Component(Arayüz): Ortak davranışı tanımlar
-   ConcreteComponent: Asıl işi yapan sınıf yani yukarıdaki Coffee
-   Decorator: Component arayüzünü uygulayan ve içinde başka bir Component referansı tutan yer
-   ConcreteDecorator: İşte tüm bu dinamikliği yöneten yer.

Gelin koddan bakalım:
```java
// Ortak arayüz yani Component  
interface Coffee {  
    int cost();  
    String description();  
}  
  
// Temel sınıf yani ConcreteComponent  
class SimpleCoffee implements Coffee {  
    public int cost() { return 10; }  
    public String description() { return "Basit kahve"; }  
}  
  
// Decorator  
class CoffeeDecorator implements Coffee {  
    protected Coffee decoratedCoffee;  
    public CoffeeDecorator(Coffee coffee) {  
        this.decoratedCoffee = coffee;  
    }  
    public int cost() { return decoratedCoffee.cost(); }  
    public String description() { return decoratedCoffee.description(); }  
}  
  
// Süt eklentisi  
class MilkDecorator extends CoffeeDecorator {  
    public MilkDecorator(Coffee coffee) {  
        super(coffee);  
    }  
    public int cost() { return super.cost() + 3; }  
    public String description() { return super.description() + ", süt"; }  
}  
  
// Karamel eklentisi  
class CaramelDecorator extends CoffeeDecorator {  
    public CaramelDecorator(Coffee coffee) {  
        super(coffee);  
    }  
    public int cost() { return super.cost() + 2; }  
    public String description() { return super.description() + ", karamel"; }  
}
```
Artık ihtiyacıma göre kahvemi aşağıdaki gibi kurgulayabilirim:
```java
Coffee coffee = new SimpleCoffee();  
coffee = new MilkDecorator(coffee);  
coffee = new CaramelDecorator(coffee);  
  
System.out.println(coffee.description() + " → " + coffee.cost() + "₺");  
  
  
-----------  
Basit kahve, süt, karamel → 15₺
```
Gerçekten tertemiz kod oldu. Şimdi herkesten kahvelerini nasıl istediğini alabilirim.🙃

### Gerçek Hayattan Kesitler

Temel fikri şekerden şerbetten anladığımıza göre gerçek hayat örneğine geçelim:

 ```java
public class SimpleApp {  
    public static void main(String[] args) {  
        SimpleApp app = new SimpleApp();  
        int val1 = app.generateRandomInt1(10, 1);  
        System.out.printf("generateRandomInt1 Generated value: %d\n\n", val1);  
        ///////////////////////////////  
        int val2 = app.generateRandomInt2(10, 1);  
        System.out.printf("generateRandomInt2 Generated value: %d\n\n", val2);  
        ///////////////////////////////  
        int val3 = app.generateRandomInt3(10, 1);  
        System.out.printf("generateRandomInt3 Generated value: %d\n\n", val3);  
    }  
  
    public int generateRandomInt1(int max, int min) {  
        return ThreadLocalRandom.current().nextInt(min, max + 1);  
    }  
  
    public int generateRandomInt2(int max, int min) {  
        System.out.printf("inbound max: %d, min: %d\n", max, min);  
        int val = ThreadLocalRandom.current().nextInt(min, max + 1);  
        System.out.printf("outbound val: %d\n", val);  
        return val;  
    }  
  
    public int generateRandomInt3(int max, int min) {  
        System.out.printf("inbound max: %d, min: %d\n", max, min);  
        long start = System.nanoTime();  
        int val = ThreadLocalRandom.current().nextInt(min, max + 1);  
        long end = System.nanoTime();  
        long duration = end - start;  
        System.out.printf("Execution time: %d nanoseconds%n", duration);  
        System.out.printf("outbound val: %d\n", val);  
        return val;  
    }  
}
``` 
Burada verilen min ve max değerlere göre random değer üreten ve dönen bir `generateRandomInt1` metodumuz var, temel davranışı gerçekleştiriyor.

Eğer biz bu metoda bir loglama ekleyelim, metot her çalıştığında gelen değerler ve üretilen değer loglansın istersek kodumuz `generateRandomInt2` gibi bir şeye dönüşecek.

Bize yetmez bir de bu metotta ne kadar zaman harcandığını görmek istiyorum derseniz buyrun bir de manzaraya `generateRandomInt3` ten bakın…

Tabii ki kimse kodunun bu şekilde olmasını istemez, hele bir de tekrar tekrar aynı davranışı farklı yerlerde kullanabilmeyi istiyorsanız. Gelin Decorator Pattern’i burada uygularsak konu neye evriliyor birlikte bakalım:

```java  
public class SimpleApp {  
  
    // Ortak arayüz yani Component  
    public interface RandomIntGenerator {  
        int generateRandomInt(int max, int min);  
    }  
  
    // Temel sınıf yani ConcreteComponent  
    public static class SimpleRandomIntGenerator implements RandomIntGenerator {  
        @Override  
        public int generateRandomInt(int max, int min) {  
            return ThreadLocalRandom.current().nextInt(min, max + 1);  
        }  
    }  
  
    // Decorator  
    public static abstract class RandomIntGeneratorDecorator implements RandomIntGenerator {  
        protected final RandomIntGenerator decoratedGenerator;  
  
        public RandomIntGeneratorDecorator(RandomIntGenerator generator) {  
            this.decoratedGenerator = generator;  
        }  
  
        @Override  
        public int generateRandomInt(int max, int min) {  
            return decoratedGenerator.generateRandomInt(max, min);  
        }  
    }  
  
    // Loglama eklentisi  
    public static class LoggingRandomIntGenerator extends RandomIntGeneratorDecorator {  
  
        public LoggingRandomIntGenerator(RandomIntGenerator generator) {  
            super(generator);  
        }  
  
        @Override  
        public int generateRandomInt(int max, int min) {  
            System.out.printf("inbound max: %d, min: %d%n", max, min);  
            int val = super.generateRandomInt(max, min);  
            System.out.printf("outbound val: %d%n", val);  
            return val;  
        }  
    }  
    // Performans eklentisi  
    public static class TimingRandomIntGenerator extends RandomIntGeneratorDecorator {  
  
        public TimingRandomIntGenerator(RandomIntGenerator generator) {  
            super(generator);  
        }  
  
        @Override  
        public int generateRandomInt(int max, int min) {  
            long start = System.nanoTime();  
            int val = super.generateRandomInt(max, min);  
            long end = System.nanoTime();  
            long duration = end - start;  
            System.out.printf("Execution time: %d nanoseconds%n", duration);  
            return val;  
        }  
    }  
  
    // Ana uygulama  
    public static void main(String[] args) {  
        RandomIntGenerator generator =  
                new TimingRandomIntGenerator(  
                        new LoggingRandomIntGenerator(  
                                new SimpleRandomIntGenerator()  
                        )  
                );  
  
        int val = generator.generateRandomInt(10, 1);  
        System.out.printf("Generated value: %d%n", val);  
    }  
}  
  
  
------------------------------------  
inbound max: 10, min: 1  
outbound val: 1  
Execution time: 35659167 nanoseconds  
  
Generated value: 1
```

Özellikle main kısmındaki kod dikkatli gözlerden kaçmamıştır diye tahmin ediyorum. Bir yerlerden tanıdık geliyor değil mi:
```java
InputStream in = new BufferedInputStream(new FileInputStream("data.txt"));
``` 

Java’da I/O fonksiyonalitelerini kullanmak için `InputStream`’i nasıl alacağımızı `BufferedInputStream` ve `FileInputStream` ile dekore etmişiz. Harika, **Decorator** mantığını artık tam anlamıyla cebimize koyduk!

### Spring Dünyasında Durum, IoC ve DI

Yazı uzadıkça uzuyor ama bu işi anlatmanın temiz başka bir yolu yok! Hadi devam.

**IoC**, yani **Inversion of Control**(Kontrolün Tersine Çevrilmesi) yazılımımızda nesnelerin yönetimi, nasıl ilkleneceği vb ile ilgili konuları ele alan bir tasarım prensibi. Normalde bir sınıf bağımlı olduğu diğer sınıfları şu şekilde yaratır:

```java
public class UserService {  
    private UserRepository repo = new UserRepository(); // kendisi oluşturuyor  
  
    public void createUser(String name) {  
        repo.save(name);  
    }  
}
```

Tabii burada sıkı sıkıya bağımlı(tight coupling) hale geldiğini söylemeye gerek bile yok. Keza farklı bir `UserRepository` implementasyonu kullanmak ve bu kodu test edebilmek de gerçekçi durmuyor.

IoC prensibinde ise kontrol tersine çevrilir, yani bağımlılığı sınıf yaratmaz. Bu bağımlılık dışarıda yaratılır ve sınıfa iletilir(inject edilir).

```java 
public class UserService {  
    private final UserRepository repo;  
  
    // Bağımlılık dışarıdan veriliyor  
    public UserService(UserRepository repo) {  
        this.repo = repo;  
    }  
  
    public void createUser(String name) {  
        repo.save(name);  
    }  
}  
-----------------------------  
  
// Kullanımı da şu şekilde  
UserRepository repo = new UserRepository();  
UserService service = new UserService(repo);
```

Spring de yukarıdaki hareketi bir IoC Container’ı olarak otomatik yapar. Mülakatlarda hep sorulan **DI**, yani **Dependency Injection**(Bağımlılık Enjeksiyonu/Zerki) Spring’in IoC’yi uygulama şeklidir. Örnek kod da şöyle olur:

```java
@Service  
public class UserService {  
    private final UserRepository repo;  
  
    // bu annotationa gerek bile yok,   
    // hatta tamamen kaldırılacağı konuşuluyor ama   
    // eski günlerin hatrına diyelim :)  
    @Autowired   
    public UserService(UserRepository repo) {  
        this.repo = repo;  
    }  
}
```

Decorator örneğindeki hatırlarsanız nasıl dekore etmek istiyorsak instanceları o şekilde çevreleye çevreleye(wrap) yaratıyorduk. Ee şimdi objelerin yaratımı da Spring’in kontrolünde ise benzer şekilde Spring de aynısını yapabilir değil mi? Cevap: mantık aynı fakat yaklaşım farklı.

### Spring Proxy Nesneleri

Spring IoC container’ı bir `@Bean` oluştururken o nesnede bir AOP referansı olup olmadığını kontrol eder. Yani hepinizin kullandığı `@Transactional` ,`@Cachable` , `@Around` gibi **ADVICE**’lar(yazının başında anlatmıştık değil mi, bu kadar çabuk unutmayın😆) kullanılacaksa o nesnenin yerine bir **Proxy** oluşturur. Yani şöyle bir kodumuz olsun:

```java
@Repository  
public class UserRepository {  
    public void createUser(String name) { ... }  
}

ve buna şu şekilde bir **Aspect** tanımlayalım:

@Aspect  
@Component  
public class LoggingAspect {  
    @Before("execution(* com.mehmetcemyucel.UserRepository.*(..))")  
    public void log() {  
        System.out.println("DB'ye kaydediliyor..");  
    }  
}
```

`UserRepositoy` ‘e bağımlı olan `UserService` bean’i aslında direk repository’nin bir instance’ını değil o instance’ı wrapleyen bir **Proxy** nesnesini servis sınıfına döner. Bu proxy `createUser(...)` çağrımını yakalar, önce loglama aspectini çalıştırır ve sonra gerçek metodu çağırır. Yani sıralama şuna döner:

client → UserRepositoryProxy → (aspect logic) → real UserRepository

### Yeter mi? Yetmez… JDK Dynamic Proxy & CGLIB

Bu kadar geldik, sıkın dişinizi! Size arkadaş ortamında hava atmalık bilgiler veriyorum, yazın kafanıza 😜.

Hani **SOLID** prensiplerinde D-> Dependency Inversion vardı ya. Üst seviye modüller düşük sebiye modüllere bağımlı olmaması gerekiyordu ve biz bu yüzden direk bağlamak yerine bir interface ile bağlıyorduk. Yani şunu kastediyorum:
```java
public interface UserRepository {  
    void createUser(String name);  
}  
  
public class UserRepositoryPostgre implements UserRepository{  
   ...  
}
```


İşte bu durumda Spring proxy yaratmak için `java.lang.reflect.Proxy` sınıfını kullanır ve aşağıdaki gibi bir instance oluşur:
```java
UserRepository proxy = (UserRepository) Proxy.newProxyInstance(  
    classLoader,  
    new Class[]{UserRepository.class},  
    new InvocationHandler() {  
        public Object invoke(Object proxy, Method method, Object[] args) {  
            // Aspect öncesi çalıştırılacak ADVICE  
            Object result = method.invoke(target, args);  
            // Aspect sonrası çalıştırılacak ADVICE  
            return result;  
        }  
    }  
);
```
Yani metodu intercept etmek için kullandığımız her şey reflection ile yapıldı ve baya direk java kütüphanelerini kullandık. Maliyet minimum, gayet native bir kod, şahane!

Ee peki ya interface’imiz yoksa? İşte orada da Spring **CGLIB(Code Generation library) Proxy** kullanır. Yani runtime’da hedef sınıfın alt sınıfı hedef sınıfı override edecek şekilde oluşturulur. Yani baya runtime’da bytecode üretilir, bu bytecode memory’e alınır ve çalıştırılır. Tabii ki interface çağırımına göre daha yavaştır ancak korkulacak bir durum yok, bu bizler tarafından hissedilmeyecek kadar düşük bir süre. Ancak ufak bir memory ve cpu usage olacağının da farkında olmak iyidir.

### Sonuç

Yaa işte, bir Aspect’in kabaca hikayesi bu şekilde. Aspect dedik tasarım paternlerine zıpladık, Spring dedik IoC, DI, Proxyleme konularına değinmeden geçemedik. Ama artık uçtan uca neler yaşandığını biliyoruz. Daha fazlası için takibi unutmayın, [Youtube](https://www.youtube.com/@technicaldebt-tr) kanalıma da beklerim.

Kendinize iyi bakın 🤙

Mehmet Cem Yücel