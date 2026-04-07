---
title: "Android Tabletimi MacBooka İkinci Monitor Yaptım"
date: 2026-06-07 10:00:00
author: "Mehmet Cem Yücel"
categories: [go, architecture, android, golang, software, blog]
tags: [go,  goroutines,  performance, adb, CGVirtualDisplay, mehmet-cem-yucel]
description: "Android Samsung tabletimi Mabcook Pro bilgisayarıma 2. monitör nasıl yapabilirim inclemesi"
excerpt: "Samsung tabletimi Macbook'a 2. monitör nasıl yaptığımı görmek ister misiniz?"
image: /images/2026-04-07-tablet-as-a-monitor/1_reNQ1C39uUiBEIN6vGawQw.webp
og_image: /images/2026-04-07-tablet-as-a-monitor/1_reNQ1C39uUiBEIN6vGawQw.webp
canonical: https://www.mehmetcemyucel.com/2026/tablet-as-a-monitor/

---


Android tabletimi MacBook’umla çalışırken ikinci bir ekran/monitor olarak nasıl kullanabilirim? Bu yazıda daha çok teknik tarafa odaklanacağım ama ihtiyacın nasıl çıktığı, kullanmak için neler yapmak lazım, kurulum vb gerekiyor mu onu kısa zaman içinde çekip yükleyeceğim YouTube videomdan izleyebilirsiniz. Videodan haberdar olmak için beni aşağıdaki kanallardan takip edebilirsiniz.

[YouTube](https://www.youtube.com/@mehmetcemyucel),  [LinkedIn](https://www.linkedin.com/in/mehmetcemyucel/),  [Instagram](https://instagram.com/mehmet.cem.yucel),  [WebSitem](https://www.mehmetcemyucel.com/subscribe/)


![TaaM (tablet as a monitor)](/images/2026-04-07-tablet-as-a-monitor/1_reNQ1C39uUiBEIN6vGawQw.webp)




## Mimari

Aslında akla gelen ilk yöntem bir  **Android**  tarafında bir de  **Macbook**  için birer uygulama yazmak. Ama nihai ve kusursuznbir ürün yapmak yerine hızlıca ve yeterince işimi görmesine odaklıyım. Android tarafında bir uygulama olmayacak bile(evet doğru duydunuz), bir tane  **Go**  uygulaması yazacağım ve  **zero install client**  mimari ile yazılımsal olarak olay burada bitecek. Aslında teknolojik çerçeve çok kompleks değil:

-   **ADB (Android Debug Bridge)**
-   **CGVirtualDisplay (MacOS 14)**
-   **GPU Accelerated Capture**  (**ScreenCaptureKit**  ->  **IOSurface**  ->  **JPEG**)

## Adım Adım Neler Yapıldı

Sistem şöyle çalışıyor. Usb portlarından bir kablo tablete ve bilgisayara bağlanır. Bilgisayardaki uygulama açılınca ADB aracılığı ile açılan tünel sayesinde otomatik olarak tablette bir browser tabı açılır ve buradaki statik html aracılığı ile sunucu ile haberleşir. Aldığı görüntüleri render eder, kendisindeki eventleri de sunucuya bildirir.

Tabi mevzu burada bitmiyor,  **FPS**’in(frame per second) yukarı çıkması için yapılabilecek optimizasyonlar, retina ekranlardaki eksran çözünürlüğünün yüksek olmasından sebepli yapılan optimizasyonlarla hızın artması, donanımsal hızlandırıcılara odaklanarak işlemciden yükü almak gibi bir çok adımda iyileştirme için AI ile bolca sohbetimiz oldu.

Sonra fonksiyonel kullanılabilirlik üzerine odaklanıp dokunmatik ekranda fare fonksiyonları, çözünürlük seçenekleri, tam ekran kullanım, ekranın dikey/yatay aynalanması, kopan bağlantıda bağlantının otomatik tekrar kurulması, dinamik fps yönetimi vb konularda ufak tefek şeyler de eklendi.

## Teknik Çözüm

Hadi biraz daha tekniğe inelim. İki cihaz arasında iletişim için başta  **WebRTC’yi**  düşündüm. Sadece ekranda değişen piksellerin aktarılıyor olması hızlı ve akıcı görüntü oluşturmak için akla güzel geliyordu. Ancak bunun için  **Signaling Server**  gerekecek olması teknolojik çözümü zorlaştıracaktı. Düşününce zaten kablo ile bağlayacağım dedim ve cihazların ne kadar hızda bir veri transferi yapabileceğine baktım. Burada belirleyici olan tablet,  **USB 3.2 Gen 1**  kullanıyor ve  **5 Gbps**  yani saniyede yaklaşık  **600 Mb**  transfer yapabileceğim için WebRTC’den dönüp  **WebHook**’ları kullanmaya karar verdim.

Server kısmında ise  **android-platform-tools**’a ihtiyaç duyuyorum. Önce ADB ile açılan tünelde iletişim kanalı oluşturup sonra bu kanal aracılığı ile teknik olarak clienta ekran görüntüleri gönderiyorum. Tabi bu ekran görüntüleri sanal bir monitöre ait olmalı,  **CGVirtualDisplay**  ile çözünürlük ve refreshRate ayarlarını belirleyip başlattıktan sonra MacOS bu ekranı yeni bir monitör olarak tanımaya başlıyor. Tabi ki  **ObjC**  frameworklerini kullanabilmek için de  **CGO**  kullanmamız gerekiyor.

Yeni monitörümüz OS seviyesinde tanımlandıktan sonra bu monitörün id’sini bulup bir  **DisplayStream**  başlatıyoruz ki görüntünün oluşması için frameleri yakalayabilelim. Evet yanlış duymadınız, Go’nun güçlü kısmı olan  **goroutine**’leri tam bu noktada frameleri yakalamak ve JPEG formatına çevirmek için kullanıyoruz. Tabi buralarda ince hesaplar yaparak ihtiyacımız olmayacak kadar büyük çözünürlükleri downscale ediyoruz. Ediyoruz ki performansı yukarıda tutmaya çalışıyoruz ve elde edilen nihai frameleri clientlara gönderme vakti geliyor.

Birden fazla client yani tablet de bağlanmış olabilir. Bu sebeple her bir clienta  **buffered channel**lar yaratarak görsellerimizi tablete göndermeye başlıyoruz. Tablet de binary olarak gelen bu görselleri browser tabında  **drawImage**  yapmaya başlıyor.

Tabi ki tablette de dokunma, sürükleme, sağ tıklama gibi fonksiyonlara ihtiyacımız var. Burada da html’de eventListenerlarla alınan infolar sunucuyla paylaşılıyor. Sadece bunlar da değil, çözünürlük değiştirme, imleci ekrana getirme vb gibi farklı işlemler için yine sunucu tarafında farklı endpointler mevcut.

Kullanmak isteyenler için  [**GitHub**](https://github.com/mehmetcemyucel/taam)  reposu burada. AI ile onlarca yıllık uygulamalar kısa sürede taklit edilebilmeye hatta daha da geliştirilebilmeye başladı. Bu dönemde önemli olan buna adapte olmak ve hatta belki de yukarıdaki repodan download edip kullanmak yerine acaba kendim de yapabilir miyim sorusunu kendine sormak, ne dersiniz ;)
