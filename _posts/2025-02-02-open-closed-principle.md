---
title: "Open/Closed Principle (OCP) Nedir? — SOLID'in İkinci Adımı"
date: 2025-02-02 12:00:00
categories: [software, principles, solid, youtube, blog]
tags: [solid, ocp, yazilim-mimarisi, clean-code, design-patterns, mehmet-cem-yucel]
image: https://img.youtube.com/vi/jZZhHxzoU10/maxresdefault.jpg
excerpt: "SOLID prensiplerinin ikinci adımı olan Open/Closed Principle (OCP) nedir, neden önemlidir ve gerçek bir örnekle nasıl uygulanır? Kodunuzu değiştirmeden genişletebilmeyi öğrenin."
canonical_url: https://youtu.be/jZZhHxzoU10
---

> “Software entities should be open for extension, but closed for modification.”  
> — Bertrand Meyer

Yazının ana kaynağı [YouTube](https://youtu.be/jZZhHxzoU10) videosudur. Bu içerik AI destekli olarak YouTube videosu temel alınarak oluşturulmuştur.

Bu yazıda **SOLID prensiplerinin ikinci adımı** olan **Open/Closed Principle (OCP)** konusunu ele alıyoruz.  
Kısaca: Kodunuzu *değiştirmeden* yeni davranışlar ekleyebilmek.

---

## 🎯 Hatırlatma: SRP ile Başlamıştık

Önceki yazıda **Single Responsibility Principle (SRP)**’yi incelemiş, bir e-ticaret sistemi örneği üzerinden kodumuzu tek sorumluluğa sahip sınıflara bölmüştük:

- `OrderProcessor` siparişi yönetiyordu,  
- `InvoiceService` faturayı oluşturuyordu,  
- `EmailService` bildirim gönderiyordu,  
- `ReportGenerator` raporlamayı üstleniyordu.

Ancak bu hâl hâlâ *mükemmel değil*. Yeni bir iletişim kanalı (örneğin SMS veya Push Notification) eklemek istesek, bazı yerlerde kodu **değiştirmemiz gerekir**.  
İşte OCP burada devreye giriyor.

---

## 🧱 OCP Nedir?

**Open/Closed Principle**, yazılım bileşenlerinin:

- **Yeni davranışlar eklemeye açık (open for extension)**,  
- **Mevcut kodu değiştirmeye kapalı (closed for modification)**  

olması gerektiğini söyler.

Yani yeni bir gereksinim geldiğinde, var olan sınıfı değiştirmek yerine **yeni bir sınıf** eklemelisin.

---

## ⚠️ Sorun: Kodun Değişmesi Gerekiyor

```java
class InvoiceService {
    private final EmailService emailService;

    public InvoiceService(EmailService emailService) {
        this.emailService = emailService;
    }

    public void sendInvoice(Order order) {
        emailService.send(order);
    }
}
```

Bu haliyle **InvoiceService** doğrudan **EmailService**’e bağımlı.  
Yarın “SMS gönder” veya “Push Notification gönder” dersen, `sendInvoice()` metodunu değiştirmek zorundasın.

Kodun içine “if (sms) … else if (push)” gibi koşullar eklemeye başlarsan — **OCP ihlal edilir.**

---

## ✅ Çözüm: Ortak Bir Arayüz (Interface) ile Davranışı Ayırmak

Tüm bildirim servislerinin (email, sms, push) ortak bir davranışı var: **Notify etmek.**  
Bu davranışı soyutlayarak `Notifiable` adında bir interface tanımlayabiliriz.

```java
interface Notifiable {
    void notify(Order order);
}
```

Her iletişim kanalı bu interface’i uygular:

```java
class EmailService implements Notifiable {
    public void notify(Order order) {
        System.out.println("Sending Email...");
    }
}

class SMSService implements Notifiable {
    public void notify(Order order) {
        System.out.println("Sending SMS...");
    }
}

class PushNotificationService implements Notifiable {
    public void notify(Order order) {
        System.out.println("Sending Push Notification...");
    }
}
```

Ve artık `InvoiceService` yalnızca bu interface’i bilir:

```java
class InvoiceService {
    private final Notifiable notifier;

    public InvoiceService(Notifiable notifier) {
        this.notifier = notifier;
    }

    public void sendInvoice(Order order) {
        notifier.notify(order);
    }
}
```

Yeni bir bildirim yöntemi eklemek mi istiyorsun?  
Yeni bir sınıf oluşturup `Notifiable`’ı implement etmen yeterli.

Kodun geri kalanına **tek satır bile dokunmazsın.**

---

## ⚙️ Daha Esnek Bir Adım: Strateji Patterni

OCP’nin en güçlü destekçisi **Design Patternlerdir.**  
Burada **Strategy Pattern** kullanarak hangi bildirim stratejisinin çalışacağını **runtime**’da belirleyebilirsin.

```java
public class NotificationStrategyFactory {
    public static Notifiable create(String strategyName) {
        try {
            Class<?> clazz = Class.forName(strategyName);
            if (!Notifiable.class.isAssignableFrom(clazz)) {
                throw new IllegalArgumentException("Invalid Notifiable type: " + strategyName);
            }
            return (Notifiable) clazz.getDeclaredConstructor().newInstance();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
```

Ve main metodunda:

```java
public static void main(String[] args) {
    String notifierClass = "com.technicaldebt.SMSService"; // runtime'da alınabilir
    Notifiable notifier = NotificationStrategyFactory.create(notifierClass);
    InvoiceService invoiceService = new InvoiceService(notifier);

    invoiceService.sendInvoice(new Order());
}
```

Artık hangi bildirimin gönderileceğini kodu değiştirmeden belirleyebilirsin.

Sadece runtime argümanını değiştir:  
`EmailService` → `SMSService` → `PushNotificationService`  
ve sistem dinamik olarak genişler.

---

## 🧠 Tasarım Desenleriyle Bağlantısı

OCP, yazılım mimarisinde **değişimden etkilenmeyen esneklik** sağlar.  
Design pattern’ler bu ilkenin pratik araçlarıdır:

- **Strategy Pattern:** Dinamik davranış seçimi  
- **Factory Pattern:** Nesne yaratımında soyutlama  
- **Decorator Pattern:** Davranışı genişletme  
- **Observer Pattern:** Yeni tepkiler ekleme  

Hepsi OCP’nin felsefesini destekler: *Var olan kodu değiştirmeden genişletebilmek.*

---

## 🎬 Sonuç ve Devam

Bu yazıda **Open/Closed Principle (OCP)**’yi inceledik.  
Yeni davranışları mevcut sistemi bozmadan nasıl ekleyebileceğimizi gördük.

Bir sonraki yazıda SOLID’in üçüncü adımı olan **Liskov Substitution Principle (LSP)** üzerine konuşacağız.

---

🎥 **Videoyu izlemek istersen:**  

<div class="video-container">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/jZZhHxzoU10?si=2DCLDGbt6zBmv2PC" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div>
