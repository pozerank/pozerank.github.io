---
title:  "Kafka Streams KTable"
date:   2022-12-22 11:00:00
categories: [architecture, microservices, java, spring, spring boot]
tags: [kafka, streams, ktable, rocksdb, rocks, store, topic, queue, design, best, practices, service, message broker, design, tasarım, mikroservis, microservice, kubernetes,  türkçe, yazılım, blog, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://miro.medium.com/max/150/0*DowA3KXXNQ-W6i1b
---

Önceki yazımızda Kafka Streams hakkında temel bilgilerimizi edinmiştik. Bu yazımızda KTable kavramını inceleyeceğiz.

1.  Yazı:  [Kafka Streams Nedir](https://www.mehmetcemyucel.com/2022/kafka-streams-nedir)
2.  Yazı:  [Kafka Streams KTable](https://www.mehmetcemyucel.com/2022/kafka-streams-ktable)
3.  Yazı:  [Kafka Streams Stateful Operations](https://www.mehmetcemyucel.com/2022/kafka-streams-stateful-operations)
4.  Yazı:  [Kafka Streams Windowing](https://www.mehmetcemyucel.com/2022/kafka-streams-windowing)

![](https://miro.medium.com/max/818/0*DowA3KXXNQ-W6i1b)

{% include feed-ici-yazi-1.html %}


## Kafka Streams

İlk yazımızda Kafka’nın key-value ikilileri ile çalıştığından bahsetmiştik ancak producerda gönderdiğimiz recordlarda hiç key kullanmamıştık. Hatta consoleda key leri null olarak gözlemlemiştik.

![](https://miro.medium.com/max/778/0*aHxoUeVW_l8RW2F7.png)

Bu kez producer’ımızı farklı şekilde açıyoruz ve bir seperator ile ayrılmış veriyi key-value ikilisi olarak almasını sağlıyoruz.

![](https://miro.medium.com/max/1400/1*9krBuC6l5L9JHkJFTQdKQA.png)

```bash
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic  basic-stream-input-topic --property "parse.key=true" --property "key.separator=:"
```

![](https://miro.medium.com/max/1400/1*03YyrrYfnvqTVdWxCt4a-Q.png)

Key değerimiz bu kez null yerine dolu bir değer içeriyor.

## Kafka Streams KTable

Streamler’de key’lerin değeri önemsiz olarak her record birbirinden bağımsız olarak ele alınır. Yani keyleri aynı 10 farklı value da göndersek hepsi birbirinden bağımsız birer istektir ve ayrı ayrı işlenir. İşte KTable’lar bu noktada Stream’lerden farklılaşır. Aynı key’e sahip farklı recordlar o key’in last statusunu günceller. Stream örneğinin aynısını KTable’lar için farklı bir örnekle ele alalım.

Pipelineımıza bu kez StreamsBuilder’dan bir stream olarak değil bir table olarak recordlarımızı okumak istediğimizi söylüyoruz ve bu bilgileri ‘ktable-store’ isimli bir yerde Materialized olarak store etmesini istiyoruz. Sonrasında KTable’dan datalarımızı işleyebilmek için stream e çevirip ilk yazımızdaki aynı örneği yapıyoruz.

```java
@Component  
public class KTableExample {  
  
    private static final Serde<String> STRING_SERDE = Serdes.String();  
    private static final String INPUT_TOPIC = "ktable-input-topic";  
    private static final String OUTPUT_TOPIC = "ktable-output-topic";  
  
    @Autowired  
    void buildPipeline(StreamsBuilder streamsBuilder) {  
        KTable<String, String> kTable = streamsBuilder.table(INPUT_TOPIC, Consumed.with(STRING_SERDE, STRING_SERDE),  
                Materialized.as("ktable-store"));  
        kTable  
                .toStream()  
                .peek((key, val) -> System.out.println("1. Step key: " + key + ", val: " + val))  
                .mapValues(val -> val.substring(3))  
                .peek((key, val) -> System.out.println("2. Step key: " + key + ", val: " + val))  
                .filter((key, value) -> Long.parseLong(value) > 1)  
                .peek((key, val) -> System.out.println("3. Step key: " + key + ", val: " + val))  
                .to(OUTPUT_TOPIC, Produced.with(STRING_SERDE, STRING_SERDE));  
    }  
}
```
{% include feed-ici-yazi-2.html %}


Sonrasında key1 anahtarıyla 10002 değerini producerımızdan gönderiyoruz.

![](https://miro.medium.com/max/1400/1*7OV-mcGqNNfm2C_FCBiF8g.png)

10002 göndermemizde hiçbir hareketlilik olmadığı için ardarda value u 1er artırarak recordlar göndermeye devam ettiğimizde ilginç bir görüntü ile karşılaşıyoruz.

![](https://miro.medium.com/max/1400/1*GRvJfrzq3p2KGQQ22MyIHQ.png)

![](https://miro.medium.com/max/1400/1*VyxCAhD9I6jGJyxS4z86nQ.png)

Çok sayıda record göndersek de sadece 3 ve 6 yı consoleda ve output topicinde görebildik. Bu ne demek, ne anlama geliyor?

KTable’ların önemli ve güzel özelliği aslında burada başlıyor. Bir fabrikanızda yüzbinlerce sıcaklık sensörünüzün olduğunu ve bu sensörlerden saniyede defalarca veri gönderildiğini hayal edin. Sizin sadece belirli sıcaklığın üzerine çıkan sensörleri gözlemek istediğiniz senaryoda her bir sensörden gelen her data önemli olmayacaktır. Sensörlerin son anı ve bu son andaki değerinin devamlılığı sizin alarm üretmeniz için gereken uyaran olduğunu varsayın.

Ktable sizin materialized datanızı tutan bir yapıyı ifade eder. Yani aynı keyden ne kadar adette geldiğinin önemi yoktur, her zaman son gelen değer geçerlidir. Peki binlerce kez aynı kayıt geldiğinde her defasında bir aksiyon almalı mıyım, bu maliyete değer mi? Ktable default davranış olarak bu key-value ikililerinin öncelikle cachete tutmayı, belirli senaryolarda cacheten emit etmeyi, yaymayı, tercih eder. Default policy de 30sn veya 10MB lık cache alanının dolmasıdır.

Yukarıdaki örneğimize geri dönecek olursak, key1:10002 kaydımızı gönderdiğimizde bu değer cachelendi ancak emit edilmedi. key1:10003 gönderdiğimizde yine cachelendi ancak bu kez KTable’ın StreamThreadleri taskı çalıştırarak son değerlerin yayılmasını sağladı ve hem output topic inde hem de kodumuzun console çıktısında 10003 değerini gördük. 10004,10005 değerleri de gönderildiğinde cachelenmiş ancak emit edilmemişti ama 10006 son durum olarak key1 için yine paylaşıldı ve bu değeri görebildik, işleyebildik.

Peki bu materialized store dediğimiz yer neresi, uygulamam kapanır açılırsa ne olur? Ne kadar yük kaldırabilir, performansı nedir?

## RocksDB

[RocksDB](https://github.com/facebook/rocksdb)  bir embeddable key-value persistent store’udur. Yüksek performanslı ve düşük maliyetli bir çözüm olmasından kaynaklı Kafka Streams’te store olarak kullanılmaktadır. Uygulamanız kapanıp açılsa da veriyi kaybetmezsiniz. Kafka Streams uygulamalarında sınırlı şekilde RocksDB’nin configlerinin düzenlenmesine izin verilmektedir, detaylı bilgi için  [burayı](https://medium.com/mehmetcemyucel/confluent.io/blog/how-to-tune-rocksdb-kafka-streams-state-stores-performance/)  ve  [burayı](https://kafka.apache.org/24/documentation/streams/developer-guide/config-streams#rocksdb-config-setter)  inceleyebilirsiniz.

## Store’dan Veri Okuma

Peki bizim için özet görüntüyü saklayan bu store’dan veriyi nasıl okuyacağız?

Projemize bir controller ekleyerek okuma örneği yapalım.

```java
@RestController  
@AllArgsConstructor  
public class StoreRestController {  
    private final StreamsBuilderFactoryBean factoryBean;  
  
    @GetMapping("/{key}")  
    public String getWordCount(@PathVariable String key) {  
        KafkaStreams kafkaStreams = factoryBean.getKafkaStreams();  
        ReadOnlyKeyValueStore<String, String> pairs = kafkaStreams  
                .store(StoreQueryParameters.fromNameAndType("ktable-store", QueryableStoreTypes.keyValueStore()));  
        return pairs.get(key);  
    }  
}
```

{% include feed-ici-yazi-1.html %}


Store’umuza erişip key’imizle arama yapıp sonucunu dönecek bir servis açtık. Browserdan bir istekle deneyelim.

![](https://miro.medium.com/max/1160/1*aPT4chaTaGQ-7_UhQ7DsBA.png)

KTable konusuna burada nokta koyalım. Sıradaki yazılarda Stateful operasyonlara ve windowing konusuna değineceğim.

1.  Yazı:  [Kafka Streams Nedir](https://www.mehmetcemyucel.com/2022/kafka-streams-nedir)
2.  Yazı:  [Kafka Streams KTable](https://www.mehmetcemyucel.com/2022/kafka-streams-ktable)
3.  Yazı:  [Kafka Streams Stateful Operations](https://www.mehmetcemyucel.com/2022/kafka-streams-stateful-operations)
4.  Yazı:  [Kafka Streams Windowing](https://www.mehmetcemyucel.com/2022/kafka-streams-windowing)

Projenin kodlarına  [buradan](https://github.com/mehmetcemyucel/kafka-streams)  erişebilirsiniz.