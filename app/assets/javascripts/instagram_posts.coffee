$ ->
  if $("#instagram_placeholder").length > 0
    $.get
      url: "/instagram"
      cache: false
      success: (html) ->
        $('#instagram_placeholder').replaceWith html
        return
      error: (xhr, status, errorThrown) ->
        $('#instagram_placeholder').replaceWith """<div class="alert alert-dismissible alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button><h4>Whoops!</h4><p>#{error}</p></div>"""
        return
