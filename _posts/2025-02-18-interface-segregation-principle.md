---
title: "Interface Segregation Principle (ISP) Nedir? — SOLID'in Dördüncü Adımı"
date: 2025-02-18 12:00:00
categories: [software, principles, solid, youtube, blog, podcast]
tags: [solid, isp, yazilim-mimarisi, clean-code, design-patterns, mehmet-cem-yucel]
image: https://img.youtube.com/vi/NOJIeu4aTSg/maxresdefault.jpg
excerpt: "SOLID prensiplerinin dördüncü adımı olan Interface Segregation Principle (ISP) nedir? Gerçek bir e-ticaret örneğiyle, esnek ve yeniden kullanılabilir interface tasarımını ele alıyoruz."
canonical_url: https://youtu.be/NOJIeu4aTSg
---

  ***Not:** İçeriğin orjinali ve alternatif dağıtımları hakkındaki bilgiler aşağıda paylaşılmıştır.*
 - *[YouTube](https://youtu.be/NOJIeu4aTSg) (orjinal içerik)*
 - *[Blog]({{ page.url | relative_url }}) (orjinal içerik temelli AI destekli)*
 - *[Podcast](https://open.spotify.com/episode/4sIgD2ffbSCHazsGnMyTgF?si=doWsDsAgSc-eRLGv1VquZw) (orjinal içeriğe ait ses)*

 <iframe data-testid="embed-iframe" style="border-radius:12px" src="https://open.spotify.com/embed/episode/4sIgD2ffbSCHazsGnMyTgF?utm_source=generator" width="100%" height="100" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>

> “Clients should not be forced to depend upon interfaces that they do not use.”  
> — Robert C. Martin

Bu yazıda **SOLID prensiplerinin dördüncü adımı** olan **Interface Segregation Principle (ISP)** konusunu inceliyoruz.  
Yani: Bir sınıf, ihtiyacı olmayan metodları **implement etmek zorunda kalmamalıdır.**

---

## 🧩 ISP Nedir?

Interface Segregation Principle (ISP), yazılımda **interfacerin gereğinden fazla sorumluluk almaması** gerektiğini söyler.

Eğer bir interface içerisinde farklı ve alakasız davranışlar yer alıyorsa, o interface'i kullanan sınıflar bu davranışları implement etmek **zorunda kalır.**  
Bu da **gereksiz bağımlılık** yaratır.

---

## ⚠️ Klasik Örnek: Tek Bir Dev Interface

```java
interface Order {
    void createOrder();
    void cancelOrder();
}
```

Şimdi `PhysicalOrder` ve `VirtualOrder` sınıflarını ele alalım:

```java
class PhysicalOrder implements Order {
    public void createOrder() { ... }
    public void cancelOrder() { ... }
}

class VirtualOrder implements Order {
    public void createOrder() { ... }
    public void cancelOrder() { 
        throw new UnsupportedOperationException("Virtual orders cannot be cancelled.");
    }
}
```

Burada `VirtualOrder`, `Order` interface’ini tam olarak karşılamıyor çünkü “cancel” davranışına sahip değil.  
Yine de interface’te tanımlandığı için **implement etmek zorunda kalıyor**.  
Bu, **Interface Segregation Principle ihlali**dir.

---

## ✅ Doğru Yaklaşım: Küçük ve Odaklı Interface’ler

Davranışları, birbirinden bağımsız küçük interface’lere bölmeliyiz:

```java
interface Creatable {
    void createOrder();
}

interface Cancelable {
    void cancelOrder();
}
```

Artık her sınıf yalnızca ihtiyaç duyduğu interface’leri implement eder:

```java
class PhysicalOrder implements Creatable, Cancelable {
    public void createOrder() { ... }
    public void cancelOrder() { ... }
}

class VirtualOrder implements Creatable {
    public void createOrder() { ... }
}
```

Bu yapı sayesinde `VirtualOrder`, yalnızca **oluşturulabilir (Creatable)** bir sipariştir,  
ama **iptal edilemez (Cancelable)** bir sipariş değildir.  
Kod daha sade, daha doğru ve daha güvenlidir.

---

## 🧠 ISP’nin Faydaları

- Gereksiz bağımlılıklar ortadan kalkar.  
- Sınıflar yalnızca kendi işine yarayan davranışları implement eder.  
- Kod daha **esnek, okunabilir ve test edilebilir** hale gelir.  
- Yeni interface eklemek, mevcut yapıyı bozmaz.  

---

## 🧱 Örnek: E-Ticaret Senaryosu

Bir `Order` sistemi düşünelim:  
- Fiziksel siparişler kargolanır ve iptal edilebilir.  
- Sanal siparişler (örneğin bir hediye kodu), gönderildikten sonra **iptal edilemez.**  

Bu durumda `Cancelable` davranışını ayırmak doğru yaklaşımdır.

```java
interface Creatable {
    void createOrder();
}

interface Cancelable {
    void cancelOrder();
}

class PhysicalOrder implements Creatable, Cancelable {
    public void createOrder() { System.out.println("Order created."); }
    public void cancelOrder() { System.out.println("Order cancelled."); }
}

class VirtualOrder implements Creatable {
    public void createOrder() { System.out.println("Virtual order created."); }
}
```

Artık sınıflar yalnızca gerçekten sahip oldukları davranışları uygular.  
Gereksiz metotlar yok, `UnsupportedOperationException` yok.

---

## 🎬 Sonuç ve Devam

Bu videoda **Interface Segregation Principle (ISP)**’yi inceledik.  
Bir interface’in çok fazla sorumluluk taşımasının nasıl bağımlılık ve karmaşıklık yarattığını gördük.  
Bir sonraki videoda SOLID’in son adımı olan **Dependency Inversion Principle (DIP)** üzerine konuşacağız.


---

🎥 **Videoyu izlemek istersen:**  
<div class="video-container">
<iframe width="560" height="315" src="https://www.youtube.com/embed/NOJIeu4aTSg?si=3YfcwPhcWI0HFNfm" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div>
