---
title:  "MapStruct ile SpringBoot Obje Dönüşümü"
date:   2019-07-16 15:04:23
categories: [java, test, spring spring boot, maven]
tags: [Spring, MapStruct, Mapper, ObjectMapper, Boot, Nasıl yapılır, nedir, Örnek, Nasıl, Mehmet Cem Yücel, Mehmet, Cem, Yücel, Yucel]
image: https://miro.medium.com/max/150/1*9DhTKcVmIApp1AXoGZ4A4A.png
---

Bu yazımızda MapStruct isimli Java Bean Mapper kütüphanesini ve Spring ile kullanımını inceleyeceğiz.
Kodlama yaparken ihtiyaç duyduğumuz bilgileri nesnelerimizin içerisindeki alanlarda tutarız. Nesneye dayalı programlama paradigmasına göre yaptığımız tüm tasarımlar dış dünya ile iletişim noktasına geldiğimizde birebir örtüşmeyebilir. Devraldığınız bir projede tasarladığınız bir POJO(Plain Old Java Object), veritabanındaki varlık modeliyle(ER: Entity Relationship Model) örtüşmeyebileceği gibi dış servislerden aldığınız DTO (Data Transfer Object) nesneler de sizin iç tasarımınızla birebir örtüşmeyecektir. Bu gibi durumlarda birden fazla obje katmanları (entity, DTO, vb..) yaratarak kendi kodumuzu dış dünyanın etkilerinden korumaya çalışırız. Ancak her ihtiyaç duyduğumuzda bu nesneleri birbirlerine dönüştürmek geliştirme maliyeti açısından zaman çalan bir işlemdir.
MapStruct bu ihtiyacımızı derleme zamanında kolayca karşılayan ve bizim için mapper sınıfları yaratan bir kütüphane. Arayüzler aracılığıyla kaynak ve hedef POJO sınıflarının nasıl eşitleneceğini tasarlayabilirsiniz. Başka bir yöntem olarak sadece annotationlar kullanarak Spring ile bu işi nasıl inceleyeceğimizi aşağıda inceleyeceğiz.


Yazının devamı için 
<a style="font-weight:bold" href="https://medium.com/mehmetcemyucel/https-medium-com-mehmetcemyucel-mapstruct-ile-obje-donusumu-c65d697523e8?utm_source=mehmetcemyucel.com&utm_medium=refferal&utm_campaign=blog" target="_blank">tıklayın...</a>

![](https://miro.medium.com/max/800/1*9DhTKcVmIApp1AXoGZ4A4A.png)
