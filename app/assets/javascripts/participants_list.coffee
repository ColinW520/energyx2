$ ->
  if $("#leaderboard_placeholder").length > 0
    $.get
      url: "/participants/list/"
      cache: false
      success: (html) ->
        $('#participants_placeholder').replaceWith html
        return
      error: (xhr, status, errorThrown) ->
        $('#participants_placeholder').replaceWith """<div class="alert alert-dismissible alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button><h4>Whoops!</h4><p>#{error}</p></div>"""
        return
