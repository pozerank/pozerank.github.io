---
title:  "Context Switch Nedir?"
date:   2025-01-22 12:00:00
categories: [management, agile]
tags: [context switch, cpu, context switching, nedir, nasıl yapılır, technical, debt, technicaldebt, mehmetcemyucel, türkçe, mehmet cem yücel]
image: https://miro.medium.com/v2/resize:fit:150/0*OY_UArzB24N2vguf.png
---

Kelime anlamı ‘Bağlam Değiştirme’ olsa da daha anlaşılır haliyle ‘bir işi bırakıp başka bir işe odaklanma’ manasına gelen bu kavram günümüzde gerek insanlar için gerekse CPU’lar için kullanılabilmektedir. Çünkü gün içerisinde her ne kadar aynı anda birden fazla işlem yapabildiğimizi zannetsek de insan beyni de CPU’lar da aynı anda bir işleme odaklı  [çalışabilmektedir](https://www.thoughtco.com/can-people-really-multitask-1206398). Bu yanılgıya sebep veren şey ise çok hızlı şekilde bu switchi gerçekleştirebiliyor olmamız olabilir çünkü aynı anda hem omzumuza sıkıştırdığımız telefonla konuşup hem de saatlerce araç kullanabiliyorsunuz öyle değil mi :)

Beynimiz bir konu ile uğraşırken 5 duyu organımızdan gelen uyaranlara ek eski bilgileri hatırlama, bilgiler arasında ilişki kurma ve bağlam yaratma gibi başka fonksiyonları da kullanarak bir output üretir. Bu süreç bağlam dışı uyaranlar tarafından tetiklenmediği sürece maksimum verimle çalışmalarınızı tamamlarsınız. Bu verim dahi günümüzde tartışmalıdır lakin dikkati kaybetme süreleri 2000'li yılların başında dakikalarla ifade edilirken günümüzde teknolojik uyaranların artmasıyla artık saniyelerle ifade ediliyor. Yine de 1 saattir üzerinde uğraştığınız bir bugı çözmenin eşiğine geldiğiniz anda dışarıdan gelen ‘Yemekte ne yiyelim?’ sorusu beyninizin üzerinde çalıştığı bağlamı kenara atacaktır. Aklınızdan geçirdiğiniz yemekler saatin de gelmesiyle parasempatik sinir sisteminizi uyaracak, ağzınız sulanacak, açlık hissiniz tavan yapacak ve mideniz salgı üretimini artırarak kendisine gelecek yemekleri sindirmeye hazır hale gelecek. Artık bug üzerinde geçirdiğiniz 1 saat rafa kalktı, hormonal olarak da tetiklenen vücudunuzun tekrar aynı odağa dönmesi için yemeğin hazırlanması, karnınızın doyması, yükselen şekerinizin tekrar normal seviyelere dönmesi lazım. Bu da tabii ki hemen olabilen bir şey değil.

Her zaman sınavımızı yemekle vermeyebiliriz, bazen gün içerisinde gelen farklı işler de bizi context switchinge sürükleyebilir. Her işin kendi çapında acelesi ve dinamizmi de olabilir. Ancak yapılan araştırmalar şunu gösteriyor ki aynı anda yapılan birden fazla iş hem iş kalitesini düşürmüş hem de totaldeki yapılan işlerin tek tek yapılsa tamamlanacağı süreden daha uzun sürede tamamlanabilmiş.  [Gerald Weinberg’ın Quality Software Management](https://www.amazon.com/Quality-Software-Management-Vol-Congruent/dp/0932633285)  kitabından aşağıdaki tabloyu paylaşıyorum.

![](https://miro.medium.com/v2/resize:fit:1216/0*OY_UArzB24N2vguf.png)

scrum.org

Buradaki en büyük kayıp context switchingden kaynaklanan kayıp. Bir mimarlık öğrencisi olsanız bunu anlaması daha kolay olabilirdi çünkü kocaman bir masanın üzerinde 3 boyutlu modelini yaptığınız bina ödevini kaldırıp başka bir ödevin modelini yapmak önce masayı boşaltmanıza sonra ilk malzemeleri kaldırıp yerine yenilerini açmaya itecekti. Bu tabii ki daha görünür bir switch örneği, çoğunlukla bilgisayar başında çalışan çalışanlar olarak bu maliyetin farkına yeterince varamasak da istatistik bilimi bizi yanıltmıyor. Kendi yönettiğim ekiplerde de yaptığım gözlemler ve ölçümler de switch maliyetinin küçümsenmeyecek etkilerini hep ortaya koydu. Dolayısı ile bazen hızlanmak için yavaşlamak da iyi bir tercih olabilir. Yeter ki doğru planlama ile doğru işleri sırasına koyalım, doğru yerlerde hayır demeyi bilelim ve riski, stresi ve time2market dinamizmini doğru yönetelim öyle değil mi?

Olayın diğer yönü de CPU üzerinde yaşanan context switching konusu. Ama onu burada anlatmaktansa teknik açıdan adım adım ele aldığım videoyu aşağıya bırakıyorum. İlgilenenler göz atabilir.

[![Context Switching: Performansı Artırmanın Yolları ve Multitasking'in Sırları?](https://img.youtube.com/vi/yLh9hAuBPr8/0.jpg)](https://www.youtube.com/watch?v=yLh9hAuBPr8)

Sonuç olarak genelde refleks hep değişime mesafeli yaklaşıp var olanı koruma yöneliminde oluyor. Buna ister safe area diyin ister başka bir şey. Ancak içinizi rahatlatmak için omzunuzla kulağınız arasına yerleştirdiğiniz telefonu araç telefonuna bağlayarak konuyu çözüme ulaştırdığınız kanısına varmayın. Kısa süreli bir görüşme riski minimal tutabilir lakin sürekli yaşanan bu multitasking durumu bugün veya yarın, ya kendinize ya da trafikteki başka bir kişiye o zararı vermenize sebebiyet verecek.

En yalın haliyle.