---
title:  "Kafka Streams Nedir"
date:   2022-12-22 10:00:00
categories: [mimari, microservices, java, spring, spring boot]
tags: [kafka, streams, topic, queue, api, design, best, practices, http, service, message broker, design, tasarım,  mikroservis, microservice, kubernetes,  türkçe, yazılım, blog, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://miro.medium.com/max/150/1*gNhxKQM1FtjzVsJf0UVTkg.webp
---
Apache Kafka’yı çoğumuz duymuştur, kendisini açık kaynak dağıtık bir event streaming platformu olarak tanımlıyor. Bugün Kafka’nın standart message broker özelliklerinden ziyade Kafka Streams’i irdeleyeceğiz.

1.  Yazı:  [Kafka Streams Nedir](https://www.mehmetcemyucel.com/2022/kafka-streams-nedir)
2.  Yazı:  [Kafka Streams KTable](https://www.mehmetcemyucel.com/2022/kafka-streams-ktable)
3.  Yazı:  [Kafka Streams Stateful Operations](https://www.mehmetcemyucel.com/2022/kafka-streams-stateful-operations)
4.  Yazı:  [Kafka Streams Windowing](https://www.mehmetcemyucel.com/2022/kafka-streams-windowing)

## Neden Kafka Streams

Aklınıza şu geliyor olabilir, ben zaten Kafka ile ihtiyacım olan şeyleri gerçekleştiriyorum, niçin streaming dünyasına gireyim ki? Özellikle verinin çok büyüdüğü ve bu veri üzerindeki işlemlerin arttığı bir dünyada artık işlem gücü aynı paralellikte artmıyor. Saniyede yüzbinlerce, milyonlarca sensör verisinin toplandığı bir dünyada bunları işlemek, yönetmek daha da güç hale geliyor. Güzel haber şu ki henüz bir çok uygulamada elimizdeki donanımların gücünü gerçekten maksimize kullanmıyoruz. Bunun için olabildiğince Concurrency’i ve Multithreadleri doğru şekilde kullanan uygulamalar kodlamamız lazım. Bu da uğraşanlarınızın tahmin edeceği üzere bolca race condition ve concurrent update problemleri ile uğraşmak demek. Bunun asıl sebebi de elimizde bolca mutable objenin varlığı ve onları yönetmenin başlı başına bir tecrübe, dikkat işi olması.

Öyle bir kod yazmalıyız ki çok threadli ve çok işlemcili bir mimaride robust bir şekilde çalışabilsin ve bunun için immutabilityi mimarisinin orta noktasına koysun. Immutability mimarimizin merkezine oturduğunda declerative programming bunu implement etmenin belki de en güzel yolu. Bu noktada bir okuma önerisi ile gelebilirim,  [Robert C. Martin’in Clean Architecture kitabı](https://www.amazon.com/Clean-Architecture-Craftsmans-Software-Structure/dp/0134494164)nın Functional Programming başlığına bir göz atın.

![](https://miro.medium.com/max/1400/1*gNhxKQM1FtjzVsJf0UVTkg.png)

{% include feed-ici-yazi-1.html %}


## Kafka Giriş ve Kurulum

Yazı boyunca aynı dili konuşabilmemiz için bazı kavramların üzerinden geçelim.

Kafka’ya paylaşılan veriyi paylaşan tarafa  **Producer**, veriyi tüketen tarafa  **Consumer**  ismi verilir. Paylaşılan veri  **Record**, kaydolduğu nokta  **Log**, her Record’a tekil erişimi sağlayan bir  **Offset**  sıra numarası ve bu verileri tüketen Consumer’lardan oluşan  **Consumer Group**’ları vardır.

Kavramları ortaklaştırdığımıza göre yavaştan başlayabiliriz. Anlamak için örnekler her zaman daha açıklayıcı, bu sebeple ilk önce demo ortamını kuralım.  [https://kafka.apache.org/downloads](https://kafka.apache.org/downloads)  adresinden kafkanın son versiyonunu indirelim ve paketi bilgisayarımızda uygun bir konuma çıkartalım. Benim sürümüm  [kafka_2.13–3.3.1.tgz](https://downloads.apache.org/kafka/3.3.1/kafka_2.13-3.3.1.tgz)  sürümü olacak.

Kafka’yı ayağa kaldırmak için  [https://kafka.apache.org/quickstart](https://kafka.apache.org/quickstart)  adresindeki yönergeleri izleyebilirsiniz. Tercih ettiğim 3.3.1 sürümü ile birlikte  [consensus](https://www.mehmetcemyucel.com/2018/centralized-decentralized-distributed-networkler-ve-bizans-general-problemi/)  problemini çözmek için artık  [Zookeeper’a](https://zookeeper.apache.org/)  ihtiyaç bulunmuyor. Zookeeper’a alternatif olarak pakete dahil gelen  [KRaft](https://developer.confluent.io/learn/kraft/)’ın shutdown lar sonrası recovery sürelerinin majör şekilde iyileştirmesi en önemli özelliği. Ben de bugün Kafka’yı KRaft ile ayağa kaldıracağım.

![](https://miro.medium.com/max/1400/1*TuWEWPWj3GDDaXiIxuOwZQ.png)

Tek Broker’lı Kafka Cluster’ımız demo için artık hazır. 9092 portundan bootstrap serverımız yayın yaparak oluşturduğumuz cluster hakkında metadata paylaşımında bulunuyor. Bu veri içerisinde topic’ler, onların partition’ları, bu partitionlar için leader brokerlar gibi bilgiler yer alıyor. Bir Spring Boot projesi yaratalım.

![](https://miro.medium.com/max/1400/1*2ycPS60teyl4n7Kjzn7FBg.png)

Kafka, Kafka Streams, Web ve Lombok bağımlılıklarımızı ekleyip projemizi yaratıyoruz.

Oluşan projemizin application.properties dosyasına uygulamamız ayağa kalkarken kafka clusterına erişebilmesi için gerekli metadayı edinebileceği bootstrap yapılandırmasını ekliyoruz.

![](https://miro.medium.com/max/1400/1*8OihGGav6hU5JJxyS8KcSA.png)

Bu yapılandırma bilgisi ile konfigürasyonumuzu tamamlayalım.

```java
@Configuration  
@EnableKafka  
@EnableKafkaStreams  
public class KafkaConfig {  
  
    @Value(value = "${spring.kafka.bootstrap-servers}")  
    private String bootstrapAddress;  
  
  
    @Bean(name = KafkaStreamsDefaultConfiguration.DEFAULT_STREAMS_CONFIG_BEAN_NAME)  
    KafkaStreamsConfiguration kStreamsConfig() {  
        Map<String, Object> props = new HashMap<>();  
        props.put(APPLICATION_ID_CONFIG, "cem-kafka-streams");  
        props.put(BOOTSTRAP_SERVERS_CONFIG, bootstrapAddress);  
        props.put(DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass().getName());  
        props.put(DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass().getName());  
        return new KafkaStreamsConfiguration(props);  
    }  
}
```

**Serdes**= Serializer-Deserializer.

Apache Kafka key-value ikilileri ile çalışır. Key ve valuelar transfer edilebilmeleri için serileştirilmeye ihtiyaçları vardır. Projemize eklediğimiz bağımlılıkların içerisindeki Serdes sınıfında bazı hazır serializerlar vardır. Kompleks objeler için Custom Serdes’ler yaratabilirsiniz. JSON, Avro veya Protobuf kullanıyorsanız yine hazır Serdes’ler mevcut.

![](https://miro.medium.com/max/1244/1*B-Fa4UW_2b9dAuiPzc9sXA.png)

{% include feed-ici-yazi-2.html %}


## Kafka Streams 

Artık konfigürasyonumuz hazır olduğuna göre önce topiclerimizi yaratalım, sonrasında da basit bir stream pipelineı yaratalım ve temel fonksiyonları tanıyalım.

![](https://miro.medium.com/max/1400/1*r60WGvq7MCfx9HmOTZR8Ww.png)

Declerative programlama ile daha önce uğraşanlar için çok da yabancı olmayan fonksiyonları görüyoruz.

```java
@Component  
public class BasicStream {  
  
    private static final Serde<String> STRING_SERDE = Serdes.String();  
    private static final String INPUT_TOPIC = "basic-stream-input-topic";  
    private static final String OUTPUT_TOPIC = "basic-stream-output-topic";  
  
    @Autowired  
    void buildPipeline(StreamsBuilder streamsBuilder) {  
        KStream<String, String> messageStream = streamsBuilder.stream(INPUT_TOPIC, Consumed.with(STRING_SERDE, STRING_SERDE));  
        messageStream .peek((key, val) -> System.out.println("1. Step key: " + key + ", val: " + val))  
                .mapValues(val -> val.substring(3))  
                .peek((key, val) -> System.out.println("2. Step key: " + key + ", val: " + val))  
                .filter((key, value) -> Long.parseLong(value) > 1)  
                .peek((key, val) -> System.out.println("3. Step key: " + key + ", val: " + val))  
                .to(OUTPUT_TOPIC, Produced.with(STRING_SERDE, STRING_SERDE));  
    }  
}
```

İlk peek ile topicten okunan değeri göreceğiz, sonrasında gelen değerin substringini alarak değerimizi mapleyeceğiz, yani dönüştürerek sonraki adıma aktaracağız. En son da filtreleme yaparak parse ettiğimiz değerin 1den büyük olmasını bekleyeceğiz, eğer değilse son adıma bir kayıt geçmeyecek dolayısı ile output topic e bir veri gönderilmeyecek.

Bu akışı yönetebilmek için input topic ine bir producer yaratacağız. Çıktıyı gözlemlemek için de output topic ine bir consumer açacağız.

![](https://miro.medium.com/max/1400/1*84xj9q4VK2hXEMqoM-r8wg.png)


![](https://miro.medium.com/max/1400/1*DredRERq0vx00QkNw12Zhw.png)


Test etmek için 10002 içerikli bir recordu produce request olarak ilettik.

![](https://miro.medium.com/max/1400/1*30RrLsBdnO00hR7NPanl8Q.png)


Bu değer stream olarak ele alındığında aşağıdaki şekilde steplerden geçti.

![](https://miro.medium.com/max/1400/1*kg9b1ynDbuxLl74iCyOoPQ.png)


Son adım olarak da output topic inin içerisinde maplenerek değişmiş haliyle kaydımızı gözlemledik.

![](https://miro.medium.com/max/1400/1*CqVzPCn5Kv5yvWKpXJbmFw.png)


Aynı işlemi 10000 recordu için tekrarladığımızda filterdan geçemediği için sonraki adım gerçekleşmemiş oldu.

![](https://miro.medium.com/max/778/1*RRDCwXqfXQkZKo9myyXxFg.png)

{% include feed-ici-yazi-1.html %}


Bunlar basit bir streaming örneğiydi. Bu girişin ardından  [sonraki yazımızda](https://www.mehmetcemyucel.com/2022/kafka-streams-ktable)  asıl faydayı sağlayacağımız KTable konusuna değineceğiz.

1.  Yazı:  [Kafka Streams Nedir](https://www.mehmetcemyucel.com/2022/kafka-streams-nedir)
2.  Yazı:  [Kafka Streams KTable](https://www.mehmetcemyucel.com/2022/kafka-streams-ktable)
3.  Yazı:  [Kafka Streams Stateful Operations](https://www.mehmetcemyucel.com/2022/kafka-streams-stateful-operations)
4.  Yazı:  [Kafka Streams Windowing](https://www.mehmetcemyucel.com/2022/kafka-streams-windowing)

Projenin kodlarına  [buradan](https://github.com/mehmetcemyucel/kafka-streams)  erişebilirsiniz.