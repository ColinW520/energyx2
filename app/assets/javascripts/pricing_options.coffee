$ ->
  if $("#pricing_options_placeholder").length > 0
    $.get
      url: "/pricing_options/list/"
      cache: false
      success: (html) ->
        $('#pricing_options_placeholder').replaceWith html
        return
      error: (xhr, status, errorThrown) ->
        $('#pricing_options_placeholder').replaceWith """<div class="alert alert-dismissible alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button><h4>Whoops!</h4><p>#{error}</p></div>"""
        return
