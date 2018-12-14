$ ->
  $("input[type='tel']").mask('(000) 000-0000');
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover()

  UnobtrusiveFlash.flashOptions['timeout'] = 15000

  $('#menu-toggle').click (e) ->
    e.preventDefault()
    $('#wrapper').toggleClass 'toggled'

  $('.code_editor').each ->
    console.log 'seeing code editor'
    $(this).froalaEditor
      key: gon.froala_key
      inlineMode: false
      fileUploadToS3:
        bucket: gon.aws_bucket
        region: gon.aws_region
        keyStart: 'uploads/'
        callback: (url, key) ->
          console.log url
          console.log key
        params:
          region: gon.aws_region
          acl: 'public-read'
          AWSAccessKeyId: gon.aws_hash['access_key']
          policy: gon.aws_hash['policy']
          signature: gon.aws_hash['signature']
      imageUploadToS3:
        bucket: gon.aws_bucket
        region: gon.aws_region
        keyStart: 'uploads/'
        callback: (url, key) ->
        params:
          region: gon.aws_region
          acl: 'public-read'
          AWSAccessKeyId: gon.aws_hash['access_key']
          policy: gon.aws_hash['policy']
          signature: gon.aws_hash['signature']

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
