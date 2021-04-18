---
title:  "Spring Boot Rest Servis Entegrasyon Testi"
date:   2019-03-03 15:04:23
categories: [microservices, java, spring, test]
tags: [rest, entegrasyon, integration, test, mockmvc, unit, service, microservice, mikroservis, türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://lh3.googleusercontent.com/Esv5RJA-BRT4PJcyjrApSFqRVLpDxef7CAd5oEgVEZao785R8GKuG-NKbQduwGCms0_RitOF_s8=s150
---

Hepimiz Rest servisleri uygulamalarımızda yoğun olarak kullanıyoruz. Peki, bu servislerin entegrasyon testlerini yazarken sıklıkla yapılan o hataya siz de düşüyor olabilir misiniz? Bugün bir Spring Boot uygulamasında Rest servislere 2 farklı test yazımını inceleyeceğiz. Birisi gerçekten bir integration testi, diğeri de tüm Spring Context'ini ayağa kaldırarak yapılan uçtan uca testi örnekleyecek.

![](https://lh3.googleusercontent.com/Esv5RJA-BRT4PJcyjrApSFqRVLpDxef7CAd5oEgVEZao785R8GKuG-NKbQduwGCms0_RitOF_s8=s800 "Darth Vader")

## 1. Test Piramidi
Test piramidinin en tabanında birim testler(unit tests) bulunur. Sonrasında entegrasyon testleri(integration tests), kontrat testleri(contract tests), arayüz testleri(UI tests) diye devam eder. Bu testler ile ilgili [Martin Fowler'ın yazısını](https://martinfowler.com/articles/practical-test-pyramid.html) okumanızı tavsiye ederim. 


![Martin Fowler Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid/testPyramid.png)https://martinfowler.com/articles/practical-test-pyramid/testPyramid.png

Bu piramidin en güçlü olması gereken yeri tabii ki tabanıdır. Taban katmanının gücü üzerine üzerine diğer katmanlar yerleşir. Bu sebeple en geniş kapsamlı testleri birim testlerde kodlarız. Bu testlerimizin adetlerinin çok olmasından dolayı hızlı çalışmaları lazımdır. Örneğin bir CI/CD pipeline'ında kodunuz build edilirken bu testleriniz çalıştırılacaktır. Bir mikroservis mimaride ancak 3 dakikada deploy olabilen kod sahibi olmak bir çok problemi doğuracaktır. Bu sebeple özellikle birim testleri hiçbir bağımlılık olmadan çalışabilmelidir. Entegrasyon testlerinin de doğru mock, fake, spy veya stub yöntemleri ile izolasyonu mutlaka sağlanmalıdır.

## 2. REST Entegrasyon Testi

Buradan itibaren kodumuza dönelim. Bir RestController'ımız, bir de onun kullandığı başka bir Spring Bean sınıfımız olsun.

<script src="https://gist.github.com/mehmetcemyucel/105429985b5cb00c9f73ad37c414698e.js"></script>

<script src="https://gist.github.com/mehmetcemyucel/606444790323514dea3e6bf7ea3ce6f5.js"></script>

{% include feed-ici-yazi-1.html %}

Post metod açan bu sınıfımızın testini nasıl yazmalıyız? Google'da "spring boot rest test" anahtar kelimeleri ile aramamızı yaptığımızda çıkan 5 site aşağıdaki gibi. Bunlardan ikisi de Spring'in kendi sitesi :)

![Google Search](https://lh3.googleusercontent.com/dstgHKOQQXWRTHdU7F0zOvOu-EYR1NnNkkk7Va6L4d_lD228VhHM8bxtp77h4cuZkVRxiXxpOLQ=s800 "Google")

{% include feed-ici-imaj-1.html %}

### 2.1 Web Context Entegrasyon Testi

Bu 5 sitedeki yöntemler aşağı yukarı aynı. Autowire edilmiş bir MockMvc ile ya tüm Spring Application Context ayağa kaldırılıyor, ya da sadece Web Context ve bu context'e bağımlı beanler ayağa kaldırılıyor. Ben tüm application context yerine daha hızlı olan sadece web contexti ve bunlara bağlı beanleri ayağa kaldıracak şekilde aşağıdaki test sınıfını yazdım.

<script src="https://gist.github.com/mehmetcemyucel/f27a5321efec9371fce5bf7e80b562a2.js"></script>

Bu test sınıfındaki kodu 5 farklı kez çalıştırdım ve ortalama sonlanma süresi olarak **2.186 ms** süresine ulaştım. Bir entegrasyon testi için uzun bir süre. Bu süreyi kısaltmak için neler yapılabilir? Gerçekten de tüm web contexti ayağa kaldırmak zorunda mıyız?

### 2.2. MockMvc Standalone Builder
Önerdiğim yeni yöntemimizde yapacağımız değişiklikler şunlar olacak;
1. Tüm web contexti ayağa kaldırmaktan vazgeç, sadece RestController'ımı kaldır
2. Controller'ımın bağımlı olduğu bean'leri ayağa kaldırma, yerine ben onları mocklayacağım.

Bu değişikliklerle kodumuz aşağıdaki gibi oldu:

<script src="https://gist.github.com/mehmetcemyucel/4cd1ddd05562b916e0c38ceed1eb6dbd.js"></script>

{% include feed-ici-yazi-2.html %}

Bu kodu 5 kez çalıştırdığımda da ortalama çalışma süresi olarak **556 ms** olarak ölçtüm. Neredeyse 4'te biri sürede kodumun çalışırlığını test edebilmiş oldum. Kodlara aşağıdaki adresten erişebilirsiniz.

https://github.com/mehmetcemyucel/springboot-rest-int-test

## 3. Sonuç ve Kütüphaneler

Yazıyı bitirmeden yine de şunları not etmekte fayda var. Bu yazıda kıyasladığım örnekler her bir servis için ayrı ayrı context ayağa kaldırma ile standalone yapılandırma arasındaki farkı içeriyor. Test edeceğiniz servis sayısı ile bağlantılı olmak üzere başka alternatifler de mevcut, örneğin 30 servis için tek context ayağa kaldırıp tüm testleri tek bir context ile tamamladığınızda her defasında mock üretme maliyetine girmediğinizden dolayı total süre daha düşük çıkabilir. Özetle, tek bir doğru yok, senaryoya göre doğru tercih veya tercihler var.

Sonuç olarak testlerimizin hızlı olarak sonuçlanabilmesi için maksimum izolasyon ve minimum bağımlılığı aklımızdan çıkartmamalıyız. Bu ihtiyaçlarınız için kullanabileceğiniz birkaç test frameworkünü de yazarak yazımı sonlandırıyorum.

[Junit](http://junit.org/):  Defacto standart (spring-boot-starter-test'in bir parçası)

[Spring Test](https://docs.spring.io/spring/docs/5.1.5.RELEASE/spring-framework-reference/testing.html#integration-testing):  Boot uygulamaları için utilityler (spring-boot-starter-test'in bir parçası)

[Mockito](http://mockito.org/): Dependency'leri mocklamak için (spring-boot-starter-test'in bir parçası)

[AssertJ](https://joel-costigliola.github.io/assertj/): Akıcı bir dille test yazabilmek için (spring-boot-starter-test'in bir parçası)

[Wiremock](http://wiremock.org/):  Harici bir servisi stublamak için kütüphane

[Hamcrast](http://hamcrest.org/JavaHamcrest/): Matcher objeler için test kütüphanesi (spring-boot-starter-test'in bir parçası)

[Pact](https://docs.pact.io/): Consumer Drivent Contract testleri için kütüphane

[JsonAssert](https://github.com/skyscreamer/JSONassert): JSON için assertion kütüphanesi (spring-boot-starter-test'in bir parçası)

[Selenium](http://docs.seleniumhq.org/):  UI üzerinden end to end testler yazmak için kütüphane

[Rest-assured](https://github.com/rest-assured/rest-assured): Rest apiler üzerinden end to end testler yazmak için kütüphane
