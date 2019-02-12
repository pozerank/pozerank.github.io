---
title:  "Buffer Nedir Niçin Kullanılır"
date:   2009-05-23 20:04:23
categories: [hardware, mimari]
tags: [bellek, hardware, buffer, kullanılır, nedir, niçin, saha, tampon, Mehmet Cem Yücel, Mehmet, Cem, Yucel, Yücel]
---

Buffer (tampon saha), verilerin IO işlemlerinden sonra belleğe yazılmadan önce uğradıkları bir sahadır. Bufferlar IO işlemi sırasında kullanıcının beklemesini engellemek için kullanılırlar. Bellekten okumak ve belleğe yazmak maliyetli bir işlemdir. Sistemi yorar ve hız olarak yavaştır. IO aygıtlarından gelen veriler bu sebeple önce bir havuzda toplanır. Böylece bu havuz belirli miktarlarda dolduktan sonra toplu olarak belleğe yazılır. Bu sisteme performans kazandıran bir harekettir.  
  
İkinci bir unsur ise tampon sahanın olmadığını düşündüğümüz zaman verilerin yazıldığı veya okunduğu anlarda sistem bununla meşgul olacağı için yeni veri girişiokunması yapılamayacaktır. Bu da kullanıcının beklemesine sebep olacaktır. Buffer bu derdin de dermanı olmuştur çünkü veri yazımı sırasında tampon saha yeni veriler almaya devam edebilecektir. Yani havuz benzetmemizden yola devam edecek olursak, havuz tabanındaki büyük bir musluktan boşaltılırken, yukarıdaki bir musluk da havuzu doldurmaya devam edebilmektedir.  
  
Bu olayı bir örnekle pekiştirelim. Günümüzde neredeyse herkesin artık bir fotoğraf makinesi veya fotoğraf çeken aygıtları vardır. Ortalama çözünürlüklü bir fotoğraf çekildiğini varsayalım. Bu fotoğrafın ortalama boyutu 2,5-4 MB arasında olması beklenir. Bu boyuttaki verinin belleğe alınması da tahmin edileceği gibi uzun bir zaman alacaktır. İşte buffer sayesinde veriler bir taraftan belleğe kaydedilirken diğer taraftan bufferımızın boyutuna göre başka resimler de çekebilme olanağını elde etmiş oluyoruz. Hem zamandan kazanmış oluyoruz hem de arka planda sistemi az sayıda çok miktar verilerle çağırdığımızdan sistemi daha az yormuş oluyoruz.  
  
Mevcut bufferımızın büyüklüğü ile bizim ardı ardına yapabileceğimiz iş sayısı artış gösterebilmektedir. Bu sebeple bufferın büyüklüğünün fazla olması lehimize bir durumdur.