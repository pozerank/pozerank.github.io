---
layout: null
sitemap:
  exclude: 'yes'
---

$(document).ready(function () {
  const nav = $('#site-main-nav')
  const toggle = $('[data-nav-toggle]')
  const closeBtn = $('[data-nav-close]')
  const header = $('.site-header')

  function openNav () {
    nav.addClass('is-open')
    $('body').addClass('nav-open')
    header.addClass('is-nav-open')
  }

  function closeNav () {
    nav.removeClass('is-open')
    $('body').removeClass('nav-open')
    header.removeClass('is-nav-open')
  }

  toggle.on('click', function () {
    if (nav.hasClass('is-open')) {
      closeNav()
    } else {
      openNav()
    }
  })

  closeBtn.on('click', closeNav)

  nav.find('a').on('click', function () {
    closeNav()
  })

  $(document).on('keyup', function (event) {
    if (event.key === 'Escape' && nav.hasClass('is-open')) {
      closeNav()
    }
  })
})
