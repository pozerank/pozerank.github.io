---
title: "Dependency Inversion Principle (DIP) Nedir? — SOLID'in Beşinci ve Son Adımı"
date: 2025-02-27 12:00:00
categories: [software, principles, solid, youtube, blog, podcast]
tags: [solid, dip, dependency-inversion, yazilim-mimarisi, clean-code, design-patterns,  mehmet-cem-yucel]
image: https://img.youtube.com/vi/79UltiA5DCs/maxresdefault.jpg
excerpt: "SOLID prensiplerinin son adımı olan Dependency Inversion Principle (DIP) nedir? Katmanlı mimarilerde bağımlılık yönünü tersine çevirerek esnek ve sürdürülebilir sistemler tasarlamayı öğreniyoruz."
canonical_url: https://youtu.be/79UltiA5DCs
---


  ***Not:** İçeriğin orjinali ve alternatif dağıtımları hakkındaki bilgiler aşağıda paylaşılmıştır.*
 - *[YouTube](https://youtu.be/79UltiA5DCs) (orjinal içerik)*
 - *[Blog]({{ page.url | relative_url }}) (orjinal içerik temelli AI destekli)*
 - *[Podcast]({{ page.url | relative_url }}) (orjinal içeriğe ait ses)*


> “High-level modules should not depend on low-level modules. Both should depend on abstractions.”  
> — Robert C. Martin

Bu yazıda **SOLID prensiplerinin son adımı** olan **Dependency Inversion Principle (DIP)** konusunu inceliyoruz.  
Yani: **Bağımlılık yönünü tersine çevirerek** esnek ve sürdürülebilir bir mimari kurmak.

---

## 🧩 DIP Nedir?

Klasik bir sistemde üst seviye (high-level) sınıflar, alt seviye (low-level) sınıflara doğrudan bağımlıdır.  
Bu durumda, alt katmandaki bir değişiklik yukarıdaki katmanları da etkiler.

DIP der ki:  
> Üst seviye modüller, alt seviye modüllere değil, **soyutlamalara (interfaces)** bağımlı olmalıdır.

---

## ⚠️ Sorun: Doğrudan Bağımlılık

```java
class ReportRepository {
    public String generateOrderReport() {
        return "Order Report generated.";
    }
}

class ReportService {
    private final ReportRepository reportRepository;

    public ReportService(ReportRepository reportRepository) {
        this.reportRepository = reportRepository;
    }

    public void printReport() {
        System.out.println(reportRepository.generateOrderReport());
    }
}
```

Burada `ReportService`, doğrudan `ReportRepository` sınıfına bağımlı.  
Yarın farklı bir veri kaynağı (örneğin Redis, MongoDB, PostgreSQL) kullanmak istersen, `ReportService`’i değiştirmek zorundasın.  
Bu da DIP ihlali anlamına gelir.

---

## ✅ Çözüm: Abstraction (Interface) ile Bağımlılığı Tersine Çevir

DIP’nin temel fikri: **Detaylar soyutlamaya bağlı olmalı, soyutlamalar detaya değil.**

```java
interface ReportRepository {
    String generateOrderReport();
}

class PostgresReportRepository implements ReportRepository {
    public String generateOrderReport() {
        return "PostgreSQL report generated.";
    }
}

class RedisReportRepository implements ReportRepository {
    public String generateOrderReport() {
        return "Redis report generated.";
    }
}
```

Ve artık `ReportService` doğrudan bir sınıfa değil, **interface’e bağımlı:**

```java
class ReportService {
    private final ReportRepository repository;

    public ReportService(ReportRepository repository) {
        this.repository = repository;
    }

    public void printReport() {
        System.out.println(repository.generateOrderReport());
    }
}
```

Bu yapı sayesinde `ReportService` hangi repository’nin kullanıldığını **bilmek zorunda değil.**  
Sadece `ReportRepository` arayüzünü tanıyor.  
Yani bağımlılık yönü **tersine çevrilmiş oldu.**

---

## 🔁 Katmanlı Mimaride DIP

Katmanlı bir mimaride ideal bağımlılık yönü:

```
Controller  →  Service  →  Interface  ←  Repository Implementation
```

Servis, doğrudan repository’ye değil, **repository interface’ine** bağımlıdır.  
Repository implementasyonu da bu interface’i uygular.  
Böylece iki katman arasındaki bağ **zayıf (loosely coupled)** hale gelir.

---

## 🧠 DIP ve IoC (Inversion of Control)

DIP genellikle **IoC (Inversion of Control)** ve **Dependency Injection (DI)** kavramlarıyla birlikte kullanılır.  
Örneğin Spring veya Guice gibi frameworkler, bağımlılıkları constructor üzerinden otomatik olarak enjekte eder:

```java
@Service
public class ReportService {
    private final ReportRepository repository;

    @Autowired
    public ReportService(ReportRepository repository) {
        this.repository = repository;
    }
}
```

Artık hangi repository implementasyonunun kullanılacağına framework karar verir — sen değil.  
Bu da sistemin test edilebilirliğini ve esnekliğini büyük ölçüde artırır.

---

## 🧱 Gerçek Hayattan Analogi

Bir elektrikli cihazın prize takılan kablosunu düşün.  
Cihaz, prizde ne tür bir enerji altyapısı olduğunu bilmez — sadece **bir arayüz (interface)** üzerinden enerji alır.  
Aynı şekilde, sisteminin üst katmanları da alt katmanların detaylarına bağlı olmamalıdır.

---

## 🎬 Sonuç ve Serinin Sonu

Bu videoda **Dependency Inversion Principle (DIP)**’i inceledik.  
Yüksek seviyeli modüllerin, düşük seviyeli detaylardan bağımsız olmasının neden hayati olduğunu gördük.

Böylece SOLID prensiplerinin beşini de tamamlamış olduk 🎯  
Artık elinizde sürdürülebilir, genişletilebilir ve bakımı kolay sistemler kurmak için güçlü bir temel var.

---

🎥 **Videoyu izlemek istersen:**  
<div class="video-container">
<iframe width="560" height="315" src="https://www.youtube.com/embed/79UltiA5DCs?si=GzFqpIto91BRxlBy" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div>