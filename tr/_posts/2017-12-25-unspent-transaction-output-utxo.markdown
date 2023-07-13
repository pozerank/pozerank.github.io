---
title:  "Unspent Transaction Output UTXO"
date:   2017-12-25 22:04:23
categories: [blockchain]
tags: [dlt, unspent, transaction, output, distributed, legder, blockchain, bitcoin, utxo, block, blockchainturk]
image: https://cdn-images-1.medium.com/max/150/1*xFpHRPhxSWbQZoLTxRk8og.png
---
![](https://miro.medium.com/max/550/1*xFpHRPhxSWbQZoLTxRk8og.png)

UTXO (Unspent Transaction Output)

Birçok blockchain örneğinin temelinde yatan bir konuyla yazı dizisine devam ediyoruz. Bugünün konusu Unspent Transaction Output (UTXO). “Ödenmemiş İşlem Çıktısı” diye çevirmek tam içime sinmese de yine en iyi çeviri bu olur sanırım.

![](https://miro.medium.com/max/704/0*eFNT-TXPNwCWoHHk.jpg)

Elinizde bir miktar paranız var örneğin 840 lira. Bu parayla kocaman bir tablet çikolata aldınız, çikolatanız bir değer, her bir parçası da 20 lira ediyor(42 kare var). Bu değer başka değerlerle takas edilebilir veya tekrar paraya çevirilebilir(bu durumda aslında para da bir değer oluyor ki zaten öyle).

Çikolatanızdan 9 parça koparıp bir kazak karşılığında takas yaptınız. Artık size 42 parçalık çikolatadan 33 parça kaldı, 9 parça da kazakçıda.

![](https://miro.medium.com/max/704/0*wssmknZdjyhpfALw.jpg)

Gözünüzde havuz problemine dönüşmeden son bir işlem daha yapacağız. Kazakçının sattığı kazakları müşterisine vermeden önce koymak için poşete ihtiyacı var, elindeki 9 parça çikolatanın 4üyle poşet alacak. Sizin de evde çöp poşetiniz bitmiş, 1 parça ile de siz poşet aldınız. Son görüntü şu şekilde;

![](https://miro.medium.com/max/704/0*7nV2rsA-pLolUFoB.png)

Farkındaysanız bir işlem inputlarından(kazak satma) doğan output(9 parça çikolata) ile  **kazakçı bu outputu tekrar paraya çevirmeden**  başka bir işlem inputu(poşet satınalma) yaratmak suretiyle yeni bir output(4 parça çikolata) oluşturabiliyorsa bu yapıya**Unspent Transaction Output(UTXO)**  ismi verilir.

Blockchain sistemlerinin bir çoğunda bu yaklaşım kullanılmaktadır, bir işlemin çıktısı başka bir işlemin girdisi olacak şekilde döngü devam etmektedir. Örneğin bitcoin’de sizin yaptığınız bir satım işleminin outputu(0.03 btc), alıcının hesabında alım işleminin inputunu(yine yaklaşık 0.03 btc) oluşturmaktadır. Tabii ki bitcoindeki para akışı bundan ibaret değildir, max 21 Milyon’a fix’li olarak döngüsü devam eden bitcoin piyasasında belirli periyotlarda mining işlemine katkıda bulunan peer’lara ödül olarak dağıtılan coinler de mevcuttur.

Yazılarımızın devamlılığını sağlayabilmemiz için lütfen yorumlarınızı iletmeyi unutmayınız. Ve bizi  [**LinkedIn**](http://linkedin.com/groups/13568839)  ve  [**Facebook’ta**](https://www.facebook.com/blockchainturknet/) takip edin, topluluğumuzun bir parçası olun.