---
title: "Liskov Substitution Principle (LSP) Nedir? — SOLID'in Üçüncü Adımı"
date: 2025-02-11 12:00:00
categories: [software, principles, solid, youtube, blog, podcast]
tags: [solid, lsp, yazilimm-mimarisi, clean-code, design-patterns, mehmet-cem-yucel]
image: https://img.youtube.com/vi/YM2kcSZo4IM/maxresdefault.jpg
excerpt: "SOLID prensiplerinin üçüncü adımı olan Liskov Substitution Principle (LSP) nedir? Gerçek örneklerle, hatalı kalıtım ilişkilerini nasıl tespit edip doğru soyutlamalarla çözebileceğimizi inceliyoruz."
canonical_url: https://youtu.be/YM2kcSZo4IM
---

Yazının ana kaynağı [YouTube](https://youtu.be/YM2kcSZo4IM) videosudur. Bu içerik AI destekli olarak YouTube videosu temel alınarak oluşturulmuştur.

> “Objects of a superclass should be replaceable with objects of its subclasses without breaking the application.”  
> — Barbara Liskov

Bu yazıda, **SOLID prensiplerinin üçüncü adımı** olan **Liskov Substitution Principle (LSP)**’yi ele alıyoruz.  
Yani: “Child class, parent class’ın yerine geçebilmeli — ve sistemin davranışı bozulmamalı.”

---

## 🧩 LSP Nedir?

LSP der ki:
> Bir sınıfın alt sınıfı, üst sınıfın sözleşmesini (davranışlarını) tam olarak yerine getirebilmelidir.

Eğer bir child sınıf, parent’ın beklenen davranışını **eksik ya da ters** şekilde gerçekleştiriyorsa, sistemde tutarsızlık oluşur.

Bunun klasik örneği: **Kuş problemi.**

```java
class Bird {
    void fly() { ... }
}

class Penguin extends Bird {
    void fly() { throw new UnsupportedOperationException(); }
}
```

Burada `Penguin` bir kuştur ama **uçmaz.**  
Dolayısıyla `Bird` sınıfının `fly()` davranışını yerine getiremiyor.  
Yani `Penguin`, `Bird`’ün yerine geçemediği için **LSP ihlali** meydana geliyor.

---

## 🧱 Bizim Örneğimiz: Order Hiyerarşisi

Bir e-ticaret sisteminde `Order` adında bir sınıf düşünelim.

```java
abstract class Order {
    protected String orderId;
    protected double price;

    abstract void startDelivery();
}
```

Şimdi iki farklı türde siparişimiz var:

```java
class PhysicalOrder extends Order {
    private double desi;

    void startDelivery() {
        System.out.println("Physical shipment started.");
    }
}

class VirtualOrder extends Order {
    private String code;

    void startDelivery() {
        System.out.println("Virtual delivery started via email or SMS.");
    }
}
```

Her iki sınıf da `startDelivery()` metodunu kendi davranışıyla **uygun şekilde** implemente ediyor.  
Yani `Order` yerine `PhysicalOrder` veya `VirtualOrder` kullanıldığında sistemin davranışı **değişmiyor.**  
Bu durumda LSP **sağlanmış** oluyor.

---

## ⚠️ LSP İhlali Ne Zaman Olur?

Eğer alt sınıf, parent’ın beklediği bir davranışı **boş geçerse** veya **desteklemezse**, LSP ihlali ortaya çıkar.

```java
class VirtualOrder extends Order {
    void startDelivery() {
        // hiçbir şey yapmıyor
    }
}
```

Bu durumda `VirtualOrder`, `Order` sözleşmesini tam olarak yerine getirmiyor.  
Kodun bir yerinde “her order gönderilebilir” beklentisi varsa, `VirtualOrder` bu beklentiyi kırar.  
Yani LSP ihlali.

---

## 🧠 Doğru Soyutlama: Interface ile Davranış Ayırımı

Tüm siparişlerin “teslim edilebilir” olması gerekmeyebilir.  
Bu durumda **interface ayrımı** yapabiliriz.

```java
interface Deliverable {
    void startDelivery();
}

class PhysicalOrder extends Order implements Deliverable {
    public void startDelivery() {
        System.out.println("Physical shipment started.");
    }
}

class VirtualOrder extends Order implements Deliverable {
    public void startDelivery() {
        System.out.println("Virtual delivery started via email or SMS.");
    }
}
```

Artık sadece “teslim edilebilir” sınıflar bu interface’i uygular.  
Parent–child ilişkisi **doğal**, tutarlı ve esnektir.

---

## 💡 Pratik İpucu

Eğer bir child sınıfın içinde `if (this instanceof ...)` veya `throw new UnsupportedOperationException()` gibi kontroller görüyorsan, LSP’yi ihlal ediyorsundur.  
Böyle durumlarda kalıtım yerine **interface** veya **composition (bileşim)** kullanmak çok daha sağlıklıdır.

---

## 🎬 Sonuç ve Devam

Bu videoda **Liskov Substitution Principle (LSP)**’yi inceledik.  
Kalıtımın yanlış kullanımıyla nasıl gizli hatalar oluşabileceğini gördük.  
Bir sonraki videoda **Interface Segregation Principle (ISP)** konusuna geçeceğiz.

---

🎥 **Videoyu izlemek istersen:**  

<div class="video-container">
<iframe width="560" height="315" src="https://www.youtube.com/embed/YM2kcSZo4IM?si=SGF44KOaBMe8Uglx" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div>

