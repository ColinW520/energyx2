$ ->
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover()

  UnobtrusiveFlash.flashOptions['timeout'] = 5000

  $('#menu-toggle').click (e) ->
    e.preventDefault()
    $('#wrapper').toggleClass 'toggled'

$(document).on 'ajax:error', 'form', (evt, xhr, status) ->
  $('div#error_holder').html '<ul id="errors"></ul>'
  errors = jQuery.parseJSON(xhr.responseText)
  for message of errors
    $('ul#errors').after '''<p style="padding-bottom: 10px; text-decoration: none;" class="text-danger"><i class="fa fa-exclamation-triangle text-danger" style="padding-right: 5px;"></i>''' + errors[message] + '</p><br />'


$(document).on 'turbolinks:load', ->
  members = $('#members')

  members.on 'cocoon:before-insert', (e, el_to_add) ->
    el_to_add.fadeIn(1000)

  members.on 'cocoon:after-insert', (e, added_el) ->
    added_el.effect('highlight', {}, 500)

  members.on 'cocoon:before-remove', (e, el_to_remove) ->
    $(this).data('remove-timeout', 1000)
    el_to_remove.fadeOut(1000)
