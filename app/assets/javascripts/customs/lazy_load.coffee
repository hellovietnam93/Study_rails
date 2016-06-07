$(document).on 'page:change', ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next_page a').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 5
        $('.pagination').text(I18n.t('form.buttons.load_more'))
        $.getScript(url)
    $(window).scroll()
