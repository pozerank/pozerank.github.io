---
layout: default
title: Abone Ol
permalink: /subscribe/
subscribe_iframe_src: "https://subscribe.mehmetcemyucel.com/embed"
subscribe_iframe_height: 150
subscribe_iframe_title: "Teknoloji Bülteni Abonelik Formu"
subscribe_disclaimer: "Abone listesinden istediğiniz zaman çıkabilirsiniz."
---

{% assign subscribe_iframe_src = page.subscribe_iframe_src | default: site.subscribe.iframe_src %}
{% assign subscribe_iframe_height = page.subscribe_iframe_height | default: site.subscribe.iframe_height | default: 240 %}
{% assign subscribe_iframe_title = page.subscribe_iframe_title | default: site.subscribe.iframe_title | default: 'Abonelik formu' %}
{% assign subscribe_disclaimer = page.subscribe_disclaimer | default: site.subscribe.disclaimer %}

<section class="card-surface subscribe-card">
  <header class="subscribe-card__header">
    <p class="eyebrow">Yazılım Gündemi</p>
    <h2>Haftalık Yazılım, Teknoloji ve AI Haberleri ve Trendleri İçin</h2>
    <p>Abone olarak aramıza katılın. Yeni içeriklerde ve haftalık "Yazılım Gündemi" içeriklerinde anında haberdar olabilirsiniz.</p>
  </header>

  <div class="subscribe-card__form">
    <iframe
      src="{{ subscribe_iframe_src }}"
      width="100%"
      height="{{ subscribe_iframe_height }}"
      title="{{ subscribe_iframe_title }}"
      style="border:0; overflow:hidden; background:transparent"
      loading="lazy"
      referrerpolicy="no-referrer"
      allowtransparency="true"></iframe>
  </div>

  <div class="subscribe-card__details">
    <h3>Ne Bekleyebilirsin?</h3>
    <ul class="subscribe-card__benefits">
      <li>🔍 Haftanın trend teknolojileri ve kısa özetler</li>
      <li>🧠 Seçtiğim makaleler, araç önerileri ve öğrenme kaynakları</li>
      <li>🚀 Yeni içeriklerden, etkinliklerden ve projelerden erken haberdar olma</li>
    </ul>
  </div>

  {% if subscribe_disclaimer %}
  <p class="subscribe-card__disclaimer">{{ subscribe_disclaimer }}</p>
  {% endif %}
</section>
