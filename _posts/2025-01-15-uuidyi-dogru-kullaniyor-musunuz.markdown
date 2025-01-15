---
title:  "UUID'yi Doğru Kullanıyor Musunuz?"
date:   2025-01-15 12:00:00
categories: [architecture, microservices]
tags: [uuid, uuid v4, uuid v7, collision, entropi, entropy, determinism, determinizm, nasıl yapılır, technical, debt, technicaldebt, mehmetcemyucel, türkçe, mehmet cem yücel]
image: https://miro.medium.com/v2/resize:fit:150/1*D2iR6MW3V6qPekeo18WuBQ.png
---

# Giriş

Hepimizin unique bir ID gereksinimi duyduğumuzda sığındığımız güvenilir liman UUID’ler. Peki UUID’nin 7 farklı versiyonu olduğunu ve hepsinin farklı konulara göre özel çözümler sunduğunu biliyor musunuz? Gelin birlikte inceleyelim.

![](https://miro.medium.com/v2/resize:fit:700/1*D2iR6MW3V6qPekeo18WuBQ.png)

# UUID Kırılımları

Type | Version | Description 
:---: | :---: | ---
**Timestamp + MAC** | `v1` `v2` `v6` | Zaman Damgası + MAC Adresine ek bazı bilgiler
**Random** | `v4` | Tamamen Gelişigüzel
**Namespace** | `v3` `v5` | Namespace ve ek bir bilgi ile üretilen hash fonksiyonu örneği
**Hybrid** | `v7` | Timestamp + Random kombinasyonu

# Timestamp + MAC (UUID v1, UUID v2, UUID v6)

Bu versiyonlarda Zaman Damgası kullanılarak bir unique id üretilmeye çalışılır. Nanosaniye seviyesinde bile olsa dünyanın üzerinde herhangi başka bir makinede aynı zamana denk gelebilecek başka bir yaratım söz konusu olabileceği için bu ihtimali azaltmak üzere MAC adresi de eklenerek ihtimal uzayı daraltılır. Farklı versiyonlarda farklı bilgiler daha eklenir, sıralı olarak id yaratımı mümkün olabilir(v6).

# Random (UUID v4)

Bu yöntemde herhangi bir input yoktur, doğrudan rastgele olarak UUID yaratımı yapılır. Bu da sıralılık avantajını kaybetmeye sebep olur. Yeterli entropi şartlarında oldukça geniş bir sonuç uzayına sahip olduğu için güvenle kullanılabilir.

# Namespace (UUID v3 MD5, UUID v5 SHA-1)

Belirli bir namespace ve verilen ekstra bir input değeri ile birlikte hash fonksiyonlarından geçirilerek üretilen UUID örneğidir. Avantajı, verdiğiniz aynı input değerleri için her zaman aynı output’u üretecektir. Sıralı değildir. Dikkat edilmesi gereken nokta, yeterince geniş bir output uzayına sahipseniz kullanılan hash fonksiyonlarından sebepli verdiğiniz inputlar tahmin edilebilir hale gelecektir. Bu sebeple hassas verilerle UUID üretimi yapılmamalıdır.

# Hybrid (UUID v7)

Random ve Timestamp yöntemlerinin kombinasyonu ile UUID üretimini ifade eder. Birçok modern veritabanında bu yöntem kullanılmaktadır.

# Ek Detaylar

Aşağıdaki videoda  **ID**,  **Unique ID**,  **Universally Unique ID**  kavramlarını ve ayrıca:

- UUID Çözüm Uzayı
- Entropi
- Collision
- UUID Versiyonları Detayları
- Farklı versiyonların kod örnekleri gibi bir çok ekstra konuyu inceledik. İlgileniyorsanız göz atabilirsiniz.

![# UUID ve GUID Versiyonları Hakkında Bilmedikleriniz! Gerçekten Unique Mi, Nasıl Çalışır, Güvenli Mi?](https://img.youtube.com/vi/CJ_8Cd8WxyI/0.jpg)](https://www.youtube.com/watch?v=CJ_8Cd8WxyI "UUID ve GUID Versiyonları Hakkında Bilmedikleriniz! Gerçekten Unique Mi, Nasıl Çalışır, Güvenli Mi?")

# Sonuç

Farkında olmadan kullanılan hatalı versiyon UUID’ler gerek güvenlik, gerek performans gerek ise sıralılık gibi avantajları ıskalamak açılarından yazılımımızı etkileyecektir. “One Fit Size All” yaklaşımından sıyrılıp ihtiyaca yönelik yöntemi kullanmak her zaman daha doğru bir tercih olacaktır.

En yalın haliyle
