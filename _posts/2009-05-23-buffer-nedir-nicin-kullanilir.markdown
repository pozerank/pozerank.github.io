---
title:  "Buffer Nedir Niçin Kullanılır"
date:   2009-05-23 20:04:23
categories: [hardware, mimari]
tags: [bellek, hardware, buffer, saha, tampon, türkçe, yazılım, blog, blogger, mehmet cem yücel]
---

Buffer (tampon saha), verilerin IO işlemlerinden sonra belleğe yazılmadan önce uğradıkları bir sahadır. Bufferlar IO işlemi sırasında kullanıcının beklemesini engellemek için kullanılırlar. Bellekten okumak ve belleğe yazmak maliyetli bir işlemdir. Sistemi yorar ve hız olarak yavaştır. IO aygıtlarından gelen veriler bu sebeple önce bir havuzda toplanır. Böylece bu havuz belirli miktarlarda dolduktan sonra toplu olarak belleğe yazılır. Bu sisteme performans kazandıran bir harekettir.

{% include feed-ici-yazi-1.html %}

İkinci bir unsur ise tampon sahanın olmadığını düşündüğümüz zaman verilerin yazıldığı veya okunduğu anlarda sistem bununla meşgul olacağı için yeni veri girişiokunması yapılamayacaktır. Bu da kullanıcının beklemesine sebep olacaktır. Buffer bu derdin de dermanı olmuştur çünkü veri yazımı sırasında tampon saha yeni veriler almaya devam edebilecektir. Yani havuz benzetmemizden yola devam edecek olursak, havuz tabanındaki büyük bir musluktan boşaltılırken, yukarıdaki bir musluk da havuzu doldurmaya devam edebilmektedir.

Bu olayı bir örnekle pekiştirelim. Günümüzde neredeyse herkesin artık bir fotoğraf makinesi veya fotoğraf çeken aygıtları vardır. Ortalama çözünürlüklü bir fotoğraf çekildiğini varsayalım. Bu fotoğrafın ortalama boyutu 2,5-4 MB arasında olması beklenir. Bu boyuttaki verinin belleğe alınması da tahmin edileceği gibi uzun bir zaman alacaktır. İşte buffer sayesinde veriler bir taraftan belleğe kaydedilirken diğer taraftan bufferımızın boyutuna göre başka resimler de çekebilme olanağını elde etmiş oluyoruz. Hem zamandan kazanmış oluyoruz hem de arka planda sistemi az sayıda çok miktar verilerle çağırdığımızdan sistemi daha az yormuş oluyoruz.

{% include feed-ici-imaj-2.html %}

Mevcut bufferımızın büyüklüğü ile bizim ardı ardına yapabileceğimiz iş sayısı artış gösterebilmektedir. Bu sebeple bufferın büyüklüğünün fazla olması lehimize bir durumdur.

<div class="PageNavigation">
    <p style="text-align:left; text-decoration: underline;">
        {% if page.previous.url %}
             <a href="{{page.previous.url}}">&laquo; </a>
        {% endif %}
        {% if page.next.url %}
            <span style="float:right; text-decoration: underline;">
                <a href="{{page.next.url}}">DMA Direct Access Memory Nedir? &raquo;</a>
        </span>
        {% endif %}
    </p>
</div>

**_En yalın haliyle_**

[**Mehmet Cem Yücel**](https://www.mehmetcemyucel.com)

---

**_Bu yazılar ilgilinizi çekebilir:_**

- [Bir Yazılımcının Bilmesi Gereken 15 Madde](https://www.mehmetcemyucel.com/2019/bir-yazilimcinin-bilmesi-gereken-15-madde/)
- [Spring Boot Devtools ile Docker Üzerindeki Kodu Debug Etme ve Değiştirme](https://www.mehmetcemyucel.com/2019/spring-boot-devtools-ile-docker-uzerindeki-kodu-debug-etme-ve-degistirme/)
- [Spring Boot Property’lerini Jasypt ile Şifrelemek](https://www.mehmetcemyucel.com/2019/spring-boot-propertylerini-jasypt-ile-sifrelemek/)

**_Blockchain teknolojisi ile ilgileniyor iseniz bunlar da hoşunuza gidebilir:_**

- [BlockchainTurk.net yazıları](https://www.mehmetcemyucel.com/categories/#blockchain)

---
