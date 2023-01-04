---
title:  "Kafka Streams Windowing"
date:   2022-12-26 11:00:00
categories: [mimari, microservices, java, spring, spring boot]
tags: [kafka, streams, ktable, api, design, best, practices, http, service, message broker, design, tasarım, topic, queue, mikroservis, microservice, kubernetes,  türkçe, yazılım, blog, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://miro.medium.com/max/150/0*Dg0Gr6w92tALzjGh.webp
---

Kafka Streamsin son yazısında Windowing konusunu inceleyeceğiz.

1.  Yazı:  [Kafka Streams Nedir](https://www.mehmetcemyucel.com/2022/kafka-streams-nedir)
2.  Yazı:  [Kafka Streams KTable](https://www.mehmetcemyucel.com/2022/kafka-streams-ktable)
3.  Yazı:  [Kafka Streams Stateful Operations](https://www.mehmetcemyucel.com/2022/kafka-streams-stateful-operations)
4.  Yazı:  [Kafka Streams Windowing](https://www.mehmetcemyucel.com/2022/kafka-streams-windowing)

![](https://miro.medium.com/max/1000/0*Dg0Gr6w92tALzjGh.png)

Farklı stateful operasyonlarda yaptığımız özet veriler sürekli olarak artmakta ve birbirinin sonuna eklenmekteydi. Sonsuz miktardaki artış gerçekten istediğimiz bir durum mu yoksa örneği saydırma yapıyorsak belirli aralıkların saydırılması bizim için daha mı anlam ifade ediyor? Yürüyen merdiven örneğimizden yola çıkalım, haftanın her günü artan adetlerde merdiven başına geçen kişi sayısını toplatmak yerine gün gün bu değeri elde etmek daha anlamlı olabilir.

> Windowlar  **TimeWindowedStream**  yaratırlar, KTable’larla değil KStreamlerle ilgili bir kavramdır. Her stream gibi sonradan table’a bir stateful operasyon aracılığıyla çevrilebilir.

**Session**  henüz Spring Boot’ta implementasyonu olan bir windowing fonksiyonu olmadığından ve  **hopping**  de deprecated olarak ele alındığından biz  **tubmling**  ve  **sliding**  fonksiyonlarını ele alacağız.

## Tumbling

Tumbling ilk windowing yaklaşımımız. Kodumuzu birlikte inceleyelim.

```java
@Component  
public class TumblingExample {  
  
    private static final Serde<String> STRING_SERDE = Serdes.String();  
    private static final String INPUT_TOPIC = "tumbling-input-topic";  
  
    @Autowired  
    void buildPipeline(StreamsBuilder streamsBuilder) {  
        KStream<String, String> messageStream = streamsBuilder.stream(INPUT_TOPIC, Consumed.with(STRING_SERDE, STRING_SERDE));  
        Reducer<String> reducer = (String val1, String val2) -> val1 + val2;  
        Duration windowSize = Duration.ofMinutes(3);  
        TimeWindows tumblingWindow = TimeWindows.ofSizeWithNoGrace(windowSize);  
  
        messageStream  
                .peek((key, val) -> System.out.println("1. Step key: " + key + ", val: " + val))  
                .groupByKey()  
                .windowedBy(tumblingWindow)  
                .reduce(reducer, Materialized.as("tumbling"))  
                .toStream()  
                .peek((key, val) -> System.out.println("2. Step key: " + key.key() + " "  
                        + key.window().startTime().toString() + " - " + key.window().endTime().toString() + ", val: " + val));  
    }  
}
```

![](https://miro.medium.com/max/1400/1*NCNC0_byaP-jbuH-Xkc11g.png)

Topic’imizden okuduğumuz aynı keye sahip 2 kaydımız olduğunu düşünelim, streami groupBy ve reduce işlemlerinden geçirdiğimizde önceki yazımızdan da hatırlayacağınız gibi bu 2 değeri reducer’daki fonksiyondan geçirip bize store’da saklanacak şekilde sunuyordu. Yani key1'in güncel değeri 1122 olarak saklanacaktı.

![](https://miro.medium.com/max/1400/1*co3on66N0msMFN3L0n71YA.png)

Peki biz tumblingWindow ile bu fonksiyonu değiştirdiğimizde neler oldu? WindowSize olarak ilettiğimiz değer kaydın ne kadar süreyle geçerli olacağı bilgisi. Yani bu 1122 değeri emit edildikten sonra 3 dakikalık zaman aralığı için geçerli olacak. Kaydı store’dan sorgulamak için bir Rest Controller yazalım.

```java
@GetMapping("/timestamp/{store}/{key}")  
public String ktable2(@PathVariable String store, @PathVariable String key) {  
    KafkaStreams kafkaStreams = factoryBean.getKafkaStreams();  
    ReadOnlyWindowStore<Object, Object> pairs = kafkaStreams  
            .store(StoreQueryParameters.fromNameAndType(store, QueryableStoreTypes.windowStore()));  
    String result = "";  
    Instant timeFrom = Instant.now().minusSeconds(180); // beginning of time = oldest available  
    Instant timeTo = Instant.now(); // now (in processing-time)  
    WindowStoreIterator<Object> keyPair = pairs.fetch(key, timeFrom, timeTo);  
    while (keyPair.hasNext()) {  
        KeyValue<Long, Object> pair = keyPair.next();  
        result += new Date(pair.key) + " " + pair.value.toString() + "</br>";  
    }  
    return result;  
}
```


![](https://miro.medium.com/max/1400/1*BGN5WR-JS-U9PHk-1wYn6g.png)

39 geçeden itibaren 3 dakika boyunca geçerli olacak ve aynı sorgulamayı 42 geçe itibariyle sorguladığımızda bu key e ait bir değer dönmeyecek.

![](https://miro.medium.com/max/1400/1*-SmvDOrw49it01bkxmGS1A.png)

Başka bir örneği de ardarda değerler emit ettirdiğimizde neler reducer’ımızdan gelen değerlerin nasıl değişeceğine bakarak inceleyelim. 33 ve 44 kayırlarını farklı emitlerin içerisine girecek şekilde ard arda gönderelim ve ilk 33 recordunun window u biteceği zamanda yeni record 55 i gönderelim.

![](https://miro.medium.com/max/1400/1*1ST_iMGAilx4j9mQq4PA-Q.png)

48 geçe ilk recordu gönderdiğimizde storedaki key3 ün değeri 33 oldu.

![](https://miro.medium.com/max/1400/1*KYv9tiWI75B5SolFx0hKQA.png)

49 geçe ilk recordu gönderdiğimizde ise storedaki keyin değeri reducerın çıktısı olan 3344 olarak güncellendi ama ilk windowun süresi uzamadı.

![](https://miro.medium.com/max/1400/1*nA3SAEG7cKXIcBw2032AIg.png)

51 geçe itibariyle de artık kayda erişemez duruma geldik. Key’i ilk store’a sokan sürenin windowu o keyi update eden tüm recordlar için de geçerli oldu.

## Sliding

Tahmin ettiğiniz gibi bu kez ilk gelen kayıtla sınırlandırdığımız bir time windowu yerine aynı key için farklı windowlara sahip birden fazla value söz konusu olacak. Önemli nokta, window u halen geçerli olan kaydın güncellenmeye devam edeceği konusu. Örnekle inceleyelim.

```java
@Component  
public class SlidingExample {  
  
    private static final Serde<String> STRING_SERDE = Serdes.String();  
    private static final String INPUT_TOPIC = "sliding-input-topic";  
  
    @Autowired  
    void buildPipeline(StreamsBuilder streamsBuilder) {  
        KStream<String, String> messageStream = streamsBuilder.stream(INPUT_TOPIC, Consumed.with(STRING_SERDE, STRING_SERDE));  
        Reducer<String> reducer = (String val1, String val2) -> val1 + val2;  
        Duration timeDifference = Duration.ofMinutes(3);  
        Duration afterWindowEnd = Duration.ofMinutes(1);  
        SlidingWindows slidingWindow = SlidingWindows.ofTimeDifferenceAndGrace(timeDifference, afterWindowEnd);  
  
        messageStream  
                .peek((key, val) -> System.out.println("1. Step key: " + key + ", val: " + val))  
                .groupByKey()  
                .windowedBy(slidingWindow)  
                .reduce(reducer, Materialized.as("sliding"))  
                .toStream()  
                .peek((key, val) -> System.out.println("2. Step key: " + key.key() + " "  
                        + key.window().startTime().toString() + " - " + key.window().endTime().toString() + ", val: " + val));  
    }  
}
```

İlk kaydımızı gönderelim.

![](https://miro.medium.com/max/1400/1*mNJPWYI5VPlGl7s_0L1k4A.png)

Emit edildikten sonra 1 dakika attıktan sonra 2. kaydı gönderdiğimizde görüntü şu şekilde oluyor.

![](https://miro.medium.com/max/1400/1*FLWev1O7-z9CMuZqbG6wMg.png)

Yeni dağıtımdan sonra 3. kaydı gönderdiğimizde de bu şekilde

![](https://miro.medium.com/max/1400/1*yZfko_sKy3hQ1oEX6fy4Dg.png)

Son bir kayıt daha gönderiyoruz ancak bu süre zarfında ilkinin geçerliliği sona erdiği için artık o value responseda dönmeyecek.

![](https://miro.medium.com/max/1400/1*fJBWgs1rvx3lv2VGtBfPFw.png)

Kafka Streams serimizin burada sonuna geldik. Sonraki yazılarda/serilerde tekrar görüşmek üzere.

Serinin diğer yazıları için

1.  Yazı:  [Kafka Streams Nedir](https://www.mehmetcemyucel.com/2022/kafka-streams-nedir)
2.  Yazı:  [Kafka Streams KTable](https://www.mehmetcemyucel.com/2022/kafka-streams-ktable)
3.  Yazı:  [Kafka Streams Stateful Operations](https://www.mehmetcemyucel.com/2022/kafka-streams-stateful-operations)
4.  Yazı:  [Kafka Streams Windowing](https://www.mehmetcemyucel.com/2022/kafka-streams-windowing)

Projenin kodlarına  [buradan](https://github.com/mehmetcemyucel/kafka-streams)  erişebilirsiniz.