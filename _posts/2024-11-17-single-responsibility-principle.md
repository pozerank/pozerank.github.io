---
title: "Single Responsibility Principle (SRP) Nedir? — SOLID'in İlk Adımı"
date: 2024-11-17 12:00:00 
categories: [software, principles, solid, youtube, blog]
tags: [solid, srp, yazilim-mimarisi, clean-code, mehmet-cem-yucel]
image: https://img.youtube.com/vi/ZUBrL_b12xM/maxresdefault.jpg
excerpt: "SOLID prensiplerinin ilk adımı olan Single Responsibility Principle'ı (SRP) gerçek bir örnekle açıklıyorum. Neden önemlidir, yanlış uygulandığında neler olur ve doğru kurgulamak kod mimarisini nasıl değiştirir?"
canonical_url: https://www.youtube.com/watch?v=ZUBrL_b12xM
---

> “Bir sınıfın yalnızca tek bir sorumluluğu olmalı.”  
> — Robert C. Martin (Uncle Bob)

Bu yazıda, SOLID prensiplerinin ilk adımı olan **Single Responsibility Principle (SRP)** konusunu ele alıyoruz.  Yazının ana kaynağı [YouTube](https://www.youtube.com/watch?v=ZUBrL_b12xM) videosudur. Bu içerik AI destekli olarak YouTube videosu temel alınarak oluşturulmuştur.

Eğer yazılım projelerinde modülerlik, test edilebilirlik ve sürdürülebilirlik hedefliyorsan, bu prensip seni doğrudan ilgilendiriyor.

---

## 🎯 SOLID Prensipleri Neden Var?

SOLID prensipleri yazılım geliştirme sürecinde bizi **daha düzenli, modüler ve ölçeklenebilir kodlar** yazmaya yönlendirir.  
Her bir madde, kodun:

- **Gelişmeye açık, değişime kapalı** kalmasını,  
- **Bağımsız bileşenlerden** oluşmasını,  
- **Bakımı kolay ve test edilebilir** bir yapıya sahip olmasını amaçlar.

Böylece hem tek başına hem de ekiple çalışırken yazdığın kodun ömrü uzar,  
hatayı bulmak ve düzeltmek çok daha kolay hale gelir.

---

## 🧱 Single Responsibility Principle (SRP) Nedir?

**Single Responsibility Principle (SRP)**, adından da anlaşılacağı üzere her sınıfın **tek bir sorumluluğu** olmasını söyler.

> “Bir sınıfın değişmesi için yalnızca bir nedeni olmalıdır.”

Bu, bir sınıfın yalnızca **tek bir iş yapması** gerektiği anlamına gelir.  
Bu sayede kodun:

- Okunabilirliği artar,  
- Yönetimi kolaylaşır,  
- Nerede hangi davranışı arayacağını tahmin etmek kolaylaşır.

---

## 🧩 Yanlış Uygulama: Her Şeyi Yapan Tek Servis

```java
class OrderService {

    void processOrder() {
        createOrder();
        createInvoice();
        sendEmail();
        generateReport();
    }

    void createOrder() {
        // Sipariş oluşturma işlemleri
    }

    void createInvoice() {
        // Fatura oluşturma işlemleri
    }

    void sendEmail() {
        // E-posta gönderimi
    }

    void generateReport() {
        // Rapor oluşturma işlemleri
    }
}
```

Bu yapı başlangıçta basit görünse de, zamanla **tek bir sınıfa birden fazla sorumluluk yüklediği için**:
- Kod karmaşıklaşır,  
- Değişiklik yapmak riskli hale gelir,  
- Yeni özellikler eklemek mevcut davranışları bozabilir.

---

## ✅ Doğru Yaklaşım: Her Sınıfın Tek Bir Sorumluluğu Olmalı

```java
class OrderProcessor {
    void process(Order order) {
        // Siparişi işleme al
    }
}

class InvoiceService {
    void createInvoice(Order order) {
        // Fatura oluşturma işlemleri
    }
}

class EmailService {
    void sendInvoiceEmail(Invoice invoice) {
        // Fatura e-postası gönder
    }
}

class ReportGenerator {
    void generateReport(Order order) {
        // Rapor oluşturma işlemleri
    }
}
```

Artık:
- **OrderProcessor** sadece sipariş sürecinden,  
- **InvoiceService** fatura oluşturma işinden,  
- **EmailService** iletişimden,  
- **ReportGenerator** raporlamadan sorumlu.

Bu sayede kod:  
✔️ Daha okunabilir  
✔️ Daha modüler  
✔️ Daha kolay test edilebilir hale gelir.  

---

## ⚙️ Neden Bu Kadar Önemli?

SRP, kodun **uzun ömürlü olmasının temelidir.**  
Bir sınıfa gereğinden fazla sorumluluk yüklersen:

- Değişiklik yapmak zorlaşır,  
- Yeni gereksinimler mevcut davranışları kırar,  
- Test yazmak zaman alır,  
- Hatalar gizlenir, bakım maliyeti artar.

Ancak tek sorumluluğa sahip sınıflarla:

✅ Hataları daha hızlı izole edebilirsin  
✅ Değişiklikler minimum etkiyle yapılır  
✅ Kodun *“neden değiştiğini”* kolayca takip edebilirsin

---

## 🧠 Tasarım Desenleriyle Bağlantısı

SRP uygulandığında **tasarım desenlerini** (Design Patterns) uygulamak da kolaylaşır.  
Örneğin:
- **Strategy pattern** ile email yerine SMS veya push notification geçişini kolaylaştırabilirsin.  
- **Factory pattern** ile farklı order tipleri yaratabilirsin.  
- **Observer pattern** ile yeni bir “raporlama servisini” sisteme ekleyebilirsin.

Hepsi, temelinde **SRP’nin sağladığı modüler yapı** sayesinde mümkündür.

---

## 🎬 Sonuç ve Devam

Bu videoda SOLID prensiplerinin ilk adımı olan **Single Responsibility Principle (SRP)**’yi ele aldık.  
Bir sonraki bölümde SOLID’in ikinci adımı olan **Open/Closed Principle (OCP)** üzerinden aynı örnekle devam edeceğiz.

---

🎥 **Videoyu izlemek istersen:**  

<div class="video-container">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/ZUBrL_b12xM?si=wrEFO72Ww-w2L0_q" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div>
