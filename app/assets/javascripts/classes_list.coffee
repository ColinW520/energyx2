$ ->
  if $("#classes_placeholder").length > 0
    $.get
      url: "/studio_session_types/list/"
      cache: false
      success: (html) ->
        $('#classes_placeholder').replaceWith html
        return
      error: (xhr, status, errorThrown) ->
        $('#classes_placeholder').replaceWith """<div class="alert alert-dismissible alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button><h4>Whoops!</h4><p>#{error}</p></div>"""
        return
