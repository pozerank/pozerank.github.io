---
title:  "DMA Direct Access Memory Nedir"
date:   2017-12-25 20:04:23
categories: [hardware, mimari]
tags: [dma, hardware, direct, access, memory, kullanılır, nedir, niçin, Mehmet Cem Yücel, Mehmet, Cem, Yucel, Yücel]
---

DMA( Direct Access Memory), bellek ile diğer aygıtlar arasındaki veri iletişimi için kullanılan bir yapıdır. Avantajı, bu veri iletişimini sağlarken merkezi işlem birimini kısmen devre dışı bırakarak veri akışını hızlandırmak ve merkezi işlem birimini daha az meşgul etmektir. Böylece merkezi işlem birimi veri akışında temel unsur olmaktan çıkıp diğer süreçlere fırsat tanıyabilecek, öbür taraftan veri akışı da daha kısa bir yol dolaşmış olacağından dolayı hızlanmış olacaktır.  
  
Bir örnekle açıklamak gerekirse, örneğin oyun oynarken bilgisayarımız görüntü aygıtlarını donanımsal olarak kullanacaktır. Oyun çalışma zamanında bellekten çalışacak ve görüntülerin ekranda oluşması için sürekli ekran kartıyla iletişim içerisinde olması gerekecektir. Böyle bir durumda bellek ile ekran kartı arasında veri paylaşımı, sürekli giden ve gelen paketler sistemi yoracaktır. Bellek bir veriye ihtiyacı olduğu anda merkezi işlem birimi aracılığıyla bunu ekran kartına iletmeli, ekran kartımız da cevabını aynı yolla belleğe göndermelidir. Bu durumda merkezi işlem biriminin fazlasıyla meşgul olacağı aşikârdır. Meşgul olan merkezi işlem birimi diğer süreçlere fırsat tanıyamayacağı için süreçler beklemede kalacak, bu işlerin gecikmesine ve sistemin şişmesine sebep olacaktır. Tabii ki bu da istenen bir durum değildir.  
  
İşte bu durumu engellemek için DMA yaklaşımı öne sürülmüştür. Bu yaklaşımda temel amaç veri transferi sırasında merkezi işlem birimini aradan çıkartmaktır. Normal bir veri akışında veride hiçbir işlem yapılmayacak olsa bile merkezi işlem birimine uğrayan veriler bu yaklaşımda doğrudan bellek ile aygıt arasında kurulan bir yolda ilerleyeceklerdir. Peki, bu yoldan merkezi işlem biriminin haberi olmayacak mı?  
  
İşlemin gerçekleşişi şöyledir;  
  
-Bellekten veya belleğe veri transferi isteği doğar.  
-Bu transfer isteği veri akış bilgileriyle birlikte(veri uzunluğu, nereden nereye gittiği, hangi hızda transfer edileceği gibi) merkezi işlem birimine iletilir.  
-Merkezi işlem birimi aldığı istek ve isteğin verileri doğrultusunda DMA’ya veri akışının başlatılması için emir verir.  
-Veri akışı bittiğinde akışı sonlandıran aygıt merkezi işlem birimine bir kesme ile bunu haber verir.  
-Merkezi işlem birimi bu kesme doğrultusunda DMA’yı ya sonlandırır ya da ona başka bir işlem emri verir.  
  
Yukarıda da görüldüğü gibi merkezi işlem birimi DMA’yı yarattıktan sonra başka süreçlerle ilgilenebilmiş, böylece sistem işleyişine devam edebilmiştir. Bilgisayarlarımızda 8 adet DMA kanalı bulunmaktadır. İlk 4ü 8 bitlik, diğer 16 bitlik veriyi taşıyabilmektedir. Merkezi işlem birimi aynı anda birden fazla DMA yaratamaz çünkü böyle bir durumda verilerin transfer edileceği adreslerde çakışmalar olacaktır. Bu sebeple DMA’yı kullanacak olan işlemler birbirlerini beklemek zorundadır.
